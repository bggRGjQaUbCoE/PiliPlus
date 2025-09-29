import 'dart:io';

import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/button/toolbar_icon_button.dart';
import 'package:PiliPlus/common/widgets/text_field/controller.dart';
import 'package:PiliPlus/common/widgets/text_field/text_field.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/publish_panel_type.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/item.dart';
import 'package:PiliPlus/models_new/emote/emote.dart' as e;
import 'package:PiliPlus/models_new/live/live_emote/emoticon.dart';
import 'package:PiliPlus/models_new/upload_bfs/data.dart';
import 'package:PiliPlus/pages/common/publish/common_publish_page.dart';
import 'package:PiliPlus/pages/dynamics_mention/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:dio/dio.dart' show CancelToken;
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

abstract class CommonRichTextPubPage
    extends CommonPublishPage<List<RichTextItem>> {
  const CommonRichTextPubPage({
    super.key,
    this.items,
    super.onSave,
    super.autofocus,
    super.imageLengthLimit,
  });

  final List<RichTextItem>? items;
}

abstract class CommonRichTextPubPageState<T extends CommonRichTextPubPage>
    extends CommonPublishPageState<T> {
  final key = GlobalKey<RichTextFieldState>();
  late final imagePicker = ImagePicker();
  late final RxList<String> pathList = <String>[].obs;
  int get limit => widget.imageLengthLimit ?? 9;

  @override
  late final RichTextEditingController editController =
      RichTextEditingController(
        items: widget.items,
        onMention: onMention,
      );

  @override
  void initPubState() {
    if (editController.rawText.trim().isNotEmpty) {
      enablePublish.value = true;
    }
  }

  @override
  void dispose() {
    if (Utils.isMobile) {
      for (var i in pathList) {
        File(i).tryDel();
      }
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    editController.richStyle = null;
    super.didChangeDependencies();
  }

  Widget buildImage(int index, double height) {
    final color = Theme.of(
      context,
    ).colorScheme.secondaryContainer.withValues(alpha: 0.5);

    void onClear() {
      pathList.removeAt(index);
      if (pathList.isEmpty && editController.rawText.trim().isEmpty) {
        enablePublish.value = false;
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () async {
            controller.keepChatPanel();
            await PageUtils.imageView(
              imgList: pathList
                  .map(
                    (path) => SourceModel(
                      url: path,
                      sourceType: SourceType.fileImage,
                    ),
                  )
                  .toList(),
              initialPage: index,
            );
            controller.restoreChatPanel();
          },
          onLongPress: Utils.isMobile ? onClear : null,
          onSecondaryTap: Utils.isMobile ? null : onClear,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: Image(
              height: height,
              fit: BoxFit.fitHeight,
              filterQuality: FilterQuality.low,
              image: FileImage(File(pathList[index])),
            ),
          ),
        ),
        if (Utils.isMobile)
          Positioned(
            top: 34,
            right: 5,
            child: iconButton(
              context: context,
              icon: Icons.edit,
              onPressed: () => onCropImage(index),
              size: 24,
              iconSize: 14,
              bgColor: color,
            ),
          ),
        Positioned(
          top: 5,
          right: 5,
          child: iconButton(
            context: context,
            icon: Icons.clear,
            onPressed: onClear,
            size: 24,
            iconSize: 14,
            bgColor: color,
          ),
        ),
      ],
    );
  }

  Future<void> onCropImage(int index) async {
    late final colorScheme = ColorScheme.of(context);
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: pathList[index],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '裁剪',
          toolbarColor: colorScheme.secondaryContainer,
          toolbarWidgetColor: colorScheme.onSecondaryContainer,
          statusBarLight: colorScheme.isLight,
        ),
        IOSUiSettings(title: '裁剪'),
      ],
    );
    if (croppedFile != null) {
      pathList[index] = croppedFile.path;
    }
  }

  void onPickImage([VoidCallback? callback]) {
    EasyThrottle.throttle(
      'imagePicker',
      const Duration(milliseconds: 500),
      () async {
        try {
          List<XFile> pickedFiles = await imagePicker.pickMultiImage(
            limit: limit,
            imageQuality: 100,
          );
          if (pickedFiles.isNotEmpty) {
            for (int i = 0; i < pickedFiles.length; i++) {
              if (pathList.length == limit) {
                SmartDialog.showToast('最多选择$limit张图片');
                break;
              } else {
                pathList.add(pickedFiles[i].path);
              }
            }
            callback?.call();
          }
        } catch (e) {
          SmartDialog.showToast(e.toString());
        }
      },
    );
  }

  void onChooseEmote(dynamic emote, double? width, double? height) {
    if (emote is e.Emote) {
      final isTextEmote = width == null;
      onInsertText(
        isTextEmote ? emote.text! : '\uFFFC',
        RichTextType.emoji,
        rawText: emote.text!,
        emote: isTextEmote
            ? null
            : Emote(
                url: emote.url!,
                width: width,
                height: height,
              ),
      );
    } else if (emote is Emoticon) {
      onInsertText(
        '\uFFFC',
        RichTextType.emoji,
        rawText: emote.emoji!,
        emote: Emote(
          url: emote.url!,
          width: width!,
          height: height,
        ),
      );
    }
  }

  List<Map<String, dynamic>>? getRichContent() {
    if (editController.items.isEmpty) return null;
    final list = <Map<String, dynamic>>[];
    for (var e in editController.items) {
      switch (e.type) {
        case RichTextType.text || RichTextType.composing || RichTextType.common:
          list.add({
            "raw_text": e.text,
            "type": 1,
            "biz_id": "",
          });
        case RichTextType.at:
          list.add({
            "raw_text": '@${e.rawText}',
            "type": 2,
            "biz_id": e.id,
          });
        case RichTextType.emoji:
          list.add({
            "raw_text": e.rawText,
            "type": 9,
            "biz_id": "",
          });
        case RichTextType.vote:
          list
            ..add({
              "raw_text": e.rawText,
              "type": 4,
              "biz_id": e.id,
            })
            ..add({
              "raw_text": ' ',
              "type": 1,
              "biz_id": "",
            });
      }
    }
    return list;
  }

  late double _mentionOffset = 0;
  Future<void> onMention([bool fromClick = false]) async {
    controller.keepChatPanel();
    final res = await DynMentionPanel.onDynMention(
      context,
      offset: _mentionOffset,
      callback: (offset) => _mentionOffset = offset,
    );
    if (res != null) {
      if (res is MentionItem) {
        _onInsertUser(res, fromClick);
      } else if (res is Set<MentionItem>) {
        for (var e in res) {
          e.checked = null;
          _onInsertUser(e, fromClick);
        }
        res.clear();
      }
    }
    controller.restoreChatPanel();
  }

  void _onInsertUser(MentionItem e, bool fromClick) {
    onInsertText(
      '@${e.name} ',
      RichTextType.at,
      rawText: e.name,
      id: e.uid,
      fromClick: fromClick,
    );
  }

  void onInsertText(
    String text,
    RichTextType type, {
    String? rawText,
    Emote? emote,
    String? id,
    bool? fromClick,
  }) {
    if (text.isEmpty) {
      return;
    }

    enablePublish.value = true;

    var oldValue = editController.value;
    final selection = oldValue.selection;

    if (selection.isValid) {
      TextEditingDelta delta;

      if (selection.isCollapsed) {
        if (type == RichTextType.at && fromClick == false) {
          delta = RichTextEditingDeltaReplacement(
            oldText: oldValue.text,
            replacementText: text,
            replacedRange: TextRange(
              start: selection.start - 1,
              end: selection.end,
            ),
            selection: TextSelection.collapsed(
              offset: selection.start - 1 + text.length,
            ),
            composing: TextRange.empty,
            rawText: rawText,
            type: type,
            emote: emote,
            id: id,
          );
        } else {
          delta = RichTextEditingDeltaInsertion(
            oldText: oldValue.text,
            textInserted: text,
            insertionOffset: selection.start,
            selection: TextSelection.collapsed(
              offset: selection.start + text.length,
            ),
            composing: TextRange.empty,
            rawText: rawText,
            type: type,
            emote: emote,
            id: id,
          );
        }
      } else {
        delta = RichTextEditingDeltaReplacement(
          oldText: oldValue.text,
          replacementText: text,
          replacedRange: selection,
          selection: TextSelection.collapsed(
            offset: selection.start + text.length,
          ),
          composing: TextRange.empty,
          rawText: rawText,
          type: type,
          emote: emote,
          id: id,
        );
      }

      final newValue = delta.apply(oldValue);

      if (oldValue == newValue) {
        return;
      }

      editController
        ..syncRichText(delta)
        ..value = newValue;
    } else {
      editController.items
        ..clear()
        ..add(
          RichTextItem(
            type: type,
            text: text,
            rawText: rawText,
            range: TextRange(
              start: 0,
              end: text.length,
            ),
            emote: emote,
            id: id,
          ),
        );
      editController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    key.currentState?.scheduleShowCaretOnScreen(withAnimation: true);
  }

  @override
  void onSave() => widget.onSave?.call(editController.items);

  Widget get emojiBtn => Obx(
    () {
      final isEmoji = panelType.value == PanelType.emoji;
      return ToolbarIconButton(
        tooltip: isEmoji ? '输入' : '表情',
        onPressed: () {
          if (isEmoji) {
            updatePanelType(PanelType.keyboard);
          } else {
            updatePanelType(PanelType.emoji);
          }
        },
        icon: isEmoji
            ? const Icon(Icons.keyboard, size: 22)
            : const Icon(Icons.emoji_emotions, size: 22),
        selected: isEmoji,
      );
    },
  );

  Widget get atBtn => ToolbarIconButton(
    onPressed: () => onMention(true),
    icon: const Icon(Icons.alternate_email, size: 22),
    tooltip: '@',
    selected: false,
  );

  Widget get moreBtn => Obx(
    () {
      final isMore = panelType.value == PanelType.more;
      return ToolbarIconButton(
        tooltip: isMore ? '输入' : '更多',
        onPressed: () {
          if (isMore) {
            updatePanelType(PanelType.keyboard);
          } else {
            updatePanelType(PanelType.more);
          }
        },
        icon: isMore
            ? const Icon(Icons.keyboard, size: 22)
            : const Icon(Icons.add_circle_outline, size: 22),
        selected: isMore,
      );
    },
  );

  @override
  Future<void> onPublish() async {
    feedBack();
    List<Map<String, dynamic>>? pictures;
    if (pathList.isNotEmpty) {
      SmartDialog.showLoading(msg: '正在上传图片...');
      final cancelToken = CancelToken();
      try {
        pictures = await Future.wait<Map<String, dynamic>>(
          pathList.map((path) async {
            Map result = await MsgHttp.uploadBfs(
              path: path,
              category: 'daily',
              biz: 'new_dyn',
              cancelToken: cancelToken,
            );
            if (!result['status']) throw HttpException(result['msg']);
            UploadBfsResData data = result['data'];
            return {
              'img_width': data.imageWidth,
              'img_height': data.imageHeight,
              'img_size': data.imgSize,
              'img_src': data.imageUrl,
            };
          }),
          eagerError: true,
        );
        SmartDialog.dismiss();
      } on HttpException catch (e) {
        cancelToken.cancel();
        SmartDialog.dismiss();
        SmartDialog.showToast(e.message);
        return;
      }
    }
    onCustomPublish(pictures: pictures);
  }
}
