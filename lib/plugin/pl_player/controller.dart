import 'dart:async' show StreamSubscription, Timer;
import 'dart:convert' show ascii;
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
import 'package:PiliPlus/pages/sponsor_block/block_mixin.dart';
import 'package:PiliPlus/plugin/pl_player/models/android_hdr_playback_backend.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/double_tap_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/duration.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/heart_beat_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/playback_backend.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/asset_utils.dart';
import 'package:PiliPlus/utils/device_utils.dart';
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
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:archive/archive.dart' show getCrc32;
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:floating/floating.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback, DeviceOrientation;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:path/path.dart' as path;
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';

typedef PlayCallback = Future<void>? Function();

class PlPlayerController with BlockConfigMixin {
  Player? _videoPlayerController;
  VideoController? _videoController;
  AndroidHdrPlaybackBackend? _androidHdrBackend;
  StreamSubscription<PlaybackBackendEvent>? _backendSubscription;

  // 添加一个私有静态变量来保存实例
  static PlPlayerController? _instance;

  // 流事件  监听播放状态变化
  // StreamSubscription? _playerEventSubs;

  /// [playerStatus] has a [status] observable
  final playerStatus = PlPlayerStatus(PlayerStatus.playing);

  ///
  final Rx<DataStatus> dataStatus = Rx(DataStatus.none);

  // bool controlsEnabled = false;

  /// 响应数据
  /// 带有Seconds的变量只在秒数更新时更新，以避免频繁触发重绘
  // 播放位置
  Duration position = Duration.zero;
  final RxInt positionSeconds = 0.obs;

  /// 进度条位置
  Duration sliderPosition = Duration.zero;
  final RxInt sliderPositionSeconds = 0.obs;
  // 展示使用
  final Rx<Duration> sliderTempPosition = Rx(Duration.zero);

  /// 视频时长
  final Rx<Duration> duration = Rx(Duration.zero);

  /// 视频缓冲
  final Rx<Duration> buffered = Rx(Duration.zero);
  final RxInt bufferedSeconds = 0.obs;

  int _playerCount = 0;

  late double lastPlaybackSpeed = 1.0;
  final RxDouble _playbackSpeed = Pref.playSpeedDefault.obs;
  late final RxDouble _longPressSpeed = Pref.longPressSpeedDefault.obs;

  /// 音量控制条
  final RxDouble volume = RxDouble(
    PlatformUtils.isDesktop ? Pref.desktopVolume : 1.0,
  );
  final setSystemBrightness = Pref.setSystemBrightness;

  /// 亮度控制条
  final RxDouble brightness = (-1.0).obs;

  /// 是否展示控制条
  final RxBool showControls = false.obs;

  /// 亮度控制条展示/隐藏
  final RxBool showBrightnessStatus = false.obs;

  /// 是否长按倍速
  final RxBool longPressStatus = false.obs;

  /// 屏幕锁 为true时，关闭控制栏
  final RxBool controlsLock = false.obs;

  /// 全屏状态
  final RxBool isFullScreen = false.obs;
  // 默认投稿视频格式
  bool isLive = false;

  bool _isVertical = false;

  /// 视频比例
  final Rx<VideoFitType> videoFit = Rx(VideoFitType.contain);

  /// 后台播放
  late final RxBool continuePlayInBackground =
      Pref.continuePlayInBackground.obs;

  ///
  final RxBool isSliderMoving = false.obs;

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
  StreamSubscription<Duration>? _subForSeek;

  Box setting = GStorage.setting;

  // final Durations durations;

  String get bvid => _bvid!;

  /// 视频播放速度
  double get playbackSpeed => _playbackSpeed.value;

  // 长按倍速
  double get longPressSpeed => _longPressSpeed.value;

  /// [videoPlayerController] instance of Player
  Player? get videoPlayerController => _videoPlayerController;

  /// [videoController] instance of Player
  VideoController? get videoController => _videoController;

  AndroidHdrPlaybackBackend? get androidHdrBackend => _androidHdrBackend;

  bool get isAndroidHdrBackend => _androidHdrBackend != null;

  bool get hasVideoView =>
      _videoController != null || _androidHdrBackend != null;

  bool isMuted = false;

