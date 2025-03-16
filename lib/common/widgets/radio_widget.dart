import 'package:flutter/material.dart';

class RadioWidget<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final String title;
  final EdgeInsetsGeometry? padding;

  const RadioWidget({
    super.key,
    required this.value,
    this.groupValue,
    required this.onChanged,
    required this.title,
    this.padding,
  });

  Widget _child() => Row(
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text(title),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: padding != null
          ? Padding(
              padding: padding!,
              child: _child(),
            )
          : _child(),
    );
  }
}

class WrapRadioOptionsGroup<T> extends StatelessWidget {
  final String groupTitle;
  final Map<T, String> options;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final EdgeInsetsGeometry? itemPadding;

  const WrapRadioOptionsGroup({
    super.key,
    required this.groupTitle,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.itemPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (groupTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Text(
              groupTitle,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            children: options.entries.map((entry) {
              return IntrinsicWidth(
                child: RadioWidget<T>(
                  value: entry.key,
                  groupValue: selectedValue,
                  onChanged: onChanged,
                  title: entry.value,
                  padding: itemPadding ?? const EdgeInsets.only(right: 10),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
