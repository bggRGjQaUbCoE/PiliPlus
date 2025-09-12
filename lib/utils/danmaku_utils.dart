import 'package:canvas_danmaku/models/danmaku_content_item.dart';
import 'package:flutter/material.dart';

abstract class DmUtils {
  static Color decimalToColor(int decimalColor) {
    // 16777215 表示白色
    int red = (decimalColor >> 16) & 0xFF;
    int green = (decimalColor >> 8) & 0xFF;
    int blue = decimalColor & 0xFF;

    return Color.fromRGBO(red, green, blue, 1);
  }

  static DanmakuItemType getPosition(int mode) {
    return switch (mode) {
      4 => DanmakuItemType.bottom,
      5 => DanmakuItemType.top,
      7 => DanmakuItemType.special,
      _ => DanmakuItemType.scroll,
    };
  }
}