  /// 听视频
  late final RxBool onlyPlayAudio = false.obs;

  /// 镜像
  late final RxBool flipX = false.obs;

  late final RxBool flipY = false.obs;

  final RxBool isBuffering = true.obs;

  /// 全屏方向
  bool get isVertical => _isVertical;

  /// 弹幕开关
  late final RxBool _enableShowDanmaku = Pref.enableShowDanmaku.obs;
  late final RxBool _enableShowLiveDanmaku = Pref.enableShowLiveDanmaku.obs;
  RxBool get enableShowDanmaku =>
      isLive ? _enableShowLiveDanmaku : _enableShowDanmaku;

  late final bool autoPiP = Pref.autoPiP;
  bool get isPipMode =>
      (Platform.isAndroid && Floating().isPipMode) ||
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
    final state = _androidHdrBackend?.state;
    int width = state?.width ?? videoPlayerController?.state.width ?? 0;
    int height = state?.height ?? videoPlayerController?.state.height ?? 0;
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

  late bool _shouldSetPip = false;

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

  void enterPip({bool isAuto = false}) {
    if (hasVideoView) {
      controls = false;
      final state = _androidHdrBackend?.state;
      final stateWidth =
          state?.width ?? videoPlayerController?.state.width ?? 0;
      final stateHeight =
          state?.height ?? videoPlayerController?.state.height ?? 0;
      PageUtils.enterPip(
        isAuto: isAuto,
        width: stateWidth == 0 ? width : stateWidth,
        height: stateHeight == 0 ? height : stateHeight,
      );
    }
  }

