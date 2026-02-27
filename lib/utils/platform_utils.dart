import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show debugPrint;

abstract final class PlatformUtils {
  @pragma("vm:platform-const")
  static final bool isMobile = Platform.isAndroid || Platform.isIOS;

  @pragma("vm:platform-const")
  static final bool isDesktop =
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  /// Whether the device is a VR headset (Quest, Pico, etc.)
  /// Must call [initVR] before accessing this value.
  static bool isVR = false;

  /// Initialize VR device detection. Call once during app startup.
  static Future<void> initVR() async {
    if (!Platform.isAndroid) return;
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      final manufacturer = info.manufacturer.toLowerCase();
      debugPrint('VR_DETECT: manufacturer="$manufacturer" '
          'model="${info.model}" brand="${info.brand}"');
      isVR = manufacturer.contains('oculus') ||
          manufacturer.contains('meta') ||
          manufacturer.contains('pico');
      debugPrint('VR_DETECT: isVR=$isVR');
    } catch (e) {
      debugPrint('VR_DETECT: error=$e');
      isVR = false;
    }
  }
}
