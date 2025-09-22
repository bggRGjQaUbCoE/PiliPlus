import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/danmaku_msg.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveRoomChatPanel extends StatelessWidget {
  const LiveRoomChatPanel({
    super.key,
    required this.roomId,
    required this.liveRoomController,
    this.isPP = false,
  });

  final int roomId;
  final LiveRoomController liveRoomController;
  final bool isPP;
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
    return Stack(
      children: [
        Obx(
          () => ListView.separated(
            key: const PageStorageKey('live-chat'),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            controller: liveRoomController.scrollController,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: liveRoomController.messages.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = liveRoomController.messages[index];
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
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
                          recognizer: item.uid == 0
                              ? null
                              : (TapGestureRecognizer()
                                  ..onTap = () =>
                                      Get.toNamed('/member?mid=${item.uid}')),
                        ),
                        _buildMsg(devicePixelRatio, item),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (kDebugMode && liveRoomController.showSuperChat) ...[
          Positioned(
            top: 50,
            right: 0,
            child: TextButton(
              onPressed: () {
                liveRoomController.superChatMsg.insert(
                  0,
                  SuperChatItem.fromJson({
                    "id": Utils.random.nextInt(2147483647),
                    "price": 66,
                    "end_time":
                        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 5,
                    "message": "message message message message message",
                    "user_info": {
                      "face": "",
                      "uname": "UNAME",
                    },
                  }),
                );
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
          height: uemote.height == null
              ? null
              : isUpower
              ? uemote.height!
              : uemote.height! / devicePixelRatio,
          semanticsLabel: obj.text,
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
                semanticsLabel: key,
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
}
