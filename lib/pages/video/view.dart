import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/models/common/episode_panel_type.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/models_new/video/video_detail/ugc_season.dart';
import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/danmaku/view.dart';
import 'package:PiliPlus/pages/episode_panel/view.dart';
import 'package:PiliPlus/pages/video/ai_conclusion/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/view.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/widgets/intro_detail.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/view.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/page.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/season.dart';
import 'package:PiliPlus/pages/video/member/controller.dart';
import 'package:PiliPlus/pages/video/member/view.dart';
import 'package:PiliPlus/pages/video/related/view.dart';
import 'package:PiliPlus/pages/video/reply/controller.dart';
import 'package:PiliPlus/pages/video/reply/view.dart';
import 'package:PiliPlus/pages/video/view_point/view.dart';
import 'package:PiliPlus/pages/video/widgets/header_control.dart';
import 'package:PiliPlus/pages/video/widgets/player_focus.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/plugin/pl_player/view.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/services/shutdown_timer_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:floating/floating.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';

class VideoDetailPageV extends StatefulWidget {
  const VideoDetailPageV({super.key});

  @override
  State<VideoDetailPageV> createState() => _VideoDetailPageVState();
}

class _VideoDetailPageVState extends State<VideoDetailPageV>
    with TickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  final heroTag = Get.arguments['heroTag'];

  late final VideoDetailController videoDetailController;
  late final VideoReplyController _videoReplyController;
  PlPlayerController? plPlayerController;
  late final CommonIntroController introController = videoDetailController.isUgc
      ? ugcIntroController
      : pgcIntroController;
  late final UgcIntroController ugcIntroController;
  late final PgcIntroController pgcIntroController;
  ScrollController? _introScrollController;

  ScrollController get introScrollController =>
      _introScrollController ??= ScrollController();

  bool get autoExitFullscreen =>
      videoDetailController.plPlayerController.autoExitFullscreen;

  bool get autoPlayEnable =>
      videoDetailController.plPlayerController.autoPlayEnable;

  bool get enableVerticalExpand =>
      videoDetailController.plPlayerController.enableVerticalExpand;

  bool get pipNoDanmaku =>
      videoDetailController.plPlayerController.pipNoDanmaku;

  bool isShowing = true;

  bool get isFullScreen =>
      videoDetailController.plPlayerController.isFullScreen.value;

  bool get _shouldShowSeasonPanel {
    if (isPortrait || !videoDetailController.isUgc) {
      return false;
    }
    late final videoDetail = ugcIntroController.videoDetail.value;
    return videoDetailController.plPlayerController.horizontalSeasonPanel &&
        (videoDetail.ugcSeason != null ||
            ((videoDetail.pages?.length ?? 0) > 1));
  }

  final videoPlayerKey = GlobalKey();
  final videoReplyPanelKey = GlobalKey();
  final videoRelatedKey = GlobalKey();
  final videoIntroKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    PlPlayerController.setPlayCallBack(playCallBack);
    videoDetailController = Get.put(VideoDetailController(), tag: heroTag);

    if (videoDetailController.showReply) {
      _videoReplyController = Get.put(
        VideoReplyController(
          aid: videoDetailController.aid,
          videoType: videoDetailController.videoType,
          heroTag: heroTag,
        ),
        tag: heroTag,
      );
    }
    if (videoDetailController.isUgc) {
      ugcIntroController = Get.put(UgcIntroController(), tag: heroTag);
    } else {
      pgcIntroController = Get.put(PgcIntroController(), tag: heroTag);
    }

    videoSourceInit();
    autoScreen();

    WidgetsBinding.instance.addObserver(this);
  }

  // 获取视频资源，初始化播放器
  Future<void> videoSourceInit() async {
    videoDetailController.queryVideoUrl();
    if (videoDetailController.autoPlay.value) {
      plPlayerController = videoDetailController.plPlayerController;
      plPlayerController!
        ..addStatusLister(playerListener)
        ..addPositionListener(positionListener);
      await plPlayerController!.autoEnterFullscreen();
    }
  }

  void positionListener(Duration position) {
    videoDetailController.playedTime = position;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    late final ctr = videoDetailController.plPlayerController;
    if (state == AppLifecycleState.resumed) {
      if (!ctr.showDanmaku) {
        introController.startTimer();
        ctr.showDanmaku = true;

        // 修复从后台恢复时全屏状态下屏幕方向错误的问题
        if (isFullScreen && Platform.isIOS) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // 根据视频方向重新设置屏幕方向
            final isVertical = videoDetailController.isVertical.value;
            final mode = ctr.mode;

            if (!(mode == FullScreenMode.vertical ||
                (mode == FullScreenMode.auto && isVertical) ||
                (mode == FullScreenMode.ratio &&
                    (isVertical || maxHeight / maxWidth < kScreenRatio)))) {
              landscape();
            }
          });
        }
      }
    } else if (state == AppLifecycleState.paused) {
      introController.canelTimer();
      ctr.showDanmaku = false;
    }
  }

  void playCallBack() {
    plPlayerController?.play();
  }

  // 播放器状态监听
  Future<void> playerListener(PlayerStatus status) async {
    bool isPlaying = status == PlayerStatus.playing;
    try {
      if (videoDetailController.scrollCtr.hasClients) {
        if (isPlaying) {
          if (!videoDetailController.isExpanding &&
              videoDetailController.scrollCtr.offset != 0 &&
              !videoDetailController.animationController.isAnimating) {
            videoDetailController.isExpanding = true;
            videoDetailController.animationController.forward(
              from:
                  1 -
                  videoDetailController.scrollCtr.offset /
                      videoDetailController.videoHeight,
            );
          } else {
            refreshPage();
          }
        } else {
          refreshPage();
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('handle playe status: $e');
    }

    if (status == PlayerStatus.completed) {
      try {
        if (videoDetailController
                .steinEdgeInfo
                ?.edges
                ?.questions
                ?.firstOrNull
                ?.choices
                ?.isNotEmpty ==
            true) {
          videoDetailController.showSteinEdgeInfo.value = true;
          return;
        }
      } catch (_) {}
      shutdownTimerService.handleWaitingFinished();
      bool notExitFlag = false;

      /// 顺序播放 列表循环
      if (plPlayerController!.playRepeat != PlayRepeat.pause &&
          plPlayerController!.playRepeat != PlayRepeat.singleCycle) {
        if (videoDetailController.isUgc) {
          notExitFlag = ugcIntroController.nextPlay();
        } else {
          notExitFlag = pgcIntroController.nextPlay();
        }
      }

      /// 单个循环
      if (plPlayerController!.playRepeat == PlayRepeat.singleCycle) {
        notExitFlag = true;
        plPlayerController!.play(repeat: true);
      }

      // 结束播放退出全屏
      if (!notExitFlag && autoExitFullscreen) {
        plPlayerController!.triggerFullScreen(status: false);
        if (plPlayerController!.longPressStatus.value) {
          plPlayerController!.setLongPressStatus(false);
        }
        if (plPlayerController!.controlsLock.value) {
          plPlayerController!.onLockControl(false);
        }
      }
      // 播放完展示控制栏
      if (Platform.isAndroid && !notExitFlag) {
        PiPStatus currentStatus = await Floating().pipStatus;
        if (currentStatus == PiPStatus.disabled) {
          plPlayerController!.onLockControl(false);
        }
      }
    }
  }

  // 继续播放或重新播放
  void continuePlay() {
    plPlayerController!.play();
  }

  /// 未开启自动播放时触发播放
  Future<void> handlePlay() async {
    if (videoDetailController.isQuerying) {
      if (kDebugMode) debugPrint('handlePlay: querying');
      return;
    }
    if (videoDetailController.videoUrl == null ||
        videoDetailController.audioUrl == null) {
      if (kDebugMode) {
        debugPrint('handlePlay: videoUrl/audioUrl not initialized');
      }
      videoDetailController.queryVideoUrl();
      return;
    }
    plPlayerController = videoDetailController.plPlayerController;
    videoDetailController.autoPlay.value = true;
    if (videoDetailController.plPlayerController.preInitPlayer) {
      await plPlayerController!.play();
    } else {
      await videoDetailController.playerInit(autoplay: true);
    }
    plPlayerController!
      ..addStatusLister(playerListener)
      ..addPositionListener(positionListener);
    await plPlayerController!.autoEnterFullscreen();
  }

  @override
  void dispose() {
    plPlayerController
      ?..removeStatusLister(playerListener)
      ..removePositionListener(positionListener);

    videoDetailController
      ..cancelSkipTimer()
      ..positionSubscription?.cancel()
      ..cid.close()
      ..animController?.removeListener(animListener);

    Get.delete<HorizontalMemberPageController>(
      tag: videoDetailController.heroTag,
    );

    if (!Get.previousRoute.startsWith('/video')) {
      if (Utils.isMobile) {
        ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
      }
      PlPlayerController.setPlayCallBack(null);
    }

    _introScrollController?.dispose();
    if (videoDetailController.isUgc) {
      ugcIntroController
        ..canelTimer()
        ..videoDetail.close();
    } else {
      pgcIntroController.canelTimer();
    }
    if (!videoDetailController.horizontalScreen) {
      AutoOrientation.portraitUpMode();
    }
    shutdownTimerService.handleWaitingFinished();
    if (!videoDetailController.plPlayerController.isCloseAll) {
      videoPlayerServiceHandler?.onVideoDetailDispose(heroTag);
      if (plPlayerController != null) {
        videoDetailController.makeHeartBeat();
        plPlayerController!.dispose();
      } else {
        PlPlayerController.updatePlayCount();
      }
    }
    PageUtils.routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    if (Utils.isMobile) {
      showStatusBar();
    }
    super.dispose();
  }

  @override
  // 离开当前页面时
  Future<void> didPushNext() async {
    if (videoDetailController.imageStatus) {
      return;
    }

    WidgetsBinding.instance.removeObserver(this);

    if (Utils.isMobile) {
      ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
    }

    videoDetailController.positionSubscription?.cancel();

    introController.canelTimer();

    videoDetailController
      ..playerStatus = plPlayerController?.playerStatus.value
      ..brightness = plPlayerController?.brightness.value;
    if (plPlayerController != null) {
      videoDetailController.makeHeartBeat();
      plPlayerController!
        ..removeStatusLister(playerListener)
        ..removePositionListener(positionListener)
        ..pause();
    }
    isShowing = false;
    super.didPushNext();
  }

  @override
  // 返回当前页面时
  Future<void> didPopNext() async {
    if (videoDetailController.imageStatus) {
      return;
    }

    if (plPlayerController?.isCloseAll == true) {
      return;
    }

    WidgetsBinding.instance.addObserver(this);

    plPlayerController?.isLive = false;
    if (videoDetailController.plPlayerController.playerStatus.playing &&
        videoDetailController.playerStatus != PlayerStatus.playing) {
      videoDetailController.plPlayerController.pause();
    }

    isShowing = true;
    PlPlayerController.setPlayCallBack(playCallBack);

    introController.startTimer();

    if (Utils.isMobile && mounted) {
      if (videoDetailController.brightness != null) {
        plPlayerController?.setCurrBrightness(
          videoDetailController.brightness!,
        );
        if (videoDetailController.brightness != -1.0) {
          ScreenBrightnessPlatform.instance.setApplicationScreenBrightness(
            videoDetailController.brightness!,
          );
        } else {
          ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
        }
      } else {
        ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
      }
    }
    super.didPopNext();
    if (videoDetailController.autoPlay.value) {
      await videoDetailController.playerInit(
        autoplay: videoDetailController.playerStatus == PlayerStatus.playing,
      );
    } else if (videoDetailController.plPlayerController.preInitPlayer &&
        !videoDetailController.isQuerying &&
        videoDetailController.videoState.value is! Error) {
      await videoDetailController.playerInit();
    }

    plPlayerController
      ?..addStatusLister(playerListener)
      ..addPositionListener(positionListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PageUtils.routeObserver.subscribe(
      this,
      ModalRoute.of(context)! as PageRoute,
    );

    padding = MediaQuery.viewPaddingOf(context);

    final size = MediaQuery.sizeOf(context);
    maxWidth = size.width;
    maxHeight = size.height;

    final shortestSide = size.shortestSide;
    final minVideoHeight = shortestSide * 9 / 16;
    final maxVideoHeight = max(size.longestSide * 0.65, shortestSide);
    videoDetailController
      ..isPortrait = isPortrait = maxHeight >= maxWidth
      ..minVideoHeight = minVideoHeight
      ..maxVideoHeight = maxVideoHeight
      ..videoHeight = videoDetailController.isVertical.value
          ? maxVideoHeight
          : minVideoHeight;

    themeData = videoDetailController.plPlayerController.darkVideoPage
        ? MyApp.darkThemeData ?? Theme.of(context)
        : Theme.of(context);
  }

  void animListener() {
    if (videoDetailController.animationController.isForwardOrCompleted) {
      cal();
      refreshPage();
    }
  }

  late double animHeight;

  void cal() {
    if (videoDetailController.isExpanding) {
      animHeight = clampDouble(
        videoDetailController.videoHeight *
            videoDetailController.animationController.value,
        kToolbarHeight,
        videoDetailController.videoHeight,
      );
    } else if (videoDetailController.isCollapsing) {
      animHeight = clampDouble(
        videoDetailController.maxVideoHeight -
            (videoDetailController.maxVideoHeight -
                    videoDetailController.minVideoHeight) *
                videoDetailController.animationController.value,
        videoDetailController.minVideoHeight,
        videoDetailController.maxVideoHeight,
      );
    }
  }

  void refreshPage() {
    if (videoDetailController.scrollKey.currentState?.mounted == true) {
      videoDetailController.scrollKey.currentState?.setState(() {});
    }
  }

  Widget get childWhenDisabled {
    videoDetailController.animationController
      ..removeListener(animListener)
      ..addListener(animListener);
    if (Utils.isMobile && mounted && isShowing && !isFullScreen) {
      if (isPortrait) {
        if (!videoDetailController.imageStatus) {
          showStatusBar();
        }
      } else if (!videoDetailController.horizontalScreen) {
        hideStatusBar();
      }
    }
    if (Utils.isMobile) {
      if (!isPortrait &&
          !isFullScreen &&
          plPlayerController != null &&
          videoDetailController.autoPlay.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          plPlayerController!.triggerFullScreen(
            status: true,
            isManualFS: false,
            mode: FullScreenMode.gravity,
          );
        });
      } else if (isPortrait &&
          isFullScreen &&
          plPlayerController?.isManualFS == false &&
          plPlayerController?.controlsLock.value == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          plPlayerController!.triggerFullScreen(status: false);
        });
      }
    }
    return Obx(
      () {
        final isFullScreen = this.isFullScreen;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Obx(
              () {
                final scrollRatio = videoDetailController.scrollRatio.value;
                bool shouldShow =
                    scrollRatio != 0 &&
                    videoDetailController.scrollCtr.offset != 0 &&
                    isPortrait;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppBar(
                      backgroundColor: Colors.black,
                      toolbarHeight: 0,
                      systemOverlayStyle: Platform.isAndroid
                          ? shouldShow
                                ? null
                                : SystemUiOverlayStyle(
                                    statusBarIconBrightness: Brightness.light,
                                    systemNavigationBarIconBrightness:
                                        themeData.brightness.reverse,
                                  )
                          : null,
                    ),
                    if (shouldShow)
                      AppBar(
                        backgroundColor: themeData.colorScheme.surface
                            .withValues(alpha: scrollRatio),
                        toolbarHeight: 0,
                        systemOverlayStyle: Platform.isAndroid
                            ? SystemUiOverlayStyle(
                                statusBarIconBrightness:
                                    themeData.brightness.reverse,
                                systemNavigationBarIconBrightness:
                                    themeData.brightness.reverse,
                              )
                            : null,
                      ),
                  ],
                );
              },
            ),
          ),
          body: ExtendedNestedScrollView(
            key: videoDetailController.scrollKey,
            controller: videoDetailController.scrollCtr,
            onlyOneScrollInBody: true,
            pinnedHeaderSliverHeightBuilder: () {
              double pinnedHeight = this.isFullScreen || !isPortrait
                  ? maxHeight - padding.top
                  : videoDetailController.isExpanding ||
                        videoDetailController.isCollapsing
                  ? animHeight
                  : videoDetailController.isCollapsing ||
                        plPlayerController?.playerStatus.value ==
                            PlayerStatus.playing
                  ? videoDetailController.minVideoHeight
                  : kToolbarHeight;
              if (videoDetailController.isExpanding &&
                  videoDetailController.animationController.value == 1) {
                videoDetailController.isExpanding = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  videoDetailController.scrollRatio.value = 0;
                  refreshPage();
                });
              } else if (videoDetailController.isCollapsing &&
                  videoDetailController.animationController.value == 1) {
                videoDetailController.isCollapsing = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  refreshPage();
                });
              }
              return pinnedHeight;
            },
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              final height = isFullScreen || !isPortrait
                  ? maxHeight - padding.top
                  : videoDetailController.isExpanding ||
                        videoDetailController.isCollapsing
                  ? animHeight
                  : videoDetailController.videoHeight;
              return [
                SliverAppBar(
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  primary: false,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  expandedHeight: height,
                  flexibleSpace: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: maxWidth,
                        height: height,
                        child: videoPlayer(
                          width: maxWidth,
                          height: height,
                        ),
                      ),
                      Obx(
                        () {
                          Widget toolbar() => Opacity(
                            opacity: videoDetailController.scrollRatio.value,
                            child: Container(
                              color: themeData.colorScheme.surface,
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                height: kToolbarHeight,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 42,
                                            height: 34,
                                            child: IconButton(
                                              tooltip: '返回',
                                              icon: Icon(
                                                FontAwesomeIcons.arrowLeft,
                                                size: 15,
                                                color: themeData
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                              onPressed: Get.back,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 42,
                                            height: 34,
                                            child: IconButton(
                                              tooltip: '返回主页',
                                              icon: Icon(
                                                FontAwesomeIcons.house,
                                                size: 15,
                                                color: themeData
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                              onPressed: () {
                                                videoDetailController
                                                    .plPlayerController
                                                  ..isCloseAll = true
                                                  ..dispose();
                                                Get.until(
                                                  (route) => route.isFirst,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.play_arrow_rounded,
                                            color:
                                                themeData.colorScheme.primary,
                                          ),
                                          Text(
                                            '${videoDetailController.playedTime == null
                                                ? '立即'
                                                : plPlayerController!.playerStatus.completed
                                                ? '重新'
                                                : '继续'}播放',
                                            style: TextStyle(
                                              color:
                                                  themeData.colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child:
                                          videoDetailController.playedTime ==
                                              null
                                          ? _moreBtn(
                                              themeData.colorScheme.onSurface,
                                            )
                                          : SizedBox(
                                              width: 42,
                                              height: 34,
                                              child: IconButton(
                                                tooltip: "更多设置",
                                                style: const ButtonStyle(
                                                  padding:
                                                      WidgetStatePropertyAll(
                                                        EdgeInsets.zero,
                                                      ),
                                                ),
                                                onPressed: () =>
                                                    videoDetailController
                                                        .headerCtrKey
                                                        .currentState
                                                        ?.showSettingSheet(),
                                                icon: Icon(
                                                  Icons.more_vert_outlined,
                                                  size: 19,
                                                  color: themeData
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          return videoDetailController.scrollRatio.value == 0 ||
                                  videoDetailController.scrollCtr.offset == 0 ||
                                  !isPortrait
                              ? const SizedBox.shrink()
                              : Positioned.fill(
                                  bottom: -2,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (videoDetailController.isQuerying) {
                                        if (kDebugMode) {
                                          debugPrint(
                                            'handlePlay: querying',
                                          );
                                        }
                                        return;
                                      }
                                      if (videoDetailController.videoUrl ==
                                              null ||
                                          videoDetailController.audioUrl ==
                                              null) {
                                        if (kDebugMode) {
                                          debugPrint(
                                            'handlePlay: videoUrl/audioUrl not initialized',
                                          );
                                        }
                                        videoDetailController.queryVideoUrl();
                                        return;
                                      }
                                      videoDetailController.scrollRatio.value =
                                          0;
                                      if (plPlayerController == null ||
                                          videoDetailController.playedTime ==
                                              null) {
                                        handlePlay();
                                      } else {
                                        if (plPlayerController!
                                            .videoPlayerController!
                                            .state
                                            .completed) {
                                          await plPlayerController!
                                              .videoPlayerController!
                                              .seek(Duration.zero);
                                          plPlayerController!
                                              .videoPlayerController!
                                              .play();
                                        } else {
                                          plPlayerController!
                                              .videoPlayerController!
                                              .playOrPause();
                                        }
                                      }
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: toolbar(),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: Scaffold(
              key: videoDetailController.childKey,
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  buildTabbar(onTap: videoDetailController.animToTop),
                  Expanded(
                    child: videoTabBarView(
                      controller: videoDetailController.tabCtr,
                      children: [
                        videoIntro(
                          isHorizontal: false,
                          needCtr: false,
                          isNested: true,
                        ),
                        if (videoDetailController.showReply)
                          videoReplyPanel(isNested: true),
                        if (_shouldShowSeasonPanel) seasonPanel,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get childWhenDisabledLandscape => Obx(
    () {
      final isFullScreen = this.isFullScreen;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black, toolbarHeight: 0),
        body: Padding(
          padding: !isFullScreen
              ? padding.copyWith(top: 0, bottom: 0)
              : EdgeInsets.zero,
          child: childWhenDisabledLandscapeInner(isFullScreen, padding),
        ),
      );
    },
  );

  Widget childSplit(double ratio) {
    final double videoHeight = maxHeight - padding.vertical;
    final double width = videoHeight * ratio;
    final videoWidth = isFullScreen ? maxWidth : width;
    final introWidth = maxWidth - width - padding.horizontal;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: videoWidth,
          height: videoHeight,
          child: videoPlayer(
            width: videoWidth,
            height: videoHeight,
          ),
        ),
        Offstage(
          offstage: isFullScreen,
          child: SizedBox(
            width: introWidth,
            height: maxHeight - padding.top,
            child: Scaffold(
              key: videoDetailController.childKey,
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTabbar(),
                  Expanded(
                    child: videoTabBarView(
                      controller: videoDetailController.tabCtr,
                      children: [
                        videoIntro(
                          width: introWidth,
                          height: maxHeight,
                        ),
                        if (videoDetailController.showReply) videoReplyPanel(),
                        if (_shouldShowSeasonPanel) seasonPanel,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget childWhenDisabledLandscapeInner(
    bool isFullScreen,
    EdgeInsets padding,
  ) => Obx(() {
    if (videoDetailController.isVertical.value &&
        enableVerticalExpand &&
        !isPortrait) {
      final double videoHeight = maxHeight - padding.vertical;
      final double width = videoHeight * 9 / 16;
      final videoWidth = isFullScreen ? maxWidth : width;
      final introWidth = (maxWidth - padding.horizontal - width) / 2;
      final introHeight = maxHeight - padding.top;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Offstage(
            offstage: isFullScreen,
            child: SizedBox(
              width: introWidth,
              height: introHeight,
              child: videoIntro(
                width: introWidth,
                height: introHeight,
              ),
            ),
          ),
          SizedBox(
            width: videoWidth,
            height: videoHeight,
            child: videoPlayer(
              width: videoWidth,
              height: videoHeight,
            ),
          ),
          Offstage(
            offstage: isFullScreen,
            child: SizedBox(
              width: introWidth,
              height: introHeight,
              child: Scaffold(
                key: videoDetailController.childKey,
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    buildTabbar(showIntro: false),
                    Expanded(
                      child: videoTabBarView(
                        controller: videoDetailController.tabCtr,
                        children: [
                          if (videoDetailController.showReply)
                            videoReplyPanel(),
                          if (_shouldShowSeasonPanel) seasonPanel,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
    double width =
        clampDouble(maxHeight / maxWidth * 1.08, 0.5, 0.7) * maxWidth;
    if (maxWidth >= 560) {
      width = maxWidth - clampDouble(maxWidth - width, 280, 425);
    }
    final videoWidth = isFullScreen ? maxWidth : width;
    final double height = width * 9 / 16;
    final videoHeight = isFullScreen ? maxHeight - padding.top : height;
    if (height > maxHeight) {
      return childSplit(16 / 9);
    }
    final introHeight = maxHeight - height - padding.top;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: videoWidth,
              height: videoHeight,
              child: videoPlayer(
                width: videoWidth,
                height: videoHeight,
              ),
            ),
            Offstage(
              offstage: isFullScreen,
              child: SizedBox(
                width: width,
                height: introHeight,
                child: videoIntro(
                  width: width,
                  height: introHeight,
                  needRelated: false,
                  needCtr: false,
                ),
              ),
            ),
          ],
        ),
        Offstage(
          offstage: isFullScreen,
          child: SizedBox(
            width: maxWidth - width - padding.horizontal,
            height: maxHeight - padding.top,
            child: Scaffold(
              key: videoDetailController.childKey,
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTabbar(
                    introText: '相关视频',
                    showIntro:
                        videoDetailController.isUgc &&
                        videoDetailController
                            .plPlayerController
                            .showRelatedVideo,
                  ),
                  Expanded(
                    child: videoTabBarView(
                      controller: videoDetailController.tabCtr,
                      children: [
                        if (videoDetailController.isUgc &&
                            videoDetailController
                                .plPlayerController
                                .showRelatedVideo)
                          KeepAliveWrapper(
                            builder: (context) => CustomScrollView(
                              controller: introScrollController,
                              slivers: [
                                RelatedVideoPanel(
                                  key: videoRelatedKey,
                                  heroTag: heroTag,
                                ),
                              ],
                            ),
                          ),
                        if (videoDetailController.showReply) videoReplyPanel(),
                        if (_shouldShowSeasonPanel) seasonPanel,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  });

  Widget get childWhenDisabledAlmostSquare => Obx(() {
    final isFullScreen = this.isFullScreen;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.black, toolbarHeight: 0),
      body: Padding(
        padding: !isFullScreen
            ? padding.copyWith(top: 0, bottom: 0)
            : EdgeInsets.zero,
        child: childWhenDisabledAlmostSquareInner(isFullScreen, padding),
      ),
    );
  });

  Widget childWhenDisabledAlmostSquareInner(
    bool isFullScreen,
    EdgeInsets padding,
  ) => Obx(
    () {
      final isFullScreen = this.isFullScreen;
      if (videoDetailController.isVertical.value &&
          enableVerticalExpand &&
          !isPortrait) {
        return childSplit(9 / 16);
      }
      final shouldShowSeasonPanel = _shouldShowSeasonPanel;
      final double height = maxHeight / 2.5;
      final videoHeight = isFullScreen ? maxHeight - padding.top : height;
      final bottomHeight = maxHeight - height - padding.top;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: maxWidth,
            height: videoHeight,
            child: videoPlayer(
              width: maxWidth,
              height: videoHeight,
            ),
          ),
          Offstage(
            offstage: isFullScreen,
            child: SizedBox(
              width: maxWidth - padding.horizontal,
              height: bottomHeight,
              child: Scaffold(
                key: videoDetailController.childKey,
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTabbar(needIndicator: false),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: videoIntro(
                              width: () {
                                double flex = 1;
                                if (videoDetailController.showReply) flex++;
                                if (shouldShowSeasonPanel) flex++;
                                return maxWidth / flex;
                              }(),
                              height: bottomHeight,
                            ),
                          ),
                          if (videoDetailController.showReply)
                            Expanded(child: videoReplyPanel()),
                          if (shouldShowSeasonPanel)
                            Expanded(child: seasonPanel),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  Widget get manualPlayerWidget => Obx(() {
    if (!videoDetailController.autoPlay.value) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              primary: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  SizedBox(
                    width: 42,
                    height: 34,
                    child: IconButton(
                      tooltip: '返回',
                      icon: const Icon(
                        FontAwesomeIcons.arrowLeft,
                        size: 15,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 1.5,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      onPressed: Get.back,
                    ),
                  ),
                  SizedBox(
                    width: 42,
                    height: 34,
                    child: IconButton(
                      tooltip: '返回主页',
                      icon: const Icon(
                        FontAwesomeIcons.house,
                        size: 15,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 1.5,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      onPressed: () {
                        videoDetailController.plPlayerController
                          ..isCloseAll = true
                          ..dispose();
                        Get.until((route) => route.isFirst);
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                _moreBtn(
                  Colors.white,
                  shadows: const [
                    Shadow(
                      blurRadius: 1.5,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            bottom: 10,
            child: IconButton(
              tooltip: '播放',
              onPressed: handlePlay,
              icon: Image.asset(
                'assets/images/play.png',
                width: 60,
                height: 60,
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  });

  Widget _moreBtn(Color color, {List<Shadow>? shadows}) => PopupMenuButton(
    icon: Icon(
      size: 22,
      Icons.more_vert,
      color: color,
      shadows: shadows,
    ),
    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
      PopupMenuItem(
        onTap: introController.viewLater,
        child: const Text('稍后再看'),
      ),
      if (videoDetailController.epId == null)
        PopupMenuItem(
          onTap: () => videoDetailController.showNoteList(context),
          child: const Text('查看笔记'),
        ),
      if (videoDetailController.cover.value.isNotEmpty)
        PopupMenuItem(
          onTap: () => ImageUtils.downloadImg(
            context,
            [videoDetailController.cover.value],
          ),
          child: const Text('保存封面'),
        ),
      if (videoDetailController.isUgc)
        PopupMenuItem(
          onTap: videoDetailController.toAudioPage,
          child: const Text('听音频'),
        ),
      PopupMenuItem(
        onTap: () {
          if (!Accounts.main.isLogin) {
            SmartDialog.showToast('账号未登录');
          } else {
            PageUtils.reportVideo(videoDetailController.aid);
          }
        },
        child: const Text('举报'),
      ),
    ],
  );

  Widget plPlayer({
    required double width,
    required double height,
    bool isPipMode = false,
  }) => Obx(
    key: videoPlayerKey,
    () =>
        videoDetailController.videoState.value is! Success ||
            !videoDetailController.autoPlay.value ||
            plPlayerController?.videoController == null
        ? const SizedBox.shrink()
        : PLVideoPlayer(
            maxWidth: width,
            maxHeight: height,
            plPlayerController: plPlayerController!,
            videoDetailController: videoDetailController,
            introController: videoDetailController.isUgc
                ? ugcIntroController
                : pgcIntroController,
            headerControl: HeaderControl(
              key: videoDetailController.headerCtrKey,
              isPortrait: isPortrait,
              controller: videoDetailController.plPlayerController,
              videoDetailCtr: videoDetailController,
              heroTag: heroTag,
            ),
            danmuWidget: isPipMode && pipNoDanmaku
                ? null
                : Obx(
                    () => PlDanmaku(
                      key: ValueKey(videoDetailController.cid.value),
                      isPipMode: isPipMode,
                      cid: videoDetailController.cid.value,
                      playerController: plPlayerController!,
                      isFullScreen: plPlayerController!.isFullScreen.value,
                    ),
                  ),
            showEpisodes: showEpisodes,
            showViewPoints: showViewPoints,
          ),
  );

  late ThemeData themeData;
  late bool isPortrait;
  late double maxWidth;
  late double maxHeight;
  late EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (videoDetailController.plPlayerController.isPipMode) {
      child = plPlayer(width: maxWidth, height: maxHeight, isPipMode: true);
    } else if (!videoDetailController.horizontalScreen) {
      child = childWhenDisabled;
    } else if (maxWidth > maxHeight * kScreenRatio) {
      child = childWhenDisabledLandscape;
    } else if (maxWidth * (9 / 16) < (2 / 5) * maxHeight) {
      child = childWhenDisabled;
    } else {
      child = childWhenDisabledAlmostSquare;
    }
    if (videoDetailController.plPlayerController.keyboardControl) {
      child = PlayerFocus(
        plPlayerController: videoDetailController.plPlayerController,
        introController: videoDetailController.isUgc
            ? ugcIntroController
            : pgcIntroController,
        onSendDanmaku: videoDetailController.showShootDanmakuSheet,
        canPlay: () {
          if (videoDetailController.autoPlay.value) {
            return true;
          }
          handlePlay();
          return false;
        },
        onSkipSegment: videoDetailController.onSkipSegment,
        child: child,
      );
    }
    return videoDetailController.plPlayerController.darkVideoPage
        ? Theme(data: themeData, child: child)
        : child;
  }

  Widget buildTabbar({
    bool needIndicator = true,
    String introText = '简介',
    bool showIntro = true,
    VoidCallback? onTap,
  }) {
    List<String> tabs = [
      if (showIntro) introText,
      if (videoDetailController.showReply) '评论',
      if (_shouldShowSeasonPanel) '播放列表',
    ];
    if (videoDetailController.tabCtr.length != tabs.length) {
      videoDetailController.tabCtr.dispose();
      videoDetailController.tabCtr = TabController(
        vsync: this,
        length: tabs.length,
        initialIndex: tabs.isEmpty
            ? 0
            : videoDetailController.tabCtr.index.clamp(0, tabs.length - 1),
      );
    }

    final flag = !needIndicator || tabs.length == 1;
    Widget tabbar() => TabBar(
      labelColor: flag ? themeData.colorScheme.onSurface : null,
      indicator: flag ? const BoxDecoration() : null,
      padding: EdgeInsets.zero,
      controller: videoDetailController.tabCtr,
      labelStyle:
          TabBarTheme.of(context).labelStyle?.copyWith(fontSize: 13) ??
          const TextStyle(fontSize: 13),
      labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      dividerColor: Colors.transparent,
      dividerHeight: 0,
      onTap: (value) {
        void animToTop() {
          if (onTap != null) {
            onTap();
            return;
          }
          String text = tabs[value];
          if (text == '简介' || text == '相关视频') {
            _introScrollController?.animToTop();
          } else if (text.startsWith('评论')) {
            _videoReplyController.animateToTop();
          }
        }

        if (flag) {
          animToTop();
        } else if (!videoDetailController.tabCtr.indexIsChanging) {
          animToTop();
        }
      },
      tabs: tabs.map((text) {
        if (text == '评论') {
          return Obx(() {
            final count = _videoReplyController.count.value;
            return Tab(
              text: '评论${count == -1 ? '' : ' ${NumUtils.numFormat(count)}'}',
            );
          });
        } else {
          return Tab(text: text);
        }
      }).toList(),
    );

    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: themeData.dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          if (tabs.isEmpty)
            const Spacer()
          else
            Flexible(
              flex: tabs.length == 3 ? 2 : 1,
              child: tabbar(),
            ),
          Flexible(
            flex: 1,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 32,
                    child: TextButton(
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                      ),
                      onPressed: videoDetailController.showShootDanmakuSheet,
                      child: Text(
                        '发弹幕',
                        style: TextStyle(
                          fontSize: 12,
                          color: themeData.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: Obx(
                      () {
                        final ctr = videoDetailController.plPlayerController;
                        final enableShowDanmaku = ctr.enableShowDanmaku.value;
                        return IconButton(
                          onPressed: () {
                            final newVal = !enableShowDanmaku;
                            ctr.enableShowDanmaku.value = newVal;
                            if (!ctr.tempPlayerConf) {
                              GStorage.setting.put(
                                SettingBoxKey.enableShowDanmaku,
                                newVal,
                              );
                            }
                          },
                          icon: Icon(
                            size: 22,
                            enableShowDanmaku
                                ? CustomIcons.dm_on
                                : CustomIcons.dm_off,
                            color: enableShowDanmaku
                                ? themeData.colorScheme.secondary
                                : themeData.colorScheme.outline,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget videoPlayer({required double width, required double height}) {
    final isFullScreen = this.isFullScreen;
    return PopScope(
      canPop:
          !isFullScreen &&
          (videoDetailController.horizontalScreen || isPortrait),
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: ColoredBox(color: Colors.black)),

          if (isShowing) plPlayer(width: width, height: height),

          Obx(() {
            if (!videoDetailController.autoPlay.value) {
              return Positioned.fill(
                child: GestureDetector(
                  onTap: handlePlay,
                  child: Obx(
                    () => NetworkImgLayer(
                      radius: 0,
                      quality: 60,
                      src: videoDetailController.cover.value,
                      width: width,
                      height: height,
                      boxFit: BoxFit.cover,
                      forceUseCacheWidth: true,
                      getPlaceHolder: () => Center(
                        child: Image.asset('assets/images/loading.png'),
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          manualPlayerWidget,

          if (videoDetailController.plPlayerController.enableSponsorBlock ||
              videoDetailController.continuePlayingPart)
            Positioned(
              left: 16,
              bottom: isFullScreen ? max(75, maxHeight * 0.25) : 75,
              child: SizedBox(
                width: MediaQuery.textScalerOf(context).scale(120),
                child: AnimatedList(
                  padding: EdgeInsets.zero,
                  key: videoDetailController.listKey,
                  reverse: true,
                  shrinkWrap: true,
                  initialItemCount: videoDetailController.listData.length,
                  itemBuilder: (context, index, animation) {
                    return videoDetailController.buildItem(
                      videoDetailController.listData[index],
                      animation,
                    );
                  },
                ),
              ),
            ),

          // for debug
          // Positioned(
          //   right: 16,
          //   bottom: 75,
          //   child: FilledButton.tonal(
          //     onPressed: () {
          //       videoDetailController.onAddItem(
          //         SegmentModel(
          //           UUID: '',
          //           segmentType:
          //               SegmentType.values[Utils.random.nextInt(
          //                 SegmentType.values.length,
          //               )],
          //           segment: Pair(first: 0, second: 0),
          //           skipType: SkipType.alwaysSkip,
          //         ),
          //       );
          //     },
          //     child: const Text('skip'),
          //   ),
          // ),
          // Positioned(
          //   right: 16,
          //   bottom: 120,
          //   child: FilledButton.tonal(
          //     onPressed: () {
          //       videoDetailController.onAddItem(2);
          //     },
          //     child: const Text('index'),
          //   ),
          // ),
          Obx(
            () {
              if (videoDetailController.showSteinEdgeInfo.value) {
                try {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: plPlayerController?.showControls.value == true
                            ? 75
                            : 16,
                      ),
                      child: Wrap(
                        spacing: 25,
                        runSpacing: 10,
                        children: videoDetailController
                            .steinEdgeInfo!
                            .edges!
                            .questions!
                            .first
                            .choices!
                            .map((item) {
                              return FilledButton.tonal(
                                style: FilledButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                  backgroundColor: themeData
                                      .colorScheme
                                      .secondaryContainer
                                      .withValues(alpha: 0.8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  ugcIntroController.onChangeEpisode(
                                    item,
                                    isStein: true,
                                  );
                                  videoDetailController.getSteinEdgeInfo(
                                    item.id,
                                  );
                                },
                                child: Text(item.option!),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  );
                } catch (e) {
                  if (kDebugMode) debugPrint('build stein edges: $e');
                  return const SizedBox.shrink();
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget videoIntro({
    double? width,
    double? height,
    bool? isHorizontal,
    bool needRelated = true,
    bool needCtr = true,
    bool isNested = false,
  }) {
    Widget introPanel() => KeepAliveWrapper(
      builder: (context) {
        final child = CustomScrollView(
          controller: needCtr ? introScrollController : null,
          physics: !needCtr
              ? const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                )
              : null,
          slivers: [
            if (videoDetailController.isUgc) ...[
              UgcIntroPanel(
                key: videoIntroKey,
                heroTag: heroTag,
                showAiBottomSheet: showAiBottomSheet,
                showEpisodes: showEpisodes,
                onShowMemberPage: onShowMemberPage,
                isPortrait: isPortrait,
                isHorizontal: isHorizontal ?? width! > height! * kScreenRatio,
              ),
              if (needRelated &&
                  videoDetailController
                      .plPlayerController
                      .showRelatedVideo) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: StyleString.safeSpace),
                    child: Divider(
                      height: 1,
                      indent: 12,
                      endIndent: 12,
                      color: themeData.colorScheme.outline.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),
                ),
                RelatedVideoPanel(key: videoRelatedKey, heroTag: heroTag),
              ],
            ] else
              PgcIntroPage(
                key: videoIntroKey,
                heroTag: heroTag,
                cid: videoDetailController.cid.value,
                showEpisodes: showEpisodes,
                showIntroDetail: showIntroDetail,
                maxWidth: width ?? maxWidth,
                isLandscape: !isPortrait,
              ),
            SliverToBoxAdapter(
              child: SizedBox(
                height:
                    (videoDetailController.isPlayAll && !isPortrait
                        ? 80
                        : StyleString.safeSpace) +
                    padding.bottom,
              ),
            ),
          ],
        );
        if (isNested) {
          return ExtendedVisibilityDetector(
            uniqueKey: const Key('intro-panel'),
            child: child,
          );
        }
        return child;
      },
    );
    if (videoDetailController.isPlayAll) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          introPanel(),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12 + padding.bottom,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => videoDetailController.showMediaListPanel(context),
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.secondaryContainer.withValues(
                      alpha: 0.95,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.playlist_play, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        videoDetailController.watchLaterTitle,
                        style: TextStyle(
                          color: themeData.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.keyboard_arrow_up_rounded, size: 26),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return introPanel();
  }

  Widget get seasonPanel {
    final videoDetail = ugcIntroController.videoDetail.value;
    return KeepAliveWrapper(
      builder: (context) => Column(
        children: [
          if ((videoDetail.pages?.length ?? 0) > 1)
            if (videoDetail.ugcSeason != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: PagesPanel(
                  heroTag: heroTag,
                  ugcIntroController: ugcIntroController,
                  bvid: ugcIntroController.bvid,
                  showEpisodes: showEpisodes,
                ),
              )
            else
              Expanded(
                child: Obx(
                  () => EpisodePanel(
                    heroTag: heroTag,
                    enableSlide: false,
                    ugcIntroController: videoDetailController.isUgc
                        ? ugcIntroController
                        : null,
                    type: EpisodeType.part,
                    list: [videoDetail.pages!],
                    cover: videoDetailController.cover.value,
                    bvid: videoDetailController.bvid,
                    aid: videoDetailController.aid,
                    cid: videoDetailController.cid.value,
                    isReversed: videoDetail.isPageReversed,
                    onChangeEpisode: videoDetailController.isUgc
                        ? ugcIntroController.onChangeEpisode
                        : pgcIntroController.onChangeEpisode,
                    showTitle: false,
                    isSupportReverse: videoDetailController.isUgc,
                    onReverse: () => onReversePlay(isSeason: false),
                  ),
                ),
              ),
          if (videoDetail.ugcSeason != null) ...[
            if ((videoDetail.pages?.length ?? 0) > 1) ...[
              const SizedBox(height: 8),
              Divider(
                height: 1,
                color: themeData.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Obx(
                () => SeasonPanel(
                  key: ValueKey(introController.videoDetail.value),
                  heroTag: heroTag,
                  canTap: false,
                  showEpisodes: showEpisodes,
                  ugcIntroController: ugcIntroController,
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => EpisodePanel(
                  heroTag: heroTag,
                  enableSlide: false,
                  ugcIntroController: videoDetailController.isUgc
                      ? ugcIntroController
                      : null,
                  type: EpisodeType.season,
                  initialTabIndex: videoDetailController.seasonIndex.value,
                  cover: videoDetailController.cover.value,
                  seasonId: videoDetail.ugcSeason!.id,
                  list: videoDetail.ugcSeason!.sections!,
                  bvid: videoDetailController.bvid,
                  aid: videoDetailController.aid,
                  cid: videoDetailController.seasonCid ?? 0,
                  isReversed: ugcIntroController
                      .videoDetail
                      .value
                      .ugcSeason!
                      .sections![videoDetailController.seasonIndex.value]
                      .isReversed,
                  onChangeEpisode: videoDetailController.isUgc
                      ? ugcIntroController.onChangeEpisode
                      : pgcIntroController.onChangeEpisode,
                  showTitle: false,
                  isSupportReverse: videoDetailController.isUgc,
                  onReverse: () => onReversePlay(isSeason: true),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget videoReplyPanel({bool isNested = false}) => VideoReplyPanel(
    key: videoReplyPanelKey,
    isNested: isNested,
    heroTag: heroTag,
    onViewImage: videoDetailController.onViewImage,
    onDismissed: videoDetailController.onDismissed,
  );

  // ai总结
  void showAiBottomSheet() {
    videoDetailController.childKey.currentState?.showBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(),
      (context) =>
          AiConclusionPanel(item: ugcIntroController.aiConclusionResult!),
    );
  }

  void showIntroDetail(
    PgcInfoModel videoDetail,
    List<VideoTagItem>? videoTags,
  ) {
    videoDetailController.childKey.currentState?.showBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(),
      (context) => PgcIntroPanel(
        item: videoDetail,
        videoTags: videoTags,
      ),
    );
  }

  void showEpisodes([
    int? index,
    UgcSeason? season,
    episodes,
    String? bvid,
    int? aid,
    int? cid,
  ]) {
    assert((cid == null) == (bvid == null));
    final isFullScreen = this.isFullScreen;
    if (cid == null) {
      videoDetailController.showMediaListPanel(context);
      return;
    }
    Widget listSheetContent({bool enableSlide = true}) => EpisodePanel(
      heroTag: heroTag,
      ugcIntroController: videoDetailController.isUgc
          ? ugcIntroController
          : null,
      type: season != null
          ? EpisodeType.season
          : episodes is List<Part>
          ? EpisodeType.part
          : EpisodeType.pgc,
      cover: videoDetailController.cover.value,
      enableSlide: enableSlide,
      initialTabIndex: index ?? 0,
      bvid: bvid!,
      aid: aid,
      cid: cid,
      seasonId: season?.id,
      list: season != null ? season.sections! : [episodes],
      isReversed: !videoDetailController.isUgc
          ? null
          : season != null
          ? ugcIntroController
                .videoDetail
                .value
                .ugcSeason!
                .sections![videoDetailController.seasonIndex.value]
                .isReversed
          : ugcIntroController.videoDetail.value.isPageReversed,
      isSupportReverse: videoDetailController.isUgc,
      onChangeEpisode: videoDetailController.isUgc
          ? ugcIntroController.onChangeEpisode
          : pgcIntroController.onChangeEpisode,
      onClose: Get.back,
      onReverse: () {
        Get.back();
        onReversePlay(isSeason: season != null);
      },
    );
    if (isFullScreen || videoDetailController.showVideoSheet) {
      PageUtils.showVideoBottomSheet(
        context,
        isFullScreen: () => isFullScreen,
        child: videoDetailController.plPlayerController.darkVideoPage
            ? Theme(
                data: themeData,
                child: listSheetContent(enableSlide: false),
              )
            : listSheetContent(enableSlide: false),
      );
    } else {
      videoDetailController.childKey.currentState?.showBottomSheet(
        backgroundColor: Colors.transparent,
        constraints: const BoxConstraints(),
        (context) => listSheetContent(),
      );
    }
  }

  void onReversePlay({required bool isSeason}) {
    if (isSeason && videoDetailController.isPlayAll) {
      SmartDialog.showToast('当前为播放全部，合集不支持倒序');
      return;
    }

    final videoDetail = ugcIntroController.videoDetail.value;
    if (isSeason) {
      // reverse season
      final item = videoDetail
          .ugcSeason!
          .sections![videoDetailController.seasonIndex.value];
      item
        ..isReversed = !item.isReversed
        ..episodes = item.episodes!.reversed.toList();

      if (!videoDetailController.plPlayerController.reverseFromFirst) {
        // keep current episode
        videoDetailController
          ..seasonIndex.refresh()
          ..cid.refresh();
      } else {
        // switch to first episode
        var episode = ugcIntroController
            .videoDetail
            .value
            .ugcSeason!
            .sections![videoDetailController.seasonIndex.value]
            .episodes!
            .first;
        if (episode.cid != videoDetailController.cid.value) {
          ugcIntroController.onChangeEpisode(episode);
          videoDetailController.seasonCid = episode.cid;
        } else {
          videoDetailController
            ..seasonIndex.refresh()
            ..cid.refresh();
        }
      }
    } else {
      // reverse part
      videoDetail
        ..isPageReversed = !videoDetail.isPageReversed
        ..pages = videoDetail.pages!.reversed.toList();
      if (!videoDetailController.plPlayerController.reverseFromFirst) {
        // keep current episode
        videoDetailController.cid.refresh();
      } else {
        // switch to first episode
        var episode = videoDetail.pages!.first;
        if (episode.cid != videoDetailController.cid.value) {
          ugcIntroController.onChangeEpisode(episode);
        } else {
          videoDetailController.cid.refresh();
        }
      }
    }
  }

  void showViewPoints() {
    if (isFullScreen || videoDetailController.showVideoSheet) {
      PageUtils.showVideoBottomSheet(
        context,
        isFullScreen: () => isFullScreen,
        child: videoDetailController.plPlayerController.darkVideoPage
            ? Theme(
                data: themeData,
                child: ViewPointsPage(
                  enableSlide: false,
                  videoDetailController: videoDetailController,
                  plPlayerController: plPlayerController,
                ),
              )
            : ViewPointsPage(
                enableSlide: false,
                videoDetailController: videoDetailController,
                plPlayerController: plPlayerController,
              ),
      );
    } else {
      videoDetailController.childKey.currentState?.showBottomSheet(
        backgroundColor: Colors.transparent,
        constraints: const BoxConstraints(),
        (context) => ViewPointsPage(
          videoDetailController: videoDetailController,
          plPlayerController: plPlayerController,
        ),
      );
    }
  }

  void _onPopInvokedWithResult(bool didPop, result) {
    if (didPop) {
      videoDetailController.plPlayerController.disableAutoEnterPipIfNeeded();
    }
    if (plPlayerController?.controlsLock.value == true) {
      plPlayerController?.onLockControl(false);
      return;
    }
    if (isFullScreen) {
      videoDetailController.plPlayerController.triggerFullScreen(status: false);
      return;
    }
    if (!videoDetailController.horizontalScreen && !isPortrait) {
      verticalScreenForTwoSeconds();
      return;
    }
  }

  void onShowMemberPage(int? mid) {
    videoDetailController.childKey.currentState?.showBottomSheet(
      shape: const RoundedRectangleBorder(),
      constraints: const BoxConstraints(),
      (context) {
        return HorizontalMemberPage(
          mid: mid,
          videoDetailController: videoDetailController,
          ugcIntroController: ugcIntroController,
        );
      },
    );
  }
}
