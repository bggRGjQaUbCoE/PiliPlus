import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/cropped_image.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/disabled_icon.dart';
import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/common/widgets/gesture/immediate_tap_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/gesture/mouse_interactive_viewer.dart';
import 'package:PiliPlus/common/widgets/gesture/player_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/player_bar.dart';
import 'package:PiliPlus/common/widgets/progress_bar/audio_video_progress_bar.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart' as ugc;
import 'package:PiliPlus/models_new/video/video_detail/ugc_season.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/danmaku/danmaku_model.dart';
import 'package:PiliPlus/pages/danmaku/mask/clip_driver.dart';
import 'package:PiliPlus/pages/danmaku/mask/geometry.dart';
import 'package:PiliPlus/pages/live_room/widgets/bottom_control.dart'
    as live_bottom;
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/post_panel/popup_menu_text.dart';
import 'package:PiliPlus/pages/video/post_panel/view.dart';
import 'package:PiliPlus/pages/video/widgets/header_control.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_control_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/double_tap_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/gesture_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/speed_lock_hint.dart';
import 'package:PiliPlus/plugin/pl_player/models/two_finger_tap_detector.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/app_bar_ani.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/backward_seek.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/bottom_control.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/common_btn.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/forward_seek.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/mpv_convert_webp.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/play_pause_btn.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/speed_lock_arrows.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/mobile_observer.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart'
    show RenderProxyBox, SemanticsConfiguration;
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';
import 'package:window_manager/window_manager.dart';

part 'widgets.dart';

class PLVideoPlayer extends StatefulWidget {
  const PLVideoPlayer({
    required this.maxWidth,
    required this.maxHeight,
    required this.plPlayerController,
    this.videoDetailController,
    this.introController,
    required this.headerControl,
    this.bottomControl,
    this.danmuWidget,
    this.showEpisodes,
    this.showViewPoints,
    this.isPipMode = false,
    this.isInAppPip = false,
    this.fill = Colors.black,
    this.alignment = Alignment.center,
    super.key,
  });

  final double maxWidth;
  final double maxHeight;
  final PlPlayerController plPlayerController;
  final VideoDetailController? videoDetailController;
  final CommonIntroController? introController;
  final Widget headerControl;
  final Widget? bottomControl;
  final Widget? danmuWidget;
  final void Function([
    int?,
    UgcSeason?,
    List<ugc.BaseEpisodeItem>?,
    String?,
    int?,
    int?,
  ])?
  showEpisodes;
  final VoidCallback? showViewPoints;
  final bool isPipMode;

  /// 应用内小窗（我们独有的浮窗，非系统 PiP）。
  /// 窗口过小时不渲染字幕，避免（尤其是双语）字幕挤占画面。
  final bool isInAppPip;
  final Color fill;
  final Alignment alignment;

  @override
  State<PLVideoPlayer> createState() => _PLVideoPlayerState();
}

