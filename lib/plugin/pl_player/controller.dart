import 'dart:async' show StreamSubscription, Timer;
import 'dart:convert' show ascii, utf8;
import 'dart:io' show Platform;
import 'dart:math' show max, min;
import 'dart:ui' as ui;

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/models/common/audio_normalization.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/user/danmaku_rule.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/video/video_shot/data.dart';
import 'package:PiliPlus/pages/danmaku/danmaku_model.dart';
import 'package:PiliPlus/pages/setting/models/play_settings.dart'
    show kMaxVolume;
import 'package:PiliPlus/pages/sponsor_block/block_mixin.dart';
import 'package:PiliPlus/plugin/pl_player/backends/mpv/mpv_player_view.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/audio_normalization_filter.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/double_tap_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/duration.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/heart_beat_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/exo_player_failure.dart';
import 'package:PiliPlus/plugin/pl_player/models/player_feature_result.dart';
import 'package:PiliPlus/plugin/pl_player/models/player_media_track.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/subtitle_source.dart';
import 'package:PiliPlus/plugin/pl_player/models/subtitle_style.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/plugin/pl_player/utils/captured_frame.dart';
import 'package:PiliPlus/plugin/pl_player/utils/player_listener_registry.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/android/android_helper.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/asset_utils.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/box_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:archive/archive.dart' show getCrc32;
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart' show HapticFeedback, DeviceOrientation;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:path/path.dart' as path;
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';

typedef PlayCallback = Future<void>? Function();

class PlPlayerController with BlockConfigMixin, AudioNormalizationMixin {
  Player? _videoPlayerController;
  MpvPlayerView? _mpvPlayerView;
  ExoPlayerController? _exoPlayerController;
  StreamSubscription<ExoPlayerEvent>? _exoSubscription;

  bool get useExoPlayer => Platform.isAndroid && Pref.useExoPlayer;
  bool get playerReady =>
      useExoPlayer ? _exoPlayerController != null : _mpvPlayerView != null;
  ExoPlayerController? get exoPlayerController => _exoPlayerController;

  List<PlayerMediaTrack> tracksFor(PlayerMediaTrackType type) {
    if (useExoPlayer) {
      return _exoPlayerController?.state.tracks
              .where((track) => track.type == type)
              .toList(growable: false) ??
          const [];
    }
    final state = _videoPlayerController?.state;
    if (state == null) return const [];
    return switch (type) {
      PlayerMediaTrackType.video =>
        state.tracks.video
            .where((track) => track.id != 'auto' && track.id != 'no')
            .toList()
            .asMap()
            .entries
            .map(
              (entry) => PlayerMediaTrack(
                type: type,
                id: entry.value.id,
                groupIndex: -1,
                trackIndex: entry.key,
                selected:
                    entry.value.selected ||
                    entry.value.id == state.track.video.id,
                supported: true,
                title: entry.value.title,
                language: entry.value.language,
                codec: entry.value.codec,
                bitrate: entry.value.bitrate,
                width: entry.value.w,
                height: entry.value.h,
                frameRate: entry.value.fps,
                rotationDegrees: entry.value.rotate,
                pixelWidthHeightRatio: entry.value.par,
              ),
            )
            .toList(growable: false),
      PlayerMediaTrackType.audio =>
        state.tracks.audio
            .where((track) => track.id != 'auto' && track.id != 'no')
            .toList()
            .asMap()
            .entries
            .map(
              (entry) => PlayerMediaTrack(
                type: type,
                id: entry.value.id,
                groupIndex: -1,
                trackIndex: entry.key,
                selected:
                    entry.value.selected ||
                    entry.value.id == state.track.audio.id,
                supported: true,
                title: entry.value.title,
                language: entry.value.language,
                codec: entry.value.codec,
                bitrate: entry.value.bitrate,
                channelCount: entry.value.channelscount,
                sampleRate: entry.value.samplerate,
              ),
            )
            .toList(growable: false),
      PlayerMediaTrackType.subtitle =>
        state.tracks.subtitle
            .where((track) => track.id != 'auto' && track.id != 'no')
            .toList()
            .asMap()
            .entries
            .map(
              (entry) => PlayerMediaTrack(
                type: type,
                id: entry.value.id,
                groupIndex: -1,
                trackIndex: entry.key,
                selected:
                    entry.value.selected ||
                    entry.value.id == state.track.subtitle.id,
                supported: true,
                external: entry.value.uri,
                title: entry.value.title,
                language: entry.value.language,
                codec: entry.value.codec,
              ),
            )
            .toList(growable: false),
    };
  }

  PlayerMediaTrack? selectedTrack(PlayerMediaTrackType type) {
    for (final track in tracksFor(type)) {
      if (track.selected) return track;
    }
    return null;
  }

  List<PlayerMediaTrack> get embeddedSubtitleTracks => tracksFor(
    PlayerMediaTrackType.subtitle,
  ).where((track) => !track.external).toList(growable: false);

  PlayerMediaTrack? get selectedEmbeddedSubtitleTrack {
    for (final track in embeddedSubtitleTracks) {
      if (track.selected) return track;
    }
    return null;
  }

  Future<void> setTrackSelection(
    PlayerMediaTrackType type,
    PlayerTrackSelectionMode mode, {
    PlayerMediaTrack? track,
  }) async {
    if (mode == PlayerTrackSelectionMode.track && track == null) {
      throw ArgumentError.notNull('track');
    }
    if (useExoPlayer) {
      final player = _exoPlayerController;
      if (player == null) return;
      await player.setTrackSelection(
        type: type,
        mode: mode,
        track: track,
      );
    } else {
      final player = _videoPlayerController;
      if (player == null) return;
      switch (type) {
        case PlayerMediaTrackType.video:
          await player.setVideoTrack(
            switch (mode) {
              PlayerTrackSelectionMode.auto => VideoTrack.auto(),
              PlayerTrackSelectionMode.disabled => VideoTrack.no(),
              PlayerTrackSelectionMode.track => VideoTrack(
                track!.id,
                track.title,
                track.language,
              ),
            },
          );
        case PlayerMediaTrackType.audio:
          await player.setAudioTrack(
            switch (mode) {
              PlayerTrackSelectionMode.auto => AudioTrack.auto(),
              PlayerTrackSelectionMode.disabled => AudioTrack.no(),
              PlayerTrackSelectionMode.track => AudioTrack(
                track!.id,
                track.title,
                track.language,
              ),
            },
          );
        case PlayerMediaTrackType.subtitle:
          await player.setSubtitleTrack(
            switch (mode) {
              PlayerTrackSelectionMode.auto => SubtitleTrack.auto(),
              PlayerTrackSelectionMode.disabled => SubtitleTrack.no(),
              PlayerTrackSelectionMode.track => SubtitleTrack(
                track!.id,
                track.title,
                track.language,
              ),
            },
          );
      }
    }
    if (type == PlayerMediaTrackType.video) {
      onlyPlayAudio.value = mode == PlayerTrackSelectionMode.disabled;
    }
  }

  Future<void> setApplicationSubtitle({
    PlayerSubtitleSource? source,
    String? language,
    String? label,
  }) async {
    if (useExoPlayer) {
      await _exoPlayerController?.setSubtitle(
        data: source?.isData == true ? source!.id : null,
        uri: source?.isData == false ? source!.id : null,
        language: language,
        label: label,
        mimeType: source?.format.mimeType,
      );
      return;
    }

    final player = _videoPlayerController;
    if (player == null) return;
    if (source == null) {
      await player.setSubtitleTrack(SubtitleTrack.no());
      return;
    }
    await player.setSubtitleTrack(
      SubtitleTrack(
        source.isData ? 'memory://${source.id}' : source.id,
        label,
        language,
        uri: true,
      ),
    );
  }

  List<PlayerInfoEntry> get playerInfoEntries {
    String value(Object? value) => value?.toString() ?? 'N/A';
    if (useExoPlayer) {
      final state = _exoPlayerController?.state;
      if (state == null) return const [];
      final video = selectedTrack(PlayerMediaTrackType.video);
      final audio = selectedTrack(PlayerMediaTrackType.audio);
      final subtitle = selectedTrack(PlayerMediaTrackType.subtitle);
      return [
        const PlayerInfoEntry('Backend', 'Media3 ExoPlayer'),
        PlayerInfoEntry('Resolution', '${state.width}x${state.height}'),
        PlayerInfoEntry('VideoParams', video?.details ?? 'N/A'),
        PlayerInfoEntry('AudioParams', audio?.details ?? 'N/A'),
        PlayerInfoEntry('Media', state.mediaDescription ?? 'N/A'),
        PlayerInfoEntry('AudioTrack', audio?.details ?? 'disabled'),
        PlayerInfoEntry('VideoTrack', video?.details ?? 'disabled'),
        PlayerInfoEntry('SubtitleTrack', subtitle?.details ?? 'disabled'),
        PlayerInfoEntry(
          'PlaybackConfig',
          state.playbackConfiguration ?? 'N/A',
        ),
        PlayerInfoEntry(
          'VideoOutput',
          'firstFrameRendered: ${state.firstVideoFrameRendered}',
        ),
        PlayerInfoEntry(
          'SuperResolution',
          state.superResolution ?? 'disabled',
        ),
        PlayerInfoEntry('rate', value(state.speed)),
        PlayerInfoEntry('Volume', value(state.volume)),
        PlayerInfoEntry(
          'Decoder',
          'video: ${state.videoDecoder ?? 'N/A'}\n'
              'audio: ${state.audioDecoder ?? 'N/A'}',
        ),
      ];
    }
    final player = _videoPlayerController;
    if (player == null) return const [];
    final state = player.state;
    return [
      const PlayerInfoEntry('Backend', 'MPV'),
      PlayerInfoEntry('Resolution', '${state.width}x${state.height}'),
      PlayerInfoEntry('VideoParams', value(state.videoParams)),
      PlayerInfoEntry('AudioParams', value(state.audioParams)),
      PlayerInfoEntry('Media', value(state.playlist)),
      PlayerInfoEntry('AudioTrack', value(state.track.audio)),
      PlayerInfoEntry('VideoTrack', value(state.track.video)),
      PlayerInfoEntry('SubtitleTrack', value(state.track.subtitle)),
      PlayerInfoEntry('rate', value(state.rate)),
      PlayerInfoEntry('Volume', player.getProperty('volume').subLength(3)),
      PlayerInfoEntry('hwdec', player.getProperty('hwdec-current')),
    ];
  }

