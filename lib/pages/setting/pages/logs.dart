import 'dart:async';
import 'dart:convert';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:flutter/foundation.dart';
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
        final log = Report.fromJson(jsonDecode(i));
        latestLog ??= log.copyWith();
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
                  if (kDebugMode) {
                    Timer.periodic(const Duration(milliseconds: 3500), (timer) {
                      Utils.reportError('Manual');
                      if (timer.tick > 3) {
                        timer.cancel();
                        if (mounted) getLog();
                      }
                    });
                  }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              if (kDebugMode)
                const PopupMenuItem<String>(
                  value: 'assert',
                  child: Text('引发错误'),
                ),
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
          ? Padding(
              padding: EdgeInsets.only(
                left: padding.left + 12,
                right: padding.right + 12,
              ),
              child: CustomScrollView(
                slivers: [
                  if (latestLog != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const .only(bottom: 12),
                        child: InfoCard(report: latestLog!),
                      ),
                    ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: padding.bottom + 100),
                    sliver: SliverList.separated(
                      itemCount: logsContent.length,
                      itemBuilder: (context, index) =>
                          ReportCard(report: logsContent[index]),
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                    ),
                  ),
                ],
              ),
            )
          : scrollErrorWidget(),
    );
  }
}

class InfoCard extends StatelessWidget {
  final Report report;

  const InfoCard({super.key, required this.report});

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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
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
        _buildMapSection(
          colorScheme.primary,
          '设备信息',
          report.deviceParameters,
        ),
        _buildMapSection(
          colorScheme.primary,
          '应用信息',
          report.applicationParameters,
        ),
        _buildMapSection(
          colorScheme.primary,
          '编译信息',
          report.customParameters,
        ),
      ],
    ]);
  }
}

class ReportCard extends StatelessWidget {
  final Report report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    late final stackTrace = report.stackTrace.toString().trim();
    final dateTime = DateFormatUtils.longFormatDs.format(report.dateTime);
    return _card([
      Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              report.error.toString(),
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
              foregroundColor: colorScheme.secondary,
            ),
            onPressed: () {
              Utils.copyText('```\n$report```', needToast: false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已将 $dateTime 复制至剪贴板')),
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
              report.isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onPressed: () {
              report.isExpanded = !report.isExpanded;
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        spacing: 4,
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color: colorScheme.outline,
          ),
          Text(
            dateTime,
            style: TextStyle(
              height: 1.2,
              color: colorScheme.outline,
            ),
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
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
          child: SelectableText(
            report.error.toString(),
            style: TextStyle(
              fontFamily: 'Monospace',
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        // stackTrace may be null or String("null") or blank
        if (stackTrace.isNotEmpty && stackTrace != 'null') ...[
          const SizedBox(height: 16),
          Text(
            '堆栈跟踪',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.error,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            child: SelectableText(
              stackTrace,
              style: TextStyle(
                fontFamily: 'Monospace',
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
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

class Report {
  Report(
    this.error,
    this.stackTrace,
    this.dateTime,
    this.deviceParameters,
    this.applicationParameters,
    this.customParameters,
    this.errorDetails,
    this.platformType,
  );

  final dynamic error;

  final dynamic stackTrace;

  final DateTime dateTime;

  final Map<String, dynamic> deviceParameters;

  final Map<String, dynamic> applicationParameters;

  final Map<String, dynamic> customParameters;

  final FlutterErrorDetails? errorDetails;

  final PlatformType platformType;

  bool isExpanded = false;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    json['error'],
    json['stackTrace'],
    DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime(1970),
    json['deviceParameters'] ?? const {},
    json['applicationParameters'] ?? const {},
    json['customParameters'] ?? const {},
    null,
    PlatformType.values.byName(json['platformType']),
  );

  Report copyWith({
    dynamic error,
    dynamic stackTrace,
    DateTime? dateTime,
    Map<String, dynamic>? deviceParameters,
    Map<String, dynamic>? applicationParameters,
    Map<String, dynamic>? customParameters,
    FlutterErrorDetails? errorDetails,
    PlatformType? platformType,
  }) {
    return Report(
      error ?? this.error,
      stackTrace ?? this.stackTrace,
      dateTime ?? this.dateTime,
      deviceParameters ?? this.deviceParameters,
      applicationParameters ?? this.applicationParameters,
      customParameters ?? this.customParameters,
      errorDetails ?? this.errorDetails,
      platformType ?? this.platformType,
    );
  }

  String _params2String(Map<String, dynamic> params) {
    return params.entries
        .map((entry) => '${entry.key}: ${entry.value}\n')
        .join();
  }

  @override
  String toString() {
    return '------- DEVICE INFO -------\n${_params2String(deviceParameters)}'
        '------- APP INFO -------\n${_params2String(applicationParameters)}'
        '------- ERROR -------\n$error\n'
        '------- STACK TRACE -------\n${stackTrace.toString().trim()}\n'
        '------- CUSTOM INFO -------\n${_params2String(customParameters)}';
  }
}
