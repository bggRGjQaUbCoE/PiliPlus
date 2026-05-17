import 'package:flutter/rendering.dart' show Color;

abstract final class ColourUtils {
  static Color parseColor(String color) =>
      Color(0xFF000000 | int.parse(color.substring(1), radix: 16));

  static Color parseMedalColor(String color) {
    final rgba = int.parse(color.substring(1), radix: 16);
    return Color.fromARGB(rgba, rgba >> 24, rgba >> 16, rgba >> 8);
  }

  static Color index2Color(int index, Color color) => switch (index) {
    0 => const Color(0xFFfdad13),
    1 => const Color(0xFF8aace1),
    2 => const Color(0xFFdfa777),
    _ => color,
  };
}
