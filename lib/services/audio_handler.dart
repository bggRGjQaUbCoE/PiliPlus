import 'dart:io' show File, Platform;
import 'dart:ui' show PlatformDispatcher;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pb.dart' show DetailItem;
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

Future<VideoPlayerServiceHandler> initAudioService() {
  return AudioService.init(
    builder: VideoPlayerServiceHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.piliplus.audio',
      androidNotificationChannelName: 'Audio Service ${Constants.appName}',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      fastForwardInterval: Duration(seconds: 10),
      rewindInterval: Duration(seconds: 10),
      androidNotificationChannelDescription: 'Media notification channel',
      androidNotificationIcon: 'drawable/ic_notification_icon',
    ),
  );
}

class VideoPlayerServiceHandler extends BaseAudioHandler with SeekHandler {
  static final List<MediaItem> _item = [];

  Future<void>? Function()? onPlay;
  Future<void>? Function()? onPause;
  Future<void>? Function(Duration position)? onSeek;

  @override
  Future<void> play() {
    return onPlay?.call() ??
        PlPlayerController.playIfExists() ??
        Future.syncValue(null);
  }

  @override
  Future<void> pause() {
    return onPause?.call() ?? PlPlayerController.pauseIfExists();
  }

  @override
  Future<void> seek(Duration position) {
    playbackState.add(
      playbackState.value.copyWith(
        updatePosition: position,
      ),
    );
    return (onSeek?.call(position) ??
        PlPlayerController.seekToIfExists(position, isSeek: false));
  }

  void setMediaItem(MediaItem newMediaItem) {
    if (!mediaItem.isClosed) mediaItem.add(newMediaItem);
  }

  void setPlaybackState(
    PlayerStatus status,
    bool isBuffering,
    bool isLive,
  ) {
    final AudioProcessingState processingState;
    if (status.isCompleted) {
      processingState = .completed;
    } else if (isBuffering) {
      processingState = .buffering;
    } else {
      processingState = .ready;
    }

    final playing = status.isPlaying;
    playbackState.add(
      playbackState.value.copyWith(
        processingState: isBuffering ? .buffering : processingState,
        controls: [
          if (!isLive)
            MediaControl.skipToPrevious.copyWith(
              androidIcon: 'drawable/ic_player_rewind_10s',
            ),
          if (playing)
            MediaControl.pause.copyWith(androidIcon: 'drawable/ic_player_pause')
          else
            MediaControl.play.copyWith(androidIcon: 'drawable/ic_player_play'),
          if (!isLive)
            MediaControl.skipToNext.copyWith(
              androidIcon: 'drawable/ic_player_fast_forward_10s',
            ),
        ],
        playing: playing,
        systemActions: const {MediaAction.seek},
      ),
    );
    if (Platform.isAndroid && AndroidHelper.isPipMode) {
      AndroidHelper.updatePipActions(
        PlatformDispatcher.instance.engineId!,
        isLive,
        playing,
      );
    }
  }

  @override
  Future<void> skipToPrevious() => rewind();

  @override
  Future<void> skipToNext() => fastForward();

  void onStatusChange(PlayerStatus status, bool isBuffering, isLive) {
    if (_item.isEmpty) return;
    setPlaybackState(status, isBuffering, isLive);
  }

  void onVideoDetailChange(
    dynamic data,
    int cid,
    String herotag, {
    String? artist,
    String? cover,
  }) {
    if (!PlPlayerController.instanceExists()) return;
    if (data == null) return;

    Uri getUri(String? cover) => Uri.parse(ImageUtils.safeThumbnailUrl(cover));

    late final id = '$cid$herotag';
    final MediaItem mediaItem;
    switch (data) {
      case VideoDetailData(:final pages):
        if (pages != null && pages.length > 1) {
          final current = pages.firstWhereOrNull((e) => e.cid == cid);
          mediaItem = MediaItem(
            id: id,
            title: current?.part ?? '',
            artist: data.owner?.name,
            duration: Duration(seconds: current?.duration ?? 0),
            artUri: getUri(data.pic),
          );
        } else {
          mediaItem = MediaItem(
            id: id,
            title: data.title ?? '',
            artist: data.owner?.name,
            duration: Duration(seconds: data.duration ?? 0),
            artUri: getUri(data.pic),
          );
        }
      case EpisodeItem():
        mediaItem = MediaItem(
          id: id,
          title: data.showTitle ?? data.longTitle ?? data.title ?? '',
          artist: artist,
          duration: data.from == 'pugv'
              ? Duration(seconds: data.duration ?? 0)
              : Duration(milliseconds: data.duration ?? 0),
          artUri: getUri(data.cover),
        );
      case RoomInfoH5Data():
        mediaItem = MediaItem(
          id: id,
          title: data.roomInfo?.title ?? '',
          artist: data.anchorInfo?.baseInfo?.uname,
          artUri: getUri(data.roomInfo?.cover),
          isLive: true,
        );
      case Part():
        mediaItem = MediaItem(
          id: id,
          title: data.part ?? '',
          artist: artist,
          duration: Duration(seconds: data.duration ?? 0),
          artUri: getUri(cover),
        );
      case DetailItem(:final arc):
        mediaItem = MediaItem(
          id: id,
          title: arc.title,
          artist: data.owner.name,
          duration: Duration(seconds: arc.duration.toInt()),
          artUri: getUri(arc.cover),
        );
      case BiliDownloadEntryInfo():
        final coverFile = File(
          path.join(data.entryDirPath, PathUtils.coverName),
        );
        final uri = coverFile.existsSync()
            ? coverFile.absolute.uri
            : getUri(data.cover);
        mediaItem = MediaItem(
          id: id,
          title: data.showTitle,
          artist: data.ownerName,
          duration: Duration(milliseconds: data.totalTimeMilli),
          artUri: uri,
        );
      default:
        return;
    }
    if (!PlPlayerController.instanceExists()) return;
    _item.add(mediaItem);
    setMediaItem(mediaItem);
  }

  void onVideoDetailDispose(String herotag) {
    if (_item.isNotEmpty) {
      _item.removeWhere((item) => item.id.endsWith(herotag));
    }
    if (_item.isNotEmpty) {
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.idle,
          playing: false,
        ),
      );
      setMediaItem(_item.last);
      stop();
    }
  }

  void clear() {
    mediaItem.add(null);
    _item.clear();
    if (playbackState.value.processingState == AudioProcessingState.idle) {
      playbackState.add(
        PlaybackState(
          processingState: AudioProcessingState.completed,
          playing: false,
        ),
      );
    }
    playbackState.add(
      PlaybackState(
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
  }

  void onPositionChange(Duration position) {
    playbackState.add(
      playbackState.value.copyWith(
        updatePosition: position,
      ),
    );
  }
}
