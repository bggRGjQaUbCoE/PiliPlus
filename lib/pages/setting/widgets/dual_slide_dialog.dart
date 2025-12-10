import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class DualSlideDialog extends StatefulWidget {
	final double value1;
	final double value2;
	final String title;
	final String description1;
	final String description2;
	final double min;
	final double max;
	final int? divisions;
	final String suffix;
	final int precise;

	const DualSlideDialog({
		super.key,
		required this.value1,
		required this.value2,
		required this.description1,
		required this.description2,
		required this.title,
		required this.min,
		required this.max,
		this.divisions,
		this.suffix = '',
		this.precise = 1,
	});

	@override
	State<DualSlideDialog> createState() => _DualSlideDialogState();
}

class _DualSlideDialogState extends State<DualSlideDialog> {
	late double _tempValue1;
	late double _tempValue2;

	@override
	void initState() {
		super.initState();
		_tempValue1 = widget.value1;
		_tempValue2 = widget.value2;
	}

	@override
	Widget build(BuildContext context) {
		return AlertDialog(
			title: Text(widget.title),
			contentPadding: const EdgeInsets.only(
				top: 20,
				left: 8,
				right: 8,
				bottom: 8,
			),
			content: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Text(widget.description1),
					Builder(
						builder: (context) {
							return Slider(
								value: _tempValue1,
								min: widget.min,
								max: widget.max,
								divisions: widget.divisions,
								label:
										'${_tempValue1.toStringAsFixed(widget.precise)}${widget.suffix}',
								onChanged: (double value) {
									_tempValue1 = value.toPrecision(widget.precise);
									(context as Element).markNeedsBuild();
								},
							);
						},
					),
					Text(widget.description2),
					Builder(
						builder: (context) {
							return Slider(
								value: _tempValue2,
								min: widget.min,
								max: widget.max,
								divisions: widget.divisions,
								label:
										'${_tempValue2.toStringAsFixed(widget.precise)}${widget.suffix}',
								onChanged: (double value) {
									_tempValue2 = value.toPrecision(widget.precise);
									(context as Element).markNeedsBuild();
								},
							);
						},
					),
				],
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
					onPressed: () => Navigator.pop(context, (_tempValue1, _tempValue2)),
					child: const Text('确定'),
				),
			],
		);
	}
}
