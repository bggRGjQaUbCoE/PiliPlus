import 'dart:async' show unawaited;
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
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

typedef _PlayerCallbacks = ({
  String mediaOwnerTag,
  Object owner,
  Future<void>? Function() onPlay,
  Future<void>? Function() onPause,
  Future<void>? Function(Duration position) onSeek,
});

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
  VideoPlayerServiceHandler({bool? enableBackgroundPlay})
    : enableBackgroundPlay = enableBackgroundPlay ?? Pref.enableBackgroundPlay;

  static final List<MediaItem> _item = [];
  static const _mediaOwnerTagKey = 'piliPlusMediaOwnerTag';
  bool enableBackgroundPlay;

  final List<_PlayerCallbacks> _playerCallbacks = [];

  void setPlayerCallbacks({
    required Object owner,
    required String mediaOwnerTag,
    required Future<void>? Function() onPlay,
    required Future<void>? Function() onPause,
    required Future<void>? Function(Duration position) onSeek,
  }) {
    _playerCallbacks
      ..removeWhere((callbacks) => identical(callbacks.owner, owner))
      ..add((
        mediaOwnerTag: mediaOwnerTag,
        owner: owner,
        onPlay: onPlay,
        onPause: onPause,
        onSeek: onSeek,
      ));
  }

  _PlayerCallbacks? get _currentPlayerCallbacks {
    final currentItem = _item.lastOrNull;
    if (currentItem == null) return null;
    final currentOwnerTag = _mediaOwnerTag(currentItem);
    return _playerCallbacks.lastWhereOrNull(
      (callbacks) => callbacks.mediaOwnerTag == currentOwnerTag,
    );
  }

  bool _isCurrentMediaOwner(String? mediaOwnerTag) {
    final currentItem = _item.lastOrNull;
    if (currentItem == null) return false;
    final currentOwnerTag = _mediaOwnerTag(currentItem);
    if (mediaOwnerTag != null) return mediaOwnerTag == currentOwnerTag;
    return !_playerCallbacks.any(
      (callbacks) => callbacks.mediaOwnerTag == currentOwnerTag,
    );
  }

  static String? _mediaOwnerTag(MediaItem item) =>
      item.extras?[_mediaOwnerTagKey] as String?;

  void clearPlayerCallbacks(Object owner) {
    _playerCallbacks.removeWhere(
      (callbacks) => identical(callbacks.owner, owner),
    );
  }

  @override
  Future<void> play() {
    return _currentPlayerCallbacks?.onPlay() ??
        PlPlayerController.playIfExists() ??
        Future.syncValue(null);
    // player.play();
  }

  @override
  Future<void> pause() {
    return _currentPlayerCallbacks?.onPause() ??
        PlPlayerController.pauseIfExists();
    // player.pause();
  }

  @override
  Future<void> seek(Duration position) {
    playbackState.add(
      playbackState.value.copyWith(
        updatePosition: position,
      ),
    );
    return (_currentPlayerCallbacks?.onSeek(position) ??
        PlPlayerController.seekToIfExists(position, isSeek: false));
    // await player.seekTo(position);
  }

  void setMediaItem(MediaItem newMediaItem) {
    if (!enableBackgroundPlay) return;
    // if (kDebugMode) {
    //   debugPrint("此时调用栈为：");
    //   debugPrint(newMediaItem);
    //   debugPrint(newMediaItem.title);
    //   debugPrint(StackTrace.current.toString());
    // }
    if (!mediaItem.isClosed) mediaItem.add(newMediaItem);
  }

  void setPlaybackState(
    PlayerStatus status,
    bool isBuffering,
    bool isLive,
  ) {
    if (!enableBackgroundPlay || _item.isEmpty) {
      return;
    }

    final AudioProcessingState processingState;
    if (status.isCompleted) {
      processingState = AudioProcessingState.completed;
    } else if (isBuffering) {
      processingState = AudioProcessingState.buffering;
    } else {
      processingState = AudioProcessingState.ready;
    }

    final playing = status.isPlaying;
    playbackState.add(
      playbackState.value.copyWith(
        processingState: isBuffering
            ? AudioProcessingState.buffering
            : processingState,
        controls: [
          if (!isLive)
            const MediaControl(
              androidIcon: 'drawable/ic_player_rewind_10s',
              label: 'Rewind',
              action: MediaAction.rewind,
            ),
          if (playing)
            const MediaControl(
              androidIcon: 'drawable/ic_player_pause',
              label: 'Pause',
              action: MediaAction.pause,
            )
          else
            const MediaControl(
              androidIcon: 'drawable/ic_player_play',
              label: 'Play',
              action: MediaAction.play,
            ),
          if (!isLive)
            const MediaControl(
              androidIcon: 'drawable/ic_player_fast_forward_10s',
              label: 'Fast Forward',
              action: MediaAction.fastForward,
            ),
        ],
        playing: playing,
        systemActions: const {
          MediaAction.seek,
        },
      ),
    );
    if (Platform.isAndroid &&
        (AndroidHelper.isPipMode ||
            PlPlayerController.instance?.isAutoEnterPip == true)) {
      AndroidHelper.updatePipActions(
        PlatformDispatcher.instance.engineId!,
        isLive,
        playing,
      );
    }
  }

  void onStatusChange(
    PlayerStatus status,
    bool isBuffering,
    bool isLive, {
    String? mediaOwnerTag,
  }) {
    if (!enableBackgroundPlay || !_isCurrentMediaOwner(mediaOwnerTag)) return;

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
    if (!enableBackgroundPlay) return;
    // if (kDebugMode) {
    //   debugPrint('当前调用栈为：');
    //   debugPrint(StackTrace.current);
    // }
    if (data == null) return;

    Uri getUri(String? cover) => Uri.parse(ImageUtils.safeThumbnailUrl(cover));

    late final id = '$cid::$herotag';
    final extras = <String, dynamic>{_mediaOwnerTagKey: herotag};
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
            extras: extras,
          );
        } else {
          mediaItem = MediaItem(
            id: id,
            title: data.title ?? '',
            artist: data.owner?.name,
            duration: Duration(seconds: data.duration ?? 0),
            artUri: getUri(data.pic),
            extras: extras,
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
          extras: extras,
        );
      case RoomInfoH5Data():
        mediaItem = MediaItem(
          id: id,
          title: data.roomInfo?.title ?? '',
          artist: data.anchorInfo?.baseInfo?.uname,
          artUri: getUri(data.roomInfo?.cover),
          isLive: true,
          extras: extras,
        );
      case Part():
        mediaItem = MediaItem(
          id: id,
          title: data.part ?? '',
          artist: artist,
          duration: Duration(seconds: data.duration ?? 0),
          artUri: getUri(cover),
          extras: extras,
        );
      case DetailItem(:final arc):
        mediaItem = MediaItem(
          id: id,
          title: arc.title,
          artist: data.owner.name,
          duration: Duration(seconds: arc.duration.toInt()),
          artUri: getUri(arc.cover),
          extras: extras,
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
          extras: extras,
        );
      default:
        return;
    }
    // if (kDebugMode) debugPrint("exist: ${PlPlayerController.instanceExists()}");
    _item
      ..removeWhere((item) => _mediaOwnerTag(item) == herotag)
      ..add(mediaItem);
    setMediaItem(mediaItem);
  }

  void onVideoDetailDispose(String herotag) {
    final currentItem = _item.lastOrNull;
    final wasCurrent =
        currentItem != null && _mediaOwnerTag(currentItem) == herotag;
    final itemCount = _item.length;
    if (_item.isNotEmpty) {
      _item.removeWhere((item) => _mediaOwnerTag(item) == herotag);
    }
    if (_item.length == itemCount) return;
    if (_item.isEmpty) {
      clear();
      return;
    }
    if (!wasCurrent) return;
    playbackState.add(
      playbackState.value.copyWith(
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
    setMediaItem(_item.last);
    unawaited(stop());
  }

  void clear() {
    if (!mediaItem.isClosed) mediaItem.add(null);
    _item.clear();
    /**
     * if (playbackState.processingState == AudioProcessingState.idle &&
            previousState?.processingState != AudioProcessingState.idle) {
          await AudioService._stop();
        }
     */
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

  void onPositionChange(Duration position, {String? mediaOwnerTag}) {
    if (!enableBackgroundPlay ||
        _item.isEmpty ||
        !_isCurrentMediaOwner(mediaOwnerTag)) {
      return;
    }

    playbackState.add(
      playbackState.value.copyWith(
        updatePosition: position,
      ),
    );
  }
}
