import 'dart:convert';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/services/loggeer.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:PiliPlus/models/github/latest.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import '../../utils/cache_manage.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key, this.showAppBar});

  final bool? showAppBar;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final AboutController _aboutController = Get.put(AboutController());
  final String _sourceCodeUrl = 'https://github.com/bggRGjQaUbCoE/PiliPlus';
  final String _originSourceCodeUrl = 'https://github.com/guozhigq/pilipala';
  final String _upstreamUrl = 'https://github.com/orz12/PiliPalaX';

  late int _pressCount = 0;

  @override
  void initState() {
    super.initState();
    // 读取缓存占用
    getCacheSize();
  }

  Future<void> getCacheSize() async {
    final res = await CacheManage().loadApplicationCache();
    _aboutController.cacheSize.value = res;
  }

  @override
  Widget build(BuildContext context) {
    final Color outline = Theme.of(context).colorScheme.outline;
    TextStyle subTitleStyle =
        TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline);
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
                            Utils.handleWebview(value, inApp: true);
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
            title: Text('PiliPlus',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(height: 2)),
            subtitle: Row(children: [
              const Spacer(),
              Text(
                '使用Flutter开发的B站第三方客户端',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
                semanticsLabel: '与你一起，发现不一样的世界',
              ),
              const Icon(
                Icons.accessibility_new,
                semanticLabel: "无障碍适配",
                size: 18,
              ),
              const Spacer(),
            ]),
          ),
          Obx(
            () => ListTile(
              onTap: () => Utils.checkUpdate(false),
              onLongPress: () =>
                  Utils.copyText(_aboutController.currentVersion.value),
              title: const Text('当前版本'),
              leading: const Icon(Icons.commit_outlined),
              trailing: Text(
                _aboutController.currentVersion.value,
                style: subTitleStyle,
              ),
            ),
          ),
          ListTile(
            title: Text(
              '''
Build Time: ${BuildConfig.buildTime}
Commit Hash: ${BuildConfig.commitHash}''',
              style: TextStyle(fontSize: 14),
            ),
            leading: const Icon(Icons.info_outline),
            onTap: () => Utils.launchURL(
                'https://github.com/bggRGjQaUbCoE/PiliPlus/commit/${BuildConfig.commitHash}'),
            onLongPress: () => Utils.copyText(BuildConfig.commitHash),
          ),
          // Obx(
          //   () => ListTile(
          //     onTap: () => _aboutController.onUpdate(),
          //     title: const Text('最新版本'),
          //     leading: const Icon(Icons.flag_outlined),
          //     trailing: Text(
          //       _aboutController.isLoading.value
          //           ? '正在获取'
          //           : _aboutController.isUpdate.value
          //               ? '有新版本  ❤️${_aboutController.remoteVersion.value}'
          //               : '当前已是最新版',
          //       style: subTitleStyle,
          //     ),
          //   ),
          // ),
          // ListTile(
          //   onTap: () {},
          //   title: const Text('更新日志'),
          //   trailing: const Icon(
          //     Icons.arrow_forward,
          //     size: 16,
          //   ),
          // ),
          Divider(
            thickness: 1,
            height: 30,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          ListTile(
            onTap: () => Utils.launchURL(_sourceCodeUrl),
            leading: const Icon(Icons.code),
            title: const Text('Source Code'),
            subtitle: Text(_sourceCodeUrl, style: subTitleStyle),
          ),
          ListTile(
            onTap: () => Utils.launchURL(_originSourceCodeUrl),
            leading: const Icon(Icons.code),
            title: const Text('Origin'),
            subtitle: Text(
              _originSourceCodeUrl,
              style: subTitleStyle,
            ),
          ),
          ListTile(
            onTap: () => Utils.launchURL(_upstreamUrl),
            leading: const Icon(Icons.code),
            title: const Text('Upstream'),
            subtitle: Text(
              _upstreamUrl,
              style: subTitleStyle,
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    clipBehavior: Clip.hardEdge,
                    title: const Text('问题反馈'),
                    children: [
                      ListTile(
                        title: const Text('GitHub Issue'),
                        onTap: () => Utils.launchURL('$_sourceCodeUrl/issues'),
                      ),
                    ],
                  );
                },
              );
            },
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('问题反馈'),
            trailing: Icon(
              Icons.arrow_forward,
              size: 16,
              color: outline,
            ),
          ),
          ListTile(
            onTap: () {
              Get.toNamed('/logs');
            },
            onLongPress: clearLogs,
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('错误日志'),
            trailing: Icon(Icons.arrow_forward, size: 16, color: outline),
          ),
          ListTile(
            onTap: () async {
              await CacheManage().clearCacheAll(context);
              getCacheSize();
            },
            leading: const Icon(Icons.delete_outline),
            title: const Text('清除缓存'),
            subtitle: Obx(
              () => Text(
                '图片及网络缓存 ${_aboutController.cacheSize.value}',
                style: subTitleStyle,
              ),
            ),
          ),
          ListTile(
            title: const Text('导入/导出登录信息'),
            leading: const Icon(Icons.import_export_outlined),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text('导入/导出登录信息'),
                  clipBehavior: Clip.hardEdge,
                  children: [
                    ListTile(
                      title: const Text('导出'),
                      onTap: () async {
                        Get.back();
                        String res = jsonEncode(Accounts.account.toMap());
                        Utils.copyText(res);
                        // if (context.mounted) {
                        //   showDialog(
                        //     context: context,
                        //     builder: (context) => AlertDialog(
                        //       content: SelectableText('$res'),
                        //     ),
                        //   );
                        // }
                      },
                    ),
                    ListTile(
                      title: const Text('导入'),
                      onTap: () async {
                        Get.back();
                        ClipboardData? data =
                            await Clipboard.getData('text/plain');
                        if (data?.text?.isNotEmpty != true) {
                          SmartDialog.showToast('剪贴板无数据');
                          return;
                        }
                        if (!context.mounted) return;
                        await showDialog(
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
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    try {
                                      final res = (jsonDecode(data.text!)
                                              as Map)
                                          .map((key, value) => MapEntry(key,
                                              LoginAccount.fromJson(value)));
                                      Accounts.account
                                          .putAll(res)
                                          .then((_) => Accounts.refresh())
                                          .then((_) {
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
              );
            },
          ),
          ListTile(
              title: const Text('导入/导出设置'),
              dense: false,
              leading: const Icon(Icons.import_export_outlined),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      clipBehavior: Clip.hardEdge,
                      title: const Text('导入/导出设置'),
                      children: [
                        ListTile(
                          title: const Text('导出设置至剪贴板'),
                          onTap: () async {
                            Get.back();
                            String data = await GStorage.exportAllSettings();
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
                            await showDialog(
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
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
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
                );
              }),
          ListTile(
            title: const Text('重置所有设置'),
            leading: const Icon(Icons.settings_backup_restore_outlined),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('重置所有设置'),
                    content: const Text('是否重置所有设置？'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
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
              );
            },
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 80),
        ],
      ),
    );
  }
}

class AboutController extends GetxController {
  RxString currentVersion = ''.obs;
  RxString remoteVersion = ''.obs;
  LatestDataModel? remoteAppInfo;
  RxBool isUpdate = true.obs;
  RxBool isLoading = true.obs;
  LatestDataModel? data;
  RxString cacheSize = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // init();
    // 获取当前版本
    getCurrentApp();
    // 获取最新的版本
    // getRemoteApp();
  }

  // 获取设备信息
  // Future init() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     debugPrint(androidInfo.supportedAbis);
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     debugPrint(iosInfo);
  //   }
  // }

  // 获取当前版本
  Future getCurrentApp() async {
    var currentInfo = await PackageInfo.fromPlatform();
    String buildNumber = currentInfo.buildNumber;
    currentVersion.value = "${currentInfo.version}+$buildNumber";
  }

  // // 获取远程版本
  // Future getRemoteApp() async {
  //   var result = await Request().get(Api.latestApp, extra: {'ua': 'pc'});
  //   if (result.data.isEmpty) {
  //     SmartDialog.showToast('检查更新失败，github接口未返回数据，请检查网络');
  //     return false;
  //   } else if (result.data[0] == null) {
  //     SmartDialog.showToast('检查更新失败，github接口返回如下内容：\n${result.data}');
  //     return false;
  //   }
  //   data = LatestDataModel.fromJson(result.data[0]);
  //   remoteAppInfo = data;
  //   remoteVersion.value = data!.tagName!;
  //   isUpdate.value =
  //       Utils.needUpdate(currentVersion.value, remoteVersion.value);
  //   isLoading.value = false;
  // }
}
