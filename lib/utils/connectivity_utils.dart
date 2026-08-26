import 'dart:async';
import 'dart:io' show Platform;

import 'package:PiliPlus/models/common/network_profile.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/utils/android/android_helper.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/windows/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract final class ConnectivityUtils {
  static final _changes = StreamController<NetworkPolicyChange>.broadcast(
    sync: true,
  );
  static Stream<NetworkPolicyChange> get changes => _changes.stream;

  // App-lifetime observer; ConnectivityUtils lives for the whole process.
  // ignore: cancel_subscriptions
  static StreamSubscription<ConnectivityResult>? _subscription;
  static Timer? _networkDebounce;
  static Timer? _peakTimer;
  static NetworkProfile? _current;
  static bool _bufferingWeak = false;
  static bool _peakActive = false;

  static NetworkProfile? get current => _current;

  static Future<void> initialize() async {
    if (_subscription != null) return;
    _current = await _sample();
    _peakActive = isNetworkPeak(_current!);
    _schedulePeakBoundary();
    _subscription = Connectivity().onConnectivityChanged.skip(1).listen((_) {
      _networkDebounce?.cancel();
      _networkDebounce = Timer(const Duration(milliseconds: 800), () {
        _bufferingWeak = false;
        _refresh();
      });
    });
  }

  static Future<NetworkProfile> resolveForPlayback() async {
    if (_subscription == null) await initialize();
    return _refresh();
  }

  static Future<bool> get isWiFi async =>
      !(await resolveForPlayback()).useCellularPreferences;

  static Future<NetworkProfile> _refresh({
    bool forcePeakRefresh = false,
  }) async {
    final next = await _sample();
    final previous = _current;
    final peak = isNetworkPeak(next);
    final peakChanged = peak != _peakActive;
    _current = next;
    _peakActive = peak;
    if (previous != null && previous.identity != next.identity) {
      _changes.add(NetworkPolicyChange(next, NetworkPolicyReason.network));
    } else if (peakChanged || forcePeakRefresh && peak) {
      _changes.add(NetworkPolicyChange(next, NetworkPolicyReason.peak));
    }
    _schedulePeakBoundary();
    return next;
  }

  static Future<void> notifySettingsChanged() async {
    if (_subscription == null) await initialize();
    await _refresh(forcePeakRefresh: true);
  }

  static void markCurrentWifiWeak() {
    if (!Platform.isAndroid ||
        _current?.transport != NetworkTransport.wifi ||
        !Pref.wifiNetworkPolicy ||
        Pref.wifiRssiThreshold != 0 ||
        _bufferingWeak) {
      return;
    }
    _bufferingWeak = true;
    _refresh();
  }

  static List<VideoDecodeFormatType> effectiveCodecs(
    List<VideoDecodeFormatType> base,
    NetworkProfile profile,
  ) {
    if (!isNetworkPeak(profile)) return List.of(base);
    final peak = Pref.networkPeakCodecs;
    return List.of(peak.isEmpty ? Pref.preferCodecsCellular : peak);
  }

  static bool isNetworkPeak(NetworkProfile profile, [DateTime? now]) {
    final time = now ?? DateTime.now();
    final currentMinute = time.hour * 60 + time.minute;
    for (final period in Pref.networkPeakPeriods) {
      if (period['enabled'] != true) continue;
      final start = period['start'] as int?;
      final end = period['end'] as int?;
      if (start == null || end == null) continue;
      final inPeriod = start == end
          ? true
          : start < end
          ? currentMinute >= start && currentMinute < end
          : currentMinute >= start || currentMinute < end;
      if (inPeriod &&
          (period['scope'] == 1 || !profile.useCellularPreferences)) {
        return true;
      }
    }
    return false;
  }

  static void _schedulePeakBoundary() {
    _peakTimer?.cancel();
    final now = DateTime.now();
    DateTime? next;
    for (final period in Pref.networkPeakPeriods) {
      if (period['enabled'] != true) continue;
      for (final value in [period['start'], period['end']]) {
        if (value is! int) continue;
        var candidate = DateTime(
          now.year,
          now.month,
          now.day,
          value ~/ 60,
          value % 60,
        );
        if (!candidate.isAfter(now)) {
          candidate = candidate.add(const Duration(days: 1));
        }
        if (next == null || candidate.isBefore(next)) next = candidate;
      }
    }
    if (next != null) {
      _peakTimer = Timer(
        next.difference(now) + const Duration(milliseconds: 50),
        () {
          final profile = _current;
          if (profile != null) {
            final active = isNetworkPeak(profile);
            if (active != _peakActive) {
              _peakActive = active;
              _changes.add(
                NetworkPolicyChange(profile, NetworkPolicyReason.peak),
              );
            }
          }
          _schedulePeakBoundary();
        },
      );
    }
  }

  static Future<NetworkProfile> _sample() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return _current ?? _fallback;
      }

      if (connectivity == ConnectivityResult.wifi) {
        int? rssi;
        int? linkSpeed;
        int? signalLevel;
        var metered = false;
        var weakHint = _bufferingWeak;
        if (Platform.isWindows) {
          final info = WindowsNetworkInfoReader.read();
          rssi = info.rssi;
          linkSpeed = info.wifiMbps;
        } else if (Platform.isAndroid) {
          final info = PiliAndroidHelper.networkInfo();
          rssi = info?.rssi;
          linkSpeed = info?.linkSpeed;
          signalLevel = info?.signalLevel;
          metered = info?.metered ?? false;
          weakHint = weakHint || (info?.weakHint ?? false);
        }

        final signalWeak = Platform.isAndroid && Pref.wifiRssiThreshold == 0
            ? (signalLevel != null && signalLevel < 3) || weakHint
            : rssi != null && rssi < Pref.wifiRssiThreshold;
        final speedWeak =
            linkSpeed != null && linkSpeed < Pref.wifiMinLinkSpeed;
        final wifiWeak =
            Pref.wifiNetworkPolicy &&
            switch (Pref.wifiNetworkPolicyMode) {
              0 => signalWeak,
              1 => speedWeak,
              2 => signalWeak && speedWeak,
              _ => signalWeak || speedWeak,
            };
        return NetworkProfile(
          transport: NetworkTransport.wifi,
          useCellularPreferences: metered || wifiWeak,
          rssi: rssi,
          linkSpeedMbps: linkSpeed,
          signalLevel: signalLevel,
          metered: metered,
          weakHint: weakHint,
        );
      }

      if (connectivity == ConnectivityResult.ethernet) {
        final speed = Platform.isWindows
            ? WindowsNetworkInfoReader.read().wiredMbps
            : null;
        final isNonstandard = speed != null && !_isStandardWiredSpeed(speed);
        final wiredWeak =
            Pref.wiredNetworkPolicy &&
            speed != null &&
            (speed < Pref.wiredMinLinkSpeed ||
                Pref.wiredNonstandardLinkSpeed && isNonstandard);
        return NetworkProfile(
          transport: NetworkTransport.wired,
          useCellularPreferences: wiredWeak,
          linkSpeedMbps: speed,
        );
      }

      if (connectivity == ConnectivityResult.mobile) {
        return const NetworkProfile(
          transport: NetworkTransport.cellular,
          useCellularPreferences: true,
          metered: true,
        );
      }
      return _current ?? _fallback;
    } catch (_) {
      return _current ?? _fallback;
    }
  }

  static bool _isStandardWiredSpeed(int speed) => _standardWiredSpeeds.any(
    (standard) => (speed - standard).abs() <= standard * 0.035,
  );

  // Nominal Ethernet MAC rates from 1BASE5 through 800GbE (and emerging
  // 1.6TbE), plus legacy and current PON optical line rates. The tolerance
  // also covers 1.244/2.488/9.953/10.3125G and similar reported values.
  static const _standardWiredSpeeds = {
    1,
    10,
    100,
    155,
    622,
    1000,
    1250,
    2500,
    5000,
    10000,
    25000,
    40000,
    50000,
    100000,
    200000,
    400000,
    800000,
    1600000,
  };

  static const _fallback = NetworkProfile(
    transport: NetworkTransport.other,
    useCellularPreferences: false,
  );
}
