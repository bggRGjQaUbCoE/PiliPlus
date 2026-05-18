import 'dart:async';
import 'dart:io' show Platform;

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/playback_backend.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class MediaKitPlaybackBackend extends PlaybackBackend {
  MediaKitPlaybackBackend({
    required this.isLive,
    required this.hwdec,
    required this.options,
    required this.bufferSize,
    required this.videoControllerConfiguration,
  });

  final bool isLive;
  final String? hwdec;
  final Map<String, String> options;
  final int bufferSize;
  final VideoControllerConfiguration videoControllerConfiguration;

  Player? _player;
  VideoController? _videoController;
  final _events = StreamController<PlaybackBackendEvent>.broadcast();
  final List<StreamSubscription> _subscriptions = [];

  @override
  PlaybackBackendType get type => PlaybackBackendType.mediaKit;

  @override
  Player? get mediaKitPlayer => _player;

  @override
  VideoController? get mediaKitVideoController => _videoController;

  @override
  Stream<PlaybackBackendEvent> get events => _events.stream;

  @override
  bool get supportsShader => true;

  @override
  bool get supportsNativeSubtitle => true;

  @override
  bool get supportsVideoTrack => true;

  @override
  PlaybackStateSnapshot get state {
    final state = _player?.state;
    if (state == null) return const PlaybackStateSnapshot();
    return PlaybackStateSnapshot(
      playing: state.playing,
      completed: state.completed,
      position: state.position,
      duration: state.duration,
      width: state.width,
      height: state.height,
      rate: state.rate,
    );
  }

  Future<Player> _ensurePlayer() async {
    if (_player case final player?) return player;
    final player = await Player.create(
      configuration: PlayerConfiguration(
        bufferSize: bufferSize,
        logLevel: kDebugMode ? .warn : .error,
        options: options,
      ),
    );
    _videoController = await VideoController.create(
      player,
      configuration: videoControllerConfiguration,
    );
    player.setMediaHeader(
      userAgent: BrowserUa.pc,
      referer: HttpString.baseUrl,
    );
    _player = player;
    _listen(player);
    return player;
  }

  @override
  Future<void> open(
    DataSource dataSource, {
    Duration? start,
    Duration? duration,
    bool play = false,
    Map<String, String>? headers,
    VideoFitType fit = VideoFitType.contain,
  }) async {
    final player = await _ensurePlayer();
    final extras = <String, String>{};
    var video = dataSource.videoSource;
    if (dataSource.audioSource case final audio? when audio.isNotEmpty) {
      extras['audio-files'] =
          '"${Platform.isWindows ? audio.replaceAll(';', r'\;') : audio.replaceAll(':', r'\:')}"';
    }
    await player.open(
      Media(video, start: start, extras: extras.isEmpty ? null : extras),
      play: play,
    );
  }

  @override
  Future<void> play() => _player?.play() ?? Future.value();

  @override
  Future<void> pause() => _player?.pause() ?? Future.value();

  @override
  Future<void> seek(Duration position) =>
      _player?.seek(position) ?? Future.value();

  @override
  Future<void> setPlaybackSpeed(double speed) =>
      _player?.setRate(speed) ?? Future.value();

  @override
  Future<void> setVolume(double volume) =>
      _player?.setVolume(volume) ?? Future.value();

  @override
  Future<void> setVideoEnabled(bool enabled) {
    return _player?.setVideoTrack(
          enabled ? VideoTrack.auto() : VideoTrack.no(),
        ) ??
        Future.value();
  }

  @override
  Future<void> setSubtitleTrack(SubtitleTrack track) {
    return _player?.setSubtitleTrack(track) ?? Future.value();
  }

  @override
  Future<Uint8List?> screenshot() {
    return _player?.screenshot(format: ScreenshotFormat.png) ?? Future.value();
  }

  @override
  Widget? buildView({required Color fill, required VideoFitType fit}) {
    final controller = _videoController;
    if (controller == null) return null;
    return SimpleVideo(
      controller: controller,
      fill: fill,
      aspectRatio: fit.aspectRatio,
    );
  }

  void _listen(Player player) {
    final stream = player.stream;
    _subscriptions
      ..add(
        stream.playing.listen((playing) {
          _events.add(
            PlaybackBackendEvent(
              status: playing ? PlayerStatus.playing : PlayerStatus.paused,
            ),
          );
        }),
      )
      ..add(
        stream.completed.listen((completed) {
          if (completed) {
            _events.add(
              const PlaybackBackendEvent(status: PlayerStatus.completed),
            );
          }
        }),
      )
      ..add(
        stream.position.listen((position) {
          _events.add(PlaybackBackendEvent(position: position));
        }),
      )
      ..add(
        stream.duration.listen((duration) {
          _events.add(PlaybackBackendEvent(duration: duration));
        }),
      )
      ..add(
        stream.buffer.listen((buffered) {
          _events.add(PlaybackBackendEvent(buffered: buffered));
        }),
      )
      ..add(
        stream.buffering.listen((buffering) {
          _events.add(PlaybackBackendEvent(buffering: buffering));
        }),
      )
      ..add(
        stream.error.listen((error) {
          _events.add(PlaybackBackendEvent(error: error));
        }),
      );
    if (kDebugMode) {
      _subscriptions.add(
        stream.log.listen((log) {
          if (log.level == 'error' || log.level == 'fatal') {
            debugPrint('${log.level}: ${log.prefix}: ${log.text}');
          } else {
            debugPrint(log.toString());
          }
        }),
      );
    }
  }

  @override
  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
    await _player?.dispose();
    _player = null;
    _videoController = null;
    await _events.close();
  }
}
