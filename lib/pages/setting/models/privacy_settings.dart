import 'dart:async';

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/stateful_builder.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/services/local_blacklist_cleanup_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/accounts/api_type.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide StatefulBuilder;

List<SettingsModel> get privacySettings => [
  NormalModel(
    onTap: (context, setState) => Get.toNamed('/blackListPage'),
    title: '黑名单管理',
    subtitle: '已拉黑用户',
    leading: const Icon(Icons.block),
  ),
  const SwitchModel(
    title: '自动清理已注销用户',
    subtitle: '启动时在后台检查，仅清理 B 站明确判定为不存在的账号',
    leading: Icon(Icons.person_remove_alt_1_outlined),
    setKey: SettingBoxKey.autoCleanDeletedBlacklist,
    defaultVal: true,
  ),
  NormalModel(
    title: '清理已注销用户',
    subtitle: '立即检查并清理本地黑名单中的已注销账号',
    leading: const Icon(Icons.cleaning_services_outlined),
    onTap: (_, _) => _cleanDeletedBlacklist(),
  ),
  const NormalModel(
    title: 'buvid设置',
    leading: Icon(CustomIcons.identifier_circle),
    onTap: _showBuvidDialog,
  ),
  NormalModel(
    onTap: (context, setState) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('账号模式详情'),
          content: SelectionArea(
            child: SingleChildScrollView(
              child: _getAccountDetail(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text('确认'),
            ),
          ],
        ),
      );
    },
    leading: const Icon(Icons.flag_outlined),
    title: '了解账号模式',
    subtitle: '查看各个账号模式作用的API列表',
  ),
];

void _cleanDeletedBlacklist() {
  unawaited(() async {
    SmartDialog.showLoading(msg: '正在检查本地黑名单');
    try {
      final removedCount =
          await LocalBlacklistCleanupService.cleanDeletedLocalMids();
      SmartDialog.dismiss();
      if (removedCount == null) {
        SmartDialog.showToast('正在检查，请稍后再试');
      } else if (removedCount == 0) {
        SmartDialog.showToast('未发现已注销用户');
      } else {
        SmartDialog.showToast('已清理 $removedCount 个已注销用户');
      }
    } catch (error) {
      SmartDialog.dismiss();
      SmartDialog.showToast('检查失败，名单未更改：$error');
    }
  }());
}

Widget _getAccountDetail(BuildContext context) {
  final children = <Widget>[];
  final theme = TextTheme.of(context);
  for (final i in AccountType.values) {
    final url = ApiType.apiTypeSet[i];
    if (url == null) continue;

    children
      ..add(Center(child: Text(i.title, style: theme.titleMedium)))
      ..add(Text(url.join('\n')));
  }
  return Column(
    spacing: 8,
    mainAxisSize: .min,
    crossAxisAlignment: .start,
    children: children,
  );
}

void _showBuvidDialog(BuildContext context, VoidCallback setState) {
  final filter = [
    FilteringTextInputFormatter.allow(
      RegExp(r"[a-z\d\-_]+", caseSensitive: false),
    ),
  ];
  final controllers = [
    (
      AnonymousAccount(),
      TextEditingController(text: AnonymousAccount().buvid),
    ),
    ...Accounts.account.values.map(
      (i) => (i, TextEditingController(text: i.buvid)),
    ),
  ];
  showDialog<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return StatefulBuilder(
        onDispose: () {
          for (var (_, ctr) in controllers) {
            ctr.dispose();
          }
          controllers.clear();
        },
        builder: (context, _) => AlertDialog(
          title: const Text('buvid'),
          content: SingleChildScrollView(
            child: Column(
              spacing: 8,
              mainAxisSize: .min,
              children: controllers
                  .map(
                    (i) => TextField(
                      controller: i.$2,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'mid: ${i.$1.mid}',
                        labelStyle: theme.textTheme.titleMedium,
                        suffixIcon: IconButton(
                          onPressed: () =>
                              i.$2.text = LoginUtils.generateBuvid(),
                          iconSize: 24,
                          tooltip: '随机',
                          icon: const Icon(Icons.casino_outlined),
                        ),
                      ),
                      inputFormatters: filter,
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(color: theme.colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                for (var (account, ctr) in controllers) {
                  if (ctr.text case final text when text.isNotEmpty) {
                    account.buvid = text;
                  }
                }
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
    },
  );
}
