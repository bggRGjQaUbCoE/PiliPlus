import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/playback_backend.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:flutter/foundation.dart' show Factory;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' hide Uint8List;

class AndroidHdrPlaybackBackend extends PlaybackBackend {
  AndroidHdrPlaybackBackend();

  static const MethodChannel _channel = MethodChannel('PiliPlus/HdrPlayer');
  static const EventChannel _eventsChannel = EventChannel(
    'PiliPlus/HdrPlayer/events',
  );
  // Process-wide native event stream shared by all short-lived HDR sessions.
  static StreamSubscription? _eventSubscription; // ignore: cancel_subscriptions
  static final Map<int, AndroidHdrPlaybackBackend> _instances = {};

  int? _sessionId;
  PlaybackStateSnapshot _state = const PlaybackStateSnapshot();
  final _events = StreamController<PlaybackBackendEvent>.broadcast();

  @override
  PlaybackBackendType get type => PlaybackBackendType.androidHdr;

  int? get sessionId => _sessionId;

  @override
  Stream<PlaybackBackendEvent> get events => _events.stream;

  @override
  PlaybackStateSnapshot get state => _state;

  @override
  Future<void> open(
    DataSource dataSource, {
    Duration? start,
    Duration? duration,
    bool play = false,
    Map<String, String>? headers,
    VideoFitType fit = VideoFitType.contain,
    int? width,
    int? height,
  }) async {
    _ensureEventSubscription();
    final sessionId = await _channel.invokeMethod<int>('create');
    if (sessionId == null) {
      throw StateError('failed to create Android HDR player session');
    }
    _sessionId = sessionId;
    _instances[sessionId] = this;
    await _channel.invokeMethod<void>('setHdrMode', {'enabled': true});
    await _channel.invokeMethod<void>('open', {
      'sessionId': sessionId,
      'videoUrl': dataSource.videoSource,
      'audioUrl': dataSource.audioSource,
      'isFileSource': dataSource is FileSource,
      'qualityCode': dataSource.qualityCode,
      'frameRate': dataSource.frameRate,
      'width': width,
      'height': height,
      'startMs': start?.inMilliseconds ?? 0,
      'durationMs': duration?.inMilliseconds,
      'headers': headers ?? const <String, String>{},
      'fitMode': _fitModeName(fit),
    });
    if (play) {
      await this.play();
    }
  }

  @override
  Future<void> play() => _invoke('play');

  @override
  Future<void> pause() => _invoke('pause');

  @override
  Future<void> seek(Duration position) => _invoke(
    'seekTo',
    {'positionMs': position.inMilliseconds},
  );

  @override
  Future<void> setPlaybackSpeed(double speed) => _invoke(
    'setPlaybackSpeed',
    {'speed': speed},
  );

  @override
  Future<void> setVolume(double volume) => _invoke(
    'setVolume',
    {'volume': volume.clamp(0.0, 1.0)},
  );

  Future<void> setFit(VideoFitType fit) => _invoke(
    'setFitMode',
    {'fitMode': _fitModeName(fit)},
  );

  @override
  Future<Uint8List?> screenshot() async {
    final id = _sessionId;
    if (id == null) return null;
    final bytes = await _channel.invokeMethod<Uint8List>('screenshot', {
      'sessionId': id,
    });
    return bytes;
  }

