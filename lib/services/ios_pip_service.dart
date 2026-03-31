import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:flutter/services.dart';

class IOSPipRestoreState {
  const IOSPipRestoreState({
    required this.wasActive,
    required this.position,
    required this.isPlaying,
  });

  final bool wasActive;
  final Duration position;
  final bool isPlaying;

  factory IOSPipRestoreState.fromMap(Map<dynamic, dynamic> map) {
    final positionMs = switch (map['positionMs']) {
      int value => value,
      String value => int.tryParse(value) ?? 0,
      num value => value.toInt(),
      _ => 0,
    };
    return IOSPipRestoreState(
      wasActive: map['wasActive'] == true,
      position: Duration(milliseconds: positionMs),
      isPlaying: map['isPlaying'] == true,
    );
  }
}

abstract final class IOSPipService {
  static const MethodChannel _channel = MethodChannel('PiliPlus.iOSPiP');
  static final StreamController<IOSPipRestoreState> _restoreController =
      StreamController<IOSPipRestoreState>.broadcast();

  static bool _initialized = false;

  static void ensureInitialized() {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onPipStop' && call.arguments is Map) {
        _restoreController.add(IOSPipRestoreState.fromMap(call.arguments));
      }
    });
  }

  static Stream<IOSPipRestoreState> get onPipStop {
    ensureInitialized();
    return _restoreController.stream;
  }

  static Future<bool> get isAvailable async {
    if (!Platform.isIOS) {
      return false;
    }
    ensureInitialized();
    return (await _channel.invokeMethod<bool>('isAvailable')) ?? false;
  }

  static Future<bool> enter({
    required DataSource dataSource,
    required Duration position,
    required bool isPlaying,
    required double playbackSpeed,
  }) async {
    if (!Platform.isIOS) {
      return false;
    }
    ensureInitialized();
    return (await _channel.invokeMethod<bool>('enter', {
          'videoUrl': _normalizeSource(dataSource.videoSource),
          'audioUrl': switch (dataSource.audioSource) {
            final String source when source.isNotEmpty => _normalizeSource(source),
            _ => null,
          },
          'positionMs': position.inMilliseconds,
          'playWhenReady': isPlaying,
          'playbackSpeed': playbackSpeed,
          'headers': const {
            'User-Agent': BrowserUa.pc,
            'Referer': HttpString.baseUrl,
          },
        })) ??
        false;
  }

  static Future<IOSPipRestoreState?> restore() async {
    if (!Platform.isIOS) {
      return null;
    }
    ensureInitialized();
    final result = await _channel.invokeMapMethod<dynamic, dynamic>('restore');
    if (result == null) {
      return null;
    }
    return IOSPipRestoreState.fromMap(result);
  }

  static String _normalizeSource(String source) {
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return source;
    }
    return Uri.file(source).toString();
  }
}
