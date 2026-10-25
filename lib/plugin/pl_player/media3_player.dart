import 'package:flutter/services.dart';

class Media3PlaybackResult {
  const Media3PlaybackResult({
    required this.position,
    required this.duration,
    required this.speed,
    required this.completed,
    this.error,
  });

  factory Media3PlaybackResult.fromMap(Map<Object?, Object?> value) {
    if (value
        case {
          'positionMs': int position,
          'durationMs': int duration,
          'speed': num speed,
          'completed': bool completed,
        }
        when position >= 0 && duration >= 0 && speed.isFinite && speed > 0) {
      return Media3PlaybackResult(
        position: Duration(milliseconds: position),
        duration: Duration(milliseconds: duration),
        speed: speed.toDouble(),
        completed: completed,
        error: value['error'] as String?,
      );
    }
    throw const FormatException('Invalid Media3 playback result');
  }

  final Duration position;
  final Duration duration;
  final double speed;
  final bool completed;
  final String? error;
}

class Media3Player {
  static const channel = MethodChannel('com.example.piliplus/media3');

  static Future<Media3PlaybackResult> open({
    required String video,
    String? audio,
    required Duration position,
    required double speed,
    required Map<String, String> headers,
  }) async {
    final result = await channel.invokeMapMethod<Object?, Object?>('open', {
      'video': video,
      if (audio != null && audio.isNotEmpty) 'audio': audio,
      'positionMs': position.inMilliseconds,
      'speed': speed,
      'headers': headers,
    });
    if (result == null) {
      throw const FormatException('Missing Media3 playback result');
    }
    return Media3PlaybackResult.fromMap(result);
  }

  static Future<void> close() => channel.invokeMethod<void>('close');
  static Future<void> pause() => channel.invokeMethod<void>('pause');
}
