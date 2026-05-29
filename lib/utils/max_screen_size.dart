import 'dart:io' show Platform;

import 'package:PiliPlus/utils/android/android_helper.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';

abstract final class MaxScreenSize {
  static int? _maxWidth;
  static int? _maxHeight;

  static void init() {
    _initScreenSize();
    if (AndroidHelper.isFoldable) {
      AndroidHelper$ToDart.onUserLeaveHint = Runnable.implement(
        $Runnable(run: _initScreenSize),
      );
    }
  }

  static void _initScreenSize() {
    final size = PiliAndroidHelper.maxScreenSize();
    if (size != null) {
      _maxWidth = size.$1;
      _maxHeight = size.$2;
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
