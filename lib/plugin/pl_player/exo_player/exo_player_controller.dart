import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/exo_player/exo_subtitle_cue.dart';
import 'package:PiliPlus/plugin/pl_player/models/exo_player_failure.dart';
import 'package:PiliPlus/plugin/pl_player/models/player_media_track.dart';
import 'package:flutter/services.dart';

class ExoPlayerEvent {
  const ExoPlayerEvent({
    required this.generation,
    required this.type,
    required this.position,
    required this.buffered,
    required this.duration,
    required this.playing,
    required this.playWhenReady,
    required this.buffering,
    required this.ready,
    required this.completed,
    required this.width,
    required this.height,
    required this.speed,
    required this.subtitle,
    required this.subtitleCues,
    required this.tracks,
    required this.volume,
    required this.firstVideoFrameRendered,
    this.videoDecoder,
    this.audioDecoder,
    this.mediaDescription,
    this.playbackConfiguration,
    this.superResolution,
    this.failure,
  });

  final int generation;
  final String type;
  final Duration position;
  final Duration buffered;
  final Duration duration;
  final bool playing;
  final bool playWhenReady;
  final bool buffering;
  final bool ready;
  final bool completed;
  final int width;
  final int height;
  final double speed;
  final String subtitle;
  final List<ExoSubtitleCue> subtitleCues;
  final List<PlayerMediaTrack> tracks;
  final double volume;
  final bool firstVideoFrameRendered;
  final String? videoDecoder;
  final String? audioDecoder;
  final String? mediaDescription;
  final String? playbackConfiguration;
  final String? superResolution;
  final ExoPlayerPlaybackFailure? failure;

  factory ExoPlayerEvent.fromMap(Map<Object?, Object?> map) {
    int intValue(String key) => (map[key] as num?)?.toInt() ?? 0;
    final failure = switch (map['error']) {
      final Map error => ExoPlayerPlaybackFailure.fromMap(
        Map<Object?, Object?>.from(error),
      ),
      _ => switch (map['message']) {
        final String message => ExoPlayerPlaybackFailure.legacy(message),
        _ => null,
      },
    };
    return ExoPlayerEvent(
      generation: intValue('generation'),
      type: map['type'] as String? ?? 'state',
      position: Duration(milliseconds: intValue('positionMs')),
      buffered: Duration(milliseconds: intValue('bufferedMs')),
      duration: Duration(milliseconds: intValue('durationMs')),
      playing: map['playing'] as bool? ?? false,
      playWhenReady: map['playWhenReady'] as bool? ?? false,
      buffering: map['buffering'] as bool? ?? false,
      ready: map['ready'] as bool? ?? false,
      completed: map['completed'] as bool? ?? false,
      width: intValue('width'),
      height: intValue('height'),
      speed: (map['speed'] as num?)?.toDouble() ?? 1,
      subtitle: map['subtitle'] as String? ?? '',
      subtitleCues: switch (map['subtitleCues']) {
        final List cues =>
          cues
              .whereType<Map>()
              .map(
                (cue) => ExoSubtitleCue.fromMap(
                  Map<Object?, Object?>.from(cue),
                ),
              )
              .toList(growable: false),
        _ => const [],
      },
      tracks: switch (map['tracks']) {
        final List tracks =>
          tracks
              .whereType<Map>()
              .map(
                (track) => PlayerMediaTrack.fromMap(
                  Map<Object?, Object?>.from(track),
                ),
              )
              .toList(growable: false),
        _ => const [],
      },
      volume: (map['volume'] as num?)?.toDouble() ?? 1,
      firstVideoFrameRendered: map['firstVideoFrameRendered'] as bool? ?? false,
      videoDecoder: map['videoDecoder'] as String?,
      audioDecoder: map['audioDecoder'] as String?,
      mediaDescription: map['mediaDescription'] as String?,
      playbackConfiguration: map['playbackConfiguration'] as String?,
      superResolution: map['superResolution'] as String?,
      failure: failure,
    );
  }
}

class ExoPlayerController {
  ExoPlayerController._(this.id, this.textureId);

  static const MethodChannel _methods = MethodChannel(
    'com.example.piliplus/exo_player',
  );
  static const EventChannel _events = EventChannel(
    'com.example.piliplus/exo_player_events',
  );
  static int _nextId = 1;
  static Stream<Map<Object?, Object?>>? _eventStream;

