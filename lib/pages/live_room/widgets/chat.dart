import 'dart:convert';

import 'package:PiliPalaX/common/widgets/network_img_layer.dart';
import 'package:PiliPalaX/pages/live_room/controller.dart';
import 'package:PiliPalaX/services/loggeer.dart';
import 'package:PiliPalaX/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveRoomChat extends StatefulWidget {
  final int roomId;
  final LiveRoomController liveRoomController;
  const LiveRoomChat({
    super.key,
    required this.roomId,
    required this.liveRoomController,
  });
  @override
  State<LiveRoomChat> createState() => _LiveRoomChatState();
}

class _LiveRoomChatState extends State<LiveRoomChat> {
  bool get disableAutoScroll =>
      widget.liveRoomController.disableAutoScroll.value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => ListView.separated(
            controller: widget.liveRoomController.scrollController,
            separatorBuilder: (_, index) => const SizedBox(height: 6),
            itemCount: widget.liveRoomController.messages.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: const BoxDecoration(
                    color: Color(0x15FFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${widget.liveRoomController.messages[index]['name']}: ',
                          style: const TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 14,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              try {
                                dynamic uid = widget
                                    .liveRoomController.messages[index]['uid'];
                                Get.toNamed(
                                  '/member?mid=$uid',
                                  arguments: {
                                    'heroTag': Utils.makeHeroTag(uid),
                                  },
                                );
                              } catch (err) {
                                debugPrint(err.toString());
                                // SmartDialog.showToast(err.toString());
                              }
                            },
                        ),
                        _buildMsg(widget.liveRoomController.messages[index]),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Obx(
          () => widget.liveRoomController.disableAutoScroll.value
              ? Positioned(
                  right: 12,
                  bottom: 12,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_downward_rounded),
                    label: const Text('回到底部'),
                    onPressed: () {
                      widget.liveRoomController.disableAutoScroll.value = false;
                      widget.liveRoomController.scrollToBottom();
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
      if (emots != null) emots.keys,
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
                color: Color(0xFFFFFFFF),
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
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      );
    }
  }
}

final PiliLogger logger = getLogger();
