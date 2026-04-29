import 'dart:io' show Platform;

import 'package:PiliPlus/utils/utils.dart';

abstract final class MaxScreenSize {
  static int? _maxWidth;
  static int? _maxHeight;

  static Future<void> init() async {
    final res = await Utils.channel.invokeMethod('maxScreenSize');
    if (res is Map) {
      _maxWidth = res['maxWidth'];
      _maxHeight = res['maxHeight'];
    }
  }

  static bool isWindowMode({required num width, required num height}) {
    if (!Platform.isAndroid) return false;
    width = width.round();
    height = height.round();
    final hasWidthMatch = width == _maxWidth || width == _maxHeight;
    final hasHeightMatch = height == _maxWidth || height == _maxHeight;
    return !(hasWidthMatch && hasHeightMatch);
  }
}
