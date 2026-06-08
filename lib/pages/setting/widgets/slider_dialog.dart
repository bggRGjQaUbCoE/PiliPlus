import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:flutter/material.dart';

class SliderDialog extends StatefulWidget {
  const SliderDialog({
    super.key,
    required this.value,
    required this.title,
    required this.min,
    required this.max,
    this.divisions,
    this.suffix = '',
    this.precise = 1,
  });

  final double value;
  final Widget title;
  final double min;
  final double max;
  final int? divisions;
  final String suffix;
  final int precise;

  @override
  State<SliderDialog> createState() => _SliderDialogState();
}

class _SliderDialogState extends State<SliderDialog> {
  late double _tempValue;

  @override
  void initState() {
    super.initState();
    _tempValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      contentPadding: const .only(top: 20, left: 8, right: 8, bottom: 8),
      content: SizedBox(
        height: 40,
        child: Slider(
          value: _tempValue,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          label:
              '${_tempValue.toStringAsFixed(widget.precise)}${widget.suffix}',
          onChanged: (double value) {
            setState(() {
              _tempValue = value.toPrecision(widget.precise);
            });
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(
            '取消',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _tempValue),
          child: const Text('确定'),
        ),
      ],
    );
  }
}
