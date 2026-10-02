import 'dart:io' show Platform;
import 'dart:math';

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/flutter/pop_scope.dart';
import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/pip_mini_video_content.dart';
import 'package:PiliPlus/common/widgets/route_aware_mixin.dart';
import 'package:PiliPlus/common/widgets/scaffold/mini_scaffold.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_behavior.dart'
    show NoOverscrollIndicator;
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show tabBarView, platformAlwaysClampingPhysics, platformClampingPhysics;
import 'package:PiliPlus/common/widgets/simple_app_bar.dart';
import 'package:PiliPlus/common/widgets/sliver/video_header.dart';
import 'package:PiliPlus/common/widgets/svg/play_icon.dart';
import 'package:PiliPlus/models/common/episode_panel_type.dart';
import 'package:PiliPlus/models/common/list_order.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart' as ugc;
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/models_new/video/video_detail/ugc_season.dart';
import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/pages/ai_chat/controller.dart';
import 'package:PiliPlus/pages/ai_chat/view.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/danmaku/view.dart';
import 'package:PiliPlus/pages/episode_panel/view.dart';
import 'package:PiliPlus/pages/video/ai_conclusion/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/local/controller.dart';
import 'package:PiliPlus/pages/video/introduction/local/view.dart';
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
import 'package:PiliPlus/pages/video/widgets/keyboard_scrollable.dart';
import 'package:PiliPlus/pages/video/view_point/view.dart';
import 'package:PiliPlus/pages/video/widgets/header_control.dart';
import 'package:PiliPlus/pages/video/widgets/intro_layout.dart';
import 'package:PiliPlus/pages/video/widgets/player_focus.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/plugin/pl_player/view/view.dart';
import 'package:PiliPlus/services/live_pip_overlay_service.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/services/pip_overlay_service.dart';
import 'package:PiliPlus/services/pip_transition_coordinator.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/services/shutdown_timer_service.dart'
    show shutdownTimerService;
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/max_screen_size.dart';
import 'package:PiliPlus/utils/mobile_observer.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/foundation.dart' show kDebugMode, clampDouble;
import 'package:flutter/services.dart' show SystemChrome;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';

class VideoDetailPageV extends StatefulWidget {
  const VideoDetailPageV({super.key});

  @override
  State<VideoDetailPageV> createState() => _VideoDetailPageVState();
}

