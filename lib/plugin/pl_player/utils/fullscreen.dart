import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/services.dart';

bool _isDesktopFullScreen = false;

@pragma('vm:notify-debugger-on-exception')
Future<void> enterDesktopFullscreen({bool inAppFullScreen = false}) async {
  if (!inAppFullScreen && !_isDesktopFullScreen) {
    _isDesktopFullScreen = true;
    try {
      await const MethodChannel(
        'com.alexmercerind/media_kit_video',
      ).invokeMethod('Utils.EnterNativeFullscreen');
    } catch (_) {}
  }
}

@pragma('vm:notify-debugger-on-exception')
Future<void> exitDesktopFullscreen() async {
  if (_isDesktopFullScreen) {
    _isDesktopFullScreen = false;
    try {
      await const MethodChannel(
        'com.alexmercerind/media_kit_video',
      ).invokeMethod('Utils.ExitNativeFullscreen');
    } catch (_) {}
  }
}

//横屏
// Returns true if system rotation succeeded, false if manual rotation needed
@pragma('vm:notify-debugger-on-exception')
Future<bool> landscape() async {
  if (Platform.isAndroid) {
    try {
      final result = await Utils.channel.invokeMethod<bool>('forceLandscape');
      if (result == true) return true;
      // Native strategies all failed; try Flutter's SystemChrome API
      // which uses a slightly different code path
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // Give the system time to respond
      await Future.delayed(const Duration(milliseconds: 400));
      // Check via native if orientation changed
      final retryResult =
          await Utils.channel.invokeMethod<bool>('checkLandscape');
      if (retryResult == true) return true;
      // All strategies failed - caller should use manual rotation
      return false;
    } catch (_) {}
  }
  try {
    await AutoOrientation.landscapeAutoMode(forceSensor: true);
  } catch (_) {}
  return true;
}

//竖屏
Future<void> verticalScreenForTwoSeconds() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await autoScreen();
}

//全向
bool allowRotateScreen = Pref.allowRotateScreen;
Future<void> autoScreen() async {
  if (PlatformUtils.isMobile && allowRotateScreen) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

Future<void> fullAutoModeForceSensor() {
  return AutoOrientation.fullAutoMode(forceSensor: true);
}

Future<void> exitForcedOrientation() async {
  if (Platform.isAndroid) {
    try {
      await Utils.channel.invokeMethod('exitForceLandscape');
    } catch (_) {}
  }
}

bool _showStatusBar = true;
Future<void> hideStatusBar() async {
  if (!_showStatusBar) {
    return;
  }
  _showStatusBar = false;
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

//退出全屏显示
Future<void> showStatusBar() async {
  if (_showStatusBar) {
    return;
  }
  _showStatusBar = true;
  SystemUiMode mode;
  if (Platform.isAndroid && (await Utils.sdkInt < 29)) {
    mode = SystemUiMode.manual;
  } else {
    mode = SystemUiMode.edgeToEdge;
  }
  await SystemChrome.setEnabledSystemUIMode(
    mode,
    overlays: SystemUiOverlay.values,
  );
}
