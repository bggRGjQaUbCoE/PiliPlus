import 'dart:async';

import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/pages/common/common_publish_page.dart';
import 'package:PiliPlus/pages/emote/view.dart';
import 'package:PiliPlus/pages/video/detail/reply_new/toolbar_icon_button.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/models/common/reply_type.dart';

class ReplyPage extends CommonPublishPage {
  final int? oid;
  final int? root;
  final int? parent;
  final ReplyType? replyType;
  final dynamic replyItem;
  final String? hint;

  const ReplyPage({
    super.key,
    super.initialValue,
    super.imageLengthLimit,
    super.onSave,
    this.oid,
    this.root,
    this.parent,
    this.replyType,
    this.replyItem,
    this.hint,
  });

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends CommonPublishPageState<ReplyPage> {
  final RxBool _syncToDynamic = false.obs;

  Widget get child => GestureDetector(
        onTap: Get.back,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isH = constraints.maxWidth > constraints.maxHeight;
            late double padding = constraints.maxWidth * 0.12;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isH ? padding : 0),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildInputView(),
                      buildImagePreview(),
                      buildPanelContainer(themeData.colorScheme.surface),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeData = darkVideoPage
        ? MyApp.darkThemeData ?? Theme.of(context)
        : Theme.of(context);
  }

  late final darkVideoPage =
      Get.currentRoute.startsWith('/video') && GStorage.darkVideoPage;
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return darkVideoPage ? Theme(data: themeData, child: child) : child;
  }

  @override
  Widget? customPanel(double height) => SizedBox(
        height: height,
        child: EmotePanel(onChoose: onChooseEmote),
      );

  Widget buildImagePreview() {
    return Obx(
      () {
        if (pathList.isNotEmpty) {
          return Container(
            height: 85,
            color: themeData.colorScheme.surface,
            padding: const EdgeInsets.only(bottom: 10),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: pathList.length,
              itemBuilder: (context, index) => buildImage(index, 75),
              separatorBuilder: (context, index) => const SizedBox(width: 10),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget buildInputView() {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: themeData.colorScheme.surface,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 12, right: 15, left: 15, bottom: 10),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Listener(
                onPointerUp: (event) {
                  if (readOnly.value) {
                    updatePanelType(PanelType.keyboard);
                    selectKeyboard.value = true;
                  }
                },
                child: Obx(
                  () => TextField(
                    controller: editController,
                    minLines: 4,
                    maxLines: 8,
                    autofocus: false,
                    readOnly: readOnly.value,
                    onChanged: (value) {
                      bool isEmpty = value.trim().isEmpty;
                      if (!isEmpty && !enablePublish.value) {
                        enablePublish.value = true;
                      } else if (isEmpty && enablePublish.value) {
                        enablePublish.value = false;
                      }
                      widget.onSave?.call(value);
                    },
                    focusNode: focusNode,
                    decoration: InputDecoration(
                        hintText: widget.hint ?? "输入回复内容",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 14)),
                    style: themeData.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: themeData.dividerColor.withOpacity(0.1),
          ),
          Container(
            height: 52,
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => ToolbarIconButton(
                    tooltip: '输入',
                    onPressed: () {
                      if (!selectKeyboard.value) {
                        selectKeyboard.value = true;
                        updatePanelType(PanelType.keyboard);
                      }
                    },
                    icon: const Icon(Icons.keyboard, size: 22),
                    selected: selectKeyboard.value,
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => ToolbarIconButton(
                    tooltip: '表情',
                    onPressed: () {
                      if (selectKeyboard.value) {
                        selectKeyboard.value = false;
                        updatePanelType(PanelType.emoji);
                      }
                    },
                    icon: const Icon(Icons.emoji_emotions, size: 22),
                    selected: !selectKeyboard.value,
                  ),
                ),
                if (widget.root == 0) ...[
                  const SizedBox(width: 10),
                  ToolbarIconButton(
                    tooltip: '图片',
                    selected: false,
                    icon: const Icon(Icons.image, size: 22),
                    onPressed: onPickImage,
                  ),
                ],
                const Spacer(),
                Obx(
                  () => TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 13),
                      visualDensity: const VisualDensity(
                        horizontal: -2,
                        vertical: -2,
                      ),
                      foregroundColor: _syncToDynamic.value
                          ? themeData.colorScheme.secondary
                          : themeData.colorScheme.outline,
                    ),
                    onPressed: () {
                      _syncToDynamic.value = !_syncToDynamic.value;
                    },
                    icon: Icon(
                      _syncToDynamic.value
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 22,
                    ),
                    label: const Text('转发至动态'),
                  ),
                ),
                const Spacer(),
                Obx(
                  () => FilledButton.tonal(
                    onPressed: enablePublish.value ? onPublish : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      visualDensity: const VisualDensity(
                        horizontal: -2,
                        vertical: -2,
                      ),
                    ),
                    child: const Text('发送'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future onCustomPublish({required String message, List? pictures}) async {
    var result = await VideoHttp.replyAdd(
      type: widget.replyType ?? ReplyType.video,
      oid: widget.oid!,
      root: widget.root!,
      parent: widget.parent!,
      message: widget.replyItem != null && widget.replyItem.root != 0
          ? ' 回复 @${widget.replyItem.member.name} : $message'
          : message,
      pictures: pictures,
      syncToDynamic: _syncToDynamic.value,
    );
    if (result['status']) {
      SmartDialog.showToast(result['data']['success_toast']);
      Get.back(result: result['data']['reply']);
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }
}
