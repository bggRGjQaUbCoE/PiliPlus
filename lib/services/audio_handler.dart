import 'package:PiliPlus/models/bangumi/info.dart';
import 'package:PiliPlus/models/live/room_info_h5.dart';
import 'package:PiliPlus/models/video_detail_res.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get/get_utils/get_utils.dart';

Future<VideoPlayerServiceHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => VideoPlayerServiceHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.piliplus.audio',
      androidNotificationChannelName: 'Audio Service PiliPlus',
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
  bool enableBackgroundPlay = true;
  // PlPlayerController player = PlPlayerController.getInstance();

  VideoPlayerServiceHandler() {
    revalidateSetting();
  }

  void revalidateSetting() {
    enableBackgroundPlay = GStorage.setting
        .get(SettingBoxKey.enableBackgroundPlay, defaultValue: true);
  }

  @override
  Future<void> play() async {
    await PlPlayerController.playIfExists();
    // player.play();
  }

  @override
  Future<void> pause() async {
    await PlPlayerController.pauseIfExists();
    // player.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    playbackState.add(playbackState.value.copyWith(
      updatePosition: position,
    ));
    await PlPlayerController.seekToIfExists(position, type: 'slider');
    // await player.seekTo(position);
  }

  Future<void> setMediaItem(MediaItem newMediaItem) async {
    if (!enableBackgroundPlay) return;
    // debugPrint("此时调用栈为：");
    // debugPrint(newMediaItem);
    // debugPrint(newMediaItem.title);
    // debugPrint(StackTrace.current.toString());
    if (!mediaItem.isClosed) mediaItem.add(newMediaItem);
  }

  Future<void> setPlaybackState(
      PlayerStatus status, bool isBuffering, bool isLive) async {
    if (!enableBackgroundPlay ||
        _item.isEmpty ||
        PlPlayerController.instanceExists().not) {
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

    playbackState.add(playbackState.value.copyWith(
      processingState:
          isBuffering ? AudioProcessingState.buffering : processingState,
      controls: [
        if (isLive.not)
          MediaControl.rewind
              .copyWith(androidIcon: 'drawable/ic_baseline_replay_10_24'),
        if (playing) MediaControl.pause else MediaControl.play,
        if (isLive.not)
          MediaControl.fastForward
              .copyWith(androidIcon: 'drawable/ic_baseline_forward_10_24'),
      ],
      playing: playing,
      systemActions: const {
        MediaAction.seek,
      },
    ));
  }

  void onStatusChange(PlayerStatus status, bool isBuffering, isLive) {
    if (!enableBackgroundPlay) return;

    if (_item.isEmpty) return;
    setPlaybackState(status, isBuffering, isLive);
  }

  void onVideoDetailChange(dynamic data, int cid, String herotag) {
    if (!enableBackgroundPlay) return;
    // debugPrint('当前调用栈为：');
    // debugPrint(StackTrace.current);
    if (!PlPlayerController.instanceExists()) return;
    if (data == null) return;

    late final id = '$cid$herotag';
    MediaItem? mediaItem;
    if (data is VideoDetailData) {
      if ((data.pages?.length ?? 0) > 1) {
        final current =
            data.pages?.firstWhereOrNull((element) => element.cid == cid);
        mediaItem = MediaItem(
          id: id,
          title: current?.pagePart ?? "",
          artist: data.title ?? "",
          album: data.title ?? "",
          duration: Duration(seconds: current?.duration ?? 0),
          artUri: Uri.parse(data.pic ?? ""),
        );
      } else {
        mediaItem = MediaItem(
          id: id,
          title: data.title ?? "",
          artist: data.owner?.name ?? "",
          duration: Duration(seconds: data.duration ?? 0),
          artUri: Uri.parse(data.pic ?? ""),
        );
      }
    } else if (data is BangumiInfoModel) {
      final current =
          data.episodes?.firstWhereOrNull((element) => element.cid == cid);
      mediaItem = MediaItem(
        id: id,
        title: current?.longTitle ?? "",
        artist: data.title ?? "",
        duration: Duration(milliseconds: current?.duration ?? 0),
        artUri: Uri.parse(data.cover ?? ""),
      );
    } else if (data is RoomInfoH5Model) {
      mediaItem = MediaItem(
        id: id,
        title: data.roomInfo?.title ?? '',
        artist: data.anchorInfo?.baseInfo?.uname ?? '',
        artUri: Uri.parse(data.roomInfo?.cover ?? ''),
        isLive: true,
      );
    }
    if (mediaItem == null) return;
    // debugPrint("exist: ${PlPlayerController.instanceExists()}");
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
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.idle,
        playing: false,
      ));
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
      playbackState.add(PlaybackState(
        processingState: AudioProcessingState.completed,
        playing: false,
      ));
    }
    playbackState.add(PlaybackState(
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
  }

  void onPositionChange(Duration position) {
    if (!enableBackgroundPlay ||
        _item.isEmpty ||
        PlPlayerController.instanceExists().not) {
      return;
    }

    playbackState.add(playbackState.value.copyWith(
      updatePosition: position,
    ));
  }
}
