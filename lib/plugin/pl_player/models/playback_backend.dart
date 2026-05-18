import 'dart:async';
import 'dart:typed_data';

import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

enum PlaybackBackendType {
  mediaKit,
  androidHdr,
}

class PlaybackStateSnapshot {
  const PlaybackStateSnapshot({
    this.playing = false,
    this.completed = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.width = 0,
    this.height = 0,
    this.rate = 1.0,
  });

  final bool playing;
  final bool completed;
  final Duration position;
  final Duration duration;
  final int width;
  final int height;
  final double rate;
}

class PlaybackBackendEvent {
  const PlaybackBackendEvent({
    this.status,
    this.position,
    this.duration,
    this.buffered,
    this.buffering,
    this.width,
    this.height,
    this.error,
    this.ready = false,
  });

  final PlayerStatus? status;
  final Duration? position;
  final Duration? duration;
  final Duration? buffered;
  final bool? buffering;
  final int? width;
  final int? height;
  final String? error;
  final bool ready;
}

abstract class PlaybackBackend {
  PlaybackBackendType get type;
  Player? get mediaKitPlayer => null;
  VideoController? get mediaKitVideoController => null;
  PlaybackStateSnapshot get state;
  Stream<PlaybackBackendEvent> get events;
  bool get supportsShader => false;
  bool get supportsNativeSubtitle => false;
  bool get supportsVideoTrack => false;
  bool get hasView => true;

  Future<void> open(
    DataSource dataSource, {
    Duration? start,
    Duration? duration,
    bool play = false,
    Map<String, String>? headers,
    VideoFitType fit = VideoFitType.contain,
  });

  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> setPlaybackSpeed(double speed);
  Future<void> setVolume(double volume);
  Future<void> setVideoEnabled(bool enabled) async {}
  Future<void> setSubtitleTrack(SubtitleTrack track) async {}
  Future<Uint8List?> screenshot() async => null;
  Widget? buildView({required Color fill, required VideoFitType fit}) => null;
  Future<void> dispose();
}
