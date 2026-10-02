import 'dart:async';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/button/toolbar_icon_button.dart';
import 'package:PiliPlus/common/widgets/flutter/text_field/text_field.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/models/common/publish_panel_type.dart';
import 'package:PiliPlus/pages/common/publish/common_rich_text_pub_page.dart';
import 'package:PiliPlus/pages/live_emote/controller.dart';
import 'package:PiliPlus/pages/live_emote/view.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/fans_medal/view.dart';
import 'package:PiliPlus/pages/member/widget/medal_widget.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide TextField;

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
    liveRoomController.loadFansMedal();
  }

  @override
  void dispose() {
    Get.delete<LiveEmotePanelController>(
      tag: liveRoomController.roomId.toString(),
    );
    super.dispose();
  }

  Widget get fansMedalBtn {
    if (!liveRoomController.isLogin) return const SizedBox.shrink();
    return Obx(() {
      final medal = liveRoomController.wearingMedal.value;
      if (medal == null) {
        return ToolbarIconButton(
          tooltip: '粉丝勋章',
          selected: false,
          icon: const Icon(Icons.workspace_premium_outlined, size: 22),
          onPressed: _showFansMedalPanel,
        );
      }
      return Tooltip(
        message: '粉丝勋章',
        child: Material(
          type: MaterialType.transparency,
          borderRadius: Style.mdRadius,
          child: InkWell(
            borderRadius: Style.mdRadius,
            onTap: _showFansMedalPanel,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: MedalWidget.fromMedalInfo(
                medal: medal,
                padding: MedalWidget.mediumPadding,
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showFansMedalPanel() {
    final context = this.context;
    final isPortrait = MediaQuery.sizeOf(context).isPortrait;
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 450),
      builder: (context) => FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: PlatformUtils.isMobile && !isPortrait ? 1.0 : 0.5,
        child: FansMedalPanel(liveRoomController: liveRoomController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Flexible(child: buildPanelContainer(Colors.transparent)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget? get customPanel => DecoratedBox(
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
    ),
    child: LiveEmotePanel(
      onChoose: onChooseEmote,
      roomId: liveRoomController.roomId,
      onSendEmoticonUnique: (emote) {
        onCustomPublish(
          message: emote.emoticonUnique!,
          dmType: 1,
          emoticonOptions: '[object Object]',
        );
      },
    ),
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
              textInputAction: TextInputAction.send,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: "输入弹幕内容",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 14),
              ),
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                emojiBtn,
                const SizedBox(width: 4),
                fansMedalBtn,
              ],
            ),
            Obx(
              () => FilledButton.tonal(
                onPressed: enablePublish.value ? onPublishThrottle : null,
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
        ..savedDanmaku = null
        ..markFansMedalStale();
      SmartDialog.showToast('发送成功');
    } else {
      res.toast();
    }
  }

  @override
  Future<void>? onMention([bool fromClick = false]) => null;
}
