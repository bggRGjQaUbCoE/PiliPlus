import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/stateful_builder.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/accounts/api_type.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide StatefulBuilder;

List<SettingsModel> get privacySettings => [
  NormalModel(
    onTap: (context, setState) => Get.toNamed('/blackListPage'),
    title: '黑名单管理',
    subtitle: '已拉黑用户',
    leading: const Icon(Icons.block),
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
