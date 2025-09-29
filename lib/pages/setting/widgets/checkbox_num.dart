import 'package:flutter/material.dart';

class OrderedCheckbox extends StatelessWidget {
  const OrderedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  }) : assert(value == null || value < 100);

  final int? value;
  final ValueChanged<int?>? onChanged;
  bool get selected => value != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final child = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(1.5)),
        border: Border.all(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
          width: 1.6,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        color: selected ? theme.colorScheme.primary : null,
      ),
      child: selected
          ? SizedBox.square(
              dimension: 16.5,
              child: Center(
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    inherit: false,
                    color: theme.colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    shadows: theme.iconTheme.shadows,
                    height: 1.0,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              ),
            )
          : const SizedBox.square(dimension: 16.5),
    );
    if (onChanged != null) {
      return InkWell(
        onTap: () => onChanged!(value),
        child: child,
      );
    }
    return child;
  }
}
