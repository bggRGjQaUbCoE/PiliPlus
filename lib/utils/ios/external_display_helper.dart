import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Connects the phone player to a separate TV renderer, keeping comments usable.
abstract final class IOSExternalDisplayHelper {
  // TV typography follows the TV image height, independently of the sending
  // device's screen size, orientation, split view or app UI scale.
  static const canvasHeight = 400.0;
  static const _channel = MethodChannel(
    'com.example.piliplus/external-display',
  );
  static bool get isActive => _active;
  static bool get continuesToNextVideo => _continueCasting;
  static bool _active = false;
  static bool _continueCasting = false;
  static int? _cid;
  static Future<void> Function()? _update;
  static Completer<void>? _closed;

  static Future<void> showControls() =>
      _channel.invokeMethod<void>('showControls');

  static Future<void> close() async {
    final closed = _closed?.future;
    if (_active) {
      await _channel.invokeMethod<void>('close', {
        'keepReceiver': _continueCasting,
      });
    }
    await closed;
  }

  /// Releasing a video's decoder does not cancel the user's casting choice.
  /// Reconnect only while a real external display is still available.
  static Future<bool> prepareNextVideo() async {
    if (!_continueCasting) return false;
    await close();
    if (!_continueCasting) return false;
    final available =
        await _channel.invokeMethod<bool>('hasExternalDisplay') ?? false;
    if (!available) {
      _continueCasting = false;
      await _channel.invokeMethod<void>('close');
    }
    return available && _continueCasting;
  }

  static void refresh() {
    if (_active) unawaited(_update?.call());
  }

  static void clearDanmaku() {
    if (_active) unawaited(_send('clearDanmaku'));
  }

  static void sendDanmaku(int cid, List<Map<String, Object?>> items) {
    if (_active && cid == _cid && items.isNotEmpty) {
      unawaited(_send('danmaku', items));
    }
  }

  static Future<void> _send(String method, [Object? arguments]) async {
    try {
      await _channel.invokeMethod<void>(method, arguments);
    } on PlatformException catch (error) {
      if (kDebugMode) {
        debugPrint('External display channel failed: ${error.runtimeType}');
      }
    }
  }

  static Future<String?> present({
    required String title,
    required String artwork,
    required bool darkMode,
    required int cid,
    bool showControls = true,
    required Map<String, Object>? Function() state,
    required Future<void> Function(String command, double? value) onCommand,
  }) async {
    if (_active) throw StateError('External display is already open');
    _active = true;
    final closed = Completer<void>();
    _closed = closed;
    _cid = cid;
    Map<String, Object>? snapshot() {
      final value = state();
      if (value == null) return null;
      return {...value, 'referenceHeight': canvasHeight};
    }

    Future<void> update() async {
      if (!_active || _closed != closed) return;
      final value = snapshot();
      if (value == null) {
        await close();
        return;
      }
      try {
        await _channel.invokeMethod<void>('update', value);
      } on PlatformException catch (error) {
        if (kDebugMode) {
          debugPrint('External display channel failed: ${error.runtimeType}');
        }
      }
    }

    _update = update;

    _channel.setMethodCallHandler((call) async {
      if (call.method != 'command' || !_active || _closed != closed) return;
      final args = Map<String, dynamic>.from(call.arguments as Map);
      final command = args['command'] as String;
      if (command == 'connected') _continueCasting = true;
      if (command == 'close') _continueCasting = false;
      await onCommand(command, (args['value'] as num?)?.toDouble());
      await update();
    });
    final timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      unawaited(update());
    });
    try {
      final response = await _channel.invokeMapMethod<String, dynamic>(
        'present',
        {
          'title': title,
          'artwork': artwork,
          'darkMode': darkMode,
          'showControls': showControls,
          'state': snapshot(),
        },
      );
      if (response?['diagnostics'] case final List diagnostics) {
        for (final message in diagnostics.whereType<String>()) {
          if (kDebugMode) debugPrint('[External display] $message');
        }
      }
      return response?['nextMode'] as String?;
    } finally {
      timer.cancel();
      _channel.setMethodCallHandler(null);
      _active = false;
      _cid = null;
      _update = null;
      _closed = null;
      closed.complete();
    }
  }
}
