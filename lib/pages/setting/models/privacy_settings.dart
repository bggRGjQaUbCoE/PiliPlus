import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/models/common/settings_type.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account_manager/account_mgr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

List<SettingsModel> get privacySettings => [
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) {
      if (!Accounts.main.isLogin) {
        SmartDialog.showToast('登录后查看');
        return;
      }
      Get.toNamed('/blackListPage');
    },
    title: '黑名单管理',
    subtitle: '已拉黑用户',
    leading: const Icon(Icons.block),
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) {
      MineController.onChangeAnonymity();
      setState();
    },
    leading: const Icon(Icons.privacy_tip_outlined),
    getTitle: () => MineController.anonymity.value ? '退出无痕模式' : '进入无痕模式',
    getSubtitle: () => MineController.anonymity.value
        ? '已进入无痕模式，搜索、观看视频/直播不携带Cookie与CSRF，其余操作不受影响'
        : '未开启无痕模式，将使用账户信息提供完整服务',
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('账号模式详情'),
            content: SingleChildScrollView(
              child: _getAccountDetail(context),
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: const Text('确认'),
              ),
            ],
          );
        },
      );
    },
    leading: const Icon(Icons.flag_outlined),
    title: '了解账号模式',
    subtitle: '查看各个账号模式作用的API列表',
  ),
];

Widget _getAccountDetail(BuildContext context) {
  final slivers = <Widget>[];
  final theme = TextTheme.of(context);
  for (var i in AccountType.values) {
    final url = AccountManager.apiTypeSet[i];
    if (url == null) continue;

    slivers
      ..add(Center(child: Text(i.title, style: theme.titleMedium)))
      ..add(SelectableText(url.join('\n')));
  }
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: slivers,
  );
}
