import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:PiliPlus/common/widgets/segment_progress_bar.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/pages/video/detail/controller.dart';
import 'package:PiliPlus/pages/video/detail/introduction/controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/duration.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../common/widgets/audio_video_progress_bar.dart';
import '../../models/video_detail_res.dart';
import '../../pages/bangumi/introduction/controller.dart';
import '../../utils/utils.dart';
import 'models/bottom_control_type.dart';
import 'models/bottom_progress_behavior.dart';
import 'widgets/app_bar_ani.dart';
import 'widgets/backward_seek.dart';
import 'widgets/bottom_control.dart';
import 'widgets/common_btn.dart';
import 'widgets/forward_seek.dart';
import 'widgets/play_pause_btn.dart';

class PLVideoPlayer extends StatefulWidget {
  const PLVideoPlayer({
    required this.plPlayerController,
    this.videoDetailController,
    this.videoIntroController,
    this.bangumiIntroController,
    this.headerControl,
    this.bottomControl,
    this.danmuWidget,
    this.customWidget,
    this.customWidgets,
    this.showEpisodes,
    this.showViewPoints,
    this.fill,
    this.alignment,
    super.key,
  });

  final PlPlayerController plPlayerController;
  final VideoDetailController? videoDetailController;
  final VideoIntroController? videoIntroController;
  final BangumiIntroController? bangumiIntroController;
  final PreferredSizeWidget? headerControl;
  final PreferredSizeWidget? bottomControl;
  final Widget? danmuWidget;
  // List<Widget> or Widget

  final Widget? customWidget;
  final List<Widget>? customWidgets;
  final Function? showEpisodes;
  final VoidCallback? showViewPoints;
  final Color? fill;
  final Alignment? alignment;

  @override
  State<PLVideoPlayer> createState() => _PLVideoPlayerState();
}