class _VideoDetailPageVState extends State<VideoDetailPageV>
    with RouteAware, RouteAwareMixin, WidgetsBindingObserver {
  late final String heroTag;

  late final VideoDetailController videoDetailController;
  late final VideoReplyController _videoReplyController;
  PlPlayerController? plPlayerController;

  // 标志位：是否正在进入 PiP 模式（用于防止 dispose/didPushNext 时清理播放器状态）
  bool _isEnteringPipMode = false;

  // 标志位：_onPopInvokedWithResult 触发了 didPop=true 但 PiP 被其他视频/直播抢占，
  // 需要在 didPopNext 关闭其他 PiP 后重试启动
  bool _pipRetryPending = false;

  // 标志位：三点菜单「应用内画中画」发起的 pop，一次性；由 _onPopInvokedWithResult 消费，
  // 让本次收起绕过设置开关与嵌套栈判断
  bool _manualPipRequested = false;

  // 从 PiP 恢复时提前取出的 additional controllers（在 stopPip 清空前保存）
  dynamic _savedIntroControllerFromPip;
  VideoReplyController? _savedReplyControllerFromPip;

  // 归位动画进行中：页面播放器以透明占位先行布局（供量取目标矩形），
  // 恢复握手完成后亮出，期间小窗是唯一可见端
  bool _pipRestoreInFlight = false;
  int _pipRestoreRectAttempts = 0;

  // 页面根节点 key：归位目标矩形以页面根为参照系量取——路由转场期间页面
  // 整体在移动，相对页面根的矩形 == 页面落定后的全局矩形
  final _pageRootKey = GlobalKey();

  // intro ctr
  late final CommonIntroController introController =
      videoDetailController.isFileSource
      ? localIntroController
      : videoDetailController.isUgc
      ? ugcIntroController
      : pgcIntroController;
  late final UgcIntroController ugcIntroController;
  late final PgcIntroController pgcIntroController;
  late final LocalIntroController localIntroController;

  void _logSponsorBlock(String message) {
    if (!kDebugMode) return;
    logger.i('[${videoDetailController.hashCode}] [SponsorBlock] $message');
  }

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

  // 本页能否被 pop 收起：popScope 的 canPop 与手动小窗入口共用同一判定
  bool get _canPopPage =>
      videoDetailController.canPopPage(isPortrait: isPortrait);

  bool get _shouldShowSeasonPanel {
    if (videoDetailController.isFileSource ||
        isPortrait ||
        !videoDetailController.isUgc) {
      return false;
    }
    late final videoDetail = ugcIntroController.videoDetail.value;
    return videoDetailController.plPlayerController.horizontalSeasonPanel &&
        (videoDetail.ugcSeason != null ||
            ((videoDetail.pages?.length ?? 0) > 1));
  }

  void _resetEnteringPipFlags() {
    _isEnteringPipMode = false;
    videoDetailController.isEnteringPip = false;
    if (videoDetailController.showReply) {
      _videoReplyController.isEnteringPip = false;
    }
    if (videoDetailController.isFileSource) {
      localIntroController.isEnteringPip = false;
    } else if (videoDetailController.isUgc) {
      ugcIntroController.isEnteringPip = false;
    } else {
      pgcIntroController.isEnteringPip = false;
    }
  }

  final videoReplyPanelKey = GlobalKey();
  final videoRelatedKey = GlobalKey();
  final videoIntroKey = GlobalKey();

  /// 播放器键盘焦点：点/悬停视频区、切换 tab 时抢回，方向键恢复音量控制
  final playerFocusNode = FocusNode();

  /// tab 内容区键盘焦点：切到内容 tab 时自动聚焦，方向键免点击滚动内容
  final tabContentFocusNode = FocusNode();

  /// 播放列表 tab 的 EpisodePanel，方向键滚动其当前列表
  final seasonEpisodeKey = GlobalKey<EpisodePanelState>();

  /// 量取页面播放器矩形。relativeToPage 时以页面根为参照系(用于归位目标,
  /// 规避路由转场偏移),否则为全局坐标(用于收起源矩形,pop/push 甫一触发
  /// 页面尚未移动,全局坐标即所见位置)
  Rect? _playerRect({bool relativeToPage = false}) {
    final renderObject = videoDetailController
        .videoPlayerKey
        .currentContext
        ?.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize ||
        // 占位副本挂载初期是零尺寸 SizedBox.shrink,视为未量到,交由重试
        renderObject.size.isEmpty) {
      return null;
    }
    if (relativeToPage) {
      final pageRenderObject = _pageRootKey.currentContext?.findRenderObject();
      if (pageRenderObject is RenderBox && pageRenderObject.attached) {
        return renderObject.localToGlobal(
              Offset.zero,
              ancestor: pageRenderObject,
            ) &
            renderObject.size;
      }
      return null;
    }
    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  /// C1/C2 共用:页面就绪后量取归位目标矩形并上报协调器。
  /// 播放器占位可能要等 videoState 置位后一两帧才有布局,最多重试 10 帧;
  /// 始终量不到则上报 null(小窗按预估目标降级收尾)
  void _schedulePipRestoreAttach() {
    _pipRestoreRectAttempts = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) => _attachPipRestore());
  }

  void _attachPipRestore() {
    if (!mounted || !_pipRestoreInFlight) return;
    final targetRect = _playerRect(relativeToPage: true);
    if (targetRect == null && _pipRestoreRectAttempts++ < 10) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _attachPipRestore());
      return;
    }
    PipOverlayService.transition.attachRestorePage(
      targetRect: targetRect,
      onCompleted: () {
        // 握手完成(或协调器已离开归位相位的防御路径):亮出页面播放器
        if (!mounted) {
          _pipRestoreInFlight = false;
          return;
        }
        setState(() => _pipRestoreInFlight = false);
        // 恢复后控制栏保持收起（一点即出），底部进度/高能条立即可见；
        // 置 true 会让高能条被 offstage 到自动隐藏计时结束
        plPlayerController?.controls = false;
        _resetEnteringPipFlags();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    VideoStackManager.increment(); // 追踪视频页面层级
    final bool fromPip = Get.arguments['fromPip'] ?? false;
    final String? targetContextKey = PipOverlayService.contextKeyFromArgs(
      Get.arguments is Map ? Get.arguments as Map : null,
    );
    // 同视频复用：从推荐流/动态等入口点开 PiP 中正在播放的同一视频
    // （videoType|bvid|cid|epId|seasonId 完全匹配）时，走与 fromPip
    // 相同的 controller 恢复路径，避免重新加载。cid 不同则正常加载。
    final bool isSameVideo =
        !fromPip &&
        targetContextKey != null &&
        targetContextKey == PipOverlayService.savedVideoContextKey;
    final bool shouldRestoreFromPip = fromPip || isSameVideo;
    final restoredController =
        shouldRestoreFromPip && PipOverlayService.isInPipMode
        ? PipOverlayService.getSavedController<VideoDetailController>()
        : null;
    final bool restoringFromPip = restoredController != null;

    // heroTag 是这组 GetX controller 的作用域标识。复用已有 controller
    // 时必须沿用其原 tag；这里只在页面初始化时决定一次，之后保持不变。
    heroTag = restoredController?.heroTag ?? Get.arguments['heroTag'];
    if (restoredController != null && Get.arguments is Map) {
      // 附属 controller 的 onInit 仍从 Get.arguments 读取 heroTag，需在创建
      // 它们之前同步为同一作用域，避免主/附属 controller 的 tag 分裂。
      (Get.arguments as Map)['heroTag'] = heroTag;
    }

    // 如果有直播间 PiP 在运行，关闭它（采用非销毁式，避免干扰视频播放器单例）
    if (LivePipOverlayService.isInPipMode && !fromPip) {
      // 关闭小窗并停止直播播放（从列表点击视频应该停止旧的直播播放）
      final savedLive =
          LivePipOverlayService.getSavedController<LiveRoomController>();
      // 旧直播 controller 就此退休，关闭其弹幕流/计时器/通知条目防泄漏
      LivePipOverlayService.cleanupSavedController();
      LivePipOverlayService.stopLivePip(callOnClose: false);
      // stopLivePip(callOnClose: false) 不会调用 onClose，手动暂停直播播放器
      savedLive?.plPlayerController.pause();
    }

    PlPlayerController.setPlayCallBack(playCallBack);

    // 如果从 PiP 返回或从外部入口点开同视频，尝试恢复保存的控制器
    if (shouldRestoreFromPip && PipOverlayService.isInPipMode) {
      final savedController = restoredController;
      if (savedController != null) {
        // 必须在 stopPip 之前取出所有 additional controllers，
        // 因为 stopPip 会调用 _savedControllers.clear() 清空缓存
        final savedReplyControllerFromPip =
            PipOverlayService.getAdditionalController<VideoReplyController>(
              'reply',
            );
        final savedIntroControllerFromPip =
            PipOverlayService.getAdditionalController('intro');

        // 直接使用保存的控制器
        videoDetailController = savedController;
        videoDetailController.isEnteringPip = false; // 重置标志
        videoDetailController.$reopenLifeCycle(); // 重置 isClosed
        Get.put(savedController, tag: heroTag);

        // 点击展开（归位动画中）：小窗仍在飞向本页，非销毁式 stopPip 推迟到
        // 握手完成由协调器触发 _finalizeRestore 执行；本页播放器先透明占位。
        // 其余场景（如从听视频页带 fromPip 返回）维持旧的瞬时关闭
        if (PipOverlayService.transition.phase == PipPhase.restoring &&
            targetContextKey != null &&
            targetContextKey == PipOverlayService.savedVideoContextKey) {
          _pipRestoreInFlight = true;
          _schedulePipRestoreAttach();
        } else {
          PipOverlayService.stopPip(
            callOnClose: false,
            immediate: true,
            targetContextKey: targetContextKey,
          );
        }

        // 将提前取出的 additional controllers 存回局部变量供后续使用
        _savedReplyControllerFromPip = savedReplyControllerFromPip;
        _savedIntroControllerFromPip = savedIntroControllerFromPip;
        _logSponsorBlock(
          'Restored controller from PiP, hashCode: ${savedController.hashCode}, segmentList.length: ${savedController.segmentList.length}',
        );

        // 强制刷新 UI 状态
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _logSponsorBlock('Refreshing videoState and cid after return');
          videoDetailController.videoState.refresh();
          videoDetailController.cid.refresh();
          videoDetailController.update();
        });
      } else {
        // 没有保存的控制器，创建新的
        PipOverlayService.stopPip(
          callOnClose: false,
          immediate: true,
          targetContextKey: targetContextKey,
        );
        videoDetailController = Get.put(VideoDetailController(), tag: heroTag);
      }
    } else {
      // 非 PiP 返回，正常流程（包括原页面还留在栈中或由于某些原因被销毁重构）
      if (PipOverlayService.isInPipMode) {
        // 关闭小窗，释放旧页面 owner（清媒体会话、dispose 播放器，
        // 从列表点击视频应该停止旧的播放）
        final savedController =
            PipOverlayService.getSavedController<VideoDetailController>();
        final fromVideoPage =
            VideoStackManager.getCount() > 1 ||
            PipOverlayService.isVideoLikeRoute(Get.previousRoute);
        final savedWasPlaying =
            fromVideoPage &&
            (savedController?.plPlayerController.playerStatus.isPlaying ??
                false);
        if (savedWasPlaying) {
          savedController!.playerStatus = PlayerStatus.playing;
        }
        PipOverlayService.stopPip(
          callOnClose: false,
          immediate: true,
          targetContextKey: targetContextKey,
          releaseSavedOwner: true,
          // 旧视频页仍在栈内（链式进入新视频）时只暂停不 dispose，
          // 保留播放器实例与计数供返回时恢复
          disposeSavedOwnerPlayer: !fromVideoPage,
        );
      }
      videoDetailController = Get.put(VideoDetailController(), tag: heroTag);
    }

    if (videoDetailController.removeSafeArea) {
      hideSystemBar();
    }

    if (videoDetailController.showReply) {
      // 尝试从 PiP 恢复 ReplyController
      // 注意：_savedReplyControllerFromPip 在 stopPip 之前已提前取出
      final savedReplyController =
          _savedReplyControllerFromPip ??
          (restoringFromPip
              ? PipOverlayService.getAdditionalController<VideoReplyController>(
                  'reply',
                )
              : null);
      if (savedReplyController != null) {
        _videoReplyController = savedReplyController;
        _videoReplyController.isEnteringPip = false; // 重置标志
        Get.put(savedReplyController, tag: heroTag);
        _logSponsorBlock('Restored VideoReplyController from PiP');
      } else {
        _videoReplyController = Get.put(
          VideoReplyController(
            aid: videoDetailController.aid,
            videoType: videoDetailController.videoType,
            heroTag: heroTag,
          ),
          tag: heroTag,
        );
      }
    }

    // 尝试从 PiP 恢复 IntroController
    // 注意：_savedIntroControllerFromPip 在 stopPip 之前已提前取出
    final savedIntroController =
        _savedIntroControllerFromPip ??
        (restoringFromPip
            ? PipOverlayService.getAdditionalController('intro')
            : null);

    if (videoDetailController.isFileSource) {
      if (savedIntroController != null &&
          savedIntroController is LocalIntroController) {
        localIntroController = savedIntroController;
        localIntroController.isEnteringPip = false; // 重置标志
        Get.put(localIntroController, tag: heroTag);
        _logSponsorBlock('Restored LocalIntroController from PiP');
      } else {
        localIntroController = Get.put(LocalIntroController(), tag: heroTag);
      }
    } else if (videoDetailController.isUgc) {
      if (savedIntroController != null &&
          savedIntroController is UgcIntroController) {
        ugcIntroController = savedIntroController;
        ugcIntroController.isEnteringPip = false; // 重置标志
        Get.put(ugcIntroController, tag: heroTag);
        _logSponsorBlock(
          'Restored UgcIntroController from PiP, videoDetail.bvid: ${ugcIntroController.videoDetail.value.bvid}',
        );
      } else {
        ugcIntroController = Get.put(UgcIntroController(), tag: heroTag);
      }
    } else {
      if (savedIntroController != null &&
          savedIntroController is PgcIntroController) {
        pgcIntroController = savedIntroController;
        pgcIntroController.isEnteringPip = false; // 重置标志
        Get.put(pgcIntroController, tag: heroTag);
        _logSponsorBlock('Restored PgcIntroController from PiP');
      } else {
        pgcIntroController = Get.put(PgcIntroController(), tag: heroTag);
      }
    }

    // AI chat controller - create if not already registered (PiP reuse)
    if (!Get.isRegistered<AiChatController>(tag: heroTag)) {
      Get.put(AiChatController(heroTag: heroTag), tag: heroTag);
    }

    // 必须在 videoDetailController 三条赋值路径（恢复/新建）汇合之后绑定
    videoDetailController.onRequestInAppPip = _enterInAppPipManually;

    if (restoringFromPip) {
      plPlayerController = videoDetailController.plPlayerController;
      final wasPlaying = plPlayerController!.playerStatus.isPlaying;

      // 重新创建 TabController，因为旧的 vsync (State) 已经失效
      final List<String> initialTabs = [
        videoDetailController.isFileSource ? '离线视频' : '简介',
        if (videoDetailController.showReply) '评论',
      ];
      videoDetailController.tabCtr = TabController(
        vsync: videoDetailController,
        length: initialTabs.length,
        initialIndex: videoDetailController.tabCtr.index.clamp(
          0,
          initialTabs.length - 1,
        ),
      );

      plPlayerController!
        ..addStatusLister(playerListener)
        ..addPositionListener(positionListener);

      if (plPlayerController!.isFullScreen.value) {
        plPlayerController!.triggerFullScreen(status: false);
      }
      // 控制栏保持收起：置 true 会把状态卡在"打开"（挂载前置位无视觉），
      // 底部进度/高能条被 offstage 到自动隐藏计时结束，且首次点击变成关闭
      plPlayerController!.controls = false;

      _logSponsorBlock(
        'Returning from PiP, segmentList.length: ${videoDetailController.segmentList.length}',
      );
      _logSponsorBlock(
        'videoDetailController status: videoState=${videoDetailController.videoState.value}, isClosed=${videoDetailController.isClosed}',
      );

      // 立即调用 setState 触发 build
      if (mounted) {
        setState(() {});
      }

      // 然后在下一帧刷新所有 observable
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _logSponsorBlock('First postFrameCallback executing');

        videoDetailController.videoState.value = true;
        videoDetailController.videoState.refresh();
        if (wasPlaying && !plPlayerController!.playerStatus.isPlaying) {
          plPlayerController!.play();
        }
        videoDetailController.cid.refresh();
        videoDetailController.cover.refresh();

        // 确保 IntroController 的数据被 UI 识别
        if (videoDetailController.isUgc &&
            savedIntroController is UgcIntroController) {
          _logSponsorBlock(
            'UgcIntroController status: ${savedIntroController.status.value}, videoDetail items: ${savedIntroController.videoDetail.value.pages?.length}',
          );
          savedIntroController.videoDetail.refresh();
          savedIntroController.status.refresh();
          savedIntroController.update();
        } else if (videoDetailController.isFileSource &&
            savedIntroController is LocalIntroController) {
          savedIntroController.videoDetail.refresh();
          savedIntroController.update();
        } else if (!videoDetailController.isUgc &&
            !videoDetailController.isFileSource &&
            savedIntroController is PgcIntroController) {
          savedIntroController.videoDetail.refresh();
          savedIntroController.update();
        } else if (videoDetailController.isFileSource &&
            savedIntroController is LocalIntroController) {
          savedIntroController.videoDetail.refresh();
          savedIntroController.update();
        }

        // 同样刷新 ReplyController
        if (videoDetailController.showReply) {
          try {
            final replyController = Get.find<VideoReplyController>(
              tag: heroTag,
            );
            replyController.update();
            _logSponsorBlock('Forced UI refresh for VideoReplyController');
          } catch (e) {
            _logSponsorBlock('Failed to refresh VideoReplyController: $e');
          }
        }

        // 强制 VideoDetailController 也更新
        videoDetailController.update();

        // 再次触发 setState 确保本组件重绘
        if (mounted) setState(() {});

        _logSponsorBlock('Completed postFrameCallback UI refresh');
      });

      // 确保 SponsorBlock 监听器正常工作
      // 从 PiP 返回时，必须重新创建 positionSubscription，因为是新页面实例
      if (videoDetailController.plPlayerController.enableSponsorBlock &&
          videoDetailController.segmentList.isNotEmpty) {
        _logSponsorBlock(
          'Re-creating position subscription for new page instance',
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            videoDetailController.initSkip();
            _logSponsorBlock(
              'Re-initialized SponsorBlock after PiP return, segmentList.length: ${videoDetailController.segmentList.length}',
            );
          }
        });
      }
    } else {
      videoSourceInit();
    }

    addObserverMobile(this);
  }

  // 获取视频资源，初始化播放器
  void videoSourceInit() {
    videoDetailController.queryVideoUrl(autoFullScreenFlag: true);
    if (videoDetailController.autoPlay) {
      plPlayerController = videoDetailController.plPlayerController;
      plPlayerController!
        ..addStatusLister(playerListener)
        ..addPositionListener(positionListener);
    }
  }

  void positionListener(Duration position) {
    final plPlayerController = videoDetailController.plPlayerController;
    if (!plPlayerController.isCurrentVideoSource(
      bvid: videoDetailController.bvid,
      cid: videoDetailController.cid.value,
    )) {
      return;
    }
    videoDetailController.playedTime = position;
    videoDetailController.danmakuMaskController.updatePosition(position);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isResume = state == .resumed;
    final ctr = videoDetailController.plPlayerController..visible = isResume;
    if (isResume) {
      if (Platform.isAndroid && !showSystemBar_) {
        SystemChrome.setEnabledSystemUIMode(.immersiveSticky);
      }
      if (!ctr.showDanmaku) {
        introController.startTimer();
        ctr.showDanmaku = true;
      }
    } else if (state == .paused) {
      introController.cancelTimer();
      ctr.showDanmaku = false;
    }
  }

  Future<void>? playCallBack() {
    if (!isShowing) {
      plPlayerController
        ?..addStatusLister(playerListener)
        ..addPositionListener(positionListener);
    }
    return plPlayerController?.play();
  }

  // 播放器状态监听
  Future<void> playerListener(PlayerStatus status) async {
    final isPlaying = status.isPlaying;
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
            videoDetailController.refreshPage();
          }
        } else {
          videoDetailController.refreshPage();
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('handle player status: $e');
    }

    if (status.isCompleted) {
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

      bool exitFlag = true;

      /// 顺序播放 列表循环
      if (shutdownTimerService.isWaiting) {
        shutdownTimerService.handleWaiting();
      } else {
        switch (plPlayerController!.playRepeat) {
          case PlayRepeat.singleCycle:
            exitFlag = false;
            plPlayerController!.play(repeat: true);
          case PlayRepeat.listOrder:
          case PlayRepeat.listCycle:
          case PlayRepeat.autoPlayRelated:
            if (!introController.nextPlay()) {
              if (videoDetailController.listOrder.isShuffle &&
                  videoDetailController.isPlayAll) {
                exitFlag = false;
                videoDetailController.getMediaList().then((_) {
                  introController.nextPlay();
                });
              }
            } else {
              exitFlag = false;
            }
          case PlayRepeat.pause:
        }
      }

      if (exitFlag) {
        if (autoExitFullscreen) {
          plPlayerController!.triggerFullScreen(status: false);
          if (plPlayerController!.controlsLock.value) {
            plPlayerController!.onLockControl(false);
          }
        } else {
          if (plPlayerController!.controlsLock.value &&
              (!Platform.isAndroid || !AndroidHelper.isPipMode)) {
            plPlayerController!.onLockControl(false);
          }
        }
      }
    }
  }

  // 继续播放或重新播放
  void continuePlay() {
    plPlayerController!.play();
  }

  /// 未开启自动播放时触发播放
  Future<void>? handlePlay() {
    if (!videoDetailController.isFileSource) {
      if (videoDetailController.isQuerying) {
        if (kDebugMode) debugPrint('handlePlay: querying');
        return null;
      }
      if (videoDetailController.videoUrl == null ||
          videoDetailController.audioUrl == null) {
        if (kDebugMode) {
          debugPrint('handlePlay: videoUrl/audioUrl not initialized');
        }
        videoDetailController.queryVideoUrl();
        return null;
      }
    }
    final plPlayerController = this.plPlayerController =
        videoDetailController.plPlayerController;
    videoDetailController.autoPlay = true;
    plPlayerController
      ..addStatusLister(playerListener)
      ..addPositionListener(positionListener);
    if (plPlayerController.preInitPlayer) {
      if (plPlayerController.autoEnterFullScreen) {
        plPlayerController.triggerFullScreen();
      }
      return plPlayerController.play();
    } else {
      return videoDetailController.playerInit(
        autoplay: true,
        autoFullScreenFlag: true,
      );
    }
  }

  @override
  void dispose() {
    VideoStackManager.decrement(); // 减少视频页面层级追踪
    final isInAppPip = PipOverlayService.isInPipMode;
    // 如果 _pipRetryPending=true 但用户没有继续 pop（_onPopInvokedWithResult 未触发），
    // 说明用户通过其他方式离开（点导航栏、Get.offAll 等），需要主动暂停播放器。
    if (_pipRetryPending && !isInAppPip && !_isEnteringPipMode) {
      plPlayerController?.pause();
      _pipRetryPending = false;
    }

    plPlayerController
      ?..removeStatusLister(playerListener)
      ..removePositionListener(positionListener);

    // 从小窗展开的新页面会复用同一 controller 并重新绑定，只解绑指向本页的引用
    if (videoDetailController.onRequestInAppPip == _enterInAppPipManually) {
      videoDetailController.onRequestInAppPip = null;
    }

    Get.delete<HorizontalMemberPageController>(
      tag: videoDetailController.heroTag,
    );

    if (!videoDetailController.isFileSource &&
        !isInAppPip &&
        !_isEnteringPipMode) {
      if (videoDetailController.isUgc) {
        ugcIntroController
          ..cancelTimer()
          ..videoDetail.close();
      } else {
        pgcIntroController.cancelTimer();
      }
    }

    if (!videoDetailController.removeSafeArea) {
      showSystemBar();
    }

    if (!videoDetailController.plPlayerController.isCloseAll) {
      if (isInAppPip || _isEnteringPipMode) {
        videoDetailController.makeHeartBeat();
      } else {
        videoPlayerServiceHandler?.onVideoDetailDispose(heroTag);
        if (plPlayerController != null) {
          videoDetailController.makeHeartBeat();
          plPlayerController!.dispose();
        } else {
          PlPlayerController.updatePlayCount();
        }
      }
    }
    removeObserverMobile(this);

    playerFocusNode.dispose();
    tabContentFocusNode.dispose();
    super.dispose();
  }

  @override
  // 离开当前页面时
  void didPushNext() {
    super.didPushNext();
    isShowing = false;

    removeObserverMobile(this);

    if (Platform.isAndroid && !videoDetailController.setSystemBrightness) {
      ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
    }

    // 2. 计算小窗触发状态
    final playerStatusBeforePush = plPlayerController?.playerStatus;
    final bool willStartPip =
        plPlayerController != null &&
        playerStatusBeforePush?.isPlaying == true &&
        !plPlayerController!.isFullScreen.value &&
        _shouldStartInAppPip();

    // 确定是否需要释放/暂停资源
    final bool shouldKeepAlive =
        _isEnteringPipMode || PipOverlayService.isInPipMode || willStartPip;

    introController.cancelTimer();

    videoDetailController
      ..playerStatus = willStartPip
          ? PlayerStatus.playing
          : playerStatusBeforePush
      ..brightness = plPlayerController?.brightness.value;

    if (shouldKeepAlive) {
      _logSponsorBlock(
        'didPushNext() preserving blockListener (entering PiP or in PiP mode)',
      );
    } else {
      _logSponsorBlock('didPushNext() cancelling blockListener');
      videoDetailController.cancelBlockListener();
    }

    // 无论是否进入小窗，离开当前页面时都标记隐藏播放器 UI
    // 这样做有两个目的：
    // 1. 收起页面内的播放器副本，小窗展示的是独立副本（不共享 GlobalKey），
    //    避免两份 PLVideoPlayer 同时渲染
    // 2. 确保下次 didPopNext 时 videoState.value = true 能触发 Obx 刷新
    videoDetailController.videoState.value = false;

    // 4. 处理播放器实例
    if (plPlayerController != null) {
      videoDetailController.makeHeartBeat();
      plPlayerController!
        ..removeStatusLister(playerListener)
        ..removePositionListener(positionListener);

      if (willStartPip) {
        _startInAppPipIfNeeded();
      } else if (!shouldKeepAlive) {
        // 只有在确定不进入小窗时才暂停播放
        plPlayerController!.pause();
      }
    }
  }

  @override
  // 返回当前页面时
  void didPopNext() async {
    super.didPopNext();

    if (videoDetailController.plPlayerController.isCloseAll) {
      return;
    }

    // 如果 local 的 plPlayerController 实例指向了已被销毁的单例，刷新它
    if (plPlayerController != videoDetailController.plPlayerController) {
      plPlayerController = videoDetailController.plPlayerController;
    }

    isShowing = true;

    addObserverMobile(this);

    plPlayerController?.isLive = false;

    // 如果是从应用内小窗返回（例如从子页面 Pop 回来，或者手动点击展开）
    if (PipOverlayService.isInPipMode) {
      // 用视频上下文 key 比较（而非 controller 实例），因为 controller 可能已被
      // dispose 再重建，实例比较会失败
      final isSameVideo =
          PipOverlayService.savedVideoContextKey ==
          PipOverlayService.contextKeyFromArgs(videoDetailController.args);
      if (isSameVideo) {
        _logSponsorBlock(
          'Returning to video page with matching active PiP, closing PiP overlay',
        );
        // 小窗里的实际状态是用户最新的播放意图（可能在小窗中手动暂停过），
        // 先于关闭小窗记录，交由 didPopNext 末尾统一对账
        videoDetailController.playerStatus =
            plPlayerController?.playerStatus;
        // 返回展开：小窗飞回页内播放器位置，非销毁式 stopPip 推迟到握手完成；
        // 无法归位（无小窗会话）则维持旧的瞬时关闭
        if (PipOverlayService.transition.beginRestore()) {
          _pipRestoreInFlight = true;
          _schedulePipRestoreAttach();
        } else {
          PipOverlayService.stopPip(
            callOnClose: false,
            immediate: true,
            targetContextKey: PipOverlayService.contextKeyFromArgs(
              videoDetailController.args,
            ),
          );
          _resetEnteringPipFlags();
          // 控制栏保持收起，避免状态卡"打开"导致高能条 offstage、首点失效
          plPlayerController?.controls = false;
        }
      } else {
        // 小窗里播放的是其他视频，返回到新的视频页面时必须关闭小窗，否则会同时播放两个视频
        _logSponsorBlock(
          'Returning to video page but PiP has different controller, closing PiP',
        );
        PipOverlayService.stopPip(callOnClose: true, immediate: true);
        // 当前页面之前可能曾尝试进入小窗（didPushNext 设置了 _isEnteringPipMode = true），
        // 但被其他视频抢占。需要重置该标志，否则 dispose 会跳过播放器清理，
        // 且 PopScope 不在 widget tree 中导致后续返回无法触发新的小窗
        _resetEnteringPipFlags();
        // 标记需要重试 PiP：关了别人的 PiP，恢复播放器后应尝试启动自己的 PiP
        _pipRetryPending = true;
      }
    } else if (_isEnteringPipMode || videoDetailController.isEnteringPip) {
      _resetEnteringPipFlags();
    }
    // 视频页返回时，若直播小窗仍在运行，也需关闭
    if (LivePipOverlayService.isInPipMode) {
      LivePipOverlayService.stopLivePip(callOnClose: true, immediate: true);
    }

    // 设置页可能改了「智能防挡」开关，回到本页时对齐一次
    videoDetailController.danmakuMaskController.syncEnabledFromPreference(
      videoDetailController.plPlayerController.positionInMilliseconds,
    );

    // 如果是从开启新页面方式（Get.toNamed）从小窗手动返回，播放器应已在运行，跳过部分重置逻辑
    final bool fromPip = Get.arguments?['fromPip'] ?? false;
    if (fromPip) {
      isShowing = true;
      PlPlayerController.setPlayCallBack(playCallBack);
      introController.startTimer();

      // 重新恢复 SponsorBlock
      if (videoDetailController.plPlayerController.enableSponsorBlock &&
          videoDetailController.segmentList.isNotEmpty) {
        videoDetailController.initSkip();
      }

      // didPushNext 时 videoState 被置为 false，需要在这里恢复
      // 场景：fromPip 页面（如听视频）返回时，播放器已在运行但 videoState 未恢复
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        videoDetailController.videoState.value = true;
        videoDetailController.videoState.refresh();
        setState(() {});
      });

      super.didPopNext();
      return;
    }

    PlPlayerController.setPlayCallBack(playCallBack);

    introController.startTimer();

    // 重新恢复 SponsorBlock (针对常规导航返回)
    if (videoDetailController.plPlayerController.enableSponsorBlock &&
        videoDetailController.segmentList.isNotEmpty) {
      videoDetailController.initSkip();
    }

    if (mounted &&
        Platform.isAndroid &&
        !videoDetailController.setSystemBrightness) {
      if (videoDetailController.brightness != null) {
        plPlayerController?.brightness.value =
            videoDetailController.brightness!;
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

    // 检查并恢复播放器实例
    // 场景：1. 播放器被销毁（小窗关闭） 2. 播放器被抢占（在其它页面播放了新的视频/直播）
    bool needsRecovery = false;
    if (plPlayerController?.videoPlayerController == null) {
      needsRecovery = true;
    } else if (plPlayerController!.isLive ||
        plPlayerController!.cid != videoDetailController.cid.value) {
      needsRecovery = true;
    }

    if (needsRecovery) {
      _logSponsorBlock('Player needs recovery (disposed or content mismatch)');
      await videoDetailController.playerInit(
        autoplay: videoDetailController.playerStatus?.isPlaying ?? false,
      );
      plPlayerController = videoDetailController.plPlayerController;
    } else {
      // 场景 3：直接恢复关联的小窗/后台播放器，确保界面正常显示
      // 由于小窗可能刚刚被关闭（OverlayEntry 移除），延迟一帧再展开主页播放器，
      // 确保移除生效后两份播放器副本不会同帧共存
      _logSponsorBlock('Restoring current player (delayed refresh)');
      // 统一对账：以离开页面/小窗时记录的期望状态为准，对齐实际播放状态。
      // 期望播放但实际暂停（如 didPushNext 未进小窗时暂停、关小窗时暂停）→ 恢复播放；
      // 期望暂停但实际播放 → 暂停（原上游保底暂停的语义）
      final expected = videoDetailController.playerStatus;
      if (expected != null &&
          expected.isPlaying != plPlayerController!.playerStatus.isPlaying) {
        if (expected.isPlaying) {
          plPlayerController!.play();
        } else {
          plPlayerController!.pause();
        }
      }
      // 如果播放器（应）处于播放状态，临时启用 autoPlay 以确保 UI 正确显示
      if (expected?.isPlaying ?? plPlayerController!.playerStatus.isPlaying) {
        videoDetailController.autoPlay = true;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        videoDetailController.videoState.value = true;
        videoDetailController.videoState.refresh();
        // 强制触发一次同步 UI 刷新，确保 sliver 和 layout 正确响应
        setState(() {});
      });
    }

    _syncCurrentMediaSessionOnResume();

    // 重注册全屏画质切换回调。
    // PlPlayerController 是单例，新视频页面 push 时会覆盖回调为其 controller 的闭包，
    // 返回本页后必须重新注册，否则进入全屏时会使用错误 controller 的数据。
    if (Platform.isAndroid || Platform.isIOS) {
      videoDetailController.setupFullScreenQualitySwitch();
    }

    plPlayerController
      ?..addStatusLister(playerListener)
      ..addPositionListener(positionListener);

    if (!videoDetailController.autoPlay &&
        videoDetailController.plPlayerController.preInitPlayer &&
        !videoDetailController.isQuerying &&
        videoDetailController.videoUrl != null) {
      videoDetailController.playerInit();
    }

    // 无论进入哪个分支，最后都刷新一下 UI
    if (mounted) setState(() {});

    // 不在此处重试 _startInAppPipIfNeeded。
    // didPopNext 是"返回到本页面"的回调，无法预知用户接下来是停留还是继续返回。
    // 若立即重试，会在用户停在本页时把视频错误地送入 PiP。
    // _pipRetryPending 留待 _onPopInvokedWithResult 消费——只有用户真正继续 pop 时才重试。
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (videoDetailController.removeSafeArea) {
      padding = .zero;
    } else {
      padding = MediaQuery.viewPaddingOf(context);
    }

    final size = MediaQuery.sizeOf(context);
    maxWidth = size.width;
    maxHeight = size.height;
    isWindowMode = MaxScreenSize.isWindowMode(
      width: maxWidth * videoDetailController.uiScale,
      height: maxHeight * videoDetailController.uiScale,
    );
    videoDetailController.plPlayerController.screenRatio = maxHeight / maxWidth;

    final shortestSide = size.shortestSide;
    final minVideoHeight = shortestSide / Style.aspectRatio16x9;
    final maxVideoHeight = max(size.longestSide * 0.65, shortestSide);
    videoDetailController
      ..isPortrait = isPortrait = maxHeight >= maxWidth
      ..minVideoHeight = minVideoHeight
      ..maxVideoHeight = maxVideoHeight
      ..videoHeight = videoDetailController.isVertical.value
          ? maxVideoHeight
          : minVideoHeight;

    theme = videoDetailController.plPlayerController.darkVideoPage
        ? ThemeUtils.darkTheme
        : Theme.of(context);
  }

  bool removeAppBar(bool isFullScreen) =>
      PlatformUtils.isDesktop ||
      videoDetailController.removeSafeArea ||
      (isWindowMode && isFullScreen && !isPortrait);

  Widget get childWhenDisabled {
    return Obx(
      () {
        final isFullScreen = this.isFullScreen;
        return SimpleScaffold(
          appBar: removeAppBar(isFullScreen)
              ? null
              : Obx(
                  () {
                    final scrollRatio = videoDetailController.scrollRatio.value;
                    final brightness = colorScheme.brightness;
                    final Brightness statusBarBrightness;
                    final Brightness statusBarIconBrightness;
                    final backgroundColor = isPortrait && scrollRatio > 0
                        ? Color.lerp(
                            Colors.black,
                            colorScheme.surface,
                            scrollRatio,
                          )!
                        : Colors.black;
                    if (isPortrait && scrollRatio >= 0.5) {
                      statusBarBrightness = brightness;
                      statusBarIconBrightness = brightness.reverse;
                    } else {
                      statusBarBrightness = .dark;
                      statusBarIconBrightness = .light;
                    }
                    return SimpleAppBar(
                      height: padding.top,
                      backgroundColor: backgroundColor,
                      brightness: brightness,
                      statusBarBrightness: statusBarBrightness,
                      statusBarIconBrightness: statusBarIconBrightness,
                    );
                  },
                ),
          body: ExtendedNestedScrollView(
            onlyOneScrollInBody: true,
            physics: platformClampingPhysics,
            key: videoDetailController.scrollKey,
            controller: videoDetailController.scrollCtr,
            scrollBehavior: const NoOverscrollIndicator(),
            pinnedHeaderSliverHeightBuilder: () {
              double pinnedHeight = this.isFullScreen || !isPortrait
                  ? maxHeight - (isWindowMode && !isPortrait ? 0 : padding.top)
                  : videoDetailController.isExpanding ||
                        videoDetailController.isCollapsing
                  ? videoDetailController.animHeight
                  : videoDetailController.isCollapsing ||
                        (plPlayerController?.playerStatus.isPlaying ?? false)
                  ? videoDetailController.minVideoHeight
                  : kToolbarHeight;
              if (videoDetailController.isExpanding &&
                  videoDetailController.animationController.value == 1) {
                videoDetailController.isExpanding = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  videoDetailController.scrollRatio.value = 0;
                  videoDetailController.refreshPage();
                });
              } else if (videoDetailController.isCollapsing &&
                  videoDetailController.animationController.value == 1) {
                videoDetailController.isCollapsing = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  videoDetailController.refreshPage();
                });
              }
              return pinnedHeight;
            },
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              final height = isFullScreen || !isPortrait
                  ? maxHeight - (isWindowMode && !isPortrait ? 0 : padding.top)
                  : videoDetailController.isExpanding ||
                        videoDetailController.isCollapsing
                  ? videoDetailController.animHeight
                  : videoDetailController.videoHeight;
              return [
                VideoHeader(
                  minExtent: kToolbarHeight,
                  maxExtent: height,
                  minVideoHeight: videoDetailController.minVideoHeight,
                  onScrollRatioChanged: videoDetailController.scrollRatio.call,
                  child: Stack(
                    clipBehavior: .none,
                    children: [
                      // 溢出垫层，解决预测性返回缩放动画时的亚像素白缝
                      const Positioned(
                        top: -1,
                        left: 0,
                        right: 0,
                        height: 2,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: maxWidth,
                        height: height,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(color: Colors.black),
                          child: videoPlayer(
                            width: maxWidth,
                            height: height,
                          ),
                        ),
                      ),
                      _buildHeaderOverlay(),
                    ],
                  ),
                ),
              ];
            },
            body: MiniScaffold(
              key: videoDetailController.childKey,
              body: Column(
                children: [
                  buildTabBar(onTap: videoDetailController.animToTop),
                  Expanded(
                    child: wrapTabContent(
                      tabBarView(
                        hitTestBehavior: .translucent,
                        controller: videoDetailController.tabCtr,
                        children: [
                          videoIntro(isHorizontal: false, needCtr: false),
                          if (videoDetailController.showReply)
                            videoReplyPanel(isNested: true),
                          if (_shouldShowSeasonPanel) seasonPanel,
                        ],
                      ),
                      // 竖屏：简介/评论滚整页，播放列表滚自身列表
                      resolveCtr: () {
                        final idx = videoDetailController.tabCtr.index;
                        return _shouldShowSeasonPanel &&
                                idx ==
                                    (videoDetailController.showReply ? 2 : 1)
                            ? _seasonScrollCtr()
                            : videoDetailController.scrollCtr;
                      },
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

  Widget _buildOverlayToolBar(double scrollRatio) {
    final IconData icon;
    final String playStat;
    if (videoDetailController.playedTime == null) {
      icon = Icons.play_arrow_rounded;
      playStat = '立即';
    } else if (plPlayerController!.isCompleted) {
      icon = CustomIcons.replay_rounded;
      playStat = '重新';
    } else {
      icon = Icons.play_arrow_rounded;
      playStat = '继续';
    }
    final playBtn = Row(
      spacing: 2,
      mainAxisSize: .min,
      children: [
        Icon(icon, color: colorScheme.primary),
        Text(
          '$playStat播放',
          style: TextStyle(color: colorScheme.primary),
        ),
      ],
    );
    return Opacity(
      opacity: videoDetailController.scrollRatio.value,
      child: Container(
        color: colorScheme.surface,
        alignment: .topCenter,
        child: SizedBox(
          height: kToolbarHeight,
          child: Stack(
            clipBehavior: .none,
            children: [
              Align(
                alignment: .centerLeft,
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    SizedBox(
                      width: 42,
                      height: 34,
                      child: IconButton(
                        tooltip: '返回',
                        icon: Icon(
                          FontAwesomeIcons.arrowLeft,
                          size: 15,
                          color: colorScheme.onSurface,
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
                          color: colorScheme.onSurface,
                        ),
                        onPressed:
                            videoDetailController.plPlayerController.onCloseAll,
                      ),
                    ),
                  ],
                ),
              ),
              Center(child: playBtn),
              Align(
                alignment: .centerRight,
                child: videoDetailController.playedTime == null
                    ? _moreBtn(colorScheme.onSurface)
                    : SizedBox(
                        width: 42,
                        height: 34,
                        child: IconButton(
                          tooltip: "更多设置",
                          style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                          ),
                          onPressed: () =>
                              (videoDetailController.headerCtrKey.currentState
                                      as HeaderControlState?)
                                  ?.showSettingSheet(),
                          icon: Icon(
                            Icons.more_vert_outlined,
                            size: 19,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderOverlay() {
    return Obx(
      () {
        final scrollRatio = videoDetailController.scrollRatio.value;
        if (scrollRatio == 0) {
          return const SizedBox.shrink();
        }
        return Positioned.fill(
          bottom: -1,
          child: GestureDetector(
            onTap: () {
              if (!videoDetailController.isFileSource) {
                if (videoDetailController.isQuerying) {
                  if (kDebugMode) {
                    debugPrint('handlePlay: querying');
                  }
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
              }
              if (plPlayerController == null ||
                  videoDetailController.playedTime == null) {
                handlePlay();
              } else {
                plPlayerController!.onDoubleTapCenter();
              }
            },
            behavior: .opaque,
            child: _buildOverlayToolBar(scrollRatio),
          ),
        );
      },
    );
  }

  Widget get childWhenDisabledLandscape => Obx(
    () {
      final isFullScreen = this.isFullScreen;
      return SimpleScaffold(
        appBar: removeAppBar(isFullScreen)
            ? null
            : SimpleAppBar(
                height: padding.top,
                brightness: colorScheme.brightness,
              ),
        body: Padding(
          padding: isFullScreen
              ? EdgeInsets.zero
              : padding.copyWith(top: 0, bottom: 0),
          child: childWhenDisabledLandscapeInner(isFullScreen),
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
            child: MiniScaffold(
              key: videoDetailController.childKey,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTabBar(),
                  Expanded(
                    child: wrapTabContent(
                      tabBarView(
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
                      resolveCtr: _landscapeTabScrollCtr,
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

  Widget childWhenDisabledLandscapeInner(bool isFullScreen) {
    if (enableVerticalExpand) {
      return Obx(() {
        if (videoDetailController.isVertical.value && !isPortrait) {
          final double videoHeight = maxHeight - padding.vertical;
          final double width = videoHeight / Style.aspectRatio16x9;
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
                  child: MiniScaffold(
                    key: videoDetailController.childKey,
                    body: Column(
                      children: [
                        buildTabBar(showIntro: false),
                        Expanded(
                          child: wrapTabContent(
                            tabBarView(
                              controller: videoDetailController.tabCtr,
                              children: [
                                if (videoDetailController.showReply)
                                  videoReplyPanel(),
                                if (_shouldShowSeasonPanel) seasonPanel,
                              ],
                            ),
                            resolveCtr: () {
                              final idx = videoDetailController.tabCtr.index;
                              if (videoDetailController.showReply && idx == 0) {
                                return _videoReplyController.scrollController;
                              }
                              return _shouldShowSeasonPanel &&
                                      idx ==
                                          (videoDetailController.showReply
                                              ? 1
                                              : 0)
                                  ? _seasonScrollCtr()
                                  : null;
                            },
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

        return _childWhenDisabledLandscapeInner(isFullScreen);
      });
    }
    return _childWhenDisabledLandscapeInner(isFullScreen);
  }

  Widget _childWhenDisabledLandscapeInner(bool isFullScreen) {
    double width =
        clampDouble(maxHeight / maxWidth * 1.08, 0.5, 0.7) * maxWidth;
    if (maxWidth >= 560) {
      width = maxWidth - clampDouble(maxWidth - width, 280, 425);
    }
    final videoWidth = isFullScreen ? maxWidth : width;
    final double height = width / Style.aspectRatio16x9;
    final videoHeight = isFullScreen
        ? maxHeight - (isWindowMode && !isPortrait ? 0 : padding.top)
        : height;
    if (height > maxHeight) {
      return childSplit(Style.aspectRatio16x9);
    }
    final introHeight = maxHeight - height - padding.top;
    final showIntro =
        videoDetailController.isUgc && videoDetailController.showRelatedVideo;
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
            if (!videoDetailController.isFileSource)
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
            child: MiniScaffold(
              key: videoDetailController.childKey,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTabBar(
                    introText: '相关视频',
                    showIntro: videoDetailController.isFileSource
                        ? true
                        : showIntro,
                  ),
                  Expanded(
                    child: wrapTabContent(
                      tabBarView(
                        controller: videoDetailController.tabCtr,
                        children: [
                          if (videoDetailController.isFileSource)
                            localIntroPanel()
                          else if (showIntro)
                            KeepAliveWrapper(
                              child: CustomScrollView(
                                key: const PageStorageKey(CommonIntroController),
                                controller:
                                    videoDetailController.effectiveIntroScrollCtr,
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
                      resolveCtr: _landscapeTabScrollCtr,
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

  Widget get childWhenDisabledAlmostSquare => Obx(() {
    final isFullScreen = this.isFullScreen;
    return SimpleScaffold(
      appBar: removeAppBar(isFullScreen)
          ? null
          : SimpleAppBar(
              height: padding.top,
              brightness: colorScheme.brightness,
            ),
      body: Padding(
        padding: isFullScreen
            ? EdgeInsets.zero
            : padding.copyWith(top: 0, bottom: 0),
        child: childWhenDisabledAlmostSquareInner(isFullScreen),
      ),
    );
  });

  Widget childWhenDisabledAlmostSquareInner(bool isFullScreen) {
    if (enableVerticalExpand) {
      return Obx(
        () {
          if (videoDetailController.isVertical.value && !isPortrait) {
            return childSplit(9 / 16);
          }

          return _childWhenDisabledAlmostSquareInner(isFullScreen);
        },
      );
    }

    return _childWhenDisabledAlmostSquareInner(isFullScreen);
  }

  Widget _childWhenDisabledAlmostSquareInner(bool isFullScreen) {
    final shouldShowSeasonPanel = _shouldShowSeasonPanel;
    final double height = maxHeight / 2.5;
    final videoHeight = isFullScreen
        ? maxHeight - (isWindowMode && !isPortrait ? 0 : padding.top)
        : height;
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
            child: MiniScaffold(
              key: videoDetailController.childKey,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTabBar(needIndicator: false),
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
                        if (shouldShowSeasonPanel) Expanded(child: seasonPanel),
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

  Widget manualPlayerWidget(double height) => Obx(() {
    if (!videoDetailController.autoPlay) {
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: kToolbarHeight,
            child: Row(
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
                    onPressed:
                        videoDetailController.plPlayerController.onCloseAll,
                  ),
                ),
                const Spacer(),
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
            top: height - 70,
            child: const PlayIcon(),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  });

  Widget _moreBtn(Color color, {List<Shadow>? shadows}) =>
      StaticPopupMenuButton(
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
      if (!videoDetailController.isFileSource)
        PopupMenuItem(
          onTap: () => videoDetailController.onDownload(this.context),
          child: const Text('缓存视频'),
        ),
      if (videoDetailController.cover.value.isNotEmpty)
        PopupMenuItem(
          onTap: () =>
              ImageUtils.downloadImg([videoDetailController.cover.value]),
          child: const Text('保存封面'),
        ),
      if (!videoDetailController.isFileSource && videoDetailController.isUgc)
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
  }) {
    // 小窗内容已轻量化（PipMiniVideoContent），本方法只服务页面副本，
    // videoPlayerKey 不再有共享冲突，同时兼任收起源矩形/归位目标矩形的量取锚点
    final Widget player = popScope(
      key: videoDetailController.videoPlayerKey,
      canPop: _canPopPage,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Obx(
        () =>
            (!isPipMode && !videoDetailController.videoState.value) ||
                !videoDetailController.autoPlay ||
                plPlayerController?.videoController == null
            ? const SizedBox.shrink()
            : PLVideoPlayer(
                maxWidth: width,
                maxHeight: height,
                isPipMode: isPipMode,
                plPlayerController: plPlayerController!,
                videoDetailController: videoDetailController,
                introController: introController,
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
                          isFileSource: videoDetailController.isFileSource,
                          size: Size(width, height),
                        ),
                      ),
                showEpisodes: showEpisodes,
                showViewPoints: showViewPoints,
              ),
      ),
    );
    // 归位动画中：透明占位参与布局（供量取目标矩形）但不可见不可点，
    // 小窗是唯一可见端，恢复握手完成后亮出
    return _pipRestoreInFlight
        ? IgnorePointer(child: Opacity(opacity: 0, child: player))
        : player;
  }

  late ThemeData theme;
  ColorScheme get colorScheme => theme.colorScheme;
  late bool isPortrait;
  late double maxWidth;
  late double maxHeight;
  bool isWindowMode = false;
  late EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (videoDetailController.plPlayerController.isPipMode) {
      child = plPlayer(width: maxWidth, height: maxHeight, isPipMode: true);
    } else if (!videoDetailController.horizontalScreen) {
      child = childWhenDisabled;
    } else if (maxWidth / maxHeight >= kScreenRatio) {
      child = childWhenDisabledLandscape;
    } else if (maxWidth / Style.aspectRatio16x9 < 0.4 * maxHeight) {
      child = childWhenDisabled;
    } else {
      child = childWhenDisabledAlmostSquare;
    }
    if (videoDetailController.plPlayerController.keyboardControl) {
      child = PlayerFocus(
        plPlayerController: videoDetailController.plPlayerController,
        introController: introController,
        onSendDanmaku: videoDetailController.showShootDanmakuSheet,
        focusNode: playerFocusNode,
        canPlay: () {
          if (videoDetailController.autoPlay) {
            return true;
          }
          handlePlay();
          return false;
        },
        onSkipSegment: videoDetailController.onSkipSegment,
        child: child,
      );
    }
    final page = videoDetailController.plPlayerController.darkVideoPage
        ? Theme(data: theme, child: child)
        : child;
    // 页面根参照系：归位目标矩形以此量取（规避路由转场期间的整页偏移）
    return KeyedSubtree(key: _pageRootKey, child: page);
  }

  /// 包住 tab 内容区：方向键滚动当前激活 tab 的内容。
  /// [resolveCtr] 按布局分支返回该 tab 的滚动目标，null 时放行（音量控制）
  Widget wrapTabContent(
    Widget child, {
    required ScrollController? Function() resolveCtr,
  }) {
    return KeyboardScrollable(
      controller: resolveCtr,
      focusNode: tabContentFocusNode,
      child: child,
    );
  }

  /// 横屏 tab 滚动目标：简介/相关视频 → 简介滚动，评论 → 评论滚动
  ScrollController? _landscapeTabScrollCtr() {
    final idx = videoDetailController.tabCtr.index;
    if (idx == 0) {
      return videoDetailController.effectiveIntroScrollCtr;
    }
    if (videoDetailController.showReply && idx == 1) {
      return _videoReplyController.scrollController;
    }
    return _shouldShowSeasonPanel &&
            idx == (videoDetailController.showReply ? 2 : 1)
        ? _seasonScrollCtr()
        : null;
  }

  /// 播放列表 tab 的滚动目标：EpisodePanel 当前子列表
  ScrollController? _seasonScrollCtr() =>
      seasonEpisodeKey.currentState?.activeScrollController;

  Widget buildTabBar({
    bool needIndicator = true,
    String? introText,
    bool showIntro = true,
    VoidCallback? onTap,
  }) {
    final tabs = [
      if (showIntro)
        videoDetailController.isFileSource ? '离线视频' : introText ?? '简介',
      if (videoDetailController.showReply) '评论',
      if (_shouldShowSeasonPanel) '播放列表',
    ];
    final oldTabCtr = videoDetailController.tabCtr;
    final oldTabCtrDisposed = oldTabCtr.animation == null;
    if (oldTabCtr.length != tabs.length || oldTabCtrDisposed) {
      final initialIndex = tabs.isEmpty
          ? 0
          : oldTabCtr.index.clamp(0, tabs.length - 1);
      if (!oldTabCtrDisposed) {
        oldTabCtr.dispose();
      }
      videoDetailController.tabCtr = TabController(
        vsync: videoDetailController,
        length: tabs.length,
        initialIndex: initialIndex,
      );
    }

    Widget tabBar() {
      final flag = !needIndicator || tabs.length == 1;
      return TabBar(
        padding: .zero,
        dividerHeight: 0,
        labelPadding: .zero,
        dividerColor: Colors.transparent,
        controller: videoDetailController.tabCtr,
        indicator: flag ? const BoxDecoration() : null,
        labelColor: flag ? colorScheme.onSurface : null,
        labelStyle:
            TabBarTheme.of(context).labelStyle?.copyWith(fontSize: 13) ??
            const TextStyle(fontSize: 13),
        onTap: (value) {
          // 切 tab 后免点击直接支持方向键滚动：焦点交给 tab 内容区
          if (value != videoDetailController.tabCtr.index) {
            tabContentFocusNode.requestFocus();
          }
          void animToTop() {
            if (onTap != null) {
              onTap();
              return;
            }
            String text = tabs[value];
            if (videoDetailController.isFileSource ||
                text == '简介' ||
                text == '相关视频') {
              videoDetailController.introScrollCtr?.animToTop();
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
                child: Text(
                  '评论${count == -1 ? '' : ' ${NumUtils.numFormat(count)}'}',
                  softWrap: false,
                  overflow: .visible,
                ),
              );
            });
          } else {
            return Tab(
              child: Text(text, softWrap: false, overflow: .visible),
            );
          }
        }).toList(),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: SizedBox(
        height: 45,
        child: Row(
          children: [
            if (tabs.isEmpty)
              const Spacer()
            else
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 96.0 * tabs.length),
                    child: tabBar(),
                  ),
                ),
              ),
            SizedBox(
              height: 32,
              child: TextButton(
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(.zero),
                ),
                onPressed: videoDetailController.showShootDanmakuSheet,
                child: Text(
                  '发弹幕',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            SizedBox.square(
              dimension: 38,
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
                          ? colorScheme.secondary
                          : colorScheme.outline,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }

  Widget videoPlayer({required double width, required double height}) {
    final isFullScreen = this.isFullScreen;
    // 点/悬停视频区 → 归还键盘焦点给播放器（方向键恢复音量控制）
    return MouseRegion(
      onEnter: (_) => playerFocusNode.requestFocus(),
      child: Listener(
        onPointerDown: (_) => playerFocusNode.requestFocus(),
        child: Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(
          child: ColoredBox(
            color: Colors.black,
            isAntiAlias: false,
          ),
        ),

        plPlayer(width: width, height: height),

        Obx(() {
          if (!videoDetailController.autoPlay) {
            return Positioned.fill(
              child: GestureDetector(
                onTap: handlePlay,
                behavior: .opaque,
                child: Obx(
                  () => NetworkImgLayer(
                    type: .emote,
                    quality: 60,
                    src: videoDetailController.cover.value,
                    width: width,
                    height: height,
                    cacheWidth: true,
                    getPlaceHolder: () => Center(
                      child: Image.asset(Assets.loading),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        manualPlayerWidget(height),

        if (videoDetailController.plPlayerController.enableBlock ||
            videoDetailController.continuePlayingPart)
          Positioned(
            left: 16,
            bottom: isFullScreen ? max(75, maxHeight * 0.25) : 75,
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
                                  borderRadius: .all(.circular(6)),
                                ),
                                backgroundColor: theme
                                    .colorScheme
                                    .secondaryContainer
                                    .withValues(alpha: 0.8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                visualDensity: VisualDensity.compact,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                ugcIntroController.onChangeEpisode(
                                  item,
                                  isStein: true,
                                );
                                videoDetailController.getSteinEdgeInfo(item.id);
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
      ),
    );
  }

  Widget localIntroPanel({
    bool needCtr = true,
  }) {
    return CustomScrollView(
      controller: needCtr
          ? videoDetailController.effectiveIntroScrollCtr
          : null,
      physics: !needCtr ? platformAlwaysClampingPhysics : null,
      key: const PageStorageKey(CommonIntroController),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(top: 7, bottom: padding.bottom + 100),
          sliver: LocalIntroPanel(
            key: videoRelatedKey,
            heroTag: heroTag,
          ),
        ),
      ],
    );
  }

  Widget videoIntro({
    double? width,
    double? height,
    bool? isHorizontal,
    bool needRelated = true,
    bool needCtr = true,
  }) {
    if (videoDetailController.isFileSource) {
      return localIntroPanel(needCtr: needCtr);
    }
    Widget child = CustomScrollView(
      key: const PageStorageKey(CommonIntroController),
      controller: needCtr
          ? videoDetailController.effectiveIntroScrollCtr
          : null,
      physics: !needCtr ? platformAlwaysClampingPhysics : null,
      slivers: [
        if (videoDetailController.isUgc) ...[
          UgcIntroPanel(
            key: videoIntroKey,
            heroTag: heroTag,
            showAiBottomSheet: showAiBottomSheet,
            showAiChatBottomSheet: showAiChatBottomSheet,
            showEpisodes: showEpisodes,
            onShowMemberPage: onShowMemberPage,
            isPortrait: isPortrait,
            isHorizontal: isHorizontal ?? width! / height! >= kScreenRatio,
          ),
          if (needRelated && videoDetailController.showRelatedVideo) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Style.safeSpace,
                ),
                child: Divider(
                  height: 1,
                  indent: 12,
                  endIndent: 12,
                  color: colorScheme.outline.withValues(alpha: .08),
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
                    : Style.safeSpace) +
                padding.bottom,
          ),
        ),
      ],
    );

    if (videoDetailController.isPlayAll) {
      child = IntroLayout(
        body: child,
        playlist: Padding(
          padding: .only(left: 12, right: 12, bottom: 12 + padding.bottom),
          child: Material(
            type: .transparency,
            child: InkWell(
              onTap: () => videoDetailController.showMediaListPanel(context),
              borderRadius: const .all(.circular(14)),
              child: Container(
                height: 54,
                padding: const .symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withValues(alpha: 0.95),
                  borderRadius: const .all(.circular(14)),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    const Icon(Icons.playlist_play, size: 24),
                    Expanded(
                      child: Text(
                        videoDetailController.watchLaterTitle,
                        style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: .bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_up_rounded, size: 26),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return KeepAliveWrapper(child: child);
  }

  Widget get seasonPanel {
    final videoDetail = ugcIntroController.videoDetail.value;
    return KeepAliveWrapper(
      child: Column(
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
                    key: seasonEpisodeKey,
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
                    listOrder: videoDetail.listOrder,
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
                color: colorScheme.outline.withValues(alpha: 0.1),
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
                  key: seasonEpisodeKey,
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
                  listOrder: ugcIntroController
                      .videoDetail
                      .value
                      .ugcSeason!
                      .sections![videoDetailController.seasonIndex.value]
                      .listOrder,
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
  );

  // ai总结
  void showAiBottomSheet() {
    videoDetailController.childKey.currentState?.showBottomSheet(
      constraints: const BoxConstraints(),
      (context) =>
          AiConclusionPanel(item: ugcIntroController.aiConclusionResult!),
    );
  }

  // ai字幕分析
  void showAiChatBottomSheet() {
    videoDetailController.childKey.currentState?.showBottomSheet(
      constraints: const BoxConstraints(),
      (context) => AiChatPage(heroTag: heroTag),
    );
  }

  void showIntroDetail(
    PgcInfoModel videoDetail,
    List<VideoTagItem>? videoTags,
  ) {
    videoDetailController.childKey.currentState?.showBottomSheet(
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
    List<ugc.BaseEpisodeItem>? episodes,
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
      listOrder: !videoDetailController.isUgc
          ? null
          : season != null
          ? ugcIntroController
                .videoDetail
                .value
                .ugcSeason!
                .sections![videoDetailController.seasonIndex.value]
                .listOrder
          : ugcIntroController.videoDetail.value.listOrder,
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
      final child = listSheetContent(enableSlide: false);
      PageUtils.showVideoBottomSheet(
        context,
        child: videoDetailController.plPlayerController.darkVideoPage
            ? Theme(data: theme, child: child)
            : child,
      );
    } else {
      videoDetailController.childKey.currentState?.showBottomSheet(
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
      final item = videoDetail
          .ugcSeason!
          .sections![videoDetailController.seasonIndex.value];
      final nextOrder = item.listOrder.next;
      _applyListOrder(
        nextOrder: nextOrder,
        list: item.episodes!,
        getList: () => item.episodes,
        setList: (v) => item.episodes = v,
        backup: item.originalEpisodes,
        setBackup: (v) => item.originalEpisodes = v,
        setOrder: (v) => item.listOrder = v,
      );
      // refresh or switch episode
      if (!videoDetailController.plPlayerController.reverseFromFirst ||
          nextOrder.isShuffle) {
        videoDetailController
          ..seasonIndex.refresh()
          ..cid.refresh();
      } else {
        final episode = item.episodes!.first;
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
      final nextOrder = videoDetail.listOrder.next;
      _applyListOrder(
        nextOrder: nextOrder,
        list: videoDetail.pages!,
        getList: () => videoDetail.pages,
        setList: (v) => videoDetail.pages = v,
        backup: videoDetail.originalPages,
        setBackup: (v) => videoDetail.originalPages = v,
        setOrder: (v) => videoDetail.listOrder = v,
      );
      if (!videoDetailController.plPlayerController.reverseFromFirst ||
          nextOrder.isShuffle) {
        videoDetailController.cid.refresh();
      } else {
        final episode = videoDetail.pages!.first;
        if (episode.cid != videoDetailController.cid.value) {
          ugcIntroController.onChangeEpisode(episode);
        } else {
          videoDetailController.cid.refresh();
        }
      }
    }
  }

  void _applyListOrder<T>({
    required ListOrder nextOrder,
    required List<T> list,
    required List<T>? Function() getList,
    required void Function(List<T>) setList,
    required List<T>? backup,
    required void Function(List<T>?) setBackup,
    required void Function(ListOrder) setOrder,
  }) {
    if (nextOrder.isShuffle) {
      // entering shuffle: backup then shuffle
      setBackup(List.of(list));
      list.shuffle();
    } else if (nextOrder.isDesc) {
      if (backup != null) {
        // shuffle → desc: restore backup then reverse
        setList(backup.reversed.toList());
        setBackup(null);
      } else {
        // asc → desc: reverse current
        setList(list.reversed.toList());
      }
    } else {
      // nextOrder == asc
      if (backup != null) {
        // shuffle → asc: restore backup
        setList(List.of(backup));
        setBackup(null);
      } else {
        // desc → asc: reverse current
        setList(list.reversed.toList());
      }
    }
    setOrder(nextOrder);
  }

  void showViewPoints() {
    if (isFullScreen || videoDetailController.showVideoSheet) {
      final child = ViewPointsPage(
        enableSlide: false,
        videoDetailController: videoDetailController,
        plPlayerController: plPlayerController,
      );
      PageUtils.showVideoBottomSheet(
        context,
        child: videoDetailController.plPlayerController.darkVideoPage
            ? Theme(data: theme, child: child)
            : child,
      );
    } else {
      videoDetailController.childKey.currentState?.showBottomSheet(
        constraints: const BoxConstraints(),
        (context) => ViewPointsPage(
          videoDetailController: videoDetailController,
          plPlayerController: plPlayerController,
        ),
      );
    }
  }

  void _onPopInvokedWithResult(bool didPop, result) {
    final returningToVideoPage = _isReturningToVideoPageInStack();
    if (didPop && Platform.isAndroid) {
      // 参考上游逻辑：返回时立即强制清空 Auto-PiP 状态，切断系统自动进入的时机，防止误触
      plPlayerController?.disableAutoEnterPip();
    }
    if (didPop) {
      final manual = _manualPipRequested;
      _manualPipRequested = false;
      _startInAppPipIfNeeded(fromPop: true, manual: manual);
      // 消费 didPopNext else 分支设的重试标志（用户真的继续 pop 了）。
      // 立即调用通常足够（didPopNext 已同步关闭其他 PiP，playerInit 多半已完成）；
      // 若立即失败（rapid back press 时 playerInit 还在 await，playerStatus 不是 playing），
      // 延迟到下一帧再试一次，那时 playerInit 已完成、playerStatus=playing。
      if (_pipRetryPending) {
        final needDeferredRetry = !_isEnteringPipMode;
        _pipRetryPending = false;
        if (needDeferredRetry) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startInAppPipIfNeeded(fromPop: true);
          });
        }
      }
    } else {
      // pop 被拦下，手动小窗的一次性豁免不能留给下一次普通返回
      _manualPipRequested = false;
    }
    videoDetailController.plPlayerController.onPopInvokedWithResult(
      didPop,
      result,
      // 当前页被 pop 掉，但下层仍是另一个视频页时，播放器单例的 owner
      // 会在 didPopNext 中切回可见页面；这里不能再由旧页面去 pause 共享播放器。
      pauseOnPop: !_isEnteringPipMode && !returningToVideoPage,
    );
  }

  bool _isReturningToVideoPageInStack() {
    final previousRoute = Get.previousRoute;
    return VideoStackManager.getCount() > 1 &&
        previousRoute.startsWith('/video');
  }

  /// [manual] 为三点菜单手动触发：不受设置开关约束；嵌套的视频/直播页在
  /// 触发前已被静默移除，且 didRemove 会把 Get.previousRoute 改写成被移除页
  /// 的名字，栈判断在此路径下既无必要也不可信
  bool _shouldStartInAppPip({bool fromPop = false, bool manual = false}) {
    _logSponsorBlock(
      'Checking PiP: count=${VideoStackManager.getCount()}, previousRoute=${Get.previousRoute}, manual=$manual',
    );
    if (!manual && !Pref.enableInAppPip) {
      _logSponsorBlock('Reject PiP: in-app PiP is disabled in settings');
      return false;
    }
    if (PipOverlayService.isInPipMode) {
      _logSponsorBlock('Reject PiP: already in PiP mode');
      return false;
    }
    plPlayerController ??= videoDetailController.plPlayerController;
    final controller = plPlayerController;
    if (controller == null || controller.videoController == null) {
      _logSponsorBlock('Reject PiP: controller or videoController is null');
      return false;
    }
    if (controller.isDesktopPip || controller.isPipMode) {
      _logSponsorBlock(
        'Reject PiP: isDesktopPip=${controller.isDesktopPip}, isPipMode=${controller.isPipMode}',
      );
      return false;
    }
    if (controller.playerStatus != PlayerStatus.playing) {
      _logSponsorBlock('Reject PiP: video is paused');
      return false;
    }
    if (!videoDetailController.autoPlay) {
      _logSponsorBlock('Reject PiP: autoPlay is false');
      return false;
    }

    // 如果即将进入听视频界面，不开启小窗
    if (Get.currentRoute == '/audio') {
      _logSponsorBlock('Reject PiP: Navigating to audio page');
      return false;
    }
    final prevRoute = Get.previousRoute;
    if (!manual && VideoStackManager.isReturningToVideo()) {
      // 如果返回的页面不是视频或直播详情页，允许开启小窗
      if (!prevRoute.startsWith('/video') &&
          !prevRoute.startsWith('/liveRoom')) {
        _logSponsorBlock(
          'Allowing PiP: Returning to non-video page ($prevRoute)',
        );
      } else {
        _logSponsorBlock(
          'Reject PiP: isReturningToVideo is true (Stack Count = ${VideoStackManager.getCount()}, Previous = $prevRoute)',
        );
        return false;
      }
    }
    return true;
  }

  /// 三点菜单「应用内画中画」：不依赖设置开关，把当前视频临时收进小窗。
  /// 复用返回键收起路径（pop → _onPopInvokedWithResult → _startInAppPipIfNeeded），
  /// 只是提前把门禁条件凑齐：全屏的先退全屏、暂停的先续播、嵌套页先静默移除
  Future<void> _enterInAppPipManually() async {
    if (!mounted || _isEnteringPipMode || _manualPipRequested) {
      return;
    }
    plPlayerController ??= videoDetailController.plPlayerController;
    final controller = plPlayerController!;
    if (controller.isFullScreen.value) {
      // 全屏时返回键语义是"退出全屏"，页面本就不能被 pop；且直接 pop 会把
      // 播放器单例的 isFullScreen 留在 true、方向也不复位（resetScreenRotation
      // 只在 triggerFullScreen 内调用）。先退回半屏再走正常的收起流程
      await controller.triggerFullScreen(status: false);
      if (!mounted) {
        return;
      }
      // 横屏退出全屏会把设备转回竖屏，由 OS 异步完成；isPortrait 是 _canPopPage
      // 的一项，未等到就判定会被误拒。这里直接用待判定的条件本身当落定信号：
      // 竖屏视频退出全屏不转屏，isPortrait 已为 true，只等保底的一帧；
      // 方向本就未变时（如 fullScreenMode=.none 的横屏手机）等不到，超时后
      // 由下面的判定拒绝——这种形态本就不该 pop 本页
      await PipOverlayService.awaitLayoutSettled(() => _canPopPage);
      if (!mounted) {
        return;
      }
    }
    if (controller.videoController != null &&
        !controller.playerStatus.isPlaying) {
      // 手动进小窗是明确的播放意图；播完的从头播
      await controller.play(repeat: controller.playerStatus.isCompleted);
      if (!mounted) {
        return;
      }
    }
    if (!_canPopPage || !_shouldStartInAppPip(manual: true)) {
      SmartDialog.showToast('当前无法进入小窗');
      return;
    }
    if (PipOverlayService.removeNestedVideoLikeRoutesBelow(context) > 0) {
      // 被移除的页面要到下一帧才卸载并归还各自的播放器计数；等它们落地再 pop，
      // 否则小窗按 X 关闭时计数未归零、播放器不会真正销毁
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) {
        return;
      }
    }
    _manualPipRequested = true;
    Get.back();
  }

  void _startInAppPipIfNeeded({bool fromPop = false, bool manual = false}) {
    if (!_shouldStartInAppPip(fromPop: fromPop, manual: manual)) {
      return;
    }

    // 设置标志，防止 didPushNext 清理 SponsorBlock 数据
    _isEnteringPipMode = true;
    _logSponsorBlock(
      'Starting PiP mode, segmentList.length: ${videoDetailController.segmentList.length}',
    );

    // 设置控制器标志，防止 onClose 清理资源
    videoDetailController.isEnteringPip = true;

    // 保存所有相关控制器
    final additionalControllers = <String, dynamic>{};
    if (videoDetailController.showReply) {
      try {
        final replyController = Get.find<VideoReplyController>(tag: heroTag);
        replyController.isEnteringPip = true;
        additionalControllers['reply'] = replyController;
      } catch (_) {}
    }
    if (videoDetailController.isFileSource) {
      try {
        final intro = Get.find<LocalIntroController>(tag: heroTag);
        intro.isEnteringPip = true;
        additionalControllers['intro'] = intro;
      } catch (_) {}
    } else if (videoDetailController.isUgc) {
      try {
        final intro = Get.find<UgcIntroController>(tag: heroTag);
        intro.isEnteringPip = true;
        additionalControllers['intro'] = intro;
      } catch (_) {}
    } else {
      try {
        final intro = Get.find<PgcIntroController>(tag: heroTag);
        intro.isEnteringPip = true;
        additionalControllers['intro'] = intro;
      } catch (_) {}
    }
    _logSponsorBlock(
      'Saved ${additionalControllers.length} additional controllers',
    );

    // 收起动画源矩形：页面播放器当前屏幕位置（pop/push 甫一触发，页面尚未
    // 移动，全局坐标即所见位置）；量取失败则无动画直接以活跃态出现
    final sourceRect = _playerRect();

    PipOverlayService.startPip(
      plPlayerController: plPlayerController!,
      controller: videoDetailController,
      additionalControllers: additionalControllers,
      context: context,
      sourceRect: sourceRect,
      // 轻量小窗内容：纹理+弹幕+缓冲指示，不再复用完整 PLVideoPlayer，
      // 小窗副本与页面副本彻底解耦（字幕随之不在小窗显示）
      videoPlayerBuilder: (isNative, w, h) => PipMiniVideoContent(
        plPlayerController: plPlayerController!,
        transition: PipOverlayService.transition,
        danmuWidget: pipNoDanmaku
            ? null
            : Obx(
                () => PlDanmaku(
                  key: ValueKey(videoDetailController.cid.value),
                  isPipMode: true,
                  cid: videoDetailController.cid.value,
                  playerController: plPlayerController!,
                  isFullScreen: false,
                  isFileSource: videoDetailController.isFileSource,
                  size: Size(w, h),
                ),
              ),
      ),
      onClose: () {
        _isEnteringPipMode = false;
        _logSponsorBlock('PiP closed by user');
        _handleInAppPipCloseCleanup();
      },
      onTapToReturn: () {
        // 不取消 position subscription，让它在新页面继续工作
        _logSponsorBlock(
          'Returning from PiP, positionSubscription will be preserved',
        );
        final currentPosition = plPlayerController?.positionInMilliseconds;
        final args = Map<String, dynamic>.from(videoDetailController.args);
        final progress =
            currentPosition ??
            videoDetailController.playedTime?.inMilliseconds;
        if (progress != null) {
          args['progress'] = progress;
        }
        args['fromPip'] = true;

        // 重置标志
        _isEnteringPipMode = false;
        _logSponsorBlock(
          'Tap to return from PiP, args contains: bvid=${args['bvid']}, cid=${args['cid']}, heroTag=${args['heroTag']}, title=${args['title']}, segmentList.length: ${videoDetailController.segmentList.length}',
        );

        Get.toNamed('/videoV', arguments: args);
      },
    );

    // 不需要重新初始化 SponsorBlock，因为 positionSubscription 已经存在并在工作
    // 重新调用 initSkip() 会取消并重新创建 subscription，可能导致失效
    _logSponsorBlock('PiP started, positionSubscription preserved');
  }

  void _handleInAppPipCloseCleanup() {
    if (videoDetailController.plPlayerController.isCloseAll) {
      return;
    }
    if (Platform.isAndroid && !videoDetailController.setSystemBrightness) {
      ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
    }
    PlPlayerController.setPlayCallBack(null);
    videoPlayerServiceHandler?.onVideoDetailDispose(heroTag);
    plPlayerController ??= videoDetailController.plPlayerController;
    if (plPlayerController != null) {
      if (videoDetailController.isFileSource) {
        videoDetailController.playedTime = Duration(
          milliseconds: plPlayerController!.positionInMilliseconds,
        );
        videoDetailController.cacheLocalProgress();
      }
      videoDetailController.makeHeartBeat();
      if (mounted) {
        // owner 页面仍在路由栈内，只能暂停：dispose 会消耗页面持有的
        // _playerCount，返回后恢复时 setDataSource 会因计数为 0 静默中止，
        // 播放器区域永久黑屏且失去交互
        plPlayerController!.pause();
        // 按 X 是明确的停止意图，改写快照使返回后保持暂停而非续播
        videoDetailController.playerStatus = PlayerStatus.paused;
      } else {
        plPlayerController!.dispose();
      }
    } else {
      PlPlayerController.updatePlayCount();
    }
  }

  void _syncCurrentMediaSessionOnResume() {
    if (videoPlayerServiceHandler == null) {
      return;
    }

    if (videoDetailController.isFileSource) {
      localIntroController.onVideoDetailChange(videoDetailController.entry);
      return;
    }

    if (videoDetailController.isUgc) {
      videoPlayerServiceHandler?.onVideoDetailChange(
        ugcIntroController.videoDetail.value,
        videoDetailController.cid.value,
        heroTag,
      );
      return;
    }

    pgcIntroController.queryVideoIntro();
  }

  void onShowMemberPage(int? mid) {
    videoDetailController.childKey.currentState?.showBottomSheet(
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
