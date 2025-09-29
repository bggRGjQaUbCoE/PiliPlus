import 'package:PiliPlus/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class ColorPalette extends StatelessWidget {
  final Color color;
  final bool selected;

  const ColorPalette({
    super.key,
    required this.color,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Hct hct = Hct.fromInt(color.toARGB32());
    final primary = Color(Hct.from(hct.hue, 20.0, 90.0).toInt());
    final tertiary = Color(Hct.from(hct.hue + 50, 20.0, 85.0).toInt());
    final primaryContainer = Color(Hct.from(hct.hue, 30.0, 50.0).toInt());
    Widget coloredBox(Color color) => Expanded(
      child: ColoredBox(
        color: color,
        child: const SizedBox.expand(),
      ),
    );
    Widget child = ClipOval(
      child: Column(
        children: [
          coloredBox(primary),
          Expanded(
            child: Row(
              children: [
                coloredBox(tertiary),
                coloredBox(primaryContainer),
              ],
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
              color: Color(Hct.from(hct.hue, 30.0, 40.0).toInt()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: primary,
              size: 12,
            ),
          ),
        ],
      );
    }
    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onInverseSurface,
        borderRadius: StyleString.mdRadius,
      ),
      child: child,
    );
  }
}
