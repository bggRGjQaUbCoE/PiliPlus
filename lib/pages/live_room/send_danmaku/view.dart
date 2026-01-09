import 'dart:async';

import 'package:PiliPlus/common/widgets/flutter/text_field/text_field.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/models/common/publish_panel_type.dart';
import 'package:PiliPlus/pages/common/publish/common_rich_text_pub_page.dart';
import 'package:PiliPlus/pages/live_emote/controller.dart';
import 'package:PiliPlus/pages/live_emote/view.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LiveSendDmPanel extends CommonRichTextPubPage {
  final bool fromEmote;
  final LiveRoomController liveRoomController;

  const LiveSendDmPanel({
    super.key,
    super.items,
    super.onSave,
    super.autofocus = true,
    this.fromEmote = false,
    required this.liveRoomController,
  });

  @override
  State<LiveSendDmPanel> createState() => _ReplyPageState();
}

class _ReplyPageState extends CommonRichTextPubPageState<LiveSendDmPanel> {
  LiveRoomController get liveRoomController => widget.liveRoomController;

  @override
  void initState() {
    super.initState();
    if (widget.fromEmote) {
      updatePanelType(PanelType.emoji);
    }
  }

  @override
  void dispose() {
    Get.delete<LiveEmotePanelController>(
      tag: liveRoomController.roomId.toString(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ViewSafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...buildInputView(theme),
              Flexible(child: buildPanelContainer(theme, Colors.transparent)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget? get customPanel => LiveEmotePanel(
    onChoose: onChooseEmote,
    roomId: liveRoomController.roomId,
    onSendEmoticonUnique: (emote) {
      onCustomPublish(
        message: emote.emoticonUnique!,
        dmType: 1,
        emoticonOptions: '[object Object]',
      );
    },
  );

  List<Widget> buildInputView(ThemeData theme) {
    return [
      Padding(
        padding: const EdgeInsets.only(
          top: 12,
          right: 15,
          left: 15,
          bottom: 10,
        ),
        child: Listener(
          onPointerUp: (event) {
            if (readOnly.value) {
              updatePanelType(PanelType.keyboard);
            }
          },
          child: Obx(
            () => RichTextField(
              key: key,
              controller: editController,
              minLines: 1,
              maxLines: 2,
              autofocus: false,
              readOnly: readOnly.value,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: "输入弹幕内容",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 14),
              ),
              style: theme.textTheme.bodyLarge,
              // inputFormatters: [LengthLimitingTextInputFormatter(20)],
            ),
          ),
        ),
      ),
      Divider(
        height: 1,
        color: theme.dividerColor.withValues(alpha: 0.1),
      ),
      Container(
        height: 52,
        padding: const .symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            emojiBtn,
            Obx(
              () => FilledButton.tonal(
                onPressed: enablePublish.value ? onPublish : null,
                style: FilledButton.styleFrom(
                  visualDensity: .compact,
                  padding: const .symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('发送'),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Future<void> onCustomPublish({
    String? message,
    List? pictures,
    int? dmType,
    emoticonOptions,
  }) async {
    int replyMid = 0;
    String replyDmid = '';
    if (message == null) {
      final buffer = StringBuffer();
      for (final e in editController.items) {
        if (e.type == .at) {
          replyMid = int.parse(e.rawText);
          replyDmid = e.id!;
        } else {
          buffer.write(e.rawText);
        }
      }
      message = buffer.toString();
    }
    final res = await LiveHttp.sendLiveMsg(
      roomId: liveRoomController.roomId,
      msg: message,
      dmType: dmType,
      emoticonOptions: emoticonOptions,
      replyMid: replyMid,
      replayDmid: replyDmid,
    );
    if (res.isSuccess) {
      hasPub = true;
      Get.back();
      liveRoomController
        ..savedDanmaku?.clear()
        ..savedDanmaku = null;
      SmartDialog.showToast('发送成功');
    } else {
      res.toast();
    }
  }

  @override
  Future<void>? onMention([bool fromClick = false]) => null;
}
