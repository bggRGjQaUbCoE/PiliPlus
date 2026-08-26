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
  static StreamSubscription<List<ConnectivityResult>>? _subscription;
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
      if (connectivity.length == 1 &&
          connectivity.single == ConnectivityResult.none) {
        return _current ?? _fallback;
      }

      final hasWifi = connectivity.contains(ConnectivityResult.wifi);
      final hasEthernet = connectivity.contains(ConnectivityResult.ethernet);
      final windows = Platform.isWindows
          ? WindowsNetworkInfoReader.read()
          : null;
      var wiredActive = hasEthernet && !hasWifi;
      if (Platform.isWindows && hasEthernet && hasWifi) {
        final wired = windows?.wired;
        final wifi = windows?.wifi;
        wiredActive = wired != null &&
            (wifi == null || wired.metric <= wifi.metric);
      }

      if (hasWifi && !wiredActive) {
        final windowsLink = windows?.wifi;
        final android = Platform.isAndroid
            ? PiliAndroidHelper.networkInfo()
            : null;
        final rssi = windows?.rssi ?? android?.rssi;
        final linkSpeed = windowsLink?.minimumSpeedMbps ?? android?.linkSpeed;
        final signalLevel = android?.signalLevel;
        final metered = android?.metered ?? false;
        final weakHint = _bufferingWeak || (android?.weakHint ?? false);

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
          downstreamKbps: android?.downstreamKbps,
          upstreamKbps: android?.upstreamKbps,
          networkType: android?.networkType,
          adapterName: windowsLink?.name,
          adapterDescription: windowsLink?.description,
          receiveLinkSpeedMbps: windowsLink?.receiveSpeedMbps,
          transmitLinkSpeedMbps: windowsLink?.transmitSpeedMbps,
          interfaceMetric: windowsLink?.metric,
          mtu: windowsLink?.mtu,
          metered: metered,
          captivePortal: android?.captivePortal ?? false,
          congested: android?.congested ?? false,
          bandwidthConstrained: android?.bandwidthConstrained ?? false,
          validated: android?.validated ?? false,
          internet: android?.internet ?? false,
          vpn: android?.vpn ?? false,
          roaming: android?.roaming ?? false,
          weakHint: weakHint,
        );
      }

      if (hasEthernet) {
        final windowsLink = windows?.wired;
        final speed = windowsLink?.minimumSpeedMbps;
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
          adapterName: windowsLink?.name,
          adapterDescription: windowsLink?.description,
          receiveLinkSpeedMbps: windowsLink?.receiveSpeedMbps,
          transmitLinkSpeedMbps: windowsLink?.transmitSpeedMbps,
          interfaceMetric: windowsLink?.metric,
          mtu: windowsLink?.mtu,
        );
      }

      if (connectivity.contains(ConnectivityResult.mobile)) {
        final android = Platform.isAndroid
            ? PiliAndroidHelper.networkInfo()
            : null;
        final carrierName = Platform.isAndroid
            ? PiliAndroidHelper.networkOperator()
            : null;
        final subscription = Platform.isAndroid
            ? PiliAndroidHelper.subscriptionInfo()
            : null;
        final flattened = _flattenCellularDetails(subscription);
        final configured = Pref.cellularQualityMatch
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toSet();
        final matched = configured.isNotEmpty &&
            configured.any(flattened.matchValues.contains);

        bool useCellularPreferences = true;
        if (Pref.cellularQualityMode != 0 && matched) {
          final downstream = android?.downstreamKbps;
          final dbm = android?.cellularDbm;
          final level = android?.signalLevel;
          final speedWeak = downstream == null
              ? null
              : downstream < Pref.cellularDownstreamThresholdMbps * 1000;
          final speedGood = downstream == null
              ? null
              : downstream > Pref.cellularDownstreamThresholdMbps * 1000;
          final signalWeak = dbm != null
              ? dbm < Pref.cellularDbmThreshold
              : level == null
              ? null
              : level < Pref.cellularSignalLevelThreshold;
          final signalGood = dbm != null
              ? dbm > Pref.cellularDbmThreshold
              : level == null
              ? null
              : level > Pref.cellularSignalLevelThreshold;
          if (Pref.cellularQualityMode == 1) {
            // 默认按宽带；满足“弱”条件才降为蜂窝策略。
            useCellularPreferences = _matchesCellularQuality(
              signalWeak,
              speedWeak,
            );
          } else {
            // 默认按蜂窝；满足“优”条件才升为宽带策略。
            useCellularPreferences = !_matchesCellularQuality(
              signalGood,
              speedGood,
            );
          }
        }

        return NetworkProfile(
          transport: NetworkTransport.cellular,
          useCellularPreferences: useCellularPreferences,
          signalLevel: android?.signalLevel,
          downstreamKbps: android?.downstreamKbps,
          upstreamKbps: android?.upstreamKbps,
          networkType: android?.networkType,
          carrierName: carrierName,
          cellularDbm: android?.cellularDbm,
          cellularDetails: flattened.details,
          cellularMatchValues: flattened.matchValues.toList(growable: false),
          metered: true,
          captivePortal: android?.captivePortal ?? false,
          congested: android?.congested ?? false,
          bandwidthConstrained: android?.bandwidthConstrained ?? false,
          validated: android?.validated ?? false,
          internet: android?.internet ?? false,
          vpn: android?.vpn ?? false,
          roaming: android?.roaming ?? false,
          weakHint: android?.weakHint ?? false,
        );
      }
      return _current ?? _fallback;
    } catch (_) {
      return _current ?? _fallback;
    }
  }

  static bool _matchesCellularQuality(bool? signal, bool? speed) =>
      switch (Pref.cellularQualityJudgeMode) {
        0 => signal == true,
        1 => speed == true,
        2 => signal == true && speed == true,
        _ => signal == true || speed == true,
      };

  static ({List<String> details, Set<String> matchValues})
  _flattenCellularDetails(Map<String, dynamic>? value) {
    final details = <String>[];
    final matchValues = <String>{};
    void walk(Object? current, String path) {
      if (current is Map) {
        for (final entry in current.entries) {
          walk(
            entry.value,
            path.isEmpty ? entry.key.toString() : '$path.${entry.key}',
          );
        }
        return;
      }
      if (current is List) {
        for (final (index, item) in current.indexed) {
          walk(item, '$path[$index]');
        }
        return;
      }
      if (current == null) return;
      final raw = current.toString();
      if (raw.isEmpty) return;
      final line = '$path=$raw';
      details.add(line);
      // 所有 SubscriptionInfo 都展示，但只有当前默认数据订阅和根级
      // Telephony 字段参与匹配，避免双卡时另一张闲置 SIM 误触发策略。
      if (!path.startsWith('subscriptions[')) {
        matchValues
          ..add(raw)
          ..add(line);
      }
    }

    if (value != null) walk(value, '');
    return (details: details, matchValues: matchValues);
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
