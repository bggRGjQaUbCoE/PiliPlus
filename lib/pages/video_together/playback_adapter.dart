import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_status.dart';
import 'package:PiliPlus/services/video_together/models.dart';
import 'package:PiliPlus/services/video_together/playback.dart';

final class PlPlayerVideoTogetherPlayback implements VideoTogetherPlayback {
  const PlPlayerVideoTogetherPlayback(
    this.controller, {
    this.preparePlayback,
    this.isCurrentMediaReady,
  });

  final PlPlayerController controller;
  final VideoTogetherPreparePlayback? preparePlayback;
  final bool Function()? isCurrentMediaReady;

  @override
  bool get isReady =>
      controller.videoPlayerController != null &&
      controller.dataStatus.value == DataStatus.loaded &&
      (isCurrentMediaReady?.call() ?? true);

  @override
  bool get isPlaying =>
      controller.videoPlayerController?.state.playing ?? false;

  @override
  bool get isBuffering => !isReady || controller.isBuffering.value;
  @override
  bool get keepsPlayingInBackground => controller.keepsPlayingInBackground;

  @override
  double get positionSeconds => controller.positionInMilliseconds / 1000;

  @override
  double get durationSeconds => controller.durationInMilliseconds / 1000;

  @override
  double get playbackRate => controller.playbackSpeed;

  @override
  Future<void> prepare() async {
    if (isReady) return;
    final future = preparePlayback?.call();
    if (future != null) await future;
  }

  @override
  Future<void> recover() async {
    final future = controller.refreshPlayer();
    if (future != null) await future;
  }

  @override
  Future<void> pause() => controller.pause();

  @override
  Future<void> play() => controller.play();

  @override
  Future<void> seek(double seconds) => controller.seekTo(
    Duration(milliseconds: (seconds * 1000).round()),
    isSeek: false,
  );

  @override
  Future<void> setPlaybackRate(double rate) =>
      controller.setPlaybackSpeed(rate);
}

abstract final class VideoTogetherMediaBuilder {
  static VideoTogetherMedia ugc({
    required String bvid,
    required String title,
    int part = 1,
  }) {
    final uri = Uri.https(
      'www.bilibili.com',
      '/video/$bvid',
      part > 1 ? {'p': '$part'} : null,
    );
    return VideoTogetherMedia(url: uri.toString(), title: title);
  }

  static VideoTogetherMedia pgc({required int epId, required String title}) =>
      VideoTogetherMedia(
        url: 'https://www.bilibili.com/bangumi/play/ep$epId',
        title: title,
      );
}