  static Stream<Map<Object?, Object?>> get eventStream =>
      _eventStream ??= _events.receiveBroadcastStream().map(
        (event) => Map<Object?, Object?>.from(event as Map),
      );

  final int id;
  final int textureId;
  StreamSubscription<Map<Object?, Object?>>? _subscription;
  final StreamController<ExoPlayerEvent> _controller =
      StreamController<ExoPlayerEvent>.broadcast();
  int _generation = 0;
  bool _playWhenReady = false;

  ExoPlayerEvent state = const ExoPlayerEvent(
    generation: 0,
    type: 'state',
    position: Duration.zero,
    buffered: Duration.zero,
    duration: Duration.zero,
    playing: false,
    playWhenReady: false,
    buffering: false,
    ready: false,
    completed: false,
    width: 0,
    height: 0,
    speed: 1,
    subtitle: '',
    subtitleCues: [],
    tracks: [],
    volume: 1,
    firstVideoFrameRendered: false,
  );

  Stream<ExoPlayerEvent> get events => _controller.stream;
  bool get playWhenReady => _playWhenReady;

  static Future<ExoPlayerController> create({
    bool enableHardwareDecoding = true,
    String? decoderMode,
    int targetBufferBytes = 4 * 1024 * 1024,
    int bufferDurationMs = 16000,
    bool isLive = false,
  }) async {
    final id = _nextId++;
    final textureId = await _methods.invokeMethod<int>('create', {
      'id': id,
      'enableHardwareDecoding': enableHardwareDecoding,
      'decoderMode': ?decoderMode,
      'targetBufferBytes': targetBufferBytes,
      'bufferDurationMs': bufferDurationMs,
      'isLive': isLive,
    });
    if (textureId == null) {
      throw StateError('ExoPlayer did not create a Flutter texture');
    }
    final player = ExoPlayerController._(id, textureId);
    player._subscription = eventStream
        .where((event) => (event['id'] as num?)?.toInt() == player.id)
        .listen((event) {
          final next = ExoPlayerEvent.fromMap(event);
          if (next.generation < player._generation) {
            return;
          }
          player._generation = next.generation;
          if (event.containsKey('playWhenReady')) {
            player._playWhenReady = next.playWhenReady;
          }
          player.state = ExoPlayerEvent(
            generation: next.generation,
            type: next.type,
            position: event.containsKey('positionMs')
                ? next.position
                : player.state.position,
            buffered: event.containsKey('bufferedMs')
                ? next.buffered
                : player.state.buffered,
            duration: event.containsKey('durationMs')
                ? next.duration
                : player.state.duration,
            playing: event.containsKey('playing')
                ? next.playing
                : player.state.playing,
            playWhenReady: event.containsKey('playWhenReady')
                ? next.playWhenReady
                : player.state.playWhenReady,
            buffering: event.containsKey('buffering')
                ? next.buffering
                : player.state.buffering,
            ready: event.containsKey('ready') ? next.ready : player.state.ready,
            completed: event.containsKey('completed')
                ? next.completed
                : player.state.completed,
            width: event.containsKey('width') ? next.width : player.state.width,
            height: event.containsKey('height')
                ? next.height
                : player.state.height,
            speed: event.containsKey('speed') ? next.speed : player.state.speed,
            subtitle: event.containsKey('subtitle')
                ? next.subtitle
                : player.state.subtitle,
            subtitleCues: event.containsKey('subtitleCues')
                ? next.subtitleCues
                : player.state.subtitleCues,
            tracks: event.containsKey('tracks')
                ? next.tracks
                : player.state.tracks,
            volume: event.containsKey('volume')
                ? next.volume
                : player.state.volume,
            firstVideoFrameRendered:
                event.containsKey(
                  'firstVideoFrameRendered',
                )
                ? next.firstVideoFrameRendered
                : player.state.firstVideoFrameRendered,
            videoDecoder: event.containsKey('videoDecoder')
                ? next.videoDecoder
                : player.state.videoDecoder,
            audioDecoder: event.containsKey('audioDecoder')
                ? next.audioDecoder
                : player.state.audioDecoder,
            mediaDescription: event.containsKey('mediaDescription')
                ? next.mediaDescription
                : player.state.mediaDescription,
            playbackConfiguration: event.containsKey('playbackConfiguration')
                ? next.playbackConfiguration
                : player.state.playbackConfiguration,
            superResolution: event.containsKey('superResolution')
                ? next.superResolution
                : player.state.superResolution,
            failure: next.failure,
          );
          player._controller.add(player.state);
        });
    return player;
  }

