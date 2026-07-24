import 'dart:async' show Timer;
import 'dart:convert' show jsonDecode;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/selection_text.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:catcher_2/utils/log_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

const _snackBarDisplayDuration = Duration(seconds: 1);

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<_ExpandedItem<Report>> logsContent = [];
  _ExpandedItem<_DeviceInfo>? _deviceInfo;
  late bool enableLog = Pref.enableLog;

  @override
  void initState() {
    _initDeviceInfo();
    getLog();
    super.initState();
  }

  void _initDeviceInfo() {
    if (Catcher2.instance case final c?) {
      _deviceInfo = _ExpandedItem((
        c.deviceParameters,
        c.applicationParameters,
        c.customParameters,
      ));
    }
  }

  Future<void> getLog() async {
    final logsPath = await LoggerUtils.getLogsPath();
    logsContent = (await logsPath.readAsLines()).reversed.map((i) {
      try {
        final log = Report.fromJson(jsonDecode(i));
        return _ExpandedItem(log);
      } catch (e, s) {
        return _ExpandedItem(
          Report(
            'Parse log failed: $e\n\n\n$i',
            s,
            DateTime.now(),
            const {},
            const {},
            const {},
            null,
          ),
        );
      }
    }).toList();
    if (mounted) {
      setState(() {});
    }
  }

  void copyLogs() {
    Utils.copyText(
      '```\n${logsContent.join('\n\n')}```',
      needToast: false,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('复制成功'),
          duration: _snackBarDisplayDuration,
        ),
      );
    }
  }

  Future<void> clearLogs() async {
    if (await LoggerUtils.clearLogs()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已清空'),
            duration: _snackBarDisplayDuration,
          ),
        );
        logsContent.clear();
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('日志'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              if (kDebugMode)
                PopupMenuItem(
                  onTap: () => Timer.periodic(
                    const Duration(milliseconds: 3500),
                    (timer) {
                      Utils.reportError('Manual', StackTrace.current);
                      if (timer.tick > 3) {
                        timer.cancel();
                        if (mounted) getLog();
                      }
                    },
                  ),
                  child: const Text('引发错误'),
                ),
              PopupMenuItem(
                onTap: () {
                  enableLog = !enableLog;
                  GStorage.setting.put(SettingBoxKey.enableLog, enableLog);
                  SmartDialog.showToast('已${enableLog ? '开启' : '关闭'}，重启生效');
                },
                child: Text('${enableLog ? '关闭' : '开启'}日志'),
              ),
              PopupMenuItem(
                onTap: copyLogs,
                child: const Text('复制日志'),
              ),
              PopupMenuItem(
                onTap: () =>
                    PageUtils.launchURL('${Constants.sourceCodeUrl}/issues'),
                child: const Text('错误反馈'),
              ),
              PopupMenuItem(
                onTap: clearLogs,
                child: const Text('清空日志'),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: logsContent.isNotEmpty || _deviceInfo != null
          ? Padding(
              padding: EdgeInsets.only(
                left: padding.left + 12,
                right: padding.right + 12,
              ),
              child: CustomScrollView(
                slivers: [
                  if (_deviceInfo != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const .only(bottom: 12),
                        child: _InfoCard(info: _deviceInfo!),
                      ),
                    ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: padding.bottom + 100),
                    sliver: SliverList.separated(
                      itemCount: logsContent.length,
                      itemBuilder: (context, index) =>
                          _ReportCard(report: logsContent[index]),
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                    ),
                  ),
                ],
              ),
            )
          : scrollableError,
    );
  }
}

typedef _DeviceInfo = (
  Map<String, dynamic>,
  Map<String, dynamic>,
  Map<String, dynamic>,
);

class _InfoCard extends StatelessWidget {
  final _ExpandedItem<_DeviceInfo> info;

  const _InfoCard({required this.info});

