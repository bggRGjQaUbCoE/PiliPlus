import 'dart:io' show Platform;

import 'package:flutter/services.dart';

abstract final class IosWindowUtils {
  static const _channel = MethodChannel('com.example.piliplus/window_controls');

  static Future<double> get windowControlsLeadingInset async {
    if (!Platform.isIOS) return 0;

    try {
      final inset = await _channel.invokeMethod<num>(
        'getWindowControlsLeadingInset',
      );
      return inset?.toDouble() ?? 0;
    } on MissingPluginException {
      return 0;
    } on PlatformException {
      return 0;
    }
  }
}
