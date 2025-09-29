import 'dart:math' show max;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/button/toolbar_icon_button.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/draggable_sheet/draggable_scrollable_sheet_dyn.dart'
    as dyn_sheet;
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/text_field/controller.dart';
import 'package:PiliPlus/common/widgets/text_field/text_field.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/models/common/publish_panel_type.dart';
import 'package:PiliPlus/models/common/reply/reply_option_type.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reserve_info/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_top/topic_item.dart';
import 'package:PiliPlus/pages/common/publish/common_rich_text_pub_page.dart';
import 'package:PiliPlus/pages/dynamics_create_reserve/view.dart';
import 'package:PiliPlus/pages/dynamics_create_vote/view.dart';
import 'package:PiliPlus/pages/dynamics_mention/controller.dart';
import 'package:PiliPlus/pages/dynamics_select_topic/controller.dart';
import 'package:PiliPlus/pages/dynamics_select_topic/view.dart';
import 'package:PiliPlus/pages/emote/controller.dart';
import 'package:PiliPlus/pages/emote/view.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' hide DraggableScrollableSheet;
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class CreateDynPanel extends CommonRichTextPubPage {
  const CreateDynPanel({
    super.key,
    super.imageLengthLimit = 18,
    this.scrollController,
    this.topic,
  });

  final ScrollController? scrollController;
  final Pair<int, String>? topic;

  @override
  State<CreateDynPanel> createState() => _CreateDynPanelState();

  static void onCreateDyn(BuildContext context, {Pair<int, String>? topic}) =>
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (context) => dyn_sheet.DraggableScrollableSheet(
          snap: true,
          expand: false,
          initialChildSize: 1,
          minChildSize: 0,
          maxChildSize: 1,
          snapSizes: const [1],
          builder: (context, scrollController) => CreateDynPanel(
            scrollController: scrollController,
            topic: topic,
          ),
        ),
      );
}

class _CreateDynPanelState extends CommonRichTextPubPageState<CreateDynPanel> {
  final RxBool _isPrivate = false.obs;
  final Rx<DateTime?> _publishTime = Rx<DateTime?>(null);
  final Rx<ReplyOptionType> _replyOption = ReplyOptionType.allow.obs;
  final _titleEditCtr = TextEditingController();
  final Rx<Pair<int, String>?> topic = Rx<Pair<int, String>?>(null);
  final Rx<ReserveInfoData?> _reserveCard = Rx<ReserveInfoData?>(null);

  @override
  void initState() {
    super.initState();
    topic.value = widget.topic;
  }

