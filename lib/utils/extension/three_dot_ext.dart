import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart'
    show ThreeDotItem, ThreeDotItemType, IMSettingType;
import 'package:PiliPlus/pages/common/common_whisper_controller.dart';
import 'package:PiliPlus/pages/contact/view.dart';
import 'package:PiliPlus/pages/whisper_settings/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

extension ThreeDotItemTypeExt on ThreeDotItemType {
  Icon get icon => switch (this) {
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_MSG_SETTING => const Icon(
      Icons.settings,
      size: 20,
    ),
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_READ_ALL => const Icon(
      Icons.cleaning_services,
      size: 20,
    ),
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_CLEAR_LIST => const Icon(
      Icons.delete_forever_outlined,
      size: 20,
    ),
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_UP_HELPER => const Icon(
      Icons.live_tv,
      size: 20,
    ),
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_CONTACTS => const Icon(
      Icons.account_box_outlined,
      size: 20,
    ),
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_FANS_GROUP_HELPER => const Icon(
      Icons.notifications_none,
      size: 20,
    ),
    _ => const Icon(MdiIcons.circleMedium, size: 20),
  };

  void action({
    required BuildContext context,
    required CommonWhisperController controller,
    required ThreeDotItem item,
  }) {
    switch (this) {
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_READ_ALL:
        showConfirmDialog(
          context: context,
          title: '一键已读',
          content: '是否清除全部新消息提醒？',
          onConfirm: controller.onClearUnread,
        );
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_CLEAR_LIST:
        showConfirmDialog(
          context: context,
          title: '清空列表',
          content: '清空后所有消息将被删除，无法恢复',
          onConfirm: controller.onDeleteList,
        );
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_MSG_SETTING:
        Get.to(
          const WhisperSettingsPage(
            imSettingType: IMSettingType.SETTING_TYPE_NEED_ALL,
          ),
        );
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_UP_HELPER:
        dynamic talkerId = RegExp(r'/(\d{3,})').firstMatch(item.url)?.group(1);
        if (talkerId != null) {
          talkerId = int.parse(talkerId);
          Get.toNamed(
            '/whisperDetail',
            arguments: {
              'talkerId': talkerId,
              'name': item.title,
              'face': switch (talkerId) {
                844424930131966 =>
                  'https://message.biliimg.com/bfs/im/489a63efadfb202366c2f88853d2217b5ddc7a13.png',
                844424930131964 =>
                  'https://i0.hdslb.com/bfs/im_new/58eda511672db078466e7ab8db22a95c1503684976.png',
                _ => item.icon,
              },
            },
          );
        }
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_CONTACTS:
        Get.to(const ContactPage(isFromSelect: false));
      default:
        SmartDialog.showToast('TODO: $name');
    }
  }
}
