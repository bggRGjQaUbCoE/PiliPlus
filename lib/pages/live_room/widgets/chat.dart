import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/services/loggeer.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveRoomChat extends StatelessWidget {
  const LiveRoomChat({
    super.key,
    required this.roomId,
    required this.liveRoomController,
    this.isPP,
  });

  final int roomId;
  final LiveRoomController liveRoomController;
  final bool? isPP;
  bool get disableAutoScroll => liveRoomController.disableAutoScroll.value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Obx(
          () => ListView.separated(
            padding: const EdgeInsets.all(0),
            controller: liveRoomController.scrollController,
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemCount: liveRoomController.messages.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isPP == true
                        ? Colors.black.withOpacity(0.3)
                        : Color(0x15FFFFFF),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${liveRoomController.messages[index]['name']}: ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              try {
                                dynamic uid =
                                    liveRoomController.messages[index]['uid'];
                                Get.toNamed(
                                  '/member?mid=$uid',
                                  arguments: {
                                    'heroTag': Utils.makeHeroTag(uid),
                                  },
                                );
                              } catch (err) {
                                debugPrint(err.toString());
                              }
                            },
                        ),
                        _buildMsg(liveRoomController.messages[index]),
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
                    onPressed: () {
                      liveRoomController.disableAutoScroll.value = false;
                      liveRoomController.scrollToBottom();
                    },
                  ),
                )
              : const SizedBox.shrink(),
        )
      ],
    );
  }

  TextSpan _buildMsg(obj) {
    dynamic emots = obj['emots'];
    dynamic uemote = obj['uemote'];
    List list = [
      if (emots != null) ...emots.keys,
      if (uemote is Map) uemote['emoticon_unique'].replaceFirst('upower_', '')
    ];
    if (list.isNotEmpty) {
      list = list.map((e) {
        return e.toString().replaceAllMapped(
              RegExp(r'\[(.*?)\]'),
              (match) => r'\[' + match.group(1)! + r'\]',
            );
      }).toList();
      RegExp regExp = RegExp(list.join('|'));
      final List<InlineSpan> spanChildren = <InlineSpan>[];
      (obj['text'] as String).splitMapJoin(
        regExp,
        onMatch: (Match match) {
          String key = match[0]!;
          dynamic emote = emots?[key] ?? uemote;
          spanChildren.add(WidgetSpan(
            child: ExcludeSemantics(
                child: NetworkImgLayer(
              src: emote['url'],
              type: 'emote',
              width: emote['width'].toDouble(),
              height: emote['height'].toDouble(),
              semanticsLabel: key,
            )),
          ));
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
        text: obj['text'],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      );
    }
  }
}

final PiliLogger logger = getLogger();