  @override
  void dispose() {
    _titleEditCtr.dispose();
    Get
      ..delete<EmotePanelController>()
      ..delete<SelectTopicController>()
      ..delete<DynMentionController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAppBar(theme),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            controller: widget.scrollController,
            physics: const ClampingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () {
                    final hasTopic = topic.value != null;
                    return Row(
                      spacing: 10,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            overlayColor: hasTopic ? Colors.transparent : null,
                            splashFactory: hasTopic
                                ? NoSplash.splashFactory
                                : null,
                            shape: hasTopic
                                ? null
                                : RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: hasTopic
                                          ? Colors.transparent
                                          : theme.colorScheme.outline
                                                .withValues(alpha: 0.2),
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                  ),
                            minimumSize: Size.zero,
                            padding: hasTopic
                                ? const EdgeInsets.symmetric(vertical: 12)
                                : const EdgeInsets.all(12),
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: _onSelectTopic,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(
                                      CustomIcons.topic_tag,
                                      size: 18,
                                      color: hasTopic
                                          ? null
                                          : theme.colorScheme.outline,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: hasTopic ? topic.value!.second : '选择话题',
                                  style: TextStyle(
                                    color: hasTopic
                                        ? null
                                        : theme.colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (hasTopic)
                          iconButton(
                            size: 22,
                            iconSize: 16,
                            context: context,
                            icon: Icons.clear,
                            bgColor: theme.colorScheme.onInverseSurface,
                            iconColor: theme.colorScheme.onSurfaceVariant,
                            onPressed: () => topic.value = null,
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _titleEditCtr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: '标题，选填20字',
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: const OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.outline.withValues(alpha: 0.7),
                    ),
                  ),
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildEditWidget(theme),
              ),
              const SizedBox(height: 16),
              _buildReserveItem(theme),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => _buildPubtimeWidget),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => _buildReplyOptionWidget(theme)),
                        const SizedBox(height: 5),
                        Obx(() => _buildPrivateWidget(theme)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildImageList(theme),
            ],
          ),
        ),
        _buildToolbar,
        buildPanelContainer(theme, Colors.transparent),
      ],
    );
  }

  Widget _buildImageList(ThemeData theme) => SizedBox(
    height: 100,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              pathList.length,
              (index) => buildImage(index, 100),
            ),
            if (pathList.length != limit)
              Builder(
                builder: (context) {
                  const borderRadius = StyleString.mdRadius;
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
                        child: const Center(child: Icon(Icons.add, size: 35)),
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

  Widget _buildAppBar(ThemeData theme) => Container(
    height: 66,
    padding: const EdgeInsets.all(16),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 34,
            height: 34,
            child: IconButton(
              tooltip: '返回',
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                backgroundColor: WidgetStatePropertyAll(
                  theme.colorScheme.secondaryContainer,
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
              child: Text(_publishTime.value == null ? '发布' : '定时发布'),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildPrivateWidget(ThemeData theme) {
    final color = _isPrivate.value
        ? theme.colorScheme.error
        : theme.colorScheme.secondary;
    return PopupMenuButton<bool>(
      requestFocus: false,
      initialValue: _isPrivate.value,
      onSelected: (value) => _isPrivate.value = value,
      itemBuilder: (context) => List.generate(
        2,
        (index) => PopupMenuItem<bool>(
          enabled: _publishTime.value != null && index == 1 ? false : true,
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
              _isPrivate.value ? Icons.visibility_off : Icons.visibility,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              _isPrivate.value ? '仅自己可见' : '所有人可见',
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
    final color = _replyOption.value == ReplyOptionType.close
        ? theme.colorScheme.error
        : theme.colorScheme.secondary;
    return PopupMenuButton<ReplyOptionType>(
      requestFocus: false,
      initialValue: _replyOption.value,
      onSelected: (item) => _replyOption.value = item,
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
              _replyOption.value.iconData,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              _replyOption.value.title,
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

  Widget get _buildPubtimeWidget => _publishTime.value == null
      ? FilledButton.tonal(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            visualDensity: VisualDensity.compact,
          ),
          onPressed: _isPrivate.value
              ? null
              : () async {
                  controller.keepChatPanel();
                  DateTime nowDate = DateTime.now();
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: nowDate,
                    firstDate: nowDate,
                    lastDate: DateTime(
                      nowDate.year,
                      nowDate.month,
                      nowDate.day + 7,
                    ),
                  );
                  if (selectedDate != null && mounted) {
                    TimeOfDay nowTime = TimeOfDay.now();
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: nowTime.replacing(
                        hour: nowTime.minute + 6 >= 60
                            ? (nowTime.hour + 1) % 24
                            : nowTime.hour,
                        minute: (nowTime.minute + 6) % 60,
                      ),
                    );
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
                      _publishTime.value = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    }
                  }
                  controller.restoreChatPanel();
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
          onPressed: () => _publishTime.value = null,
          label: Text(DateFormatUtils.longFormatD.format(_publishTime.value!)),
          icon: const Icon(Icons.clear, size: 20),
          iconAlignment: IconAlignment.end,
        );

  Widget get _buildToolbar => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      spacing: 16,
      children: [
        emojiBtn,
        atBtn,
        voteBtn,
        moreBtn,
        // if (kDebugMode)
        //   ToolbarIconButton(
        //     onPressed: editController.clear,
        //     icon: const Icon(Icons.clear, size: 22),
        //     selected: false,
        //   ),
      ],
    ),
  );

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
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      );
    }

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
        padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
        gridDelegate: gridDelegate,
        children: [
          item(
            onTap: _onReserve,
            icon: Icon(CustomIcons.live_reserve, size: 28, color: color),
            title: '直播预约',
          ),
        ],
      ),
    );
  }

  Widget get voteBtn => ToolbarIconButton(
    onPressed: () async {
      controller.keepChatPanel();
      RichTextItem? voteItem = editController.items.firstWhereOrNull(
        (e) => e.type == RichTextType.vote,
      );
      VoteInfo? voteInfo = await Navigator.of(context).push(
        GetPageRoute(
          page: () => CreateVotePage(
            voteId: voteItem?.id == null ? null : int.parse(voteItem!.id!),
          ),
        ),
      );
      if (voteInfo != null) {
        if (voteItem != null) {
          final range = voteItem.range;
          final text = ' ${voteInfo.title} ';
          final selection = TextSelection.collapsed(
            offset: range.start + text.length,
          );
          final delta = RichTextEditingDeltaReplacement(
            oldText: editController.text,
            replacementText: text,
            replacedRange: range,
            selection: selection,
            composing: TextRange.empty,
            type: RichTextType.vote,
            id: voteInfo.voteId.toString(),
            rawText: voteInfo.title,
          );
          final newValue = delta.apply(editController.value);
          editController
            ..syncRichText(delta)
            ..value = newValue;
        } else {
          onInsertText(
            '我发起了一个投票',
            RichTextType.text,
          );
          onInsertText(
            ' ${voteInfo.title} ',
            RichTextType.vote,
            rawText: voteInfo.title,
            id: voteInfo.voteId.toString(),
          );
        }
      }
      controller.restoreChatPanel();
    },
    icon: const Icon(Icons.bar_chart_rounded, size: 24),
    tooltip: '投票',
    selected: false,
  );

  Widget _buildEditWidget(ThemeData theme) => Form(
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
          maxLines: null,
          focusNode: focusNode,
          readOnly: readOnly.value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '说点什么吧',
            hintStyle: TextStyle(color: theme.colorScheme.outline),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
            contentPadding: EdgeInsets.zero,
          ),
          // inputFormatters: [LengthLimitingTextInputFormatter(1000)],
        ),
      ),
    ),
  );

  @override
  Widget? get customPanel => EmotePanel(onChoose: onChooseEmote);

  @override
  Future<void> onCustomPublish({List? pictures}) async {
    SmartDialog.showLoading(msg: '正在发布');
    List<Map<String, dynamic>>? extraContent = getRichContent();
    final hasRichText = extraContent != null;
    final reserveCard = _reserveCard.value;
    var result = await DynamicsHttp.createDynamic(
      mid: Accounts.main.mid,
      rawText: hasRichText ? null : editController.text,
      pics: pictures,
      publishTime: _publishTime.value != null
          ? _publishTime.value!.millisecondsSinceEpoch ~/ 1000
          : null,
      replyOption: _replyOption.value,
      privatePub: _isPrivate.value ? 1 : null,
      title: _titleEditCtr.text,
      topic: topic.value,
      extraContent: extraContent,
      attachCard: reserveCard == null
          ? null
          : {
              "common_card": {
                "type": 14,
                "biz_id": reserveCard.id,
                "reserve_source": 0,
                "reserve_lottery": 0,
              },
            },
    );
    SmartDialog.dismiss();
    if (result['status']) {
      hasPub = true;
      Get.back();
      SmartDialog.showToast('发布成功');
      var id = result['data']?['dyn_id'];
      RequestUtils.insertCreatedDyn(id);
      if (!_isPrivate.value) {
        RequestUtils.checkCreatedDyn(
          id: id,
          dynText: editController.rawText,
        );
      }
    } else {
      SmartDialog.showToast(result['msg']);
      if (kDebugMode) debugPrint('failed to publish: ${result['msg']}');
    }
  }

  double _topicOffset = 0;
  Future<void> _onSelectTopic() async {
    controller.keepChatPanel();
    TopicItem? res = await SelectTopicPanel.onSelectTopic(
      context,
      offset: _topicOffset,
      callback: (offset) => _topicOffset = offset,
    );
    if (res != null) {
      topic.value = Pair(first: res.id, second: res.name);
    }
    controller.restoreChatPanel();
  }

  @override
  void onSave() {}

  Widget _buildReserveItem(ThemeData theme) {
    return Obx(
      () {
        final reserveCard = _reserveCard.value;
        if (reserveCard == null) {
          return const SizedBox.shrink();
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: _onReserve,
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: theme.colorScheme.onInverseSurface,
                ),
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                padding: const EdgeInsets.fromLTRB(12, 12, 30, 12),
                child: Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('直播预约: ${reserveCard.title}'),
                    Text(
                      '${DateFormatUtils.longFormatD.format(
                        DateTime.fromMillisecondsSinceEpoch(reserveCard.livePlanStartTime! * 1000),
                      )} 直播',
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 18,
              top: 2,
              child: iconButton(
                context: context,
                size: 30,
                iconSize: 18,
                icon: Icons.clear,
                onPressed: () => _reserveCard.value = null,
                bgColor: Colors.transparent,
                iconColor: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onReserve() async {
    controller.keepChatPanel();
    ReserveInfoData? reserveInfo = await Navigator.of(context).push(
      GetPageRoute(
        page: () => CreateReservePage(sid: _reserveCard.value?.id),
      ),
    );
    if (reserveInfo != null) {
      _reserveCard.value = reserveInfo;
    }
    controller.restoreChatPanel();
  }
}