  static PlPlayerController? _instance;

  final playerStatus = PlPlayerStatus(.playing);

  final Rx<DataStatus> dataStatus = Rx(.none);

  Duration? seekToPos;
  bool hasToasted = false;
  final RxBool isSeeking = false.obs;

  final RxInt position = RxInt(0);

  int get positionInMilliseconds => useExoPlayer
      ? _exoPlayerController?.state.position.inMilliseconds ?? 0
      : _videoPlayerController?.state.position.inMilliseconds ?? 0;

  Duration get currentPosition => useExoPlayer
      ? _exoPlayerController?.state.position ?? Duration.zero
      : _videoPlayerController?.state.position ?? Duration.zero;

  Duration get currentDuration => useExoPlayer
      ? _exoPlayerController?.state.duration ?? Duration.zero
      : _videoPlayerController?.state.duration ?? Duration.zero;

  Size get naturalVideoSize {
    final stateWidth = useExoPlayer
        ? _exoPlayerController?.state.width ?? 0
        : _videoPlayerController?.state.width ?? 0;
    final stateHeight = useExoPlayer
        ? _exoPlayerController?.state.height ?? 0
        : _videoPlayerController?.state.height ?? 0;
    return Size(
      (stateWidth > 0 ? stateWidth : width ?? 16).toDouble(),
      (stateHeight > 0 ? stateHeight : height ?? 9).toDouble(),
    );
  }

  bool get isPlaying => useExoPlayer
      ? _exoPlayerController?.state.playing ?? false
      : _videoPlayerController?.state.playing ?? false;

  bool get playWhenReady =>
      useExoPlayer ? _exoPlayerController?.playWhenReady ?? false : isPlaying;

  final RxInt buffered = RxInt(0);

  final RxInt duration = RxInt(0);

  int durationInMilliseconds = 0;

  void updateDuration(Duration value) {
    duration.value = value.inSeconds;
    durationInMilliseconds = value.inMilliseconds;
  }

  int _playerCount = 0;

  late double lastPlaybackSpeed = 1.0;
  final RxDouble _playbackSpeed = Pref.playSpeedDefault.obs;
  late final RxDouble _longPressSpeed = Pref.longPressSpeedDefault.obs;

  final RxDouble volume = RxDouble(
    PlatformUtils.isDesktop ? Pref.desktopVolume : 1.0,
  );
  final setSystemBrightness = Pref.setSystemBrightness;

  final RxDouble brightness = (-1.0).obs;

  final RxBool showControls = false.obs;

  final RxBool showBrightnessStatus = false.obs;

  final RxBool longPressStatus = false.obs;

  final RxBool controlsLock = false.obs;

  final RxBool isFullScreen = false.obs;
  bool isLive = false;

  bool _isVertical = false;

  final Rx<VideoFitType> videoFit = Rx(.contain);

  late final RxBool continuePlayInBackground =
      Pref.continuePlayInBackground.obs;

  bool _autoPlay = false;

  // 记录历史记录
  int? _aid;
  String? _bvid;
  int? cid;
  int? _epid;
  int? _seasonId;
  int? _pgcType;
  VideoType _videoType = VideoType.ugc;
  int _heartDuration = 0;
  int? width;
  int? height;

  late final tryLook = !Accounts.get(AccountType.video).isLogin && Pref.p1080;

  late DataSource dataSource;

  Timer? _timer;
  StreamSubscription? _subForSeek;
  Timer? _exoRetryTimer;
  int _exoRetryAttempt = 0;
  String? _lastFinalExoFailure;
  bool _exoSoftwareFallbackAttempted = false;

  Box setting = GStorage.setting;

  // final Durations durations;

  String get bvid => _bvid!;

  /// 视频播放速度
  double get playbackSpeed => _playbackSpeed.value;

  // 长按倍速
  double get longPressSpeed => _longPressSpeed.value;

  MpvPlayerView? get mpvPlayerView => _mpvPlayerView;

  bool isMuted = false;
  double _audioFocusGain = 1;

  /// 听视频
  late final RxBool onlyPlayAudio = false.obs;

  /// 镜像
  late final RxBool flipX = false.obs;

  late final RxBool flipY = false.obs;

  final RxBool isBuffering = true.obs;

  /// 全屏方向
  // ignore: unnecessary_getters_setters
  bool get isVertical => _isVertical;

  set isVertical(bool value) {
    _isVertical = value;
  }

  /// 弹幕开关
  late final RxBool enableShowDanmaku = Pref.enableShowDanmaku.obs;
  late final RxBool enableShowLiveDanmaku = Pref.enableShowLiveDanmaku.obs;
  RxBool get enableShowDanmakuAdaptive =>
      isLive ? enableShowLiveDanmaku : enableShowDanmaku;

  late final bool autoPiP = Pref.autoPiP;
  bool get isPipMode =>
      (Platform.isAndroid && AndroidHelper.isPipMode) ||
      (PlatformUtils.isDesktop && isDesktopPip);
  late bool isDesktopPip = false;
  late Rect _lastWindowBounds;

  late final showWindowTitleBar = Pref.showWindowTitleBar;
  late final RxBool isAlwaysOnTop = false.obs;
  Future<void> setAlwaysOnTop(bool value) {
    isAlwaysOnTop.value = value;
    return windowManager.setAlwaysOnTop(value);
  }

  Future<void> exitDesktopPip() {
    isDesktopPip = false;
    return Future.wait([
      if (showWindowTitleBar)
        windowManager.setTitleBarStyle(TitleBarStyle.normal),
      windowManager.setMinimumSize(const Size(400, 700)),
      windowManager.setBounds(_lastWindowBounds),
      setAlwaysOnTop(false),
      windowManager.setAspectRatio(0),
    ]);
  }

  Future<void> enterDesktopPip() async {
    if (isFullScreen.value) return;

    isDesktopPip = true;

    _lastWindowBounds = await windowManager.getBounds();

    if (showWindowTitleBar) {
      windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    }

    final Size size;
    final state = _videoPlayerController!.state;
    int width = state.width;
    int height = state.height;
    if (width == 0) {
      width = this.width ?? 16;
    }
    if (height == 0) {
      height = this.height ?? 9;
    }
    if (height > width) {
      size = Size(280.0, 280.0 * height / width);
    } else {
      size = Size(280.0 * width / height, 280.0);
    }

    await windowManager.setMinimumSize(size);
    setAlwaysOnTop(true);
    windowManager
      ..setSize(size)
      ..setAspectRatio(width / height);
  }

  void toggleDesktopPip() {
    if (isDesktopPip) {
      exitDesktopPip();
    } else {
      enterDesktopPip();
    }
  }

  late bool _isAutoEnterPip = false;
  bool get isAutoEnterPip => _isAutoEnterPip;
  bool _isInAppMiniPlayer = false;

  static bool get _isCurrVideoPage {
    final routing = Get.routing;
    if (routing.route is! GetPageRoute) {
      return false;
    }
    return _isVideoPage(routing.current);
  }

  static bool _isVideoPage(String routeName) {
    return routeName == '/videoV' || routeName == '/liveRoom';
  }

  void enterPip({bool autoEnter = false}) {
    if (playerReady) {
      final stateWidth = useExoPlayer
          ? _exoPlayerController?.state.width ?? 0
          : _videoPlayerController?.state.width ?? 0;
      final stateHeight = useExoPlayer
          ? _exoPlayerController?.state.height ?? 0
          : _videoPlayerController?.state.height ?? 0;
      PageUtils.enterPip(
        autoEnter: autoEnter,
        width: stateWidth == 0 ? width : stateWidth,
        height: stateHeight == 0 ? height : stateHeight,
        isLive: isLive,
        isPlaying: playerStatus.isPlaying,
      );
    }
  }

  void _disableAutoEnterPip() {
    if (_isAutoEnterPip) {
      PiliAndroidHelper.disableAutoEnterPip();
    }
  }

  void _syncAutoEnterPip(bool playing) {
    if (!playing) {
      _disableAutoEnterPip();
      return;
    }
    if (_isAutoEnterPip) {
      if (_isCurrVideoPage || _isInAppMiniPlayer) {
        enterPip(autoEnter: true);
      } else {
        _disableAutoEnterPip();
      }
    }
  }

  // 弹幕相关配置
  late final enableTapDm = PlatformUtils.isMobile && Pref.enableTapDm;
  late RuleFilter filters = Pref.danmakuFilterRule;
  // 关联弹幕控制器
  DanmakuController<DanmakuExtra>? danmakuController;
  bool showDanmaku = true;
  Set<int> dmState = <int>{};
  late final mergeDanmaku = Pref.mergeDanmaku;
  late final String midHash = getCrc32(
    ascii.encode(Accounts.main.mid.toString()),
    0,
  ).toRadixString(16);
  late final RxDouble danmakuOpacity = Pref.danmakuOpacity.obs;

