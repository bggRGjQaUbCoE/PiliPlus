import 'package:PiliPlus/http/login.dart';
import 'package:PiliPlus/pages/about/index.dart';
import 'package:PiliPlus/pages/login/controller.dart';
import 'package:PiliPlus/pages/setting/extra_setting.dart';
import 'package:PiliPlus/pages/setting/play_setting.dart';
import 'package:PiliPlus/pages/setting/privacy_setting.dart';
import 'package:PiliPlus/pages/setting/recommend_setting.dart';
import 'package:PiliPlus/pages/setting/style_setting.dart';
import 'package:PiliPlus/pages/setting/video_setting.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'widgets/multi_select_dialog.dart';

class _SettingsModel {
  final String name;
  final String title;
  final String? subtitle;
  final IconData icon;

  const _SettingsModel({
    required this.name,
    required this.title,
    this.subtitle,
    required this.icon,
  });
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late String _type = 'privacySetting';
  final RxBool _noAccount = Accounts.accountMode.isEmpty.obs;
  TextStyle get _titleStyle => Theme.of(context).textTheme.titleMedium!;
  TextStyle get _subTitleStyle => Theme.of(context)
      .textTheme
      .labelMedium!
      .copyWith(color: Theme.of(context).colorScheme.outline);
  bool get _isPortrait => context.orientation == Orientation.portrait;

  final List<_SettingsModel> _items = [
    _SettingsModel(
      name: 'privacySetting',
      title: '隐私设置',
      subtitle: '黑名单、无痕模式',
      icon: Icons.privacy_tip_outlined,
    ),
    _SettingsModel(
      name: 'recommendSetting',
      title: '推荐流设置',
      subtitle: '推荐来源（web/app）、刷新保留内容、过滤器',
      icon: Icons.explore_outlined,
    ),
    _SettingsModel(
      name: 'videoSetting',
      title: '音视频设置',
      subtitle: '画质、音质、解码、缓冲、音频输出等',
      icon: Icons.video_settings_outlined,
    ),
    _SettingsModel(
      name: 'playSetting',
      title: '播放器设置',
      subtitle: '双击/长按、全屏、后台播放、弹幕、字幕、底部进度条等',
      icon: Icons.touch_app_outlined,
    ),
    _SettingsModel(
      name: 'styleSetting',
      title: '外观设置',
      subtitle: '横屏适配（平板）、侧栏、列宽、首页、动态红点、主题、字号、图片、帧率等',
      icon: Icons.style_outlined,
    ),
    _SettingsModel(
      name: 'extraSetting',
      title: '其它设置',
      subtitle: '震动、搜索、收藏、ai、评论、动态、代理、更新检查等',
      icon: Icons.extension_outlined,
    ),
    _SettingsModel(
      name: 'about',
      title: '关于',
      icon: Icons.info_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isPortrait
            ? const Text('设置')
            : Text(switch (_type) {
                'privacySetting' => '隐私设置',
                'recommendSetting' => '推荐流设置',
                'videoSetting' => '音视频设置',
                'playSetting' => '播放器设置',
                'styleSetting' => '外观设置',
                'extraSetting' => '其它设置',
                'about' => '关于',
                _ => '设置',
              }),
      ),
      body: _isPortrait
          ? _buildList
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 40, child: _buildList),
                VerticalDivider(
                  width: 1,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                ),
                Expanded(
                  flex: 60,
                  child: switch (_type) {
                    'privacySetting' => PrivacySetting(showAppBar: false),
                    'recommendSetting' => RecommendSetting(showAppBar: false),
                    'videoSetting' => VideoSetting(showAppBar: false),
                    'playSetting' => PlaySetting(showAppBar: false),
                    'styleSetting' => StyleSetting(showAppBar: false),
                    'extraSetting' => ExtraSetting(showAppBar: false),
                    'about' => AboutPage(showAppBar: false),
                    _ => const SizedBox.shrink(),
                  },
                )
              ],
            ),
    );
  }

  void _toPage(String name) {
    if (_isPortrait) {
      Get.toNamed('/$name');
    } else {
      _type = name;
      setState(() {});
    }
  }

  Color? _getTileColor(String name) {
    if (_isPortrait) {
      return null;
    } else {
      return name == _type
          ? Theme.of(context).colorScheme.onInverseSurface
          : null;
    }
  }

  Widget get _buildList {
    return ListView(
      children: [
        _buildSearchItem,
        ..._items.sublist(0, _items.length - 1).map(
              (item) => ListTile(
                tileColor: _getTileColor(item.name),
                onTap: () => _toPage(item.name),
                leading: Icon(item.icon),
                title: Text(item.title, style: _titleStyle),
                subtitle: item.subtitle == null
                    ? null
                    : Text(item.subtitle!, style: _subTitleStyle),
              ),
            ),
        ListTile(
          onTap: () => LoginPageController.switchAccountDialog(context),
          leading: const Icon(Icons.switch_account_outlined),
          title: const Text('设置账号模式'),
        ),
        Obx(
          () => _noAccount.value
              ? const SizedBox.shrink()
              : ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  onTap: () => _logoutDialog(context),
                  title: Text('退出登录', style: _titleStyle),
                ),
        ),
        ListTile(
          tileColor: _getTileColor(_items.last.name),
          onTap: () => _toPage(_items.last.name),
          leading: Icon(_items.last.icon),
          title: Text(_items.last.title, style: _titleStyle),
        ),
        SizedBox(height: MediaQuery.paddingOf(context).bottom + 80),
      ],
    );
  }

  Future<void> _logoutDialog(BuildContext context) async {
    final result = await showDialog<Set<LoginAccount>>(
      context: context,
      builder: (context) {
        return MultiSelectDialog<LoginAccount>(
          title: '选择要登出的账号uid',
          initValues: Iterable.empty(),
          values: {for (var i in Accounts.account.values) i: i.mid.toString()},
        );
      },
    );
    if (!context.mounted || result.isNullOrEmpty) return;
    Future<void> logout() {
      _noAccount.value = result!.length == Accounts.account.length;
      return Accounts.deleteAll(result);
    }

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('提示'),
            content: Text(
                "确认要退出以下账号登录吗\n\n${result!.map((i) => i.mid.toString()).join('\n')}"),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '点错了',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  logout();
                },
                child: Text(
                  '仅登出',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              TextButton(
                onPressed: () async {
                  SmartDialog.showLoading();
                  final res = await LoginHttp.logout(Accounts.main);
                  if (res['status']) {
                    SmartDialog.dismiss();
                    logout();
                    Get.back();
                  } else {
                    SmartDialog.dismiss();
                    SmartDialog.showToast(res['msg'].toString());
                  }
                },
                child: const Text('确认'),
              )
            ],
          );
        });
  }

  Widget get _buildSearchItem => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
        child: InkWell(
          onTap: () => Get.toNamed('/settingsSearch'),
          borderRadius: BorderRadius.circular(50),
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    size: MediaQuery.textScalerOf(context).scale(18),
                    Icons.search,
                  ),
                  const Text(' 搜索'),
                ],
              ),
            ),
          ),
        ),
      );
}