  @override
  Widget? buildView({required Color fill, required VideoFitType fit}) {
    final id = _sessionId;
    if (id == null || !(Platform.isAndroid || Platform.isIOS)) {
      return ColoredBox(color: fill);
    }
    const viewType = 'com.example.piliplus/hdr_player_view';
    final creationParams = {'sessionId': id};
    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        hitTestBehavior: PlatformViewHitTestBehavior.transparent,
      );
    }
    return PlatformViewLink(
      viewType: 'com.example.piliplus/hdr_player_view',
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          hitTestBehavior: PlatformViewHitTestBehavior.transparent,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )..addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
      },
    );
  }

  @override
  Future<void> dispose() async {
    final id = _sessionId;
    _sessionId = null;
    if (id != null) {
      _instances.remove(id);
      await _channel.invokeMethod<void>('dispose', {'sessionId': id});
    }
    await _events.close();
  }

  Future<void> _invoke(String method, [Map<String, Object?>? args]) {
    final id = _sessionId;
    if (id == null) return Future.value();
    return _channel.invokeMethod<void>(method, {
      'sessionId': id,
      ...?args,
    });
  }

  void _handleEvent(Map<dynamic, dynamic> event) {
    final type = event['type'] as String?;
    if (type == null) return;
    switch (type) {
      case 'ready':
        _events.add(
          const PlaybackBackendEvent(
            ready: true,
            buffering: false,
          ),
        );
        return;
      case 'playing':
        _state = PlaybackStateSnapshot(
          playing: true,
          completed: false,
          position: _state.position,
          duration: _state.duration,
          width: _state.width,
          height: _state.height,
          rate: _state.rate,
        );
        _events.add(
          const PlaybackBackendEvent(
            status: PlayerStatus.playing,
            buffering: false,
          ),
        );
        return;
      case 'paused':
        _state = PlaybackStateSnapshot(
          playing: false,
          completed: _state.completed,
          position: _state.position,
          duration: _state.duration,
          width: _state.width,
          height: _state.height,
          rate: _state.rate,
        );
        _events.add(
          const PlaybackBackendEvent(
            status: PlayerStatus.paused,
            buffering: false,
          ),
        );
        return;
      case 'completed':
        _state = PlaybackStateSnapshot(
          playing: false,
          completed: true,
          position: _state.position,
          duration: _state.duration,
          width: _state.width,
          height: _state.height,
          rate: _state.rate,
        );
        _events.add(
          const PlaybackBackendEvent(
            status: PlayerStatus.completed,
          ),
        );
        return;
      case 'buffering':
        _events.add(PlaybackBackendEvent(buffering: event['value'] == true));
        return;
      case 'position':
        final position = _duration(event['positionMs']);
        final duration = _duration(event['durationMs']);
        final buffered = _duration(event['bufferedMs']);
        _state = PlaybackStateSnapshot(
          playing: _state.playing,
          completed: _state.completed,
          position: position,
          duration: duration == Duration.zero ? _state.duration : duration,
          width: _state.width,
          height: _state.height,
          rate: _state.rate,
        );
        _events.add(
          PlaybackBackendEvent(
            position: position,
            duration: duration == Duration.zero ? null : duration,
            buffered: buffered,
          ),
        );
        return;
      case 'duration':
        final duration = _duration(event['durationMs']);
        _state = PlaybackStateSnapshot(
          playing: _state.playing,
          completed: _state.completed,
          position: _state.position,
          duration: duration,
          width: _state.width,
          height: _state.height,
          rate: _state.rate,
        );
        _events.add(PlaybackBackendEvent(duration: duration));
        return;
      case 'buffered':
        _events.add(
          PlaybackBackendEvent(
            buffered: _duration(event['bufferedMs']),
          ),
        );
        return;
      case 'size':
        final width = (event['width'] as num?)?.toInt() ?? 0;
        final height = (event['height'] as num?)?.toInt() ?? 0;
        _state = PlaybackStateSnapshot(
          playing: _state.playing,
          completed: _state.completed,
          position: _state.position,
          duration: _state.duration,
          width: width,
          height: height,
          rate: _state.rate,
        );
        _events.add(PlaybackBackendEvent(width: width, height: height));
        return;
      case 'error':
        final message = event['message'] as String?;
        final errorCodeName = event['errorCodeName'] as String?;
        final cause = event['cause'] as String?;
        final rendererName = event['rendererName'] as String?;
        final rendererFormat = event['rendererFormat'] as String?;
        final isAudioError = event['isAudioError'] == true;
        _events.add(
          PlaybackBackendEvent(
            error: [
              if (isAudioError) 'AUDIO_RENDERER_ERROR',
              if (errorCodeName?.isNotEmpty == true) errorCodeName,
              if (rendererName?.isNotEmpty == true) rendererName,
              if (rendererFormat?.isNotEmpty == true) rendererFormat,
              if (message?.isNotEmpty == true) message,
              if (cause?.isNotEmpty == true) cause,
            ].join(' | '),
          ),
        );
        return;
      default:
        return;
    }
  }

  static Future<bool> supportsHdr({int? qualityCode}) async {
    if (!(Platform.isAndroid || Platform.isIOS)) return false;
    try {
      return await _channel.invokeMethod<bool>('supportsHdr', {
            'qualityCode': qualityCode,
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static void _ensureEventSubscription() {
    _eventSubscription ??= _eventsChannel.receiveBroadcastStream().listen(
      (event) {
        if (event is Map) {
          final id = event['sessionId'] as int?;
          if (id != null) {
            _instances[id]?._handleEvent(event);
          }
        }
      },
      onError: (_, _) {},
    );
  }

  static Duration _duration(Object? value) {
    return Duration(milliseconds: (value as num?)?.toInt() ?? 0);
  }

  static String _fitModeName(VideoFitType fit) => switch (fit) {
    VideoFitType.fill => 'fill',
    VideoFitType.cover => 'cover',
    VideoFitType.fitWidth => 'fitWidth',
    VideoFitType.fitHeight => 'fitHeight',
    _ => 'contain',
  };
}
