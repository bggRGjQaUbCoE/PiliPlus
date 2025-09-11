import 'package:PiliPlus/pages/dynamics_create_reserve/controller.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show TextInputFormatter, LengthLimitingTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class CreateReservePage extends StatefulWidget {
  const CreateReservePage({super.key, this.sid});

  final int? sid;

  @override
  State<CreateReservePage> createState() => _CreateReservePageState();
}

class _CreateReservePageState extends State<CreateReservePage> {
  late final _controller = Get.put(
    CreateReserveController(widget.sid),
    tag: Utils.generateRandomString(6),
  );
  late TextStyle _leadingStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _leadingStyle = TextStyle(
      fontSize: 15,
      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
    );
    final padding = MediaQuery.viewPaddingOf(context);
    final divider = [
      const SizedBox(height: 10),
      Divider(
        height: 1,
        color: theme.colorScheme.outline.withValues(alpha: 0.1),
      ),
      const SizedBox(height: 10),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('添加直播预约')),
      body: ListView(
        padding: EdgeInsets.only(
          top: 16,
          left: padding.left + 16,
          right: padding.right + 16,
          bottom: padding.bottom + 100,
        ),
        children: [
          Row(
            spacing: 12,
            children: [
              SizedBox(
                width: 65,
                child: Text('类型', style: _leadingStyle),
              ),
              Obx(
                () => PopupMenuButton(
                  requestFocus: false,
                  initialValue: _controller.subType.value,
                  onSelected: (value) => _controller.subType.value = value,
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(
                        value: 0,
                        child: Text('公开直播'),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text('大航海直播'),
                      ),
                    ];
                  },
                  child: Text(
                    _controller.subType.value == 0 ? '公开直播' : '大航海直播',
                  ),
                ),
              ),
            ],
          ),
          ...divider,
          Row(
            spacing: 12,
            children: [
              SizedBox(
                width: 65,
                child: Text('时间', style: _leadingStyle),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: _controller.date.value,
                      firstDate: _controller.now,
                      lastDate: _controller.end,
                    );
                    if (newDate != null && context.mounted) {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          _controller.date.value,
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
                          _controller.date.value = newEndtime;
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
                        DateFormatUtils.longFormatD.format(_controller.date.value),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ...divider,
          Obx(
            () => _buildInput(
              theme,
              key: ValueKey(_controller.key),
              initialValue: _controller.title.value,
              onChanged: (value) => _controller
                ..title.value = value
                ..updateCanCreate(),
              desc: '标题',
              hintText: '请填写标题，最多14字',
              inputFormatters: [LengthLimitingTextInputFormatter(14)],
            ),
          ),
          ...divider,
          const SizedBox(height: 25),
          Obx(() {
            return FilledButton.tonal(
              onPressed: _controller.canCreate.value
                  ? _controller.onCreate
                  : null,
              child: const Text('添加预约'),
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
      ],
    );
  }
}
