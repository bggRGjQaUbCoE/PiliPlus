import 'dart:async';
import 'dart:io' show Platform;

import 'package:PiliPlus/utils/desktop/window_controller.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlay, DeviceOrientation;

bool _isDesktopFullScreen = false;

void enterDesktopFullScreen({bool inAppFullScreen = false}) {
  if (!inAppFullScreen && !_isDesktopFullScreen) {
    WindowController.instance.window?.isFullScreen = _isDesktopFullScreen =
        true;
  }
}

void exitDesktopFullScreen() {
  if (_isDesktopFullScreen) {
    WindowController.instance.window?.isFullScreen = _isDesktopFullScreen =
        false;
  }
}

List<DeviceOrientation>? _lastOrientation;
Future<void>? _setPreferredOrientations(List<DeviceOrientation> orientations) {
  if (DeviceUtils.isChromeOS) return null;

  if (_lastOrientation == orientations) {
    return null;
  }
  _lastOrientation = orientations;
  return SystemChrome.setPreferredOrientations(orientations);
}

Future<void>? portraitUpMode() {
  return _setPreferredOrientations(const [.portraitUp]);
}

Future<void>? portraitDownMode() {
  return _setPreferredOrientations(const [.portraitDown]);
}

Future<void>? landscapeLeftMode() {
  return _setPreferredOrientations(const [.landscapeLeft]);
}

Future<void>? landscapeRightMode() {
  return _setPreferredOrientations(const [.landscapeRight]);
}

// 从 iPhone 17 Pro 起，Pro / Pro Max 底部短边的扬声器位于左侧，
// 逆时针转横屏时右手正好握住扬声器，因此这些机型默认顺时针转。
// 注意：18 系真机标识符与 Xcode 模拟器配置不一致（如 18 Pro Max 真机为
// iPhone19,7，模拟器为 iPhone19,3），两者都列入；遗漏的机型可在设置中手动指定。
const _kClockwiseLandscapeModels = {
  'iPhone18,1', // iPhone 17 Pro
  'iPhone18,2', // iPhone 17 Pro Max
  'iPhone19,2', // iPhone 18 Pro（模拟器配置）
  'iPhone19,3', // iPhone 18 Pro Max（模拟器配置）
  'iPhone19,7', // iPhone 18 Pro Max
};

Future<bool>? _isClockwiseLandscapeModel;

/// iOS 无重力方向信息（如点击全屏按钮）时使用的默认横屏方向
Future<void> iosDefaultLandscapeMode() async {
  final bool clockwise = switch (Pref.iosLandscapeDirection) {
    .clockwise => true,
    .counterclockwise => false,
    .auto =>
      await (_isClockwiseLandscapeModel ??= DeviceInfoPlugin().iosInfo
          .then((e) => _kClockwiseLandscapeModels.contains(e.utsname.machine))
          .catchError((_) => false)),
  };
  await (clockwise ? landscapeLeftMode() : landscapeRightMode());
}

Future<void>? fullMode() {
  return _setPreferredOrientations(
    const [.portraitUp, .portraitDown, .landscapeLeft, .landscapeRight],
  );
}

bool _showSystemBar = true;
bool get showSystemBar_ => _showSystemBar;
Future<void>? hideSystemBar() {
  if (!_showSystemBar) {
    return null;
  }
  _showSystemBar = false;
  return SystemChrome.setEnabledSystemUIMode(.immersiveSticky);
}

//退出全屏显示
Future<void>? showSystemBar() {
  if (_showSystemBar) {
    return null;
  }
  _showSystemBar = true;
  return SystemChrome.setEnabledSystemUIMode(
    Platform.isAndroid && DeviceUtils.sdkInt < 29 ? .manual : .edgeToEdge,
    overlays: SystemUiOverlay.values,
  );
}
