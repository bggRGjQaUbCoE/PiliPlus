import 'dart:io' show Platform;

import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/services.dart' show MethodChannel;

abstract final class MaxScreenSize {
  static int? _maxWidth;
  static int? _maxHeight;

  static Future<void> init() {
    return Future.wait([_initFoldable(), _initScreenSize()]);
  }

  static Future<void> _initFoldable() async {
    final isFoldable = await Utils.channel.invokeMethod('isFoldable');
    if (isFoldable == true) {
      const MethodChannel('ScreenChannel').setMethodCallHandler((call) {
        if (call.method == 'onConfigChanged') {
          _handleRes(call.arguments);
        }
        return Future.syncValue(null);
      });
    }
  }

  static Future<void> _initScreenSize() {
    return Utils.channel.invokeMethod('maxScreenSize').then(_handleRes);
  }

  static void _handleRes(dynamic res) {
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
