import 'dart:async';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/msg/session.dart';
import 'package:PiliPlus/pages/common/common_publish_page.dart';
import 'package:PiliPlus/pages/emote/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';

import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/pages/whisper_detail/controller.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:image_picker/image_picker.dart';
import 'widget/chat_item.dart';

class WhisperDetailPage extends CommonPublishPage {
  const WhisperDetailPage({
    super.key,
    super.autofocus = false,
  });

  @override
  State<WhisperDetailPage> createState() => _WhisperDetailPageState();
}

class _WhisperDetailPageState
    extends CommonPublishPageState<WhisperDetailPage> {
  final _whisperDetailController = Get.put(
    WhisperDetailController(),
    tag: Utils.makeHeroTag(Get.parameters['talkerId']),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Center(
          child: SizedBox(
            width: 34,
            height: 34,
            child: IconButton(
              tooltip: '返回',
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
              onPressed: Get.back,
              icon: Icon(
                Icons.arrow_back_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
        title: GestureDetector(
          onTap: () {
            if (_whisperDetailController.mid != null) {
              feedBack();
              Get.toNamed(
                '/member?mid=${_whisperDetailController.mid}',
                arguments: {
                  'face': _whisperDetailController.face,
                },
              );
            }
          },
          child: Row(
            children: [
              NetworkImgLayer(
                width: 34,
                height: 34,
                type: 'avatar',
                src: _whisperDetailController.face,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _whisperDetailController.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Listener(
                child: Obx(() =>
                    _buildBody(_whisperDetailController.loadingState.value)),
                onPointerDown: (event) {
                  // Hide panel when touch ListView.
                  hidePanel();
                },
              ),
            ),
            _buildInputView(),
            buildPanelContainer(Theme.of(context).colorScheme.onInverseSurface),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<MessageItem>?> loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => loadingState.response?.isNotEmpty == true
          ? refreshIndicator(
              onRefresh: () async {
                await _whisperDetailController.onRefresh();
              },
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: loadingState.response!.length,
                padding: const EdgeInsets.only(bottom: 12),
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                controller: _whisperDetailController.scrollController,
                itemBuilder: (context, int index) {
                  if (index == loadingState.response!.length - 1) {
                    _whisperDetailController.onLoadMore();
                  }
                  final item = loadingState.response![index];
                  return ChatItem(
                    item: item,
                    eInfos: _whisperDetailController.eInfos,
                    onLongPress: item.senderUid ==
                            _whisperDetailController.ownerMid
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  clipBehavior: Clip.hardEdge,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          Get.back();
                                          _whisperDetailController.sendMsg(
                                            message: '${item.msgKey}',
                                            onClearText: editController.clear,
                                            msgType: 5,
                                            index: index,
                                          );
                                        },
                                        dense: true,
                                        title: const Text(
                                          '撤回',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        : null,
                  );
                },
              ),
            )
          : scrollErrorWidget(
              onReload: _whisperDetailController.onReload,
            ),
      Error() => scrollErrorWidget(
          errMsg: loadingState.errMsg,
          onReload: _whisperDetailController.onReload,
        ),
    };
  }

  Widget _buildInputView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onInverseSurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              updatePanelType(
                PanelType.emoji == currentPanelType
                    ? PanelType.keyboard
                    : PanelType.emoji,
              );
            },
            icon: const Icon(Icons.emoji_emotions),
            tooltip: '表情',
          ),
          Expanded(
            child: Listener(
              onPointerUp: (event) {
                // Currently it may be emojiPanel.
                if (readOnly.value) {
                  updatePanelType(PanelType.keyboard);
                }
              },
              child: Obx(
                () => TextField(
                  readOnly: readOnly.value,
                  focusNode: focusNode,
                  controller: editController,
                  minLines: 1,
                  maxLines: 4,
                  onChanged: (value) {
                    bool isNotEmpty = value.trim().isNotEmpty;
                    if (isNotEmpty && !enablePublish.value) {
                      enablePublish.value = true;
                    } else if (!isNotEmpty && enablePublish.value) {
                      enablePublish.value = false;
                    }
                  },
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '发个消息聊聊呗~',
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(6),
                      gapPadding: 0,
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () {
              return IconButton(
                onPressed: () async {
                  if (enablePublish.value) {
                    _whisperDetailController.sendMsg(
                      message: editController.text,
                      onClearText: editController.clear,
                    );
                  } else {
                    try {
                      XFile? pickedFile = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 100,
                      );
                      if (pickedFile != null) {
                        SmartDialog.showLoading(msg: '正在上传图片');
                        final result = await MsgHttp.uploadBfs(
                          path: pickedFile.path,
                          biz: 'im',
                        );
                        if (result['status']) {
                          String mimeType = lookupMimeType(pickedFile.path)
                                  ?.split('/')
                                  .getOrNull(1) ??
                              'jpg';
                          Map picMsg = {
                            'url': result['data']['image_url'],
                            'height': result['data']['image_height'],
                            'width': result['data']['image_width'],
                            'imageType': mimeType,
                            'original': 1,
                            'size': result['data']['img_size'] / 1024,
                          };
                          SmartDialog.showLoading(msg: '正在发送');
                          await _whisperDetailController.sendMsg(
                            picMsg: picMsg,
                            message: editController.text,
                            onClearText: editController.clear,
                          );
                        } else {
                          SmartDialog.dismiss();
                          SmartDialog.showToast(result['msg']);
                          return;
                        }
                      }
                    } catch (e) {
                      SmartDialog.showToast(e.toString());
                    }
                  }
                },
                icon: Icon(enablePublish.value
                    ? Icons.send
                    : Icons.add_photo_alternate_outlined),
                tooltip: enablePublish.value ? '发送' : '图片',
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget? customPanel(double height) => SizedBox(
        height: height,
        child: EmotePanel(onChoose: onChooseEmote),
      );

  @override
  Future onCustomPublish({required String message, List? pictures}) {
    throw UnimplementedError();
  }
}
