import 'dart:convert';

import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart'
    show Session, SessionId, SessionPageType, SessionType, UnreadStyle;
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/pages/whisper_secondary/view.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class WhisperSessionItem extends StatelessWidget {
  const WhisperSessionItem({
    super.key,
    required this.item,
    required this.onSetTop,
    required this.onSetMute,
    required this.onRemove,
  });

  final Session item;
  final Function(bool isTop, SessionId id) onSetTop;
  final Function(bool isMuted, Int64 talkerUid) onSetMute;
  final ValueChanged<int?> onRemove;

  @override
  Widget build(BuildContext context) {
    final resource =
        item.sessionInfo.avatar.fallbackLayers.layers.first.resource;
    final avatar = resource.hasResImage()
        ? resource.resImage.imageSrc.remote.url
        : resource.hasResAnimation()
        ? resource.resAnimation.webpSrc.remote.url
        : resource.resNativeDraw.drawSrc.remote.url;
    Map? vipInfo = item.sessionInfo.hasVipInfo()
        ? jsonDecode(item.sessionInfo.vipInfo)
        : null;
    final ThemeData theme = Theme.of(context);

    void onLongPress() => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          clipBehavior: Clip.hardEdge,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          content: DefaultTextStyle(
            style: const TextStyle(fontSize: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  onTap: () {
                    Get.back();
                    onSetTop(item.isPinned, item.id);
                  },
                  title: Text(item.isPinned ? '移除置顶' : '置顶'),
                ),
                if (item.id.privateId.hasTalkerUid())
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      onSetMute(item.isMuted, item.id.privateId.talkerUid);
                    },
                    title: Text('${item.isMuted ? '关闭' : '开启'}免打扰'),
                  ),
                if (item.id.privateId.hasTalkerUid())
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      showConfirmDialog(
                        context: context,
                        title: '确定删除该对话？',
                        onConfirm: () =>
                            onRemove(item.id.privateId.talkerUid.toInt()),
                      );
                    },
                    title: const Text('删除'),
                  ),
              ],
            ),
          ),
        );
      },
    );

    return ListTile(
      safeArea: true,
      tileColor: item.isPinned
          ? theme.colorScheme.onInverseSurface.withValues(
              alpha: Get.isDarkMode ? 0.4 : 0.8,
            )
          : null,
      onLongPress: onLongPress,
      onSecondaryTap: Utils.isMobile ? null : onLongPress,
      onTap: () {
        if (item.hasUnread()) {
          item.clearUnread();
          if (context.mounted) {
            (context as Element).markNeedsBuild();
          }
        }
        if (item.id.privateId.hasTalkerUid()) {
          Get.toNamed(
            '/whisperDetail',
            arguments: {
              'talkerId': item.id.privateId.talkerUid.toInt(),
              'name': item.sessionInfo.sessionName,
              'face': avatar,
              if (item.sessionInfo.avatar.hasMid())
                'mid': item.sessionInfo.avatar.mid.toInt(),
              'isLive': item.sessionInfo.isLive,
            },
          );
          return;
        }

        if (item.id.foldId.hasType()) {
          SessionPageType? sessionPageType = switch (item.id.foldId.type) {
            SessionType.SESSION_TYPE_UNKNOWN =>
              SessionPageType.SESSION_PAGE_TYPE_UNKNOWN,
            SessionType.SESSION_TYPE_GROUP =>
              SessionPageType.SESSION_PAGE_TYPE_GROUP,
            SessionType.SESSION_TYPE_GROUP_FOLD =>
              SessionPageType.SESSION_PAGE_TYPE_GROUP,
            SessionType.SESSION_TYPE_UNFOLLOWED =>
              SessionPageType.SESSION_PAGE_TYPE_UNFOLLOWED,
            SessionType.SESSION_TYPE_STRANGER =>
              SessionPageType.SESSION_PAGE_TYPE_STRANGER,
            SessionType.SESSION_TYPE_DUSTBIN =>
              SessionPageType.SESSION_PAGE_TYPE_DUSTBIN,
            SessionType.SESSION_TYPE_CUSTOMER_FOLD =>
              SessionPageType.SESSION_PAGE_TYPE_CUSTOMER,
            SessionType.SESSION_TYPE_AI_FOLD =>
              SessionPageType.SESSION_PAGE_TYPE_AI,
            SessionType.SESSION_TYPE_CUSTOMER_ACCOUNT =>
              SessionPageType.SESSION_PAGE_TYPE_CUSTOMER,
            _ => null,
          };
          if (sessionPageType != null) {
            Get.to(
              WhisperSecPage(
                name: item.sessionInfo.sessionName,
                sessionPageType: sessionPageType,
              ),
            );
          } else {
            SmartDialog.showToast(item.id.foldId.type.name);
          }
        }
      },
      leading: Builder(
        builder: (context) {
          final pendant = item.sessionInfo.avatar.fallbackLayers.layers
              .getOrNull(1)
              ?.resource;
          final offcial = item
              .sessionInfo
              .avatar
              .fallbackLayers
              .layers
              .lastOrNull
              ?.resource
              .resImage
              .imageSrc;

          return GestureDetector(
            onTap: item.sessionInfo.avatar.hasMid()
                ? () =>
                      Get.toNamed('/member?mid=${item.sessionInfo.avatar.mid}')
                : null,
            child: PendantAvatar(
              size: 42,
              badgeSize: 14,
              avatar: avatar,
              garbPendantImage:
                  pendant?.resImage.imageSrc.remote.hasUrl() == true
                  ? pendant!.resImage.imageSrc.remote.url
                  : pendant?.resAnimation.webpSrc.remote.url,
              isVip: vipInfo?['status'] != null && vipInfo!['status'] > 0,
              officialType: offcial?.hasLocalValue() == true
                  ? switch (offcial!.localValue) {
                      3 => 0,
                      4 => 1,
                      _ => null,
                    }
                  : null,
            ),
          );
        },
      ),
      title: Row(
        spacing: 5,
        children: [
          Expanded(
            child: Row(
              spacing: 5,
              children: [
                Flexible(
                  child: Text(
                    item.sessionInfo.sessionName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          vipInfo?['status'] != null &&
                              vipInfo!['status'] > 0 &&
                              vipInfo['type'] == 2
                          ? theme.colorScheme.vipColor
                          : null,
                    ),
                  ),
                ),
                if (item.sessionInfo.userLabel.style.borderedLabel.hasText())
                  PBadge(
                    isStack: false,
                    type: PBadgeType.line_secondary,
                    size: PBadgeSize.small,
                    fontSize: 10,
                    isBold: false,
                    text: item.sessionInfo.userLabel.style.borderedLabel.text,
                  ),
                if (item.sessionInfo.isLive)
                  Image.asset(
                    'assets/images/live/live.gif',
                    height: 15,
                    filterQuality: FilterQuality.low,
                  ),
              ],
            ),
          ),
          if (item.hasTimestamp())
            Text(
              DateFormatUtils.dateFormat((item.timestamp ~/ 1000000).toInt()),
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.outline,
              ),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              item.msgSummary.rawMsg,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          if (item.isMuted)
            Icon(
              size: 16,
              Icons.notifications_off,
              color: theme.colorScheme.outline,
            )
          else if (item.hasUnread() &&
              item.unread.style != UnreadStyle.UNREAD_STYLE_NONE)
            Badge(
              label: item.unread.style == UnreadStyle.UNREAD_STYLE_NUMBER
                  ? Text(item.unread.number.toString())
                  : null,
            ),
        ],
      ),
    );
  }
}
