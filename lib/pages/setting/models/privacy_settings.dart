import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/multi_select_dialog.dart';
import 'package:PiliPlus/services/message_notification_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/api_type.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

List<SettingsModel> get privacySettings => [
  getBanWordModel(
    title: '评论关键词屏蔽',
    key: SettingBoxKey.banWordForReply,
    onChanged: (value) {
      ReplyGrpc.replyRegExp = value;
      ReplyGrpc.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getBanWordModel(
    title: '评论用户名称关键词屏蔽',
    key: SettingBoxKey.banWordForReplyUser,
    onChanged: (value) => ReplyGrpc.replyUserRegExp = value,
  ),
  getBanWordModel(
    title: '评论 IP 属地屏蔽',
    key: SettingBoxKey.banWordForReplyZone,
    onChanged: (value) => ReplyGrpc.replyZoneRegExp = value,
  ),
  const SwitchModel(
    title: '屏蔽重复评论',
    subtitle: '隐藏当前评论区中正文相同的重复评论',
    leading: Icon(Icons.content_copy_outlined),
    setKey: SettingBoxKey.hideDuplicateReply,
  ),
  const SwitchModel(
    title: '模糊屏蔽相似评论',
    subtitle: '隐藏当前评论区中正文高度相似的评论，保留每组中的第一条',
    leading: Icon(Icons.filter_alt_outlined),
    setKey: SettingBoxKey.hideSimilarReply,
  ),
  SwitchModel(
    title: '接收手机消息通知',
    subtitle: '应用运行期间检测到新的未读消息时发送系统通知',
    leading: const Icon(Icons.notifications_active_outlined),
    setKey: SettingBoxKey.enableMessageNotifications,
    onChanged: (enabled) {
      if (enabled) MessageNotificationService.requestPermission();
      try {
        Get.find<MainController>().queryUnreadMsg();
      } catch (_) {}
    },
  ),
  NormalModel(
    title: '按用户等级屏蔽评论',
    getSubtitle: () {
      final levels = ReplyGrpc.blockedReplyLevels.toList()..sort();
      return levels.isEmpty ? '未屏蔽，可同时选择 0～6 级' : '已屏蔽：${levels.join('、')} 级';
    },
    leading: const Icon(Icons.filter_list_outlined),
    onTap: (context, setState) async {
      final result = await showDialog<Set<int>>(
        context: context,
        builder: (context) => MultiSelectDialog<int>(
          title: '选择要屏蔽的评论等级',
          initValues: Pref.blockedReplyLevels,
          values: {for (int level = 0; level <= 6; level++) level: '$level 级'},
        ),
      );
      if (result != null) {
        ReplyGrpc.blockedReplyLevels = result;
        await GStorage.setting.put(
          SettingBoxKey.blockedReplyLevels,
          result.toList()..sort(),
        );
        setState();
      }
    },
  ),
  NormalModel(
    onTap: (context, setState) {
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
