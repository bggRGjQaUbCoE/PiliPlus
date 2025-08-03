import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:PiliPlus/pages/dynamics_create_vote/controller.dart';
import 'package:PiliPlus/utils/date_util.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateVotePage extends StatefulWidget {
  const CreateVotePage({super.key, this.voteId});

  final int? voteId;

  @override
  State<CreateVotePage> createState() => _CreateVotePageState();
}

class _CreateVotePageState extends State<CreateVotePage> {
  late final _controller = Get.put(
    CreateVoteController(widget.voteId),
    tag: Utils.generateRandomString(8),
  );
  late final imagePicker = ImagePicker();

  late TextStyle _leadingStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _leadingStyle = TextStyle(
      fontSize: 15,
      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
    );
    final padding = MediaQuery.paddingOf(context);
    final divider = Divider(
      height: 20,
      thickness: 1,
      color: theme.colorScheme.outline.withValues(alpha: 0.1),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('${_controller.voteId != null ? '' : '发起'}投票'),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: padding.left + 16,
          right: padding.right + 16,
          bottom: padding.bottom + 80,
        ),
        children: [
          const Text(
            '投票类型',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          _buildType(theme),
          const SizedBox(height: 40),
          Obx(
            () => _buildInput(
              theme,
              key: ValueKey('${_controller.key}title'),
              initialValue: _controller.title.value,
              onChanged: (value) => _controller
                ..title.value = value
                ..updateCanCreate(),
              desc: '投票标题',
              hintText: '请填写标题',
              inputFormatters: [LengthLimitingTextInputFormatter(32)],
            ),
          ),
          divider,
          Obx(
            () => _buildInput(
              theme,
              key: ValueKey('${_controller.key}desc'),
              initialValue: _controller.desc.value,
              onChanged: (value) => _controller.desc.value = value,
              desc: '投票说明',
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
            ),
          ),
          divider,
          const SizedBox(height: 40),
          Obx(
            () {
              final showImg = _controller.type.value == 1;
              final showDel = _controller.options.length > 2;
              List<Widget> children = [];
              for (int i = 0; i < _controller.options.length; i++) {
                final e = _controller.options[i];
                children
                  ..add(
                    _buildInput(
                      theme,
                      key: ObjectKey(e),
                      showDel: showDel,
                      onDel: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _controller.onDel(i);
                      },
                      showImg: showImg,
                      imgUrl: e.imgUrl,
                      onPickImg: () => EasyThrottle.throttle(
                        'picImg',
                        const Duration(milliseconds: 500),
                        () => _onPickImg(i),
                      ),
                      initialValue: e.optDesc,
                      onChanged: (value) => _controller
                        ..options[i].optDesc = value
                        ..updateCanCreate(),
                      desc: '选项${i + 1}',
                      hintText: '选项内容，最多20字',
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    ),
                  )
                  ..add(divider);
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...children,
                  if (_controller.options.length < 20)
                    FilledButton(
                      onPressed: () => _controller
                        ..options.add(Option(optDesc: '', imgUrl: ''))
                        ..updateCanCreate(),
                      style: FilledButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 14,
                          top: 4,
                          bottom: 4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: theme.colorScheme.onSurfaceVariant,
                        backgroundColor: theme.colorScheme.onInverseSurface,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 16),
                          Text(
                            ' 添加选项',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 40),
          Row(
            spacing: 12,
            children: [
              SizedBox(
                width: 100,
                child: Text('单选/多选', style: _leadingStyle),
              ),
              Obx(() {
                final choiceCnt = _controller.choiceCnt.value;
                final choices = List.generate(
                  _controller.options.length,
                  (i) => i + 1,
                );
                return Listener(
                  onPointerDown: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  child: PopupMenuButton<int>(
                    initialValue: choiceCnt,
                    requestFocus: false,
                    child: Text(
                      choiceCnt == 1 ? '单选         ' : '最多选$choiceCnt项',
                    ),
                    onSelected: (value) => _controller.choiceCnt.value = value,
                    itemBuilder: (context) {
                      return choices
                          .map(
                            (e) => PopupMenuItem(
                              value: e,
                              child: Text(e == 1 ? '单选' : '最多选$e项'),
                            ),
                          )
                          .toList();
                    },
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 4),
          divider,
          Row(
            spacing: 12,
            children: [
              SizedBox(
                width: 100,
                child: Text('投票截止时间', style: _leadingStyle),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: _controller.endtime.value,
                    firstDate: _controller.now,
                    lastDate: _controller.end,
                  );
                  if (newDate != null && context.mounted) {
                    TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        _controller.endtime.value,
                      ),
                    );
                    if (newTime != null) {
                      final newEndtime = DateTime(
                        newDate.year,
                        newDate.month,
                        newDate.day,
                        newTime.hour,
                        newTime.minute,
                      );
                      if (newEndtime.difference(DateTime.now()) >=
                          const Duration(minutes: 5)) {
                        _controller.endtime.value = newEndtime;
                      } else {
                        SmartDialog.showToast('至少选择5分钟之后');
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Obx(
                    () => Text(
                      DateUtil.longFormatD.format(_controller.endtime.value),
                    ),
                  ),
                ),
              ),
            ],
          ),
          divider,
          const SizedBox(height: 40),
          Obx(() {
            final canCreate = _controller.canCreate.value;
            return FilledButton.tonal(
              onPressed: canCreate ? _controller.onCreate : null,
              child: const Text('发起投票'),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInput(
    ThemeData theme, {
    Key? key,
    String? initialValue,
    required ValueChanged<String> onChanged,
    required String desc,
    String? hintText,
    List<TextInputFormatter>? inputFormatters,
    bool showDel = false,
    bool showImg = false,
    String? imgUrl,
    VoidCallback? onDel,
    VoidCallback? onPickImg,
  }) {
    return Row(
      spacing: 12,
      children: [
        SizedBox(
          width: 65,
          child: Text(
            desc,
            style: _leadingStyle,
          ),
        ),
        Expanded(
          child: TextFormField(
            key: key,
            initialValue: initialValue,
            onChanged: onChanged,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: hintText ?? desc,
              hintStyle: TextStyle(
                fontSize: 15,
                color: theme.colorScheme.outline.withValues(alpha: 0.7),
              ),
            ),
            inputFormatters: inputFormatters,
          ),
        ),
        if (showImg)
          GestureDetector(
            onTap: onPickImg,
            child: NetworkImgLayer(
              src: imgUrl,
              width: 40,
              height: 40,
              radius: 6,
            ),
          ),
        if (showDel)
          iconButton(
            size: 26,
            iconSize: 18,
            tooltip: '移除',
            context: context,
            icon: Icons.clear,
            onPressed: onDel,
            bgColor: Colors.transparent,
            iconColor: theme.colorScheme.onSurfaceVariant,
          ),
      ],
    );
  }

  Widget _buildType(ThemeData theme) => Obx(
    () {
      return Row(
        spacing: 16,
        children: List.generate(
          2,
          (index) {
            final isEnable = index == _controller.type.value;
            final style = TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isEnable
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              backgroundColor: isEnable
                  ? theme.colorScheme.secondaryContainer
                  : Colors.transparent,
              foregroundColor: isEnable
                  ? theme.colorScheme.onSecondaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            );
            Widget child = TextButton(
              style: style,
              onPressed: () => _controller
                ..type.value = index
                ..updateCanCreate(),
              child: Text(
                '${const ['文字', '图片'][index]}投票',
                strutStyle: const StrutStyle(forceStrutHeight: true),
              ),
            );
            if (isEnable) {
              child = Stack(
                clipBehavior: Clip.none,
                children: [
                  child,
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomRight: Radius.circular(6),
                        ),
                        color: theme.colorScheme.primary,
                      ),
                      child: Icon(
                        size: 10,
                        Icons.check,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              );
            }
            return child;
          },
        ),
      );
    },
  );

  void _onPickImg(int index) {
    EasyThrottle.throttle(
      'imagePicker',
      const Duration(milliseconds: 500),
      () async {
        try {
          XFile? pickedFile = await imagePicker.pickImage(
            imageQuality: 100,
            source: ImageSource.gallery,
          );
          if (pickedFile != null) {
            _controller.onUpload(index, pickedFile);
          }
        } catch (e) {
          SmartDialog.showToast(e.toString());
        }
      },
    );
  }
}
