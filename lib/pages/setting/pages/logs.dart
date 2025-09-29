import 'dart:io';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

typedef _LogInfo = ({Object? date, String body});

class _LogsPageState extends State<LogsPage> {
  late File logsPath;
  late String fileContent;
  List<_LogInfo> logsContent = [];
  DateTime? latestLog;
  late bool enableLog = Pref.enableLog;

  @override
  void initState() {
    getLog();
    super.initState();
  }

  @override
  void dispose() {
    if (latestLog != null) {
      if (DateTime.now().difference(latestLog!) >= const Duration(days: 14)) {
        LoggerUtils.clearLogs();
      }
    }
    super.dispose();
  }

  Future<void> getLog() async {
    logsPath = await LoggerUtils.getLogsPath();
    fileContent = await logsPath.readAsString();
    logsContent = parseLogs(fileContent);
    setState(() {});
  }

  List<_LogInfo> parseLogs(String fileContent) {
    const String splitToken =
        '======================================================================';
    List contentList = fileContent.split(splitToken).map((item) {
      return item
          .replaceAll(
            '============================== CATCHER 2 LOG ==============================',
            '${Constants.appName}错误日志\n********************',
          )
          .replaceAll('DEVICE INFO', '设备信息')
          .replaceAll('APP INFO', '应用信息')
          .replaceAll('ERROR', '错误信息')
          .replaceAll('STACK TRACE', '错误堆栈');
    }).toList();
    List<_LogInfo> result = [];
    for (String i in contentList) {
      Object? date;
      String body = i
          .split("\n")
          .map((l) {
            if (l.startsWith("Crash occurred on")) {
              try {
                date = DateTime.parse(
                  l.split("Crash occurred on")[1].trim(),
                );
              } catch (e) {
                if (kDebugMode) debugPrint(e.toString());
                date = l.toString();
              }
              return "";
            }
            return l;
          })
          .where((l) => l.replaceAll("\n", "").trim().isNotEmpty)
          .join("\n");
      if (date != null || body != '') {
        result.add((date: date, body: body));
      }
    }
    return result.reversed.toList();
  }

  void copyLogs() {
    Utils.copyText('```\n$fileContent\n```', needToast: false);
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
          ? ListView.separated(
              padding: EdgeInsets.only(
                left: padding.left,
                right: padding.right,
                bottom: padding.bottom + 100,
              ),
              itemCount: logsContent.length,
              itemBuilder: (context, index) {
                final log = logsContent[index];
                if (log.date case DateTime date) {
                  latestLog ??= date;
                }
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
                            log.date.toString(),
                            style: TextStyle(
                              fontSize: Theme.of(
                                context,
                              ).textTheme.titleMedium!.fontSize,
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () {
                              Utils.copyText(
                                '```\n${log.body}\n```',
                                needToast: false,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '已将 ${log.date} 复制至剪贴板',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.copy_outlined, size: 16),
                            label: const Text('复制'),
                          ),
                        ],
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SelectableText(log.body),
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
            )
          : scrollErrorWidget(),
    );
  }
}