class _PLVideoPlayerState extends State<PLVideoPlayer>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late VideoController videoController;
  late VideoIntroController? videoIntroController;
  late BangumiIntroController? bangumiIntroController;

  final GlobalKey _playerKey = GlobalKey();
  final GlobalKey<VideoState> key = GlobalKey<VideoState>();

  final RxBool _mountSeekBackwardButton = false.obs;
  final RxBool _mountSeekForwardButton = false.obs;

  final RxDouble _brightnessValue = 0.0.obs;
  final RxBool _brightnessIndicator = false.obs;
  Timer? _brightnessTimer;

  final RxDouble _volumeValue = 0.0.obs;
  final RxBool _volumeIndicator = false.obs;
  Timer? _volumeTimer;

  // final RxDouble _distance = 0.0.obs;
  final RxBool _volumeInterceptEventStream = false.obs;

  late FullScreenMode mode;
  late int defaultBtmProgressBehavior;
  late bool enableQuickDouble;
  late bool fullScreenGestureReverse;

  late final RxBool showRestoreScaleBtn = false.obs;

  Offset _initialFocalPoint = Offset.zero;
  String? _gestureType;
  //播放器放缩
  bool interacting = false;

  // 是否在调整固定进度条
  RxBool draggingFixedProgressBar = false.obs;
  // 阅读器限制
  // Timer? _accessibilityDebounce;
  // double _lastAnnouncedValue = -1;

  void onDoubleTapSeekBackward() {
    _mountSeekBackwardButton.value = true;
  }

  void onDoubleTapSeekForward() {
    _mountSeekForwardButton.value = true;
  }

  // 双击播放、暂停
  void onDoubleTapCenter() async {
    if (plPlayerController.videoPlayerController!.state.completed) {
      await plPlayerController.videoPlayerController!.seek(Duration.zero);
      plPlayerController.videoPlayerController!.play();
    } else {
      plPlayerController.videoPlayerController!.playOrPause();
    }
  }

  void doubleTapFuc(String type) {
    if (!enableQuickDouble) {
      onDoubleTapCenter();
      return;
    }
    switch (type) {
      case 'left':
        // 双击左边区域 👈
        onDoubleTapSeekBackward();
        break;
      case 'center':
        onDoubleTapCenter();
        break;
      case 'right':
        // 双击右边区域 👈
        onDoubleTapSeekForward();
        break;
    }
  }

  StreamSubscription? _listener;

  @override
  void initState() {
    super.initState();
    plPlayerController.getPlayerKey = () => key;
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    videoController = plPlayerController.videoController!;
    videoIntroController = widget.videoIntroController;
    bangumiIntroController = widget.bangumiIntroController;
    plPlayerController.headerControl = widget.headerControl;
    plPlayerController.bottomControl = widget.bottomControl;
    plPlayerController.danmuWidget = widget.danmuWidget;
    defaultBtmProgressBehavior = GStorage.setting.get(
        SettingBoxKey.btmProgressBehavior,
        defaultValue: BtmProgressBehavior.values.first.code);
    enableQuickDouble = GStorage.setting
        .get(SettingBoxKey.enableQuickDouble, defaultValue: true);
    fullScreenGestureReverse = GStorage.setting
        .get(SettingBoxKey.fullScreenGestureReverse, defaultValue: false);
    Future.microtask(() async {
      try {
        FlutterVolumeController.updateShowSystemUI(true);
        _volumeValue.value = (await FlutterVolumeController.getVolume())!;
        FlutterVolumeController.addListener((double value) {
          if (mounted && !_volumeInterceptEventStream.value) {
            _volumeValue.value = value;
            if (Platform.isIOS && FlutterVolumeController.showSystemUI.not) {
              _volumeIndicator.value = true;
              _volumeTimer?.cancel();
              _volumeTimer = Timer(const Duration(milliseconds: 800), () {
                if (mounted) {
                  _volumeIndicator.value = false;
                }
              });
            }
          }
        });
      } catch (_) {}
    });

    Future.microtask(() async {
      try {
        _brightnessValue.value = await ScreenBrightness().application;
        _listener = ScreenBrightness()
            .onApplicationScreenBrightnessChanged
            .listen((double value) {
          if (mounted) {
            _brightnessValue.value = value;
          }
        });
      } catch (_) {}
    });
  }

  Future<void> setVolume(double value) async {
    try {
      FlutterVolumeController.updateShowSystemUI(false);
      await FlutterVolumeController.setVolume(value);
    } catch (_) {}
    _volumeValue.value = value;
    _volumeIndicator.value = true;
    _volumeInterceptEventStream.value = true;
    _volumeTimer?.cancel();
    _volumeTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _volumeIndicator.value = false;
        _volumeInterceptEventStream.value = false;
      }
    });
  }

  Future<void> setBrightness(double value) async {
    try {
      await ScreenBrightness().setApplicationScreenBrightness(value);
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
    _listener?.cancel();
    animationController.dispose();
    FlutterVolumeController.removeListener();
    transformationController.dispose();
    super.dispose();
  }

  // 动态构建底部控制条
  Widget buildBottomControl() {
    bool isSeason = videoIntroController?.videoDetail.value.ugcSeason != null;
    bool isPage = videoIntroController?.videoDetail.value.pages != null &&
        videoIntroController!.videoDetail.value.pages!.length > 1;
    bool isBangumi = bangumiIntroController?.loadingState.value is Success;
    bool anySeason = isSeason || isPage || isBangumi;
    double widgetWidth =
        isFullScreen && context.orientation == Orientation.landscape ? 42 : 35;
    Map<BottomControlType, Widget> videoProgressWidgets = {
      /// 上一集
      BottomControlType.pre: Container(
        width: widgetWidth,
        height: 30,
        alignment: Alignment.center,
        child: ComBtn(
          icon: const Icon(
            Icons.skip_previous,
            semanticLabel: '上一集',
            size: 22,
            color: Colors.white,
          ),
          onTap: () {
            bool? res;
            if (videoIntroController != null) {
              res = videoIntroController!.prevPlay();
            }
            if (bangumiIntroController != null) {
              res = bangumiIntroController!.prevPlay();
            }
            if (res == false) {
              SmartDialog.showToast('已经是第一集了');
            }
          },
        ),
      ),

      /// 播放暂停
      BottomControlType.playOrPause: PlayOrPauseButton(
        plPlayerController: plPlayerController,
      ),

      /// 下一集
      BottomControlType.next: Container(
        width: widgetWidth,
        height: 30,
        alignment: Alignment.center,
        child: ComBtn(
          icon: const Icon(
            Icons.skip_next,
            semanticLabel: '下一集',
            size: 22,
            color: Colors.white,
          ),
          onTap: () {
            bool? res;
            if (videoIntroController != null) {
              res = videoIntroController!.nextPlay();
            }
            if (bangumiIntroController != null) {
              res = bangumiIntroController!.nextPlay();
            }
            if (res == false) {
              SmartDialog.showToast('已经是最后一集了');
            }
          },
        ),
      ),

      /// 时间进度
      BottomControlType.time: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 播放时间
          Obx(() {
            return Text(
              Utils.timeFormat(plPlayerController.positionSeconds.value),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                height: 1.4,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
              semanticsLabel:
                  '已播放${Utils.durationReadFormat(Utils.timeFormat(plPlayerController.positionSeconds.value))}',
            );
          }),
          Obx(
            () => Text(
              Utils.timeFormat(
                  plPlayerController.durationSeconds.value.inSeconds),
              style: const TextStyle(
                color: Color(0xFFD0D0D0),
                fontSize: 10,
                height: 1.4,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
              semanticsLabel:
                  '共${Utils.durationReadFormat(Utils.timeFormat(plPlayerController.durationSeconds.value.inSeconds))}',
            ),
          ),
        ],
      ),

      /// 高能进度条
      BottomControlType.dmChart: Obx(() => plPlayerController.dmTrend.isEmpty
          ? const SizedBox.shrink()
          : Container(
              width: widgetWidth,
              height: 30,
              alignment: Alignment.center,
              child: ComBtn(
                icon: plPlayerController.showDmChart.value
                    ? Icon(
                        Icons.show_chart,
                        size: 22,
                        color: Colors.white,
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.show_chart,
                            size: 22,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.hide_source,
                            size: 22,
                            color: Colors.white,
                          ),
                        ],
                      ),
                onTap: () {
                  plPlayerController.showDmChart.value =
                      !plPlayerController.showDmChart.value;
                },
              ),
            )),

      /// 超分辨率
      BottomControlType.superResolution: Get.parameters['type'] == '1' ||
              Get.parameters['type'] == '4'
          ? Container(
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: PopupMenuButton<SuperResolutionType>(
                initialValue: SuperResolutionType
                    .values[plPlayerController.superResolutionType],
                color: Colors.black.withOpacity(0.8),
                itemBuilder: (BuildContext context) {
                  return SuperResolutionType.values
                      .map((SuperResolutionType type) {
                    return PopupMenuItem<SuperResolutionType>(
                      height: 35,
                      padding: const EdgeInsets.only(left: 30),
                      value: type,
                      onTap: () {
                        plPlayerController.setShader(type.index);
                      },
                      child: Text(
                        type.title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    );
                  }).toList();
                },
                child: Text(
                  SuperResolutionType
                      .values[plPlayerController.superResolutionType].title,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            )
          : const SizedBox.shrink(),

      /// 分段信息
      BottomControlType.viewPoints: Obx(
        () => plPlayerController.viewPointList.isEmpty
            ? const SizedBox.shrink()
            : Container(
                width: widgetWidth,
                height: 30,
                alignment: Alignment.center,
                child: ComBtn(
                  icon: Transform.rotate(
                    angle: pi / 2,
                    child: Icon(
                      MdiIcons.viewHeadline,
                      semanticLabel: '分段信息',
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                  onTap: widget.showViewPoints,
                  onLongPress: () {
                    Feedback.forLongPress(context);
                    plPlayerController.showVP.value =
                        !plPlayerController.showVP.value;
                  },
                ),
              ),
      ),

      /// 选集
      BottomControlType.episode: Container(
        width: widgetWidth,
        height: 30,
        alignment: Alignment.center,
        child: ComBtn(
          icon: const Icon(
            Icons.list,
            semanticLabel: '选集',
            size: 22,
            color: Colors.white,
          ),
          onTap: () {
            if (anySeason.not) {
              widget.showEpisodes?.call();
              return;
            }
            int? index;
            int currentCid = plPlayerController.cid;
            String bvid = plPlayerController.bvid;
            List episodes = [];
            if (isPage) {
              final List<Part> pages =
                  videoIntroController!.videoDetail.value.pages!;
              episodes = pages;
            } else if (isSeason) {
              final List<SectionItem> sections =
                  videoIntroController!.videoDetail.value.ugcSeason!.sections!;
              for (int i = 0; i < sections.length; i++) {
                final List<EpisodeItem> episodesList = sections[i].episodes!;
                for (int j = 0; j < episodesList.length; j++) {
                  if (episodesList[j].cid == plPlayerController.cid) {
                    index = i;
                    episodes = episodesList;
                    break;
                  }
                }
              }
            } else if (isBangumi) {
              episodes = (bangumiIntroController!.loadingState.value as Success)
                  .response
                  .episodes!;
            }
            widget.showEpisodes?.call(
              index,
              isPage ? null : videoIntroController?.videoDetail.value.ugcSeason,
              episodes,
              bvid,
              IdUtils.bv2av(bvid),
              currentCid,
            );
          },
        ),
      ),

      /// 画面比例
      BottomControlType.fit: Container(
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: PopupMenuButton<BoxFit>(
          initialValue: plPlayerController.videoFit.value,
          color: Colors.black.withOpacity(0.8),
          itemBuilder: (BuildContext context) {
            return BoxFit.values.map((BoxFit boxFit) {
              return PopupMenuItem<BoxFit>(
                height: 35,
                padding: const EdgeInsets.only(left: 30),
                value: boxFit,
                onTap: () {
                  plPlayerController.toggleVideoFit(boxFit);
                },
                child: Text(
                  "${PlPlayerController.videoFitType[boxFit.index]['desc']}",
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              );
            }).toList();
          },
          child: Text(
            "${PlPlayerController.videoFitType[plPlayerController.videoFit.value.index]['desc']}",
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ),

      /// 字幕
      BottomControlType.subtitle: Obx(
        () => plPlayerController.vttSubtitles.isEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                width: widgetWidth,
                height: 30,
                child: PopupMenuButton<int>(
                  initialValue: plPlayerController.vttSubtitles.length <
                          plPlayerController.vttSubtitlesIndex.value
                      ? 0
                      : plPlayerController.vttSubtitlesIndex.value,
                  color: Colors.black.withOpacity(0.8),
                  itemBuilder: (BuildContext context) {
                    return plPlayerController.vttSubtitles
                        .asMap()
                        .entries
                        .map((entry) {
                      return PopupMenuItem<int>(
                        value: entry.key,
                        onTap: () {
                          plPlayerController.setSubtitle(entry.key);
                        },
                        child: Text(
                          "${entry.value['title']}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    width: 35,
                    height: 30,
                    alignment: Alignment.center,
                    child: Icon(
                      plPlayerController.vttSubtitlesIndex.value == 0
                          ? Icons.closed_caption_off_outlined
                          : Icons.closed_caption_off_rounded,
                      size: 22,
                      color: Colors.white,
                      semanticLabel: '字幕',
                    ),
                  ),
                ),
              ),
      ),

      /// 播放速度
      BottomControlType.speed: Obx(
        () => Container(
          height: 30,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: PopupMenuButton<double>(
            initialValue: plPlayerController.playbackSpeed,
            color: Colors.black.withOpacity(0.8),
            itemBuilder: (BuildContext context) {
              return plPlayerController.speedList.map((double speed) {
                return PopupMenuItem<double>(
                  height: 35,
                  padding: const EdgeInsets.only(left: 30),
                  value: speed,
                  onTap: () {
                    plPlayerController.setPlaybackSpeed(speed);
                  },
                  child: Text(
                    "${speed}X",
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    semanticsLabel: "$speed倍速",
                  ),
                );
              }).toList();
            },
            child: Text("${plPlayerController.playbackSpeed}X",
                style: const TextStyle(color: Colors.white, fontSize: 13),
                semanticsLabel: "${plPlayerController.playbackSpeed}倍速"),
          ),
        ),
      ),

      /// 全屏
      BottomControlType.fullscreen: SizedBox(
        width: widgetWidth,
        height: 30,
        child: Obx(
          () => ComBtn(
            icon: Icon(
              isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              semanticLabel: isFullScreen ? '退出全屏' : '全屏',
              size: 24,
              color: Colors.white,
            ),
            onTap: () => plPlayerController.triggerFullScreen(
                status: !isFullScreen, duration: 800),
          ),
        ),
      ),
    };

    List<BottomControlType> userSpecifyItemLeft = [
      BottomControlType.playOrPause,
      BottomControlType.time,
      if (anySeason || widget.videoDetailController?.isPlayAll == true) ...[
        BottomControlType.pre,
        BottomControlType.next,
      ],
    ];

    List<BottomControlType> userSpecifyItemRight = [
      BottomControlType.dmChart,
      BottomControlType.superResolution,
      BottomControlType.viewPoints,
      if (anySeason || widget.videoDetailController?.isPlayAll == true)
        BottomControlType.episode,
      if (isFullScreen) BottomControlType.fit,
      BottomControlType.subtitle,
      BottomControlType.speed,
      BottomControlType.fullscreen,
    ];

    return Row(
      children: [
        ...userSpecifyItemLeft.map((item) => videoProgressWidgets[item]!),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => FittedBox(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: userSpecifyItemRight
                      .map((item) => videoProgressWidgets[item]!)
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  PlPlayerController get plPlayerController => widget.plPlayerController;

  bool get isFullScreen => plPlayerController.isFullScreen.value;

  late final transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    final Color colorTheme = Theme.of(context).colorScheme.primary;
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    return Stack(
      fit: StackFit.passthrough,
      key: _playerKey,
      children: <Widget>[
        Obx(
          () => Video(
            fill: widget.fill ?? Colors.black,
            key: key,
            alignment: widget.alignment ?? Alignment.center,
            controller: videoController,
            controls: NoVideoControls,
            pauseUponEnteringBackgroundMode:
                !plPlayerController.continuePlayInBackground.value,
            resumeUponEnteringForegroundMode: true,
            // 字幕尺寸调节
            subtitleViewConfiguration:
                plPlayerController.subtitleViewConfiguration,
            fit: plPlayerController.videoFit.value,
            dmWidget: widget.danmuWidget,
            // transformationController: transformationController,
            // scaleEnabled: !plPlayerController.controlsLock.value,
            // enableShrinkVideoSize: plPlayerController.enableShrinkVideoSize,
            // onInteractionStart: (ScaleStartDetails details) {
            //   if (plPlayerController.controlsLock.value) return;
            //   // 如果起点太靠上则屏蔽
            //   if (details.localFocalPoint.dy < 40) return;
            //   if (details.pointerCount == 2) {
            //     interacting = true;
            //   }
            //   _initialFocalPoint = details.localFocalPoint;
            //   // debugPrint("_initialFocalPoint$_initialFocalPoint");
            //   _gestureType = null;
            // },
            // onInteractionUpdate: (ScaleUpdateDetails details) {
            //   showRestoreScaleBtn.value =
            //       transformationController.value.row0.x != 1.0;
            //   if (interacting || _initialFocalPoint == Offset.zero) return;
            //   Offset cumulativeDelta =
            //       details.localFocalPoint - _initialFocalPoint;
            //   if (details.pointerCount == 2 && cumulativeDelta.distance < 1.5) {
            //     interacting = true;
            //     _gestureType = null;
            //     return;
            //   }

            //   /// 锁定时禁用
            //   if (plPlayerController.controlsLock.value) return;
            //   RenderBox renderBox =
            //       _playerKey.currentContext!.findRenderObject() as RenderBox;

            //   if (_gestureType == null) {
            //     if (cumulativeDelta.distance < 1) return;
            //     if (cumulativeDelta.dx.abs() > 3 * cumulativeDelta.dy.abs()) {
            //       _gestureType = 'horizontal';
            //     } else if (cumulativeDelta.dy.abs() >
            //         3 * cumulativeDelta.dx.abs()) {
            //       // _gestureType = 'vertical';

            //       final double totalWidth = renderBox.size.width;
            //       final double tapPosition = details.localFocalPoint.dx;
            //       final double sectionWidth = totalWidth / 3;
            //       if (tapPosition < sectionWidth) {
            //         if (plPlayerController.enableSlideVolumeBrightness.not) {
            //           return;
            //         }
            //         // 左边区域
            //         _gestureType = 'left';
            //       } else if (tapPosition < sectionWidth * 2) {
            //         // 全屏
            //         _gestureType = 'center';
            //       } else {
            //         if (plPlayerController.enableSlideVolumeBrightness.not) {
            //           return;
            //         }
            //         // 右边区域
            //         _gestureType = 'right';
            //       }
            //     } else {
            //       return;
            //     }
            //   }

            //   Offset delta = details.focalPointDelta;

            //   if (_gestureType == 'horizontal') {
            //     // live模式下禁用
            //     if (plPlayerController.videoType.value == 'live') return;

            //     final int curSliderPosition =
            //         plPlayerController.sliderPosition.value.inMilliseconds;
            //     final double scale = 90000 / renderBox.size.width;
            //     final Duration pos = Duration(
            //         milliseconds:
            //             curSliderPosition + (delta.dx * scale).round());
            //     final Duration result =
            //         pos.clamp(Duration.zero, plPlayerController.duration.value);
            //     final height = renderBox.size.height * 0.125;
            //     if (details.localFocalPoint.dy <= height &&
            //         (details.localFocalPoint.dx >=
            //                 renderBox.size.width * 0.875 ||
            //             details.localFocalPoint.dx <=
            //                 renderBox.size.width * 0.125)) {
            //       plPlayerController.cancelSeek = true;
            //       plPlayerController.showPreview.value = false;
            //       if (plPlayerController.hasToast != true) {
            //         plPlayerController.hasToast = true;
            //         SmartDialog.showAttach(
            //           targetContext: context,
            //           alignment: Alignment.center,
            //           animationTime: const Duration(milliseconds: 200),
            //           animationType: SmartAnimationType.fade,
            //           displayTime: const Duration(milliseconds: 1500),
            //           maskColor: Colors.transparent,
            //           builder: (context) => Container(
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 8, vertical: 4),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(6),
            //               color:
            //                   Theme.of(context).colorScheme.secondaryContainer,
            //             ),
            //             child: Text(
            //               '松开手指，取消进退',
            //               style: TextStyle(
            //                 color: Theme.of(context)
            //                     .colorScheme
            //                     .onSecondaryContainer,
            //               ),
            //             ),
            //           ),
            //         );
            //       }
            //     } else {
            //       if (plPlayerController.cancelSeek == true) {
            //         plPlayerController.cancelSeek = null;
            //         plPlayerController.hasToast = null;
            //       }
            //     }
            //     plPlayerController.onUpdatedSliderProgress(result);
            //     plPlayerController.onChangedSliderStart();
            //     if (plPlayerController.showSeekPreview &&
            //         plPlayerController.cancelSeek != true) {
            //       try {
            //         plPlayerController.previewDx.value = result.inMilliseconds /
            //             plPlayerController
            //                 .durationSeconds.value.inMilliseconds *
            //             renderBox.size.width;
            //         if (plPlayerController.showPreview.value.not) {
            //           plPlayerController.showPreview.value = true;
            //         }
            //       } catch (_) {}
            //     }
            //   } else if (_gestureType == 'left') {
            //     // 左边区域 👈
            //     final double level = renderBox.size.height * 3;
            //     final double brightness =
            //         _brightnessValue.value - delta.dy / level;
            //     final double result = brightness.clamp(0.0, 1.0);
            //     setBrightness(result);
            //   } else if (_gestureType == 'center') {
            //     // 全屏
            //     const double threshold = 2.5; // 滑动阈值
            //     double cumulativeDy =
            //         details.localFocalPoint.dy - _initialFocalPoint.dy;

            //     void fullScreenTrigger(bool status) {
            //       plPlayerController.triggerFullScreen(
            //           status: status, duration: 800);
            //     }

            //     if (cumulativeDy > threshold) {
            //       _gestureType = 'center_down';
            //       if (isFullScreen ^ fullScreenGestureReverse) {
            //         fullScreenTrigger(fullScreenGestureReverse);
            //       }
            //       // debugPrint('center_down:$cumulativeDy');
            //     } else if (cumulativeDy < -threshold) {
            //       _gestureType = 'center_up';
            //       if (!isFullScreen ^ fullScreenGestureReverse) {
            //         fullScreenTrigger(!fullScreenGestureReverse);
            //       }
            //       // debugPrint('center_up:$cumulativeDy');
            //     }
            //   } else if (_gestureType == 'right') {
            //     // 右边区域
            //     final double level = renderBox.size.height * 0.5;
            //     EasyThrottle.throttle(
            //         'setVolume', const Duration(milliseconds: 20), () {
            //       final double volume = _volumeValue.value - delta.dy / level;
            //       final double result = volume.clamp(0.0, 1.0);
            //       setVolume(result);
            //     });
            //   }
            // },
            // onInteractionEnd: (ScaleEndDetails details) {
            //   if (plPlayerController.showSeekPreview) {
            //     plPlayerController.showPreview.value = false;
            //   }
            //   if (plPlayerController.isSliderMoving.value) {
            //     if (plPlayerController.cancelSeek == true) {
            //       plPlayerController.onUpdatedSliderProgress(
            //         plPlayerController.position.value,
            //       );
            //     } else {
            //       plPlayerController.seekTo(
            //         plPlayerController.sliderPosition.value,
            //         type: 'slider',
            //       );
            //     }
            //     plPlayerController.onChangedSliderEnd();
            //   }
            //   interacting = false;
            //   _initialFocalPoint = Offset.zero;
            //   _gestureType = null;
            // },
            // flipX: plPlayerController.flipX.value,
            // flipY: plPlayerController.flipY.value,
          ),
        ),

        // /// 弹幕面板
        // if (widget.danmuWidget != null)
        //   Positioned.fill(top: 4, child: widget.danmuWidget!),

        /// 长按倍速 toast
        Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: FractionalTranslation(
              translation: const Offset(0.0, 0.3), // 上下偏移量（负数向上偏移）
              child: AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: plPlayerController.longPressStatus.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0x88000000),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  height: 32.0,
                  width: 70.0,
                  child: Center(
                    child: Obx(
                      () => Text(
                        '${plPlayerController.enableAutoLongPressSpeed ? (plPlayerController.longPressStatus.value ? plPlayerController.lastPlaybackSpeed : plPlayerController.playbackSpeed) * 2 : plPlayerController.longPressSpeed}倍速中',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        /// 时间进度 toast
        IgnorePointer(
          ignoring: true,
          child: Align(
            alignment: Alignment.topCenter,
            child: FractionalTranslation(
              translation: const Offset(0.0, 1.0), // 上下偏移量（负数向上偏移）
              child: Obx(
                () => AnimatedOpacity(
                  curve: Curves.easeInOut,
                  opacity: plPlayerController.isSliderMoving.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: IntrinsicWidth(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0x88000000),
                        borderRadius: BorderRadius.circular(64.0),
                      ),
                      height: 34.0,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            return Text(
                              Utils.timeFormat(plPlayerController
                                  .sliderTempPosition.value.inSeconds),
                              style: textStyle,
                            );
                          }),
                          const SizedBox(width: 2),
                          const Text('/', style: textStyle),
                          const SizedBox(width: 2),
                          Obx(
                            () => Text(
                              plPlayerController
                                          .durationSeconds.value.inMinutes >=
                                      60
                                  ? printDurationWithHours(
                                      plPlayerController.durationSeconds.value)
                                  : printDuration(
                                      plPlayerController.durationSeconds.value),
                              style: textStyle,
                            ),
                          ),
                        ],
                      ),
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
              () => AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: _volumeIndicator.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0x88000000),
                    borderRadius: BorderRadius.circular(64.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        _volumeValue.value == 0.0
                            ? Icons.volume_off
                            : _volumeValue.value < 0.5
                                ? Icons.volume_down
                                : Icons.volume_up,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      const SizedBox(width: 2.0),
                      Text(
                        '${(_volumeValue.value * 100.0).round()}%',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0x88000000),
                    borderRadius: BorderRadius.circular(64.0),
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

        // Obx(() {
        //   if (_.buffered.value == Duration.zero) {
        //     return Positioned.fill(
        //       child: Container(
        //         color: Colors.black,
        //         child: Center(
        //           child: Image.asset(
        //             'assets/images/loading.gif',
        //             height: 25,
        //           ),
        //         ),
        //       ),
        //     );
        //   } else {
        //     return Container();
        //   }
        // }),

        /// 手势
        Positioned.fill(
          left: 16,
          top: 25,
          right: 15,
          bottom: 15,
          child: Semantics(
            label: '双击开关控件',
            child: GestureDetector(
              onVerticalDragStart: (details) {
                if (plPlayerController.controlsLock.value) return;
                if (details.localPosition.dy < 40) return;
                _initialFocalPoint = details.localPosition;
                _gestureType = null;
              },
              onVerticalDragUpdate: (details) {
                if (plPlayerController.controlsLock.value) return;
                RenderBox renderBox =
                    _playerKey.currentContext!.findRenderObject() as RenderBox;
                final double totalWidth = renderBox.size.width;
                final double tapPosition = details.localPosition.dx;
                final double sectionWidth = totalWidth / 3;
                late String gestureType;
                if (tapPosition < sectionWidth) {
                  if (plPlayerController.enableSlideVolumeBrightness.not) {
                    return;
                  }
                  // 左边区域
                  gestureType = 'left';
                } else if (tapPosition < sectionWidth * 2) {
                  // 全屏
                  gestureType = 'center';
                } else {
                  if (plPlayerController.enableSlideVolumeBrightness.not) {
                    return;
                  }
                  // 右边区域
                  gestureType = 'right';
                }

                if (_gestureType != null && _gestureType != gestureType) {
                  return;
                }
                _gestureType = gestureType;

                if (_gestureType == 'left') {
                  // 左边区域 👈
                  final double level = renderBox.size.height * 3;
                  final double brightness =
                      _brightnessValue.value - details.delta.dy / level;
                  final double result = brightness.clamp(0.0, 1.0);
                  setBrightness(result);
                } else if (_gestureType == 'center') {
                  // 全屏
                  const double threshold = 2.5; // 滑动阈值
                  double cumulativeDy =
                      details.localPosition.dy - _initialFocalPoint.dy;

                  void fullScreenTrigger(bool status) {
                    plPlayerController.triggerFullScreen(status: status);
                  }

                  if (cumulativeDy > threshold) {
                    _gestureType = 'center_down';
                    if (isFullScreen ^ fullScreenGestureReverse) {
                      fullScreenTrigger(fullScreenGestureReverse);
                    }
                    // debugPrint('center_down:$cumulativeDy');
                  } else if (cumulativeDy < -threshold) {
                    _gestureType = 'center_up';
                    if (!isFullScreen ^ fullScreenGestureReverse) {
                      fullScreenTrigger(!fullScreenGestureReverse);
                    }
                    // debugPrint('center_up:$cumulativeDy');
                  }
                } else if (_gestureType == 'right') {
                  // 右边区域
                  final double level = renderBox.size.height * 0.5;
                  EasyThrottle.throttle(
                      'setVolume', const Duration(milliseconds: 20), () {
                    final double volume =
                        _volumeValue.value - details.delta.dy / level;
                    final double result = volume.clamp(0.0, 1.0);
                    setVolume(result);
                  });
                }
              },
              onVerticalDragEnd: (details) {
                interacting = false;
                _initialFocalPoint = Offset.zero;
                _gestureType = null;
              },
              onTap: () {
                plPlayerController.controls =
                    !plPlayerController.showControls.value;
              },
              onDoubleTapDown: (TapDownDetails details) {
                // live模式下禁用 锁定时🔒禁用
                if (plPlayerController.videoType.value == 'live' ||
                    plPlayerController.controlsLock.value) {
                  return;
                }
                RenderBox renderBox =
                    _playerKey.currentContext!.findRenderObject() as RenderBox;
                final double totalWidth = renderBox.size.width;
                final double tapPosition = details.localPosition.dx;
                final double sectionWidth = totalWidth / 4;
                String type = 'left';
                if (tapPosition < sectionWidth) {
                  type = 'left';
                } else if (tapPosition < sectionWidth * 3) {
                  type = 'center';
                } else {
                  type = 'right';
                }
                doubleTapFuc(type);
              },
              onLongPressStart: (LongPressStartDetails detail) {
                plPlayerController.setLongPressStatus(true);
              },
              onLongPressEnd: (LongPressEndDetails details) {
                plPlayerController.setLongPressStatus(false);
              },
            ),
          ),
        ),

        // 头部、底部控制条
        Obx(
          () => Positioned.fill(
            child: ClipRect(
              child: Column(
                children: [
                  if (widget.headerControl != null ||
                      plPlayerController.headerControl != null)
                    AppBarAni(
                      controller: animationController,
                      visible: !plPlayerController.controlsLock.value &&
                          plPlayerController.showControls.value,
                      position: 'top',
                      child: widget.headerControl ??
                          plPlayerController.headerControl!,
                    ),
                  const Spacer(),
                  if (plPlayerController.showControls.value)
                    AppBarAni(
                      controller: animationController,
                      visible: !plPlayerController.controlsLock.value &&
                          plPlayerController.showControls.value,
                      position: 'bottom',
                      child: widget.bottomControl ??
                          BottomControl(
                            controller: plPlayerController,
                            buildBottomControl: buildBottomControl,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // if (BuildConfig.isDebug)
        // Positioned(
        //   right: 25,
        //   top: 125,
        //   child: FilledButton.tonal(
        //     onPressed: () {
        //       transformationController.value = Matrix4.identity()
        //         ..translate(0.5, 0.5)
        //         ..scale(1.2)
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
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer
                                .withOpacity(0.8),
                            visualDensity:
                                VisualDensity(horizontal: -2, vertical: -2),
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () async {
                            showRestoreScaleBtn.value = false;
                            final animController = AnimationController(
                              vsync: this,
                              duration: const Duration(milliseconds: 255),
                            );
                            final anim = Matrix4Tween(
                              begin: transformationController.value,
                              end: Matrix4.identity(),
                            ).animate(
                              CurveTween(curve: Curves.easeOut)
                                  .animate(animController),
                            );
                            void listener() {
                              transformationController.value = anim.value;
                            }

                            animController.addListener(listener);
                            await animController.forward(from: 0);
                            animController.removeListener(listener);
                            animController.dispose();
                          },
                          child: Text('还原屏幕'),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
        ),

        /// 进度条 live模式下禁用
        Obx(
          () {
            final int value = plPlayerController.sliderPositionSeconds.value;
            final int max = plPlayerController.durationSeconds.value.inSeconds;
            final int buffer = plPlayerController.bufferedSeconds.value;
            if (plPlayerController.showControls.value) {
              return const SizedBox.shrink();
            }
            if (defaultBtmProgressBehavior ==
                BtmProgressBehavior.alwaysHide.code) {
              return const SizedBox.shrink();
            }
            if (defaultBtmProgressBehavior ==
                    BtmProgressBehavior.onlyShowFullScreen.code &&
                !isFullScreen) {
              return const SizedBox.shrink();
            } else if (defaultBtmProgressBehavior ==
                    BtmProgressBehavior.onlyHideFullScreen.code &&
                isFullScreen) {
              return const SizedBox.shrink();
            }

            if (plPlayerController.videoType.value == 'live') {
              return const SizedBox.shrink();
            }
            if (value > max || max <= 0) {
              return const SizedBox.shrink();
            }
            return Positioned(
                bottom: -2.2,
                left: 0,
                right: 0,
                child: Semantics(
                  // label: '${(value / max * 100).round()}%',
                  value: '${(value / max * 100).round()}%',
                  // enabled: false,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      if (plPlayerController.dmTrend.isNotEmpty &&
                          plPlayerController.showDmChart.value)
                        buildDmChart(context, plPlayerController),
                      if (plPlayerController.viewPointList.isNotEmpty &&
                          plPlayerController.showVP.value)
                        buildViewPointWidget(plPlayerController, 4.25),
                      IgnorePointer(
                        child: ProgressBar(
                          progress: Duration(seconds: value),
                          buffered: Duration(seconds: buffer),
                          total: Duration(seconds: max),
                          progressBarColor: colorTheme,
                          baseBarColor: Colors.white.withOpacity(0.2),
                          bufferedBarColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.4),
                          timeLabelLocation: TimeLabelLocation.none,
                          thumbColor: colorTheme,
                          barHeight: 3.5,
                          thumbRadius: draggingFixedProgressBar.value ? 7 : 2.5,
                          // onDragStart: (duration) {
                          //   feedBack();
                          //   plPlayerController.onChangedSliderStart();
                          // },
                          // onDragUpdate: (duration) {
                          //   plPlayerController
                          //       .onUpdatedSliderProgress(duration.timeStamp);
                          //   if (plPlayerController.showSeekPreview) {
                          //     if (plPlayerController.showPreview.value.not) {
                          //       plPlayerController.showPreview.value = true;
                          //     }
                          //     plPlayerController.previewDx.value =
                          //         duration.localPosition.dx;
                          //   }
                          // },
                          // onSeek: (duration) {
                          //   if (plPlayerController.showSeekPreview) {
                          //     plPlayerController.showPreview.value = false;
                          //   }
                          //   plPlayerController.onChangedSliderEnd();
                          //   plPlayerController
                          //       .onChangedSlider(duration.inSeconds.toDouble());
                          //   plPlayerController.seekTo(
                          //       Duration(seconds: duration.inSeconds),
                          //       type: 'slider');
                          // },
                        ),
                      ),
                      if (plPlayerController.segmentList.isNotEmpty)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0.75,
                          child: IgnorePointer(
                            child: CustomPaint(
                              size: Size(double.infinity, 3.5),
                              painter: SegmentProgressBar(
                                segmentColors: plPlayerController.segmentList,
                              ),
                            ),
                          ),
                        ),
                      if (plPlayerController.viewPointList.isNotEmpty &&
                          plPlayerController.showVP.value)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0.75,
                          child: IgnorePointer(
                            child: CustomPaint(
                              size: Size(double.infinity, 3.5),
                              painter: SegmentProgressBar(
                                segmentColors: plPlayerController.viewPointList,
                              ),
                            ),
                          ),
                        ),
                      if (plPlayerController.showSeekPreview)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 12,
                          child: buildSeekPreviewWidget(plPlayerController),
                        ),
                    ],
                  ),
                  // SlideTransition(
                  //     position: Tween<Offset>(
                  //       begin: Offset.zero,
                  //       end: const Offset(0, -1),
                  //     ).animate(CurvedAnimation(
                  //       parent: animationController,
                  //       curve: Curves.easeInOut,
                  //     )),
                  //     child: ),
                ));
          },
        ),

        // 锁
        Obx(
          () => Visibility(
            visible:
                plPlayerController.videoType.value != 'live' && isFullScreen,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionalTranslation(
                translation: const Offset(1, -0.4),
                child: Visibility(
                  visible: plPlayerController.showControls.value &&
                      (isFullScreen || plPlayerController.controlsLock.value),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0x45000000),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ComBtn(
                      icon: Icon(
                        plPlayerController.controlsLock.value
                            ? FontAwesomeIcons.lock
                            : FontAwesomeIcons.lockOpen,
                        semanticLabel:
                            plPlayerController.controlsLock.value ? '解锁' : '锁定',
                        size: 15,
                        color: Colors.white,
                      ),
                      onTap: () => plPlayerController.onLockControl(
                          !plPlayerController.controlsLock.value),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 截图
        Obx(
          () => Align(
            alignment: Alignment.centerRight,
            child: FractionalTranslation(
              translation: const Offset(-1, -0.4),
              child: Visibility(
                visible: plPlayerController.showControls.value && isFullScreen,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0x45000000),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ComBtn(
                    icon: const Icon(
                      Icons.photo_camera,
                      semanticLabel: '截图',
                      size: 20,
                      color: Colors.white,
                    ),
                    onTap: () {
                      SmartDialog.showToast('截图中');
                      plPlayerController.videoPlayerController
                          ?.screenshot(format: 'image/png')
                          .then((value) {
                        if (value != null && context.mounted) {
                          SmartDialog.showToast('点击弹窗保存截图');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                // title: const Text('点击保存'),
                                titlePadding: EdgeInsets.zero,
                                contentPadding: const EdgeInsets.all(8),
                                insetPadding:
                                    EdgeInsets.only(left: context.width / 2),
                                //移除圆角
                                shape: const RoundedRectangleBorder(),
                                content: GestureDetector(
                                  onTap: () async {
                                    String name = DateTime.now().toString();
                                    final SaveResult result =
                                        await SaverGallery.saveImage(
                                      value,
                                      fileName: name,
                                      androidRelativePath:
                                          "Pictures/Screenshots",
                                      skipIfExists: false,
                                    );

                                    if (result.isSuccess) {
                                      Get.back();
                                      SmartDialog.showToast(
                                          '$name.png已保存到相册/截图');
                                    } else {
                                      await SmartDialog.showToast(
                                          '保存失败，${result.errorMessage}');
                                    }
                                  },
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: context.width / 3,
                                      maxHeight: context.height / 3,
                                    ),
                                    child: Image.memory(value),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          SmartDialog.showToast('截图失败');
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        //
        Obx(() {
          if (plPlayerController.dataStatus.loading ||
              plPlayerController.isBuffering.value) {
            return Center(
                child: GestureDetector(
                    onTap: () {
                      plPlayerController.refreshPlayer();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Colors.black26, Colors.transparent],
                        ),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Image.asset(
                          'assets/images/loading.gif',
                          height: 25,
                          semanticLabel: "加载中",
                        ),
                        if (plPlayerController.isBuffering.value)
                          Obx(() {
                            if (plPlayerController.buffered.value ==
                                Duration.zero) {
                              return const Text('加载中...',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12));
                            }
                            String bufferStr =
                                plPlayerController.buffered.toString();
                            return Text(
                              bufferStr.substring(0, bufferStr.length - 3),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            );
                          }),
                      ]),
                    )));
          } else {
            return const SizedBox.shrink();
          }
        }),

        /// 点击 快进/快退
        Obx(
          () => _mountSeekBackwardButton.value || _mountSeekForwardButton.value
              ? Positioned.fill(
                  child: Row(
                    children: [
                      if (_mountSeekBackwardButton.value)
                        Expanded(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: child,
                            ),
                            child: BackwardSeekIndicator(
                              onSubmitted: (Duration value) {
                                _mountSeekBackwardButton.value = false;
                                final Player player = widget
                                    .plPlayerController.videoPlayerController!;
                                Duration result = player.state.position - value;
                                result = result.clamp(
                                  Duration.zero,
                                  player.state.duration,
                                );
                                plPlayerController.seekTo(
                                  result,
                                  type: 'slider',
                                );
                                plPlayerController.play();
                              },
                            ),
                          ),
                        ),
                      const Spacer(flex: 2),
                      if (_mountSeekForwardButton.value)
                        Expanded(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: child,
                            ),
                            child: ForwardSeekIndicator(
                              onSubmitted: (Duration value) {
                                _mountSeekForwardButton.value = false;
                                final Player player = widget
                                    .plPlayerController.videoPlayerController!;
                                Duration result = player.state.position + value;
                                result = result.clamp(
                                  Duration.zero,
                                  player.state.duration,
                                );
                                plPlayerController.seekTo(
                                  result,
                                  type: 'slider',
                                );
                                plPlayerController.play();
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

Widget buildDmChart(
  BuildContext context,
  PlPlayerController plPlayerController, [
  double offset = 0,
]) {
  return IgnorePointer(
    child: Container(
      height: 12,
      margin: EdgeInsets.only(
        bottom: plPlayerController.viewPointList.isNotEmpty &&
                plPlayerController.showVP.value
            ? 20.25 + offset
            : 4.25 + offset,
      ),
      child: LineChart(
        LineChartData(
          titlesData: const FlTitlesData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (plPlayerController.dmTrend.length - 1).toDouble(),
          minY: 0,
          maxY: plPlayerController.dmTrend
              .reduce((a, b) => a > b ? a : b)
              .toDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                plPlayerController.dmTrend.length,
                (index) => FlSpot(
                  index.toDouble(),
                  plPlayerController.dmTrend[index].toDouble(),
                ),
              ),
              isCurved: true,
              barWidth: 1,
              color: Theme.of(context).colorScheme.primary,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildSeekPreviewWidget(PlPlayerController plPlayerController) {
  return Obx(() {
    if (plPlayerController.showPreview.value.not) {
      return SizedBox.shrink(
        key: ValueKey(plPlayerController.previewDx.value),
      );
    }
    if (plPlayerController.videoShot == null) {
      plPlayerController.getVideoShot();
      return SizedBox.shrink(
        key: ValueKey(plPlayerController.previewDx.value),
      );
    } else if (plPlayerController.videoShot!['status'] == false) {
      return SizedBox.shrink(
        key: ValueKey(plPlayerController.previewDx.value),
      );
    }

    return LayoutBuilder(
        key: ValueKey(plPlayerController.previewDx.value),
        builder: (context, constraints) {
          try {
            double scale = plPlayerController.isFullScreen.value &&
                    plPlayerController.direction.value == 'horizontal'
                ? 4
                : 2.5;
            // offset
            double left = (plPlayerController.previewDx.value - 48 * scale / 2)
                .clamp(8, constraints.maxWidth - 48 * scale - 8);

            // index
            // int index = plPlayerController.sliderPositionSeconds.value ~/ 5;
            int index = max(
                0,
                (List<int>.from(plPlayerController.videoShot!['data']['index'])
                        .where((item) =>
                            item <=
                            plPlayerController.sliderPositionSeconds.value)
                        .length -
                    2));

            // pageIndex
            int pageIndex = (index ~/ 100).clamp(
              0,
              (plPlayerController.videoShot!['data']['image'] as List).length,
            );

            // alignment
            double cal(m) {
              return -1 + 2 / 9 * m;
            }

            int align = index % 100;
            int x = align % 10;
            int y = align ~/ 10;
            double dx = cal(x);
            double dy = cal(y);
            Alignment alignment = Alignment(dx, dy);

            // url
            String parseUrl(String url) {
              return url.startsWith('//') ? 'https:$url' : url;
            }

            return Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: left),
              child: UnconstrainedBox(
                child: ClipRRect(
                  // clipBehavior: Clip.antiAlias,
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     color: Colors.white,
                  //     strokeAlign: BorderSide.strokeAlignOutside,
                  //   ),
                  //   borderRadius: BorderRadius.circular(scale == 2.5 ? 6 : 10),
                  // ),
                  borderRadius: BorderRadius.circular(scale == 2.5 ? 6 : 10),
                  child: Align(
                    widthFactor: 0.1,
                    heightFactor: 0.1,
                    alignment: alignment,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      width: 480 * scale,
                      height: 270 * scale,
                      imageUrl: parseUrl(plPlayerController.videoShot!['data']
                          ['image'][pageIndex]),
                    ),
                  ),
                ),
              ),
            );
          } catch (e) {
            debugPrint('seek preview: $e');
            return SizedBox.shrink(
              key: ValueKey(plPlayerController.previewDx.value),
            );
          }
        });
  });
}

Widget buildViewPointWidget(
    PlPlayerController plPlayerController, double offset) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        height: 16,
        margin: EdgeInsets.only(bottom: offset),
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) {
            try {
              double seg = event.localPosition.dx / constraints.maxWidth;
              Segment item = plPlayerController.viewPointList.where((item) {
                return item.start >= seg;
              }).reduce((a, b) => a.start < b.start ? a : b);
              if (item.from != null) {
                plPlayerController.danmakuController?.clear();
                plPlayerController.videoPlayerController
                    ?.seek(Duration(seconds: item.from!));
              }
              // debugPrint('${item.title},,${item.from}');
            } catch (e) {
              debugPrint('$e');
            }
          },
        ),
      );
    },
  );
}
