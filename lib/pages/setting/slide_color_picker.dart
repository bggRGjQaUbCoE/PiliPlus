import 'package:PiliPlus/utils/danmaku_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show LengthLimitingTextInputFormatter, FilteringTextInputFormatter;
import 'package:get/get.dart';

class SlideColorPicker extends StatefulWidget {
  const SlideColorPicker({
    super.key,
    required this.color,
    required this.callback,
    this.showResetBtn = false,
  });

  final Color color;
  final Function(Color? color) callback;
  final bool showResetBtn;

  @override
  State<SlideColorPicker> createState() => _SlideColorPickerState();
}

class _SlideColorPickerState extends State<SlideColorPicker> {
  late int _rgb;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _rgb = widget.color.toARGB32() & 0xFFFFFF;
    _textController = TextEditingController(text: _convert);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String get _convert => _rgb.toRadixString(16).toUpperCase().padLeft(6, '0');

  Widget _slider({
    required String title,
    required int value,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        const SizedBox(width: 16),
        SizedBox(
          width: MediaQuery.textScalerOf(context).scale(16),
          child: Text(title),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 10,
              thumbSize: const WidgetStatePropertyAll(Size(4, 25)),
            ),
            child: Slider(
              padding: EdgeInsets.zero,
              min: 0,
              max: 255,
              divisions: 255,
              value: value.toDouble(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: MediaQuery.textScalerOf(context).scale(25) + 16,
          child: Text(
            value.toString(),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
            color: DmUtils.decimalToColor(_rgb),
          ),
          const SizedBox(height: 10),
          IntrinsicWidth(
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.allow(RegExp('[0-9a-fA-F]')),
              ],
              controller: _textController,
              decoration: const InputDecoration(
                isDense: true,
                prefixText: '#',
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                _textController.text = value.toUpperCase();
                if (value.length == 6) {
                  setState(() {
                    _rgb = int.tryParse(value, radix: 16) ?? 0;
                  });
                }
              },
            ),
          ),
          _slider(
            title: 'R',
            value: _rgb >> 16,
            onChanged: (value) {
              setState(() {
                _rgb = _rgb.setByte(value.round(), 16);
                _textController.text = _convert;
              });
            },
          ),
          _slider(
            title: 'G',
            value: (_rgb >> 8) & 0xFF,
            onChanged: (value) {
              setState(() {
                _rgb = _rgb.setByte(value.round(), 8);
                _textController.text = _convert;
              });
            },
          ),
          _slider(
            title: 'B',
            value: _rgb & 0xFF,
            onChanged: (value) {
              setState(() {
                _rgb = _rgb.setByte(value.round(), 0);
                _textController.text = _convert;
              });
            },
          ),
          Row(
            children: [
              if (widget.showResetBtn) ...[
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    Get.back();
                    widget.callback(null);
                  },
                  child: const Text('重置'),
                ),
              ],
              const Spacer(),
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  widget.callback(DmUtils.decimalToColor(_rgb));
                },
                child: const Text('确定'),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }
}

extension on int {
  @pragma("vm:prefer-inline")
  int setByte(int value, int shift) =>
      (this & ~(0xFF << shift)) | (value << shift);
}
