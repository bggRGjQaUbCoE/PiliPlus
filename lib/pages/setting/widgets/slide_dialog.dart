import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SlideDialog extends StatefulWidget {
  final double value;
  final String title;
  final double min;
  final double max;
  final int? divisions;
  final String? suffix;
  final int precise;
  final double? defVal;

  const SlideDialog({
    super.key,
    required this.value,
    required this.title,
    required this.min,
    required this.max,
    this.divisions,
    this.suffix,
    this.precise = 1,
    this.defVal,
  });

  @override
  State<SlideDialog> createState() => _SlideDialogState();
}

class _SlideDialogState extends State<SlideDialog> {
  late double _tempValue;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _tempValue = widget.value;
    _controller = TextEditingController(
      text: _tempValue.toStringAsFixed(widget.precise),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const .only(top: 24, left: 20, right: 20, bottom: 12),
      content: Column(
        mainAxisSize: .min,
        spacing: 20,
        children: [
          Slider(
            padding: .zero,
            value: _tempValue,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            secondaryTrackValue: widget.defVal,
            label:
                '${_tempValue.toStringAsFixed(widget.precise)}${widget.suffix ?? ""}',
            onChanged: (value) => setState(() {
              _tempValue = value.toPrecision(widget.precise);
              _controller.text = _tempValue.toStringAsFixed(widget.precise);
            }),
          ),
          TextField(
            controller: _controller,
            maxLines: 1,
            keyboardType: const .numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]+')),
            ],
            decoration: InputDecoration(
              suffixText: widget.suffix,
              labelText: widget.title,
              hintText:
                  '${widget.min.toStringAsFixed(widget.precise)} - ${widget.max.toStringAsFixed(widget.precise)}',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null &&
                  widget.min <= parsed &&
                  parsed <= widget.max) {
                setState(() {
                  _tempValue = parsed.toPrecision(widget.precise);
                });
              }
            },
            onSubmitted: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null) {
                setState(() {
                  _tempValue = parsed
                      .clamp(widget.min, widget.max)
                      .toPrecision(widget.precise);
                  _controller.text = _tempValue.toStringAsFixed(widget.precise);
                });
              }
            },
          ),
        ],
      ),
      actions: [
        if (widget.defVal != null)
          TextButton(
            onPressed: () => Get.back(result: double.nan),
            child: Text('重置', style: TextStyle(color: colorScheme.error)),
          ),
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(color: colorScheme.outline),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(result: _tempValue),
          child: const Text('确定'),
        ),
      ],
    );
  }
}
