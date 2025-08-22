import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/danmaku_msg.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveRoomChat extends StatelessWidget {
  const LiveRoomChat({
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
    return Stack(
      children: [
        Obx(
          () => ListView.separated(
            padding: EdgeInsets.zero,
            controller: liveRoomController.scrollController,
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemCount: liveRoomController.messages.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = liveRoomController.messages[index];
              return Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
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
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              try {
                                Get.toNamed('/member?mid=${item.uid}');
                              } catch (err) {
                                if (kDebugMode) debugPrint(err.toString());
                              }
                            },
                        ),
                        _buildMsg(item),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Obx(
          () => liveRoomController.disableAutoScroll.value
              ? Positioned(
                  right: 12,
                  bottom: 0,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.arrow_downward_rounded,
                      size: 20,
                    ),
                    label: const Text('回到底部'),
                    onPressed: () => liveRoomController
                      ..disableAutoScroll.value = false
                      ..scrollToBottom(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  InlineSpan _buildMsg(DanmakuMsg obj) {
    final uemote = obj.uemote;
    if (uemote != null) {
      // "room_{{room_id}}_{{int}}" or "upower_[{{emote}}]"
      return WidgetSpan(
        child: NetworkImgLayer(
          src: uemote.url,
          type: ImageType.emote,
          width: uemote.width,
          height: uemote.height,
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
