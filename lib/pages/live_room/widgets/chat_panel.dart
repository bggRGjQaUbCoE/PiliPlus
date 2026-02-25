import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/common/widgets/gesture/tap_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/danmaku_msg.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_card.dart';
import 'package:PiliPlus/pages/video/widgets/header_control.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LiveRoomChatPanel extends StatelessWidget {
  const LiveRoomChatPanel({
    super.key,
    required this.roomId,
    required this.liveRoomController,
    required this.isPP,
    required this.onAtUser,
  });

  final int roomId;
  final LiveRoomController liveRoomController;
  final bool isPP;
  final ValueChanged<DanmakuMsg> onAtUser;

  bool get disableAutoScroll => liveRoomController.disableAutoScroll.value;

  @override
  Widget build(BuildContext context) {
    late final bg = isPP
        ? Colors.black.withValues(alpha: 0.4)
        : const Color(0x15FFFFFF);
    late final nameColor = isPP
        ? Colors.white.withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.6);
    late final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    late final colorScheme = ColorScheme.of(context);
    late final primary = colorScheme.isDark
        ? colorScheme.primary
        : colorScheme.inversePrimary;
    return Stack(
      children: [
        Obx(
          () => ListView.separated(
            key: const PageStorageKey(LiveRoomChatPanel),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            controller: liveRoomController.scrollController,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemCount: liveRoomController.messages.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (_, index) {
              final item = liveRoomController.messages[index];
              if (item is DanmakuMsg) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Builder(
                    builder: (itemContext) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(14),
                          ),
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${item.name}: ',
                                style: TextStyle(
                                  color: nameColor,
                                  fontSize: 14,
                                ),
                                recognizer: item.extra.mid == 0
                                    ? null
                                    : (NoDeadlineTapGestureRecognizer()
                                        ..onTapUp = (e) => _showMsgMenu(
                                          context,
                                          itemContext,
                                          e,
                                          item,
                                        )),
                              ),
                              if (item.reply case final reply?)
                                TextSpan(
                                  text: '@${reply.name} ',
                                  style: TextStyle(
                                    color: primary,
                                    fontSize: 14,
                                  ),
                                  recognizer: NoDeadlineTapGestureRecognizer()
                                    ..onTap = () =>
                                        Get.toNamed('/member?mid=${reply.mid}'),
                                ),
                              _buildMsg(devicePixelRatio, item),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              if (item is SuperChatItem) {
                return SuperChatCard(
                  item: item,
                  persistentSC: true,
                  onReport: () => liveRoomController.reportSC(item),
                );
              }
              throw item.runtimeType;
            },
          ),
        ),
        if (kDebugMode && liveRoomController.showSuperChat) ...[
          Positioned(
            top: 50,
            right: 0,
            child: TextButton(
              onPressed: () {
                final item = SuperChatItem.random;
                liveRoomController
                  ..superChatMsg.insert(0, item)
                  ..addDm(item);
              },
              child: const Text('add superchat'),
            ),
          ),
          Positioned(
            right: 0,
            top: 90,
            child: TextButton(
              onPressed: () {
                if (liveRoomController.superChatMsg.isNotEmpty) {
                  liveRoomController.superChatMsg.removeLast();
                }
              },
              child: const Text('remove superchat'),
            ),
          ),
        ],
        if (liveRoomController.showSuperChat)
          Positioned(
            top: 12,
            right: 12,
            child: Obx(() {
              final isEmpty = liveRoomController.superChatMsg.isEmpty;
              return AnimatedOpacity(
                opacity: isEmpty ? 0 : 1,
                duration: const Duration(milliseconds: 120),
                child: GestureDetector(
                  onTap: isEmpty
                      ? null
                      : () => liveRoomController.pageController?.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: const Color(0x2FFFFFFF),
                      border: Border.all(color: Colors.white24, width: 0.7),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
                    child: Text.rich(
                      style: const TextStyle(color: Colors.white, height: 1),
                      strutStyle: const StrutStyle(height: 1, leading: 0),
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'SC(${liveRoomController.superChatMsg.length})',
                          ),
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              size: 18,
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        Obx(
          () => liveRoomController.disableAutoScroll.value
              ? Positioned(
                  right: 12,
                  bottom: 0,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity.comfortable,
                    ),
                    icon: const Icon(
                      Icons.arrow_downward_rounded,
                      size: 20,
                    ),
                    label: const Text('回到底部'),
                    onPressed: () => liveRoomController
                      ..disableAutoScroll.value = false
                      ..jumpToBottom(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  InlineSpan _buildMsg(double devicePixelRatio, DanmakuMsg obj) {
    final uemote = obj.uemote;
    if (uemote != null) {
      // "room_{{room_id}}_{{int}}" or "upower_[{{emote}}]"
      final isUpower = uemote.isUpower;
      return WidgetSpan(
        child: NetworkImgLayer(
          src: uemote.url,
          type: ImageType.emote,
          width: isUpower ? uemote.width : uemote.width / devicePixelRatio,
          height: isUpower ? uemote.height : uemote.height / devicePixelRatio,
        ),
      );
    }
    final emots = obj.emots;
    if (emots != null) {
      RegExp regExp = RegExp(emots.keys.map(RegExp.escape).join('|'));
      final List<InlineSpan> spanChildren = <InlineSpan>[];
      obj.text.splitMapJoin(
        regExp,
        onMatch: (match) {
          final key = match[0]!;
          final emote = emots[key]!;
          spanChildren.add(
            WidgetSpan(
              child: NetworkImgLayer(
                src: emote.url,
                type: ImageType.emote,
                width: emote.width,
                height: emote.height,
              ),
            ),
          );
          return '';
        },
        onNonMatch: (String nonMatchStr) {
          spanChildren.add(
            TextSpan(
              text: nonMatchStr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          );
          return '';
        },
      );
      return TextSpan(children: spanChildren);
    } else {
      return TextSpan(
        text: obj.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      );
    }
  }

  void _showMsgMenu(
    BuildContext context,
    BuildContext itemContext,
    TapUpDetails details,
    DanmakuMsg item,
  ) {
    final dx = details.globalPosition.dx;
    final renderBox = itemContext.findRenderObject() as RenderBox;
    final dy =
        details.globalPosition.dy -
        details.localPosition.dy +
        renderBox.size.height -
        4; // padding
    final autoScroll =
        liveRoomController.autoScroll &&
        !liveRoomController.disableAutoScroll.value;
    if (autoScroll) {
      liveRoomController.autoScroll = false;
    }
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, 0),
      items: <PopupMenuEntry<Never>>[
        CustomPopupMenuItem(
          height: 38,
          child: Text(
            item.name,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        const CustomPopupMenuDivider(height: 1),
        PopupMenuItem(
          height: 38,
          onTap: () => Utils.copyText(Utils.jsonEncoder.convert(item.toJson())),
          child: const Text(
            '复制弹幕信息',
            style: TextStyle(fontSize: 13),
          ),
        ),
        PopupMenuItem(
          height: 38,
          onTap: () => Get.toNamed('/member?mid=${item.extra.mid}'),
          child: const Text(
            '去TA的个人空间',
            style: TextStyle(fontSize: 13),
          ),
        ),
        PopupMenuItem(
          height: 38,
          onTap: () => onAtUser(item),
          child: const Text(
            '@TA',
            style: TextStyle(fontSize: 13),
          ),
        ),
        PopupMenuItem(
          height: 38,
          onTap: () async {
            if (!liveRoomController.isLogin) return;
            final res = await LiveHttp.liveShieldUser(
              uid: item.extra.mid,
              roomid: roomId,
              type: 1,
            );
            if (res.isSuccess) {
              SmartDialog.showToast('屏蔽成功');
            } else {
              res.toast();
            }
          },
          child: const Text(
            '屏蔽发送者',
            style: TextStyle(fontSize: 13),
          ),
        ),
        PopupMenuItem(
          height: 38,
          onTap: () => HeaderControl.reportLiveDanmaku(
            context,
            roomId: roomId,
            msg: item.text,
            extra: item.extra,
          ),
          child: const Text(
            '举报选中弹幕',
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    ).whenComplete(() {
      if (autoScroll && context.mounted) {
        liveRoomController
          ..autoScroll = true
          ..scrollToBottom();
      }
    });
  }
}
