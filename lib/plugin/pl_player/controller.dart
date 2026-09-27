import 'dart:async' show Completer, StreamSubscription, Timer, unawaited;
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
import 'package:PiliPlus/models/common/dm_chart_source.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/user/danmaku_rule.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/video/video_shot/data.dart';
import 'package:PiliPlus/pages/danmaku/danmaku_model.dart';
import 'package:PiliPlus/pages/setting/models/play_settings.dart'
    show kMaxVolume;
import 'package:PiliPlus/pages/sponsor_block/block_mixin.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/double_tap_seek_layout.dart';
import 'package:PiliPlus/plugin/pl_player/models/double_tap_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/duration.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/heart_beat_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/speed_lock_hint.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/services/live_pip_overlay_service.dart';
import 'package:PiliPlus/services/pip_overlay_service.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/android/android_helper.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/asset_utils.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/box_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:archive/archive.dart' show getCrc32;
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart'
    show ValueNotifier, clampDouble, kDebugMode;
import 'package:flutter/services.dart' show HapticFeedback, DeviceOrientation;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:path/path.dart' as path;
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:PiliPlus/plugin/pl_player/models/auto_audio_only_state.dart';

typedef PlayCallback = Future<void>? Function();
typedef PlayerInitCallback = Future<void> Function();

class PlPlayerController with BlockConfigMixin, AudioNormalizationMixin {
  Player? _videoPlayerController;
  VideoController? _videoController;

  static PlPlayerController? _instance;

  final Rx<PlayerStatus> _playerStatus = Rx(.paused);
  PlayerStatus get playerStatus => _playerStatus.value;
  set playerStatus(PlayerStatus value) => _playerStatus.value = value;

  final Rx<DataStatus> dataStatus = Rx(.none);

  Duration? seekToPos;
  bool hasToasted = false;
  final RxBool isSeeking = false.obs;

  final RxInt position = RxInt(0);
  final RxInt seekPosition = RxInt(0);
  int get progress => isSeeking.value ? seekPosition.value : position.value;

  int get positionInMilliseconds =>
      videoPlayerController?.state.position.inMilliseconds ?? 0;

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

  /// 系统音量（仅在应用内音量模式下用于追踪当前系统音量）
  final RxDouble systemVolume = RxDouble(1.0);

  /// duck 相关状态
  bool _isDucked = false;
  double _preDuckVolume = 1.0;
  final RxDouble brightness = (-1.0).obs;

  final RxBool showControls = false.obs;

  final RxBool showBrightnessStatus = false.obs;

  final RxBool longPressStatus = false.obs;

  /// 长按倍速锁定（仅当次播放生效，不持久化）
  bool speedLocked = false;

  /// 长按倍速锁定提示（六态，驱动播放器顶部 toast）
  final Rx<SpeedLockHint> speedLockHint = SpeedLockHint.none.obs;

  /// 长按中滑动越线后的预备态：松手才提交锁定/解锁
  bool _speedLockArmed = false;
  Timer? _speedLockHintTimer;

  final RxBool controlsLock = false.obs;

  final RxBool isFullScreen = false.obs;
  void Function(bool isFullScreen)? onFullScreenChanged;
  // 系统原生 PiP 状态
  final RxBool isNativePip = false.obs;
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
  int? roomId;
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

  Box setting = GStorage.setting;

  // final Durations durations;

  String get bvid => _bvid!;

  bool isCurrentVideoSource({
    required String bvid,
    required int cid,
  }) =>
      dataStatus.value == DataStatus.loaded &&
      _bvid == bvid &&
      this.cid == cid;

  /// 视频播放速度
  double get playbackSpeed => _playbackSpeed.value;

  // 长按倍速
  double get longPressSpeed => _longPressSpeed.value;

  /// [videoPlayerController] instance of Player
  Player? get videoPlayerController => _videoPlayerController;

  /// [videoController] instance of Player
  VideoController? get videoController => _videoController;

  bool isMuted = false;

  /// 听视频
  late final RxBool onlyPlayAudio = false.obs;

  /// 后台自动只听音频状态机
  AutoAudioOnlyState _autoAudioState = AutoAudioOnlyState.idle;
  Timer? _autoAudioOnlyTimer;
  bool _audioReopened = false;
  AppLifecycleState? _lastAppLifecycleState;
  bool _autoAudioRestoreInProgress = false;
  int _autoAudioRestoreGeneration = 0;
  Timer? _autoAudioRestoreTimer;
  StreamSubscription? _autoAudioRestoreSubscription;
  Completer<bool>? _autoAudioRestoreCompleter;
  final RxBool suppressBufferingIndicator = false.obs;

  /// 自动恢复需要重初始化的回调（视频→playerInit，直播→queryLiveUrl）
  PlayerInitCallback? onNeedsPlayerInit;

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
      isNativePip.value ||
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

    const shortSide = 280.0;
    const minShortSide = 160.0;
    final Size size;
    final Size minimumSize;
    final state = videoPlayerController!.state;
    int width = state.width;
    int height = state.height;
    if (width == 0) {
      width = this.width ?? 16;
    }
    if (height == 0) {
      height = this.height ?? 9;
    }
    if (height > width) {
      size = Size(shortSide, shortSide * height / width);
      minimumSize = Size(minShortSide, minShortSide * height / width);
    } else {
      size = Size(shortSide * width / height, shortSide);
      minimumSize = Size(minShortSide * width / height, minShortSide);
    }

    await windowManager.setMinimumSize(minimumSize);
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

  bool get _isInInAppPip {
    return PipOverlayService.isInPipMode || LivePipOverlayService.isInPipMode;
  }

  void enterPip({bool autoEnter = false}) {
    if (videoPlayerController case NativePlayer(:final state)) {
      PageUtils.enterPip(
        autoEnter: autoEnter,
        width: state.width == 0 ? width : state.width,
        height: state.height == 0 ? height : state.height,
        isLive: isLive,
        isPlaying: playerStatus.isPlaying,
      );
    }
  }

  // void _disableAutoEnterPipIfNeeded() {
  //   // 对齐上游逻辑，如果是从视频页返回到非视频页，则切断 Auto-Enter PiP
  //   if (!_isPreviousVideoPage) {
  //     _disableAutoEnterPip();
  //   }
  // }

  void disableAutoEnterPip() => _disableAutoEnterPip();

  void _disableAutoEnterPip() {
    if (_isAutoEnterPip) {
      PiliAndroidHelper.disableAutoEnterPip();
    }
  }

  // 弹幕相关配置
  late final enableTapDm = PlatformUtils.isMobile && Pref.enableTapDm;
  late RuleFilter filters = Pref.danmakuFilterRule;
  // 关联弹幕控制器
  DanmakuController<DanmakuExtra>? danmakuController;

  /// 弹幕遮挡区（弹幕层坐标系）。PLVideoPlayer 的几何驱动写入，PlDanmaku 消费；
  /// 两端都以此对象为交接点，画布重建（切 P）时 PlDanmaku 从这里补读。
  final ValueNotifier<Path?> danmakuMaskPath = ValueNotifier(null);
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
  // 副字幕(位置边距与主字幕共用)
  late double subtitleSecondaryFontScale = Pref.subtitleSecondaryFontScale;
  late double subtitleSecondaryFontScaleFS = Pref.subtitleSecondaryFontScaleFS;
  late double subtitleSecondaryBgOpacity = Pref.subtitleSecondaryBgOpacity;
  late double subtitleSecondaryStrokeWidth = Pref.subtitleSecondaryStrokeWidth;
  late int subtitleSecondaryFontWeight = Pref.subtitleSecondaryFontWeight;
  late double subtitleSecondarySpacing = Pref.subtitleSecondarySpacing;

  // settings
  late final showFSActionItem = Pref.showFSActionItem;
  late final enableShrinkVideoSize = Pref.enableShrinkVideoSize;
  late final enablePinchRotate = Pref.enablePinchRotate;
  late final darkVideoPage = Pref.darkVideoPage;
  late final enableSlideVolumeBrightness = Pref.enableSlideVolumeBrightness;
  late final enableSlideFS = Pref.enableSlideFS;
  late final enableDragSubtitle = Pref.enableDragSubtitle;
  Duration get fastBackwardDuration =>
      Duration(seconds: Pref.doubleTapBackwardDuration);
  Duration get fastForwardDuration =>
      Duration(seconds: Pref.doubleTapForwardDuration);