  late List<double> speedList = Pref.speedList;
  late bool enableAutoLongPressSpeed = Pref.enableAutoLongPressSpeed;
  late final showControlDuration = Pref.enableLongShowControl
      ? const Duration(seconds: 30)
      : const Duration(seconds: 3);
  // 字幕
  late double subtitleFontScale = Pref.subtitleFontScale;
  late double subtitleFontScaleFS = Pref.subtitleFontScaleFS;
  late int subtitlePaddingH = Pref.subtitlePaddingH;
  late int subtitlePaddingB = Pref.subtitlePaddingB;
  late double subtitleBgOpacity = Pref.subtitleBgOpacity;
  final bool showVipDanmaku = Pref.showVipDanmaku; // loop unswitching
  late double subtitleStrokeWidth = Pref.subtitleStrokeWidth;
  late int subtitleFontWeight = Pref.subtitleFontWeight;

  // settings
  late final showFSActionItem = Pref.showFSActionItem;
  late final enableShrinkVideoSize = Pref.enableShrinkVideoSize;
  late final darkVideoPage = Pref.darkVideoPage;
  late final enableSlideVolumeBrightness = Pref.enableSlideVolumeBrightness;
  late final enableSlideFS = Pref.enableSlideFS;
  late final enableDragSubtitle = Pref.enableDragSubtitle;
  late final fastForBackwardDuration = Duration(
    seconds: Pref.fastForBackwardDuration,
  );

  late final horizontalSeasonPanel = Pref.horizontalSeasonPanel;
  late final preInitPlayer = Pref.preInitPlayer;
  late final showRelatedVideo = Pref.showRelatedVideo;
  late final showVideoReply = Pref.showVideoReply;
  late final showBangumiReply = Pref.showBangumiReply;
  late final reverseFromFirst = Pref.reverseFromFirst;
  late final horizontalPreview = Pref.horizontalPreview;
  late final showDmChart = Pref.showDmChart;
  late final showViewPoints = Pref.showViewPoints;
  late final showFsScreenshotBtn = Pref.showFsScreenshotBtn;
  late final showFsLockBtn = Pref.showFsLockBtn;
  late final keyboardControl = Pref.keyboardControl;
  late final uiScale = Pref.uiScale;

  late final bool autoEnterFullScreen = Pref.autoEnterFullScreen;
  late final bool autoExitFullscreen = Pref.autoExitFullscreen;
  late final bool autoPlayEnable = Pref.autoPlayEnable;
  late final bool enableVerticalExpand = Pref.enableVerticalExpand;
  late final bool pipNoDanmaku = Pref.pipNoDanmaku;

  late final bool tempPlayerConf = Pref.tempPlayerConf;

  late int? cacheVideoQa = PlatformUtils.isMobile ? null : Pref.defaultVideoQa;
  late int cacheAudioQa = Pref.defaultAudioQa;
  bool enableHeart = true;
  late final String? hwdec = Pref.enableHA ? Pref.hardwareDecoding : null;

  late final progressType = Pref.btmProgressBehavior;
  late final enableQuickDouble = Pref.enableQuickDouble;
  late final fullScreenGestureReverse = Pref.fullScreenGestureReverse;

  late final isRelative = Pref.useRelativeSlide;
  late final offset = isRelative
      ? Pref.sliderDuration / 100
      : Pref.sliderDuration * 1000;

  num get sliderScale => isRelative ? durationInMilliseconds * offset : offset;

  // 播放顺序相关
  late PlayRepeat playRepeat = Pref.playRepeat;

  TextStyle get subTitleStyle => TextStyle(
    height: 1.5,
    fontSize:
        16 * (isFullScreen.value ? subtitleFontScaleFS : subtitleFontScale),
    letterSpacing: 0.1,
    wordSpacing: 0.1,
    color: Colors.white,
    fontWeight: FontWeight.values[subtitleFontWeight],
    backgroundColor: subtitleBgOpacity == 0
        ? null
        : Colors.black.withValues(alpha: subtitleBgOpacity),
  );

  late final Rx<PlayerSubtitleStyle> subtitleConfig = getSubConfig.obs;

  PlayerSubtitleStyle get getSubConfig {
    final subTitleStyle = this.subTitleStyle;
    return PlayerSubtitleStyle(
      style: subTitleStyle,
      strokeStyle: subtitleBgOpacity == 0
          ? subTitleStyle.copyWith(
              color: null,
              background: null,
              backgroundColor: null,
              foreground: Paint()
                ..color = Colors.black
                ..style = PaintingStyle.stroke
                ..strokeWidth = subtitleStrokeWidth,
            )
          : null,
      padding: EdgeInsets.only(
        left: subtitlePaddingH.toDouble(),
        right: subtitlePaddingH.toDouble(),
        bottom: subtitlePaddingB.toDouble(),
      ),
      textScaleFactor: 1,
    );
  }

  void updateSubtitleStyle() {
    subtitleConfig.value = getSubConfig;
  }

  void onUpdatePadding(EdgeInsets padding) {
    subtitlePaddingB = padding.bottom.round().clamp(0, 200);
    putSubtitleSettings();
  }

  static PlPlayerController? get instance => _instance;

  static bool instanceExists() {
    return _instance != null;
  }

  static void setPlayCallBack(PlayCallback? playCallBack) {
    _playCallBack = playCallBack;
  }

  static PlayCallback? _playCallBack;

  static Future<void>? playIfExists() {
    return _playCallBack?.call();
  }

  // try to get PlayerStatus
  static PlayerStatus? getPlayerStatusIfExists() {
    return _instance?.playerStatus.value;
  }

  static Future<void> pauseIfExists({
    bool notify = true,
    bool isInterrupt = false,
  }) async {
    if (_instance?.playerStatus.isPlaying ?? false) {
      await _instance?.pause(notify: notify, isInterrupt: isInterrupt);
    }
  }

  static Future<void> seekToIfExists(
    Duration position, {
    bool isSeek = true,
  }) async {
    await _instance?.seekTo(position, isSeek: isSeek);
  }

  static double? getVolumeIfExists() {
    return _instance?.volume.value;
  }

  static Future<void>? setVolumeIfExists(
    double volumeNew, {
    bool showIndicator = true,
  }) {
    return _instance?.setVolume(volumeNew, showIndicator: showIndicator);
  }

  static Future<void>? syncDesktopVolumeIfExists(double volume) {
    return _instance?.syncDesktopVolume(volume);
  }

  static Future<void>? setAudioFocusGainIfExists(double gain) {
    return _instance?._setAudioFocusGain(gain);
  }

  Box video = GStorage.video;

  bool visible = true;

  DeviceOrientation? _orientation;
  late final checkIsAutoRotate = Platform.isAndroid && mode != .gravity;
  StreamSubscription<OrientationParams>? _orientationListener;

  void _stopOrientationListener() {
    _orientationListener?.cancel();
    _orientationListener = null;
  }

  void _onOrientationChanged(OrientationParams param) {
    _orientation = param.orientation;
    if (Platform.isIOS && !visible) return;
    final orientation = param.orientation;
    final isFullScreen = this.isFullScreen.value;
    if (checkIsAutoRotate &&
        param.isAutoRotate != true &&
        (!isFullScreen ||
            _isVertical ||
            orientation == .portraitUp ||
            orientation == .portraitDown)) {
      return;
    }
    switch (orientation) {
      case .portraitUp:
        if (!_isVertical && controlsLock.value) return;
        if (!horizontalScreen && !_isVertical && isFullScreen) {
          if (!isManualFS) {
            triggerFullScreen(status: false, orientation: orientation);
          }
        } else {
          portraitUpMode();
        }
      case .portraitDown:
        if (!horizontalScreen) return;
        if (!_isVertical && controlsLock.value) return;
        portraitDownMode();
      case .landscapeLeft:
        if (!horizontalScreen && !isFullScreen) {
          triggerFullScreen(orientation: orientation, isManualFS: false);
        } else {
          landscapeLeftMode();
        }
      case .landscapeRight:
        if (!horizontalScreen && !isFullScreen) {
          triggerFullScreen(orientation: orientation, isManualFS: false);
        } else {
          landscapeRightMode();
        }
    }
  }

  // 添加一个私有构造函数
  PlPlayerController._() {
    if (PlatformUtils.isMobile) {
      _orientationListener = NativeDeviceOrientationPlatform.instance
          .onOrientationChanged(
            checkIsAutoRotate: checkIsAutoRotate,
            angleDegrees: Platform.isAndroid ? Pref.angleDegrees : null,
          )
          .listen(_onOrientationChanged);
    }

    if (!Accounts.heartbeat.isLogin || Pref.historyPause) {
      enableHeart = false;
    }

    if (Platform.isAndroid && autoPiP) {
      if (DeviceUtils.sdkInt < 31) {
        AndroidHelper$ToDart.onUserLeaveHint = Runnable.implement(
          $Runnable(run: _onUserLeaveHint),
        );
      } else {
        _isAutoEnterPip = true;
      }
    }
  }

  void _onUserLeaveHint() {
    if (playerStatus.isPlaying && (_isCurrVideoPage || _isInAppMiniPlayer)) {
      enterPip();
    }
  }

  // 获取实例 传参
  static PlPlayerController getInstance({bool isLive = false}) {
    // 如果实例尚未创建，则创建一个新实例
    return (_instance ??= PlPlayerController._())
      ..isLive = isLive
      .._playerCount += 1;
  }

  /// Keeps the current player alive while its video page is being removed.
  ///
  /// The in-app mini player owns the retained reference until it is closed or
  /// another video page takes over playback.
  bool retainForInAppMiniPlayer() {
    if (_instance != this || _playerCount == 0 || !playerReady) {
      return false;
    }
    _playerCount += 1;
    _isInAppMiniPlayer = true;
    _syncAutoEnterPip(playerStatus.isPlaying);
    setPlayCallBack(null);
    controls = false;
    if (Platform.isAndroid && !setSystemBrightness) {
      ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
    }
    return true;
  }

