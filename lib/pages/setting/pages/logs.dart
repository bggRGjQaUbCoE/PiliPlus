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
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SelectableText(_getDeviceString(latestLog!)),
                          ),
                        ),
                        const Divider(
                          indent: 12,
                          endIndent: 12,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: padding.left,
                    right: padding.right,
                    bottom: padding.bottom + 100,
                  ),
                  sliver: SliverList.separated(
                    itemCount: logsContent.length,
                    itemBuilder: (context, index) {
                      final log = logsContent[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 5,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                Text(
                                  log.dateTime.toString(),
                                  style: TextStyle(
                                    fontSize: Theme.of(
                                      context,
                                    ).textTheme.titleMedium!.fontSize,
                                  ),
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () {
                                    Utils.copyText(
                                      Utils.jsonEncoder.convert(log.toJson()),
                                      needToast: false,
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '已将 ${log.dateTime} 复制至剪贴板',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.copy_outlined,
                                    size: 16,
                                  ),
                                  label: const Text('复制'),
                                ),
                              ],
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SelectableText(
                                  '---------- 错误信息 ----------\n${log.error}\n\n---------- 错误堆栈 ----------\n${log.stackTrace}',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      indent: 12,
                      endIndent: 12,
                      height: 24,
                    ),
                  ),
                ),
              ],
            )
          : scrollErrorWidget(),
    );
  }
}

String _getDeviceString(Report report) {
  final sb = StringBuffer()
    ..writeln('---------- 设备信息 ----------')
    ..writeMapln(report.deviceParameters)
    ..writeln('---------- 应用信息 ----------')
    ..writeMapln(report.applicationParameters)
    ..writeln('---------- 编译信息 ----------')
    ..writeMapln(report.customParameters);
  return sb.toString();
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

extension on StringBuffer {
  void writeMapln(Map map) {
    map.forEach((k, v) => writeln('$k: $v'));
  }
}
