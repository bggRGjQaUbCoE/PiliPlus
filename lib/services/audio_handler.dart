import 'dart:async' show FutureOr;
import 'dart:io' show File, Platform;
import 'dart:math' as math;
import 'dart:ui' show PlatformDispatcher;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pb.dart' show DetailItem;
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_service_mpris/audio_service_mpris.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;
import 'package:window_manager/window_manager.dart';

Future<VideoPlayerServiceHandler> initAudioService() {
  if (Platform.isLinux) {
    final speeds = Pref.speedList;
    AudioServiceMpris.init(
      dBusName: Constants.appName,
      identity: Constants.appName,
      desktopEntry: 'com.example.piliplus',
      canControl: Pref.enableBackgroundPlay,
      canPlay: true,
      canPause: true,
      canSeek: true,
      canGoNext: true,
      canGoPrevious: true,
      canSetFullscreen: true,
      supportedUriSchemes: const ['http', 'https', 'file'],
      supportedMimeTypes: const [
        'video/mp4',
        'audio/mp4',
        'video/x-matroska',
        'audio/mpeg',
        'audio/aac',
        'video/webm',
        'audio/webm',
      ],
      minimumRate: math.min(1.0, speeds.isEmpty ? 1.0 : speeds.min),
      maximumRate: math.max(1.0, speeds.isEmpty ? 1.0 : speeds.max),
      onRaiseRequest: () {
        windowManager
          ..show()
          ..focus();
      },
      onQuitRequest: windowManager.close,
      onFullscreenRequest: (value) {
        PlPlayerController.triggerFullScreenIfExists(status: value);
      },
    ).volume = Pref.desktopVolume.clamp(
      0.0,
      1.0,
    );
    GStorage.video.watch(key: VideoBoxKey.speedsList).listen((_) {
      final speeds = Pref.speedList;
      if (speeds.isNotEmpty) {
        Mpris()
          ..minimumRate = math.min(1.0, speeds.min)
          ..maximumRate = math.max(1.0, speeds.max);
      }
    });
  }
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
  bool _enableBackgroundPlay = Pref.enableBackgroundPlay;
  bool get enableBackgroundPlay => _enableBackgroundPlay;
  set enableBackgroundPlay(bool value) {
    _enableBackgroundPlay = value;
    if (!value) {
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.idle,
          playing: false,
        ),
      );
      if (Platform.isLinux) {
        Mpris().canControl = false;
        Mpris().resetMetadata();
      }
    } else if (Platform.isLinux) {
      Mpris().canControl = true;
    }
  }

  bool _stopped = false;
  bool _isHandlingMprisSeek = false;

  Object? _skipOwner;
  Future<void>? Function()? onPlay;
  Future<void>? Function()? onPause;
  Future<void>? Function(Duration position)? onSeek;
  FutureOr<dynamic> Function()? onSkipToNext;
  FutureOr<dynamic> Function()? onSkipToPrevious;
  FutureOr<void> Function(double speed)? onSetSpeed;
  FutureOr<void> Function(double volume)? onSetVolume;
  FutureOr<void> Function(PlayRepeat mode)? onSetRepeatMode;
  PlayRepeat? Function()? onGetPlayRepeat;
  double? Function()? onGetSpeed;

  void setSkipCallBack({
    Object? owner,
    FutureOr<dynamic> Function()? next,
    FutureOr<dynamic> Function()? previous,
  }) {
    _skipOwner = owner;
    onSkipToNext = next;
    onSkipToPrevious = previous;
    updateSkipActions();
  }

  void clearSkipCallBack(Object owner) {
    if (_skipOwner == owner) {
      _skipOwner = null;
      onSkipToNext = null;
      onSkipToPrevious = null;
      updateSkipActions();
    }
  }

  bool get canSkipNext => onSkipToNext != null;
  bool get canSkipPrevious => onSkipToPrevious != null;
  bool get _hasPlayer => PlPlayerController.instanceExists() || onPlay != null;

  @override
  Future<void> play() {
    _stopped = false;
    if (onPlay != null) {
      return onPlay!() ?? Future.syncValue(null);
    }
    return PlPlayerController.playIfExists() ?? Future.syncValue(null);
  }

  @override
  Future<void> pause() {
    if (onPause != null) {
      return onPause!() ?? Future.syncValue(null);
    }
    return PlPlayerController.pauseIfExists();
  }

  @override
  Future<void> stop() async {
    if (!Platform.isLinux) {
      await super.stop();
      return;
    }
    if (_stopped) return;
    _stopped = true;
    if (onPause != null) {
      await onPause!();
    } else {
      await PlPlayerController.pauseIfExists();
    }
    if (onSeek != null) {
      await onSeek!(Duration.zero);
    } else {
      await PlPlayerController.seekToIfExists(Duration.zero, isSeek: false);
    }
    if (_item.isNotEmpty) {
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.completed,
          playing: false,
          updatePosition: Duration.zero,
        ),
      );
    }
  }

  @override
  Future<void> seek(Duration position) async {
    _stopped = false;
    playbackState.add(
      playbackState.value.copyWith(
        updatePosition: position,
      ),
    );
    _isHandlingMprisSeek = true;
    try {
      if (onSeek != null) {
        await onSeek!(position);
      } else {
        await PlPlayerController.seekToIfExists(position, isSeek: false);
      }
    } finally {
      _isHandlingMprisSeek = false;
    }
  }

  @override
  Future<void> skipToNext() async {
    _stopped = false;
    await onSkipToNext?.call();
  }

  @override
  Future<void> skipToPrevious() async {
    _stopped = false;
    await onSkipToPrevious?.call();
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    final PlayRepeat target = switch (repeatMode) {
      AudioServiceRepeatMode.one => PlayRepeat.singleCycle,
      AudioServiceRepeatMode.all ||
      AudioServiceRepeatMode.group => PlayRepeat.listCycle,
      _ => PlayRepeat.listOrder,
    };
    if (onSetRepeatMode != null) {
      await onSetRepeatMode!(target);
    } else {
      PlPlayerController.setPlayRepeatIfExists(target);
    }
  }

  // Mpris Volume
  @override
  Future<dynamic> customAction(
    String name, [
    Map<String, dynamic>? extras,
  ]) async {
    if (name == 'dbusVolume') {
      final value = extras?['value'];
      if (value is num) {
        final volume = value.toDouble().clamp(0.0, 1.0);
        if (onSetVolume != null) {
          await onSetVolume!(volume);
        } else {
          await PlPlayerController.setVolumeIfExists(
            volume,
            showIndicator: false,
          );
        }
      }
    }
  }

  // Mpris Rate
  @override
  Future<void> setSpeed(double speed) async {
    if (speed == 0.0) {
      await pause();
      return;
    }
    final steps = Pref.speedList;
    if (steps.isEmpty) return;
    final snapped = steps.reduce(
      (a, b) => (speed - a).abs() <= (speed - b).abs() ? a : b, // 自动吸附
    );
    if (onSetSpeed != null) {
      await onSetSpeed!(snapped);
    } else {
      await PlPlayerController.instance?.setPlaybackSpeed(snapped);
    }
  }

  void onVolumeChange(double volume) {
    if (Platform.isLinux) {
      Mpris().volume = volume.clamp(0.0, 1.0);
    }
  }

  void onFullscreenChange(bool isFullScreen) {
    if (Platform.isLinux) {
      Mpris().fullscreen = isFullScreen;
    }
  }

  void onSeeked(Duration position) {
    if (Platform.isLinux) {
      if (_stopped || _isHandlingMprisSeek) return;
      Mpris().emitSeeked(position);
    }
  }

  void onSpeedChange(double speed) {
    if (!enableBackgroundPlay || _item.isEmpty) return;
    playbackState.add(playbackState.value.copyWith(speed: speed));
  }

  void onRepeatModeChange(PlayRepeat type) {
    if (!enableBackgroundPlay || _item.isEmpty) return;
    playbackState.add(
      playbackState.value.copyWith(repeatMode: type.toRepeatMode()),
    );
  }

  void updateSkipActions() {
    if (!enableBackgroundPlay || _item.isEmpty) return;
    final actions = Set<MediaAction>.from(playbackState.value.systemActions);
    if (canSkipNext) {
      actions.add(MediaAction.skipToNext);
    } else {
      actions.remove(MediaAction.skipToNext);
    }
    if (canSkipPrevious) {
      actions.add(MediaAction.skipToPrevious);
    } else {
      actions.remove(MediaAction.skipToPrevious);
    }
    playbackState.add(
      playbackState.value.copyWith(
        systemActions: actions,
      ),
    );
  }

  double get _currentSpeed {
    return onGetSpeed?.call() ??
        PlPlayerController.instance?.playbackSpeed ??
        1.0;
  }

  void setMediaItem(MediaItem newMediaItem) {
    if (!enableBackgroundPlay) return;
    _stopped = false;
    // if (kDebugMode) {
    //   debugPrint("此时调用栈为：");
    //   debugPrint(newMediaItem);
    //   debugPrint(newMediaItem.title);
    //   debugPrint(StackTrace.current.toString());
    // }
    if (!mediaItem.isClosed) mediaItem.add(newMediaItem);
  }

  void onStatusChange(
    PlayerStatus status,
    bool isBuffering,
    bool isLive,
  ) {
    if (!enableBackgroundPlay || _item.isEmpty || !_hasPlayer) {
      return;
    }

    final playing = status.isPlaying;
    if (playing) {
      _stopped = false;
    }

    final AudioProcessingState processingState;
    if (_stopped || status.isCompleted) {
      processingState = AudioProcessingState.completed;
    } else if (isBuffering) {
      processingState = AudioProcessingState.buffering;
    } else {
      processingState = AudioProcessingState.ready;
    }
    final playRepeat =
        onGetPlayRepeat?.call() ?? PlPlayerController.getPlayRepeatIfExists();
    final repeatMode =
        playRepeat?.toRepeatMode() ?? AudioServiceRepeatMode.none;

    playbackState.add(
      playbackState.value.copyWith(
        processingState: processingState,
        speed: _currentSpeed,
        repeatMode: repeatMode,
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
        systemActions: {
          if (!isLive) MediaAction.seek,
          if (!isLive && canSkipNext) MediaAction.skipToNext,
          if (!isLive && canSkipPrevious) MediaAction.skipToPrevious,
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
    if (!_hasPlayer) return;
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
    _item.removeWhere((item) => item.id.endsWith(herotag));
    _item.add(mediaItem);
    setMediaItem(mediaItem);
    updateSkipActions();
  }

  void onVideoDetailDispose(String herotag) {
    if (_item.isNotEmpty) {
      _item.removeWhere((item) => item.id.endsWith(herotag));
    }
    if (_item.isNotEmpty) {
      if (!enableBackgroundPlay) return;
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.idle,
          playing: false,
        ),
      );
      setMediaItem(_item.last);
    } else {
      clear();
    }
  }

  void clearCustomCallbacks() {
    _skipOwner = null;
    onPlay = null;
    onPause = null;
    onSeek = null;
    onSkipToNext = null;
    onSkipToPrevious = null;
    onSetRepeatMode = null;
    onGetPlayRepeat = null;
    onSetSpeed = null;
    onSetVolume = null;
    onGetSpeed = null;
    updateSkipActions();
  }

  void clear() {
    _stopped = false;
    mediaItem.add(null);
    _item.clear();
    clearCustomCallbacks();
    if (Platform.isLinux) {
      Mpris().resetMetadata();
    }
    if (!enableBackgroundPlay) return;
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
    if (!enableBackgroundPlay || _item.isEmpty || !_hasPlayer) {
      return;
    }

    playbackState.add(
      playbackState.value.copyWith(
        updatePosition: position,
      ),
    );
  }
}

extension on PlayRepeat {
  AudioServiceRepeatMode toRepeatMode() => switch (this) {
    PlayRepeat.singleCycle => AudioServiceRepeatMode.one,
    PlayRepeat.listCycle ||
    PlayRepeat.autoPlayRelated => AudioServiceRepeatMode.all,
    _ => AudioServiceRepeatMode.none,
  };
}
