import 'dart:io';

import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/services/loggeer.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  late File logsPath;
  late String fileContent;
  List logsContent = [];
  DateTime? latestLog;

  @override
  void initState() {
    getPath();
    super.initState();
  }

  @override
  void dispose() {
    if (latestLog != null) {
      if (DateTime.now().difference(latestLog!) >= const Duration(days: 14)) {
        clearLogs();
      }
    }
    super.dispose();
  }

  Future<void> getPath() async {
    logsPath = await getLogsPath();
    fileContent = await logsPath.readAsString();
    logsContent = parseLogs(fileContent);
    setState(() {});
  }

  List<Map<String, dynamic>> parseLogs(String fileContent) {
    const String splitToken =
        '======================================================================';
    List contentList = fileContent.split(splitToken).map((item) {
      return item
          .replaceAll(
              '============================== CATCHER 2 LOG ==============================',
              'PiliPlus错误日志\n********************')
          .replaceAll('DEVICE INFO', '设备信息')
          .replaceAll('APP INFO', '应用信息')
          .replaceAll('ERROR', '错误信息')
          .replaceAll('STACK TRACE', '错误堆栈');
    }).toList();
    List<Map<String, dynamic>> result = [];
    for (String i in contentList) {
      dynamic date;
      String body = i
          .split("\n")
          .map((l) {
            if (l.startsWith("Crash occurred on")) {
              try {
                date = DateTime.parse(
                  l.split("Crash occurred on")[1].trim(),
                );
              } catch (e) {
                debugPrint(e.toString());
                date = l.toString();
              }
              return "";
            }
            return l;
          })
          .where((l) => l.replaceAll("\n", "").trim().isNotEmpty)
          .join("\n");
      if (date != null || body != '') {
        result.add({'date': date, 'body': body, 'expand': false});
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
    if (await clearLogs()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已清空')),
        );
        logsContent = [];
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日志'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String type) {
              switch (type) {
                case 'copy':
                  copyLogs();
                  break;
                case 'feedback':
                  PageUtils.launchURL(
                      'https://github.com/bggRGjQaUbCoE/PiliPlus/issues');
                  break;
                case 'clear':
                  clearLogsHandle();
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
          ? SafeArea(
              bottom: false,
              child: ListView.separated(
                itemCount: logsContent.length,
                itemBuilder: (context, index) {
                  final log = logsContent[index];
                  if (log['date'] is DateTime) {
                    latestLog ??= log['date'];
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Text(
                              log['date'].toString(),
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize,
                              ),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {
                                Utils.copyText('```\n${log['body']}\n```',
                                    needToast: false);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '已将 ${log['date'].toString()} 复制至剪贴板',
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.copy_outlined, size: 16),
                              label: const Text('复制'),
                            )
                          ],
                        ),
                        Card(
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12.0),
                            child: SelectableText(log['body']),
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
            )
          : scrollErrorWidget(),
    );
  }
}
