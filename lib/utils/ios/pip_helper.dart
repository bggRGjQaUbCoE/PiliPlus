import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState, WidgetsBinding;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// Picture-in-Picture on iOS, implemented in `ios/Runner/PipPlugin.swift`.
abstract final class IOSPipHelper {
  static const _channel = MethodChannel('com.example.piliplus/pip');

  static bool isAvailable = false;

  /// Whether the PiP window is shown or about to be shown.
  static bool isActive = false;

  static bool _autoEnter = false;

  /// Whether the native side needs playback state updates.
  static bool get needsUpdate => isActive || _autoEnter;

  static Future<void> init() async {
    _channel.setMethodCallHandler(_onMethodCall);
    try {
      isAvailable = await _channel.invokeMethod<bool>('isAvailable') ?? false;
    } catch (e) {
      if (kDebugMode) debugPrint('IOSPipHelper init: $e');
    }
  }

  static Future<void> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onStateChanged':
        final args = call.arguments as Map;
        isActive = args['active'] as bool;
        final isResumed =
            WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
        if (args['error'] != null && isResumed) {
          SmartDialog.showToast('画中画启动失败');
        }
        // Closing the PiP window in background stops playback, as on Android.
        if (args['closed'] == true && !isResumed) {
          if (PlPlayerController.instance case final ctr?
              when !ctr.continuePlayInBackground.value) {
            PlPlayerController.pauseIfExists();
          }
        }
      case 'setPlaying':
        if (call.arguments as bool) {
          PlPlayerController.playIfExists();
        } else {
          PlPlayerController.pauseIfExists();
        }
      case 'skip':
        if (PlPlayerController.instance case final ctr?) {
          ctr.seekTo(
            Duration(
              milliseconds:
                  ctr.positionInMilliseconds + (call.arguments as int),
            ),
            isSeek: false,
          );
        }
    }
  }

  /// Enters PiP, or arms entering it automatically when the app goes to
  /// background if [autoEnter] is `true`.
  static void enter(
    int textureId, {
    required int? width,
    required int? height,
    required bool autoEnter,
    required Map<String, Object> state,
  }) {
    if (autoEnter) _autoEnter = true;
    _channel.invokeMethod('enter', {
      'textureId': textureId,
      'width': ?width,
      'height': ?height,
      'autoEnter': autoEnter,
      ...state,
    });
  }

  static void update(Map<String, Object> state) {
    _channel.invokeMethod('update', state);
  }

  static void disableAutoEnter() {
    if (_autoEnter) {
      _autoEnter = false;
      _channel.invokeMethod('disableAutoEnter');
    }
  }

  static void dispose() {
    _autoEnter = false;
    _channel.invokeMethod('dispose');
  }
}