  Widget _buildMapSection(
    Color color,
    String title,
    Map<String, dynamic> map,
  ) {
    if (map.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontWeight: .bold, color: color, fontSize: 15),
        ),
        ...map.entries.map(
          (entry) => Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '• ${entry.key}: ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: entry.value.toString(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return _card([
      Row(
        spacing: 8,
        children: [
          Icon(
            Icons.info_outline,
            size: 22,
            color: colorScheme.primary,
          ),
          const Expanded(
            child: Text(
              '相关信息',
              style: TextStyle(fontWeight: .bold, fontSize: 15),
              maxLines: 1,
              overflow: .ellipsis,
            ),
          ),
          iconButton(
            size: 34,
            iconSize: 22,
            tooltip: info.isExpanded ? '收起' : '展开',
            icon: Icon(
              info.isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onPressed: () {
              info.isExpanded = !info.isExpanded;
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      if (info.isExpanded) ...[
        _buildMapSection(colorScheme.primary, '设备信息', info.item.$1),
        _buildMapSection(colorScheme.primary, '应用信息', info.item.$2),
        _buildMapSection(colorScheme.primary, '编译信息', info.item.$3),
      ],
    ]);
  }
}

class _ReportCard extends StatelessWidget {
  final _ExpandedItem<Report> report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    late final stackTrace = PrettyLogPrinter.formatStackString(
      report.item.stackTrace?.toString(),
      -1,
    );
    final dateTime = DateFormatUtils.longFormatDs.format(report.item.dateTime);
    return _card([
      Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: Column(
              spacing: 6,
              crossAxisAlignment: .start,
              children: [
                Text(
                  report.item.error.toString(),
                  style: const TextStyle(fontWeight: .bold, fontSize: 15),
                  maxLines: 2,
                  overflow: .ellipsis,
                ),
                Text(
                  dateTime,
                  style: TextStyle(
                    height: 1.2,
                    color: colorScheme.outline,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          iconButton(
            size: 34,
            iconSize: 22,
            tooltip: '复制',
            onPressed: () {
              Utils.copyText('```\n$report```', needToast: false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('已将 $dateTime 复制至剪贴板'),
                  duration: _snackBarDisplayDuration,
                ),
              );
            },
            icon: const Icon(Icons.copy_outlined, size: 16),
          ),
          iconButton(
            size: 34,
            iconSize: 22,
            tooltip: report.isExpanded ? '收起' : '展开',
            icon: Icon(
              report.isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onPressed: () {
              report.isExpanded = !report.isExpanded;
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      if (report.isExpanded) ...[
        const SizedBox(height: 16),
        Text(
          '错误详情',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.error,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const .all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const .all(.circular(8)),
            border: .all(color: colorScheme.outline.withValues(alpha: 0.5)),
          ),
          child: SelectionText(
            report.item.error.toString(),
            style: TextStyle(
              fontFamily: 'Monospace',
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        // stackTrace may be null or String("null") or blank
        if (stackTrace != null && stackTrace.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '堆栈跟踪',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.error,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const .all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const .all(.circular(8)),
              border: .all(color: colorScheme.outline.withValues(alpha: 0.5)),
            ),
            child: SelectionText.rich(
              TextSpan(
                children: stackTrace
                    .map(
                      (i) => TextSpan(
                        text: '$i\n',
                        style: i.contains('(package:${Constants.appName}')
                            ? TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: .w600,
                              )
                            : TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    )
                    .toList(),
              ),
              style: const TextStyle(fontFamily: 'Monospace', fontSize: 13),
            ),
          ),
        ],
      ],
    ]);
  }
}

Widget _card(List<Widget> contents) {
  return Card(
    child: Padding(
      padding: const .all(12),
      child: Column(
        crossAxisAlignment: .stretch,
        children: contents,
      ),
    ),
  );
}

class _ExpandedItem<T> {
  bool isExpanded = false;
  final T item;

  _ExpandedItem(this.item);

  @override
  String toString() => item.toString();
}