class _PLVideoPlayerState extends State<PLVideoPlayer>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late AnimationController _animationController;
  late VideoController videoController;
  late final CommonIntroController introController = widget.introController!;
  late final VideoDetailController videoDetailController =
      widget.videoDetailController!;

  final _playerKey = GlobalKey();
  final _videoKey = GlobalKey();

  /// 弹幕层相对播放器 Stack 的下沿偏移；Positioned.fill(top:) 与遮挡区几何共用，不要各写一份
  static const double _kDanmakuTopInset = 4;

  DanmakuMaskClipDriver? _maskDriver;
  final List<StreamSubscription<dynamic>> _maskSubscriptions = [];
  double _devicePixelRatio = 1;

  final RxDouble _brightnessValue = 0.0.obs;
  final RxBool _brightnessIndicator = false.obs;
  Timer? _brightnessTimer;

  late FullScreenMode mode;

  late final RxBool showRestoreScaleBtn = false.obs;

  GestureType? _gestureType;
  final TwoFingerTapDetector _twoFingerTapDetector = TwoFingerTapDetector();
  DateTime? _ignoreTapUpBefore;
  Offset? _initialFocalPoint;

  bool _pauseDueToPauseUponEnteringBackgroundMode = false;

  StreamSubscription? _brightnessListener;
  void _onBrightnessChanged(double value) {
    if (mounted && _gestureType != .left) {
      _brightnessValue.value = value;
    }
  }

  void _getSystemBrightness() {
    ScreenBrightnessPlatform.instance.system.then((res) {
      if (mounted) {
        _brightnessValue.value = res;
      }
    });
  }

  void _getAppBrightness() {
    ScreenBrightnessPlatform.instance.application.then((res) {
      if (mounted) {
        _brightnessValue.value = res;
      }
    });
  }

  void _onVolumeChanged(double value) {
    if (mounted && !plPlayerController.volumeInterceptEventStream) {
      plPlayerController.volume.value = value;
      if (Platform.isIOS && !FlutterVolumeController.showSystemUI) {
        plPlayerController
          ..volumeIndicator.value = true
          ..volumeTimer?.cancel()
          ..volumeTimer = Timer(
            const Duration(milliseconds: 800),
            () {
              if (mounted) {
                plPlayerController.volumeIndicator.value = false;
              }
            },
          );
      }
    }
  }

  void _getCurrVolume() {
    FlutterVolumeController.getVolume().then((res) {
      if (mounted) {
        plPlayerController.volume.value = res!;
      }
    });
  }

  int? tmpSubtitlePaddingB;
  StreamSubscription? _controlsListener;
  void _onControlChanged(bool val) {
    final visible = val && !plPlayerController.controlsLock.value;
    if (!visible && PlatformUtils.isDesktop) {
      plPlayerController.hideDesktopProgressPreview();
    }

    if ((widget.headerControl.key as GlobalKey<TimeBatteryMixin>).currentState
        case final state?) {
      if (state.mounted) {
        state.provider
          ?..startIfNeeded()
          ..muted = !visible;
        if (visible) {
          state
            ..updateBatteryInfoIfNeeded()
            ..startClock();
        } else {
          state
            ..stopBatteryInfoListener()
            ..stopClock();
        }
      }
    }

    if (visible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    if (widget.videoDetailController case final controller?) {
      if (controller.vttSubtitlesIndex.value != 0) {
        if (visible) {
          const int minPadding = 70;
          if (plPlayerController.subtitlePaddingB < minPadding) {
            tmpSubtitlePaddingB = plPlayerController.subtitlePaddingB;
            plPlayerController
              ..subtitlePaddingB = minPadding
              ..subtitleConfig.value = plPlayerController.getSubConfig;
          }
        } else {
          if (tmpSubtitlePaddingB != null) {
            plPlayerController
              ..subtitlePaddingB = tmpSubtitlePaddingB!
              ..subtitleConfig.value = plPlayerController.getSubConfig;
            tmpSubtitlePaddingB = null;
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    addObserverMobile(this);

    _controlsListener = plPlayerController.showControls.listen(
      _onControlChanged,
    );

    _transformationController = TransformationController()
      ..addListener(_onTransformChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    // 挂载前 showControls 可能已被置真（如小窗恢复路径在页面 initState 先行
    // controls = true，播放器随 videoState 延后挂载）——Rx.listen 只收变更
    // 事件，不同步初值的话控制栏要等下一次 showControls 变更才会入场。
    // 延迟到首帧后执行，让 headerControl 的时间/电量状态也能被正确启动。
    if (plPlayerController.showControls.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && plPlayerController.showControls.value) {
          _onControlChanged(true);
        }
      });
    }
    videoController = plPlayerController.videoController!;
    _initDanmakuMask();

    if (PlatformUtils.isMobile) {
      Future.microtask(() async {
        try {
          if (Pref.enableAppVolume) {
            // 应用内音量模式：显示系统原生 HUD，不显示应用内指示器
            FlutterVolumeController.updateShowSystemUI(true);
            // 只保存系统音量，不改变播放器音量和显示指示器
            plPlayerController.systemVolume.value =
                (await FlutterVolumeController.getVolume())!;
            FlutterVolumeController.addListener(
              (double value) {
                if (mounted && !plPlayerController.volumeInterceptEventStream) {
                  // 只更新系统音量记录，不影响播放器音量和指示器显示
                  plPlayerController.systemVolume.value = value;
                }
              },
              category: AudioSessionCategory.playback,
              emitOnStart: false,
            );
          } else {
            FlutterVolumeController.updateShowSystemUI(true);
            _getCurrVolume();
            FlutterVolumeController.addListener(
              _onVolumeChanged,
              category: AudioSessionCategory.playback,
              emitOnStart: false,
            );
          }
        } catch (_) {}

        try {
          if (Platform.isIOS || plPlayerController.setSystemBrightness) {
            _getSystemBrightness();
            _brightnessListener = ScreenBrightnessPlatform
                .instance
                .onSystemScreenBrightnessChanged
                .listen(_onBrightnessChanged);
          } else {
            _getAppBrightness();
            _brightnessListener = ScreenBrightnessPlatform
                .instance
                .onApplicationScreenBrightnessChanged
                .listen(_onBrightnessChanged);
          }
        } catch (_) {}
      });
    }

    if (plPlayerController.enableTapDm) {
      _tapGestureRecognizer = ImmediateTapGestureRecognizer(
        onTapDown: plPlayerController.enableShowDanmaku.value
            ? _onTapDown
            : null,
        onTapUp: _onTapUp,
        onTapCancel: _removeDmAction,
      );

      _danmakuListener = plPlayerController.enableShowDanmaku.listen((value) {
        if (!value) _removeDmAction();
        _tapGestureRecognizer.onTapDown = value ? _onTapDown : null;
      });
    } else {
      _tapGestureRecognizer = ImmediateTapGestureRecognizer(onTapUp: _onTapUp);
    }

    _doubleTapGestureRecognizer = DoubleTapGestureRecognizer()
      ..onDoubleTapDown = _onDoubleTapDown;

    _scaleGestureRecognizer = PlayerScaleGestureRecognizer(
      debugOwner: this,
      dragStartBehavior: .start,
      allowedButtonsFilter: (buttons) => buttons == kPrimaryButton,
      trackpadScrollToScaleFactor: const Offset(
        0,
        -1 / kDefaultMouseScrollToScaleFactor,
      ),
      trackpadScrollCausesScale: false,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!plPlayerController.continuePlayInBackground.value) {
      late final player = plPlayerController.videoPlayerController;
      if (const <AppLifecycleState>[.paused, .detached].contains(state)) {
        if (player != null && player.state.playing) {
          _pauseDueToPauseUponEnteringBackgroundMode = true;
          player.pause();
        }
      } else {
        if (_pauseDueToPauseUponEnteringBackgroundMode) {
          _pauseDueToPauseUponEnteringBackgroundMode = false;
          player?.play();
        }
      }
      // 后台播放关了，本功能不运行，转发生命周期以取消定时器
      plPlayerController.handleAutoAudioOnlyLifecycle(state);
      return;
    }
    plPlayerController.handleAutoAudioOnlyLifecycle(state);
  }

  Future<void> setBrightness(double value) async {
    _brightnessValue.value = value;
    try {
      if (Platform.isIOS || plPlayerController.setSystemBrightness) {
        await ScreenBrightnessPlatform.instance.setSystemScreenBrightness(
          value,
        );
      } else {
        await ScreenBrightnessPlatform.instance.setApplicationScreenBrightness(
          value,
        );
      }
    } catch (_) {}
    _brightnessIndicator.value = true;
    _brightnessTimer?.cancel();
    _brightnessTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _brightnessIndicator.value = false;
      }
    });
    plPlayerController.brightness.value = value;
  }

  @override
  void dispose() {
    removeObserverMobile(this);
    _danmakuListener?.cancel();
    _tapGestureRecognizer.dispose();
    _longPressRecognizer?.dispose();
    _doubleTapGestureRecognizer.dispose();
    _scaleGestureRecognizer.dispose();
    _brightnessListener?.cancel();
    _controlsListener?.cancel();
    _animationController.dispose();
    _disposeDanmakuMask();
    _transformationController
      ..removeListener(_onTransformChanged)
      ..dispose();
    _removeDmAction();
    if (PlatformUtils.isMobile) {
      FlutterVolumeController.removeListener();
    }
    super.dispose();
  }

  // 动态构建底部控制条
  Widget buildBottomControl(
    VideoDetailController videoDetailController,
    bool isLandscape,
  ) {
    final videoDetail = introController.videoDetail.value;
    final isSeason = videoDetail.ugcSeason != null;
    final isPart = videoDetail.pages != null && videoDetail.pages!.length > 1;
    final isPgc = !videoDetailController.isUgc;
    final isPlayAll = videoDetailController.isPlayAll;
    final anySeason = isSeason || isPart || isPgc || isPlayAll;
    final isFullScreen = this.isFullScreen;
    final double widgetWidth = isLandscape && isFullScreen ? 42 : 35;

    Widget progressWidget(
      BottomControlType bottomControl,
    ) => switch (bottomControl) {
      /// 播放暂停
      BottomControlType.playOrPause => PlayOrPauseButton(
        plPlayerController: plPlayerController,
      ),

      /// 上一集
      BottomControlType.pre => ComBtn(
        width: widgetWidth,
        height: 30,
        tooltip: '上一集',
        icon: const Icon(
          Icons.skip_previous,
          size: 22,
          color: Colors.white,
        ),
        onTap: () {
          if (!introController.prevPlay(manual: true)) {
            SmartDialog.showToast('已经是第一集了');
          }
        },
      ),

      /// 下一集
      BottomControlType.next => ComBtn(
        width: widgetWidth,
        height: 30,
        tooltip: '下一集',
        icon: const Icon(
          Icons.skip_next,
          size: 22,
          color: Colors.white,
        ),
        onTap: () {
          if (!introController.nextPlay(manual: true)) {
            SmartDialog.showToast('已经是最后一集了');
          }
        },
      ),

      /// 时间进度
      BottomControlType.time => Obx(
        () => _VideoTime(
          position: DurationUtils.formatDuration(
            plPlayerController.position.value,
          ),
          duration: DurationUtils.formatDuration(
            plPlayerController.duration.value,
          ),
        ),
      ),

      /// 高能进度条
      BottomControlType.dmChart => Obx(
        () {
          final list = videoDetailController.dmTrend.value?.dataOrNull;
          if (list != null && list.isNotEmpty) {
            final show = videoDetailController.showDmTrendChart.value;
            return ComBtn(
              width: widgetWidth,
              height: 30,
              tooltip: '高能进度条',
              icon: DisabledIcon(
                disable: !show,
                child: const Icon(
                  Icons.show_chart,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              onTap: () => videoDetailController.showDmTrendChart.value = !show,
            );
          }
          return const SizedBox.shrink();
        },
      ),

      /// 超分辨率
      BottomControlType.superResolution => Obx(
        () {
          final type = plPlayerController.superResolutionType.value;
          return StaticPopupMenuButton<SuperResolutionType>(
            tooltip: '超分辨率',
            requestFocus: false,
            initialValue: type,
            color: Colors.black.withValues(alpha: 0.8),
            menuPadding: EdgeInsets.zero,
            menuItemOuterPadding: EdgeInsets.zero,
            menuItemStateLayerColor: Colors.white,
            itemBuilder: (context) {
              return SuperResolutionType.values
                  .map(
                    (type) => PopupMenuItem<SuperResolutionType>(
                      height: 35,
                      padding: const EdgeInsets.only(left: 30),
                      value: type,
                      onTap: () => plPlayerController.setShader(type),
                      child: Text(
                        type.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                  .toList();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                type.label,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          );
        },
      ),

      /// 分段信息
      BottomControlType.viewPoints => Obx(
        () {
          if (videoDetailController.viewPointList.isNotEmpty) {
            final viewPoints = videoDetailController.viewPointList;
            final positionSec = plPlayerController.position.value;
            // Find current segment
            String? currentTitle;
            for (final seg in viewPoints) {
              if (seg.from != null &&
                  seg.to != null &&
                  positionSec >= seg.from! &&
                  positionSec < seg.to!) {
                currentTitle = seg.title;
                break;
              }
            }
            if (currentTitle != null && currentTitle.isNotEmpty) {
              final maxW = isLandscape && isFullScreen ? 160.0 : 135.0;

              // Use TextPainter to manually truncate the string to ensure the Text widget
              // tight-wraps the text, avoiding the layout padding caused by TextOverflow.ellipsis
              const textStyle = TextStyle(
                color: Colors.white,
                fontSize: 12,
              );
              String displayTitle = currentTitle;
              // Padding(6x2) + gap(4) + chevron(~10) = 26
              final maxTextW = maxW - 26.0;

              final tp = TextPainter(
                text: TextSpan(text: displayTitle, style: textStyle),
                textDirection: ui.TextDirection.ltr,
                maxLines: 1,
              )..layout(maxWidth: maxTextW);

              if (tp.didExceedMaxLines) {
                // '...' is roughly 14px wide
                final pos = tp.getPositionForOffset(Offset(maxTextW - 14.0, 0));
                if (pos.offset > 0 && pos.offset < displayTitle.length) {
                  displayTitle = '${displayTitle.substring(0, pos.offset)}...';
                }
              }

              return GestureDetector(
                onTap: widget.showViewPoints,
                behavior: HitTestBehavior.opaque,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            displayTitle,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: textStyle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '>',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            // Fallback: show icon if no segment matched
            return ComBtn(
              width: widgetWidth,
              height: 30,
              tooltip: '分段信息',
              icon: DisabledIcon(
                disable: !videoDetailController.showVP.value,
                child: const Icon(
                  CustomIcons.view_headline_rotate_90,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              onTap: widget.showViewPoints,
            );
          }
          return const SizedBox.shrink();
        },
      ),

      /// 选集
      BottomControlType.episode => ComBtn(
        width: widgetWidth,
        height: 30,
        tooltip: '选集',
        icon: const Icon(
          Icons.list,
          size: 22,
          color: Colors.white,
        ),
        onTap: () {
          if (videoDetailController.isFileSource) {
            // TODO
            return;
          }
          // part -> playAll -> season(pgc)
          if (isPlayAll && !isPart) {
            widget.showEpisodes?.call();
            return;
          }
          int? index;
          int currentCid = plPlayerController.cid!;
          String bvid = plPlayerController.bvid;
          List<ugc.BaseEpisodeItem> episodes = [];
          if (isSeason) {
            final sections = videoDetail.ugcSeason!.sections!;
            for (int i = 0; i < sections.length; i++) {
              final episodesList = sections[i].episodes!;
              for (final item in episodesList) {
                if (item.cid == currentCid) {
                  index = i;
                  episodes = episodesList;
                  break;
                }
              }
            }
          } else if (isPart) {
            episodes = videoDetail.pages!;
          } else if (isPgc) {
            episodes =
                (introController as PgcIntroController).pgcItem.episodes!;
          }
          widget.showEpisodes?.call(
            index,
            isSeason ? videoDetail.ugcSeason! : null,
            isSeason ? null : episodes,
            bvid,
            IdUtils.bv2av(bvid),
            isSeason && isPart
                ? videoDetailController.seasonCid ?? currentCid
                : currentCid,
          );
        },
      ),

      /// 画面比例
      BottomControlType.fit => Obx(
        () {
          final fit = plPlayerController.videoFit.value;
          return StaticPopupMenuButton<VideoFitType>(
            tooltip: '画面比例',
            requestFocus: false,
            initialValue: fit,
            color: Colors.black.withValues(alpha: 0.8),
            menuPadding: EdgeInsets.zero,
            menuItemOuterPadding: EdgeInsets.zero,
            menuItemStateLayerColor: Colors.white,
            itemBuilder: (context) {
              return VideoFitType.values
                  .map(
                    (boxFit) => PopupMenuItem<VideoFitType>(
                      height: 35,
                      padding: const EdgeInsets.only(left: 30),
                      value: boxFit,
                      onTap: () => plPlayerController.toggleVideoFit(boxFit),
                      child: Text(
                        boxFit.desc,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                  .toList();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                fit.desc,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          );
        },
      ),

      BottomControlType.aiTranslate => Obx(
        () {
          final list = videoDetailController.languages.value;
          if (list != null && list.isNotEmpty) {
            return StaticPopupMenuButton<String>(
              tooltip: '翻译',
              requestFocus: false,
              initialValue: videoDetailController.currLang.value,
              onSelected: videoDetailController.setLanguage,
              color: Colors.black.withValues(alpha: 0.8),
              menuPadding: EdgeInsets.zero,
              menuItemOuterPadding: EdgeInsets.zero,
              menuItemStateLayerColor: Colors.white,
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  height: 35,
                  value: '',
                  child: Text(
                    "关闭翻译",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                ...list.map(
                  (e) => PopupMenuItem<String>(
                    height: 35,
                    value: e.lang,
                    child: Text(
                      e.title!,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
              ],
              child: SizedBox(
                width: widgetWidth,
                height: 30,
                child: const Icon(
                  Icons.translate,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),

      /// 字幕
      BottomControlType.subtitle => Obx(
        () {
          if (videoDetailController.subtitles.isNotEmpty) {
            final val = videoDetailController.vttSubtitlesIndex.value;
            return StaticPopupMenuButton<int>(
              tooltip: '字幕',
              requestFocus: false,
              initialValue: val,
              color: Colors.black.withValues(alpha: 0.8),
              menuPadding: EdgeInsets.zero,
              menuItemOuterPadding: EdgeInsets.zero,
              menuItemStateLayerColor: Colors.white,
              itemBuilder: (context) {
                // 只有一条字幕时退回旧版单列菜单
                // 两条以上才用主/副双栏面板
                if (videoDetailController.subtitles.length < 2) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      height: 35,
                      onTap: () => videoDetailController.setSubtitle(0),
                      child: const Text(
                        "关闭字幕",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    ...videoDetailController.subtitles.mapIndexed((i, e) {
                      return PopupMenuItem<int>(
                        value: i + 1,
                        height: 35,
                        onTap: () => videoDetailController.setSubtitle(i + 1),
                        child: Text(
                          e.lanDoc ?? e.lan,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const .new(color: Colors.white, fontSize: 13),
                        ),
                      );
                    }),
                  ];
                }
                return [
                  // 主/副字幕双栏选择面板,点击不关闭菜单,可连续设置
                  PopupMenuItem<int>(
                    enabled: false,
                    padding: EdgeInsets.zero,
                    child: _SubtitleSelectPanel(
                      controller: videoDetailController,
                    ),
                  ),
                ];
              },
              child: SizedBox(
                width: widgetWidth,
                height: 30,
                child: val == 0
                    ? const Icon(
                        Icons.closed_caption_off_outlined,
                        size: 22,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.closed_caption_off_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),

      /// 播放速度
      BottomControlType.speed => Obx(
        () => StaticPopupMenuButton<double>(
          tooltip: '倍速',
          requestFocus: false,
          initialValue: plPlayerController.playbackSpeed,
          color: Colors.black.withValues(alpha: 0.8),
          menuPadding: EdgeInsets.zero,
          menuItemOuterPadding: EdgeInsets.zero,
          menuItemStateLayerColor: Colors.white,
          itemBuilder: (context) {
            return plPlayerController.speedList
                .map(
                  (double speed) => PopupMenuItem<double>(
                    height: 35,
                    padding: const EdgeInsets.only(left: 30),
                    value: speed,
                    onTap: () =>
                        plPlayerController.setManualPlaybackSpeed(speed),
                    child: Text(
                      "${speed}X",
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      semanticsLabel: "$speed倍速",
                    ),
                  ),
                )
                .toList();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "${plPlayerController.playbackSpeed}X",
              style: const TextStyle(color: Colors.white, fontSize: 13),
              semanticsLabel: "${plPlayerController.playbackSpeed}倍速",
            ),
          ),
        ),
      ),

      BottomControlType.qa => Obx(
        () {
          final VideoQuality? currentVideoQa =
              videoDetailController.currentVideoQa.value;
          if (currentVideoQa == null) {
            return const SizedBox.shrink();
          }
          final PlayUrlModel videoInfo = videoDetailController.data;
          if (videoInfo.dash == null) {
            return const SizedBox.shrink();
          }
          final videoFormat = videoInfo.supportFormats!;
          final availableQa = videoInfo.dash!.video!.availableVideoQualities;
          return StaticPopupMenuButton<int>(
            tooltip: '画质',
            requestFocus: false,
            initialValue: currentVideoQa.code,
            color: Colors.black.withValues(alpha: 0.8),
            menuPadding: EdgeInsets.zero,
            menuItemOuterPadding: EdgeInsets.zero,
            menuItemStateLayerColor: Colors.white,
            itemBuilder: (context) {
              return List.generate(
                videoFormat.length,
                (index) {
                  final item = videoFormat[index];
                  final enabled = availableQa.contains(item.quality);
                  return PopupMenuItem<int>(
                    enabled: enabled,
                    height: 35,
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    value: item.quality,
                    onTap: () {
                      if (currentVideoQa.code == item.quality) {
                        return;
                      }
                      final int quality = item.quality!;
                      final newQa = VideoQuality.fromCode(quality);
                      videoDetailController
                        ..plPlayerController.cacheVideoQa = newQa.code
                        ..currentVideoQa.value = newQa
                        ..updatePlayer();

                      SmartDialog.showToast("画质已变为：${newQa.desc}");

                      // update
                      videoDetailController.persistVideoQa(quality);
                    },
                    child: Text(
                      item.newDesc ?? '',
                      style: enabled
                          ? const TextStyle(color: Colors.white, fontSize: 13)
                          : const TextStyle(
                              color: Color(0x62FFFFFF),
                              fontSize: 13,
                            ),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                currentVideoQa.shortDesc,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          );
        },
      ),

      /// 全屏
      BottomControlType.fullscreen => ComBtn(
        width: widgetWidth,
        height: 30,
        tooltip: isFullScreen ? '退出全屏' : '全屏',
        icon: isFullScreen
            ? const Icon(Icons.fullscreen_exit, size: 24, color: Colors.white)
            : const Icon(Icons.fullscreen, size: 24, color: Colors.white),
        onTap: () =>
            plPlayerController.triggerFullScreen(status: !isFullScreen),
        onSecondaryTap: () => plPlayerController.triggerFullScreen(
          status: !isFullScreen,
          inAppFullScreen: true,
        ),
      ),
    };

    final isNotFileSource = !plPlayerController.isFileSource;

    List<BottomControlType> userSpecifyItemLeft = [
      .playOrPause,
      .time,
      if (!isNotFileSource || anySeason) ...[.pre, .next],
    ];

    final flag =
        isFullScreen || plPlayerController.isDesktopPip || maxWidth >= 500;
    final List<BottomControlType> userSpecifyItemRight = [
      if (plPlayerController.showViewPoints) .viewPoints,
      if (isNotFileSource && plPlayerController.showDmChart) .dmChart,
      if (plPlayerController.isAnim) .superResolution,
      if (isNotFileSource && anySeason) .episode,
      if (flag) .fit,
      if (isNotFileSource) .aiTranslate,
      .subtitle,
      .speed,
      if (isNotFileSource && flag) .qa,
      if (!plPlayerController.isDesktopPip) .fullscreen,
    ];
    return PlayerBar(
      children: [
        Row(
          mainAxisSize: .min,
          children: userSpecifyItemLeft.map(progressWidget).toList(),
        ),
        Row(
          mainAxisSize: .min,
          children: userSpecifyItemRight.map(progressWidget).toList(),
        ),
      ],
    );
  }

  PlPlayerController get plPlayerController => widget.plPlayerController;

  bool get isFullScreen => plPlayerController.isFullScreen.value;

  late final TransformationController _transformationController;

  late ColorScheme colorScheme;
  late double maxWidth;
  late double maxHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
    _devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    // 首次计算遮挡区的地方（dpr 到这里才可读）
    _maskDriver?.update();
  }

  @override
  void didUpdateWidget(covariant PLVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (Platform.isAndroid && AndroidHelper.isPipMode) {
      plPlayerController.controls = false;
    }
    if (oldWidget.maxWidth != widget.maxWidth ||
        oldWidget.maxHeight != widget.maxHeight ||
        oldWidget.isPipMode != widget.isPipMode ||
        oldWidget.alignment != widget.alignment) {
      // 同步调用即可：它标脏的是子树里的 ValueListenableBuilder，
      // Flutter 允许在祖先 build 期间标脏后代
      _maskDriver?.update();
    }
  }

  void _initDanmakuMask() {
    final maskController =
        widget.videoDetailController?.danmakuMaskController;
    if (maskController == null || plPlayerController.isLive) return;
    final driver = _maskDriver = DanmakuMaskClipDriver(
      frame: maskController.frame,
      output: plPlayerController.danmakuMaskPath,
      readInputs: _readDanmakuMaskInputs,
    );
    maskController.frame.addListener(driver.update);
    _transformationController.addListener(driver.update);
    videoController.rect.addListener(driver.update);
    _maskSubscriptions.addAll([
      plPlayerController.videoFit.listen((_) => driver.update()),
      plPlayerController.flipX.listen((_) => driver.update()),
      plPlayerController.flipY.listen((_) => driver.update()),
    ]);
  }

  void _disposeDanmakuMask() {
    final driver = _maskDriver;
    if (driver == null) return;
    _maskDriver = null;
    widget.videoDetailController?.danmakuMaskController.frame
        .removeListener(driver.update);
    _transformationController.removeListener(driver.update);
    videoController.rect.removeListener(driver.update);
    for (final subscription in _maskSubscriptions) {
      subscription.cancel();
    }
    _maskSubscriptions.clear();
    driver.detach();
  }

  DanmakuMaskInputs? _readDanmakuMaskInputs() {
    if (widget.isPipMode) return null;
    final rect = videoController.rect.value;
    // media_kit 在无画面时给 1×1 的 rect（SimpleVideo 用同一判据盖 fill 色）
    if (rect == null || rect.isEmpty || (rect.width <= 1 && rect.height <= 1)) {
      return null;
    }
    final viewport = Size(widget.maxWidth, widget.maxHeight);
    final videoFit = plPlayerController.videoFit.value;
    // 与 media_kit fork 的 SimpleVideo 盒子尺寸同式：rect/dpr，强制比例时宽 = 高 × 比例
    final height = rect.height / _devicePixelRatio;
    final aspectRatio = videoFit.aspectRatio;
    final videoSize = Size(
      aspectRatio == null ? rect.width / _devicePixelRatio : height * aspectRatio,
      height,
    );
    final fit = DanmakuMaskGeometry.fittedBoxTransform(
      fit: videoFit.boxFit,
      alignment: widget.alignment,
      childSize: videoSize,
      boxSize: viewport,
    );
    if (fit == null) return null;
    final videoToLayer = Matrix4.translationValues(0, -_kDanmakuTopInset, 0)
      ..multiply(_transformationController.value)
      ..multiply(
        DanmakuMaskGeometry.flipTransform(
          flipX: plPlayerController.flipX.value,
          flipY: plPlayerController.flipY.value,
          boxSize: viewport,
        ),
      )
      ..multiply(fit);
    return (videoSize: videoSize, videoToLayer: videoToLayer);
  }

  void _onPanStart(ScaleStartDetails details) {
    _gestureType = null;
    _initialFocalPoint = details.localFocalPoint;
  }

  // 显隐由 _onTransformChanged 统一驱动
  void _onScaleUpdate(double scale) {}

  // 浮点残差，不与 identity 精确比较
  void _onTransformChanged() {
    final matrix = _transformationController.value;
    final translation = matrix.getTranslation();
    showRestoreScaleBtn.value =
        translation.x.abs() > 0.5 ||
        translation.y.abs() > 0.5 ||
        matrix.storage[1].abs() > 1e-3 ||
        (matrix.getMaxScaleOnAxis() - 1).abs() > 1e-3;
  }

  void _onHorizontalDragStart() {
    plPlayerController.onSeekStart(plPlayerController.position.value);
  }

  void _onHorizontalDragUpdate(double dx) {
    final curPos =
        plPlayerController.seekToPos?.inMilliseconds ??
        plPlayerController.seekPosition.value * 1000;
    final posDelta = (plPlayerController.sliderScale * dx / maxWidth).round();
    final newPos = (curPos + posDelta).clamp(
      0,
      plPlayerController.durationInMilliseconds,
    );
    final seconds = newPos ~/ 1000;
    plPlayerController
      ..seekToPos = Duration(milliseconds: newPos)
      ..seekPosition.value = seconds;
    if (!plPlayerController.isFileSource &&
        plPlayerController.showSeekPreview) {
      plPlayerController.updatePreviewIndex(seconds);
    }
  }

  void _onHorizontalDragEnd() {
    if (plPlayerController.seekToPos case final seekToPos?) {
      feedBack();
      plPlayerController
        ..position.value = seekToPos.inSeconds
        ..seekTo(seekToPos, isSeek: false)
        ..seekToPos = null;
    } else {
      plPlayerController.position.value =
          plPlayerController.videoPlayerController?.state.position.inSeconds ??
          0;
    }
    plPlayerController.onSeekEnd();
  }

  void _onPanUpdate(ScaleUpdateDetails details) {
    if (_gestureType == null) {
      final cumulativeDelta = details.localFocalPoint - _initialFocalPoint!;
      if (cumulativeDelta.distanceSquared < 1) return;
      final dx = cumulativeDelta.dx.abs();
      final dy = cumulativeDelta.dy.abs();
      if (dx > 3 * dy) {
        _onHorizontalDragStart();
        _gestureType = .horizontal;
      } else if (dy > 3 * dx) {
        if (!plPlayerController.enableSlideVolumeBrightness &&
            !plPlayerController.enableSlideFS) {
          return;
        }

        final double tapPosition = details.localFocalPoint.dx;
        final double sectionWidth = maxWidth / 3;
        if (tapPosition < sectionWidth) {
          if (!plPlayerController.enableSlideVolumeBrightness) {
            return;
          }
          // 左边区域
          if (PlatformUtils.isDesktop) {
            _gestureType = .right;
          } else {
            _gestureType = .left;
          }
        } else if (tapPosition < sectionWidth * 2) {
          if (!plPlayerController.enableSlideFS) {
            return;
          }
          // 全屏
          _gestureType = .center;
        } else {
          if (!plPlayerController.enableSlideVolumeBrightness) {
            return;
          }
          // 右边区域
          _gestureType = .right;
        }
      }
      return;
    }

    Offset delta = details.focalPointDelta;

    if (_gestureType == .horizontal) {
      // live模式下禁用
      if (plPlayerController.isLive) return;

      final height = maxHeight * 0.125;
      if (details.localFocalPoint.dy <= height &&
          (details.localFocalPoint.dx >= maxWidth * 0.875 ||
              details.localFocalPoint.dx <= maxWidth * 0.125)) {
        if (!plPlayerController.hasToasted) {
          plPlayerController
            ..seekToPos = null
            ..hasToasted = true;
          if (plPlayerController.showSeekPreview) {
            plPlayerController.showPreview.value = false;
          }
          SmartDialog.showAttach(
            targetContext: context,
            alignment: .center,
            usePenetrate: true,
            animationType: .fade,
            maskColor: Colors.transparent,
            displayTime: const Duration(milliseconds: 1500),
            animationTime: const Duration(milliseconds: 200),
            builder: (context) => Container(
              padding: const .symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: const .all(.circular(6)),
                color: colorScheme.secondaryContainer,
              ),
              child: Text(
                '松开手指，取消进退',
                style: TextStyle(color: colorScheme.onSecondaryContainer),
              ),
            ),
          );
        }
        return;
      } else if (plPlayerController.hasToasted) {
        plPlayerController.hasToasted = false;
      }

      _onHorizontalDragUpdate(delta.dx);
    } else if (_gestureType == .left) {
      // 左边区域 👈
      final double level = maxHeight * 3;
      final double brightness = (_brightnessValue.value - delta.dy / level)
          .clamp(0.0, 1.0);
      setBrightness(brightness);
    } else if (_gestureType == .center) {
      // 全屏
      const double threshold = 2.5; // 滑动阈值
      double cumulativeDy = details.localFocalPoint.dy - _initialFocalPoint!.dy;

      void fullScreenTrigger(bool status) {
        plPlayerController.triggerFullScreen(status: status);
      }

      if (cumulativeDy > threshold) {
        _gestureType = .center_down;
        if (isFullScreen ^ plPlayerController.fullScreenGestureReverse) {
          fullScreenTrigger(
            plPlayerController.fullScreenGestureReverse,
          );
        }
      } else if (cumulativeDy < -threshold) {
        _gestureType = .center_up;
        if (!isFullScreen ^ plPlayerController.fullScreenGestureReverse) {
          fullScreenTrigger(
            !plPlayerController.fullScreenGestureReverse,
          );
        }
      }
    } else if (_gestureType == .right) {
      // 右边区域
      final double level = maxHeight * 0.5;
      EasyThrottle.throttle(
        'setVolume',
        const Duration(milliseconds: 20),
        () {
          final double volumeRaw =
              plPlayerController.volume.value - delta.dy / level;
          final double volume = clampDouble(
            volumeRaw,
            0.0,
            plPlayerController.gestureVolumeMax,
          );
          // 音量增强：触达 1.0 时提示再次滑动才能突破
          if (volumeRaw > 1.0 &&
              !plPlayerController.volumeBoostUnlocked &&
              Pref.enableAppVolume &&
              Pref.enableVolumeBoost) {
            SmartDialog.showToast('再次滑动以突破 100%');
          }
          plPlayerController.setVolume(volume);
        },
      );
    }
  }

  void _onPanEnd(ScaleEndDetails details) {
    if (_gestureType == .horizontal) {
      _onHorizontalDragEnd();
    }
    _initialFocalPoint = null;
    // 松手后：若音量已在 1.0，解锁下次可突破；否则重置
    if (plPlayerController.volume.value >= 1.0) {
      plPlayerController.volumeBoostUnlocked = true;
    } else {
      plPlayerController.onVolumeGestureEnd();
    }
    _gestureType = null;
  }

  void onDoubleTapDownMobile(TapDownDetails details) {
    if (plPlayerController.isLive || plPlayerController.controlsLock.value) {
      return;
    }
    final double tapPosition = details.localPosition.dx;
    final double sectionWidth = maxWidth / 4;
    DoubleTapType type;
    if (tapPosition < sectionWidth) {
      type = DoubleTapType.left;
    } else if (tapPosition < sectionWidth * 3) {
      type = DoubleTapType.center;
    } else {
      type = DoubleTapType.right;
    }
    plPlayerController.doubleTapFuc(type);
  }

  void _onTapUp(TapUpDetails details) {
    if (_shouldIgnoreTapUp()) {
      return;
    }

    switch (details.kind) {
      case ui.PointerDeviceKind.mouse when PlatformUtils.isDesktop:
        plPlayerController.onDoubleTapCenter();
      default:
        if (_suspendedDm == null) {
          plPlayerController.controls = !plPlayerController.showControls.value;
        } else if (_suspendedDm!.suspend) {
          _dmOffset.value = details.localPosition;
        } else {
          _suspendedDm = null;
        }
    }
  }

  void _onTapDown(TapDownDetails details) {
    final ctr = plPlayerController.danmakuController;
    if (ctr != null) {
      final pos = details.localPosition;
      final res = ctr.findSingleDanmaku(pos);
      if (res != null) {
        final (dy, item) = res;
        if (item != _suspendedDm) {
          _suspendedDm?.suspend = false;
          if (item.content.extra == null) {
            _dmOffset.value = null;
            return;
          }
          _suspendedDm = item..suspend = true;
          this.dy = dy;
        }
      } else {
        _suspendedDm?.suspend = false;
        _dmOffset.value = null;
      }
    }
  }

  void _onDoubleTapDown(TapDownDetails details) {
    switch (details.kind) {
      case ui.PointerDeviceKind.mouse when PlatformUtils.isDesktop:
        plPlayerController.triggerFullScreen(status: !isFullScreen);
      default:
        onDoubleTapDownMobile(details);
    }
  }

  /// 淡出动画期间冻结的锁定提示内容（图标 + 文案）
  (Widget?, String) _speedLockToastContent = (null, '');

  LongPressGestureRecognizer? _longPressRecognizer;
  LongPressGestureRecognizer get longPressRecognizer => _longPressRecognizer ??=
      LongPressGestureRecognizer(
          duration: plPlayerController.enableTapDm
              ? const Duration(milliseconds: 300)
              : null,
        )
        ..onLongPressStart = ((_) =>
            plPlayerController.setLongPressStatus(true))
        ..onLongPressMoveUpdate = ((details) => plPlayerController
            .onLongPressMove(details.offsetFromOrigin.dy, maxHeight))
        ..onLongPressEnd = ((_) => plPlayerController.setLongPressStatus(false))
        ..onLongPressCancel = (() =>
            plPlayerController.setLongPressStatus(false, isCancel: true));
  late final ImmediateTapGestureRecognizer _tapGestureRecognizer;
  late final DoubleTapGestureRecognizer _doubleTapGestureRecognizer;
  late final PlayerScaleGestureRecognizer _scaleGestureRecognizer;

  StreamSubscription<bool>? _danmakuListener;

  bool get _canTrackTwoFingerTap =>
      PlatformUtils.isMobile &&
      plPlayerController.enableTwoFingerTapPause &&
      !plPlayerController.controlsLock.value &&
      !plPlayerController.isLive;

  void _ignoreTapUpFor(Duration duration) {
    final until = DateTime.now().add(duration);
    final current = _ignoreTapUpBefore;
    if (current == null || current.isBefore(until)) {
      _ignoreTapUpBefore = until;
    }
  }

  bool _shouldIgnoreTapUp() {
    final ignoreTapUpBefore = _ignoreTapUpBefore;
    if (ignoreTapUpBefore == null) {
      return false;
    }

    if (DateTime.now().isBefore(ignoreTapUpBefore)) {
      return true;
    }

    _ignoreTapUpBefore = null;
    return false;
  }

  bool _handleTwoFingerTapIfNeeded() {
    if (!_canTrackTwoFingerTap) {
      return false;
    }

    _ignoreTapUpFor(const Duration(milliseconds: 300));
    unawaited(plPlayerController.onDoubleTapCenter());
    return true;
  }

  void _onTwoFingerPointerDown(PointerDownEvent event) {
    if (event.kind != ui.PointerDeviceKind.touch) {
      return;
    }

    if (!_canTrackTwoFingerTap) {
      _twoFingerTapDetector.reset();
      return;
    }

    _twoFingerTapDetector.onPointerDown(
      pointer: event.pointer,
      position: event.localPosition,
    );

    if (_twoFingerTapDetector.activePointerCount >= 2) {
      _ignoreTapUpFor(const Duration(milliseconds: 300));
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.kind != ui.PointerDeviceKind.touch) {
      return;
    }

    _twoFingerTapDetector.onPointerMove(
      pointer: event.pointer,
      position: event.localPosition,
    );
  }

  void _onPointerUpImpl(PointerUpEvent event) {
    if (event.kind != ui.PointerDeviceKind.touch) {
      return;
    }

    if (_twoFingerTapDetector.onPointerUp(pointer: event.pointer)) {
      _handleTwoFingerTapIfNeeded();
    }
  }

  void _onPointerCancelImpl(PointerCancelEvent event) {
    if (event.kind != ui.PointerDeviceKind.touch) {
      return;
    }

    _twoFingerTapDetector.onPointerCancel(event.pointer);
  }

  static const _kOffsetThreshold = 25.0;
  bool _isPositionAllowed(Offset offset) {
    if (offset.dx < _kOffsetThreshold ||
        offset.dy < _kOffsetThreshold ||
        offset.dx > maxWidth - _kOffsetThreshold ||
        offset.dy > maxHeight - _kOffsetThreshold) {
      return false;
    }
    return true;
  }

  /// 鼠标中键/右键全屏切换的挂起项：(进入全屏, 应用内全屏)。
  /// 在鼠标按下时启动原生全屏过渡会与本次点击重叠，窗口可能卡在半过渡状态
  /// 导致鼠标事件失效，因此延后到抬起后执行。
  (bool, bool)? _pendingFullScreenToggle;

  void _onPointerDown(PointerDownEvent event) {
    if (PlatformUtils.isDesktop) {
      final buttons = event.buttons;
      final isSecondaryBtn = buttons == kSecondaryMouseButton;
      if (isSecondaryBtn || buttons == kMiddleMouseButton) {
        _pendingFullScreenToggle = (!isFullScreen, isSecondaryBtn);
        return;
      }
    }

    _onTwoFingerPointerDown(event);

    final controlsUnlock = !plPlayerController.controlsLock.value;
    if (PlatformUtils.isMobile) {
      _tapGestureRecognizer.addPointer(event);
      if (controlsUnlock) {
        if (!plPlayerController.isLive) {
          _doubleTapGestureRecognizer.addPointer(event);
          longPressRecognizer.addPointer(event);
        }
        _scaleGestureRecognizer
          ..isPosAllowed = _isPositionAllowed(event.localPosition)
          ..addPointer(event);
      }
    } else if (controlsUnlock) {
      if (plPlayerController.isLive) {
        _doubleTapGestureRecognizer.addPointer(event);
      } else {
        _tapGestureRecognizer.addPointer(event);
        _doubleTapGestureRecognizer.addPointer(event);
        longPressRecognizer.addPointer(event);
      }
      _scaleGestureRecognizer.addPointer(event);
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _onPointerUpImpl(event);
    final pending = _pendingFullScreenToggle;
    if (pending == null || event.buttons != 0) {
      return;
    }
    _pendingFullScreenToggle = null;
    if (isFullScreen && plPlayerController.controlsLock.value) {
      plPlayerController
        ..controlsLock.value = false
        ..showControls.value = false;
    }
    plPlayerController.triggerFullScreen(
      status: pending.$1,
      inAppFullScreen: pending.$2,
    );
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _onPointerCancelImpl(event);
    _pendingFullScreenToggle = null;
  }

  void _onPointerPanZoomUpdate(PointerPanZoomUpdateEvent event) {
    if (plPlayerController.controlsLock.value) return;
    if (_gestureType == null) {
      final pan = event.pan;
      if (pan.distanceSquared < 1) return;
      final dx = pan.dx.abs();
      final dy = pan.dy.abs();
      if (dx > 3 * dy) {
        _onHorizontalDragStart();
        _gestureType = .horizontal;
      } else if (dy > 3 * dx) {
        _gestureType = .right;
      }
      return;
    }

    if (_gestureType == .horizontal) {
      if (plPlayerController.isLive) return;

      _onHorizontalDragUpdate(event.localPanDelta.dx);
    } else if (_gestureType == .right) {
      if (!plPlayerController.enableSlideVolumeBrightness) {
        return;
      }

      final double level = maxHeight * 0.5;
      EasyThrottle.throttle(
        'setVolume',
        const Duration(milliseconds: 20),
        () {
          final double volumeRaw =
              plPlayerController.volume.value - event.localPanDelta.dy / level;
          final double volume = clampDouble(
            volumeRaw,
            0.0,
            plPlayerController.gestureVolumeMax,
          );
          // 音量增强：触达 1.0 时提示再次滑动才能突破
          if (volumeRaw > 1.0 &&
              !plPlayerController.volumeBoostUnlocked &&
              Pref.enableAppVolume &&
              Pref.enableVolumeBoost) {
            SmartDialog.showToast('再次滑动以突破 100%');
          }
          plPlayerController.setVolume(volume);
        },
      );
    }
  }

  void _onPointerPanZoomEnd(PointerPanZoomEndEvent event) {
    if (_gestureType == .horizontal) {
      _onHorizontalDragEnd();
    }
    // 松手后：若音量已在 1.0，解锁下次可突破；否则重置
    if (plPlayerController.volume.value >= 1.0) {
      plPlayerController.volumeBoostUnlocked = true;
    } else {
      plPlayerController.onVolumeGestureEnd();
    }
    _gestureType = null;
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final offset = -event.scrollDelta.dy / 4000;
      final volume = clampDouble(
        plPlayerController.volume.value + offset,
        0.0,
        plPlayerController.maxVolume,
      );
      plPlayerController.setVolume(volume);
    }
  }

  Widget _buildLockBtn() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0x45000000),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Obx(() {
        final controlsLock = plPlayerController.controlsLock.value;
        return ComBtn(
          tooltip: controlsLock ? '解锁' : '锁定',
          icon: controlsLock
              ? const Icon(
                  FontAwesomeIcons.lock,
                  size: 15,
                  color: Colors.white,
                )
              : const Icon(
                  FontAwesomeIcons.lockOpen,
                  size: 15,
                  color: Colors.white,
                ),
          onTap: () => plPlayerController.onLockControl(!controlsLock),
        );
      }),
    );
  }

  Widget _buildScreenshotBtn() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0x45000000),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: ComBtn(
        tooltip: '截图',
        icon: const Icon(
          Icons.photo_camera,
          size: 20,
          color: Colors.white,
        ),
        onLongPress:
            (Platform.isAndroid || kDebugMode) && !plPlayerController.isLive
            ? _screenshotWebp
            : null,
        onTap: plPlayerController.takeScreenshot,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    maxWidth = widget.maxWidth;
    maxHeight = widget.maxHeight;
    final isFullScreen = this.isFullScreen;
    final primary = isFullScreen && colorScheme.isLight
        ? colorScheme.inversePrimary
        : colorScheme.primary;
    late final thumbGlowColor = primary.withAlpha(80);
    late final bufferedBarColor = primary.withValues(alpha: 0.4);
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    final isLive = plPlayerController.isLive;
    // 锁定按钮显示在右侧：与截图按钮同组垂直居中
    final lockBtnOnRight =
        plPlayerController.showFsLockBtnRight && plPlayerController.showFsLockBtn;

    final child = Stack(
      fit: StackFit.passthrough,
      key: _playerKey,
      children: <Widget>[
        _videoWidget,

        if (widget.danmuWidget case final danmaku?)
          Positioned.fill(top: _kDanmakuTopInset, child: danmaku),

        if (!isLive && !widget.isInAppPip)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !plPlayerController.enableDragSubtitle,
              child: Obx(
                () => SubtitleView(
                  controller: videoController,
                  configuration: plPlayerController.subtitleConfig.value,
                  enableDragSubtitle: plPlayerController.enableDragSubtitle,
                  onUpdatePadding: plPlayerController.onUpdatePadding,
                ),
              ),
            ),
          ),

        if (plPlayerController.enableTapDm)
          Obx(
            () {
              if (!plPlayerController.enableShowDanmaku.value) {
                return const SizedBox.shrink();
              }
              final dmOffset = _dmOffset.value;
              if (dmOffset != null && _suspendedDm != null) {
                return _buildDmAction(_suspendedDm!, dmOffset);
              }
              return const SizedBox.shrink();
            },
          ),

        /// 长按倍速 toast
        if (!isLive)
          IgnorePointer(
            ignoring: true,
            child: Align(
              alignment: Alignment.topCenter,
              child: FractionalTranslation(
                translation: isFullScreen
                    ? const Offset(0.0, 1.2)
                    : const Offset(0.0, 0.8),
                child: Obx(
                  () {
                    final hint = plPlayerController.speedLockHint.value;
                    // 内容只在提示可见时计算并缓存；淡出期间直接复用成品，
                    // 避免恢复速度时文案里的数字被实时刷新
                    if (!hint.isNone) {
                      final speedText =
                          '${plPlayerController.playbackSpeed}x播放';
                      _speedLockToastContent = switch (hint) {
                        SpeedLockHint.swipeUpToLock => (
                          const SpeedLockArrows(),
                          '上滑锁定$speedText',
                        ),
                        SpeedLockHint.releaseToLock => (
                          const Icon(
                            Icons.lock_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          '松手锁定$speedText',
                        ),
                        SpeedLockHint.lockedConfirm => (
                          null,
                          '已经锁定$speedText',
                        ),
                        SpeedLockHint.swipeDownToUnlock => (
                          const SpeedLockArrows(down: true),
                          '下滑退出$speedText',
                        ),
                        SpeedLockHint.releaseToUnlock => (
                          const Icon(
                            Icons.lock_open_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          '松手退出$speedText',
                        ),
                        SpeedLockHint.unlockedConfirm => (
                          null,
                          '已经恢复$speedText',
                        ),
                        SpeedLockHint.none => (null, ''),
                      };
                    }
                    final (icon, text) = _speedLockToastContent;
                    return AnimatedOpacity(
                      curve: Curves.easeInOut,
                      opacity: hint.isNone ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0x88000000),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        // 定高内容行：各状态胶囊等高，位置不随内容跳变
                        child: SizedBox(
                          height: 22,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 6,
                            children: [
                              if (icon != null)
                                TickerMode(enabled: !hint.isNone, child: icon),
                              Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

        /// 时间进度 toast
        if (!isLive)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Obx(
                () {
                  final desktopPreview = PlatformUtils.isDesktop &&
                      plPlayerController.showDesktopProgressFeedback.value;
                  final opacity = desktopPreview ||
                          (!PlatformUtils.isDesktop &&
                              plPlayerController.isSeeking.value)
                      ? 1.0
                      : 0.0;
                  final displayPosition = desktopPreview
                      ? plPlayerController.progressPreviewSeconds.value
                      : plPlayerController.position.value;
                  Widget child = AnimatedOpacity(
                    curve: Curves.easeInOut,
                    opacity: opacity,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0x88000000),
                        borderRadius: BorderRadius.all(Radius.circular(64)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        spacing: 2,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => Text(
                              DurationUtils.formatDuration(
                                plPlayerController.isSeeking.value
                                    ? plPlayerController.seekPosition.value
                                    : displayPosition,
                              ),
                              style: textStyle,
                            ),
                          ),
                          const Text('/', style: textStyle),
                          Text(
                            DurationUtils.formatDuration(
                              plPlayerController.duration.value,
                            ),
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  );

                  final previewValue =
                      plPlayerController.desktopProgressPreviewValue.value;
                  if (desktopPreview && previewValue != null) {
                    return _DesktopProgressPreviewLayout(
                      maxWidth: maxWidth,
                      previewValue: previewValue,
                      anchorWidth: desktopSeekPreviewWidth(
                        plPlayerController,
                        maxHeight,
                      ),
                      bottom: desktopProgressTimeIndicatorBottom,
                      child: child,
                    );
                  }

                  return Align(
                    alignment: Alignment.topCenter,
                    child: FractionalTranslation(
                      translation: isFullScreen
                          ? const Offset(0.0, 1.2)
                          : const Offset(0.0, 0.8),
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ),

        /// 音量🔊 控制条展示
        IgnorePointer(
          ignoring: true,
          child: Align(
            alignment: Alignment.center,
            child: Obx(
              () {
                final volume = plPlayerController.volume.value;
                return AnimatedOpacity(
                  curve: Curves.easeInOut,
                  opacity: plPlayerController.volumeIndicator.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0x88000000),
                      borderRadius: BorderRadius.all(Radius.circular(64)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          volume == 0.0
                              ? Icons.volume_off
                              : volume < 0.5
                              ? Icons.volume_down
                              : Icons.volume_up,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        const SizedBox(width: 2.0),
                        Text(
                          '${(volume * 100.0).round()}%',
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        /// 亮度🌞 控制条展示
        IgnorePointer(
          ignoring: true,
          child: Align(
            alignment: Alignment.center,
            child: Obx(
              () => AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: _brightnessIndicator.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0x88000000),
                    borderRadius: BorderRadius.all(Radius.circular(64)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        _brightnessValue.value < 1.0 / 3.0
                            ? Icons.brightness_low
                            : _brightnessValue.value < 2.0 / 3.0
                            ? Icons.brightness_medium
                            : Icons.brightness_high,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      const SizedBox(width: 2.0),
                      Text(
                        '${(_brightnessValue.value * 100.0).round()}%',
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // 头部、底部控制条
        Positioned.fill(
          top: -1,
          bottom: -1,
          child: ClipRect(
            child: RepaintBoundary(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBarAni(
                    isTop: true,
                    controller: _animationController,
                    isFullScreen: isFullScreen,
                    removeSafeArea: plPlayerController.removeSafeArea,
                    child: plPlayerController.isDesktopPip
                        ? GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onPanStart: (_) => windowManager.startDragging(),
                            child: widget.headerControl,
                          )
                        : widget.headerControl,
                  ),
                  AppBarAni(
                    isTop: false,
                    controller: _animationController,
                    isFullScreen: isFullScreen,
                    removeSafeArea: plPlayerController.removeSafeArea,
                    child:
                        widget.bottomControl ??
                        BottomControl(
                          maxWidth: maxWidth,
                          isFullScreen: isFullScreen,
                          isPipMode: widget.isPipMode,
                          controller: plPlayerController,
                          videoDetailController: videoDetailController,
                          buildBottomControl: () => buildBottomControl(
                            videoDetailController,
                            maxWidth > maxHeight,
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Positioned(
        //   right: 25,
        //   top: 125,
        //   child: FilledButton.tonal(
        //     onPressed: () {
        //       transformationController.value = Matrix4.identity()
        //         ..translate(0.5, 0.5)
        //         ..scale(0.5)
        //         ..translate(-0.5, -0.5);

        //       showRestoreScaleBtn.value = true;
        //     },
        //     child: const Text('scale'),
        //   ),
        // ),
        Obx(
          () =>
              showRestoreScaleBtn.value && plPlayerController.showControls.value
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 95),
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: colorScheme.secondaryContainer
                            .withValues(alpha: 0.8),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.all(15),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        final animController = AnimationController(
                          vsync: this,
                          duration: const Duration(milliseconds: 255),
                        );
                        final anim = animController.drive(
                          Matrix4Tween(
                            begin: _transformationController.value,
                            end: Matrix4.identity(),
                          ).chain(CurveTween(curve: Curves.easeOut)),
                        );
                        void listener() {
                          _transformationController.value = anim.value;
                        }

                        animController.addListener(listener);
                        await animController.forward(from: 0);
                        animController
                          ..removeListener(listener)
                          ..dispose();
                        // Tween 终值可能有残差，显式归位
                        if (mounted) {
                          _transformationController.value = Matrix4.identity();
                        }
                      },
                      child: const Text('还原屏幕'),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),

        /// 进度条 live模式下禁用
        if (!isLive)
          Positioned(
            bottom: -2.2,
            left: 0,
            right: 0,
            child: Obx(
              () {
                final showControls = plPlayerController.showControls.value;
                final bool offstage;
                switch (plPlayerController.progressType) {
                  case .alwaysShow:
                    offstage = showControls;
                  case .alwaysHide:
                    if (!plPlayerController.isSeeking.value) {
                      return const SizedBox.shrink();
                    }
                    offstage = showControls;
                  case .onlyShowFullScreen:
                    offstage =
                        showControls ||
                        (!isFullScreen && !plPlayerController.isSeeking.value);
                  case .onlyHideFullScreen:
                    offstage =
                        showControls ||
                        (isFullScreen && !plPlayerController.isSeeking.value);
                }
                return Offstage(
                  offstage: offstage,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Obx(
                        () => ProgressBar(
                          progress: plPlayerController.progress,
                          buffered: plPlayerController.buffered.value,
                          total: plPlayerController.duration.value,
                          progressBarColor: primary,
                          baseBarColor: const Color(0x33FFFFFF),
                          bufferedBarColor: bufferedBarColor,
                          thumbColor: primary,
                          thumbGlowColor: thumbGlowColor,
                          barHeight: 3.5,
                          thumbRadius: 2.5,
                        ),
                      ),
                      if (plPlayerController.enableBlock &&
                          videoDetailController.segmentProgressList.isNotEmpty)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0.75,
                          child: SegmentProgressBar(
                            segments: videoDetailController.segmentProgressList,
                          ),
                        ),
                      if (!widget.isPipMode &&
                          plPlayerController.showViewPoints &&
                          videoDetailController.viewPointList.isNotEmpty &&
                          !videoDetailController.showVP.value)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0.75,
                          child: ViewPointDividerBar(
                            segments: videoDetailController.viewPointList,
                            progress: plPlayerController.duration.value > 0
                                ? plPlayerController.position.value /
                                      plPlayerController.duration.value
                                : 0.0,
                          ),
                        ),
                      if (!widget.isPipMode &&
                          plPlayerController.showViewPoints &&
                          videoDetailController.viewPointList.isNotEmpty &&
                          videoDetailController.showVP.value)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.25),
                          child: ViewPointSegmentProgressBar(
                            segments: videoDetailController.viewPointList,
                            onSeek: PlatformUtils.isMobile
                                ? (position) {
                                    if (!plPlayerController
                                        .controlsLock
                                        .value) {
                                      plPlayerController.seekTo(
                                        position,
                                        isSeek: false,
                                      );
                                    }
                                  }
                                : null,
                          ),
                        ),

                      if (!widget.isPipMode &&
                          plPlayerController.showDmChart &&
                          videoDetailController.showDmTrendChart.value)
                        if (videoDetailController.dmTrend.value?.dataOrNull
                            case final list?)
                          buildDmChart(primary, list, videoDetailController),
                    ],
                  ),
                );
              },
            ),
          ),

        if (!isLive && plPlayerController.showSeekPreview)
          Positioned.fill(
            child: buildSeekPreviewWidget(
              plPlayerController,
              maxWidth,
              maxHeight,
              () => mounted,
            ),
          ),

        if (isFullScreen || plPlayerController.isDesktopPip) ...[
          // 锁（左侧）
          if (plPlayerController.showFsLockBtn && !lockBtnOnRight)
            ViewSafeArea(
              right: false,
              left: !plPlayerController.removeSafeArea,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionalTranslation(
                  translation: const Offset(1, -0.4),
                  child: Obx(
                    () => Offstage(
                      offstage: !plPlayerController.showControls.value,
                      child: _buildLockBtn(),
                    ),
                  ),
                ),
              ),
            ),

          // 截图 / 锁定（右侧）
          if (plPlayerController.showFsScreenshotBtn || lockBtnOnRight)
            ViewSafeArea(
              left: false,
              right: !plPlayerController.removeSafeArea,
              child: Obx(
                () => Align(
                  alignment: Alignment.centerRight,
                  child: FractionalTranslation(
                    translation: Offset(-1, lockBtnOnRight ? 0 : -0.4),
                    child: Offstage(
                      offstage: !plPlayerController.showControls.value,
                      child: lockBtnOnRight
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (plPlayerController.showFsScreenshotBtn) ...[
                                  _buildScreenshotBtn(),
                                  const SizedBox(height: 20),
                                ],
                                _buildLockBtn(),
                              ],
                            )
                          : _buildScreenshotBtn(),
                    ),
                  ),
                ),
              ),
            ),
        ],

        Obx(() {
          if ((!plPlayerController.suppressBufferingIndicator.value &&
                  plPlayerController.dataStatus.loading) ||
              (plPlayerController.isBuffering.value &&
                  plPlayerController.playerStatus.isPlaying &&
                  !plPlayerController.suppressBufferingIndicator.value)) {
            return Center(
              child: GestureDetector(
                onTap: plPlayerController.refreshPlayer,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Colors.black26, Colors.transparent],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        Assets.buffering,
                        height: 25,
                        cacheHeight: 25.cacheSize(context),
                        semanticLabel: "加载中",
                        color: Colors.white,
                      ),
                      if (plPlayerController.isBuffering.value)
                        Obx(() {
                          final buffered = plPlayerController.buffered.value;
                          if (buffered == 0) {
                            return const Text(
                              '加载中...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            );
                          }
                          return Text(
                            DurationUtils.formatDuration(buffered),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),

        /// 点击 快进/快退
        if (!isLive)
          Obx(() {
            final mountSeekBackwardButton =
                plPlayerController.mountSeekBackwardButton.value;
            final mountSeekForwardButton =
                plPlayerController.mountSeekForwardButton.value;
            return mountSeekBackwardButton || mountSeekForwardButton
                ? Positioned.fill(
                    child: Row(
                      children: [
                        if (mountSeekBackwardButton)
                          Expanded(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 500),
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                              child: BackwardSeekIndicator(
                                duration:
                                    plPlayerController.fastForBackwardDuration,
                                onSubmitted: (Duration value) {
                                  plPlayerController
                                    ..mountSeekBackwardButton.value = false
                                    ..onBackward(value);
                                },
                              ),
                            ),
                          ),
                        const Spacer(flex: 2),
                        if (mountSeekForwardButton)
                          Expanded(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 500),
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                              child: ForwardSeekIndicator(
                                duration:
                                    plPlayerController.fastForBackwardDuration,
                                onSubmitted: (Duration value) {
                                  plPlayerController
                                    ..mountSeekForwardButton.value = false
                                    ..onForward(value);
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          }),
      ],
    );
    if (PlatformUtils.isDesktop) {
      return Obx(
        () => MouseRegion(
          cursor: !plPlayerController.showControls.value && isFullScreen
              ? SystemMouseCursors.none
              : MouseCursor.defer,
          onEnter: (_) => plPlayerController.controls = true,
          onHover: (_) => plPlayerController.controls = true,
          onExit: (_) => plPlayerController.controls =
              widget.videoDetailController?.showSteinEdgeInfo.value ?? false,
          child: child,
        ),
      );
    }
    return child;
  }

  Widget get _videoWidget {
    // 使用 LayoutBuilder 动态捕获当前渲染容器的真实约束。
    // 在系统画中画（PiP）转场或拖动过程中，MediaQuery 更新可能不及时，
    // 而 LayoutBuilder 提供的 Constraints 是最准确的。
    return LayoutBuilder(
      builder: (context, constraints) {
        // 如果是在小窗模式下，或者当前容器具有有效的有限约束，则优先使用约束尺寸，
        // 从而解决从系统 PiP 恢复到应用时渲染容器未及时由于 layout 变化而导致渲染异常的问题。
        final bool useConstraints =
            (widget.isPipMode ||
            (constraints.maxWidth > 0 && constraints.maxWidth.isFinite));

        final double currentWidth = useConstraints
            ? constraints.maxWidth.clamp(0.0, double.infinity)
            : maxWidth;
        final double currentHeight = useConstraints
            ? constraints.maxHeight.clamp(0.0, double.infinity)
            : maxHeight;

        // 确保容器至少有一个最小有效的尺寸，避免播放引擎初始化失败
        final double finalWidth = currentWidth > 0
            ? currentWidth
            : (maxWidth > 0 ? maxWidth : 16.0);
        final double finalHeight = currentHeight > 0
            ? currentHeight
            : (maxHeight > 0 ? maxHeight : 9.0);

        return Container(
          clipBehavior: .none,
          width: finalWidth,
          height: finalHeight,
          color: widget.fill,
          child: Obx(
            () => MouseInteractiveViewer(
              scaleEnabled: !plPlayerController.controlsLock.value,
              rotateEnabled: plPlayerController.enablePinchRotate,
              pointerSignalFallback: _onPointerSignal,
              onPointerPanZoomUpdate: _onPointerPanZoomUpdate,
              onPointerPanZoomEnd: _onPointerPanZoomEnd,
              onPointerDown: _onPointerDown,
              onPointerMove: _onPointerMove,
              onPointerUp: _onPointerUp,
              onPointerCancel: _onPointerCancel,
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              onScaleUpdate: _onScaleUpdate,
              scaleGestureRecognizer: _scaleGestureRecognizer,
              panEnabled: false,
              minScale: plPlayerController.enableShrinkVideoSize ? 0.75 : 1,
              maxScale: 2.0,
              boundaryMargin: plPlayerController.enableShrinkVideoSize
                            ? const .all(double.infinity)
                            : .zero,
              panAxis: .aligned,
              transformationController: _transformationController,
              childKey: _videoKey,
              child: RepaintBoundary(
                key: _videoKey,
                child: Obx(
                  () {
                    final videoFit = plPlayerController.videoFit.value;
                    // 几何镜像：改这里的 FittedBox / flip / Transform 结构要同步 DanmakuMaskGeometry
                    return Transform.flip(
                      flipX: plPlayerController.flipX.value,
                      flipY: plPlayerController.flipY.value,
                      child: FittedBox(
                        fit: videoFit.boxFit,
                        alignment: widget.alignment,
                        child: SimpleVideo(
                          controller: plPlayerController.videoController!,
                          fill: widget.fill,
                          aspectRatio: videoFit.aspectRatio,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _screenshotWebp() async {
    final videoInfo = videoDetailController.data;
    final ids = videoInfo.dash!.video!.availableVideoQualities;
    final video = videoDetailController.findVideoByQa(ids.min);

    String? url = video.baseUrl;
    if (url == null) return;
    VideoQuality qa = video.quality;

    final ctr = plPlayerController;
    final theme = Theme.of(context);
    final currentPos = ctr.positionInMilliseconds / 1000.0;
    final duration = ctr.durationInMilliseconds / 1000.0;
    final segment = Pair(first: currentPos, second: currentPos);
    final model = PostSegmentModel(
      segment: segment,
      category: SegmentType.sponsor,
      actionType: ActionType.skip,
    );
    final isPlay = ctr.playerStatus.isPlaying;
    if (isPlay) ctr.pause();

    WebpPreset preset = WebpPreset.def;

    final success =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('动态截图'),
            content: Column(
              spacing: 12,
              mainAxisSize: MainAxisSize.min,
              children: [
                PostPanel.segmentWidget(
                  theme,
                  item: model,
                  currentPos: () => currentPos,
                  videoDuration: duration,
                ),
                PopupMenuText(
                  title: '选择画质',
                  value: () => qa.code,
                  onSelected: (value) {
                    final video = videoDetailController.findVideoByQa(value);
                    url = video.baseUrl;
                    qa = video.quality;
                    return false;
                  },
                  itemBuilder: (context) => videoInfo.supportFormats!
                      .map(
                        (i) => PopupMenuItem(
                          enabled: ids.contains(i.quality),
                          value: i.quality,
                          child: Text(i.newDesc ?? ''),
                        ),
                      )
                      .toList(),
                  getSelectTitle: (_) => qa.shortDesc,
                ),
                PopupMenuText(
                  title: 'webp预设',
                  value: () => preset,
                  onSelected: (value) {
                    preset = value;
                    return false;
                  },
                  itemBuilder: (context) => WebpPreset.values
                      .map((i) => PopupMenuItem(value: i, child: Text(i.name)))
                      .toList(),
                  getSelectTitle: (i) => '${i.name}(${i.desc})',
                ),
                Text(
                  '*转码使用CPU，速度可能慢于播放，请不要选择过长的时间段或过高画质',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (segment.first < segment.second) {
                    Get.back(result: true);
                  }
                },
                child: const Text('确定'),
              ),
            ],
          ),
        ) ??
        false;
    if (!success) return;

    final progress = 0.0.obs;
    final name =
        '${ctr.cid}-${segment.first.toStringAsFixed(3)}_${segment.second.toStringAsFixed(3)}.webp';
    final file = '$tmpDirPath/$name';

    final mpv = MpvConvertWebp(
      url!,
      file,
      segment.first,
      segment.second,
      progress: progress,
      preset: preset,
    );
    final future = mpv.convert().whenComplete(
      () => SmartDialog.dismiss(status: SmartStatus.loading),
    );

    SmartDialog.showLoading(
      backType: SmartBackType.normal,
      builder: (_) => LoadingWidget(progress: progress, msg: '正在保存，可能需要较长时间'),
      onDismiss: () async {
        if (progress.value < 1.0) {
          mpv.dispose();
        }
        if (await future) {
          await ImageUtils.saveFileImg(
            filePath: file,
            fileName: name,
            needToast: true,
          );
        } else {
          SmartDialog.showToast('转码出现错误或已取消');
        }
        if (isPlay) ctr.play();
      },
    );
  }

  static const _overlaySpacing = 5.0;
  static const _actionItemWidth = 40.0;
  static const _actionItemHeight = 35.0 - _triangleHeight;

  DanmakuItem<DanmakuExtra>? _suspendedDm;
  late double dy = 0;
  late final Rxn<Offset> _dmOffset = Rxn<Offset>();

  void _removeDmAction() {
    if (_suspendedDm != null) {
      _suspendedDm?.suspend = false;
      _suspendedDm = null;
      _dmOffset.value = null;
    }
  }

  Widget _dmActionItem(
    Widget child, {
    required Future<void>? Function() onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await onTap();
        _removeDmAction();
      },
      child: SizedBox(
        width: _actionItemWidth,
        height: _actionItemHeight,
        child: Center(
          child: child,
        ),
      ),
    );
  }

  static final _timeRegExp = RegExp(r'(?:\d+[:：])?\d+[:：][0-5]?\d(?!\d)');

  int? _getValidOffset(String data) {
    if (_timeRegExp.firstMatch(data) case final timeStr?) {
      final offset = DurationUtils.parseDuration(timeStr.group(0));
      if (0 < offset &&
          offset * 1000 < videoDetailController.data.timeLength!) {
        return offset;
      }
    }
    return null;
  }

  Widget _buildDmAction(
    DanmakuItem<DanmakuExtra> item,
    Offset offset,
  ) {
    final dx = offset.dx;
    // fullscreen
    if (dx > maxWidth) {
      _removeDmAction();
      return const SizedBox.shrink();
    }

    final seekOffset = _getValidOffset(item.content.text);

    final overlayWidth = _actionItemWidth * (seekOffset == null ? 3 : 4);

    final top = dy + item.height + _triangleHeight + 2;

    final realLeft = dx + overlayWidth / 2;

    final left = realLeft.clamp(
      _overlaySpacing + overlayWidth,
      maxWidth - _overlaySpacing,
    );

    final right = maxWidth - left;
    final triangleOffset = realLeft - left;

    if (right > (maxWidth - item.xPosition)) {
      _removeDmAction();
      return const SizedBox.shrink();
    }

    final extra = item.content.extra;

    return Positioned(
      right: right,
      top: top,
      child: _DanmakuTip(
        offset: triangleOffset,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: switch (extra) {
            null => throw UnimplementedError(),
            VideoDanmaku() => [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _dmActionItem(
                    extra.isLike
                        ? const Icon(
                            size: 20,
                            CustomIcons.player_dm_tip_like_solid,
                            color: Colors.white,
                          )
                        : const Icon(
                            size: 20,
                            CustomIcons.player_dm_tip_like,
                            color: Colors.white,
                          ),
                    onTap: () => HeaderControl.likeDanmaku(
                      extra,
                      plPlayerController.cid!,
                    ),
                  ),
                  if (extra.like > 0)
                    Positioned(
                      left: _actionItemWidth - 10.5,
                      top: 0,
                      child: Text(
                        extra.like.toString(),
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

              _dmActionItem(
                const Icon(
                  size: 19,
                  CustomIcons.player_dm_tip_copy,
                  color: Colors.white,
                ),
                onTap: () => Utils.copyText(item.content.text),
              ),
              if (item.content.selfSend)
                _dmActionItem(
                  const Icon(
                    size: 20,
                    CustomIcons.player_dm_tip_recall,
                    color: Colors.white,
                  ),
                  onTap: () => HeaderControl.deleteDanmaku(
                    extra.id,
                    plPlayerController.cid!,
                  ),
                )
              else
                _dmActionItem(
                  const Icon(
                    size: 20,
                    CustomIcons.player_dm_tip_back,
                    color: Colors.white,
                  ),
                  onTap: () => HeaderControl.reportDanmaku(
                    context,
                    extra: extra,
                    ctr: plPlayerController,
                  ),
                ),
              if (seekOffset != null)
                _dmActionItem(
                  const Icon(
                    size: 18,
                    Icons.gps_fixed_outlined,
                    color: Colors.white,
                  ),
                  onTap: () => plPlayerController.seekTo(
                    Duration(seconds: seekOffset),
                    isSeek: false,
                  ),
                ),
            ],
            LiveDanmaku() => [
              _dmActionItem(
                const Icon(
                  size: 20,
                  MdiIcons.accountOutline,
                  color: Colors.white,
                ),
                onTap: () => Get.toNamed('/member?mid=${extra.mid}'),
              ),
              _dmActionItem(
                const Icon(
                  size: 19,
                  CustomIcons.player_dm_tip_copy,
                  color: Colors.white,
                ),
                onTap: () => Utils.copyText(item.content.text),
              ),
              _dmActionItem(
                const Icon(
                  size: 20,
                  CustomIcons.player_dm_tip_back,
                  color: Colors.white,
                ),
                onTap: () => HeaderControl.reportLiveDanmaku(
                  context,
                  roomId: (widget.bottomControl as live_bottom.BottomControl)
                      .liveRoomCtr
                      .roomId,
                  msg: item.content.text,
                  extra: extra,
                ),
              ),
            ],
          },
        ),
      ),
    );
  }
}

/// 主/副字幕双栏选择面板(双语字幕)。
/// 左栏选主字幕(mpv sid),右栏选副字幕(mpv secondary-sid),
/// 同一轨不能同时为主副,已被另一栏选中的项置灰。
class _SubtitleSelectPanel extends StatelessWidget {
  const _SubtitleSelectPanel({required this.controller});

  final VideoDetailController controller;

  static const _headerStyle = TextStyle(color: Colors.white70, fontSize: 12);
  static const _itemStyle = TextStyle(color: Colors.white, fontSize: 13);
  static const _disabledStyle = TextStyle(color: Colors.white38, fontSize: 13);

  Widget _item({
    required String label,
    required bool selected,
    required bool disabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: disabled ? _disabledStyle : _itemStyle,
              ),
            ),
            if (selected)
              const Icon(Icons.check, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _column({
    required String title,
    required int selectedIndex,
    required int disabledIndex,
    required ValueChanged<int> onSelect,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 32,
          child: Center(child: Text(title, style: _headerStyle)),
        ),
        _item(
          label: '关闭',
          selected: selectedIndex == 0,
          disabled: false,
          onTap: () => onSelect(0),
        ),
        ...controller.subtitles.mapIndexed(
          (i, e) => _item(
            label: e.lanDoc ?? e.lan,
            selected: selectedIndex == i + 1,
            disabled: disabledIndex == i + 1,
            onTap: () => onSelect(i + 1),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final primary = controller.vttSubtitlesIndex.value;
        final secondary = controller.vttSecondarySubtitlesIndex.value;
        return SizedBox(
          width: 300,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _column(
                    title: '主字幕',
                    selectedIndex: primary,
                    disabledIndex: secondary,
                    onSelect: controller.setSubtitle,
                  ),
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Colors.white24,
                ),
                Expanded(
                  child: _column(
                    title: '副字幕',
                    selectedIndex: secondary,
                    disabledIndex: primary,
                    onSelect: controller.setSecondarySubtitle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