  /// Releases the reference retained by the in-app mini player.
  ///
  /// Restoring to a video route must also restore Android's auto-enter PiP
  /// parameters because playback continues without emitting a new play event.
  void releaseFromInAppMiniPlayer({required bool restoredToVideoPage}) {
    _isInAppMiniPlayer = false;
    if (restoredToVideoPage) {
      _syncAutoEnterPip(playerStatus.isPlaying);
    } else {
      _disableAutoEnterPip();
    }
    dispose();
  }

  bool _processing = false;
  bool get processing => _processing;

  // offline
  bool get isFileSource => dataSource is FileSource;

  late final _exoAudioNormalizationConfig = Pref.audioNormalization;
  Volume? _normalizationVolume;
  String? _lastUnsupportedExoAudioNormalization;

  Map<String, Object>? _resolveExoAudioNormalization(Volume? volume) {
    if (!enableAudioNormalization) return null;
    final resolution = resolveExoAudioNormalization(
      config: _exoAudioNormalizationConfig,
      fallbackConfig: Pref.fallbackNormalization,
      volume: volume,
    );
    switch (resolution) {
      case ExoAudioNormalizationConfiguration():
        _lastUnsupportedExoAudioNormalization = null;
        return resolution.toMap();
      case ExoAudioDynamicNormalizationConfiguration():
        _lastUnsupportedExoAudioNormalization = null;
        return resolution.toMap();
      case UnsupportedExoAudioNormalization(
        :final filter,
        :final unsupportedStage,
      ):
        if (_lastUnsupportedExoAudioNormalization != filter) {
          _lastUnsupportedExoAudioNormalization = filter;
          SmartDialog.showToast(
            '音量均衡滤镜「${unsupportedStage ?? filter}」尚未适配 ExoPlayer，已保持原始音频',
          );
        }
        return null;
      case null:
        _lastUnsupportedExoAudioNormalization = null;
        return null;
    }
  }

  // 初始化资源
  Future<void> setDataSource(
    DataSource dataSource, {
    bool isLive = false,
    bool autoplay = true,
    // 初始化播放位置
    Duration? seekTo,
    // 初始化播放速度
    double speed = 1.0,
    int? width,
    int? height,
    Duration? duration,
    // 方向
    bool? isVertical,
    // 记录历史记录
    int? aid,
    String? bvid,
    int? cid,
    int? epid,
    int? seasonId,
    int? pgcType,
    VideoType? videoType,
    VoidCallback? onInit,
    Volume? volume,
    bool autoFullScreenFlag = false,
  }) async {
    try {
      _cancelExoRetry(resetAttempts: true);
      _processing = true;
      final previousCid = this.cid;
      final hasExistingExoPlayer = _exoPlayerController != null;
      final preserveExoSubtitle =
          hasExistingExoPlayer && previousCid != null && previousCid == cid;
      this.isLive = isLive;
      _videoType = videoType ?? VideoType.ugc;
      this.width = width;
      this.height = height;
      this.dataSource = dataSource;
      _autoPlay = autoplay;
      // 初始化视频倍速
      // _playbackSpeed.value = speed;
      // 初始化数据加载状态
      dataStatus.value = DataStatus.loading;
      // 初始化全屏方向
      _isVertical = isVertical ?? false;
      _aid = aid;
      _bvid = bvid;
      this.cid = cid;
      _epid = epid;
      _seasonId = seasonId;
      _pgcType = pgcType;
      _normalizationVolume = volume;
      _lastVideoSize = null;

      if (showSeekPreview) {
        _clearPreview();
      }
      cancelLongPressTimer();
      if (isPlaying) {
        await pause(notify: false, isInterrupt: true);
      }

      if (_playerCount == 0) {
        return;
      }
      // 配置Player 音轨、字幕等等
      await _createVideoController(
        dataSource,
        seekTo,
        volume,
        exoPlayWhenReady: hasExistingExoPlayer && autoplay,
        preserveExoSubtitle: preserveExoSubtitle,
      );
      await _applyPlayerOutputVolume();

      if (_playerCount == 0) {
        _removeListeners();
        _videoPlayerController?.dispose();
        _exoPlayerController?.dispose();
        _videoPlayerController = null;
        _mpvPlayerView = null;
        _exoPlayerController = null;
        return;
      }

      updateDuration(duration ?? currentDuration);
      position.value = buffered.value = seekTo?.inSeconds ?? 0;

      dataStatus.value = .loaded;

      if (autoFullScreenFlag && autoEnterFullScreen) {
        triggerFullScreen(status: true);
      }

      await _initializePlayer();
      onInit?.call();
    } catch (err, stackTrace) {
      dataStatus.value = DataStatus.error;
      if (kDebugMode) {
        debugPrint(stackTrace.toString());
        debugPrint('plPlayer err:  $err');
      }
    } finally {
      _processing = false;
    }
  }

  String? shadersDirPath;
  Future<String> get copyShadersToExternalDirectory async {
    if (shadersDirPath != null) {
      return shadersDirPath!;
    }

    return shadersDirPath = await AssetUtils.getOrCopy(
      'assets/shaders',
      Assets.mpvAnime4KShaders.followedBy(Assets.mpvAnime4KShadersLite),
      path.join(appSupportDirPath, 'anime_shaders'),
    );
  }

  late final isAnim = _pgcType == 1 || _pgcType == 4;
  late final Rx<SuperResolutionType> superResolutionType =
      (isAnim ? Pref.superResolutionType : SuperResolutionType.disable).obs;

  Future<void> setSuperResolution(SuperResolutionType type) async {
    if (useExoPlayer) {
      final player = _exoPlayerController;
      if (player == null) {
        SmartDialog.showToast('播放器尚未就绪');
        return;
      }
      await player.setSuperResolution(type.name);
      superResolutionType.value = type;
      if (isAnim && !tempPlayerConf) {
        setting.put(SettingBoxKey.superResolutionType, type.index);
      }
      return;
    }
    await _setMpvShader(type);
  }

  Future<void> _setMpvShader([
    SuperResolutionType? type,
    NativePlayer? targetPlayer,
  ]) async {
    if (type == null) {
      type = superResolutionType.value;
    } else {
      superResolutionType.value = type;
      if (isAnim && !tempPlayerConf) {
        setting.put(SettingBoxKey.superResolutionType, type.index);
      }
    }
    final player = targetPlayer ?? _videoPlayerController;
    if (player == null) {
      SmartDialog.showToast('播放器尚未就绪');
      return;
    }
    switch (type) {
      case SuperResolutionType.disable:
        return player.command(const ['change-list', 'glsl-shaders', 'clr', '']);
      case SuperResolutionType.efficiency:
        return player.command([
          'change-list',
          'glsl-shaders',
          'set',
          PathUtils.buildShadersAbsolutePath(
            await copyShadersToExternalDirectory,
            Assets.mpvAnime4KShadersLite,
          ),
        ]);
      case SuperResolutionType.quality:
        return player.command([
          'change-list',
          'glsl-shaders',
          'set',
          PathUtils.buildShadersAbsolutePath(
            await copyShadersToExternalDirectory,
            Assets.mpvAnime4KShaders,
          ),
        ]);
    }
  }

  Future<Player> _initPlayer() async {
    assert(_videoPlayerController == null);
    final opt = {
      'video-sync': Pref.videoSync,
      if (Platform.isAndroid) 'ao': Pref.audioOutput,
      'volume':
          (PlatformUtils.isMobile ? Pref.playerVolume : volume.value * 100)
              .toString(),
      'volume-max': kMaxVolume.toString(),
    };
    final autosync = Pref.autosync;
    if (autosync != '0') {
      opt['autosync'] = autosync;
    }

    final player = await Player.create(
      configuration: PlayerConfiguration(
        logLevel: kDebugMode ? .warn : .error,
        options: opt,
      ),
    );

    assert(_mpvPlayerView == null);

    _mpvPlayerView = await MpvPlayerView.create(
      player,
      enableHardwareAcceleration: hwdec != null,
      hwdec: hwdec,
    );

    player.setMediaHeader(userAgent: BrowserUa.pc, referer: HttpString.baseUrl);

    _startListeners(player);

    return player;
  }

  late final buffer = Pref.initBuffer(_playbackSpeed.value);
  late final liveBuffer = Pref.initLiveBuffer();

  int get _exoTargetBufferBytes {
    final bytes = Pref.bufferSize * 0x200000;
    if (!bytes.isFinite || bytes <= 0) {
      return isLive ? 8 * 1024 * 1024 : 4 * 1024 * 1024;
    }
    return bytes.round().clamp(64 * 1024, 0x7fffffff);
  }

  int get _exoBufferDurationMs {
    final milliseconds =
        Pref.bufferSec * _playbackSpeed.value * Duration.millisecondsPerSecond;
    if (!milliseconds.isFinite || milliseconds <= 0) {
      return 16000;
    }
    return milliseconds.round().clamp(500, 0x7fffffff);
  }

