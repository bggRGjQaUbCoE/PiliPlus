import 'dart:async';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
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
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  return Theme.of(context).colorScheme.secondaryContainer;
                }),
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
        title: SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  feedBack();
                  Get.toNamed(
                    '/member?mid=${_whisperDetailController.mid}',
                    arguments: {
                      'face': _whisperDetailController.face,
                      'heroTag': null
                    },
                  );
                },
                child: Row(
                  children: <Widget>[
                    NetworkImgLayer(
                      width: 34,
                      height: 34,
                      type: 'avatar',
                      src: _whisperDetailController.face,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _whisperDetailController.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 36, height: 36),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildList()),
          _buildInputView(),
          buildPanelContainer(Theme.of(context).colorScheme.onInverseSurface),
        ],
      ),
    );
  }

  Widget _buildList() {
    Widget resultWidget = Obx(
      () {
        List<MessageItem> messageList = _whisperDetailController.messageList;
        if (messageList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return refreshIndicator(
          onRefresh: _whisperDetailController.querySessionMsg,
          child: ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: messageList.length,
            itemBuilder: (context, int index) {
              return ChatItem(
                item: messageList[index],
                eInfos: _whisperDetailController.eInfos,
                onLongPress: messageList[index].senderUid ==
                        _whisperDetailController.ownerMid
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              clipBehavior: Clip.hardEdge,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 12, 0, 12),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Get.back();
                                      _whisperDetailController.sendMsg(
                                        message: '${messageList[index].msgKey}',
                                        onClearText: editController.clear,
                                        msgType: 5,
                                        index: index,
                                      );
                                    },
                                    dense: true,
                                    title: const Text('撤回',
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                  // ListTile(
                                  //   onTap: () {
                                  //     Get.back();
                                  //   },
                                  //   dense: true,
                                  //   title: const Text('删除',
                                  //       style: TextStyle(fontSize: 14)),
                                  // ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    : null,
              );
            },
            padding: const EdgeInsets.only(bottom: 20),
          ),
        );
      },
    );
    resultWidget = Listener(
      child: resultWidget,
      onPointerDown: (event) {
        // Hide panel when touch ListView.
        hidePanel();
      },
    );
    return resultWidget;
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
                        dynamic result = await MsgHttp.uploadBfs(
                          path: pickedFile.path,
                          biz: 'im',
                        );
                        if (result['status']) {
                          String mimeType = lookupMimeType(pickedFile.path)
                                  ?.split('/')
                                  .getOrNull(1) ??
                              'png';
                          dynamic picMsg = {
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
