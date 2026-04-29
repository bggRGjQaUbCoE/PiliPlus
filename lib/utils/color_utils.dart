import 'package:flutter/rendering.dart' show Color;

abstract final class ColourUtils {
  static Color parseColor(String color) =>
      Color(int.parse('FF${color.substring(1)}', radix: 16));

  static Color parseMedalColor(String color) => Color(
    int.parse('${color.substring(7)}${color.substring(1, 7)}', radix: 16),
  );

  static Color index2Color(int index, Color color) => switch (index) {
    0 => const Color(0xFFfdad13),
    1 => const Color(0xFF8aace1),
    2 => const Color(0xFFdfa777),
    _ => color,
  };
}