  // 配置播放器
  Future<void> _createVideoController(
    DataSource dataSource,
    Duration? seekTo,
    Volume? volume, {
    bool exoPlayWhenReady = false,
    bool preserveExoSubtitle = false,
  }) async {
    isBuffering.value = false;
    _heartDuration = 0;
    danmakuController?.clear();

    if (useExoPlayer) {
      await _createExoPlayerController(
        dataSource,
        seekTo,
        playWhenReady: exoPlayWhenReady,
        preserveSubtitle: preserveExoSubtitle,
      );
      return;
    }

    var player = _videoPlayerController;

    if (player == null) {
      player = await _initPlayer();
      if (_playerCount == 0) {
        _removeListeners();
        player.dispose();
        player = null;
        _mpvPlayerView = null;
        return;
      }
      _videoPlayerController = player;
      if (isAnim && superResolutionType.value != .disable) {
        await _setMpvShader();
      }
    }

    final Map<String, String> extras = {
      if (dataSource is FileSource)
        'cache': 'no'
      else if (isLive)
        ...liveBuffer
      else
        ...buffer,
    };

    String video = dataSource.videoSource;
    if (dataSource.audioSource case final audio? when (audio.isNotEmpty)) {
      if (onlyPlayAudio.value) {
        video = audio;
      } else {
        // dely_open need provide length
        video =
            ('edl://'
            '!no_chapters;'
            // '!delay_open,media_type=video;'
            '%${isFileSource ? utf8.encode(video).length : video.length}%$video;'
            '!new_stream;!no_chapters;'
            // '!delay_open,media_type=audio;'
            '%${isFileSource ? utf8.encode(audio).length : audio.length}%$audio');
      }
      audioFilterExtras(volume, map: extras);
    }

    await player.open(
      Media(video, start: seekTo, extras: extras.isEmpty ? null : extras),
      play: false,
    );
  }

  Future<void> _createExoPlayerController(
    DataSource dataSource,
    Duration? seekTo, {
    required bool playWhenReady,
    required bool preserveSubtitle,
  }) async {
    final existingPlayer = _exoPlayerController;
    final player =
        existingPlayer ??
        await ExoPlayerController.create(
          enableHardwareDecoding: Pref.enableHA,
          decoderMode: Pref.hardwareDecoding,
          targetBufferBytes: _exoTargetBufferBytes,
          bufferDurationMs: _exoBufferDurationMs,
          isLive: isLive,
        );
    _exoPlayerController = player;
    if (existingPlayer == null) {
      await player.setSuperResolution(superResolutionType.value.name);
    }
    _startExoListeners(player);
    await _openExoPlayer(
      dataSource,
      seekTo ?? Duration.zero,
      playWhenReady: playWhenReady,
      preserveSubtitle: preserveSubtitle,
    );
  }

  Future<void> _openExoPlayer(
    DataSource dataSource,
    Duration position, {
    required bool playWhenReady,
    bool preserveSubtitle = true,
  }) {
    _exoSoftwareFallbackAttempted = false;
    final audio = dataSource.audioSource;
    return _exoPlayerController!.open(
      videoUrl: dataSource.videoSource,
      audioUrl: audio,
      headers: const {
        'User-Agent': BrowserUa.pc,
        'Referer': HttpString.baseUrl,
      },
      expectedWidth: width,
      expectedHeight: height,
      isLive: isLive,
      position: isLive ? Duration.zero : position,
      playWhenReady: playWhenReady,
      preserveSubtitle: preserveSubtitle,
      audioNormalization: audio?.isNotEmpty != true
          ? null
          : _resolveExoAudioNormalization(_normalizationVolume),
    );
  }

  Future<void>? refreshPlayer() {
    if (useExoPlayer && _exoPlayerController != null) {
      _cancelExoRetry(resetAttempts: true);
      return _openExoPlayer(
        dataSource,
        isLive ? Duration.zero : currentPosition,
        playWhenReady: playWhenReady,
      );
    }
    if (dataSource is FileSource) {
      return null;
    }
    if (_videoPlayerController case final ctr? when (ctr.current.isNotEmpty)) {
      return ctr.open(
        ctr.current.last.copyWith(start: ctr.state.position),
        play: true,
      );
    }
    return null;
  }

  // 开始播放
  Future<void> _initializePlayer() async {
    if (_instance == null) return;
    // 设置倍速
    if (isLive) {
      await setPlaybackSpeed(1.0);
    } else {
      if ((useExoPlayer
              ? _exoPlayerController?.state.speed
              : _videoPlayerController?.state.rate) !=
          _playbackSpeed.value) {
        await setPlaybackSpeed(_playbackSpeed.value);
      }
    }
    _initVideoFit();
    // if (_looping) {
    //   await setLooping(_looping);
    // }

    // 跳转播放
    // if (seekTo != Duration.zero) {
    //   await this.seekTo(seekTo);
    // }

    // 自动播放
    if (_autoPlay) {
      playIfExists();
      // await play(duration: duration);
    }
  }

  List<StreamSubscription>? _subscriptions;
  final PlayerListenerRegistry<Duration> _positionListeners =
      PlayerListenerRegistry();
  final PlayerListenerRegistry<PlayerStatus> _statusListeners =
      PlayerListenerRegistry();
  final PlayerListenerRegistry<Size> _videoSizeListeners =
      PlayerListenerRegistry();
  Size? _lastVideoSize;

  void _notifyVideoSize(int width, int height) {
    if (width <= 0 || height <= 0) return;
    final size = Size(width.toDouble(), height.toDouble());
    if (_lastVideoSize == size) return;
    _lastVideoSize = size;
    _videoSizeListeners.notify(size);
  }

  void _startExoListeners(ExoPlayerController player) {
    if (_exoSubscription != null) return;
    bool? lastPlaying;
    bool? lastBuffering;
    bool lastCompleted = false;
    _exoSubscription = player.events.listen((event) {
      if (event.failure case final failure?) {
        _handleExoFailure(player, failure);
        return;
      }

      if (event.ready) {
        _cancelExoRetry(resetAttempts: true);
        dataStatus.value = .loaded;
      }

      final posInSeconds = event.position.inSeconds;
      if (posInSeconds != position.value) {
        if (!isSeeking.value) {
          position.value = posInSeconds;
        }
        videoPlayerServiceHandler?.onPositionChange(event.position);
        makeHeartBeat(posInSeconds);
      }
      _positionListeners.notify(event.position);

      if (event.duration > Duration.zero) {
        updateDuration(event.duration);
      }
      buffered.value = event.buffered.inSeconds;
      _notifyVideoSize(event.width, event.height);

      // Media3 emits a non-playing state immediately after an error. Keep the
      // existing UI playback intent while the same session is being retried.
      if (_exoRetryAttempt > 0) {
        return;
      }

      if (lastBuffering != event.buffering) {
        lastBuffering = event.buffering;
        isBuffering.value = event.buffering;
        videoPlayerServiceHandler?.onStatusChange(
          playerStatus.value,
          event.buffering,
          isLive,
        );
      }

      if (!isLive && event.completed && !lastCompleted) {
        lastCompleted = true;
        _syncAutoEnterPip(false);
        WakelockPlus.disable();
        audioSessionHandler?.setActive(false);
        isBuffering.value = false;
        playerStatus.value = .completed;
        videoPlayerServiceHandler?.onStatusChange(.completed, false, isLive);
        _statusListeners.notify(.completed);
        makeHeartBeat(-1, type: .completed);
      } else if (!event.completed && lastPlaying != event.playing) {
        lastCompleted = false;
        lastPlaying = event.playing;
        WakelockPlus.toggle(enable: event.playing);
        _syncAutoEnterPip(event.playing);
        playerStatus.value = event.playing ? .playing : .paused;
        videoPlayerServiceHandler?.onStatusChange(
          playerStatus.value,
          event.buffering,
          isLive,
        );
        _statusListeners.notify(event.playing ? .playing : .paused);
        if (event.position > Duration.zero) {
          makeHeartBeat(event.position.inSeconds, type: .status);
        }
      }
    });
  }

  void _handleExoFailure(
    ExoPlayerController player,
    ExoPlayerPlaybackFailure failure,
  ) {
    final retryLimit = Pref.retryCount;
    final canRetry = shouldRetryExoPlaybackFailure(
      failure,
      attempt: _exoRetryAttempt,
      limit: retryLimit,
      localSource: dataSource is FileSource,
      sessionActive: _playerCount > 0,
      softwareFallbackAttempted: _exoSoftwareFallbackAttempted,
    );
    if (canRetry) {
      _exoRetryAttempt += 1;
      final isSoftwareFallbackRetry =
          !_exoSoftwareFallbackAttempted &&
          failure.category == ExoPlayerFailureCategory.decoder;
      if (isSoftwareFallbackRetry) {
        _exoSoftwareFallbackAttempted = true;
      }
      final attempt = _exoRetryAttempt;
      final delay = exoPlaybackRetryDelay(
        baseDelayMs: Pref.retryDelay,
        attempt: attempt,
      );
      _exoRetryTimer?.cancel();
      dataStatus.value = .loading;
      isBuffering.value = true;
      videoPlayerServiceHandler?.onStatusChange(
        playerStatus.value,
        true,
        isLive,
      );
      SmartDialog.showToast(
        isSoftwareFallbackRetry
            ? '硬件解码失败，正在切换软件解码重试'
            : '播放连接失败，正在重试（$attempt/$retryLimit）',
        displayTime: const Duration(milliseconds: 900),
      );
      if (kDebugMode) {
        debugPrint(
          failure.diagnostics(
            retryAttempt: attempt,
            retryLimit: retryLimit,
          ),
        );
      }
      final retryPosition = isLive
          ? Duration.zero
          : failure.position > Duration.zero
          ? failure.position
          : currentPosition;
      _exoRetryTimer = Timer(delay, () async {
        _exoRetryTimer = null;
        if (_playerCount == 0 || !identical(player, _exoPlayerController)) {
          return;
        }
        final retryPlayWhenReady = player.playWhenReady;
        try {
          await player.retry(
            position: retryPosition,
            playWhenReady: retryPlayWhenReady,
            forceSoftwareVideo: isSoftwareFallbackRetry,
          );
        } catch (error, stackTrace) {
          _finishExoFailure(
            ExoPlayerPlaybackFailure(
              message: error.toString(),
              errorCode: failure.errorCode,
              errorCodeName: failure.errorCodeName,
              category: failure.category,
              phase: 'retry',
              recoverable: false,
              position: retryPosition,
              playWhenReady: retryPlayWhenReady,
              httpStatus: failure.httpStatus,
              uri: failure.uri,
              rendererName: failure.rendererName,
              videoDecoder: failure.videoDecoder,
              audioDecoder: failure.audioDecoder,
              mediaDescription: failure.mediaDescription,
              causeChain: [
                ...failure.causeChain,
                'Flutter retry invocation: $error',
                stackTrace.toString(),
              ],
            ),
          );
        }
      });
      return;
    }
    _finishExoFailure(failure);
  }

