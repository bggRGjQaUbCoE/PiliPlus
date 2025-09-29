import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/progress_bar/audio_video_progress_bar.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';
import 'package:PiliPlus/models_new/video/video_detail/section.dart';
import 'package:PiliPlus/models_new/video/video_detail/ugc_season.dart';
import 'package:PiliPlus/models_new/video/video_shot/data.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/post_panel/popup_menu_text.dart';
import 'package:PiliPlus/pages/video/post_panel/view.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_control_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_progress_behavior.dart';
import 'package:PiliPlus/plugin/pl_player/models/double_tap_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/gesture_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/app_bar_ani.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/backward_seek.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/bottom_control.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/common_btn.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/forward_seek.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/mpv_convert_webp.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/play_pause_btn.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';
import 'package:window_manager/window_manager.dart';

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
    this.customWidget,
    this.customWidgets,
    this.showEpisodes,
    this.showViewPoints,
    this.fill,
    this.alignment,
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

  // List<Widget> or Widget

  final Widget? customWidget;
  final List<Widget>? customWidgets;
  final void Function([int?, UgcSeason?, dynamic, String?, int?, int?])?
  showEpisodes;
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
  late final CommonIntroController introController = widget.introController!;
  late final VideoDetailController videoDetailController =
      widget.videoDetailController!;

  final GlobalKey _playerKey = GlobalKey();
  final GlobalKey<VideoState> key = GlobalKey<VideoState>();

  final RxDouble _brightnessValue = 0.0.obs;
  final RxBool _brightnessIndicator = false.obs;
  Timer? _brightnessTimer;

  late FullScreenMode mode;

  late final RxBool showRestoreScaleBtn = false.obs;

  Offset _initialFocalPoint = Offset.zero;
  GestureType? _gestureType;

  //播放器放缩
  bool interacting = false;

  // 是否在调整固定进度条
  RxBool draggingFixedProgressBar = false.obs;

  // 阅读器限制
  // Timer? _accessibilityDebounce;
  // double _lastAnnouncedValue = -1;

  StreamSubscription? _listener;
  StreamSubscription? _controlsListener;

  @override
  void initState() {
    super.initState();
    _controlsListener = plPlayerController.showControls.listen((bool val) {
      final visible = val && !plPlayerController.controlsLock.value;
      if (widget.videoDetailController?.headerCtrKey.currentState?.provider
          case final provider?) {
        provider
          ..startIfNeeded()
          ..muted = !visible;
      }
      if (visible) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    videoController = plPlayerController.videoController!;

    if (Utils.isMobile) {
      Future.microtask(() async {
        try {
          FlutterVolumeController.updateShowSystemUI(true);
          plPlayerController.volume.value =
              (await FlutterVolumeController.getVolume())!;
          FlutterVolumeController.addListener((double value) {
            if (mounted &&
                !plPlayerController.volumeInterceptEventStream.value) {
              plPlayerController.volume.value = value;
              if (Platform.isIOS && !FlutterVolumeController.showSystemUI) {
                plPlayerController
                  ..volumeIndicator.value = true
                  ..volumeTimer?.cancel()
                  ..volumeTimer = Timer(const Duration(milliseconds: 800), () {
                    if (mounted) {
                      plPlayerController.volumeIndicator.value = false;
                    }
                  });
              }
            }
          });
        } catch (_) {}
      });

      Future.microtask(() async {
        try {
          _brightnessValue.value =
              await ScreenBrightnessPlatform.instance.application;
          _listener = ScreenBrightnessPlatform
              .instance
              .onApplicationScreenBrightnessChanged
              .listen((double value) {
                if (mounted) {
                  _brightnessValue.value = value;
                }
              });
        } catch (_) {}
      });
    }
  }

  Future<void> setBrightness(double value) async {
    try {
      await ScreenBrightnessPlatform.instance.setApplicationScreenBrightness(
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
    _listener?.cancel();
    _controlsListener?.cancel();
    animationController.dispose();
    if (Utils.isMobile) {
      FlutterVolumeController.removeListener();
    }
    transformationController.dispose();
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
      BottomControlType.time => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 播放时间
          Obx(
            () => Text(
              DurationUtils.formatDuration(
                plPlayerController.positionSeconds.value,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                height: 1.4,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Obx(
            () => Text(
              DurationUtils.formatDuration(
                plPlayerController.durationSeconds.value.inSeconds,
              ),
              style: const TextStyle(
                color: Color(0xFFD0D0D0),
                fontSize: 10,
                height: 1.4,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),

      /// 高能进度条
      BottomControlType.dmChart => Obx(
        () {
          final list = videoDetailController.dmTrend.value?.dataOrNull;
          if (list != null && list.isNotEmpty) {
            return ComBtn(
              width: widgetWidth,
              height: 30,
              tooltip: '高能进度条',
              icon: videoDetailController.showDmTreandChart.value
                  ? const Icon(
                      Icons.show_chart,
                      size: 22,
                      color: Colors.white,
                    )
                  : const Stack(
                      clipBehavior: Clip.none,
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
              onTap: () => videoDetailController.showDmTreandChart.value =
                  !videoDetailController.showDmTreandChart.value,
            );
          }
          return const SizedBox.shrink();
        },
      ),

      /// 超分辨率
      BottomControlType.superResolution => Obx(
        () => PopupMenuButton<SuperResolutionType>(
          tooltip: '超分辨率',
          requestFocus: false,
          initialValue: plPlayerController.superResolutionType.value,
          color: Colors.black.withValues(alpha: 0.8),
          itemBuilder: (context) {
            return SuperResolutionType.values
                .map(
                  (type) => PopupMenuItem<SuperResolutionType>(
                    height: 35,
                    padding: const EdgeInsets.only(left: 30),
                    value: type,
                    onTap: () => plPlayerController.setShader(type),
                    child: Text(
                      type.title,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                )
                .toList();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              plPlayerController.superResolutionType.value.title,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ),

      /// 分段信息
      BottomControlType.viewPoints => Obx(
        () => videoDetailController.viewPointList.isEmpty
            ? const SizedBox.shrink()
            : ComBtn(
                width: widgetWidth,
                height: 30,
                tooltip: '分段信息',
                icon: Transform.rotate(
                  angle: math.pi / 2,
                  child: const Icon(
                    MdiIcons.viewHeadline,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
                onTap: widget.showViewPoints,
                onLongPress: Utils.isMobile
                    ? () {
                        Feedback.forLongPress(context);
                        videoDetailController.showVP.value =
                            !videoDetailController.showVP.value;
                      }
                    : null,
                onSecondaryTap: Utils.isMobile
                    ? null
                    : () => videoDetailController.showVP.value =
                          !videoDetailController.showVP.value,
              ),
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
          // part -> playAll -> season(pgc)
          if (isPlayAll && !isPart) {
            widget.showEpisodes?.call();
            return;
          }
          int? index;
          int currentCid = plPlayerController.cid;
          String bvid = plPlayerController.bvid;
          List episodes = [];
          if (isSeason) {
            final List<SectionItem> sections = videoDetail.ugcSeason!.sections!;
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
        () => PopupMenuButton<VideoFitType>(
          tooltip: '画面比例',
          requestFocus: false,
          initialValue: plPlayerController.videoFit.value,
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
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                )
                .toList();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              plPlayerController.videoFit.value.desc,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ),

      BottomControlType.aiTranslate => Obx(
        () {
          final list = videoDetailController.languages.value;
          if (list != null && list.isNotEmpty) {
            return PopupMenuButton<String>(
              tooltip: '原声翻译',
              requestFocus: false,
              initialValue: videoDetailController.currLang.value,
              color: Colors.black.withValues(alpha: 0.8),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<String>(
                    value: '',
                    onTap: () => videoDetailController.setLanguage(''),
                    child: const Text(
                      "关闭翻译",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ...list.map((e) {
                    return PopupMenuItem<String>(
                      value: e.lang,
                      onTap: () => videoDetailController.setLanguage(e.lang!),
                      child: Text(
                        e.title!,
                        style: const TextStyle(color: Colors.white),
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
        () => videoDetailController.subtitles.isEmpty == true
            ? const SizedBox.shrink()
            : PopupMenuButton<int>(
                tooltip: '字幕',
                requestFocus: false,
                initialValue: videoDetailController.vttSubtitlesIndex.value
                    .clamp(
                      0,
                      videoDetailController.subtitles.length,
                    ),
                color: Colors.black.withValues(alpha: 0.8),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      onTap: () => videoDetailController.setSubtitle(0),
                      child: const Text(
                        "关闭字幕",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ...videoDetailController.subtitles.indexed.map((e) {
                      return PopupMenuItem<int>(
                        value: e.$1 + 1,
                        onTap: () =>
                            videoDetailController.setSubtitle(e.$1 + 1),
                        child: Text(
                          "${e.$2.lanDoc}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                  ];
                },
                child: SizedBox(
                  width: widgetWidth,
                  height: 30,
                  child: videoDetailController.vttSubtitlesIndex.value == 0
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
              ),
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
          final VideoQuality currentVideoQa =
              videoDetailController.currentVideoQa.value;
          final PlayUrlModel videoInfo = videoDetailController.data;
          if (videoInfo.dash == null) {
            return const SizedBox.shrink();
          }
          final List<FormatItem> videoFormat = videoInfo.supportFormats!;
          final int totalQaSam = videoFormat.length;
          int userfulQaSam = 0;
          final List<VideoItem> video = videoInfo.dash!.video!;
          final Set<int> idSet = {};
          for (final VideoItem item in video) {
            final int id = item.id!;
            if (!idSet.contains(id)) {
              idSet.add(id);
              userfulQaSam++;
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
                  final enabled = index >= totalQaSam - userfulQaSam;
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
                        ..currentVideoQa.value = newQa
                        ..updatePlayer();

                      SmartDialog.showToast("画质已变为：${newQa.desc}");

                      // update
                      if (!plPlayerController.tempPlayerConf) {
                        GStorage.setting.put(
                          await Utils.isWiFi
                              ? SettingBoxKey.defaultVideoQa
                              : SettingBoxKey.defaultVideoQaCellular,
                          quality,
                        );
                      }
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
      ),
    };

    List<BottomControlType> userSpecifyItemLeft = [
      BottomControlType.playOrPause,
      BottomControlType.time,
      if (anySeason) ...[
        BottomControlType.pre,
        BottomControlType.next,
      ],
    ];

    final flag =
        isFullScreen || plPlayerController.isDesktopPip || maxWidth >= 500;
    List<BottomControlType> userSpecifyItemRight = [
      if (plPlayerController.showDmChart) BottomControlType.dmChart,
      if (plPlayerController.isAnim) BottomControlType.superResolution,
      if (plPlayerController.showViewPoints) BottomControlType.viewPoints,
      if (anySeason) BottomControlType.episode,
      if (flag) BottomControlType.fit,
      BottomControlType.aiTranslate,
      BottomControlType.subtitle,
      BottomControlType.speed,
      if (flag) BottomControlType.qa,
      BottomControlType.fullscreen,
    ];

    return Row(
      children: [
        ...userSpecifyItemLeft.map(progressWidget),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => FittedBox(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: userSpecifyItemRight.map(progressWidget).toList(),
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

  late ThemeData theme;
  late double maxWidth;
  late double maxHeight;

  void _onInteractionStart(ScaleStartDetails details) {
    if (plPlayerController.controlsLock.value) return;
    // 如果起点太靠上则屏蔽
    if (details.localFocalPoint.dy < 40) return;
    if (details.localFocalPoint.dx < 40) return;
    if (details.localFocalPoint.dx > maxWidth - 40) return;
    if (details.localFocalPoint.dy > maxHeight - 40) return;
    if (details.pointerCount == 2) {
      interacting = true;
    }
    _initialFocalPoint = details.localFocalPoint;
    // if (kDebugMode) {
    //   debugPrint("_initialFocalPoint$_initialFocalPoint");
    // }
    _gestureType = null;
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    showRestoreScaleBtn.value = transformationController.value.row0.x != 1.0;
    if (interacting || _initialFocalPoint == Offset.zero) return;
    Offset cumulativeDelta = details.localFocalPoint - _initialFocalPoint;
    if (details.pointerCount == 2 && cumulativeDelta.distance < 1.5) {
      interacting = true;
      _gestureType = null;
      return;
    }

    /// 锁定时禁用
    if (plPlayerController.controlsLock.value) return;

    if (_gestureType == null) {
      if (cumulativeDelta.distance < 1) return;
      if (cumulativeDelta.dx.abs() > 3 * cumulativeDelta.dy.abs()) {
        _gestureType = GestureType.horizontal;
        if (Utils.isMobile) {
          late final isFullScreen = this.isFullScreen;
          final progressType = plPlayerController.progressType;
          if (progressType == BtmProgressBehavior.alwaysHide ||
              (isFullScreen &&
                  progressType == BtmProgressBehavior.onlyHideFullScreen) ||
              (!isFullScreen &&
                  progressType == BtmProgressBehavior.onlyShowFullScreen)) {
            plPlayerController.controls = true;
          }
        }
      } else if (cumulativeDelta.dy.abs() > 3 * cumulativeDelta.dx.abs()) {
        if (!plPlayerController.enableSlideVolumeBrightness &&
            !plPlayerController.enableSlideFS) {
          return;
        }

        // _gestureType = 'vertical';

        final double tapPosition = details.localFocalPoint.dx;
        final double sectionWidth = maxWidth / 3;
        if (tapPosition < sectionWidth) {
          if (Utils.isDesktop ||
              !plPlayerController.enableSlideVolumeBrightness) {
            return;
          }
          // 左边区域
          _gestureType = GestureType.left;
        } else if (tapPosition < sectionWidth * 2) {
          if (!plPlayerController.enableSlideFS) {
            return;
          }
          // 全屏
          _gestureType = GestureType.center;
        } else {
          if (!plPlayerController.enableSlideVolumeBrightness) {
            return;
          }
          // 右边区域
          _gestureType = GestureType.right;
        }
      } else {
        return;
      }
    }

    Offset delta = details.focalPointDelta;

    if (_gestureType == GestureType.horizontal) {
      // live模式下禁用
      if (plPlayerController.isLive) return;

      final int curSliderPosition =
          plPlayerController.sliderPosition.value.inMilliseconds;
      final int newPos =
          (curSliderPosition +
                  (plPlayerController.sliderScale * delta.dx / maxWidth)
                      .round())
              .clamp(
                0,
                plPlayerController.duration.value.inMilliseconds,
              );
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
                color: theme.colorScheme.secondaryContainer,
              ),
              child: Text(
                '松开手指，取消进退',
                style: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
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
      if (plPlayerController.showSeekPreview &&
          plPlayerController.cancelSeek != true) {
        plPlayerController.updatePreviewIndex(newPos ~/ 1000);
      }
    } else if (_gestureType == GestureType.left) {
      // 左边区域 👈
      final double level = maxHeight * 3;
      final double brightness = _brightnessValue.value - delta.dy / level;
      final double result = brightness.clamp(0.0, 1.0);
      setBrightness(result);
    } else if (_gestureType == GestureType.center) {
      // 全屏
      const double threshold = 2.5; // 滑动阈值
      double cumulativeDy = details.localFocalPoint.dy - _initialFocalPoint.dy;

      void fullScreenTrigger(bool status) {
        plPlayerController.triggerFullScreen(status: status);
      }

      if (cumulativeDy > threshold) {
        _gestureType = GestureType.center_down;
        if (isFullScreen ^ plPlayerController.fullScreenGestureReverse) {
          fullScreenTrigger(
            plPlayerController.fullScreenGestureReverse,
          );
        }
        // if (kDebugMode) debugPrint('center_down:$cumulativeDy');
      } else if (cumulativeDy < -threshold) {
        _gestureType = GestureType.center_up;
        if (!isFullScreen ^ plPlayerController.fullScreenGestureReverse) {
          fullScreenTrigger(
            !plPlayerController.fullScreenGestureReverse,
          );
        }
        // if (kDebugMode) debugPrint('center_up:$cumulativeDy');
      }
    } else if (_gestureType == GestureType.right) {
      // 右边区域
      final double level = maxHeight * 0.5;
      EasyThrottle.throttle(
        'setVolume',
        const Duration(milliseconds: 20),
        () {
          final double volume = clampDouble(
            plPlayerController.volume.value - delta.dy / level,
            0.0,
            1.0,
          );
          plPlayerController.setVolume(volume);
        },
      );
    }
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    if (plPlayerController.showSeekPreview) {
      plPlayerController.showPreview.value = false;
    }
    if (plPlayerController.isSliderMoving.value) {
      if (plPlayerController.cancelSeek == true) {
        plPlayerController.onUpdatedSliderProgress(
          plPlayerController.position.value,
        );
      } else {
        plPlayerController.seekTo(
          plPlayerController.sliderPosition.value,
          isSeek: false,
        );
      }
      plPlayerController.onChangedSliderEnd();
    }
    interacting = false;
    _initialFocalPoint = Offset.zero;
    _gestureType = null;
  }

  void onDoubleTapDownMobile(TapDownDetails details) {
    if (plPlayerController.controlsLock.value) {
      return;
    }
    if (plPlayerController.isLive) {
      plPlayerController.doubleTapFuc(DoubleTapType.center);
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

  void onTapDesktop() {
    if (plPlayerController.controlsLock.value) {
      return;
    }
    plPlayerController.onDoubleTapCenter();
  }

  void onDoubleTapDesktop() {
    if (plPlayerController.controlsLock.value) {
      return;
    }
    plPlayerController.triggerFullScreen(status: !isFullScreen);
  }

  void onTap(PointerDeviceKind? kind) {
    switch (kind) {
      case ui.PointerDeviceKind.mouse:
        onTapDesktop();
        break;
      default:
        plPlayerController.controls = !plPlayerController.showControls.value;
        break;
    }
  }

  void onDoubleTapDown(TapDownDetails details) {
    switch (details.kind) {
      case ui.PointerDeviceKind.mouse:
        onDoubleTapDesktop();
        break;
      default:
        onDoubleTapDownMobile(details);
        break;
    }
  }

  final isMobile = Utils.isMobile;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    maxWidth = widget.maxWidth;
    maxHeight = widget.maxHeight;
    final Color primary = theme.colorScheme.primary;
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    final isFullScreen = this.isFullScreen;
    final isLive = plPlayerController.isLive;

    final child = Stack(
      fit: StackFit.passthrough,
      key: _playerKey,
      children: <Widget>[
        Obx(
          () {
            final videoFit = plPlayerController.videoFit.value;
            return Video(
              key: key,
              width: maxWidth,
              height: maxHeight,
              fill: widget.fill ?? Colors.black,
              alignment: widget.alignment ?? Alignment.center,
              controller: videoController,
              controls: NoVideoControls,
              pauseUponEnteringBackgroundMode:
                  !plPlayerController.continuePlayInBackground.value,
              resumeUponEnteringForegroundMode: true,
              // 字幕尺寸调节
              subtitleViewConfiguration: isLive
                  ? const SubtitleViewConfiguration()
                  : plPlayerController.subtitleConfig.value,
              fit: videoFit.boxFit,
              aspectRatio: videoFit.aspectRatio,
              dmWidget: widget.danmuWidget,
              transformationController: transformationController,
              scaleEnabled:
                  !Utils.isDesktop && !plPlayerController.controlsLock.value,
              enableShrinkVideoSize:
                  !Utils.isDesktop && plPlayerController.enableShrinkVideoSize,
              onInteractionStart: _onInteractionStart,
              onInteractionUpdate: _onInteractionUpdate,
              onInteractionEnd: _onInteractionEnd,
              flipX: plPlayerController.flipX.value,
              flipY: plPlayerController.flipY.value,
              onTap: onTap,
              onDoubleTapDown: onDoubleTapDown,
              onLongPressStart: isLive
                  ? null
                  : (_) => plPlayerController.setLongPressStatus(true),
              onLongPressEnd: isLive
                  ? null
                  : (_) => plPlayerController.setLongPressStatus(false),
              enableDragSubtitle: plPlayerController.enableDragSubtitle,
              onUpdatePadding: plPlayerController.onUpdatePadding,
            );
          },
        ),

        // /// 弹幕面板
        // if (widget.danmuWidget != null)
        //   Positioned.fill(top: 4, child: widget.danmuWidget!),

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
                          '${plPlayerController.enableAutoLongPressSpeed ? (plPlayerController.longPressStatus.value ? plPlayerController.lastPlaybackSpeed : plPlayerController.playbackSpeed) * 2 : plPlayerController.longPressSpeed}倍速中',
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
                                  plPlayerController
                                      .durationSeconds
                                      .value
                                      .inSeconds,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBarAni(
                  isTop: true,
                  controller: animationController,
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
                  controller: animationController,
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
                        backgroundColor: theme.colorScheme.secondaryContainer
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
                        final anim =
                            Matrix4Tween(
                              begin: transformationController.value,
                              end: Matrix4.identity(),
                            ).animate(
                              CurveTween(
                                curve: Curves.easeOut,
                              ).animate(animController),
                            );
                        void listener() {
                          transformationController.value = anim.value;
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
        if (!isLive &&
            plPlayerController.progressType != BtmProgressBehavior.alwaysHide)
          Positioned(
            bottom: -2.2,
            left: 0,
            right: 0,
            child: Obx(
              () {
                if (plPlayerController.showControls.value) {
                  return const SizedBox.shrink();
                }

                switch (plPlayerController.progressType) {
                  case BtmProgressBehavior.onlyShowFullScreen:
                    if (!isFullScreen) {
                      return const SizedBox.shrink();
                    }
                  case BtmProgressBehavior.onlyHideFullScreen:
                    if (isFullScreen) {
                      return const SizedBox.shrink();
                    }
                  default:
                }

                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    IgnorePointer(
                      child: Obx(() {
                        final int value =
                            plPlayerController.sliderPositionSeconds.value;
                        final int max =
                            plPlayerController.durationSeconds.value.inSeconds;
                        final int buffer =
                            plPlayerController.bufferedSeconds.value;
                        if (value > max || max <= 0) {
                          return const SizedBox.shrink();
                        }
                        return ProgressBar(
                          progress: Duration(seconds: value),
                          buffered: Duration(seconds: buffer),
                          total: Duration(seconds: max),
                          progressBarColor: primary,
                          baseBarColor: Colors.white.withValues(alpha: 0.2),
                          bufferedBarColor: primary.withValues(alpha: 0.4),
                          timeLabelLocation: TimeLabelLocation.none,
                          thumbColor: primary,
                          barHeight: 3.5,
                          thumbRadius: draggingFixedProgressBar.value ? 7 : 2.5,
                        );
                      }),
                    ),
                    if (plPlayerController.enableSponsorBlock &&
                        videoDetailController.segmentProgressList.isNotEmpty)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0.75,
                        child: IgnorePointer(
                          child: RepaintBoundary(
                            child: CustomPaint(
                              key: const Key('segmentList'),
                              size: const Size(double.infinity, 3.5),
                              painter: SegmentProgressBar(
                                segmentColors:
                                    videoDetailController.segmentProgressList,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (plPlayerController.showViewPoints &&
                        videoDetailController.viewPointList.isNotEmpty &&
                        videoDetailController.showVP.value) ...[
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0.75,
                        child: IgnorePointer(
                          child: RepaintBoundary(
                            child: CustomPaint(
                              key: const Key('viewPointList'),
                              size: const Size(double.infinity, 3.5),
                              painter: SegmentProgressBar(
                                segmentColors:
                                    videoDetailController.viewPointList,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (isMobile)
                        buildViewPointWidget(
                          videoDetailController,
                          plPlayerController,
                          4.25,
                          maxWidth,
                        ),
                    ],
                    if (plPlayerController.showDmChart &&
                        videoDetailController.showDmTreandChart.value)
                      if (videoDetailController.dmTrend.value?.dataOrNull
                          case final list?)
                        buildDmChart(theme, list, videoDetailController),
                  ],
                );
              },
            ),
          ),

        if (!isLive && plPlayerController.showSeekPreview)
          buildSeekPreviewWidget(
            plPlayerController,
            maxWidth,
            maxHeight,
          ),

        // 锁
        if (!isLive &&
            plPlayerController.showFsLockBtn &&
            (isFullScreen || plPlayerController.isDesktopPip))
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
        if (isFullScreen && plPlayerController.showFsScreenshotBtn)
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
                        onLongPress:
                            (Platform.isAndroid || kDebugMode) && !isLive
                            ? screenshotWebp
                            : null,
                        onTap: plPlayerController.takeScreenshot,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        Obx(() {
          if (plPlayerController.dataStatus.loading ||
              plPlayerController.isBuffering.value) {
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
                        'assets/images/loading.webp',
                        height: 25,
                        semanticLabel: "加载中",
                        color: Colors.white,
                      ),
                      if (plPlayerController.isBuffering.value)
                        Obx(() {
                          if (plPlayerController.buffered.value ==
                              Duration.zero) {
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
    if (!isMobile) {
      return Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            final offset = -event.scrollDelta.dy / 4000;
            final volume = clampDouble(
              plPlayerController.volume.value + offset,
              0.0,
              1.0,
            );
            plPlayerController.setVolume(volume);
          }
        },
        child: Obx(
          () => MouseRegion(
            cursor: !plPlayerController.showControls.value && isFullScreen
                ? SystemMouseCursors.none
                : MouseCursor.defer,
            onEnter: (_) => plPlayerController.controls = true,
            onHover: (_) => plPlayerController.controls = true,
            onExit: (_) => plPlayerController.controls = false,
            child: child,
          ),
        ),
      );
    }
    return child;
  }

  late final segment = Pair(
    first: plPlayerController.position.value.inMilliseconds / 1000.0,
    second: plPlayerController.position.value.inMilliseconds / 1000.0,
  );

  Future<void> screenshotWebp() async {
    final videoInfo = videoDetailController.data;
    final ids = videoInfo.dash!.video!.map((i) => i.id!).toSet();
    final video = videoDetailController.findVideoByQa(
      ids.reduce((p, n) => p < n ? p : n),
    );

    VideoQuality qa = video.quality;
    String? url = video.baseUrl;
    if (url == null) return;

    final ctr = plPlayerController;
    final theme = Theme.of(context);
    final currentPos = ctr.position.value.inMilliseconds / 1000.0;
    final duration = ctr.durationSeconds.value.inMilliseconds / 1000.0;
    final model = PostSegmentModel(
      segment: segment,
      category: SegmentType.sponsor,
      actionType: ActionType.skip,
    );
    final isPlay = ctr.playerStatus.playing;
    if (isPlay) ctr.pause();

    WebpPreset preset = WebpPreset.def;

    final success =
        await Get.dialog<bool>(
          AlertDialog(
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
                  initialValue: qa.code,
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
                  initialValue: preset,
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
    final file = '${await Utils.temporaryDirectory}/$name';

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
}

Widget buildDmChart(
  ThemeData theme,
  List<double> dmTrend,
  VideoDetailController videoDetailController, [
  double offset = 0,
]) {
  final color = theme.colorScheme.primary;
  return IgnorePointer(
    child: Container(
      height: 12,
      margin: EdgeInsets.only(
        bottom:
            videoDetailController.viewPointList.isNotEmpty &&
                videoDetailController.showVP.value
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
          maxX: (dmTrend.length - 1).toDouble(),
          minY: 0,
          maxY: dmTrend.reduce((a, b) => a > b ? a : b).toDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                dmTrend.length,
                (index) => FlSpot(
                  index.toDouble(),
                  dmTrend[index],
                ),
              ),
              isCurved: true,
              barWidth: 1,
              color: color,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildSeekPreviewWidget(
  PlPlayerController plPlayerController,
  double maxWidth,
  double maxHeight,
) {
  return Obx(
    () {
      if (!plPlayerController.showPreview.value) {
        return const SizedBox.shrink();
      }

      try {
        VideoShotData data = plPlayerController.videoShot!.data;

        final double scale =
            plPlayerController.isFullScreen.value &&
                !plPlayerController.isVertical
            ? 4
            : 3;
        double height = 27 * scale;
        final compatHeight = maxHeight - 140;
        if (compatHeight > 50) {
          height = math.min(height, compatHeight);
        }

        final int imgXLen = data.imgXLen;
        final int imgYLen = data.imgYLen;
        final int totalPerImage = data.totalPerImage;
        double imgXSize = data.imgXSize;
        double imgYSize = data.imgYSize;

        return Align(
          alignment: Alignment.center,
          child: Obx(
            () {
              final index = plPlayerController.previewIndex.value!;
              int pageIndex = (index ~/ totalPerImage).clamp(
                0,
                data.image.length - 1,
              );
              int align = index % totalPerImage;
              int x = align % imgXLen;
              int y = align ~/ imgYLen;
              final url = data.image[pageIndex];

              return ClipRRect(
                borderRadius: StyleString.mdRadius,
                child: VideoShotImage(
                  url: url,
                  x: x,
                  y: y,
                  imgXSize: imgXSize,
                  imgYSize: imgYSize,
                  height: height,
                  image: plPlayerController.previewCache?[url]?.target,
                  onCacheImg: (img) =>
                      (plPlayerController.previewCache ??= {})[url] ??=
                          WeakReference(img),
                  onSetSize: (xSize, ySize) => data
                    ..imgXSize = imgXSize = xSize
                    ..imgYSize = imgYSize = ySize,
                ),
              );
            },
          ),
        );
      } catch (e) {
        if (kDebugMode) debugPrint('seek preview: $e');
        return const SizedBox.shrink();
      }
    },
  );
}

class VideoShotImage extends StatefulWidget {
  const VideoShotImage({
    super.key,
    this.image,
    required this.url,
    required this.x,
    required this.y,
    required this.imgXSize,
    required this.imgYSize,
    required this.height,
    required this.onCacheImg,
    required this.onSetSize,
  });

  final ui.Image? image;
  final String url;
  final int x;
  final int y;
  final double imgXSize;
  final double imgYSize;
  final double height;
  final ValueChanged<ui.Image> onCacheImg;
  final Function(double imgXSize, double imgYSize) onSetSize;

  @override
  State<VideoShotImage> createState() => _VideoShotImageState();
}

Future<ui.Image?> _getImg(String url) async {
  final cacheManager = DefaultCacheManager();
  final cacheKey = Utils.getFileName(url, fileExt: false);
  final fileInfo = await cacheManager.getFileFromCache(cacheKey);
  if (fileInfo != null) {
    final bytes = await fileInfo.file.readAsBytes();
    return _loadImg(bytes);
  } else {
    final res = await Request().get<Uint8List>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    if (res.statusCode == 200) {
      final Uint8List data = res.data;
      cacheManager.putFile(cacheKey, data, fileExtension: 'jpg');
      return _loadImg(data);
    }
  }
  return null;
}

Future<ui.Image?> _loadImg(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  codec.dispose();
  return frame.image;
}

class _VideoShotImageState extends State<VideoShotImage> {
  late Size _size;
  late Rect _dstRect;
  late RRect _rrect;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _initSize();
    _loadImg();
  }

  void _initSizeIfNeeded() {
    if (_size.width.isNaN) {
      _initSize();
    }
  }

  void _initSize() {
    if (widget.imgXSize == 0) {
      if (_image != null) {
        final imgXSize = _image!.width / 10;
        final imgYSize = _image!.height / 10;
        final height = widget.height;
        final width = height * imgXSize / imgYSize;
        _setRect(width, height);
        widget.onSetSize(imgXSize, imgYSize);
      } else {
        _setRect(double.nan, double.nan);
      }
    } else {
      final height = widget.height;
      final width = height * widget.imgXSize / widget.imgYSize;
      _setRect(width, height);
    }
  }

  void _setRect(double width, double height) {
    _size = Size(width, height);
    _dstRect = Rect.fromLTWH(0, 0, width, height);
    _rrect = RRect.fromRectAndRadius(_dstRect, const Radius.circular(10));
  }

  Future<void> _loadImg() async {
    _image = widget.image;
    if (_image != null) {
      _initSizeIfNeeded();
      setState(() {});
    } else {
      final image = await _getImg(widget.url);
      if (mounted && image != null) {
        _image = image;
        widget.onCacheImg(image);
        _initSizeIfNeeded();
        setState(() {});
      }
    }
  }

  @override
  void didUpdateWidget(VideoShotImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loadImg();
    }
  }

  late final _imgPaint = Paint()..filterQuality = FilterQuality.medium;
  late final _borderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return RepaintBoundary(
        child: CustomPaint(
          painter: _CroppedImagePainter(
            image: _image!,
            x: widget.x,
            y: widget.y,
            imgXSize: widget.imgXSize,
            imgYSize: widget.imgYSize,
            dstRect: _dstRect,
            rrect: _rrect,
            imgPaint: _imgPaint,
            borderPaint: _borderPaint,
          ),
          size: _size,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _CroppedImagePainter extends CustomPainter {
  final ui.Image image;
  final Rect srcRect;
  final Rect dstRect;
  final RRect rrect;
  final Paint imgPaint;
  final Paint borderPaint;

  _CroppedImagePainter({
    required this.image,
    required int x,
    required int y,
    required double imgXSize,
    required double imgYSize,
    required this.dstRect,
    required this.rrect,
    required this.imgPaint,
    required this.borderPaint,
  }) : srcRect = Rect.fromLTWH(x * imgXSize, y * imgYSize, imgXSize, imgYSize);

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..drawImageRect(image, srcRect, dstRect, imgPaint)
      ..drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(_CroppedImagePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.srcRect != srcRect;
  }
}

Widget buildViewPointWidget(
  VideoDetailController videoDetailController,
  PlPlayerController plPlayerController,
  double offset,
  double maxWidth,
) {
  return Container(
    height: 16,
    margin: EdgeInsets.only(bottom: offset),
    child: Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        try {
          double seg = event.localPosition.dx / maxWidth;
          Segment item = videoDetailController.viewPointList
              .where((item) => item.start >= seg)
              .reduce((a, b) => a.start < b.start ? a : b);
          if (item.from != null) {
            plPlayerController
              ..danmakuController?.clear()
              ..videoPlayerController?.seek(Duration(seconds: item.from!));
          }
          // if (kDebugMode) debugPrint('${item.title},,${item.from}');
        } catch (e) {
          if (kDebugMode) debugPrint('$e');
        }
      },
    ),
  );
}
