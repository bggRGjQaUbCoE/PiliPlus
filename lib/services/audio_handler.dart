import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pb.dart' show DetailItem;
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get/get_utils/get_utils.dart';

Future<VideoPlayerServiceHandler> initAudioService() async {
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
  bool enableBackgroundPlay = Pref.enableBackgroundPlay;

  Function? onPlay;
  Function? onPause;
  Function(Duration position)? onSeek;

  // 列表播放相关回调
  Function? onSkipToNext;
  Function? onSkipToPrevious;

  // 是否启用列表控制（上一个/下一个）
  bool _enableListControl = false;
  bool _isLive = false;
  bool _lastPlaying = false;

  /// 设置列表控制模式
  void setListControlMode({
    bool enabled = false,
    Function? onNext,
    Function? onPrevious,
  }) {
    _enableListControl = enabled;
    onSkipToNext = onNext;
    onSkipToPrevious = onPrevious;

    // 刷新播放状态以更新通知控件
    _refreshPlaybackControls();
  }

  /// 刷新播放状态控件
  void _refreshPlaybackControls() {
    if (!enableBackgroundPlay || _item.isEmpty) return;

    playbackState.add(
      playbackState.value.copyWith(
        controls: _buildMediaControls(_lastPlaying, _isLive),
      ),
    );
  }

  @override
  Future<void> skipToNext() async {
    if (_enableListControl && onSkipToNext != null) {
      onSkipToNext!.call();
    } else {
      // 默认快进10秒
      await fastForward();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_enableListControl && onSkipToPrevious != null) {
      onSkipToPrevious!.call();
    } else {
      // 默认快退10秒
      await rewind();
    }
  }

  @override
  Future<void> play() async {
    onPlay?.call() ?? PlPlayerController.playIfExists();
    // player.play();
  }

  @override
  Future<void> pause() async {
    await (onPause?.call() ?? PlPlayerController.pauseIfExists());
    // player.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    playbackState.add(
      playbackState.value.copyWith(
        updatePosition: position,
      ),
    );
    await (onSeek?.call(position) ??
        PlPlayerController.seekToIfExists(position, isSeek: false));
    // await player.seekTo(position);
  }

  Future<void> setMediaItem(MediaItem newMediaItem) async {
    if (!enableBackgroundPlay) return;
    // if (kDebugMode) {
    //   debugPrint("此时调用栈为：");
    //   debugPrint(newMediaItem);
    //   debugPrint(newMediaItem.title);
    //   debugPrint(StackTrace.current.toString());
    // }
    if (!mediaItem.isClosed) mediaItem.add(newMediaItem);
  }

  Future<void> setPlaybackState(
    PlayerStatus status,
    bool isBuffering,
    bool isLive,
  ) async {
    if (!enableBackgroundPlay ||
        _item.isEmpty ||
        !PlPlayerController.instanceExists()) {
      return;
    }

    final AudioProcessingState processingState;
    final playing = status == PlayerStatus.playing;
    if (status == PlayerStatus.completed) {
      processingState = AudioProcessingState.completed;
    } else if (isBuffering) {
      processingState = AudioProcessingState.buffering;
    } else {
      processingState = AudioProcessingState.ready;
    }

    // 保存状态用于刷新控件
    _isLive = isLive;
    _lastPlaying = playing;

    playbackState.add(
      playbackState.value.copyWith(
        processingState: isBuffering
            ? AudioProcessingState.buffering
            : processingState,
        controls: _buildMediaControls(playing, isLive),
        playing: playing,
        systemActions: const {
          MediaAction.seek,
        },
      ),
    );
  }

  /// 构建媒体控制按钮列表
  List<MediaControl> _buildMediaControls(bool playing, bool isLive) {
    if (_enableListControl) {
      // 列表播放模式：显示上一个/下一个
      return [
        if (!isLive && onSkipToPrevious != null)
          MediaControl.skipToPrevious.copyWith(
            androidIcon: 'drawable/ic_baseline_skip_previous_24',
          ),
        if (playing) MediaControl.pause else MediaControl.play,
        if (!isLive && onSkipToNext != null)
          MediaControl.skipToNext.copyWith(
            androidIcon: 'drawable/ic_baseline_skip_next_24',
          ),
      ];
    } else {
      // 普通模式：显示快退/快进
      return [
        if (!isLive)
          MediaControl.rewind.copyWith(
            androidIcon: 'drawable/ic_baseline_replay_10_24',
          ),
        if (playing) MediaControl.pause else MediaControl.play,
        if (!isLive)
          MediaControl.fastForward.copyWith(
            androidIcon: 'drawable/ic_baseline_forward_10_24',
          ),
      ];
    }
  }

  void onStatusChange(PlayerStatus status, bool isBuffering, isLive) {
    if (!enableBackgroundPlay) return;

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
    if (!PlPlayerController.instanceExists()) return;
    if (data == null) return;

    late final id = '$cid$herotag';
    MediaItem? mediaItem;
    if (data is VideoDetailData) {
      if ((data.pages?.length ?? 0) > 1) {
        final current = data.pages?.firstWhereOrNull(
          (element) => element.cid == cid,
        );
        mediaItem = MediaItem(
          id: id,
          title: current?.part ?? '',
          artist: data.owner?.name,
          duration: Duration(seconds: current?.duration ?? 0),
          artUri: Uri.parse(data.pic ?? ''),
        );
      } else {
        mediaItem = MediaItem(
          id: id,
          title: data.title ?? '',
          artist: data.owner?.name,
          duration: Duration(seconds: data.duration ?? 0),
          artUri: Uri.parse(data.pic ?? ''),
        );
      }
    } else if (data is EpisodeItem) {
      mediaItem = MediaItem(
        id: id,
        title: data.showTitle ?? data.longTitle ?? data.title ?? '',
        artist: artist,
        duration: data.from == 'pugv'
            ? Duration(seconds: data.duration ?? 0)
            : Duration(milliseconds: data.duration ?? 0),
        artUri: Uri.parse(data.cover ?? ''),
      );
    } else if (data is RoomInfoH5Data) {
      mediaItem = MediaItem(
        id: id,
        title: data.roomInfo?.title ?? '',
        artist: data.anchorInfo?.baseInfo?.uname,
        artUri: Uri.parse(data.roomInfo?.cover ?? ''),
        isLive: true,
      );
    } else if (data is Part) {
      mediaItem = MediaItem(
        id: id,
        title: data.part ?? '',
        artist: artist,
        duration: Duration(seconds: data.duration ?? 0),
        artUri: Uri.parse(cover ?? ''),
      );
    } else if (data is DetailItem) {
      mediaItem = MediaItem(
        id: id,
        title: data.arc.title,
        artist: data.owner.name,
        duration: Duration(seconds: data.arc.duration.toInt()),
        artUri: Uri.parse(data.arc.cover),
      );
    } else if (data is BiliDownloadEntryInfo) {
      mediaItem = MediaItem(
        id: id,
        title: data.showTitle,
        artist: data.ownerName,
        duration: Duration(milliseconds: data.totalTimeMilli),
        artUri: Uri.parse(data.cover),
      );
    }
    if (mediaItem == null) return;
    // if (kDebugMode) debugPrint("exist: ${PlPlayerController.instanceExists()}");
    if (!PlPlayerController.instanceExists()) return;
    _item.add(mediaItem);
    setMediaItem(mediaItem);
  }

  void onVideoDetailDispose(String herotag) {
    if (!enableBackgroundPlay) return;

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
    if (!enableBackgroundPlay) return;
    mediaItem.add(null);
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

  void onPositionChange(Duration position) {
    if (!enableBackgroundPlay ||
        _item.isEmpty ||
        !PlPlayerController.instanceExists()) {
      return;
    }

    playbackState.add(
      playbackState.value.copyWith(
        updatePosition: position,
      ),
    );
  }
}
