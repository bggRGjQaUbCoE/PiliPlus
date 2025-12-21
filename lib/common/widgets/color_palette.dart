import 'package:PiliPlus/common/constants.dart';
import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool selected;
  final bool showBgColor;

  const ColorPalette({
    super.key,
    required this.colorScheme,
    required this.selected,
    this.showBgColor = true,
  });

  @override
  Widget build(BuildContext context) {
    final primary = colorScheme.primary;
    final tertiary = colorScheme.tertiary;
    final primaryContainer = colorScheme.primaryContainer;
    Widget child = ClipOval(
      child: Column(
        children: [
          _coloredBox(primary),
          Expanded(
            child: Row(
              children: [_coloredBox(tertiary), _coloredBox(primaryContainer)],
            ),
          ),
        ],
      ),
    );
    if (selected) {
      child = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          child,
          Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, color: primary, size: 12),
          ),
        ],
      );
    }
    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(6),
      decoration: showBgColor
          ? BoxDecoration(
              color: colorScheme.onInverseSurface,
              borderRadius: StyleString.mdRadius,
            )
          : null,
      child: child,
    );
  }

  static Widget _coloredBox(Color color) => Expanded(
    child: ColoredBox(color: color, child: const SizedBox.expand()),
  );
}
