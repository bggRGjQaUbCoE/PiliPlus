import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/services/loggeer.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/cache_manage.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key, this.showAppBar});

  final bool? showAppBar;

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

  Future<void> getCacheSize() async {
    cacheSize.value =
        CacheManage.formatSize(await CacheManage().loadApplicationCache());
  }

  Future<void> getCurrentApp() async {
    var currentInfo = await PackageInfo.fromPlatform();
    String buildNumber = currentInfo.buildNumber;
    currentVersion.value = "${currentInfo.version}+$buildNumber";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline;
    final subTitleStyle = TextStyle(fontSize: 13, color: outline);
    return Scaffold(
      appBar:
          widget.showAppBar == false ? null : AppBar(title: const Text('关于')),
      body: ListView(
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: ExcludeSemantics(
                child: Image.asset(
                  'assets/images/logo/logo.png',
                ),
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
              onTap: () => Utils.checkUpdate(false),
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
            title: const Text(
              '''
Build Time: ${BuildConfig.buildTime}
Commit Hash: ${BuildConfig.commitHash}''',
              style: TextStyle(fontSize: 14),
            ),
            leading: const Icon(Icons.info_outline),
            onTap: () => PageUtils.launchURL(
                'https://github.com/bggRGjQaUbCoE/PiliPlus/commit/${BuildConfig.commitHash}'),
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
            onLongPress: clearLogs,
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('错误日志'),
            subtitle: Text('长按清除日志', style: subTitleStyle),
            trailing: Icon(Icons.arrow_forward, size: 16, color: outline),
          ),
          ListTile(
            onTap: () => showConfirmDialog(
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
            ),
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
            onTap: () => showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text('导入/导出登录信息'),
                clipBehavior: Clip.hardEdge,
                children: [
                  ListTile(
                    title: const Text('导出登录信息至剪贴板'),
                    onTap: () {
                      Get.back();
                      String res = jsonEncode(Accounts.account.toMap());
                      Utils.copyText(res);
                    },
                  ),
                  ListTile(
                    title: const Text('从剪贴板导入登录信息'),
                    onTap: () async {
                      Get.back();
                      ClipboardData? data =
                          await Clipboard.getData('text/plain');
                      if (data?.text?.isNotEmpty != true) {
                        SmartDialog.showToast('剪贴板无数据');
                        return;
                      }
                      if (!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('是否导入以下登录信息？'),
                            content: SingleChildScrollView(
                              child: Text(data!.text!),
                            ),
                            actions: [
                              TextButton(
                                onPressed: Get.back,
                                child: Text(
                                  '取消',
                                  style: TextStyle(color: outline),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                  try {
                                    final res = (jsonDecode(data.text!) as Map)
                                        .map((key, value) => MapEntry(
                                            key, LoginAccount.fromJson(value)));
                                    Accounts.account
                                        .putAll(res)
                                        .whenComplete(() => Accounts.refresh())
                                        .whenComplete(() {
                                      MineController.anonymity.value =
                                          !Accounts.get(AccountType.heartbeat)
                                              .isLogin;
                                      if (Accounts.main.isLogin) {
                                        return LoginUtils.onLoginMain();
                                      }
                                    });
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
              ),
            ),
          ),
          ListTile(
            title: const Text('导入/导出设置'),
            dense: false,
            leading: const Icon(Icons.import_export_outlined),
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  clipBehavior: Clip.hardEdge,
                  title: const Text('导入/导出设置'),
                  children: [
                    ListTile(
                      title: const Text('导出设置至剪贴板'),
                      onTap: () {
                        Get.back();
                        String data = GStorage.exportAllSettings();
                        Utils.copyText(data);
                      },
                    ),
                    ListTile(
                      title: const Text('从剪贴板导入设置'),
                      onTap: () async {
                        Get.back();
                        ClipboardData? data =
                            await Clipboard.getData('text/plain');
                        if (data == null ||
                            data.text == null ||
                            data.text!.isEmpty) {
                          SmartDialog.showToast('剪贴板无数据');
                          return;
                        }
                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('是否导入如下设置？'),
                              content: SingleChildScrollView(
                                child: Text(data.text!),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: Get.back,
                                  child: Text(
                                    '取消',
                                    style: TextStyle(color: outline),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Get.back();
                                    try {
                                      await GStorage.importAllSettings(
                                          data.text!);
                                      SmartDialog.showToast('导入成功');
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
            ),
          ),
          ListTile(
            title: const Text('重置所有设置'),
            leading: const Icon(Icons.settings_backup_restore_outlined),
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('重置所有设置'),
                  content: const Text('是否重置所有设置？'),
                  actions: [
                    TextButton(
                      onPressed: Get.back,
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        await Future.wait([
                          GStorage.setting.clear(),
                          GStorage.video.clear(),
                        ]);
                        SmartDialog.showToast('重置成功');
                      },
                      child: const Text('重置可导出的设置'),
                    ),
                    TextButton(
                      onPressed: () async {
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
                      child: const Text('重置所有数据（含登录信息）'),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
