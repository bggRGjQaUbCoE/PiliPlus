import 'dart:async' show Timer;
import 'dart:io' show Platform;

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/desktop/tray_controller.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;
import 'package:window_manager/window_manager.dart';

class WindowController {
  WindowController._();
  static WindowController get instance => _instance;
  static final WindowController _instance = WindowController._();

  int? _windowId;
  nativeapi.Window? _window;
  nativeapi.Window? get window => _window;

  double? _opacity;

  final _setting = GStorage.setting;
  bool _isMaximized = false;
  set windowMaximizedPref(bool value) {
    _setting.put(SettingBoxKey.isWindowMaximized, value);
  }

  Timer? _moveTimer;
  Timer? _resizeTimer;
  static const _kDuration = Duration(milliseconds: 200);

  late bool minimizeOnExit = Pref.minimizeOnExit;
  late bool pauseOnMinimize = Pref.pauseOnMinimize;
  late bool isPlaying = false;

  void init() {
    assert(_window == null);

    final window = WindowManager.instance.getCurrent();
    if (window == null) return;
    _window = window;
    _windowId = window.addListener(_windowListener);
    _isMaximized = window.isMaximized;
  }

  void _windowListener(WindowEvent event) {
    switch (event) {
      case WindowFocusedEvent():
        // https://github.com/leanflutter/window_manager/issues/571
        _setOpacityOnWindows(1.0);
        break;
      case WindowBlurredEvent():
        break;
      case WindowMinimizedEvent():
        break;
      case WindowMaximizedEvent():
        windowMaximizedPref = _isMaximized = true;
        break;
      case WindowRestoredEvent():
        if (_isMaximized) {
          windowMaximizedPref = _isMaximized = false;
        }
        break;
      case WindowMovedEvent():
        _moveTimer?.cancel();
        _moveTimer = Timer(_kDuration, onWindowMoved);
        break;
      case WindowResizedEvent():
        _resizeTimer?.cancel();
        _resizeTimer = Timer(_kDuration, onWindowResized);
        break;
      case WindowCreatedEvent():
        break;
      case WindowClosedEvent():
        break;
      case WindowEnteredFullScreenEvent():
        break;
      case WindowExitedFullScreenEvent():
        break;
      case WindowCloseRequestedEvent():
        event.request.cancel();
        if (TrayController.instance.showTrayIcon && minimizeOnExit) {
          _hide();
        } else {
          onClose();
        }
        break;
      case WindowPropertyChangedEvent():
        break;
      case WindowOcclusionChangedEvent():
        break;
    }
  }

  void onWindowMoved() {
    final window = _window;
    if (window == null) return;
    if (PlPlayerController.instance?.updatePipBounds(window) ?? false) {
      return;
    }
    final position = window.position;
    _setting.put(SettingBoxKey.windowPosition, [position.x, position.y]);
  }

  void onWindowResized() {
    final window = _window;
    if (window == null) return;
    if (PlPlayerController.instance?.updatePipBounds(window) ?? false) {
      return;
    }
    final bounds = window.bounds;
    _setting.putAll({
      SettingBoxKey.windowSize: [bounds.width, bounds.height],
      SettingBoxKey.windowPosition: [bounds.x, bounds.y],
    });
  }

  void _playIfNeeded() {
    if (pauseOnMinimize && isPlaying) {
      PlPlayerController.instance?.play();
    }
  }

  void _pauseIfNeeded() {
    if (pauseOnMinimize) {
      if (PlPlayerController.instance case final player?) {
        if (isPlaying = player.playerStatus.isPlaying) {
          player.pause();
        }
      } else {
        isPlaying = false;
      }
    }
  }

  Future<void> onClose() async {
    await GStorage.compact();
    await GStorage.close();
    TrayController.instance.dispose();
    DeviceUtils.exitApp();
  }

  void _setOpacityOnWindows(double opacity) {
    if (Platform.isWindows && _opacity != opacity) {
      _opacity = opacity;
      _window?.opacity = opacity;
    }
  }

  void _hide() {
    _pauseIfNeeded();
    // https://github.com/leanflutter/window_manager/issues/571
    _setOpacityOnWindows(0.0);
    _window?.hide();
  }

  void show() {
    _window
      ?..focus()
      ..show();
    _playIfNeeded();
  }

  void toggleVisibility() {
    final window = _window;
    if (window == null) return;
    window.isVisible ? _hide() : show();
  }

  void dispose() {
    _moveTimer?.cancel();
    _resizeTimer?.cancel();
    _window?.removeListener(_windowId!);
    _window = null;
  }
}
