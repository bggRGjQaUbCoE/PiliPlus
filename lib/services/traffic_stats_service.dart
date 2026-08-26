import 'dart:async';
import 'dart:io' show Platform;

import 'package:PiliPlus/models/common/network_profile.dart';
import 'package:PiliPlus/utils/android/android_helper.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/widgets.dart';

final class TrafficStatsService with WidgetsBindingObserver {
  TrafficStatsService._();

  static final instance = TrafficStatsService._();

  Timer? _timer;
  StreamSubscription<NetworkPolicyChange>? _networkSubscription;
  ({int received, int sent})? _last;
  DateTime? _lastAt;
  String? _lastCategory;
  DateTime _lastFlush = DateTime.fromMillisecondsSinceEpoch(0);
  final Map<String, dynamic> _data = {};
  bool _dirty = false;

  Future<void> initialize() async {
    if (!Platform.isAndroid || _timer != null) return;
    if (GStorage.video.get(VideoBoxKey.trafficStats) case final Map raw) {
      _data.addAll(raw.map((key, value) => MapEntry(key.toString(), value)));
    }
    WidgetsBinding.instance.addObserver(this);
    await _sample();
    _networkSubscription = ConnectivityUtils.changes.listen((_) => _sample());
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _sample());
  }

  String _category(NetworkProfile? profile) => switch (profile?.transport) {
    NetworkTransport.wifi => profile!.useCellularPreferences
        ? 'wifiCellular'
        : 'wifiBroadband',
    NetworkTransport.wired => profile!.useCellularPreferences
        ? 'wiredCellular'
        : 'wiredBroadband',
    NetworkTransport.cellular => 'mobile',
    _ => 'other',
  };

  String _hourKey(DateTime time) =>
      '${time.year.toString().padLeft(4, '0')}-'
      '${time.month.toString().padLeft(2, '0')}-'
      '${time.day.toString().padLeft(2, '0')}T'
      '${time.hour.toString().padLeft(2, '0')}';

  Future<void> _sample() async {
    final current = PiliAndroidHelper.trafficStats();
    if (current == null) return;
    final now = DateTime.now();
    final previous = _last;
    if (previous != null && _lastAt != null && _lastCategory != null) {
      final received = current.received >= previous.received
          ? current.received - previous.received
          : 0;
      final sent = current.sent >= previous.sent ? current.sent - previous.sent : 0;
      if (received != 0 || sent != 0) {
        final hour = _hourKey(_lastAt!);
        final hourly = Map<String, dynamic>.from(
          _data[hour] as Map? ?? const {},
        );
        final category = Map<String, dynamic>.from(
          hourly[_lastCategory] as Map? ?? const {},
        );
        category
          ..['received'] = (category['received'] as num? ?? 0).toInt() + received
          ..['sent'] = (category['sent'] as num? ?? 0).toInt() + sent;
        hourly[_lastCategory!] = category;
        _data[hour] = hourly;
        _dirty = true;
      }
    }
    _last = current;
    _lastAt = now;
    _lastCategory = _category(ConnectivityUtils.current);
    if (_dirty && now.difference(_lastFlush) >= const Duration(seconds: 30)) {
      await flush();
    }
  }

  Future<void> flush() async {
    if (!_dirty) return;
    _dirty = false;
    _lastFlush = DateTime.now();
    await GStorage.video.put(VideoBoxKey.trafficStats, Map.of(_data));
  }

  Future<Map<String, dynamic>> snapshot() async {
    if (Platform.isAndroid) await _sample();
    return {
      for (final entry in _data.entries)
        entry.key: Map<String, dynamic>.from(entry.value as Map),
    };
  }

  Future<({int day, int week, int month})> currentPeriodUsage() async {
    final data = await snapshot();
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final weekStart = dayStart.subtract(Duration(days: dayStart.weekday - 1));
    final monthStart = DateTime(now.year, now.month);
    var day = 0;
    var week = 0;
    var month = 0;
    for (final entry in data.entries) {
      final time = DateTime.tryParse('${entry.key}:00:00');
      if (time == null) continue;
      var total = 0;
      final hourly = entry.value as Map;
      for (final category in hourly.values.whereType<Map>()) {
        total += (category['received'] as num? ?? 0).toInt();
        total += (category['sent'] as num? ?? 0).toInt();
      }
      if (!time.isBefore(monthStart)) month += total;
      if (!time.isBefore(weekStart)) week += total;
      if (!time.isBefore(dayStart)) day += total;
    }
    return (day: day, week: week, month: month);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _sample().then((_) => flush());
    }
  }

  Future<void> dispose() async {
    _timer?.cancel();
    _timer = null;
    await _networkSubscription?.cancel();
    _networkSubscription = null;
    WidgetsBinding.instance.removeObserver(this);
    await flush();
  }
}
