import 'package:PiliPlus/pages_tv/common/tv_focus_wrapper.dart';
import 'package:PiliPlus/pages_tv/common/tv_page.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class TVSettingPage extends StatefulWidget {
  const TVSettingPage({super.key});

  @override
  State<TVSettingPage> createState() => _TVSettingPageState();
}

class _TVSettingPageState extends State<TVSettingPage> {
  late final _enableDanmaku = Pref.enableShowDanmaku.obs;
  late final _enableHA = Pref.enableHA.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountService = Get.find<AccountService>();

    return TVPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('设置')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _SectionTitle('账号', theme),
            Obx(() {
              final isLogin = accountService.isLogin.value;
              return TVFocusWrapper(
                autoFocus: true,
                scaleFactor: 1.02,
                borderRadius: 12,
                onSelect: () {
                  if (isLogin) {
                    _showLogoutDialog(context);
                  } else {
                    Get.toNamed('/tvLogin');
                  }
                },
                child: ListTile(
                  leading: Icon(
                    isLogin ? Icons.logout : Icons.login,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(isLogin ? '退出登录' : '登录'),
                  subtitle: isLogin
                      ? Text('已登录: ${Pref.userInfoCache?.uname ?? ""}')
                      : const Text('使用二维码扫码登录'),
                ),
              );
            }),

            const SizedBox(height: 16),
            _SectionTitle('播放设置', theme),
            _buildToggleItem(
              icon: Icons.subtitles,
              title: '默认显示弹幕',
              value: _enableDanmaku,
              onChanged: (val) {
                _enableDanmaku.value = val;
                GStorage.setting.put(SettingBoxKey.enableShowDanmaku, val);
              },
            ),
            _buildToggleItem(
              icon: Icons.memory,
              title: '硬件解码',
              value: _enableHA,
              onChanged: (val) {
                _enableHA.value = val;
                GStorage.setting.put(SettingBoxKey.enableHA, val);
                SmartDialog.showToast('重启应用后生效');
              },
            ),

            const SizedBox(height: 16),
            _SectionTitle('画质设置', theme),
            TVFocusWrapper(
              scaleFactor: 1.02,
              borderRadius: 12,
              onSelect: () => _showQualitySelector(context),
              child: ListTile(
                leading: Icon(Icons.high_quality,
                    color: theme.colorScheme.primary),
                title: const Text('默认画质'),
                subtitle: Text(_getQualityLabel(Pref.defaultVideoQa)),
              ),
            ),

            const SizedBox(height: 16),
            _SectionTitle('关于', theme),
            TVFocusWrapper(
              scaleFactor: 1.02,
              borderRadius: 12,
              onSelect: () {},
              child: ListTile(
                leading:
                    Icon(Icons.info_outline, color: theme.colorScheme.primary),
                title: const Text('PiliPlus TV'),
                subtitle: const Text('基于 PiliPlus 的 Android TV 版本'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return Obx(() => TVFocusWrapper(
          scaleFactor: 1.02,
          borderRadius: 12,
          onSelect: () => onChanged(!value.value),
          child: ListTile(
            leading: Icon(icon, color: theme.colorScheme.primary),
            title: Text(title),
            trailing: Switch(
              value: value.value,
              onChanged: onChanged,
            ),
          ),
        ));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Accounts.clear();
              Get.find<AccountService>()
                ..isLogin.value = false
                ..face.value = '';
              SmartDialog.showToast('已退出登录');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showQualitySelector(BuildContext context) {
    final qualities = [
      (80, '1080P 高清'),
      (64, '720P 高清'),
      (32, '480P 清晰'),
      (16, '360P 流畅'),
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('选择默认画质'),
        content: SizedBox(
          width: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: qualities.length,
            itemBuilder: (ctx, i) {
              final (qa, label) = qualities[i];
              return TVFocusWrapper(
                autoFocus: qa == Pref.defaultVideoQa,
                scaleFactor: 1.05,
                borderRadius: 8,
                onSelect: () {
                  GStorage.setting.put(SettingBoxKey.defaultVideoQa, qa);
                  Navigator.of(ctx).pop();
                  setState(() {});
                },
                child: ListTile(
                  title: Text(label),
                  selected: qa == Pref.defaultVideoQa,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getQualityLabel(int? qa) {
    return switch (qa) {
      80 => '1080P 高清',
      64 => '720P 高清',
      32 => '480P 清晰',
      16 => '360P 流畅',
      _ => '自动',
    };
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, this.theme);
  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
