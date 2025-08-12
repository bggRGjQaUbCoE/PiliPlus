import 'dart:async';
import 'dart:io';
import 'dart:math' show max;

import 'package:PiliPlus/common/widgets/button/toolbar_icon_button.dart';
import 'package:PiliPlus/common/widgets/text_field/controller.dart'
    show RichTextType;
import 'package:PiliPlus/common/widgets/text_field/text_field.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/models/common/publish_panel_type.dart';
import 'package:PiliPlus/pages/common/publish/common_rich_text_pub_page.dart';
import 'package:PiliPlus/pages/dynamics_mention/controller.dart';
import 'package:PiliPlus/pages/emote/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/reply_search_item/view.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/duration_util.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:path_provider/path_provider.dart';

class ReplyPage extends CommonRichTextPubPage {
  final int oid;
  final int root;
  final int parent;
  final int replyType;
  final ReplyInfo? replyItem;
  final String? hint;

  const ReplyPage({
    super.key,
    super.items,
    super.imageLengthLimit,
    super.onSave,
    required this.oid,
    required this.root,
    required this.parent,
    required this.replyType,
    this.replyItem,
    this.hint,
  });

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends CommonRichTextPubPageState<ReplyPage> {
  final RxBool _syncToDynamic = false.obs;
  final heroTag = Get.arguments?['heroTag'];

  @override
  void dispose() {
    Get.delete<DynMentionController>();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeData = darkVideoPage
        ? MyApp.darkThemeData ?? Theme.of(context)
        : Theme.of(context);
  }

  late final darkVideoPage =
      Get.currentRoute.startsWith('/video') && Pref.darkVideoPage;
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    Widget child = SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640),
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
              ...buildInputView(),
              buildImagePreview(),
              buildPanelContainer(themeData, Colors.transparent),
            ],
          ),
        ),
      ),
    );
    return darkVideoPage ? Theme(data: themeData, child: child) : child;
  }

  @override
  Widget? get customPanel => EmotePanel(onChoose: onChooseEmote);

  Widget buildImagePreview() {
    return Obx(
      () {
        if (pathList.isNotEmpty) {
          return Container(
            height: 85,
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  pathList.length,
                  (index) => buildImage(index, 75),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  List<Widget> buildInputView() {
    return [
      Padding(
        padding: const EdgeInsets.only(
          top: 12,
          right: 15,
          left: 15,
          bottom: 10,
        ),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                minLines: 4,
                maxLines: 8,
                autofocus: false,
                readOnly: readOnly.value,
                onChanged: onChanged,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: widget.hint ?? "输入回复内容",
                  border: InputBorder.none,
                  hintStyle: const TextStyle(fontSize: 14),
                ),
                style: themeData.textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ),
      Divider(
        height: 1,
        color: themeData.dividerColor.withValues(alpha: 0.1),
      ),
      Container(
        height: 52,
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          children: [
            emojiBtn,
            if (widget.root == 0) ...[
              const SizedBox(width: 8),
              ToolbarIconButton(
                tooltip: '图片',
                selected: false,
                icon: const Icon(Icons.image, size: 22),
                onPressed: onPickImage,
              ),
            ],
            const SizedBox(width: 8),
            atBtn,
            const SizedBox(width: 8),
            moreBtn,
            Expanded(
              child: Center(
                child: Obx(
                  () {
                    final syncToDynamic = _syncToDynamic.value;
                    return TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.all(13),
                        visualDensity: VisualDensity.compact,
                        foregroundColor: syncToDynamic
                            ? themeData.colorScheme.secondary
                            : themeData.colorScheme.outline,
                      ),
                      onPressed: () => _syncToDynamic.value = !syncToDynamic,
                      child: Row(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            syncToDynamic
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 22,
                          ),
                          const Flexible(
                            child: Text(
                              '转到动态',
                              maxLines: 1,
                              style: TextStyle(height: 1),
                              strutStyle: StrutStyle(leading: 0, height: 1),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Obx(
              () => FilledButton.tonal(
                onPressed: enablePublish.value ? onPublish : null,
                style: FilledButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  visualDensity: VisualDensity.compact,
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
  Widget buildMorePanel(ThemeData theme) {
    double height = context.isTablet ? 300 : 170;
    final keyboardHeight = controller.keyboardHeight;
    if (keyboardHeight != 0) {
      height = max(height, keyboardHeight);
    }

    Widget item({
      required VoidCallback onTap,
      required Icon icon,
      required String title,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: themeData.colorScheme.onInverseSurface,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                alignment: Alignment.center,
                child: icon,
              ),
            ),
            Text(
              title,
              maxLines: 1,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      );
    }

    final isRoot = widget.root == 0;
    final color = themeData.colorScheme.onSurfaceVariant;

    return SizedBox(
      height: height,
      child: GridView(
        padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
        gridDelegate: SliverGridDelegateWithExtentAndRatio(
          maxCrossAxisExtent: 65,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 25,
        ),
        children: [
          item(
            onTap: () async {
              controller.keepChatPanel();
              ({String title, String url})? res = await Get.to(
                ReplySearchPage(type: widget.replyType, oid: widget.oid),
              );
              if (res != null) {
                onInsertText(
                  '${res.title} ',
                  RichTextType.common,
                  rawText: '${res.url} ',
                );
              }
              controller.restoreChatPanel();
            },
            icon: Icon(Icons.post_add, size: 28, color: color),
            title: '插入内容',
          ),
          if (heroTag != null) ...[
            // if (isRoot)
            //   item(
            //     onTap: () {
            //       Get.back();
            //       try {
            //         Get.find<VideoDetailController>(tag: heroTag)
            //             .showNoteList(context);
            //       } catch (e) {
            //         debugPrint(e.toString());
            //       }
            //     },
            //     icon: Icon(Icons.edit_note, size: 28, color: color),
            //     title: '笔记',
            //   ),
            item(
              onTap: () {
                try {
                  final plPlayerController = Get.find<VideoDetailController>(
                    tag: heroTag,
                  );
                  onInsertText(
                    ' ${DurationUtil.formatDuration((plPlayerController.playedTime ?? Duration.zero).inSeconds)} ',
                    RichTextType.common,
                  );
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              icon: Icon(Icons.my_location, size: 28, color: color),
              title: '视频进度',
            ),
            if (isRoot)
              item(
                onTap: () async {
                  if (pathList.length >= limit) {
                    SmartDialog.showToast('最多选择$limit张图片');
                    return;
                  }
                  try {
                    final plPlayerController = Get.find<VideoDetailController>(
                      tag: heroTag,
                    );
                    final res = await plPlayerController
                        .plPlayerController
                        .videoPlayerController
                        ?.screenshot(format: 'image/png');
                    if (res != null) {
                      final tempDir = await getTemporaryDirectory();
                      File file = File(
                        '${tempDir.path}/${Utils.generateRandomString(8)}.png',
                      );
                      await file.writeAsBytes(res);
                      pathList.add(file.path);
                    } else {
                      debugPrint('null screenshot');
                    }
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                icon: Icon(
                  Icons.enhance_photo_translate_outlined,
                  size: 28,
                  color: color,
                ),
                title: '视频截图',
              ),
          ],
        ],
      ),
    );
  }

  @override
  Future<void> onCustomPublish({List? pictures}) async {
    Map<String, int> atNameToMid = {};
    for (var e in editController.items) {
      if (e.type == RichTextType.at) {
        atNameToMid[e.rawText] ??= int.parse(e.id!);
      }
    }
    String message = editController.rawText;
    var result = await VideoHttp.replyAdd(
      type: widget.replyType,
      oid: widget.oid,
      root: widget.root,
      parent: widget.parent,
      message: widget.replyItem != null && widget.replyItem!.root != 0
          ? ' 回复 @${widget.replyItem!.member.name} : $message'
          : message,
      atNameToMid: atNameToMid,
      pictures: pictures,
      syncToDynamic: _syncToDynamic.value,
    );
    if (result['status']) {
      hasPub = true;
      SmartDialog.showToast(result['data']['success_toast']);
      Get.back(result: result['data']['reply']);
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }
}
