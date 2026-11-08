import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';

/// The Android playback backend for Dolby Vision streams.
final class NativeHdrPlayer extends PlatformPlayer {
  static const viewType = 'piliplus/native_hdr';
  static const _host = MethodChannel(viewType);
  static int _nextId = 0;

  NativeHdrPlayer._(this.id)
    : super(configuration: const PlayerConfiguration());

  final int id;
  late final MethodChannel _channel = MethodChannel('$viewType/$id');
  bool _disposed = false;

  static Future<NativeHdrPlayer> create() async {
    final player = NativeHdrPlayer._(++_nextId);
    await _host.invokeMethod<void>('create', player.id);
    player._channel.setMethodCallHandler(player._onEvent);
    return player;
  }

  Future<void> _call(String method, [Object? args]) async {
    if (!_disposed) await _channel.invokeMethod<void>(method, args);
  }

  Future<void> load({
    required String video,
    String? audio,
    Duration? position,
    required String referer,
    required String userAgent,
  }) => _call('load', {
    'video': video,
    'audio': audio,
    'position': position?.inMilliseconds ?? 0,
    'referer': referer,
    'userAgent': userAgent,
  });

  Future<void> retry() => _call('retry');

  @override
  Future<void> play() => _call('play');

  @override
  Future<void> pause() => _call('pause');

  @override
  Future<void> seek(Duration duration) =>
      _call('seek', duration.inMilliseconds);

  @override
  Future<void> setRate(double rate) async {
    await _call('rate', rate);
    state.rate = rate;
  }

  @override
  Future<void> setVolume(double volume) async {
    await _call('volume', (volume / 100).clamp(0.0, 1.0));
    state.volume = volume;
  }

  @override
  Future<void> setSubtitleTrack(SubtitleTrack track) {
    if (!track.uri) return _call('subtitle', <String, String>{});
    final id = track.id;
    final Uri uri;
    final String mimeType;
    const memory = 'memory://';
    if (id.startsWith(memory)) {
      mimeType = 'text/vtt';
      uri = Uri.dataFromString(
        id.substring(memory.length),
        mimeType: mimeType,
        encoding: utf8,
      );
    } else {
      uri = id.startsWith('/') ? Uri.file(id) : Uri.parse(id);
      mimeType = switch (uri.path.toLowerCase().split('.').last) {
        'ass' || 'ssa' => 'text/x-ssa',
        'srt' => 'application/x-subrip',
        _ => 'text/vtt',
      };
    }
    return _call('subtitle', {'uri': uri.toString(), 'mimeType': mimeType});
  }

  Future<void> _onEvent(MethodCall event) async {
    if (_disposed) return;
    switch (event.method) {
      case 'state':
        final values = event.arguments as Map;
        final playing = values['playing'] as bool;
        final completed = values['completed'] as bool;
        final buffering = values['buffering'] as bool;
        final position = Duration(milliseconds: values['position'] as int);
        final duration = Duration(milliseconds: values['duration'] as int);
        final buffer = Duration(milliseconds: values['buffer'] as int);
        final width = values['width'] as int;
        final height = values['height'] as int;
        if (state.playing != playing) playingController.add(playing);
        if (state.completed != completed) completedController.add(completed);
        if (state.buffering != buffering) bufferingController.add(buffering);
        if (state.position != position) positionController.add(position);
        if (duration > Duration.zero && state.duration != duration) {
          durationController.add(duration);
          state.duration = duration;
        }
        if (state.buffer != buffer) bufferController.add(buffer);
        if (state.width != width || state.height != height) {
          sizeController.add((width, height));
        }
        state
          ..playing = playing
          ..completed = completed
          ..buffering = buffering
          ..position = position
          ..buffer = buffer
          ..width = width
          ..height = height;
      case 'subtitle':
        final value = event.arguments as String;
        subtitleController.add(state.subtitle = Subtitle.raw(value));
      case 'error':
        errorController.add(event.arguments as String);
    }
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _channel.setMethodCallHandler(null);
    try {
      await _channel.invokeMethod<void>('dispose');
    } finally {
      await super.dispose();
    }
  }
}
