import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/list_tile.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/cache_manage.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/date_util.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/update.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:dio/dio.dart' show Headers;
import 'package:document_file_save_plus/document_file_save_plus_platform_interface.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/re_highlight.dart';
import 'package:re_highlight/styles/github-dark.dart';
import 'package:re_highlight/styles/github.dart';
import 'package:share_plus/share_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final String _sourceCodeUrl = 'https://github.com/bggRGjQaUbCoE/PiliPlus';

  RxString currentVersion = ''.obs;
  RxString cacheSize = ''.obs;

  late int _pressCount = 0;

  @override
  void initState() {
    super.initState();
    getCacheSize();
    getCurrentApp();
  }

  @override
  void dispose() {
    currentVersion.close();
    cacheSize.close();
    super.dispose();
  }

  Future<void> getCacheSize() async {
    cacheSize.value = CacheManage.formatSize(
      await CacheManage.loadApplicationCache(),
    );
  }

  Future<void> getCurrentApp() async {
    var currentInfo = await PackageInfo.fromPlatform();
    String buildNumber = currentInfo.buildNumber;
    currentVersion.value = "${currentInfo.version}+$buildNumber";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const style = TextStyle(fontSize: 15);
    final outline = theme.colorScheme.outline;
    final subTitleStyle = TextStyle(fontSize: 13, color: outline);
    final showAppBar = widget.showAppBar;
    final padding = MediaQuery.viewPaddingOf(context);
    return Scaffold(
      appBar: showAppBar ? AppBar(title: const Text('关于')) : null,
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: EdgeInsets.only(
          left: showAppBar ? padding.left : 0,
          right: showAppBar ? padding.right : 0,
          bottom: padding.bottom + 100,
        ),
        children: [
          GestureDetector(
            onTap: () {
              _pressCount++;
              if (_pressCount == 5) {
                _pressCount = 0;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: TextField(
                        autofocus: true,
                        onSubmitted: (value) {
                          Get.back();
                          if (value.isNotEmpty) {
                            PageUtils.handleWebview(value, inApp: true);
                          }
                        },
                      ),
                    );
                  },
                );
              }
            },
            child: ExcludeSemantics(
              child: Image.asset(
                width: 150,
                height: 150,
                'assets/images/logo/logo.png',
              ),
            ),
          ),
          ListTile(
            title: Text(
              'PiliPlus',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium!.copyWith(height: 2),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '使用Flutter开发的B站第三方客户端',
                  style: TextStyle(color: outline),
                  semanticsLabel: '与你一起，发现不一样的世界',
                ),
                const Icon(
                  Icons.accessibility_new,
                  semanticLabel: "无障碍适配",
                  size: 18,
                ),
              ],
            ),
          ),
          Obx(
            () => ListTile(
              onTap: () => Update.checkUpdate(false),
              onLongPress: () => Utils.copyText(currentVersion.value),
              title: const Text('当前版本'),
              leading: const Icon(Icons.commit_outlined),
              trailing: Text(
                currentVersion.value,
                style: subTitleStyle,
              ),
            ),
          ),
          ListTile(
            title: Text(
              '''
Build Time: ${DateUtil.format(BuildConfig.buildTime, format: DateUtil.longFormatDs)}
Commit Hash: ${BuildConfig.commitHash}''',
              style: const TextStyle(fontSize: 14),
            ),
            leading: const Icon(Icons.info_outline),
            onTap: () => PageUtils.launchURL(
              'https://github.com/bggRGjQaUbCoE/PiliPlus/commit/${BuildConfig.commitHash}',
            ),
            onLongPress: () => Utils.copyText(BuildConfig.commitHash),
          ),
          Divider(
            thickness: 1,
            height: 30,
            color: theme.colorScheme.outlineVariant,
          ),
          ListTile(
            onTap: () => PageUtils.launchURL(_sourceCodeUrl),
            leading: const Icon(Icons.code),
            title: const Text('Source Code'),
            subtitle: Text(_sourceCodeUrl, style: subTitleStyle),
          ),
          if (Platform.isAndroid)
            ListTile(
              onTap: () => Utils.channel.invokeMethod('linkVerifySettings'),
              leading: const Icon(MdiIcons.linkBoxOutline),
              title: const Text('打开受支持的链接'),
              trailing: Icon(
                Icons.arrow_forward,
                size: 16,
                color: outline,
              ),
            ),
          ListTile(
            onTap: () => PageUtils.launchURL('$_sourceCodeUrl/issues'),
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('问题反馈'),
            trailing: Icon(
              Icons.arrow_forward,
              size: 16,
              color: outline,
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed('/logs'),
            onLongPress: LoggerUtils.clearLogs,
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('错误日志'),
            subtitle: Text('长按清除日志', style: subTitleStyle),
            trailing: Icon(Icons.arrow_forward, size: 16, color: outline),
          ),
          ListTile(
            onTap: () {
              if (cacheSize.value.isNotEmpty) {
                showConfirmDialog(
                  context: context,
                  title: '提示',
                  content: '该操作将清除图片及网络请求缓存数据，确认清除？',
                  onConfirm: () async {
                    SmartDialog.showLoading(msg: '正在清除...');
                    try {
                      await CacheManage.clearLibraryCache();
                      SmartDialog.showToast('清除成功');
                    } catch (err) {
                      SmartDialog.showToast(err.toString());
                    } finally {
                      SmartDialog.dismiss();
                    }
                    getCacheSize();
                  },
                );
              }
            },
            leading: const Icon(Icons.delete_outline),
            title: const Text('清除缓存'),
            subtitle: Obx(
              () => Text(
                '图片及网络缓存 ${cacheSize.value}',
                style: subTitleStyle,
              ),
            ),
          ),
          ListTile(
            title: const Text('导入/导出登录信息'),
            leading: const Icon(Icons.import_export_outlined),
            onTap: () => showInportExportDialog<Map>(
              context,
              title: '登录信息',
              toJson: () => jsonEncode(Accounts.account.toMap()),
              fromJson: (json) async {
                final res = json.map(
                  (key, value) => MapEntry(key, LoginAccount.fromJson(value)),
                );
                await Accounts.account.putAll(res);
                await Accounts.refresh();
                MineController.anonymity.value = !Accounts.heartbeat.isLogin;
                if (Accounts.main.isLogin) {
                  await LoginUtils.onLoginMain();
                }
                return true;
              },
            ),
          ),
          ListTile(
            title: const Text('导入/导出设置'),
            dense: false,
            leading: const Icon(Icons.import_export_outlined),
            onTap: () => showInportExportDialog(
              context,
              title: '设置',
              label: GStorage.setting.name,
              toJson: GStorage.exportAllSettings,
              fromJson: GStorage.importAllJsonSettings,
            ),
          ),
          ListTile(
            title: const Text('重置所有设置'),
            leading: const Icon(Icons.settings_backup_restore_outlined),
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  clipBehavior: Clip.hardEdge,
                  title: const Text('是否重置所有设置？'),
                  children: [
                    ListTile(
                      dense: true,
                      onTap: () async {
                        Get.back();
                        await Future.wait([
                          GStorage.setting.clear(),
                          GStorage.video.clear(),
                        ]);
                        SmartDialog.showToast('重置成功');
                      },
                      title: const Text('重置可导出的设置', style: style),
                    ),
                    ListTile(
                      dense: true,
                      onTap: () async {
                        Get.back();
                        await Future.wait([
                          GStorage.userInfo.clear(),
                          GStorage.setting.clear(),
                          GStorage.localCache.clear(),
                          GStorage.video.clear(),
                          GStorage.historyWord.clear(),
                          Accounts.clear(),
                        ]);
                        SmartDialog.showToast('重置成功');
                      },
                      title: const Text('重置所有数据（含登录信息）', style: style),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showInportExportDialog<T>(
  BuildContext context, {
  required String title,
  String? label,
  required String Function() toJson,
  required FutureOr<bool> Function(T json) fromJson,
}) => showDialog(
  context: context,
  builder: (context) {
    const style = TextStyle(fontSize: 15);
    return SimpleDialog(
      clipBehavior: Clip.hardEdge,
      title: Text('导入/导出$title'),
      children: [
        if (label != null)
          ListTile(
            dense: true,
            title: const Text('导出文件至本地', style: style),
            onTap: () async {
              Get.back();
              final res = utf8.encode(toJson());
              final name =
                  'piliplus_${label}_${context.isTablet ? 'pad' : 'phone'}_'
                  '${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.json';
              try {
                DocumentFileSavePlusPlatform.instance.saveMultipleFiles(
                  dataList: [res],
                  fileNameList: [name],
                  mimeTypeList: const [Headers.jsonContentType],
                );
                if (Platform.isAndroid) {
                  SmartDialog.showToast('已保存');
                }
              } catch (e) {
                SharePlus.instance.share(
                  ShareParams(
                    files: [
                      XFile.fromData(
                        res,
                        name: name,
                        mimeType: Headers.jsonContentType,
                      ),
                    ],
                    sharePositionOrigin: await Utils.sharePositionOrigin,
                  ),
                );
              }
            },
          ),
        ListTile(
          dense: true,
          title: Text('导出$title至剪贴板', style: style),
          onTap: () {
            Get.back();
            Utils.copyText(toJson());
          },
        ),
        ListTile(
          dense: true,
          title: Text('从剪贴板导入$title', style: style),
          onTap: () async {
            Get.back();
            ClipboardData? data = await Clipboard.getData(
              'text/plain',
            );
            if (data?.text?.isNotEmpty != true) {
              SmartDialog.showToast('剪贴板无数据');
              return;
            }
            if (!context.mounted) return;
            final text = data!.text!;
            late final T json;
            late final String formatText;
            try {
              json = jsonDecode(text);
              formatText = const JsonEncoder.withIndent('    ').convert(json);
            } catch (e) {
              SmartDialog.showToast('解析json失败：$e');
              return;
            }
            final highlight = Highlight()..registerLanguage('json', langJson);
            final result = highlight.highlight(
              code: formatText,
              language: 'json',
            );
            late TextSpanRenderer renderer;
            bool? isDarkMode;
            showDialog(
              context: context,
              builder: (context) {
                final isDark = context.isDarkMode;
                if (isDark != isDarkMode) {
                  isDarkMode = isDark;
                  renderer = TextSpanRenderer(
                    const TextStyle(),
                    isDark ? githubDarkTheme : githubTheme,
                  );
                  result.render(renderer);
                }
                return AlertDialog(
                  title: Text('是否导入如下$title？'),
                  content: SingleChildScrollView(
                    child: Text.rich(renderer.span!),
                  ),
                  actions: [
                    TextButton(
                      onPressed: Get.back,
                      child: Text(
                        '取消',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        try {
                          if (await fromJson(json)) {
                            SmartDialog.showToast('导入成功');
                          }
                        } catch (e) {
                          SmartDialog.showToast('导入失败：$e');
                        }
                      },
                      child: const Text('确定'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  },
);