  void _finishExoFailure(ExoPlayerPlaybackFailure failure) {
    _exoRetryTimer?.cancel();
    _exoRetryTimer = null;
    _syncAutoEnterPip(false);
    WakelockPlus.disable();
    audioSessionHandler?.setActive(false);
    isBuffering.value = false;
    playerStatus.value = .paused;
    videoPlayerServiceHandler?.onStatusChange(.paused, false, isLive);
    dataStatus.value = .error;
    final diagnostics =
        failure.diagnostics(
          retryAttempt: _exoRetryAttempt,
          retryLimit: Pref.retryCount,
        ) +
        (_exoSoftwareFallbackAttempted
            ? '\\nsoftwareVideoFallback: attempted'
            : '');
    if (_lastFinalExoFailure != diagnostics) {
      _lastFinalExoFailure = diagnostics;
      SmartDialog.showToast(failure.userMessage);
      Utils.reportError(diagnostics, failure.diagnosticStackTrace);
    }
  }

  void _cancelExoRetry({required bool resetAttempts}) {
    _exoRetryTimer?.cancel();
    _exoRetryTimer = null;
    if (resetAttempts) {
      _exoRetryAttempt = 0;
      _lastFinalExoFailure = null;
      _exoSoftwareFallbackAttempted = false;
    }
  }

  /// 播放事件监听
  void _startListeners(NativePlayer player) {
    assert(_subscriptions == null);
    final stream = player.stream;
    _subscriptions = [
      /// playing
      stream.playing.listen((bool playing) {
        WakelockPlus.toggle(enable: playing);
        _syncAutoEnterPip(playing);
        playerStatus.value = playing ? .playing : .paused;

        videoPlayerServiceHandler?.onStatusChange(
          playerStatus.value,
          isBuffering.value,
          isLive,
        );

        _statusListeners.notify(playing ? .playing : .paused);

        final seconds = _videoPlayerController!.state.position.inSeconds;
        if (seconds != 0) {
          makeHeartBeat(seconds, type: .status);
        }
      }),

      ///completed
      stream.completed.listen((bool completed) {
        if (completed) {
          _syncAutoEnterPip(false);
          WakelockPlus.disable();
          audioSessionHandler?.setActive(false);
          isBuffering.value = false;
          playerStatus.value = .completed;
          videoPlayerServiceHandler?.onStatusChange(.completed, false, isLive);

          _statusListeners.notify(.completed);

          makeHeartBeat(-1, type: .completed);
        }
      }),

      /// position
      stream.position.listen((Duration position) {
        final posInSeconds = position.inSeconds;

        if (posInSeconds != this.position.value) {
          if (!isSeeking.value) {
            this.position.value = posInSeconds;
          }

          videoPlayerServiceHandler?.onPositionChange(position);

          makeHeartBeat(posInSeconds);
        }

        _positionListeners.notify(position);
      }),
      stream.duration.listen(updateDuration),
      stream.buffer.listen((Duration buffer) {
        buffered.value = buffer.inSeconds;
      }),
      stream.size.listen((size) => _notifyVideoSize(size.$1, size.$2)),
      stream.buffering.listen((bool buffering) {
        isBuffering.value = buffering;
        videoPlayerServiceHandler?.onStatusChange(
          playerStatus.value,
          buffering,
          isLive,
        );
      }),
      if (kDebugMode)
        stream.log.listen(((PlayerLog log) {
          if (log.level == 'error' || log.level == 'fatal') {
            Utils.reportError(
              '${log.level}: ${log.prefix}: ${log.text}\n${player.state.playlist}',
              null,
            );
          } else {
            debugPrint(log.toString());
          }
        })),
      stream.error.listen((String event) {
        if (dataSource is FileSource &&
            event.startsWith("Failed to open file")) {
          return;
        }
        if (isLive) {
          if (event.startsWith('tcp: ffurl_read returned ') ||
              event.startsWith("Failed to open https://") ||
              event.startsWith("Can not open external file https://")) {
            Future.delayed(const Duration(milliseconds: 3000), refreshPlayer);
          }
          return;
        }
        if (event.startsWith("Failed to open https://") ||
            event.startsWith("Can not open external file https://") ||
            //tcp: ffurl_read returned 0xdfb9b0bb
            //tcp: ffurl_read returned 0xffffff99
            event.startsWith('tcp: ffurl_read returned ')) {
          EasyThrottle.throttle(
            'controllerStream.error.listen',
            const Duration(milliseconds: 10000),
            () {
              Future.delayed(const Duration(milliseconds: 3000), () {
                // if (kDebugMode) {
                //   debugPrint("isBuffering.value: ${isBuffering.value}");
                // }
                // if (kDebugMode) {
                //   debugPrint("_buffered.value: ${_buffered.value}");
                // }
                if (isBuffering.value && buffered.value == 0) {
                  SmartDialog.showToast(
                    '视频链接打开失败，重试中',
                    displayTime: const Duration(milliseconds: 500),
                  );
                  refreshPlayer();
                }
              });
            },
          );
        } else if (event.startsWith('Could not open codec')) {
          SmartDialog.showToast('无法加载解码器, $event，可能会切换至软解');
        } else if (!onlyPlayAudio.value) {
          if (event.startsWith("error running") ||
              event.startsWith("Failed to open .") ||
              event.startsWith("Cannot open") ||
              event.startsWith("Can not open")) {
            return;
          }
          if (!kDebugMode) {
            Utils.reportError('$event\n${player.state.playlist}');
          }
          // SmartDialog.showToast('视频加载错误, $event');
        }
      }),
    ];
  }

  /// 移除事件监听
  void _removeListeners() {
    _subscriptions?.forEach((e) => e.cancel());
    _subscriptions?.clear();
    _subscriptions = null;
    _exoSubscription?.cancel();
    _exoSubscription = null;
  }

  void _cancelSubForSeek() {
    if (_subForSeek != null) {
      _subForSeek!.cancel();
      _subForSeek = null;
    }
  }