  late final fastForBackwardDuration = Duration(
    seconds: Pref.fastForBackwardDuration,
  );
  bool get enableTwoFingerTapPause => Pref.enableTwoFingerTapPause;
  DoubleTapSeekLayout get doubleTapSeekLayout => DoubleTapSeekLayout.normalize(
    backwardPercent: Pref.doubleTapBackwardZone,
    forwardPercent: Pref.doubleTapForwardZone,
  );

  late final horizontalSeasonPanel = Pref.horizontalSeasonPanel;
  late final preInitPlayer = Pref.preInitPlayer;
  late final showRelatedVideo = Pref.showRelatedVideo;
  late final showVideoReply = Pref.showVideoReply;
  late final showBangumiReply = Pref.showBangumiReply;
  late final reverseFromFirst = Pref.reverseFromFirst;
  late final horizontalPreview = Pref.horizontalPreview;
  DmChartSource get dmChartSource => Pref.dmChartSource;
  bool get showDmChart => dmChartSource.isEnabled;
  late final showViewPoints = Pref.showViewPoints;
  late final showFsScreenshotBtn = Pref.showFsScreenshotBtn;
  late final showFsLockBtn = Pref.showFsLockBtn;
  late final showFsLockBtnRight = Pref.showFsLockBtnRight;
  late final keyboardControl = Pref.keyboardControl;
  late final uiScale = Pref.uiScale;

  late final bool autoEnterFullScreen = Pref.autoEnterFullScreen;
  late final bool autoExitFullscreen = Pref.autoExitFullscreen;
  late final bool autoPlayEnable = Pref.autoPlayEnable;
  late final bool enableVerticalExpand = Pref.enableVerticalExpand;
  late final bool pipNoDanmaku = Pref.pipNoDanmaku;

  late final bool tempPlayerConf = Pref.tempPlayerConf;

  static const int videoPictureParameterMin = -100;
  static const int videoPictureParameterMax = 100;
  static const int audioDelayMin = -1000;
  static const int audioDelayMax = 1000;
  static const int audioDelayStep = 10;
  static const Duration _videoPictureSaveDelay = Duration(milliseconds: 300);

  late final RxInt videoBrightness =
      (tempPlayerConf ? 0 : Pref.videoBrightness).obs;
  late final RxInt videoContrast =
      (tempPlayerConf ? 0 : Pref.videoContrast).obs;
  late final RxInt videoSaturation =
      (tempPlayerConf ? 0 : Pref.videoSaturation).obs;
  late final RxInt videoGamma = (tempPlayerConf ? 0 : Pref.videoGamma).obs;
  late final RxInt videoHue = (tempPlayerConf ? 0 : Pref.videoHue).obs;
  late final RxInt audioDelayMs =
      (tempPlayerConf ? 0 : Pref.audioDelayMs).obs;
  Timer? _videoPictureSaveTimer;

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

  TextStyle _buildSubtitleStyle({
    required double fontScale,
    required double fontScaleFS,
    required int fontWeight,
    required double bgOpacity,
  }) => TextStyle(
    height: 1.5,
    fontSize: 16 * (isFullScreen.value ? fontScaleFS : fontScale),
    letterSpacing: 0.1,
    wordSpacing: 0.1,
    color: Colors.white,
    fontWeight: FontWeight.values[fontWeight],
    backgroundColor: bgOpacity == 0
        ? null
        : Colors.black.withValues(alpha: bgOpacity),
  );

  TextStyle get subTitleStyle => _buildSubtitleStyle(
    fontScale: subtitleFontScale,
    fontScaleFS: subtitleFontScaleFS,
    fontWeight: subtitleFontWeight,
    bgOpacity: subtitleBgOpacity,
  );

  TextStyle get subTitleSecondaryStyle => _buildSubtitleStyle(
    fontScale: subtitleSecondaryFontScale,
    fontScaleFS: subtitleSecondaryFontScaleFS,
    fontWeight: subtitleSecondaryFontWeight,
    bgOpacity: subtitleSecondaryBgOpacity,
  );

  late final Rx<SubtitleViewConfiguration> subtitleConfig = getSubConfig.obs;
  String? _activeVideoContextKey;