  void _disableAutoEnterPip() {
    if (_shouldSetPip) {
      Utils.channel.invokeMethod('setPipAutoEnterEnabled', {
        'autoEnable': false,
      });
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

  num get sliderScale =>
      isRelative ? duration.value.inMilliseconds * offset : offset;

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

  late final Rx<SubtitleViewConfiguration> subtitleConfig = getSubConfig.obs;
  final RxString currentSubtitleText = ''.obs;
  List<_SubtitleCue> _subtitleCues = const [];

  SubtitleViewConfiguration get getSubConfig {
    final subTitleStyle = this.subTitleStyle;
    return SubtitleViewConfiguration(
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

  void setExternalSubtitleData(String? data) {
    if (data == null || data.isEmpty) {
      _subtitleCues = const [];
      currentSubtitleText.value = '';
      return;
    }
    _subtitleCues = _SubtitleCue.parse(data);
    _updateExternalSubtitle(position);
  }

  void _updateExternalSubtitle(Duration position) {
    if (_subtitleCues.isEmpty) {
      if (currentSubtitleText.value.isNotEmpty) {
        currentSubtitleText.value = '';
      }
      return;
    }
    final text = _subtitleCues
        .where((cue) => cue.start <= position && position < cue.end)
        .map((cue) => cue.text)
        .where((text) => text.isNotEmpty)
        .join('\n');
    if (text != currentSubtitleText.value) {
      currentSubtitleText.value = text;
    }
  }

  void onUpdatePadding(EdgeInsets padding) {
    subtitlePaddingB = padding.bottom.round().clamp(0, 200);
    putSubtitleSettings();
  }

  void updateSliderPositionSecond() {
    int newSecond = sliderPosition.inSeconds;
    if (sliderPositionSeconds.value != newSecond) {
      sliderPositionSeconds.value = newSecond;
    }
  }

  void updatePositionSecond() {
    int newSecond = position.inSeconds;
    if (positionSeconds.value != newSecond) {
      positionSeconds.value = newSecond;
    }
  }

  void updateBufferedSecond() {
    int newSecond = buffered.value.inSeconds;
    if (bufferedSeconds.value != newSecond) {
      bufferedSeconds.value = newSecond;
    }
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
    // await _instance?.play(repeat: repeat, hideControls: hideControls);
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
    if (!visible) return;
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
            useSensor: Platform.isAndroid,
            checkIsAutoRotate: checkIsAutoRotate,
          )
          .listen(_onOrientationChanged);
    }

    if (!Accounts.heartbeat.isLogin || Pref.historyPause) {
      enableHeart = false;
    }

    if (Platform.isAndroid && autoPiP) {
      if (DeviceUtils.sdkInt < 36) {
        Utils.channel.setMethodCallHandler((call) async {
          if (call.method == 'onUserLeaveHint') {
            if (playerStatus.isPlaying && _isCurrVideoPage) {
              enterPip();
            }
          }
        });
      } else {
        _shouldSetPip = true;
      }
    }
  }

  // 获取实例 传参
  static PlPlayerController getInstance({bool isLive = false}) {
    // 如果实例尚未创建，则创建一个新实例
    return (_instance ??= PlPlayerController._())
      ..isLive = isLive
      .._playerCount += 1;
  }

  bool _processing = false;
  bool get processing => _processing;

  // offline
  bool get isFileSource => dataSource is FileSource;

  late final _audioNormalization = Pref.audioNormalization;
  late final enableAudioNormalization =
      Platform.isAndroid && _audioNormalization != '0';
  late final String _audioNormalizationParam =
      AudioNormalization.getParamFromConfig(_audioNormalization);

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
      _processing = true;
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

      if (showSeekPreview) {
        _clearPreview();
      }
      cancelLongPressTimer();
      if (playerStatus.isPlaying) {
        await pause(notify: false);
      }

      if (_playerCount == 0) {
        return;
      }
      await _createPlaybackBackend(dataSource, seekTo, volume, duration);

      if (_playerCount == 0) {
        _removeListeners();
        _videoPlayerController?.dispose();
        await _disposeAndroidHdrBackend();
        _videoPlayerController = null;
        _videoController = null;
        return;
      }

      // 获取视频时长 00:00
      this.duration.value =
          duration ??
          _androidHdrBackend?.state.duration ??
          _videoPlayerController?.state.duration ??
          Duration.zero;
      position = buffered.value = sliderPosition = seekTo ?? Duration.zero;
      updatePositionSecond();
      updateSliderPositionSecond();
      updateBufferedSecond();
      // 数据加载完成
      dataStatus.value = DataStatus.loaded;

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
    if (type != SuperResolutionType.disable && isAndroidHdrBackend) {
      await switchToMediaKitBackend(
        reason: 'SuperResolution is not compatible with HDR: not implemented',
      );
    }
    if (_videoPlayerController == null) return;
    pp ??= _videoPlayerController;
    if (pp == null) return;
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

  static final loudnormRegExp = RegExp('loudnorm=([^,]+)');

  static const Set<int> _hdrQualityCodes = {
    125,
    126,
    129,
  };

  int? get _currentQualityCode {
    return dataSource.qualityCode ?? cacheVideoQa;
  }

  bool get _isHdrQuality {
    final quality = _currentQualityCode;
    return quality != null && _hdrQualityCodes.contains(quality);
  }

  bool get _requiresMpvOnlyFeature =>
      flipX.value ||
      flipY.value ||
      onlyPlayAudio.value ||
      superResolutionType.value != SuperResolutionType.disable;

  Future<bool> _shouldUseAndroidHdrBackend() async {
    final enabled = Pref.androidHdrPlayback;
    final android = Platform.isAndroid;
    final hdrQuality = _isHdrQuality;
    final requiresMpv = _requiresMpvOnlyFeature;
    if (!enabled || !android || isLive || !hdrQuality || requiresMpv) {
      return false;
    }
    final supportsHdr = await AndroidHdrPlaybackBackend.supportsHdr(
      qualityCode: _currentQualityCode,
    );
    return supportsHdr;
  }

  Future<void> _createPlaybackBackend(
    DataSource dataSource,
    Duration? seekTo,
    Volume? volume,
    Duration? duration,
  ) async {
    if (await _shouldUseAndroidHdrBackend()) {
      try {
        await _createAndroidHdrBackend(dataSource, seekTo, duration);
        return;
      } catch (err, stackTrace) {
        if (kDebugMode) {
          debugPrint('Android HDR backend failed: $err\n$stackTrace');
        }
        await _disposeAndroidHdrBackend();
        SmartDialog.showToast('已使用兼容播放');
      }
    }
    await _createVideoController(dataSource, seekTo, volume);
  }

  Future<void> _createAndroidHdrBackend(
    DataSource dataSource,
    Duration? seekTo,
    Duration? duration,
  ) async {
    await _disposeMediaKitPlayer();
    await _disposeAndroidHdrBackend();
    isBuffering.value = false;
    buffered.value = Duration.zero;
    _heartDuration = 0;
    position = Duration.zero;
    danmakuController?.clear();

    final backend = AndroidHdrPlaybackBackend();
    _androidHdrBackend = backend;
    _startBackendListeners(backend);
    await backend.open(
      dataSource,
      start: seekTo,
      duration: duration,
      headers: const {
        'User-Agent': BrowserUa.pc,
        'Referer': HttpString.baseUrl,
      },
      fit: videoFit.value,
    );
  }

  Future<void> switchToMediaKitBackend({String? reason}) async {
    if (!isAndroidHdrBackend || _processing || _playerCount == 0) {
      return;
    }
    final wasPlaying = playerStatus.isPlaying;
    final seekTo = position;
    await _disposeAndroidHdrBackend();
    await _createVideoController(dataSource, seekTo, null);
    await _initializePlayer();
    if (!wasPlaying) {
      await pause(notify: false);
    }
    if (reason != null) {
      SmartDialog.showToast(reason);
    }
  }

  Future<void> setFlipX(bool value) async {
    flipX.value = value;
    if (value) {
      await switchToMediaKitBackend(reason: '已切换兼容播放以启用镜像');
    }
  }

  Future<void> setFlipY(bool value) async {
    flipY.value = value;
    if (value) {
      await switchToMediaKitBackend(reason: '已切换兼容播放以启用镜像');
    }
  }

  Future<Player> _initPlayer() async {
    assert(_videoPlayerController == null);
    await _disposeAndroidHdrBackend();
    final opt = {
      'video-sync': Pref.videoSync,
    };
    if (Platform.isAndroid) {
      opt['volume-max'] = '100';
      opt['ao'] = Pref.audioOutput;
    } else if (PlatformUtils.isDesktop) {
      opt['volume'] = (volume.value * 100).toString();
    }
    final autosync = Pref.autosync;
    if (autosync != '0') {
      opt['autosync'] = autosync;
    }

    final player = await Player.create(
      configuration: PlayerConfiguration(
        bufferSize: Pref.expandBuffer
            ? (isLive ? 64 * 1024 * 1024 : 32 * 1024 * 1024)
            : (isLive ? 16 * 1024 * 1024 : 4 * 1024 * 1024),
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

    player.setMediaHeader(
      userAgent: BrowserUa.pc,
      referer: HttpString.baseUrl,
    );
    // await player.setAudioTrack(.auto());

    _startListeners(player);

    return player;
  }

  // 配置播放器
  Future<void> _createVideoController(
    DataSource dataSource,
    Duration? seekTo,
    Volume? volume,
  ) async {
    isBuffering.value = false;
    buffered.value = Duration.zero;
    _heartDuration = 0;
    position = Duration.zero;
    // 初始化时清空弹幕，防止上次重叠
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

    final Map<String, String> extras = {};

    String video = dataSource.videoSource;
    if (dataSource.audioSource case final audio? when (audio.isNotEmpty)) {
      if (onlyPlayAudio.value) {
        video = audio;
      } else {
        extras['audio-files'] =
            '"${Platform.isWindows ? audio.replaceAll(';', r'\;') : audio.replaceAll(':', r'\:')}"';
      }
      if (enableAudioNormalization) {
        final String audioNormalization;
        if (volume != null && volume.isNotEmpty) {
          audioNormalization = _audioNormalizationParam.replaceFirstMapped(
            loudnormRegExp,
            (i) =>
                'loudnorm=${volume.format(
                  Map.fromEntries(
                    i.group(1)!.split(':').map((item) {
                      final parts = item.split('=');
                      return MapEntry(parts[0].toLowerCase(), num.parse(parts[1]));
                    }),
                  ),
                )}',
          );
        } else {
          audioNormalization = _audioNormalizationParam.replaceFirst(
            loudnormRegExp,
            AudioNormalization.getParamFromConfig(Pref.fallbackNormalization),
          );
        }
        if (audioNormalization.isNotEmpty) {
          extras['lavfi-complex'] = '"[aid1] $audioNormalization [ao]"';
        }
      }
    }

    await player.open(
      Media(
        video,
        start: seekTo,
        extras: extras.isEmpty ? null : extras,
      ),
      play: false,
    );
  }

  Future<void>? refreshPlayer() {
    if (dataSource is FileSource) {
      return null;
    }
    if (_videoPlayerController?.current.isNotEmpty ?? false) {
      return _videoPlayerController!.open(
        _videoPlayerController!.current.last.copyWith(start: position),
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
      if (_videoPlayerController?.state.rate != _playbackSpeed.value) {
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
  final Set<ValueChanged<Duration>> _positionListeners = {};
  final Set<ValueChanged<PlayerStatus>> _statusListeners = {};

  /// 播放事件监听
  void _startListeners(NativePlayer player) {
    assert(_subscriptions == null);
    final stream = player.stream;
    _subscriptions = [
      stream.playing.listen((event) {
        WakelockPlus.toggle(enable: event);
        if (event) {
          if (_shouldSetPip) {
            if (_isCurrVideoPage) {
              enterPip(isAuto: true);
            } else {
              _disableAutoEnterPip();
            }
          }
          playerStatus.value = PlayerStatus.playing;
        } else {
          _disableAutoEnterPip();
          playerStatus.value = PlayerStatus.paused;
        }
        videoPlayerServiceHandler?.onStatusChange(
          playerStatus.value,
          isBuffering.value,
          isLive,
        );

        /// 触发回调事件
        for (final element in _statusListeners) {
          element(event ? PlayerStatus.playing : PlayerStatus.paused);
        }
        if (player.state.position.inSeconds != 0) {
          makeHeartBeat(positionSeconds.value, type: HeartBeatType.status);
        }
      }),
      stream.completed.listen((event) {
        if (event) {
          playerStatus.value = PlayerStatus.completed;

          /// 触发回调事件
          for (final element in _statusListeners) {
            element(PlayerStatus.completed);
          }
        } else {
          // playerStatus.value = PlayerStatus.playing;
        }
        makeHeartBeat(positionSeconds.value, type: HeartBeatType.completed);
      }),
      stream.position.listen((event) {
        position = event;
        _updateExternalSubtitle(event);
        updatePositionSecond();
        if (!isSliderMoving.value) {
          sliderPosition = event;
          updateSliderPositionSecond();
        }

        /// 触发回调事件
        for (final element in _positionListeners) {
          element(event);
        }
        makeHeartBeat(event.inSeconds);
      }),
      stream.duration.listen((Duration event) {
        duration.value = event;
      }),
      stream.buffer.listen((Duration event) {
        buffered.value = event;
        updateBufferedSecond();
      }),
      stream.buffering.listen((bool event) {
        isBuffering.value = event;
        videoPlayerServiceHandler?.onStatusChange(
          playerStatus.value,
          event,
          isLive,
        );
      }),
      if (kDebugMode)
        stream.log.listen(((PlayerLog log) {
          if (log.level == 'error' || log.level == 'fatal') {
            Utils.reportError('${log.level}: ${log.prefix}: ${log.text}', null);
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
                if (isBuffering.value && buffered.value == Duration.zero) {
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
          Utils.reportError(event);
          // SmartDialog.showToast('视频加载错误, $event');
        }
      }),
      // controllerStream.volume.listen((event) {
      //   if (!mute.value && _volumeBeforeMute != event) {
      //     _volumeBeforeMute = event / 100;
      //   }
      // }),
      // 媒体通知监听
      if (videoPlayerServiceHandler != null) ...[
        playerStatus.listen((PlayerStatus event) {
          videoPlayerServiceHandler!.onStatusChange(
            event,
            isBuffering.value,
            isLive,
          );
        }),
        positionSeconds.listen((int event) {
          videoPlayerServiceHandler!.onPositionChange(Duration(seconds: event));
        }),
      ],
    ];
  }

  /// 移除事件监听
  void _removeListeners() {
    _subscriptions?.forEach((e) => e.cancel());
    _subscriptions?.clear();
    _subscriptions = null;
    _backendSubscription?.cancel();
    _backendSubscription = null;
  }

  void _startBackendListeners(AndroidHdrPlaybackBackend backend) {
    _backendSubscription?.cancel();
    _backendSubscription = backend.events.listen((event) {
      if (event.ready) {
        dataStatus.value = DataStatus.loaded;
        isBuffering.value = false;
      }
      if (event.status case final status?) {
        dataStatus.value = DataStatus.loaded;
        if (status == PlayerStatus.playing || status == PlayerStatus.paused) {
          isBuffering.value = false;
        }
        if (status == PlayerStatus.playing) {
          WakelockPlus.enable();
          if (_shouldSetPip) {
            if (_isCurrVideoPage) {
              enterPip(isAuto: true);
            } else {
              _disableAutoEnterPip();
            }
          }
        } else {
          _disableAutoEnterPip();
          if (status != PlayerStatus.completed) {
            WakelockPlus.disable();
          }
        }
        playerStatus.value = status;
        videoPlayerServiceHandler?.onStatusChange(
          status,
          isBuffering.value,
          isLive,
        );
        for (final element in _statusListeners) {
          element(status);
        }
        if (status == PlayerStatus.completed) {
          makeHeartBeat(positionSeconds.value, type: HeartBeatType.completed);
        } else if (positionSeconds.value != 0) {
          makeHeartBeat(positionSeconds.value, type: HeartBeatType.status);
        }
      }
      if (event.position case final eventPosition?) {
        dataStatus.value = DataStatus.loaded;
        isBuffering.value = false;
        position = eventPosition;
        _updateExternalSubtitle(eventPosition);
        updatePositionSecond();
        if (!isSliderMoving.value) {
          sliderPosition = eventPosition;
          updateSliderPositionSecond();
        }
        for (final element in _positionListeners) {
          element(eventPosition);
        }
        makeHeartBeat(eventPosition.inSeconds);
      }
      if (event.duration case final eventDuration?
          when eventDuration != Duration.zero) {
        duration.value = eventDuration;
      }
      if (event.buffered case final eventBuffered?) {
        buffered.value = eventBuffered;
        updateBufferedSecond();
      }
      if (event.buffering case final eventBuffering?) {
        isBuffering.value = eventBuffering;
        videoPlayerServiceHandler?.onStatusChange(
          playerStatus.value,
          eventBuffering,
          isLive,
        );
      }
      if (event.width case final eventWidth? when eventWidth > 0) {
        width = eventWidth;
      }
      if (event.height case final eventHeight? when eventHeight > 0) {
        height = eventHeight;
      }
      if (event.error case final message?) {
        _handleBackendError(message);
      }
    });
  }

  void _handleBackendError(String event) {
    if (!isAndroidHdrBackend) return;
    Future.microtask(() async {
      final seekTo = position;
      await _disposeAndroidHdrBackend();
      SmartDialog.showToast('已使用兼容播放');
      await _createVideoController(dataSource, seekTo, null);
      await _initializePlayer();
    });
  }

  Future<void> _disposeMediaKitPlayer() async {
    _removeListeners();
    await _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _videoController = null;
  }

  Future<void> _disposeAndroidHdrBackend() async {
    _backendSubscription?.cancel();
    _backendSubscription = null;
    final backend = _androidHdrBackend;
    _androidHdrBackend = null;
    await backend?.dispose();
  }

  void _cancelSubForSeek() {
    if (_subForSeek != null) {
      _subForSeek!.cancel();
      _subForSeek = null;
    }
  }

  /// 跳转至指定位置
  Future<void> seekTo(Duration position, {bool isSeek = true}) async {
    // if (position >= duration.value) {
    //   position = duration.value - const Duration(milliseconds: 100);
    // }
    if (_playerCount == 0) {
      return;
    }
    if (position < Duration.zero) {
      position = Duration.zero;
    }
    this.position = position;
    updatePositionSecond();
    _heartDuration = position.inSeconds;

    Future<void> seek() async {
      if (isSeek) {
        /// 拖动进度条调节时，不等待第一帧，防止抖动
        if (_videoPlayerController != null) {
          await _videoPlayerController?.stream.buffer.first;
        }
      }
      danmakuController?.clear();
      try {
        if (_androidHdrBackend case final backend?) {
          await backend.seek(position);
        } else {
          await _videoPlayerController?.seek(position);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('seek failed: $e');
      }
    }

    if (duration.value != Duration.zero) {
      seek();
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
        (_androidHdrBackend?.state.rate ??
            _videoPlayerController?.state.rate)) {
      return;
    }

    await (_androidHdrBackend?.setPlaybackSpeed(speed) ??
        _videoPlayerController?.setRate(speed));
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
    await (_androidHdrBackend?.setPlaybackSpeed(playSpeedDefault) ??
        _videoPlayerController?.setRate(playSpeedDefault));
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

    await (_androidHdrBackend?.play() ?? _videoPlayerController?.play());

    audioSessionHandler?.setActive(true);

    playerStatus.value = PlayerStatus.playing;
    // screenManager.setOverlays(false);
  }

  /// 暂停播放
  Future<void> pause({bool notify = true, bool isInterrupt = false}) async {
    await (_androidHdrBackend?.pause() ?? _videoPlayerController?.pause());
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
      if (!isSliderMoving.value && !tripling) {
        controls = false;
      }
      _timer = null;
    });
  }

  /// 调整播放时间
  void onChangedSlider(int v) {
    sliderPosition = Duration(seconds: v);
    updateSliderPositionSecond();
  }

  void onChangedSliderStart([Duration? value]) {
    if (value != null) {
      sliderTempPosition.value = value;
    }
    isSliderMoving.value = true;
  }

  bool? cancelSeek;
  bool? hasToast;

  void onUpdatedSliderProgress(Duration value) {
    sliderTempPosition.value = value;
    sliderPosition = value;
    updateSliderPositionSecond();
  }

  void onChangedSliderEnd() {
    if (cancelSeek != true) {
      feedBack();
    }
    cancelSeek = null;
    hasToast = null;
    isSliderMoving.value = false;
    hideTaskControls();
  }

  final RxBool volumeIndicator = false.obs;
  Timer? volumeTimer;
  bool volumeInterceptEventStream = false;

  static final double maxVolume = PlatformUtils.isDesktop ? 2.0 : 1.0;
  Future<void> setVolume(double volume, {bool showIndicator = true}) async {
    if (this.volume.value != volume) {
      this.volume.value = volume;
      try {
        if (PlatformUtils.isDesktop) {
          _videoPlayerController?.setVolume(volume * 100);
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
    _androidHdrBackend?.setFit(value);
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

  bool get _isCompleted =>
      (_androidHdrBackend?.state.completed ??
          videoPlayerController?.state.completed ??
          false) ||
      (duration.value - position).inMilliseconds <= 50;

  // 双击播放、暂停
  Future<void> onDoubleTapCenter() async {
    if (!isLive && _isCompleted) {
      await seekTo(Duration.zero, isSeek: false);
      await play();
    } else {
      if (playerStatus.isPlaying) {
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
    onForwardBackward(position + duration);
  }

  void onBackward(Duration duration) {
    onForwardBackward(position - duration);
  }

  void onForwardBackward(Duration duration) {
    seekTo(
      duration.clamp(Duration.zero, this.duration.value),
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
            (duration.value - position).inMilliseconds <= 1000) {
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
    dispose();
    Get.until((route) => route.isFirst);
  }

  void dispose() {
    // 每次减1，最后销毁
    resetScreenRotation();
    cancelLongPressTimer();
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
    _stopOrientationListener();
    _disableAutoEnterPip();
    setPlayCallBack(null);
    dmState.clear();
    if (showSeekPreview) {
      _clearPreview();
    }
    Utils.channel.setMethodCallHandler(null);
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
    if (playerStatus.isPlaying) {
      WakelockPlus.disable();
    }
    if (kDebugMode) {
      debugPrint('dispose player');
    }
    _videoPlayerController?.dispose();
    _androidHdrBackend?.dispose();
    _videoPlayerController = null;
    _videoController = null;
    _androidHdrBackend = null;
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
    continuePlayInBackground.value = !continuePlayInBackground.value;
    if (!tempPlayerConf) {
      setting.put(
        SettingBoxKey.continuePlayInBackground,
        continuePlayInBackground.value,
      );
    }
  }

  Future<void> setOnlyPlayAudio() async {
    onlyPlayAudio.value = !onlyPlayAudio.value;
    if (onlyPlayAudio.value && isAndroidHdrBackend) {
      await switchToMediaKitBackend(reason: '已切换兼容播放以启用听视频');
      return;
    }
    await videoPlayerController?.setVideoTrack(
      onlyPlayAudio.value ? VideoTrack.no() : VideoTrack.auto(),
    );
  }

  Future<void> setSubtitleTrack(SubtitleTrack track) async {
    if (track.id == 'no') {
      setExternalSubtitleData(null);
    }
    await videoPlayerController?.setSubtitleTrack(track);
  }

  Future<void> setMuted(bool muted) async {
    isMuted = muted;
    await _videoPlayerController?.setVolume(
      muted ? 0 : volume.value * 100,
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

  void takeScreenshot() {
    SmartDialog.showToast('截图中');
    final screenshotFuture = _androidHdrBackend != null
        ? _androidHdrBackend!.screenshot()
        : videoPlayerController?.screenshot(format: ScreenshotFormat.png);
    screenshotFuture?.then((value) {
      if (value != null) {
        SmartDialog.showToast('点击弹窗保存截图');
        showDialog(
          context: Get.context!,
          builder: (context) => GestureDetector(
            onTap: () {
              Get.back();
              ImageUtils.saveByteImg(
                bytes: value,
                fileName: 'screenshot_${ImageUtils.time}',
              );
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: min(DeviceUtils.size.width / 3, 350),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 5,
                        color: ThemeUtils.theme.colorScheme.surface,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image.memory(value),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        SmartDialog.showToast(
          isAndroidHdrBackend ? 'HDR 原生播放截图失败，请切换兼容播放' : '截图失败',
        );
      }
    });
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

final class _SubtitleCue {
  const _SubtitleCue(this.start, this.end, this.text);

  final Duration start;
  final Duration end;
  final String text;

  static List<_SubtitleCue> parse(String data) {
    final text = data.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    if (text.contains('[Events]') || text.contains('Dialogue:')) {
      return _parseAss(text);
    }
    if (text.contains('-->')) {
      return _parseVttOrSrt(text);
    }
    return const [];
  }

  static List<_SubtitleCue> _parseVttOrSrt(String data) {
    final cues = <_SubtitleCue>[];
    final blocks = data.split(RegExp(r'\n{2,}'));
    for (final block in blocks) {
      final lines = block
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty && line != 'WEBVTT')
          .toList();
      if (lines.isEmpty) continue;
      final timeIndex = lines.indexWhere((line) => line.contains('-->'));
      if (timeIndex == -1) continue;
      final parts = lines[timeIndex].split('-->');
      if (parts.length < 2) continue;
      final start = _parseTime(parts[0].trim());
      final end = _parseTime(parts[1].trim().split(RegExp(r'\s+')).first);
      if (start == null || end == null || end <= start) continue;
      final cueText = lines.skip(timeIndex + 1).map(_cleanText).join('\n');
      cues.add(_SubtitleCue(start, end, cueText));
    }
    return cues;
  }

  static List<_SubtitleCue> _parseAss(String data) {
    final cues = <_SubtitleCue>[];
    for (final line in data.split('\n')) {
      if (!line.startsWith('Dialogue:')) continue;
      final body = line.substring('Dialogue:'.length).trimLeft();
      final fields = body.split(',');
      if (fields.length < 10) continue;
      final start = _parseTime(fields[1].trim());
      final end = _parseTime(fields[2].trim());
      if (start == null || end == null || end <= start) continue;
      final cueText = _cleanText(fields.skip(9).join(','));
      cues.add(_SubtitleCue(start, end, cueText));
    }
    return cues;
  }

  static Duration? _parseTime(String input) {
    final time = input.trim().replaceAll(',', '.');
    final match = RegExp(
      r'(?:(\d+):)?(\d{1,2}):(\d{2})(?:\.(\d{1,3}))?',
    ).firstMatch(time);
    if (match == null) return null;
    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;
    final millisText = (match.group(4) ?? '').padRight(3, '0');
    final millis =
        int.tryParse(
          millisText.length > 3 ? millisText.substring(0, 3) : millisText,
        ) ??
        0;
    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: millis,
    );
  }

  static String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'\{[^}]*\}'), '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(r'\N', '\n')
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\h', ' ')
        .trim();
  }
}
