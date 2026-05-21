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
import 'package:PiliPlus/common/widgets/gesture/mouse_interactive_viewer.dart';
import 'package:PiliPlus/common/widgets/gesture/player_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/player_bar.dart';
import 'package:PiliPlus/common/widgets/progress_bar/audio_video_progress_bar.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart' as ugc;
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';
import 'package:PiliPlus/models_new/video/video_detail/section.dart';
import 'package:PiliPlus/models_new/video/video_detail/ugc_season.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/widgets/header_control.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_control_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/double_tap_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/gesture_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/plugin/pl_player/view/simple_video_texture.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/app_bar_ani.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/backward_seek.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/bottom_control.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/common_btn.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/forward_seek.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/play_pause_btn.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/mobile_observer.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart' show clampDouble, kDebugMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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

  final RxDouble _brightnessValue = 0.0.obs;
  final RxBool _brightnessIndicator = false.obs;
  Timer? _brightnessTimer;

  late final RxBool showRestoreScaleBtn = false.obs;

  GestureType? _gestureType;
  Offset? _initialFocalPoint;

  bool _pauseDueToPauseUponEnteringBackgroundMode = false;

  StreamSubscription? _brightnessListener;
  void _onBrightnessChanged(double value) {
    if (mounted && _gestureType != .left) {
      _brightnessValue.value = value;
    }
  }

  void _getCurrBrightness() {
    ScreenBrightnessPlatform.instance.system.then((res) {
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

    if ((widget.headerControl.key as GlobalKey<TimeBatteryMixin>).currentState
        case final state?) {
      if (state.mounted) {
        state.getBatteryLevelIfNeeded();
        state.provider
          ?..startIfNeeded()
          ..muted = !visible;
        if (visible) {
          state.startClock();
        } else {
          state.stopClock();
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

    _transformationController = TransformationController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    videoController = plPlayerController.videoController!;

    if (PlatformUtils.isMobile) {
      Future.microtask(() {
        try {
          FlutterVolumeController.updateShowSystemUI(true);
          _getCurrVolume();
          FlutterVolumeController.addListener(
            _onVolumeChanged,
            emitOnStart: false,
          );
        } catch (_) {}

        try {
          _getCurrBrightness();
          _brightnessListener = ScreenBrightnessPlatform
              .instance
              .onSystemScreenBrightnessChanged
              .listen(_onBrightnessChanged);
        } catch (_) {}
      });
    }

    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _onTapUp;
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
    // TODO: remove
    // part of https://github.com/flutter/flutter/issues/186723
    if (Platform.isAndroid && state == .resumed && !showSystemBar_) {
      setEnabledSystemUIMode(.immersiveSticky);
    }

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
    }
  }

  Future<void> setBrightness(double value) async {
    _brightnessValue.value = value;
    try {
      await ScreenBrightnessPlatform.instance.setSystemScreenBrightness(
        value,
      );
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
    _tapGestureRecognizer.dispose();
    _longPressRecognizer?.dispose();
    _doubleTapGestureRecognizer.dispose();
    _scaleGestureRecognizer.dispose();
    _brightnessListener?.cancel();
    _controlsListener?.cancel();
    _animationController.dispose();
    _transformationController.dispose();
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
          if (!introController.prevPlay()) {
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
          if (!introController.nextPlay()) {
            SmartDialog.showToast('已经是最后一集了');
          }
        },
      ),

      /// 时间进度
      BottomControlType.time => Obx(
        () => _VideoTime(
          position: DurationUtils.formatDuration(
            plPlayerController.positionSeconds.value,
          ),
          duration: DurationUtils.formatDuration(
            plPlayerController.duration.value.inSeconds,
          ),
        ),
      ),

      /// 分段信息
      BottomControlType.viewPoints => Obx(
        () {
          if (videoDetailController.viewPointList.isNotEmpty) {
            final show = videoDetailController.showVP.value;
            return ComBtn(
              width: widgetWidth,
              height: 30,
              tooltip: '分段信息',
              icon: DisabledIcon(
                iconSize: 22,
                color: Colors.white,
                disable: !show,
                child: const Icon(
                  CustomIcons.view_headline_rotate_90,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              onTap: widget.showViewPoints,
              onLongPress: () {
                Feedback.forLongPress(context);
                videoDetailController.showVP.value = !show;
              },
              onSecondaryTap: PlatformUtils.isMobile
                  ? null
                  : () => videoDetailController.showVP.value = !show,
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
            final List<SectionItem> sections = videoDetail.ugcSeason!.sections!;
            for (int i = 0; i < sections.length; i++) {
              final List<EpisodeItem> episodesList = sections[i].episodes!;
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
          return PopupMenuButton<VideoFitType>(
            tooltip: '画面比例',
            requestFocus: false,
            initialValue: fit,
            color: Colors.black.withValues(alpha: 0.8),
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
            return PopupMenuButton<String>(
              tooltip: '翻译',
              requestFocus: false,
              initialValue: videoDetailController.currLang.value,
              color: Colors.black.withValues(alpha: 0.8),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<String>(
                    height: 35,
                    value: '',
                    onTap: () => videoDetailController.setLanguage(''),
                    child: const Text(
                      "关闭翻译",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  ...list.map((e) {
                    return PopupMenuItem<String>(
                      height: 35,
                      value: e.lang,
                      onTap: () => videoDetailController.setLanguage(e.lang!),
                      child: Text(
                        e.title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }),
                ];
              },
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
            return PopupMenuButton<int>(
              tooltip: '字幕',
              requestFocus: false,
              initialValue: val,
              color: Colors.black.withValues(alpha: 0.8),
              itemBuilder: (context) {
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
                  ...videoDetailController.subtitles.indexed.map((e) {
                    return PopupMenuItem<int>(
                      value: e.$1 + 1,
                      height: 35,
                      onTap: () => videoDetailController.setSubtitle(e.$1 + 1),
                      child: Text(
                        "${e.$2.lanDoc}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }),
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
        () => PopupMenuButton<double>(
          tooltip: '倍速',
          requestFocus: false,
          initialValue: plPlayerController.playbackSpeed,
          color: Colors.black.withValues(alpha: 0.8),
          itemBuilder: (context) {
            return plPlayerController.speedList
                .map(
                  (double speed) => PopupMenuItem<double>(
                    height: 35,
                    padding: const EdgeInsets.only(left: 30),
                    value: speed,
                    onTap: () => plPlayerController.setPlaybackSpeed(speed),
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
          final List<FormatItem> videoFormat = videoInfo.supportFormats!;
          final int totalQaSam = videoFormat.length;
          int usefulQaSam = 0;
          final List<VideoItem> video = videoInfo.dash!.video!;
          final Set<int> idSet = {};
          for (final VideoItem item in video) {
            final int id = item.id!;
            if (!idSet.contains(id)) {
              idSet.add(id);
              usefulQaSam++;
            }
          }
          return PopupMenuButton<int>(
            tooltip: '画质',
            requestFocus: false,
            initialValue: currentVideoQa.code,
            color: Colors.black.withValues(alpha: 0.8),
            itemBuilder: (context) {
              return List.generate(
                totalQaSam,
                (index) {
                  final item = videoFormat[index];
                  final enabled = index >= totalQaSam - usefulQaSam;
                  return PopupMenuItem<int>(
                    enabled: enabled,
                    height: 35,
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    value: item.quality,
                    onTap: () async {
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
                      GStorage.setting.put(
                        await ConnectivityUtils.isWiFi
                            ? SettingBoxKey.defaultVideoQa
                            : SettingBoxKey.defaultVideoQaCellular,
                        quality,
                      );
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
            ? const Icon(
                Icons.fullscreen_exit,
                size: 24,
                color: Colors.white,
              )
            : const Icon(
                Icons.fullscreen,
                size: 24,
                color: Colors.white,
              ),
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
      BottomControlType.playOrPause,
      BottomControlType.time,
      if (!isNotFileSource || anySeason) ...[
        BottomControlType.pre,
        BottomControlType.next,
      ],
    ];

    final flag =
        isFullScreen || plPlayerController.isDesktopPip || maxWidth >= 500;
    List<BottomControlType> userSpecifyItemRight = [
      if (isNotFileSource) BottomControlType.viewPoints,
      if (isNotFileSource && anySeason) BottomControlType.episode,
      if (flag) BottomControlType.fit,
      if (isNotFileSource) BottomControlType.aiTranslate,
      BottomControlType.subtitle,
      BottomControlType.speed,
      if (isNotFileSource && flag) BottomControlType.qa,
      if (!plPlayerController.isDesktopPip) BottomControlType.fullscreen,
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
  }

  void _onPanStart(ScaleStartDetails details) {
    _gestureType = null;
    _initialFocalPoint = details.localFocalPoint;
  }

  void _onScaleUpdate(double scale) {
    showRestoreScaleBtn.value = scale != 1.0;
  }

  void _onPanUpdate(ScaleUpdateDetails details) {
    if (_gestureType == null) {
      final cumulativeDelta = details.localFocalPoint - _initialFocalPoint!;
      if (cumulativeDelta.distanceSquared < 1) return;
      final dx = cumulativeDelta.dx.abs();
      final dy = cumulativeDelta.dy.abs();

      if (dx > 3 * dy) {
        _gestureType = .horizontal;
      } else if (dy > 3 * dx) {
        final double tapPosition = details.localFocalPoint.dx;
        final double sectionWidth = maxWidth / 3;
        if (tapPosition < sectionWidth) {
          // 左边区域
          if (PlatformUtils.isDesktop) {
            _gestureType = .right;
          } else {
            _gestureType = .left;
          }
        } else if (tapPosition < sectionWidth * 2) {
          // 全屏
          _gestureType = .center;
        } else {
          // 右边区域
          _gestureType = .right;
        }
      }

      return;
    }

    final delta = details.focalPointDelta;

    if (_gestureType == .horizontal) {
      // live模式下禁用
      if (plPlayerController.isLive) return;

      final curSliderPosition =
          plPlayerController.sliderPosition.inMilliseconds;
      final newPos =
          (curSliderPosition +
                  (plPlayerController.sliderScale * delta.dx / maxWidth)
                      .round())
              .clamp(0, plPlayerController.duration.value.inMilliseconds);
      final Duration result = Duration(milliseconds: newPos);
      final height = maxHeight * 0.125;
      if (details.localFocalPoint.dy <= height &&
          (details.localFocalPoint.dx >= maxWidth * 0.875 ||
              details.localFocalPoint.dx <= maxWidth * 0.125)) {
        plPlayerController.cancelSeek = true;
        plPlayerController.showPreview.value = false;
        if (plPlayerController.hasToast != true) {
          plPlayerController.hasToast = true;
          SmartDialog.showAttach(
            targetContext: context,
            alignment: Alignment.center,
            animationTime: const Duration(milliseconds: 200),
            animationType: SmartAnimationType.fade,
            displayTime: const Duration(milliseconds: 1500),
            maskColor: Colors.transparent,
            builder: (context) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(6),
                ),
                color: colorScheme.secondaryContainer,
              ),
              child: Text(
                '松开手指，取消进退',
                style: TextStyle(
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          );
        }
      } else {
        if (plPlayerController.cancelSeek == true) {
          plPlayerController
            ..cancelSeek = null
            ..hasToast = null;
        }
      }
      plPlayerController
        ..onUpdatedSliderProgress(result)
        ..onChangedSliderStart();
      if (!plPlayerController.isFileSource &&
          plPlayerController.cancelSeek != true) {
        plPlayerController.updatePreviewIndex(newPos ~/ 1000);
      }
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

      if (cumulativeDy > threshold) {
        _gestureType = .center_down;
        plPlayerController.triggerFullScreen(status: false);
      } else if (cumulativeDy < -threshold) {
        _gestureType = .center_up;
        plPlayerController.triggerFullScreen(status: true);
      }
    } else if (_gestureType == .right) {
      // 右边区域
      final double level = maxHeight * 0.5;
      EasyThrottle.throttle(
        'setVolume',
        const Duration(milliseconds: 20),
        () {
          final double volume = clampDouble(
            plPlayerController.volume.value - delta.dy / level,
            0.0,
            PlPlayerController.maxVolume,
          );
          plPlayerController.setVolume(volume);
        },
      );
    }
  }

  void _onPanEnd(ScaleEndDetails details) {
    if (Platform.isAndroid && _gestureType == .left) {
      ScreenBrightnessPlatform.instance.restoreBrightnessMode();
    }
    plPlayerController.showPreview.value = false;
    if (plPlayerController.isSliderMoving.value) {
      if (plPlayerController.cancelSeek == true) {
        plPlayerController.onUpdatedSliderProgress(
          plPlayerController.position,
        );
      } else {
        plPlayerController.seekTo(
          plPlayerController.sliderPosition,
          isSeek: false,
        );
      }
      plPlayerController.onChangedSliderEnd();
    }
    _initialFocalPoint = null;
    _gestureType = null;
  }

  void onDoubleTapDownMobile(TapDownDetails details) {
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
    switch (details.kind) {
      case ui.PointerDeviceKind.mouse when PlatformUtils.isDesktop:
        plPlayerController.onDoubleTapCenter();
      default:
        plPlayerController.controls = !plPlayerController.showControls.value;
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

  PlayerLongPressGestureRecognizer? _longPressRecognizer;
  PlayerLongPressGestureRecognizer get longPressRecognizer =>
      _longPressRecognizer ??= PlayerLongPressGestureRecognizer()
        ..onLongPressStart = ((_) =>
            plPlayerController.setLongPressStatus(true))
        ..onLongPressEnd = ((_) => plPlayerController.setLongPressStatus(false))
        ..onLongPressCancel = (() =>
            plPlayerController.setLongPressStatus(false));
  late final TapGestureRecognizer _tapGestureRecognizer;
  late final DoubleTapGestureRecognizer _doubleTapGestureRecognizer;
  late final PlayerScaleGestureRecognizer _scaleGestureRecognizer;

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

  void _onPointerDown(PointerDownEvent event) {
    if (PlatformUtils.isDesktop) {
      final buttons = event.buttons;
      final isSecondaryBtn = buttons == kSecondaryMouseButton;
      if (isSecondaryBtn || buttons == kMiddleMouseButton) {
        final isFullScreen = this.isFullScreen;
        if (isFullScreen && plPlayerController.controlsLock.value) {
          plPlayerController
            ..controlsLock.value = false
            ..showControls.value = false;
        }
        plPlayerController.triggerFullScreen(
          status: !isFullScreen,
          inAppFullScreen: isSecondaryBtn,
        );
        return;
      }
    }

    final controlsUnlock = !plPlayerController.controlsLock.value;
    if (PlatformUtils.isMobile) {
      _tapGestureRecognizer.addPointer(event);
      if (controlsUnlock) {
        final isPosAllowed = _isPositionAllowed(event.localPosition);
        if (!plPlayerController.isLive) {
          _doubleTapGestureRecognizer.addPointer(event);
          longPressRecognizer
            ..isPosAllowed = isPosAllowed
            ..addPointer(event);
        }
        _scaleGestureRecognizer
          ..isPosAllowed = isPosAllowed
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

  void _onPointerPanZoomUpdate(PointerPanZoomUpdateEvent event) {
    if (plPlayerController.controlsLock.value) return;
    if (_gestureType == null) {
      final pan = event.pan;
      if (pan.distanceSquared < 1) return;
      final dx = pan.dx.abs();
      final dy = pan.dy.abs();
      if (dx > 3 * dy) {
        _gestureType = .horizontal;
      } else if (dy > 3 * dx) {
        _gestureType = .right;
      }
      return;
    }

    if (_gestureType == .horizontal) {
      if (plPlayerController.isLive) return;

      Offset delta = event.localPanDelta;
      final int curSliderPosition =
          plPlayerController.sliderPosition.inMilliseconds;
      final int newPos =
          (curSliderPosition +
                  (plPlayerController.sliderScale * delta.dx / maxWidth)
                      .round())
              .clamp(0, plPlayerController.duration.value.inMilliseconds);
      final Duration result = Duration(milliseconds: newPos);
      if (plPlayerController.cancelSeek == true) {
        plPlayerController
          ..cancelSeek = null
          ..hasToast = null;
      }
      plPlayerController
        ..onUpdatedSliderProgress(result)
        ..onChangedSliderStart();
      if (!plPlayerController.isFileSource &&
          plPlayerController.cancelSeek != true) {
        plPlayerController.updatePreviewIndex(newPos ~/ 1000);
      }
    } else if (_gestureType == .right) {
      final double level = maxHeight * 0.5;
      EasyThrottle.throttle(
        'setVolume',
        const Duration(milliseconds: 20),
        () {
          final double volume = clampDouble(
            plPlayerController.volume.value - event.localPanDelta.dy / level,
            0.0,
            PlPlayerController.maxVolume,
          );
          plPlayerController.setVolume(volume);
        },
      );
    }
  }

  void _onPointerPanZoomEnd(PointerPanZoomEndEvent event) {
    plPlayerController.showPreview.value = false;
    if (plPlayerController.isSliderMoving.value) {
      plPlayerController
        ..seekTo(plPlayerController.sliderPosition, isSeek: false)
        ..onChangedSliderEnd();
    }
    _gestureType = null;
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final offset = -event.scrollDelta.dy / 4000;
      final volume = clampDouble(
        plPlayerController.volume.value + offset,
        0.0,
        PlPlayerController.maxVolume,
      );
      plPlayerController.setVolume(volume);
    }
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

    final child = Stack(
      key: _playerKey,
      fit: .passthrough,
      children: <Widget>[
        _videoWidget,

        if (widget.danmuWidget case final danmaku?)
          Positioned.fill(top: 4, child: danmaku),

        if (!isLive)
          Positioned.fill(
            child: IgnorePointer(
              child: Obx(
                () => SubtitleView(
                  controller: videoController,
                  configuration: plPlayerController.subtitleConfig.value,
                  onUpdatePadding: plPlayerController.onUpdatePadding,
                ),
              ),
            ),
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
                  () => AnimatedOpacity(
                    curve: Curves.easeInOut,
                    opacity: plPlayerController.longPressStatus.value
                        ? 1.0
                        : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0x88000000),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Obx(
                        () => Text(
                          '${plPlayerController.longPressSpeed}倍速中',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        /// 时间进度 toast
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
                  () => AnimatedOpacity(
                    curve: Curves.easeInOut,
                    opacity: plPlayerController.isSliderMoving.value
                        ? 1.0
                        : 0.0,
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
                          Obx(() {
                            return Text(
                              DurationUtils.formatDuration(
                                plPlayerController
                                    .sliderTempPosition
                                    .value
                                    .inSeconds,
                              ),
                              style: textStyle,
                            );
                          }),
                          const Text('/', style: textStyle),
                          Obx(
                            () {
                              return Text(
                                DurationUtils.formatDuration(
                                  plPlayerController.duration.value.inSeconds,
                                ),
                                style: textStyle,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                    child:
                        widget.bottomControl ??
                        BottomControl(
                          maxWidth: maxWidth,
                          isFullScreen: isFullScreen,
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
                        showRestoreScaleBtn.value = false;
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
                return Offstage(
                  offstage: plPlayerController.showControls.value,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Obx(() {
                        final int value =
                            plPlayerController.sliderPositionSeconds.value;
                        final int max =
                            plPlayerController.duration.value.inSeconds;
                        final int buffer =
                            plPlayerController.bufferedSeconds.value;
                        return ProgressBar(
                          progress: Duration(seconds: value),
                          buffered: Duration(seconds: buffer),
                          total: Duration(seconds: max),
                          progressBarColor: primary,
                          baseBarColor: const Color(0x33FFFFFF),
                          bufferedBarColor: bufferedBarColor,
                          thumbColor: primary,
                          thumbGlowColor: thumbGlowColor,
                          barHeight: 3.5,
                          thumbRadius: 2.5,
                        );
                      }),
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
                      if (videoDetailController.viewPointList.isNotEmpty &&
                          videoDetailController.showVP.value)
                        Padding(
                          padding: const .only(bottom: 4.25),
                          child: ViewPointSegmentProgressBar(
                            segments: videoDetailController.viewPointList,
                            onSeek: PlatformUtils.isMobile
                                ? (position) => plPlayerController.seekTo(
                                    position,
                                    isSeek: false,
                                  )
                                : null,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

        if (!isLive)
          buildSeekPreviewWidget(
            plPlayerController,
            maxWidth,
            maxHeight,
            () => mounted,
          ),

        if (isFullScreen || plPlayerController.isDesktopPip) ...[
          // 锁
          ViewSafeArea(
            right: false,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionalTranslation(
                translation: const Offset(1, -0.4),
                child: Obx(
                  () => Offstage(
                    offstage: !plPlayerController.showControls.value,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color(0x45000000),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Obx(() {
                        final controlsLock =
                            plPlayerController.controlsLock.value;
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
                          onTap: () =>
                              plPlayerController.onLockControl(!controlsLock),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 截图
          ViewSafeArea(
            left: false,
            child: Obx(
              () => Align(
                alignment: Alignment.centerRight,
                child: FractionalTranslation(
                  translation: const Offset(-1, -0.4),
                  child: Offstage(
                    offstage: !plPlayerController.showControls.value,
                    child: DecoratedBox(
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
                        onTap: plPlayerController.takeScreenshot,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],

        Obx(() {
          if (plPlayerController.dataStatus.loading ||
              (plPlayerController.isBuffering.value &&
                  plPlayerController.playerStatus.isPlaying)) {
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
                        cacheHeight: 25,
                        semanticLabel: "加载中",
                        color: Colors.white,
                        isPaused: false,
                      ),
                      if (plPlayerController.isBuffering.value)
                        Obx(() {
                          if (plPlayerController.bufferedSeconds.value == 0) {
                            return const Text(
                              '加载中...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            );
                          }
                          String bufferStr = plPlayerController.buffered
                              .toString();
                          return Text(
                            bufferStr.substring(0, bufferStr.length - 3),
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
    return Container(
      clipBehavior: .none,
      width: maxWidth,
      height: maxHeight,
      color: widget.fill,
      child: Obx(
        () => MouseInteractiveViewer(
          scaleEnabled: !plPlayerController.controlsLock.value,
          pointerSignalFallback: _onPointerSignal,
          onPointerPanZoomUpdate: _onPointerPanZoomUpdate,
          onPointerPanZoomEnd: _onPointerPanZoomEnd,
          onPointerDown: _onPointerDown,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          onScaleUpdate: _onScaleUpdate,
          scaleGestureRecognizer: _scaleGestureRecognizer,
          panEnabled: false,
          minScale: 1.0,
          maxScale: 2.0,
          panAxis: .aligned,
          transformationController: _transformationController,
          childKey: _videoKey,
          child: RepaintBoundary(
            key: _videoKey,
            child: Obx(
              () {
                final videoFit = plPlayerController.videoFit.value;
                return Transform.flip(
                  flipX: plPlayerController.flipX.value,
                  flipY: plPlayerController.flipY.value,
                  child: FittedBox(
                    fit: videoFit.boxFit,
                    alignment: widget.alignment,
                    child: SimpleVideoTexture(
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
  }

  late final segment = Pair(
    first: plPlayerController.position.inMilliseconds / 1000.0,
    second: plPlayerController.position.inMilliseconds / 1000.0,
  );
}