  Future<void> open({
    required String videoUrl,
    String? audioUrl,
    required Map<String, String> headers,
    int? expectedWidth,
    int? expectedHeight,
    bool isLive = false,
    Duration position = Duration.zero,
    bool playWhenReady = false,
    bool preserveSubtitle = false,
    Map<String, Object>? audioNormalization,
  }) {
    final generation = ++_generation;
    _playWhenReady = playWhenReady;
    return _methods.invokeMethod<void>('open', {
      'id': id,
      'generation': generation,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'headers': headers,
      'expectedWidth': expectedWidth,
      'expectedHeight': expectedHeight,
      'isLive': isLive,
      'positionMs': position.inMilliseconds,
      'playWhenReady': playWhenReady,
      'preserveSubtitle': preserveSubtitle,
      'audioNormalization': audioNormalization,
    });
  }

  Future<void> play() {
    _playWhenReady = true;
    return _invoke('play');
  }

  Future<void> pause() {
    _playWhenReady = false;
    return _invoke('pause');
  }

  Future<void> retry({
    required Duration position,
    required bool playWhenReady,
    bool forceSoftwareVideo = false,
  }) {
    _playWhenReady = playWhenReady;
    return _methods.invokeMethod<void>('retry', {
      'id': id,
      'positionMs': position.inMilliseconds,
      'playWhenReady': playWhenReady,
      'forceSoftwareVideo': forceSoftwareVideo,
    });
  }

  Future<void> seek(Duration position) => _methods.invokeMethod<void>(
    'seekTo',
    {'id': id, 'positionMs': position.inMilliseconds},
  );

  Future<void> setPlaybackSpeed(double speed) => _methods.invokeMethod<void>(
    'setPlaybackSpeed',
    {'id': id, 'speed': speed},
  );

  Future<void> setVolume(double volume) =>
      _methods.invokeMethod<void>('setVolume', {'id': id, 'volume': volume});

  Future<void> setSuperResolution(String mode) =>
      _methods.invokeMethod<void>('setSuperResolution', {
        'id': id,
        'mode': mode,
      });

  Future<Uint8List> captureFrame({
    required bool flipX,
    required bool flipY,
  }) async {
    final bytes = await _methods.invokeMethod<Uint8List>('captureFrame', {
      'id': id,
      'flipX': flipX,
      'flipY': flipY,
    });
    if (bytes == null || bytes.isEmpty) {
      throw StateError('ExoPlayer returned an empty captured frame');
    }
    return bytes;
  }

  Future<bool> startAnimatedWebp({
    required int taskId,
    required String url,
    required String outFile,
    required Map<String, String> headers,
    required Duration start,
    required Duration end,
    required String preset,
  }) async =>
      await _methods.invokeMethod<bool>('startAnimatedWebp', {
        'id': id,
        'taskId': taskId,
        'url': url,
        'outFile': outFile,
        'headers': headers,
        'startMs': start.inMilliseconds,
        'endMs': end.inMilliseconds,
        'preset': preset,
      }) ??
      false;

  Future<double> animatedWebpProgress(int taskId) async =>
      (await _methods.invokeMethod<num>('animatedWebpProgress', {
        'id': id,
        'taskId': taskId,
      }))?.toDouble() ??
      0;

  Future<void> cancelAnimatedWebp(int taskId) =>
      _methods.invokeMethod<void>('cancelAnimatedWebp', {
        'id': id,
        'taskId': taskId,
      });

  Future<void> setSubtitle({
    String? data,
    String? uri,
    String? language,
    String? label,
    String? mimeType,
  }) => _methods.invokeMethod<void>('setSubtitle', {
    'id': id,
    'data': data,
    'uri': uri,
    'language': language,
    'label': label,
    'mimeType': mimeType,
  });

  Future<void> setTrackSelection({
    required PlayerMediaTrackType type,
    required PlayerTrackSelectionMode mode,
    PlayerMediaTrack? track,
  }) => _methods.invokeMethod<void>('setTrackSelection', {
    'id': id,
    'type': type.name,
    'mode': mode.name,
    'groupIndex': track?.groupIndex,
    'trackIndex': track?.trackIndex,
  });

  Future<void> _invoke(String method) =>
      _methods.invokeMethod<void>(method, {'id': id});

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _methods.invokeMethod<void>('dispose', {'id': id});
    await _controller.close();
  }
}
