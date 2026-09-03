import 'dart:async';
import 'dart:io';
import 'dart:math' show max;

import 'package:PiliPlus/common/widgets/button/toolbar_icon_button.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/flutter/text_field/controller.dart'
    show RichTextType, RichTextEditingDeltaReplacement;
import 'package:PiliPlus/common/widgets/flutter/text_field/text_field.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show platformClampingPhysics;
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/dynamics/result.dart' show FilePicModel;
import 'package:PiliPlus/pages/common/publish/common_rich_text_pub_page.dart';
import 'package:PiliPlus/pages/dynamics_mention/controller.dart';
import 'package:PiliPlus/pages/emote/controller.dart';
import 'package:PiliPlus/pages/emote/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/reply_search_item/view.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/latex_to_unicode.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide TextField;

class ReplyPage extends CommonRichTextPubPage {
  final int oid;
  final int root;
  final int parent;
  final int replyType;
  final ReplyInfo? replyItem;
  final String? hint;
  final bool canUploadPic;

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
    this.canUploadPic = true,
  });

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends CommonRichTextPubPageState<ReplyPage> {
  final RxBool _syncToDynamic = false.obs;
  final heroTag = Get.arguments?['heroTag'];

  final RxBool _latexOn = false.obs;

  @override
  void dispose() {
    Get
      ..delete<EmotePanelController>()
      ..delete<DynMentionController>();
    super.dispose();
  }

  @override
  void initTheme() {
    theme = darkVideoPage ? ThemeUtils.darkTheme : Theme.of(context);
  }

  late final darkVideoPage =
      Get.currentRoute == '/videoV' && Pref.darkVideoPage;

  @override
  Widget build(BuildContext context) {
    Widget child = ViewSafeArea(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...buildInputView(),
              buildImagePreview(),
              Flexible(child: buildPanelContainer(Colors.transparent)),
            ],
          ),
        ),
      ),
    );
    return darkVideoPage ? Theme(data: theme, child: child) : child;
  }

  @override
  Widget? get customPanel => EmotePanel(onChoose: onChooseEmote);

  Widget buildImagePreview() {
    return Obx(
      () {
        if (imageList.isNotEmpty) {
          return SizedBox(
            height: 85,
            child: ListView.separated(
              scrollDirection: .horizontal,
              padding: const .fromLTRB(15, 0, 15, 10),
              itemCount: imageList.length,
              itemBuilder: (_, index) => buildImage(index, 75),
              separatorBuilder: (_, _) => const SizedBox(width: 10),
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
        child: Obx(
          () => RichTextField(
            key: key,
            controller: editController,
            minLines: 4,
            maxLines: 8,
            autofocus: false,
            readOnly: readOnly.value,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: widget.hint ?? "输入回复内容",
              border: InputBorder.none,
              hintStyle: const TextStyle(fontSize: 14),
            ),
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ),
      Divider(
        height: 1,
        color: theme.dividerColor.withValues(alpha: 0.1),
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
                icon: widget.canUploadPic
                    ? const Icon(Icons.image, size: 22)
                    : const Icon(Icons.image_not_supported, size: 22),
                onPressed: widget.canUploadPic
                    ? onPickImage
                    : () => SmartDialog.showToast('当前评论区不支持发送图片'),
              ),
            ],
            const SizedBox(width: 8),
            atBtn,
            const SizedBox(width: 8),
            latexBtn,
            const SizedBox(width: 8),
            moreBtn,
            const SizedBox(width: 8),
            Obx(
              () => ToolbarIconButton(
                tooltip: '转到动态',
                onPressed: _syncToDynamic.toggle,
                icon: const Icon(
                  CustomIcons.repeat_rounded_rotate_90,
                  size: 22,
                ),
                selected: _syncToDynamic.value,
              ),
            ),
            const Spacer(),
            Obx(
              () => FilledButton.tonal(
                onPressed: enablePublish.value ? onPublishThrottle : null,
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
  Widget buildMorePanel() {
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
        behavior: HitTestBehavior.opaque,
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onInverseSurface,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                alignment: Alignment.center,
                child: icon,
              ),
            ),
            Text(
              title,
              maxLines: 1,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    final isRoot = widget.root == 0;
    final color = theme.colorScheme.onSurfaceVariant;
    late final gridDelegate = SliverGridDelegateWithExtentAndRatio(
      maxCrossAxisExtent: 65,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      mainAxisExtent: 25,
    );

    return SizedBox(
      height: height,
      child: GridView(
        physics: platformClampingPhysics,
        padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
        gridDelegate: gridDelegate,
        children: [
          item(
            onTap: () async {
              final ({String title, String url})? res = await Get.to(
                ReplySearchPage(type: widget.replyType, oid: widget.oid),
              );
              if (res != null) {
                onInsertText(
                  '${res.title} ',
                  RichTextType.common,
                  rawText: '${res.url} ',
                );
              }
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
                    ' ${DurationUtils.formatDuration((plPlayerController.playedTime ?? Duration.zero).inSeconds)} ',
                    RichTextType.common,
                  );
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              icon: Icon(Icons.my_location, size: 28, color: color),
              title: '视频进度',
            ),
            if (isRoot && widget.canUploadPic)
              item(
                onTap: () async {
                  if (imageList.length >= limit) {
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
                        ?.screenshot();
                    if (res != null) {
                      final png = await res.toByteData(format: .png);
                      if (png != null) {
                        final path =
                            '$tmpDirPath/${Utils.generateRandomString(8)}.png';
                        await File(path).writeAsBytes(png.buffer.asUint8List());
                        imageList.add(FilePicModel(path: path));
                      }
                      res.dispose();
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
    for (final e in editController.items) {
      if (e.type == RichTextType.at) {
        atNameToMid[e.rawText] ??= int.parse(e.id!);
      }
    }
    final message = editController.rawText;
    final res = await VideoHttp.replyAdd(
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
    if (res case Success(:final response)) {
      hasPub = true;
      SmartDialog.showToast('发送成功');
      Get.back(result: response);
    } else {
      res.toast();
    }
  }

  Widget get latexBtn => Obx(() {
    final latexOn = _latexOn.value;
    return ToolbarIconButton(
      onPressed: latexOn ? _unlatexify : _latexify,
      icon: const Icon(Icons.functions, size: 22),
      tooltip: '公式',
      selected: latexOn,
    );
  });

  Future<void> _latexify() async {
    // value.text is the display space (\uFFFC per emote), the same space
    // _replaceBlocks applies deltas in; formula spans hold no items, so the
    // text there is byte-equivalent to rawText.
    final rawText = editController.value.text;
    if (rawText.trim().isEmpty) return;

    final (spans, warnings) = LatexToUnicode.convertSpans(rawText);
    if (spans.isEmpty) {
      SmartDialog.showToast(
        warnings.isEmpty
            ? '未发现用 \$ 括起的公式'
            : '公式未能识别：${warnings.join('、')}（已保留原文）',
      );
      return;
    }

    _replaceBlocks(spans, rawText);
    _latexOn.value = true;
    if (warnings.isNotEmpty) {
      SmartDialog.showToast(
        '无法识别：${warnings.join('、')}（已保留原文）',
      );
    }
  }

  void _unlatexify() {
    // id 'latex' marks blocks created by _latexify.
    final blocks = editController.items
        .where((e) => e.type == .latex)
        .toList(growable: false);
    if (blocks.isEmpty) {
      _latexOn.value = false;
      return;
    }
    for (final item in blocks.reversed) {
      final oldValue = editController.value;
      final delta = RichTextEditingDeltaReplacement(
        oldText: oldValue.text,
        replacementText: item.rawText,
        replacedRange: TextRange(
          start: item.range.start,
          end: item.range.end,
        ),
        selection: TextSelection.collapsed(
          offset: item.range.start + item.rawText.length,
        ),
        composing: TextRange.empty,
        type: RichTextType.text,
      );
      final newValue = delta.apply(oldValue);
      if (oldValue == newValue) continue;
      editController
        ..syncRichText(delta)
        ..value = newValue;
    }
    _latexOn.value = false;
  }

  /// Replaces each formula span with a locked common-type block: the
  /// rendered Unicode goes into the block text, the LaTeX source into its
  /// rawText, and id 'latex' marks the block for toggling back.
  void _replaceBlocks(
    List<({int start, int end, String converted})> spans,
    String rawText,
  ) {
    for (final span in spans.reversed) {
      final oldValue = editController.value;
      final source = rawText.substring(span.start, span.end);
      final delta = RichTextEditingDeltaReplacement(
        oldText: oldValue.text,
        replacementText: span.converted,
        replacedRange: TextRange(start: span.start, end: span.end),
        selection: TextSelection.collapsed(
          offset: span.start + span.converted.length,
        ),
        composing: TextRange.empty,
        type: RichTextType.latex,
        rawText: source,
      );
      final newValue = delta.apply(oldValue);
      if (oldValue == newValue) continue;
      editController
        ..syncRichText(delta)
        ..value = newValue;
    }
  }
}
