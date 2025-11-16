import 'dart:ui' show Color;

import 'package:canvas_danmaku/models/danmaku_content_item.dart'
    show DanmakuItemType;

abstract final class DmUtils {
  static Color decimalToColor(int decimalColor) =>
      Color(decimalColor | 0xFF000000);

  static DanmakuItemType getPosition(int mode) => switch (mode) {
    4 => DanmakuItemType.bottom,
    5 => DanmakuItemType.top,
    7 => DanmakuItemType.special,
    _ => DanmakuItemType.scroll,
  };
}
