import 'package:PiliPlus/common/widgets/button/toolbar_icon_button.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/common/publish_panel_type.dart';
import 'package:PiliPlus/models/common/reply/reply_option_type.dart';
import 'package:PiliPlus/pages/common/common_publish_page.dart';
import 'package:PiliPlus/pages/emote/controller.dart';
import 'package:PiliPlus/pages/emote/view.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateDynPanel extends CommonPublishPage {
  const CreateDynPanel({
    super.key,
    super.imageLengthLimit = 18,
  });

  @override
  State<CreateDynPanel> createState() => _CreateDynPanelState();
}

class _CreateDynPanelState extends CommonPublishPageState<CreateDynPanel> {
  bool _isPrivate = false;
  DateTime? _publishTime;
  ReplyOptionType _replyOption = ReplyOptionType.allow;

  @override
  void dispose() {
    try {
      Get.delete<EmotePanelController>();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(theme),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildEditWidget,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPubtimeWidget,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildReplyOptionWidget(theme),
                          const SizedBox(height: 5),
                          _buildPrivateWidget(theme),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildImageList(theme),
                const SizedBox(height: 2),
              ],
            ),
          ),
          _buildToolbar,
          buildPanelContainer(Colors.transparent),
        ],
      ),
    );
  }

  Widget _buildImageList(ThemeData theme) => Obx(
        () => SizedBox(
          height: 100,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                    pathList.length, (index) => buildImage(index, 100)),
                if (pathList.length != limit)
                  Builder(
                    builder: (context) {
                      const borderRadius =
                          BorderRadius.all(Radius.circular(10));
                      return Material(
                        borderRadius: borderRadius,
                        child: InkWell(
                          borderRadius: borderRadius,
                          onTap: () => onPickImage(() {
                            if (pathList.isNotEmpty && !enablePublish.value) {
                              enablePublish.value = true;
                            }
                          }),
                          child: Ink(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              color: theme.colorScheme.secondaryContainer,
                            ),
                            child:
                                const Center(child: Icon(Icons.add, size: 35)),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      );

  PreferredSizeWidget _buildAppBar(ThemeData theme) => PreferredSize(
        preferredSize: const Size.fromHeight(66),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 34,
                  height: 34,
                  child: IconButton(
                    tooltip: '返回',
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      backgroundColor: WidgetStateProperty.resolveWith(
                        (states) {
                          return theme.colorScheme.secondaryContainer;
                        },
                      ),
                    ),
                    onPressed: Get.back,
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      size: 18,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  '发布动态',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Obx(
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
                    child: Text(_publishTime == null ? '发布' : '定时发布'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildPrivateWidget(ThemeData theme) {
    final color =
        _isPrivate ? theme.colorScheme.error : theme.colorScheme.secondary;
    return PopupMenuButton(
      initialValue: _isPrivate,
      onOpened: controller.keepChatPanel,
      onSelected: (value) {
        setState(() {
          _isPrivate = value;
        });
      },
      itemBuilder: (context) => List.generate(
        2,
        (index) => PopupMenuItem<bool>(
          enabled: _publishTime != null && index == 1 ? false : true,
          value: index == 0 ? false : true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                size: 19,
                index == 0 ? Icons.visibility : Icons.visibility_off,
              ),
              const SizedBox(width: 4),
              Text(index == 0 ? '所有人可见' : '仅自己可见'),
            ],
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              size: 19,
              _isPrivate ? Icons.visibility_off : Icons.visibility,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              _isPrivate ? '仅自己可见' : '所有人可见',
              style: TextStyle(
                height: 1,
                color: color,
              ),
              strutStyle: const StrutStyle(leading: 0, height: 1),
            ),
            Icon(
              size: 20,
              Icons.keyboard_arrow_right,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyOptionWidget(ThemeData theme) {
    final color = _replyOption == ReplyOptionType.close
        ? theme.colorScheme.error
        : theme.colorScheme.secondary;
    return PopupMenuButton(
      initialValue: _replyOption,
      onOpened: controller.keepChatPanel,
      onSelected: (item) {
        setState(() {
          _replyOption = item;
        });
      },
      itemBuilder: (context) => ReplyOptionType.values
          .map(
            (item) => PopupMenuItem<ReplyOptionType>(
              value: item,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    size: 19,
                    item.iconData,
                  ),
                  const SizedBox(width: 4),
                  Text(item.title),
                ],
              ),
            ),
          )
          .toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              size: 19,
              _replyOption.iconData,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              _replyOption.title,
              style: TextStyle(
                height: 1,
                color: color,
              ),
              strutStyle: const StrutStyle(leading: 0, height: 1),
            ),
            Icon(
              size: 20,
              Icons.keyboard_arrow_right,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _buildPubtimeWidget => _publishTime == null
      ? FilledButton.tonal(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            visualDensity: VisualDensity.compact,
          ),
          onPressed: _isPrivate
              ? null
              : () {
                  DateTime nowDate = DateTime.now();
                  showDatePicker(
                    context: context,
                    initialDate: nowDate,
                    firstDate: nowDate,
                    lastDate: DateTime(
                      nowDate.year,
                      nowDate.month,
                      nowDate.day + 7,
                    ),
                  ).then(
                    (selectedDate) {
                      if (selectedDate != null && mounted) {
                        TimeOfDay nowTime = TimeOfDay.now();
                        showTimePicker(
                          context: context,
                          initialTime: nowTime.replacing(
                            hour: nowTime.minute + 6 >= 60
                                ? (nowTime.hour + 1) % 24
                                : nowTime.hour,
                            minute: (nowTime.minute + 6) % 60,
                          ),
                        ).then((selectedTime) {
                          if (selectedTime != null) {
                            if (selectedDate.day == nowDate.day) {
                              if (selectedTime.hour < nowTime.hour) {
                                SmartDialog.showToast('时间设置错误，至少选择6分钟之后');
                                return;
                              } else if (selectedTime.hour == nowTime.hour) {
                                if (selectedTime.minute < nowTime.minute + 6) {
                                  if (selectedDate.day == nowDate.day) {
                                    SmartDialog.showToast('时间设置错误，至少选择6分钟之后');
                                  }
                                  return;
                                }
                              }
                            }
                            setState(() {
                              _publishTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                            });
                          }
                        });
                      }
                    },
                  );
                },
          child: const Text('定时发布'),
        )
      : OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            visualDensity: VisualDensity.compact,
          ),
          onPressed: () => setState(() => _publishTime = null),
          label: Text(DateFormat('yyyy-MM-dd HH:mm').format(_publishTime!)),
          icon: const Icon(Icons.clear, size: 20),
          iconAlignment: IconAlignment.end,
        );

  Widget get _buildToolbar => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Obx(
              () => ToolbarIconButton(
                onPressed: () {
                  selectKeyboard.value = PanelType.emoji == currentPanelType;
                  updatePanelType(
                    PanelType.emoji == currentPanelType
                        ? PanelType.keyboard
                        : PanelType.emoji,
                  );
                },
                icon: const Icon(Icons.emoji_emotions, size: 22),
                tooltip: '表情',
                selected: !selectKeyboard.value,
              ),
            ),
          ],
        ),
      );

  Widget get _buildEditWidget => Form(
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
              maxLines: null,
              focusNode: focusNode,
              readOnly: readOnly.value,
              onChanged: (value) {
                bool isEmpty = value.trim().isEmpty && pathList.isEmpty;
                if (!isEmpty && !enablePublish.value) {
                  enablePublish.value = true;
                } else if (isEmpty && enablePublish.value) {
                  enablePublish.value = false;
                }
              },
              decoration: const InputDecoration(
                hintText: '说点什么吧',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  gapPadding: 0,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      );

  @override
  Widget? get customPanel => EmotePanel(onChoose: onChooseEmote);

  @override
  Future<void> onCustomPublish(
      {required String message, List? pictures}) async {
    SmartDialog.showLoading(msg: '正在发布');
    dynamic result = await MsgHttp.createDynamic(
      mid: Accounts.main.mid,
      rawText: editController.text,
      pics: pictures,
      publishTime: _publishTime != null
          ? _publishTime!.millisecondsSinceEpoch ~/ 1000
          : null,
      replyOption: _replyOption,
      privatePub: _isPrivate ? 1 : null,
    );
    SmartDialog.dismiss();
    if (result['status']) {
      Get.back();
      SmartDialog.showToast('发布成功');
      RequestUtils.insertCreatedDyn(result);
      RequestUtils.checkCreatedDyn(
        id: result['data']?['dyn_id'],
        dynText: editController.text,
      );
    } else {
      SmartDialog.showToast(result['msg']);
      debugPrint('failed to publish: ${result['msg']}');
    }
  }
}
