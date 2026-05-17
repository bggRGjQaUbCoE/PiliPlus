import 'package:PiliPlus/services/net_debug_logger.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class NetDebugPage extends StatefulWidget {
  const NetDebugPage({super.key});

  @override
  State<NetDebugPage> createState() => _NetDebugPageState();
}

class _NetDebugPageState extends State<NetDebugPage> {
  late bool _enabled = Pref.enableNetLog;
  String? _tagFilter;
  NetLogLevel? _levelFilter;

  List<NetLogEntry> get _filteredEntries {
    var entries = netLog.entries;
    if (_tagFilter != null) {
      entries = entries.where((e) => e.tag == _tagFilter).toList();
    }
    if (_levelFilter != null) {
      entries = entries.where((e) => e.level == _levelFilter).toList();
    }
    return entries.reversed.toList();
  }

  Set<String> get _allTags => netLog.entries.map((e) => e.tag).toSet();

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final entries = _filteredEntries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('网络调试日志'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () {
                  _enabled = !_enabled;
                  GStorage.setting.put(SettingBoxKey.enableNetLog, _enabled);
                  SmartDialog.showToast(_enabled ? '已开启网络日志' : '已关闭网络日志');
                  setState(() {});
                },
                child: Text(_enabled ? '关闭网络日志' : '开启网络日志'),
              ),
              PopupMenuItem(
                onTap: () {
                  final text = netLog.exportToString();
                  Utils.copyText(text, needToast: false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('已复制到剪贴板'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text('复制全部日志'),
              ),
              PopupMenuItem(
                onTap: () {
                  final file = netLog.logFile;
                  SmartDialog.showToast(
                    file.existsSync()
                        ? '日志文件: ${file.path}'
                        : '暂无日志文件',
                  );
                },
                child: const Text('查看日志文件路径'),
              ),
              PopupMenuItem(
                onTap: () {
                  netLog.clear();
                  setState(() {});
                },
                child: const Text('清空日志'),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(colorScheme),
          if (!_enabled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: colorScheme.errorContainer,
              child: Text(
                '网络日志已关闭，请在菜单中开启',
                style: TextStyle(color: colorScheme.onErrorContainer),
              ),
            ),
          Expanded(
            child: entries.isEmpty
                ? const Center(child: Text('暂无日志'))
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: entries.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 2),
                    itemBuilder: (_, i) => _LogTile(entry: entries[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ColorScheme colorScheme) {
    final tags = _allTags.toList()..sort();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        spacing: 6,
        children: [
          FilterChip(
            label: const Text('ALL'),
            selected: _tagFilter == null,
            onSelected: (_) => setState(() => _tagFilter = null),
          ),
          for (final tag in tags)
            FilterChip(
              label: Text(tag),
              selected: _tagFilter == tag,
              onSelected: (_) => setState(
                () => _tagFilter = _tagFilter == tag ? null : tag,
              ),
            ),
          const VerticalDivider(width: 1),
          for (final level in NetLogLevel.values)
            FilterChip(
              label: Text(level.name.toUpperCase()),
              selected: _levelFilter == level,
              onSelected: (_) => setState(
                () => _levelFilter = _levelFilter == level ? null : level,
              ),
              backgroundColor: _levelColor(level).withValues(alpha: 0.1),
              selectedColor: _levelColor(level).withValues(alpha: 0.3),
            ),
        ],
      ),
    );
  }

  static Color _levelColor(NetLogLevel level) => switch (level) {
    NetLogLevel.info => Colors.blue,
    NetLogLevel.warn => Colors.orange,
    NetLogLevel.error => Colors.red,
  };
}

class _LogTile extends StatelessWidget {
  final NetLogEntry entry;
  const _LogTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final ts = '${entry.time.hour.toString().padLeft(2, '0')}:'
        '${entry.time.minute.toString().padLeft(2, '0')}:'
        '${entry.time.second.toString().padLeft(2, '0')}.'
        '${entry.time.millisecond.toString().padLeft(3, '0')}';

    final color = _NetDebugPageState._levelColor(entry.level);

    return InkWell(
      onTap: () => Utils.copyText(entry.toString(), needToast: false),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 85,
              child: Text(
                ts,
                style: TextStyle(
                  fontFamily: 'Monospace',
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: const BorderRadius.all(Radius.circular(3)),
              ),
              child: Text(
                entry.tag,
                style: TextStyle(
                  fontFamily: 'Monospace',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: entry.message,
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (entry.extra != null)
                      TextSpan(
                        text: '  ${_formatExtra(entry.extra!)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatExtra(Map<String, dynamic> extra) {
    return extra.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${e.value}')
        .join(' ');
  }
}
