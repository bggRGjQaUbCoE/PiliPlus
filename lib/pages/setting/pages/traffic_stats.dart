import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/services/traffic_stats_service.dart';
import 'package:material_ui/material_ui.dart';

class TrafficStatsPage extends StatefulWidget {
  const TrafficStatsPage({super.key});

  @override
  State<TrafficStatsPage> createState() => _TrafficStatsPageState();
}

class _TrafficStatsPageState extends State<TrafficStatsPage> {
  late DateTime start = DateUtils.dateOnly(DateTime.now());
  late DateTime end = start;
  Map<String, dynamic> data = const {};

  static const labels = {
    'wifiBroadband': 'Wi-Fi · 等效宽带',
    'wifiCellular': 'Wi-Fi · 等效移网',
    'wiredBroadband': '有线 · 等效宽带',
    'wiredCellular': '有线 · 等效移网',
    'mobile': '真正蜂窝流量',
    'other': '其他网络',
  };

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final value = await TrafficStatsService.instance.snapshot();
    if (mounted) setState(() => data = value);
  }

  Future<void> _selectRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: DateTimeRange(start: start, end: end),
    );
    if (range != null) {
      setState(() {
        start = DateUtils.dateOnly(range.start);
        end = DateUtils.dateOnly(range.end);
      });
    }
  }

  bool _inRange(String key) {
    final time = DateTime.tryParse('$key:00:00');
    if (time == null) return false;
    return !time.isBefore(start) && time.isBefore(end.add(const Duration(days: 1)));
  }

  Map<String, ({int received, int sent})> _aggregate(
    Iterable<MapEntry<String, dynamic>> entries,
  ) {
    final result = <String, ({int received, int sent})>{};
    for (final entry in entries) {
      final hourly = entry.value as Map;
      for (final item in hourly.entries) {
        final raw = item.value as Map;
        final previous = result[item.key.toString()] ?? (received: 0, sent: 0);
        result[item.key.toString()] = (
          received:
              previous.received + (raw['received'] as num? ?? 0).toInt(),
          sent: previous.sent + (raw['sent'] as num? ?? 0).toInt(),
        );
      }
    }
    return result;
  }

  String _bytes(int value) {
    if (value >= 1000000000) return '${(value / 1000000000).toStringAsFixed(3)} GB';
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(3)} MB';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(3)} kB';
    return '$value B';
  }

  String _date(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.where((entry) => _inRange(entry.key)).toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    final totals = _aggregate(entries);
    final received = totals.values.fold(0, (sum, item) => sum + item.received);
    final sent = totals.values.fold(0, (sum, item) => sum + item.sent);
    return SimpleScaffold(
      appBar: AppBar(
        title: const Text('应用流量统计'),
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: ViewSafeArea(
        child: ListView(
          children: [
            if (!Platform.isAndroid)
              const ListTile(
                title: Text('当前平台暂不提供应用级流量计数'),
                subtitle: Text('Android 使用系统 UID 计数，能够覆盖播放器原生网络流量且无需新增权限。'),
              ),
            ListTile(
              title: const Text('日期范围'),
              subtitle: Text('${_date(start)} 至 ${_date(end)}'),
              trailing: const Icon(Icons.date_range),
              onTap: _selectRange,
            ),
            ListTile(
              title: const Text('范围合计'),
              subtitle: Text('下行 ${_bytes(received)} · 上行 ${_bytes(sent)}'),
            ),
            const Divider(),
            for (final item in totals.entries)
              ListTile(
                title: Text(labels[item.key] ?? item.key),
                subtitle: Text(
                  '下行 ${_bytes(item.value.received)} · 上行 ${_bytes(item.value.sent)}',
                ),
              ),
            const Divider(),
            for (final entry in entries)
              ExpansionTile(
                title: Text(entry.key.replaceFirst('T', '  ')),
                subtitle: Builder(
                  builder: (_) {
                    final value = _aggregate([entry]);
                    final rx = value.values.fold(
                      0,
                      (sum, item) => sum + item.received,
                    );
                    final tx = value.values.fold(0, (sum, item) => sum + item.sent);
                    return Text('下行 ${_bytes(rx)} · 上行 ${_bytes(tx)}');
                  },
                ),
                children: [
                  for (final item in _aggregate([entry]).entries)
                    ListTile(
                      dense: true,
                      title: Text(labels[item.key] ?? item.key),
                      subtitle: Text(
                        '下行 ${_bytes(item.value.received)} · 上行 ${_bytes(item.value.sent)}',
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