  /// 跳转至指定位置
  Future<void> seekTo(Duration position, {bool isSeek = true}) async {
    if (_playerCount == 0) {
      return;
    }
    if (position < Duration.zero) {
      position = Duration.zero;
    }
    _heartDuration = position.inSeconds;

    Future<void> seek() async {
      if (isSeek) {
        /// 拖动进度条调节时，不等待第一帧，防止抖动
        if (!useExoPlayer) {
          await _videoPlayerController?.stream.buffer.first;
        }
      }
      danmakuController?.clear();
      try {
        if (useExoPlayer) {
          await _exoPlayerController?.seek(position);
        } else {
          await _videoPlayerController?.seek(position);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('seek failed: $e');
      }
    }

    if (duration.value != 0) {
      await seek();
    } else {
      // if (kDebugMode) debugPrint('seek duration else');
      _subForSeek?.cancel();
      _subForSeek = duration.listen((_) {
        seek();
        _cancelSubForSeek();
      });
    }
  }

  /// 设置倍速
  Future<void> setPlaybackSpeed(double speed) async {
    lastPlaybackSpeed = playbackSpeed;

    if (speed ==
        (useExoPlayer
            ? _exoPlayerController?.state.speed
            : _videoPlayerController?.state.rate)) {
      return;
    }

    if (useExoPlayer) {
      await _exoPlayerController?.setPlaybackSpeed(speed);
    } else {
      await _videoPlayerController?.setRate(speed);
    }
    _playbackSpeed.value = speed;
    if (danmakuController != null) {
      try {
        DanmakuOption currentOption = danmakuController!.option;
        double defaultDuration = currentOption.duration * lastPlaybackSpeed;
        double defaultStaticDuration =
            currentOption.staticDuration * lastPlaybackSpeed;
        DanmakuOption updatedOption = currentOption.copyWith(
          duration: defaultDuration / speed,
          staticDuration: defaultStaticDuration / speed,
        );
        danmakuController!.updateOption(updatedOption);
      } catch (_) {}
    }
  }

  // 还原默认速度
  double playSpeedDefault = Pref.playSpeedDefault;
  Future<void> setDefaultSpeed() async {
    if (useExoPlayer) {
      await _exoPlayerController?.setPlaybackSpeed(playSpeedDefault);
    } else {
      await _videoPlayerController?.setRate(playSpeedDefault);
    }
    _playbackSpeed.value = playSpeedDefault;
  }

  /// 播放视频
  Future<void> play({bool repeat = false, bool hideControls = true}) async {
    if (_playerCount == 0) return;
    // 播放时自动隐藏控制条
    controls = !hideControls;
    // repeat为true，将从头播放
    if (repeat) {
      // await seekTo(Duration.zero);
      await seekTo(Duration.zero, isSeek: false);
    }

    final hasAudioFocus = await audioSessionHandler?.setActive(true) ?? true;
    if (!hasAudioFocus) return;

    try {
      if (useExoPlayer) {
        await _exoPlayerController?.play();
      } else {
        await _videoPlayerController?.play();
      }
    } catch (_) {
      await audioSessionHandler?.setActive(false);
      rethrow;
    }

    playerStatus.value = PlayerStatus.playing;
    // screenManager.setOverlays(false);
  }

  /// 暂停播放
  Future<void> pause({bool notify = true, bool isInterrupt = false}) async {
    if (useExoPlayer) {
      await _exoPlayerController?.pause();
    } else {
      await _videoPlayerController?.pause();
    }
    playerStatus.value = PlayerStatus.paused;

    // 主动暂停时让出音频焦点
    if (!isInterrupt) {
      audioSessionHandler?.setActive(false);
    }
  }

  bool tripling = false;

  /// 隐藏控制条
  void hideTaskControls() {
    _timer?.cancel();
    _timer = Timer(showControlDuration, () {
      if (!isSeeking.value && !tripling) {
        controls = false;
      }
      _timer = null;
    });
  }

  void onSeekEnd() {
    if (seekToPos != null) {
      feedBack();
    }
    if (showSeekPreview) {
      showPreview.value = false;
    }
    hasToasted = false;
    isSeeking.value = false;
    hideTaskControls();
  }

  final RxBool volumeIndicator = false.obs;
  Timer? volumeTimer;
  bool volumeInterceptEventStream = false;

  final double maxVolume = PlatformUtils.isDesktop ? Pref.maxVolume : 1.0;

  Future<void> setMuted(bool muted) async {
    isMuted = muted;
    await _applyPlayerOutputVolume();
  }

  double get _basePlayerOutputVolume =>
      PlatformUtils.isMobile ? Pref.playerVolume / 100 : volume.value;

  Future<void> _setAudioFocusGain(double gain) async {
    _audioFocusGain = gain.clamp(0, 1);
    await _applyPlayerOutputVolume();
  }

  Future<void> _applyPlayerOutputVolume() async {
    final volume = isMuted ? 0.0 : _basePlayerOutputVolume * _audioFocusGain;
    if (useExoPlayer) {
      await _exoPlayerController?.setVolume(volume.clamp(0, 1));
    } else {
      await _videoPlayerController?.setVolume(volume * 100);
    }
  }

  Future<void> applyPlayerVolumePreference(double _) =>
      _applyPlayerOutputVolume();

  Future<void> syncDesktopVolume(double volume) async {
    this.volume.value = volume;
    await _applyPlayerOutputVolume();
  }

  Future<void> setVolume(double volume, {bool showIndicator = true}) async {
    if (this.volume.value != volume) {
      this.volume.value = volume;
      try {
        if (PlatformUtils.isDesktop) {
          await _applyPlayerOutputVolume();
        } else {
          FlutterVolumeController.updateShowSystemUI(false);
          await FlutterVolumeController.setVolume(volume);
        }
      } catch (err) {
        if (kDebugMode) debugPrint(err.toString());
      }
    }
    if (showIndicator) {
      volumeIndicator.value = true;
    }
    volumeInterceptEventStream = true;
    volumeTimer?.cancel();
    volumeTimer = Timer(const Duration(milliseconds: 200), () {
      volumeIndicator.value = false;
      volumeInterceptEventStream = false;
      if (PlatformUtils.isDesktop) {
        setting.put(SettingBoxKey.desktopVolume, volume.toPrecision(3));
      }
    });
  }

  /// Toggle Change the videofit accordingly
  void toggleVideoFit(VideoFitType value) {
    _prefFit = videoFit.value = value;
    video.put(VideoBoxKey.cacheVideoFit, value.index);
  }

  /// 读取fit
  var _prefFit = VideoFitType.values[Pref.cacheVideoFit];
  void _initVideoFit() {
    if (_prefFit == .fill && _isVertical) {
      videoFit.value = .contain;
    } else {
      videoFit.value = _prefFit;
    }
  }

  /// 设置后台播放
  void setBackgroundPlay(bool val) {
    videoPlayerServiceHandler?.enableBackgroundPlay = val;
    if (!tempPlayerConf) {
      setting.put(SettingBoxKey.enableBackgroundPlay, val);
    }
  }

  set controls(bool visible) {
    showControls.value = visible;
    _timer?.cancel();
    if (visible) {
      hideTaskControls();
    }
  }

  Timer? longPressTimer;
  void cancelLongPressTimer() {
    longPressTimer?.cancel();
    longPressTimer = null;
  }

  /// 设置长按倍速状态 live模式下禁用
  Future<void> setLongPressStatus(bool val) async {
    if (isLive) {
      return;
    }
    if (controlsLock.value) {
      return;
    }
    if (longPressStatus.value == val) {
      return;
    }
    if (val) {
      if (playerStatus.isPlaying) {
        longPressStatus.value = val;
        HapticFeedback.lightImpact();
        await setPlaybackSpeed(
          enableAutoLongPressSpeed ? playbackSpeed * 2 : longPressSpeed,
        );
      }
    } else {
      // if (kDebugMode) debugPrint('$playbackSpeed');
      longPressStatus.value = val;
      await setPlaybackSpeed(lastPlaybackSpeed);
    }
  }

  bool get isCompleted =>
      (useExoPlayer
          ? _exoPlayerController?.state.completed ?? false
          : _videoPlayerController?.state.completed ?? false) ||
      durationInMilliseconds - positionInMilliseconds <= 50;

  // 双击播放、暂停
  Future<void> onDoubleTapCenter() async {
    if (!isLive && isCompleted) {
      await seekTo(Duration.zero, isSeek: false);
      await play();
    } else {
      if (isPlaying) {
        await pause();
      } else {
        await play();
      }
    }
  }

  final RxBool mountSeekBackwardButton = false.obs;
  final RxBool mountSeekForwardButton = false.obs;

  void onDoubleTapSeekBackward() {
    mountSeekBackwardButton.value = true;
  }

  void onDoubleTapSeekForward() {
    mountSeekForwardButton.value = true;
  }

  void onForward(Duration duration) {
    onForwardBackward(currentPosition + duration);
  }

  void onBackward(Duration duration) {
    onForwardBackward(currentPosition - duration);
  }

  void onForwardBackward(Duration duration) {
    seekTo(
      duration.clamp(Duration.zero, currentDuration),
      isSeek: false,
    ).whenComplete(play);
  }

  void doubleTapFuc(DoubleTapType type) {
    if (!enableQuickDouble) {
      onDoubleTapCenter();
      return;
    }
    switch (type) {
      case DoubleTapType.left:
        // 双击左边区域 👈
        onDoubleTapSeekBackward();
        break;
      case DoubleTapType.center:
        onDoubleTapCenter();
        break;
      case DoubleTapType.right:
        // 双击右边区域 👈
        onDoubleTapSeekForward();
        break;
    }
  }

  /// 关闭控制栏
  void onLockControl(bool val) {
    feedBack();
    controlsLock.value = val;
    if (!val && showControls.value) {
      showControls.refresh();
    }
    controls = !val;
  }

  void _setFullScreen(bool val) {
    isFullScreen.value = val;
    updateSubtitleStyle();
  }

  double screenRatio = 0.0;
  bool isManualFS = true;
  late final FullScreenMode mode = Pref.fullScreenMode;
  late final horizontalScreen = Pref.horizontalScreen;
  late final removeSafeArea = Pref.removeSafeArea;

  Future<void>? changeOrientation({
    required bool isVertical,
    DeviceOrientation? orientation,
  }) {
    if (orientation == .portraitUp) {
      return portraitUpMode();
    }
    if (orientation == .portraitDown) {
      return portraitDownMode();
    }
    if (orientation == null && (mode == .none || mode == .gravity)) {
      return null;
    }
    if (orientation == null &&
        (mode == .vertical ||
            (mode == .auto && isVertical) ||
            (mode == .ratio && (isVertical || screenRatio < kScreenRatio)))) {
      return portraitUpMode();
    } else {
      // https://github.com/flutter/flutter/issues/73651
      // https://github.com/flutter/flutter/issues/183708
      if (Platform.isAndroid) {
        if ((orientation ?? _orientation) == .landscapeRight) {
          return landscapeRightMode();
        } else {
          return landscapeLeftMode();
        }
      } else {
        if (orientation == .landscapeLeft) {
          return landscapeLeftMode();
        } else {
          return landscapeRightMode();
        }
      }
    }
  }

  // 全屏
  bool _fsProcessing = false;
  Future<void> triggerFullScreen({
    bool status = true,
    bool inAppFullScreen = false,
    DeviceOrientation? orientation,
    bool isManualFS = true,
  }) async {
    if (isDesktopPip) return;
    if (isFullScreen.value == status) return;

    if (_fsProcessing) return;
    _fsProcessing = true;
    this.isManualFS = isManualFS;
    try {
      if (status) {
        if (PlatformUtils.isMobile) {
          hideSystemBar();
          await changeOrientation(
            isVertical: isVertical,
            orientation: orientation,
          );
        } else {
          await enterDesktopFullScreen(inAppFullScreen: inAppFullScreen);
        }
      } else {
        if (PlatformUtils.isMobile) {
          if (!removeSafeArea) {
            showSystemBar();
          }
          if (orientation == null && mode == .none) {
            return;
          }
          if (orientation == null) {
            await resetScreenRotation();
          } else {
            await changeOrientation(
              isVertical:
                  orientation == .portraitUp || orientation == .portraitDown,
              orientation: orientation,
            );
          }
        } else {
          await exitDesktopFullScreen();
        }
      }
    } finally {
      _setFullScreen(status);
      _fsProcessing = false;
    }
  }

  void addPositionListener(ValueChanged<Duration> listener) {
    if (_playerCount == 0) return;
    _positionListeners.add(listener);
  }

  void removePositionListener(ValueChanged<Duration> listener) =>
      _positionListeners.remove(listener);

  void addStatusLister(ValueChanged<PlayerStatus> listener) {
    if (_playerCount == 0) return;
    _statusListeners.add(listener);
  }

  void removeStatusLister(ValueChanged<PlayerStatus> listener) =>
      _statusListeners.remove(listener);

  void addVideoSizeListener(ValueChanged<Size> listener) {
    if (_playerCount == 0) return;
    _videoSizeListeners.add(listener);
    final size = _lastVideoSize;
    if (size != null) {
      listener(size);
    }
  }

  void removeVideoSizeListener(ValueChanged<Size> listener) =>
      _videoSizeListeners.remove(listener);

  // 记录播放记录
  Future<void>? makeHeartBeat(
    int progress, {
    HeartBeatType type = .playing,
    bool isManual = false,
    dynamic aid,
    dynamic bvid,
    dynamic cid,
    dynamic epid,
    dynamic seasonId,
    dynamic pgcType,
    VideoType? videoType,
  }) {
    if (isLive ||
        !enableHeart ||
        progress == 0 ||
        (playerStatus.isPaused && !isManual)) {
      return null;
    }

    Future<void> send() {
      return VideoHttp.heartBeat(
        aid: aid ?? _aid,
        bvid: bvid ?? _bvid,
        cid: cid ?? this.cid,
        progress: progress,
        epid: epid ?? _epid,
        seasonId: seasonId ?? _seasonId,
        subType: pgcType ?? _pgcType,
        videoType: videoType ?? _videoType,
      );
    }

    switch (type) {
      case .playing:
        if (progress - _heartDuration >= 5) {
          _heartDuration = progress;
          return send();
        }
      case .status:
        if (progress - _heartDuration >= 2) {
          _heartDuration = progress;
          return send();
        }
      case .completed:
        if (playerStatus.isCompleted &&
            (durationInMilliseconds - positionInMilliseconds) <= 1000) {
          progress = -1;
        }
        return send();
    }
    return null;
  }

  void setPlayRepeat(PlayRepeat type) {
    playRepeat = type;
    if (!tempPlayerConf) video.put(VideoBoxKey.playRepeat, type.index);
  }

  void putSubtitleSettings() {
    setting.putAllNE({
      SettingBoxKey.subtitleFontScale: subtitleFontScale,
      SettingBoxKey.subtitleFontScaleFS: subtitleFontScaleFS,
      SettingBoxKey.subtitlePaddingH: subtitlePaddingH,
      SettingBoxKey.subtitlePaddingB: subtitlePaddingB,
      SettingBoxKey.subtitleBgOpacity: subtitleBgOpacity,
      SettingBoxKey.subtitleStrokeWidth: subtitleStrokeWidth,
      SettingBoxKey.subtitleFontWeight: subtitleFontWeight,
    });
  }

  bool _isCloseAll = false;
  bool get isCloseAll => _isCloseAll;

  Future<void>? resetScreenRotation() {
    if (horizontalScreen) {
      return fullMode();
    } else {
      return portraitUpMode();
    }
  }

  void onCloseAll() {
    _isCloseAll = true;
    if (PlatformUtils.isDesktop) exitDesktopFullScreen();
    dispose();
    Get.until((route) => route.isFirst);
  }

  void dispose() {
    // 每次减1，最后销毁
    resetScreenRotation();
    cancelLongPressTimer();
    _cancelExoRetry(resetAttempts: true);
    _cancelSubForSeek();
    if (!_isCloseAll && _playerCount > 1) {
      _playerCount -= 1;
      _heartDuration = 0;
      return;
    }

    _playerCount = 0;
    _isInAppMiniPlayer = false;
    if (removeSafeArea) {
      showSystemBar();
    }
    danmakuController = null;
    _stopOrientationListener();
    _disableAutoEnterPip();
    audioSessionHandler?.setActive(false);
    setPlayCallBack(null);
    dmState.clear();
    if (showSeekPreview) {
      _clearPreview();
    }
    if (Platform.isAndroid) {
      AndroidHelper$ToDart.onUserLeaveHint?.release();
      AndroidHelper$ToDart.onUserLeaveHint = null;
    }
    _timer?.cancel();
    // _position.close();
    // _playerEventSubs?.cancel();
    // _sliderPosition.close();
    // _sliderTempPosition.close();
    // _isSliderMoving.close();
    // _duration.close();
    // _buffered.close();
    // _showControls.close();
    // _controlsLock.close();

    // playerStatus.close();
    // dataStatus.close();

    if (PlatformUtils.isDesktop && isAlwaysOnTop.value) {
      windowManager.setAlwaysOnTop(false);
    }

    _removeListeners();
    _positionListeners.clear();
    _statusListeners.clear();
    _videoSizeListeners.clear();
    _lastVideoSize = null;
    if (playerStatus.isPlaying) {
      WakelockPlus.disable();
    }
    if (kDebugMode) {
      debugPrint('dispose player');
    }
    _videoPlayerController?.dispose();
    _exoPlayerController?.dispose();
    _videoPlayerController = null;
    _mpvPlayerView = null;
    _exoPlayerController = null;
    _instance = null;
    videoPlayerServiceHandler?.clear();
  }

  static void updatePlayCount() {
    if (_instance?._playerCount == 1) {
      _instance?.dispose();
    } else {
      _instance?._playerCount -= 1;
    }
  }

  void setContinuePlayInBackground() {
    continuePlayInBackground.toggle();
    if (!tempPlayerConf) {
      setting.put(
        SettingBoxKey.continuePlayInBackground,
        continuePlayInBackground.value,
      );
    }
  }

  Future<void> setOnlyPlayAudio() async {
    final disableVideo = !onlyPlayAudio.value;
    await setTrackSelection(
      PlayerMediaTrackType.video,
      disableVideo
          ? PlayerTrackSelectionMode.disabled
          : PlayerTrackSelectionMode.auto,
    );
  }

  late final Map<String, ui.Image?> previewCache = {};
  LoadingState<VideoShotData>? videoShot;
  late final RxBool showPreview = false.obs;
  late final showSeekPreview = Pref.showSeekPreview;
  late final previewIndex = RxnInt();

  void updatePreviewIndex(int seconds) {
    if (videoShot == null) {
      videoShot = LoadingState.loading();
      getVideoShot();
      return;
    }
    if (videoShot case Success(:final response)) {
      showPreview.value = true;
      previewIndex.value = max(
        0,
        (response.index.where((item) => item <= seconds).length - 2),
      );
    }
  }

  void _clearPreview() {
    showPreview.value = false;
    previewIndex.value = null;
    videoShot = null;
    for (final i in previewCache.values) {
      i?.dispose();
    }
    previewCache.clear();
  }

  Future<void> getVideoShot() async {
    videoShot = await VideoHttp.videoshot(bvid: bvid, cid: cid!);
  }

  Future<PlayerFeatureResult<ui.Image>> captureFrame() async {
    if (useExoPlayer) {
      final player = _exoPlayerController;
      if (player == null) {
        return const PlayerFeatureUnavailable('播放器尚未就绪');
      }
      try {
        final bytes = await player.captureFrame(
          flipX: flipX.value,
          flipY: flipY.value,
        );
        return PlayerFeatureSuccess(await decodeCapturedFrame(bytes));
      } catch (error, stackTrace) {
        return PlayerFeatureFailure(
          '截图失败',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    final player = _videoPlayerController;
    if (player == null) {
      return const PlayerFeatureUnavailable('播放器尚未就绪');
    }
    try {
      final image = await player.screenshot();
      if (image == null) {
        return const PlayerFeatureFailure('截图失败');
      }
      return PlayerFeatureSuccess(image);
    } catch (error, stackTrace) {
      return PlayerFeatureFailure(
        '截图失败',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> takeScreenshot() async {
    SmartDialog.showToast('截图中');
    final time = DurationUtils.formatDuration(
      positionInMilliseconds / 1000,
    ).replaceAll(':', '-');
    final result = await captureFrame();
    switch (result) {
      case PlayerFeatureSuccess(:final value):
        SmartDialog.showToast('点击弹窗保存截图');
        showDialog(
          context: Get.context!,
          builder: (context) => GestureDetector(
            onTap: () async {
              final bytes = await value.toByteData(format: .png);
              if (bytes != null) {
                ImageUtils.saveByteImg(
                  bytes: bytes.buffer.asUint8List(),
                  fileName: 'screenshot_${cid}_$time',
                );
              }
              Get.back();
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: min(MediaQuery.widthOf(context) / 3, 350),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 5,
                        color: ColorScheme.of(context).surface,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: RawImage(image: value),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ).whenComplete(value.dispose);
      case PlayerFeatureUnavailable(:final message):
        SmartDialog.showToast(message);
      case PlayerFeatureFailure(
        :final message,
        :final error,
        :final stackTrace,
      ):
        if (error != null) {
          Utils.reportError('$message: $error\n$stackTrace');
        }
        SmartDialog.showToast(message);
    }
  }

  void onPopInvokedWithResult(bool didPop, Object? result) {
    if (didPop) {
      if (playerStatus.isPlaying) {
        pause();
      }

      setPlayCallBack(null);

      if (Platform.isAndroid && _playerCount <= 1) {
        _disableAutoEnterPip();
        if (!setSystemBrightness) {
          ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
        }
      }

      return;
    }

    if (controlsLock.value) {
      onLockControl(false);
      return;
    }
    if (isDesktopPip) {
      exitDesktopPip();
      return;
    }
    if (isFullScreen.value) {
      triggerFullScreen(status: false);
      return;
    }
    Get.back();
  }
}
