import 'dart:convert';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<Report> logsContent = [];
  Report? latestLog;
  late bool enableLog = Pref.enableLog;

  @override
  void initState() {
    getLog();
    super.initState();
  }

  @override
  void dispose() {
    if (latestLog != null) {
      final time = latestLog!.dateTime;
      if (DateTime.now().difference(time) >= const Duration(days: 14)) {
        LoggerUtils.clearLogs();
      }
    }
    super.dispose();
  }

  Future<void> getLog() async {
    final logsPath = await LoggerUtils.getLogsPath();
    logsContent = (await logsPath.readAsLines()).reversed.map((i) {
      try {
        final log = _parseReportJson(jsonDecode(i));
        latestLog ??= log;
        return log;
      } catch (e, s) {
        return Report(
          'Parse log failed: $e\n\n\n$i',
          s,
          DateTime.now(),
          const {},
          const {},
          const {},
          null,
          PlatformType.unknown,
          null,
        );
      }
    }).toList();
    setState(() {});
  }

  void copyLogs() {
    Utils.copyText(jsonEncode(logsContent), needToast: false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('复制成功')),
      );
    }
  }

  Future<void> clearLogsHandle() async {
    if (await LoggerUtils.clearLogs()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已清空')),
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
          PopupMenuButton<String>(
            onSelected: (String type) {
              switch (type) {
                case 'log':
                  enableLog = !enableLog;
                  GStorage.setting.put(SettingBoxKey.enableLog, enableLog);
                  SmartDialog.showToast('已${enableLog ? '开启' : '关闭'}，重启生效');
                  break;
                case 'copy':
                  copyLogs();
                  break;
                case 'feedback':
                  PageUtils.launchURL('${Constants.sourceCodeUrl}/issues');
                  break;
                case 'clear':
                  clearLogsHandle();
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'log',
                child: Text('${enableLog ? '关闭' : '开启'}日志'),
              ),
              const PopupMenuItem<String>(
                value: 'copy',
                child: Text('复制日志'),
              ),
              const PopupMenuItem<String>(
                value: 'feedback',
                child: Text('错误反馈'),
              ),
              const PopupMenuItem<String>(
                value: 'clear',
                child: Text('清空日志'),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: logsContent.isNotEmpty
          ? CustomScrollView(
              slivers: [
                if (latestLog != null)
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: padding.left + 16,
                      right: padding.right + 16,
                    ),
                    sliver: SliverList.list(
                      children: [
                        InfoCard(report: latestLog!),
                        _divider,
                      ],
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: padding.left + 16,
                    right: padding.right + 16,
                    bottom: padding.bottom + 100,
                  ),
                  sliver: SliverList.separated(
                    itemCount: logsContent.length,
                    itemBuilder: (context, index) =>
                        ReportCard(report: logsContent[index]),
                    separatorBuilder: (_, _) => _divider,
                  ),
                ),
              ],
            )
          : scrollErrorWidget(),
    );
  }
}

class InfoCard extends StatefulWidget {
  final Report report;

  const InfoCard({super.key, required this.report});

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  bool _isExpanded = false;

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
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 8),
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
            size: 24,
            color: colorScheme.primary,
          ),
          const Expanded(
            child: Text(
              '相关信息',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            icon: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ],
      ),
      if (_isExpanded) ...[
        const SizedBox(height: 16),
        _buildMapSection(
          colorScheme.primary,
          '设备信息',
          widget.report.deviceParameters,
        ),
        _buildMapSection(
          colorScheme.primary,
          '应用信息',
          widget.report.applicationParameters,
        ),
        _buildMapSection(
          colorScheme.primary,
          '编译信息',
          widget.report.customParameters,
        ),
      ],
    ]);
  }
}

class ReportCard extends StatefulWidget {
  final Report report;

  const ReportCard({super.key, required this.report});

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final log = widget.report;
    final colorScheme = ColorScheme.of(context);
    late final stackTrace = log.stackTrace.toString();

    return _card([
      Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              log.error.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () {
              Utils.copyText(
                Utils.jsonEncoder.convert(log.toJson()),
                needToast: false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已将 ${log.dateTime} 复制至剪贴板')),
              );
            },
            icon: const Icon(
              Icons.copy_outlined,
              size: 16,
            ),
            label: const Text('复制'),
          ),
          IconButton(
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            icon: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Icon(Icons.access_time, size: 16),
          Text(
            log.dateTime.toString(),
            style: const TextStyle(height: 1.2),
          ),
        ],
      ),
      if (_isExpanded) ...[
        const SizedBox(height: 16),
        _divider,
        const SizedBox(height: 16),

        Text(
          '错误详情:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.error,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outline),
          ),
          child: SelectableText(
            log.error.toString(),
            style: TextStyle(
              fontFamily: 'Monospace',
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // stackTrace may be null or String("null") or blank
        if (stackTrace.trim().isNotEmpty && stackTrace != 'null') ...[
          Text(
            '堆栈跟踪:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.error,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outline),
            ),
            child: SelectableText(
              log.stackTrace.toString(),
              style: TextStyle(
                fontFamily: 'Monospace',
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    ]);
  }
}

const Widget _divider = Divider(indent: 12, endIndent: 12, height: 24);

Widget _card(List<Widget> contents) {
  return Card(
    margin: const EdgeInsets.all(8),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: contents,
      ),
    ),
  );
}

Report _parseReportJson(Map<String, dynamic> json) => Report(
  json['error'],
  json['stackTrace'],
  DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime(1970),
  json['deviceParameters'] ?? const {},
  json['applicationParameters'] ?? const {},
  json['customParameters'] ?? const {},
  null,
  PlatformType.values.byName(json['platformType']),
  null,
);
