import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

//横屏
Future<void> landScape() async {
  dynamic document;
  try {
    if (kIsWeb) {
      await document.documentElement?.requestFullscreen();
    } else if (Utils.isMobile) {
      await AutoOrientation.landscapeAutoMode(forceSensor: true);
    } else if (Utils.isDesktop) {
      await const MethodChannel(
        'com.alexmercerind/media_kit_video',
      ).invokeMethod(
        'Utils.EnterNativeFullscreen',
      );
    }
  } catch (exception, stacktrace) {
    if (kDebugMode) {
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }
  }
}

//竖屏
Future<void> verticalScreenForTwoSeconds() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await autoScreen();
}

//竖屏
Future<void> verticalScreen() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

//全向
bool allowRotateScreen = Pref.allowRotateScreen;
Future<void> autoScreen() async {
  if (!allowRotateScreen) {
    return;
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

Future<void> fullAutoModeForceSensor() async {
  await AutoOrientation.fullAutoMode(forceSensor: true);
}

Future<void> hideStatusBar() async {
  if (!_showStatusBar) {
    return;
  }
  _showStatusBar = false;
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
}

bool _showStatusBar = true;

//退出全屏显示
Future<void> showStatusBar() async {
  if (_showStatusBar) {
    return;
  }
  _showStatusBar = true;
  dynamic document;
  late SystemUiMode mode = SystemUiMode.edgeToEdge;
  try {
    if (kIsWeb) {
      document.exitFullscreen();
    } else if (Utils.isMobile) {
      if (Platform.isAndroid && (await Utils.sdkInt < 29)) {
        mode = SystemUiMode.manual;
      }
      await SystemChrome.setEnabledSystemUIMode(
        mode,
        overlays: SystemUiOverlay.values,
      );
    } else if (Utils.isDesktop) {
      await const MethodChannel(
        'com.alexmercerind/media_kit_video',
      ).invokeMethod(
        'Utils.ExitNativeFullscreen',
      );
    }
  } catch (exception, stacktrace) {
    if (kDebugMode) {
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }
  }
}