  SubtitleViewConfiguration get getSubConfig {
    final subTitleStyle = this.subTitleStyle;
    final secondaryStyle = subTitleSecondaryStyle;

    // 无背景时用描边保证可读性,主副字幕各自独立
    TextStyle? strokeOf(TextStyle base, double bgOpacity, double strokeWidth) =>
        bgOpacity == 0
        ? base.copyWith(
            color: null,
            background: null,
            backgroundColor: null,
            foreground: Paint()
              ..color = Colors.black
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth,
          )
        : null;

    return SubtitleViewConfiguration(
      style: subTitleStyle,
      strokeStyle: strokeOf(
        subTitleStyle,
        subtitleBgOpacity,
        subtitleStrokeWidth,
      ),
      secondaryStyle: secondaryStyle,
      secondaryStrokeStyle: strokeOf(
        secondaryStyle,
        subtitleSecondaryBgOpacity,
        subtitleSecondaryStrokeWidth,
      ),
      spacing: subtitleSecondarySpacing,
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
    if (_instance != null && !(_instance!.playerStatus.isPlaying)) {
      return _instance!.play();
    }
    return _playCallBack?.call();
  }

  // try to get PlayerStatus
  static PlayerStatus? getPlayerStatusIfExists() {
    return _instance?.playerStatus;
  }

  static Future<void>? pauseIfExists({
    bool notify = true,
    bool isInterrupt = false,
  }) {
    if (_instance?.playerStatus.isPlaying ?? false) {
      return _instance?.pause(notify: notify, isInterrupt: isInterrupt);
    }
    return null;
  }

  static Future<void>? seekToIfExists(
    Duration position, {
    bool isSeek = true,
  }) {
    return _instance?.seekTo(position, isSeek: isSeek);
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
        if (_isVertical && controlsLock.value) return;
        if (!horizontalScreen && !isFullScreen) {
          triggerFullScreen(orientation: orientation, isManualFS: false);
        } else {
          landscapeLeftMode();
        }
      case .landscapeRight:
        if (_isVertical && controlsLock.value) return;
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

    if (Platform.isAndroid) {
      Utils.channel.setMethodCallHandler((call) async {
        if (call.method == 'onPipChanged') {
          final bool isInPip = call.arguments as bool;
          isNativePip.value = isInPip;
          PipOverlayService.isNativePip = isInPip;
          LivePipOverlayService.isNativePip = isInPip;
          handleAutoAudioOnlyPipChanged(isInPip);
        }
      });

      if (autoPiP) {
        if (DeviceUtils.sdkInt < 31) {
          AndroidHelper$ToDart.onUserLeaveHint = Runnable.implement(
            $Runnable(run: _onUserLeaveHint),
          );
        } else {
          _isAutoEnterPip = true;
        }
      }
    }
  }

  void _onUserLeaveHint() {
    if (_isInInAppPip) {
      enterPip();
      return;
    }
    if (playerStatus.isPlaying && _isCurrVideoPage) {
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

  static PlPlayerController ensureInstance({bool isLive = false}) {
    return (_instance ??= PlPlayerController._())..isLive = isLive;
  }

  static bool _isAnimPgcType(int? pgcType) => pgcType == 1 || pgcType == 4;

  void resetTempSettings({int? nextPgcType}) {
    if (!tempPlayerConf) {
      return;
    }

    if (kDebugMode) {
      debugPrint(
        '[PlPlayer] resetTempSettings (currentContext: $_activeVideoContextKey, nextPgcType: $nextPgcType)',
      );
    }

    enableShowDanmaku.value = Pref.enableShowDanmaku;
    enableShowLiveDanmaku.value = Pref.enableShowLiveDanmaku;
    videoPlayerServiceHandler?.enableBackgroundPlay = Pref.enableBackgroundPlay;
    continuePlayInBackground.value = Pref.continuePlayInBackground;
    playRepeat = Pref.playRepeat;
    cacheVideoQa = PlatformUtils.isMobile ? null : Pref.defaultVideoQa;
    cacheAudioQa = Pref.defaultAudioQa;
    if (_playbackSpeed.value != playSpeedDefault) {
      unawaited(setPlaybackSpeed(playSpeedDefault));
    }

    final defaultSuperResolutionType = _isAnimPgcType(nextPgcType)
        ? Pref.superResolutionType
        : SuperResolutionType.disable;
    superResolutionType.value = defaultSuperResolutionType;
    if (_videoPlayerController != null) {
      unawaited(setShader(defaultSuperResolutionType, _videoPlayerController!));
    }

    resetAllVideoPictureParameters(persist: false);
  }

  int _normalizeVideoPictureParameter(num value) =>
      value.round().clamp(
        videoPictureParameterMin,
        videoPictureParameterMax,
      ).toInt();

  RxInt? _videoPictureParameterState(String property) => switch (property) {
    'brightness' => videoBrightness,
    'contrast' => videoContrast,
    'saturation' => videoSaturation,
    'gamma' => videoGamma,
    'hue' => videoHue,
    _ => null,
  };

  void setVideoPictureParameter(String property, num value) {
    final state = _videoPictureParameterState(property);
    if (state == null) return;

    final normalized = _normalizeVideoPictureParameter(value);
    state.value = normalized;
    _applyVideoPictureProperty(property, normalized);
    _scheduleVideoPictureSettingsSave();
  }

  void resetVideoPictureParameter(String property) {
    setVideoPictureParameter(property, 0);
  }

  void setAudioDelay(int value) {
    audioDelayMs.value = value.clamp(audioDelayMin, audioDelayMax).toInt();
    _applyAudioDelay();
    _scheduleVideoPictureSettingsSave();
  }

  void resetAudioDelay() => setAudioDelay(0);

  void _applyAudioDelay() {
    final player = _videoPlayerController;
    if (player == null || onlyPlayAudio.value) return;
    try {
      player.setProperty('audio-delay', (audioDelayMs.value / 1000).toString());
    } catch (_) {}
  }

  void resetAllVideoPictureParameters({bool persist = true}) {
    videoBrightness.value = 0;
    videoContrast.value = 0;
    videoSaturation.value = 0;
    videoGamma.value = 0;
    videoHue.value = 0;
    audioDelayMs.value = 0;
    applyVideoPictureParameters();
    if (persist) {
      _scheduleVideoPictureSettingsSave();
    }
  }

  void _applyVideoPictureProperty(String property, int value) {
    final player = _videoPlayerController;
    if (player == null || onlyPlayAudio.value) return;
    try {
      player.setProperty(property, value.toString());
    } catch (_) {}
  }

  void applyVideoPictureParameters([Player? target]) {
    final player = target ?? _videoPlayerController;
    if (player == null || onlyPlayAudio.value) return;
    try {
      player
        ..setProperty('brightness', videoBrightness.value.toString())
        ..setProperty('contrast', videoContrast.value.toString())
        ..setProperty('saturation', videoSaturation.value.toString())
        ..setProperty('gamma', videoGamma.value.toString())
        ..setProperty('hue', videoHue.value.toString())
        ..setProperty('audio-delay', (audioDelayMs.value / 1000).toString());
    } catch (_) {}
  }

  void _scheduleVideoPictureSettingsSave() {
    if (tempPlayerConf) return;
    _videoPictureSaveTimer?.cancel();
    _videoPictureSaveTimer = Timer(
      _videoPictureSaveDelay,
      persistVideoPictureSettings,
    );
  }

  void persistVideoPictureSettings() {
    _videoPictureSaveTimer?.cancel();
    _videoPictureSaveTimer = null;
    if (tempPlayerConf) return;
    setting.putAllNE({
      SettingBoxKey.videoBrightness: videoBrightness.value,
      SettingBoxKey.videoContrast: videoContrast.value,
      SettingBoxKey.videoSaturation: videoSaturation.value,
      SettingBoxKey.videoGamma: videoGamma.value,
      SettingBoxKey.videoHue: videoHue.value,
      SettingBoxKey.audioDelayMs: audioDelayMs.value,
    });
  }

  bool _processing = false;
  bool get processing => _processing;

  // offline
  bool get isFileSource => dataSource is FileSource;

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
    int? roomId,
    int? epid,
    int? seasonId,
    int? pgcType,
    VideoType? videoType,
    VoidCallback? onInit,
    Volume? volume,
    bool autoFullScreenFlag = false,
  }) async {
    try {
      _processing = true;
      // 换视频/换P：解除倍速锁定并恢复锁定前速度。
      // 必须先于临时配置重置执行，否则 lastPlaybackSpeed 会被先行覆盖
      await releaseSpeedLock();
      final nextVideoContextKey = PipOverlayService.buildVideoContextKey(
        videoType: videoType ?? VideoType.ugc,
        bvid: bvid,
        cid: cid,
        epId: epid,
        seasonId: seasonId,
      );
      final shouldResetTempSettings =
          tempPlayerConf &&
          _activeVideoContextKey != null &&
          nextVideoContextKey != null &&
          nextVideoContextKey != _activeVideoContextKey;
      final nextVideoType = videoType ?? VideoType.ugc;
      // 非 UGC/live 先回全局基准，再 resetTempSettings，避免 temp 重置时仍用作者 playSpeedDefault
      // UGC 的 mid 注入由 intro / playerInit 的 applyAuthorDefaultSpeed 负责
      if (isLive || nextVideoType != VideoType.ugc) {
        resetAuthorDefaultSpeedToGlobal(force: false);
      }
      if (shouldResetTempSettings) {
        resetTempSettings(nextPgcType: pgcType);
      }
      _activeVideoContextKey = nextVideoContextKey;

      // 换视频上下文时取消自动只听定时器，状态保持
      _cancelAutoAudioOnlyTimer();
      _interruptAutoAudioRestore();
      if (_autoAudioState == AutoAudioOnlyState.autoAudioOnly) {
        _audioReopened = true;
      }
      this.isLive = isLive;
      _videoType = nextVideoType;
      this.width = width;
      this.height = height;
      this.dataSource = dataSource;
      _autoPlay = autoplay;
      // 初始化数据加载状态
      dataStatus.value = DataStatus.loading;
      // 初始化全屏方向
      _isVertical = isVertical ?? false;
      _aid = aid;
      _bvid = bvid;
      this.cid = cid;
      this.roomId = roomId;
      _epid = epid;
      _seasonId = seasonId;
      _pgcType = pgcType;

      if (showSeekPreview) {
        _clearPreview();
      }
      hideDesktopProgressPreview();
      cancelLongPressTimer();
      if (_videoPlayerController != null &&
          _videoPlayerController!.state.playing) {
        await pause(notify: false);
      }

      if (_playerCount == 0) {
        if (kDebugMode) {
          debugPrint(
            '[PlPlayer] setDataSource aborted: _playerCount == 0 before init',
          );
        }
        return;
      }
      // 配置Player 音轨、字幕等等
      await _createVideoController(dataSource, seekTo, volume);

      if (_playerCount == 0) {
        if (kDebugMode) {
          debugPrint(
            '[PlPlayer] setDataSource aborted: _playerCount == 0 after createVideoController',
          );
        }
        _removeListeners();
        _videoPlayerController?.dispose();
        _videoPlayerController = null;
        _videoController = null;
        return;
      }

      updateDuration(duration ?? _videoPlayerController!.state.duration);
      position.value = buffered.value = seekTo?.inSeconds ?? 0;

      dataStatus.value = .loaded;
      if (_canUseSeekPreview) {
        unawaited(ensureVideoShot());
      }

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
  Future<void> setShader([SuperResolutionType? type, NativePlayer? pp]) async {
    if (type == null) {
      type = superResolutionType.value;
    } else {
      superResolutionType.value = type;
      if (isAnim && !tempPlayerConf) {
        setting.put(SettingBoxKey.superResolutionType, type.index);
      }
    }
    pp ??= _videoPlayerController!;
    switch (type) {
      case SuperResolutionType.disable:
        return pp.command(const ['change-list', 'glsl-shaders', 'clr', '']);
      case SuperResolutionType.efficiency:
        return pp.command([
          'change-list',
          'glsl-shaders',
          'set',
          PathUtils.buildShadersAbsolutePath(
            await copyShadersToExternalDirectory,
            Assets.mpvAnime4KShadersLite,
          ),
        ]);
      case SuperResolutionType.quality:
        return pp.command([
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
    if (PlatformUtils.isMobile && Pref.enableAppVolume) {
      // 移动平台应用内音量模式：初始化系统音量
      systemVolume.value = (await FlutterVolumeController.getVolume()) ?? 1.0;
      // 从持久化存储读取应用内音量
      volume.value = Pref.appVolume;
    }
    final opt = {
      'video-sync': Pref.videoSync,
      if (Platform.isAndroid) 'ao': Pref.audioOutput,
      'volume': (PlatformUtils.isMobile
              ? (Pref.enableAppVolume ? volume.value * 100 : Pref.playerVolume)
              : volume.value * 100)
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

    assert(_videoController == null);

    _videoController = await VideoController.create(
      player,
      configuration: VideoControllerConfiguration(
        enableHardwareAcceleration: hwdec != null,
        androidAttachSurfaceAfterVideoParameters: false,
        hwdec: hwdec,
      ),
    );

    player.setMediaHeader(userAgent: BrowserUa.pc, referer: HttpString.baseUrl);

    _startListeners(player);

    return player;
  }

  late final buffer = Pref.initBuffer(_playbackSpeed.value);
  late final liveBuffer = Pref.initLiveBuffer();

  // 配置播放器
  Future<void> _createVideoController(
    DataSource dataSource,
    Duration? seekTo,
    Volume? volume,
  ) async {
    isBuffering.value = false;
    _heartDuration = 0;
    position.value = seekTo?.inSeconds ?? 0;
    buffered.value = 0;
    danmakuController?.clear();

    var player = _videoPlayerController;

    if (player == null) {
      player = await _initPlayer();
      if (_playerCount == 0) {
        _removeListeners();
        player.dispose();
        player = null;
        _videoController = null;
        return;
      }
      _videoPlayerController = player;
      if (isAnim && superResolutionType.value != .disable) {
        await setShader();
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

    assert(!isLive || seekTo == null);
    await player.open(
      Media(video, start: seekTo, extras: extras.isEmpty ? null : extras),
      play: false,
    );
    applyVideoPictureParameters(player);
  }

  Future<void>? refreshPlayer() {
    if (dataSource is FileSource) {
      return null;
    }
    if (_videoPlayerController case final ctr? when (ctr.current.isNotEmpty)) {
      var media = ctr.current.last;
      if (!isLive) media = media.copyWith(start: ctr.state.position);
      return ctr.open(media, play: true);
    }
    return null;
  }

  // 开始播放
  Future<void> _initializePlayer() async {
    if (_instance == null) return;
    // 设置倍速
    if (_videoPlayerController != null) {
      final speed = isLive ? 1.0 : playbackSpeed;
      if (_videoPlayerController!.state.rate != speed) {
        await setPlaybackSpeed(speed);
      }
    }
    _initVideoFit();

    // 自动播放
    if (_autoPlay) {
      playIfExists();
    }
  }

  List<StreamSubscription>? _subscriptions;
  final Set<ValueChanged<Duration>> _positionListeners = {};
  final Set<ValueChanged<PlayerStatus>> _statusListeners = {};

  Timer? _wakeLockTimer;

  void _startWakeLockTimer() {
    _wakeLockTimer?.cancel();
    _wakeLockTimer = Timer(
      const Duration(milliseconds: 500),
      _stopWakeLock,
    );
  }

  void _stopWakeLockTimer() {
    _wakeLockTimer?.cancel();
    _wakeLockTimer = null;
  }

  void _stopWakeLock() {
    WakelockPlus.disable();
    _updatePlaybackState(debugLabel: 'onVideoPaused');
  }

  void _updatePlaybackState({Duration? position, String? debugLabel}) {
    videoPlayerServiceHandler?.onUpdateState(
      playerStatus,
      isBuffering.value,
      isLive,
      position: position ?? _videoPlayerController!.state.position,
      speed: playbackSpeed,
      debugLabel: debugLabel,
    );
  }

  /// 播放事件监听
  void _startListeners(NativePlayer player) {
    assert(_subscriptions == null);
    final stream = player.stream;
    _subscriptions = [
      /// playing
      stream.playing.listen((bool playing) {
        if (playing) {
          playerStatus = .playing;
          _stopWakeLockTimer();
          _updatePlaybackState();
          WakelockPlus.enable();

          if (_isAutoEnterPip &&
              _autoAudioState != AutoAudioOnlyState.autoAudioOnly) {
            if (_isCurrVideoPage || _isInInAppPip) {
              enterPip(autoEnter: true);
            } else {
              _disableAutoEnterPip();
            }
          }
        } else {
          playerStatus = .paused;
          _startWakeLockTimer();
          _disableAutoEnterPip();
        }

        for (final element in _statusListeners) {
          element(playing ? .playing : .paused);
        }

        final seconds = videoPlayerController!.state.position.inSeconds;
        if (seconds != 0) {
          makeHeartBeat(seconds, type: .status);
        }
      }),

      ///completed
      stream.completed.listen((bool completed) {
        if (completed) {
          playerStatus = .completed;
          _startWakeLockTimer();

          for (final element in _statusListeners) {
            element(.completed);
          }

          makeHeartBeat(-1, type: .completed);
        }
      }),

      /// position
      stream.position.listen((Duration position) {
        final posInSeconds = position.inSeconds;

        if (posInSeconds != this.position.value) {
          if (posInSeconds == 0 && playerStatus.isPlaying) {
            _updatePlaybackState(position: position);
          }

          this.position.value = posInSeconds;

          makeHeartBeat(posInSeconds);
        }

        for (final element in _positionListeners) {
          element(position);
        }
      }),
      stream.duration.listen(updateDuration),
      stream.buffer.listen((Duration buffer) {
        buffered.value = buffer.inSeconds;
      }),
      stream.buffering.listen((bool buffering) {
        isBuffering.value = buffering;
        if (!playerStatus.isCompleted) {
          _stopWakeLockTimer();
          _updatePlaybackState();
        }
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
            Timer(const Duration(milliseconds: 3000), refreshPlayer);
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
              Timer(const Duration(milliseconds: 3000), () {
                // if (kDebugMode) {
                //   debugPrint("isBuffering.value: ${isBuffering.value}");
                // }
                // if (kDebugMode) {
                //   debugPrint("_buffered.value: ${_buffered.value}");
                // }
                if (isBuffering.value && buffered.value == 0) {
                  final customHost = VideoUtils.customCDNUrl;
                  SmartDialog.showToast(
                    customHost == null
                        ? '视频链接打开失败，重试中'
                        : '视频链接打开失败，重试中\n当前自定义CDN节点：$customHost，持续失败可尝试更换或清除',
                    displayTime: customHost == null
                        ? const Duration(milliseconds: 500)
                        : const Duration(milliseconds: 3000),
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
  }

  void _cancelSubForSeek() {
    if (_subForSeek != null) {
      _subForSeek!.cancel();
      _subForSeek = null;
    }
  }

  Future<void> seek(Duration position, {bool isSeek = false}) async {
    if (isSeek) {
      /// 拖动进度条调节时，不等待第一帧，防止抖动
      await _videoPlayerController?.stream.buffer.first;
    }
    danmakuController?.clear();
    try {
      await _videoPlayerController?.seek(position);
    } catch (e) {
      if (kDebugMode) debugPrint('seek failed: $e');
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

    if (duration.value != 0) {
      seek(position, isSeek: isSeek);
    } else {
      // if (kDebugMode) debugPrint('seek duration else');
      _subForSeek?.cancel();
      _subForSeek = duration.listen((_) {
        seek(position, isSeek: isSeek);
        _cancelSubForSeek();
      });
    }
  }

  /// 设置倍速
  Future<void> setPlaybackSpeed(double speed) async {
    lastPlaybackSpeed = playbackSpeed;

    if (speed == _videoPlayerController?.state.rate) {
      return;
    }

    await _videoPlayerController?.setRate(speed);
    _playbackSpeed.value = speed;
    _updatePlaybackState();
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

  // 当前视频 effective 默认倍速（UGC 可为作者专属，非 UGC/live 回退全局）
  double playSpeedDefault = Pref.playSpeedDefault;
  int? _authorMidForSpeed;

  /// 按作者更新当前视频的默认倍速。
  /// [force] 为 true 时立即 setPlaybackSpeed；为 false 时只更新 playSpeedDefault 基准。
  Future<void> applyAuthorDefaultSpeed(int? mid, {bool force = true}) async {
    final next = Pref.playSpeedForAuthor(mid);
    final midChanged = _authorMidForSpeed != mid;
    _authorMidForSpeed = mid;
    playSpeedDefault = next;
    if (force && (midChanged || _playbackSpeed.value != next)) {
      await setPlaybackSpeed(next);
    }
  }

  /// 非 UGC / live 时回退到全局默认倍速基准。
  void resetAuthorDefaultSpeedToGlobal({bool force = false}) {
    final hadAuthor = _authorMidForSpeed != null;
    _authorMidForSpeed = null;
    playSpeedDefault = Pref.playSpeedDefault;
    if (force && (hadAuthor || _playbackSpeed.value != playSpeedDefault)) {
      unawaited(setPlaybackSpeed(playSpeedDefault));
    }
  }

  Future<void> setDefaultSpeed() async {
    await _videoPlayerController?.setRate(playSpeedDefault);
    _playbackSpeed.value = playSpeedDefault;
  }

  bool _showControlsOnNextPlay = false;

  void markManualEpisodeChange() {
    if (Pref.showControlsOnManualEpisodeChange) {
      _showControlsOnNextPlay = true;
    }
  }

  bool _consumeShowControlsOnNextPlay() {
    final showControls = _showControlsOnNextPlay;
    _showControlsOnNextPlay = false;
    return showControls;
  }

  /// 底层播放：申请音频焦点 + 启动播放，不含 UI 副作用
  Future<void> _rawPlay() async {
    await _videoPlayerController?.play();
    audioSessionHandler?.setActive(true);
    playerStatus = PlayerStatus.playing;
  }

  /// 播放视频
  Future<void> play({bool repeat = false, bool hideControls = true}) async {
    if (_playerCount == 0) return;
    // 播放时自动隐藏控制条
    final showControlsOnNextPlay = _consumeShowControlsOnNextPlay();
    controls = !hideControls || showControlsOnNextPlay;
    // repeat为true，将从头播放
    if (repeat) {
      await seekTo(Duration.zero, isSeek: false);
    }

    await _rawPlay();
  }

  /// 暂停播放
  Future<void> pause({bool notify = true, bool isInterrupt = false}) async {
    await _videoPlayerController?.pause();
    playerStatus = .paused;

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

  void onSeekStart(int seekFrom) {
    seekPosition.value = seekFrom;
    isSeeking.value = true;
  }

  void onSeekEnd() {
    if (showSeekPreview) {
      showPreview.value = false;
    }
    hasToasted = false;
    isSeeking.value = false;
    if (PlatformUtils.isDesktop) {
      requireDesktopProgressHoverReenter = _desktopProgressPointerInside;
      hideDesktopProgressPreview();
    }
    hideTaskControls();
  }

  final RxBool volumeIndicator = false.obs;
  Timer? volumeTimer;
  bool volumeInterceptEventStream = false;

  double get maxVolume => PlatformUtils.isDesktop
      ? Pref.maxVolume
      : (Pref.enableAppVolume && Pref.enableVolumeBoost ? 2.0 : 1.0);

  // 音量增强二次确认：是否已解锁突破 100%（松手后重置）
  bool volumeBoostUnlocked = false;

  // 手势滑动时的音量上限：未解锁时最大 1.0，解锁后最大 2.0
  double get gestureVolumeMax {
    if (Pref.enableAppVolume && Pref.enableVolumeBoost) {
      return volumeBoostUnlocked ? 2.0 : 1.0;
    }
    return maxVolume;
  }

  // 松手时重置解锁状态
  void onVolumeGestureEnd() {
    if (Pref.enableAppVolume && Pref.enableVolumeBoost) {
      volumeBoostUnlocked = false;
    }
  }

  Future<void> setVolume(double volume, {bool showIndicator = true}) async {
    if (this.volume.value != volume) {
      this.volume.value = volume;
      try {
        if (PlatformUtils.isDesktop) {
          await _videoPlayerController!.setVolume(volume * 100);
        } else {
          // 移动平台：根据设置选择音量控制方式
          if (Pref.enableAppVolume) {
            // 应用内音量模式：使用 media_kit 控制应用内音量
            _videoPlayerController?.setVolume(volume * 100);
          } else {
            // 默认模式：控制系统音量
            FlutterVolumeController.updateShowSystemUI(false);
            await FlutterVolumeController.setVolume(volume);
          }
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
      } else if (Pref.enableAppVolume) {
        // 移动平台应用内音量模式：保存音量到持久化存储
        // duck 期间不保存，避免保存临时的减半音量
        if (!_isDucked) {
          Pref.appVolume = volume;
        }
      }
    });
  }

  /// 处理应用内音量设置变更
  Future<void> onAppVolumeSettingChanged() async {
    if (!PlatformUtils.isMobile) return;

    // 如果播放器未初始化，直接返回（设置已保存，下次播放器初始化时生效）
    if (_videoPlayerController == null) return;

    if (Pref.enableAppVolume) {
      // 切换到应用内音量模式
      // 获取当前系统音量
      final currentSystemVolume =
          (await FlutterVolumeController.getVolume()) ?? 1.0;
      systemVolume.value = currentSystemVolume;

      final appVolume = (Pref.playerVolume / 100)
          .clamp(0.0, maxVolume)
          .toDouble();
      volume.value = appVolume;
      Pref.appVolume = appVolume;
      volumeBoostUnlocked = false;

      // 关闭上游固定增益，避免和应用内音量叠加
      _videoPlayerController?.setVolume(appVolume * 100);

      // 显示提示
      SmartDialog.showToast('已切换到应用内音量模式');
    } else {
      // 切换到同步系统音量模式
      // 恢复上游播放器音量设置，并按增益折算系统音量
      final currentSystemVolume =
          (await FlutterVolumeController.getVolume()) ?? 1.0;
      final playerGain = max(Pref.playerVolume / 100, 0.01);
      final newSystemVolume = (currentSystemVolume * volume.value / playerGain)
          .clamp(0.0, 1.0)
          .toDouble();

      await FlutterVolumeController.updateShowSystemUI(false);
      await FlutterVolumeController.setVolume(newSystemVolume);
      await _videoPlayerController?.setVolume(Pref.playerVolume);
      volumeBoostUnlocked = false;

      // 更新状态
      systemVolume.value = newSystemVolume;
      volume.value = newSystemVolume;

      SmartDialog.showToast('已切换到同步系统音量模式');
    }
  }

  /// duck 事件处理（由 audio_session.dart 调用）
  Future<void> handleDuck(bool begin) async {
    if (!PlatformUtils.isMobile) return;

    if (Pref.enableAppVolume) {
      // 应用内音量模式：使用临时音量，不影响持久化值
      if (begin) {
        _isDucked = true;
        _preDuckVolume = volume.value;
        volume.value = volume.value * 0.5;
        _videoPlayerController?.setVolume(volume.value * 100);
      } else {
        _isDucked = false;
        volume.value = _preDuckVolume;
        _videoPlayerController?.setVolume(volume.value * 100);
      }
    }
    // 同步模式：使用原有逻辑，直接调用 setVolume 即可
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
    if (!visible && PlatformUtils.isDesktop) {
      hideDesktopProgressPreview();
    }
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
  Future<void> setLongPressStatus(bool val, {bool isCancel = false}) async {
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
        _speedLockArmed = false;
        _cancelSpeedLockHintTimer();
        longPressStatus.value = val;
        HapticFeedback.lightImpact();
        if (speedLocked) {
          // 锁定态：速度已固化为锁定值，不得再调速——setPlaybackSpeed 会
          // 覆盖 lastPlaybackSpeed（锁定前速度），动态倍速下还会二次翻倍
          speedLockHint.value = SpeedLockHint.swipeDownToUnlock;
        } else {
          await setPlaybackSpeed(
            enableAutoLongPressSpeed ? playbackSpeed * 2 : longPressSpeed,
          );
          if (longPressStatus.value) {
            speedLockHint.value = SpeedLockHint.swipeUpToLock;
          }
        }
      }
    } else {
      // 预备态在松手时提交；系统打断（cancel）一律不提交
      final bool commit = _speedLockArmed && !isCancel;
      _speedLockArmed = false;
      longPressStatus.value = val;
      if (speedLocked) {
        if (commit) {
          speedLocked = false;
          HapticFeedback.mediumImpact();
          await setPlaybackSpeed(lastPlaybackSpeed);
          _showTransientSpeedLockHint(SpeedLockHint.unlockedConfirm);
        } else {
          speedLockHint.value = SpeedLockHint.none;
        }
      } else {
        if (commit) {
          speedLocked = true;
          HapticFeedback.mediumImpact();
          _showTransientSpeedLockHint(SpeedLockHint.lockedConfirm);
        } else {
          speedLockHint.value = SpeedLockHint.none;
          await setPlaybackSpeed(lastPlaybackSpeed);
        }
      }
    }
  }

  // 长按倍速锁定：预备阈值 = 播放器实高 × 比例，clamp 到人体工学区间。
  // 比例由实测锚点反推（横屏半屏 48/231≈0.21、横屏全屏 96/411≈0.23），
  // 下限保小窗/小播放器手感，上限≈2.7cm 为拇指第一指节舒适推程封顶
  static const double _speedLockThresholdRatio = 0.22;
  static const double _speedLockThresholdMin = 48;
  static const double _speedLockThresholdMax = 112;
  static const double _speedLockHysteresis = 10;

  /// 长按中手指移动，dy 为相对长按起点的纵向偏移（上滑为负），
  /// [playerHeight] 为播放器组件实高（决定阈值）。
  /// 越线进入预备态、滑回取消预备，均可反复，提交只发生在松手
  void onLongPressMove(double dy, double playerHeight) {
    if (!longPressStatus.value) {
      return;
    }
    final double threshold = clampDouble(
      playerHeight * _speedLockThresholdRatio,
      _speedLockThresholdMin,
      _speedLockThresholdMax,
    );
    if (speedLocked) {
      // 下滑预备退出
      if (!_speedLockArmed && dy >= threshold) {
        _speedLockArmed = true;
        HapticFeedback.lightImpact();
        speedLockHint.value = SpeedLockHint.releaseToUnlock;
      } else if (_speedLockArmed && dy <= threshold - _speedLockHysteresis) {
        _speedLockArmed = false;
        HapticFeedback.lightImpact();
        speedLockHint.value = SpeedLockHint.swipeDownToUnlock;
      }
    } else {
      // 上滑预备锁定
      if (!_speedLockArmed && dy <= -threshold) {
        _speedLockArmed = true;
        HapticFeedback.lightImpact();
        speedLockHint.value = SpeedLockHint.releaseToLock;
      } else if (_speedLockArmed && dy >= -(threshold - _speedLockHysteresis)) {
        _speedLockArmed = false;
        HapticFeedback.lightImpact();
        speedLockHint.value = SpeedLockHint.swipeUpToLock;
      }
    }
  }

  /// 手动调速（倍速菜单/快捷键）：锁定态下先解除锁定再应用所选速度
  Future<void> setManualPlaybackSpeed(double speed) async {
    if (speedLocked) {
      await releaseSpeedLock(restoreSpeed: false);
    }
    await setPlaybackSpeed(speed);
  }

  /// 解除倍速锁定；[restoreSpeed] 为 true 时恢复锁定前速度
  Future<void> releaseSpeedLock({bool restoreSpeed = true}) async {
    if (!speedLocked) {
      return;
    }
    speedLocked = false;
    _speedLockArmed = false;
    _cancelSpeedLockHintTimer();
    speedLockHint.value = SpeedLockHint.none;
    if (restoreSpeed) {
      await setPlaybackSpeed(lastPlaybackSpeed);
    }
  }

  void _showTransientSpeedLockHint(SpeedLockHint hint) {
    speedLockHint.value = hint;
    _speedLockHintTimer?.cancel();
    _speedLockHintTimer = Timer(const Duration(seconds: 2), () {
      if (speedLockHint.value == hint) {
        speedLockHint.value = SpeedLockHint.none;
      }
    });
  }

  void _cancelSpeedLockHintTimer() {
    _speedLockHintTimer?.cancel();
    _speedLockHintTimer = null;
  }

  bool get isCompleted =>
      videoPlayerController!.state.completed ||
      durationInMilliseconds - positionInMilliseconds <= 50;

  // 双击播放、暂停
  Future<void> onDoubleTapCenter() async {
    if (!isLive && isCompleted) {
      await videoPlayerController!.seek(Duration.zero);
      await _rawPlay();
    } else if (videoPlayerController!.state.playing) {
      await pause();
    } else {
      await _rawPlay();
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
    onForwardBackward(videoPlayerController!.state.position + duration);
  }

  void onBackward(Duration duration) {
    onForwardBackward(videoPlayerController!.state.position - duration);
  }

  void onForwardBackward(Duration duration) {
    seekTo(
      duration.clamp(Duration.zero, videoPlayerController!.state.duration),
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
    if (val) {
      hideDesktopProgressPreview();
    }
    if (!val && showControls.value) {
      showControls.refresh();
    }
    controls = !val;
  }

  void _setFullScreen(bool val) {
    isFullScreen.value = val;
    updateSubtitleStyle();
    onFullScreenChanged?.call(val);
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
          await resetScreenRotation();
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
    if (!isManual && dataStatus.value != DataStatus.loaded) {
      return null;
    }
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
      SettingBoxKey.subtitleSecondaryFontScale: subtitleSecondaryFontScale,
      SettingBoxKey.subtitleSecondaryFontScaleFS: subtitleSecondaryFontScaleFS,
      SettingBoxKey.subtitleSecondaryBgOpacity: subtitleSecondaryBgOpacity,
      SettingBoxKey.subtitleSecondaryStrokeWidth: subtitleSecondaryStrokeWidth,
      SettingBoxKey.subtitleSecondaryFontWeight: subtitleSecondaryFontWeight,
      SettingBoxKey.subtitleSecondarySpacing: subtitleSecondarySpacing,
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

  // ──────────────────────────────────────────────
  // 后台自动只听音频 — 状态机
  // ──────────────────────────────────────────────

  /// 手动听视频/仅播放音频标记，由三点菜单或直播按钮调用
  void markManualOnlyPlayAudio(bool enabled) {
    _interruptAutoAudioRestore();
    if (enabled) {
      _cancelAutoAudioOnlyTimer();
      _autoAudioState = AutoAudioOnlyState.manualAudioOnly;
    } else {
      if (_autoAudioState == AutoAudioOnlyState.manualAudioOnly ||
          _autoAudioState == AutoAudioOnlyState.autoAudioOnly) {
        _autoAudioState = AutoAudioOnlyState.idle;
      }
    }
  }

  /// 设置项变更时调用
  void onAutoAudioOnlySettingChanged() {
    if (!Pref.autoAudioOnlyInBackground || !continuePlayInBackground.value) {
      if (_autoAudioState == AutoAudioOnlyState.arm ||
          _autoAudioState == AutoAudioOnlyState.pipHold) {
        _cancelAutoAudioOnlyTimer();
        _autoAudioState = AutoAudioOnlyState.idle;
      } else if (_autoAudioState == AutoAudioOnlyState.autoAudioOnly) {
        _cancelAutoAudioOnlyTimer();
        unawaited(restoreFromAutoAudioOnly());
      }
    }
  }

  void _cancelAutoAudioOnlyTimer() {
    _autoAudioOnlyTimer?.cancel();
    _autoAudioOnlyTimer = null;
  }

  /// 自动只听准入检查
  bool _canEnterAutoAudioOnly() {
    if (!PlatformUtils.isMobile) return false;
    if (!Pref.autoAudioOnlyInBackground) return false;
    if (!continuePlayInBackground.value) return false;
    if (_videoPlayerController == null) return false;
    if (!playerStatus.isPlaying) return false;
    if (isPipMode) return false;
    if (_autoAudioState == AutoAudioOnlyState.manualAudioOnly) return false;
    if (_autoAudioState == AutoAudioOnlyState.autoAudioOnly) return false;
    if (Get.currentRoute == '/audio') return false;
    // 点播有独立音轨才可切；直播没有音轨限制
    if (!isLive && !_hasIndependentAudioTrack) return false;
    return true;
  }

  bool get _hasIndependentAudioTrack {
    if (dataSource is FileSource) {
      return !(dataSource as FileSource).isMp4;
    }
    return dataSource.audioSource?.isNotEmpty == true;
  }

  /// 后台 10 秒到点，切到只听
  Future<void> applyAutoAudioOnly() async {
    if (!_canEnterAutoAudioOnly()) {
      _autoAudioState = AutoAudioOnlyState.idle;
      return;
    }

    onlyPlayAudio.value = true;

    if (isLive) {
      // 直播：重拉 only_audio=1
      _autoAudioState = AutoAudioOnlyState.autoAudioOnly;
      await onNeedsPlayerInit?.call();
    } else {
      // 点播：vid=no
      try {
        _videoPlayerController?.setProperty(
          'file-local-options/vid',
          'no',
        );
      } catch (_) {
        onlyPlayAudio.value = false;
        _autoAudioState = AutoAudioOnlyState.idle;
        return;
      }
      _audioReopened = false;
      _autoAudioState = AutoAudioOnlyState.autoAudioOnly;
    }
  }

  /// 回到前台，恢复画面
  Future<void> restoreFromAutoAudioOnly() async {
    if (_autoAudioState != AutoAudioOnlyState.autoAudioOnly) return;
    if (_autoAudioRestoreInProgress) return;

    _cancelAutoAudioOnlyTimer();
    _autoAudioRestoreInProgress = true;
    final restoreGeneration = ++_autoAudioRestoreGeneration;
    suppressBufferingIndicator.value = !isLive && !_audioReopened;

    try {
      // 直播，以及自动只听期间已经重开过纯音频 Media 的点播，
      // 都没有可供 vid=auto 复用的视频输入，直接走页面级恢复。
      if (isLive || _audioReopened) {
        await _fullRestore();
        return;
      }

      final player = _videoPlayerController;
      if (player == null || player.current.isEmpty) {
        await _fullRestore();
        return;
      }

      onlyPlayAudio.value = false;

      // 第一层：在当前 EDL Media 上重新选择视频轨，不重开 Media。
      try {
        player.setProperty('file-local-options/vid', 'auto');
      } catch (_) {
        await _fullRestore();
        return;
      }
      applyVideoPictureParameters();

      final restoredByTrackSwitch = await _waitForVideoOutput(
        restoreGeneration,
        checkCurrentState: false,
      );
      if (!_isAutoAudioRestoreCurrent(restoreGeneration)) {
        return;
      }

      if (restoredByTrackSwitch) {
        _completeAutoAudioRestore();
        return;
      }

      if (!_canUseAutoAudioRestoreFallback(player)) {
        _completeAutoAudioRestore();
        return;
      }

      // 第二层：当前 EDL 仍可复用时，只重开这一个 Media。
      if (await _reopenCurrentMedia(restoreGeneration)) {
        _completeAutoAudioRestore();
        return;
      }

      if (_isAutoAudioRestoreCurrent(restoreGeneration) &&
          _canUseAutoAudioRestoreFallback(player)) {
        // 第三层：当前 Media 也无法恢复时，交给页面重新初始化资源。
        await _fullRestore();
      } else if (_isAutoAudioRestoreCurrent(restoreGeneration)) {
        _completeAutoAudioRestore();
      }
    } finally {
      if (restoreGeneration == _autoAudioRestoreGeneration) {
        _autoAudioRestoreInProgress = false;
        suppressBufferingIndicator.value = false;
      }
    }
  }

  /// 等待当前 Media 恢复真实视频输出。
  Future<bool> _waitForVideoOutput(
    int restoreGeneration, {
    bool checkCurrentState = true,
  }) {
    final player = _videoPlayerController;
    if (player == null) return Future.value(false);
    if (checkCurrentState && _hasVideoOutput(player)) {
      return Future.value(true);
    }

    final completer = _autoAudioRestoreCompleter = Completer<bool>();
    final subscription = player.stream.videoParams.listen((_) {
      if (!_isAutoAudioRestoreCurrent(restoreGeneration)) {
        _finishAutoAudioRestoreWait(false);
      } else if (_hasVideoOutput(player)) {
        _finishAutoAudioRestoreWait(true);
      }
    });
    _autoAudioRestoreSubscription = subscription;
    _autoAudioRestoreTimer = Timer(
      const Duration(seconds: 4),
      () => _finishAutoAudioRestoreWait(false),
    );
    return completer.future;
  }

  bool _hasVideoOutput(Player player) {
    final state = player.state;
    if (state.track.video.id == 'no') return false;
    final params = state.videoParams;
    final width = params.dw ?? params.w ?? 0;
    final height = params.dh ?? params.h ?? 0;
    return width > 0 && height > 0;
  }

  bool _canUseAutoAudioRestoreFallback(Player player) =>
      playerStatus.isPlaying || player.state.buffering;

  bool _isAutoAudioRestoreCurrent(int restoreGeneration) =>
      restoreGeneration == _autoAudioRestoreGeneration &&
      _autoAudioState == AutoAudioOnlyState.autoAudioOnly &&
      _lastAppLifecycleState != AppLifecycleState.hidden &&
      _lastAppLifecycleState != AppLifecycleState.paused &&
      _lastAppLifecycleState != AppLifecycleState.detached &&
      !isPipMode;

  void _completeAutoAudioRestore() {
    _autoAudioState = AutoAudioOnlyState.idle;
    _audioReopened = false;
  }

  void _finishAutoAudioRestoreWait(bool result) {
    final completer = _autoAudioRestoreCompleter;
    if (completer == null || completer.isCompleted) return;
    _autoAudioRestoreTimer?.cancel();
    _autoAudioRestoreTimer = null;
    unawaited(_autoAudioRestoreSubscription?.cancel());
    _autoAudioRestoreSubscription = null;
    _autoAudioRestoreCompleter = null;
    completer.complete(result);
  }

  void _interruptAutoAudioRestore() {
    if (!_autoAudioRestoreInProgress &&
        _autoAudioRestoreCompleter == null) {
      return;
    }
    _autoAudioRestoreGeneration++;
    _autoAudioRestoreInProgress = false;
    suppressBufferingIndicator.value = false;
    _finishAutoAudioRestoreWait(false);
  }

  /// 第二层：重开当前 Media，避免立即进入页面级 playerInit 的加载状态。
  Future<bool> _reopenCurrentMedia(int restoreGeneration) async {
    final player = _videoPlayerController;
    if (player == null || player.current.isEmpty) return false;
    if (!_isAutoAudioRestoreCurrent(restoreGeneration)) return false;

    try {
      final shouldResumePlayback = player.state.playing;
      await player.open(
        player.current.last.copyWith(start: player.state.position),
        play: shouldResumePlayback,
      );
      applyVideoPictureParameters(player);
    } catch (_) {
      return false;
    }

    if (!_isAutoAudioRestoreCurrent(restoreGeneration)) return false;
    return _waitForVideoOutput(restoreGeneration);
  }

  /// 第三层：点播 playerInit，直播 queryLiveUrl。
  Future<void> _fullRestore() async {
    suppressBufferingIndicator.value = false;
    onlyPlayAudio.value = false;
    _completeAutoAudioRestore();
    await onNeedsPlayerInit?.call();
  }

  /// 生命周期变化 — 由 view 转发
  void handleAutoAudioOnlyLifecycle(AppLifecycleState state) {
    _lastAppLifecycleState = state;

    switch (state) {
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _cancelAutoAudioOnlyTimer();
        if (_autoAudioRestoreInProgress) {
          _interruptAutoAudioRestore();
        }
        // 已在只听/手动听视频时，保持状态不退出
        if (_autoAudioState == AutoAudioOnlyState.autoAudioOnly ||
            _autoAudioState == AutoAudioOnlyState.manualAudioOnly) {
          break;
        }
        if (isPipMode) {
          _autoAudioState = AutoAudioOnlyState.pipHold;
        } else if (_canEnterAutoAudioOnly()) {
          _autoAudioOnlyTimer = Timer(
            const Duration(seconds: 10),
            applyAutoAudioOnly,
          );
          _autoAudioState = AutoAudioOnlyState.arm;
        }
        break;
      case AppLifecycleState.resumed:
        _cancelAutoAudioOnlyTimer();
        if (_autoAudioState == AutoAudioOnlyState.autoAudioOnly) {
          if (!_autoAudioRestoreInProgress) {
            unawaited(restoreFromAutoAudioOnly());
          }
        } else if (_autoAudioState == AutoAudioOnlyState.arm ||
            _autoAudioState == AutoAudioOnlyState.pipHold) {
          _autoAudioState = AutoAudioOnlyState.idle;
        }
        // manualAudioOnly / pipHold / arm / idle：保持状态不重置
        break;
      case AppLifecycleState.inactive:
        // 过渡状态，忽略
        break;
      case AppLifecycleState.detached:
        _cancelAutoAudioOnlyTimer();
        _interruptAutoAudioRestore();
        break;
    }
  }

  /// 系统 PiP 变化时由 onPipChanged 调用
  void handleAutoAudioOnlyPipChanged(bool isInPip) {
    if (isInPip) {
      _cancelAutoAudioOnlyTimer();
      if (_autoAudioRestoreInProgress) {
        _interruptAutoAudioRestore();
      }
      if (_autoAudioState == AutoAudioOnlyState.arm) {
        _autoAudioState = AutoAudioOnlyState.pipHold;
      }
    } else {
      // PiP 关闭
      _cancelAutoAudioOnlyTimer();
      if (_lastAppLifecycleState == AppLifecycleState.resumed) {
        if (_autoAudioState == AutoAudioOnlyState.autoAudioOnly) {
          unawaited(restoreFromAutoAudioOnly());
        } else if (_autoAudioState == AutoAudioOnlyState.arm ||
            _autoAudioState == AutoAudioOnlyState.pipHold) {
          _autoAudioState = AutoAudioOnlyState.idle;
        }
        // manualAudioOnly 保持不动
      } else {
        // 仍在后台：仅当不在只听/手动听时重新 arm
        if (_autoAudioState == AutoAudioOnlyState.autoAudioOnly ||
            _autoAudioState == AutoAudioOnlyState.manualAudioOnly) {
          return;
        }
        _autoAudioState = AutoAudioOnlyState.arm;
        _autoAudioOnlyTimer = Timer(
          const Duration(seconds: 10),
          applyAutoAudioOnly,
        );
      }
    }
  }

  void dispose() {
    _cancelAutoAudioOnlyTimer();
    _interruptAutoAudioRestore();
    _autoAudioState = AutoAudioOnlyState.idle;
    _audioReopened = false;
    _lastAppLifecycleState = null;
    // 每次减1，最后销毁
    resetScreenRotation();
    cancelLongPressTimer();
    _cancelSpeedLockHintTimer();
    speedLocked = false;
    _speedLockArmed = false;
    speedLockHint.value = SpeedLockHint.none;
    _cancelSubForSeek();
    if (!_isCloseAll && _playerCount > 1) {
      _playerCount -= 1;
      _heartDuration = 0;
      return;
    }

    _playerCount = 0;
    if (removeSafeArea) {
      showSystemBar();
    }
    danmakuController = null;
    danmakuMaskPath.value = null;
    _stopOrientationListener();
    _disableAutoEnterPip();
    setPlayCallBack(null);
    dmState.clear();
    hideDesktopProgressPreview();
    if (showSeekPreview) {
      _clearPreview();
    }
    if (Platform.isAndroid) {
      AndroidHelper$ToDart.onUserLeaveHint?.release();
      AndroidHelper$ToDart.onUserLeaveHint = null;
    }
    _timer?.cancel();
    persistVideoPictureSettings();
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
    _stopWakeLockTimer();
    WakelockPlus.disable();
    if (kDebugMode) {
      debugPrint('dispose player');
    }
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _videoController = null;
    _activeVideoContextKey = null;
    danmakuMaskPath.dispose();
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
    // 关掉后台播放时，停止自动只听状态机
    if (!continuePlayInBackground.value) {
      onAutoAudioOnlySettingChanged();
    }
  }

  late final Map<String, ui.Image?> previewCache = {};
  LoadingState<VideoShotData>? videoShot;
  late final RxBool showPreview = false.obs;
  late final showSeekPreview = Pref.showSeekPreview;
  late final previewIndex = RxnInt();
  final RxBool showDesktopProgressFeedback = false.obs;
  final Rx<double?> desktopProgressHoverValue = Rx<double?>(null);
  final Rx<double?> desktopProgressPreviewValue = Rx<double?>(null);
  final RxInt progressPreviewSeconds = 0.obs;
  final RxInt desktopProgressPreviewLayoutVersion = 0.obs;
  bool _desktopProgressPointerInside = false;
  bool requireDesktopProgressHoverReenter = false;

  bool get _canUseSeekPreview =>
      !isFileSource && showSeekPreview && cid != null;

  void refreshDesktopProgressPreviewLayout() {
    desktopProgressPreviewLayoutVersion.value++;
  }

  double _progressValueFromDuration(Duration value) {
    if (durationInMilliseconds <= 0) {
      return 0.0;
    }
    return (value.inMilliseconds / durationInMilliseconds).clamp(0.0, 1.0);
  }

  void _setDesktopProgressPreviewState(Duration value) {
    final progressValue = _progressValueFromDuration(value);
    progressPreviewSeconds.value = value.inSeconds;
    desktopProgressHoverValue.value = progressValue;
    desktopProgressPreviewValue.value = progressValue;
  }

  void updateDesktopProgressPreviewFromDrag(Duration value) {
    if (!PlatformUtils.isDesktop) {
      return;
    }
    _setDesktopProgressPreviewState(value);
    showDesktopProgressFeedback.value = true;
    if (!isFileSource && showSeekPreview) {
      updatePreviewIndex(value.inSeconds);
    }
  }

  void onDesktopProgressDragStart(Duration value) {
    _desktopProgressPointerInside = true;
    requireDesktopProgressHoverReenter = false;
    updateDesktopProgressPreviewFromDrag(value);
  }

  void onDesktopProgressHoverStart(Duration value) {
    _desktopProgressPointerInside = true;
    if (controlsLock.value || isSeeking.value) {
      return;
    }
    if (requireDesktopProgressHoverReenter) {
      return;
    }
    _setDesktopProgressPreviewState(value);
    showDesktopProgressFeedback.value = true;
    if (!isFileSource && showSeekPreview) {
      updatePreviewIndex(value.inSeconds);
    }
  }

  void onDesktopProgressHoverUpdate(Duration value) {
    _desktopProgressPointerInside = true;
    if (controlsLock.value || isSeeking.value) {
      return;
    }
    if (requireDesktopProgressHoverReenter) {
      return;
    }
    _setDesktopProgressPreviewState(value);
    showDesktopProgressFeedback.value = true;
    if (!isFileSource && showSeekPreview) {
      updatePreviewIndex(value.inSeconds);
    }
  }

  void onDesktopProgressHoverEnd() {
    _desktopProgressPointerInside = false;
    requireDesktopProgressHoverReenter = false;
    if (!isSeeking.value) {
      hideDesktopProgressPreview();
    }
  }

  void hideDesktopProgressPreview() {
    showDesktopProgressFeedback.value = false;
    desktopProgressHoverValue.value = null;
    desktopProgressPreviewValue.value = null;
    if (showSeekPreview) {
      showPreview.value = false;
    }
  }

  void _setPreviewIndexFromShot(int seconds) {
    final shot = videoShot;
    if (shot case Success(:final response)) {
      previewIndex.value = max(
        0,
        (response.index.where((item) => item <= seconds).length - 2),
      );
    }
  }

  Future<void> ensureVideoShot() async {
    if (!_canUseSeekPreview) {
      return;
    }
    if (videoShot is Loading) {
      return;
    }
    if (videoShot case Success()) {
      return;
    }

    final requestBvid = bvid;
    final requestCid = cid!;
    videoShot = LoadingState.loading();
    final response = await VideoHttp.videoshot(
      bvid: requestBvid,
      cid: requestCid,
    );
    if (requestBvid != _bvid || requestCid != cid) {
      return;
    }

    videoShot = response;
    if (!showPreview.value) {
      return;
    }
    if (response case Success()) {
      _setPreviewIndexFromShot(progressPreviewSeconds.value);
    } else {
      showPreview.value = false;
      previewIndex.value = null;
    }
  }

  void updatePreviewIndex(int seconds) {
    if (!_canUseSeekPreview) {
      return;
    }
    showPreview.value = true;
    if (videoShot == null) {
      previewIndex.value = null;
      unawaited(ensureVideoShot());
      return;
    }
    if (videoShot is Loading) {
      previewIndex.value = null;
      return;
    }
    if (videoShot case Success()) {
      _setPreviewIndexFromShot(seconds);
    } else {
      showPreview.value = false;
      previewIndex.value = null;
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

  Future<void> takeScreenshot() async {
    SmartDialog.showToast('截图中');
    try {
      final screenshot = await videoPlayerController?.screenshot();
      final bytes = await ImageUtils.uiImageToPngBytes(
        screenshot,
        dispose: true,
      );
      if (bytes != null) {
        final time = DurationUtils.formatDuration(
          positionInMilliseconds / 1000,
        ).replaceAll(':', '-');
        SmartDialog.showToast('点击弹窗保存截图');
        showDialog(
          context: Get.context!,
          builder: (context) => GestureDetector(
            onTap: () {
              Get.back();
              ImageUtils.saveByteImg(
                bytes: bytes,
                fileName: 'screenshot_${cid}_$time',
              );
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
                      child: Image.memory(bytes),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        SmartDialog.showToast('截图失败');
      }
    } catch (e) {
      debugPrint(e.toString());
      SmartDialog.showToast('截图失败');
    }
  }

  void onPopInvokedWithResult(
    bool didPop,
    Object? result, {
    bool pauseOnPop = true,
  }) {
    if (didPop) {
      if (pauseOnPop && playerStatus.isPlaying) {
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
