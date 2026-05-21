import 'dart:io' show Platform;

import 'package:PiliPlus/utils/device_utils.dart';
import 'package:flutter/services.dart'
    show
        SystemChrome,
        MethodChannel,
        SystemUiOverlay,
        DeviceOrientation,
        SystemUiMode;

bool _isDesktopFullScreen = false;

@pragma('vm:notify-debugger-on-exception')
Future<void> enterDesktopFullScreen({bool inAppFullScreen = false}) async {
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
Future<void> exitDesktopFullScreen() async {
  if (_isDesktopFullScreen) {
    _isDesktopFullScreen = false;
    try {
      await const MethodChannel(
        'com.alexmercerind/media_kit_video',
      ).invokeMethod('Utils.ExitNativeFullscreen');
    } catch (_) {}
  }
}

List<DeviceOrientation>? _lastOrientation;
Future<void>? _setPreferredOrientations(List<DeviceOrientation> orientations) {
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
  return setEnabledSystemUIMode(.immersiveSticky);
}

//退出全屏显示
Future<void>? showSystemBar() {
  if (_showSystemBar) {
    return null;
  }
  _showSystemBar = true;
  return setEnabledSystemUIMode(
    Platform.isAndroid && DeviceUtils.sdkInt < 29 ? .manual : .edgeToEdge,
    overlays: SystemUiOverlay.values,
  );
}

// TODO: remove
// https://github.com/flutter/flutter/issues/186723
Future<void> setEnabledSystemUIMode(
  SystemUiMode mode, {
  List<SystemUiOverlay>? overlays,
}) {
  if (!Platform.isAndroid) {
    return SystemChrome.setEnabledSystemUIMode(mode, overlays: overlays);
  }
  if (mode != SystemUiMode.manual) {
    return const MethodChannel('PiliPlus').invokeMethod(
      'SystemChrome.setEnabledSystemUIMode',
      {'arguments': mode.toString()},
    );
  } else {
    assert(mode == SystemUiMode.manual && overlays != null);
    return const MethodChannel('PiliPlus').invokeMethod(
      'SystemChrome.setEnabledSystemUIOverlays',
      {'arguments': _stringify(overlays!)},
    );
  }
}

List<String> _stringify(List<dynamic> list) => <String>[
  for (final dynamic item in list) item.toString(),
];
