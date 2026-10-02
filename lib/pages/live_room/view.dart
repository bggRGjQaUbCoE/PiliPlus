import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/extra_hittest_stack.dart';
import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/common/widgets/flutter/pop_scope.dart';
import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/route_aware_mixin.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show tabBarScrollPhysics;
import 'package:PiliPlus/models/common/live/live_contribution_rank_type.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/pages/danmaku/danmaku_model.dart';
import 'package:PiliPlus/pages/live_room/contribution_rank/controller.dart';
import 'package:PiliPlus/pages/live_room/contribution_rank/view.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_card.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_panel.dart';
import 'package:PiliPlus/pages/live_room/widgets/bottom_control.dart';
import 'package:PiliPlus/pages/live_room/widgets/chat_panel.dart';
import 'package:PiliPlus/pages/live_room/widgets/header_control.dart';
import 'package:PiliPlus/pages/video/widgets/player_focus.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/utils/danmaku_options.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/plugin/pl_player/view/view.dart';
import 'package:PiliPlus/services/live_pip_overlay_service.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/services/pip_overlay_service.dart';
import 'package:PiliPlus/services/pip_transition_coordinator.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/max_screen_size.dart';
import 'package:PiliPlus/utils/mobile_observer.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/share_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:canvas_danmaku/danmaku_screen.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';

const baseWhite = Color(0xFFEEEEEE);

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage>
    with WidgetsBindingObserver, RouteAware, RouteAwareMixin {
  late final fullScreenSCWidth = Pref.fullScreenSCWidth;
  final String heroTag = Utils.generateRandomString(6);
  late final LiveRoomController _liveRoomController;
  late final PlPlayerController plPlayerController;
  bool get isFullScreen => plPlayerController.isFullScreen.value;

  // 标志位：是否正在进入 PiP 模式
  bool _isEnteringPipMode = false;

  // 标志位：三点菜单「应用内画中画」发起的 pop，一次性；由 _onPopInvokedWithResult 消费，
  // 让本次收起绕过设置开关
  bool _manualPipRequested = false;

  late final GlobalKey pageKey = GlobalKey();
  late final GlobalKey chatKey = GlobalKey();
  late final GlobalKey scKey = GlobalKey();
  late final GlobalKey playerKey = GlobalKey();

  // 归位动画进行中：页面播放器以透明占位先行布局（供量取目标矩形），
  // 恢复握手完成后亮出，期间小窗是唯一可见端
  bool _pipRestoreInFlight = false;
  int _pipRestoreRectAttempts = 0;

  // 页面根参照系：归位目标矩形以此量取，规避路由转场期间的整页偏移
  final _pageRootKey = GlobalKey();

  /// 量取页面播放器矩形（收起源矩形用全局坐标；归位目标以页面根为参照系）
  Rect? _livePlayerRect({bool relativeToPage = false}) {
    final renderObject = playerKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize ||
        // 未加载完成时播放器区是零尺寸 SizedBox.shrink,视为未量到
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

  /// C1/C2 共用：页面就绪后量取归位目标矩形并上报协调器（最多重试 10 帧）
  void _scheduleLivePipRestoreAttach() {
    _pipRestoreRectAttempts = 0;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _attachLivePipRestore(),
    );
  }

  void _attachLivePipRestore() {
    if (!mounted || !_pipRestoreInFlight) return;
    final targetRect = _livePlayerRect(relativeToPage: true);
    if (targetRect == null && _pipRestoreRectAttempts++ < 10) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _attachLivePipRestore(),
      );
      return;
    }
    LivePipOverlayService.transition.attachRestorePage(
      targetRect: targetRect,
      onCompleted: () {
        if (!mounted) {
          _pipRestoreInFlight = false;
          return;
        }
        setState(() => _pipRestoreInFlight = false);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    addObserverMobile(this);
    final args = Get.arguments;

    // 解析当前请求进入的房间号
    int? currentEntryRoomId;
    if (args is Map) {
      currentEntryRoomId = (args['roomId'] as int?) ?? (args['id'] as int?);
    } else if (args is int) {
      currentEntryRoomId = args;
    }

    // 检测是否是从小窗返回（即：进入的房间正是当前小窗中的房间）
    final bool isReturningFromPip =
        currentEntryRoomId != null &&
        LivePipOverlayService.isCurrentLiveRoom(currentEntryRoomId);

    // 无论是否是同一个房间，既然进入了直播详情页，就关闭现有的小窗（不销毁播放器）
    if (LivePipOverlayService.isInPipMode) {
      // 本页随后会新建 controller 并自开弹幕流/通知条目，旧 controller 就此退休
      LivePipOverlayService.cleanupSavedController();
      if (isReturningFromPip &&
          LivePipOverlayService.transition.phase == PipPhase.restoring) {
        // 点击展开（归位动画中）：小窗仍在飞向本页，非销毁式关闭推迟到
        // 握手完成由协调器触发 _finalizeRestore 执行；本页播放器先透明占位
        _pipRestoreInFlight = true;
        _scheduleLivePipRestoreAttach();
      } else {
        // 其他房间/无动画路径：维持旧的非销毁式关闭，让新页面接管播放器
        WidgetsBinding.instance.addPostFrameCallback((_) {
          LivePipOverlayService.stopLivePip(callOnClose: false);
        });
      }
    }

    // 如果有视频小窗也关闭
    if (PipOverlayService.isInPipMode) {
      PipOverlayService.stopPip(
        callOnClose: false,
        releaseSavedOwner: true,
        // 小窗 owner 的视频页仍在栈内时只暂停不 dispose，避免破坏其计数
        disposeSavedOwnerPlayer: VideoStackManager.getCount() == 0,
      );
    }

    _liveRoomController = Get.put(
      LiveRoomController(heroTag, fromPip: isReturningFromPip),
      tag: heroTag,
    );
    plPlayerController = _liveRoomController.plPlayerController
      ..addStatusLister(playerListener);
    PlPlayerController.setPlayCallBack(plPlayerController.play);
    _liveRoomController.onRequestInAppPip = _enterLivePipManually;

    if (isReturningFromPip) {
      _liveRoomController.isInPipMode.value = false;
      plPlayerController
        ..isLive = true
        ..danmakuController = _liveRoomController.danmakuController;
      _liveRoomController
        ..danmakuController?.resume()
        ..startLiveTimer()
        ..startLiveMsg();
    } else {
      plPlayerController.isLive = true;
      if (plPlayerController.removeSafeArea) {
        hideSystemBar();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (plPlayerController.removeSafeArea) {
      padding = .zero;
    } else {
      padding = MediaQuery.viewPaddingOf(context);
    }
    final size = MediaQuery.sizeOf(context);
    maxWidth = size.width;
    maxHeight = size.height;
    isWindowMode = MaxScreenSize.isWindowMode(
      width: maxWidth * plPlayerController.uiScale,
      height: maxHeight * plPlayerController.uiScale,
    );
    isPortrait = size.isPortrait;
    plPlayerController.screenRatio = maxHeight / maxWidth;
  }

  @override
  Future<void> didPopNext() async {
    addObserverMobile(this);

    // 如果返回当前页面时应用内小窗正在运行，且房间号匹配，说明是从正在小窗播放的页面返回
    if (LivePipOverlayService.isInPipMode) {
      if (LivePipOverlayService.currentRoomId == _liveRoomController.roomId) {
        // 返回展开：小窗飞回页内播放器位置，非销毁式关闭推迟到握手完成；
        // 无法归位（无小窗会话）则维持旧的瞬时关闭
        if (LivePipOverlayService.transition.beginRestore()) {
          _pipRestoreInFlight = true;
          _scheduleLivePipRestoreAttach();
        } else {
          LivePipOverlayService.stopLivePip(
            callOnClose: false,
            immediate: true,
          );
        }
      } else {
        // 小窗里是其他房间，返回直播间时必须关闭，否则会同时播放两个视频
        LivePipOverlayService.stopLivePip(callOnClose: true, immediate: true);
        // 当前页面之前可能曾尝试进入小窗，需要重置该标志防止 dispose 跳过播放器清理
        _isEnteringPipMode = false;
      }
    }
    // 直播页返回时，若视频小窗仍在运行，也需关闭
    if (PipOverlayService.isInPipMode) {
      PipOverlayService.stopPip(callOnClose: true, immediate: true);
      _isEnteringPipMode = false;
    }

    // 如果 local 的 plPlayerController 实例指向了已被销毁的单例，刷新它
    if (plPlayerController != _liveRoomController.plPlayerController) {
      plPlayerController = _liveRoomController.plPlayerController;
    }

    if (!plPlayerController.isLive) {
      plPlayerController.isLive = true;
      _liveRoomController.isLoaded.refresh();
    }
    plPlayerController.danmakuController =
        _liveRoomController.danmakuController;
    PlPlayerController.setPlayCallBack(plPlayerController.play);
    _liveRoomController.startLiveTimer();

    // 如果是从小窗返回，直接恢复状态，不重新初始化
    if (_liveRoomController.isReturningFromPip) {
      _liveRoomController
        ..danmakuController?.resume()
        ..startLiveMsg();
      plPlayerController.addStatusLister(playerListener);
      super.didPopNext();
      return;
    }

    // 非小窗返回情况下的恢复：如果播放器未初始化（例如小窗在其它页面被手动关闭），或者被其它直播/视频抢占
    final bool shouldPlay =
        _liveRoomController.isPlaying ??
        plPlayerController.playerStatus.isPlaying;

    bool needsRecovery = false;
    if (plPlayerController.videoPlayerController == null) {
      needsRecovery = true;
    } else if (!plPlayerController.isLive ||
        plPlayerController.roomId != _liveRoomController.roomId) {
      needsRecovery = true;
    }

    if (needsRecovery) {
      await _liveRoomController.playerInit(autoplay: shouldPlay);
      // 重新获取刷新后的实例
      plPlayerController = _liveRoomController.plPlayerController;
    }

    plPlayerController.addStatusLister(playerListener);

    if (plPlayerController.playerStatus.isPlaying &&
        plPlayerController.cid == null) {
      _liveRoomController
        ..danmakuController?.resume()
        ..startLiveMsg();
    } else {
      final shouldPlay = _liveRoomController.isPlaying ?? false;
      if (shouldPlay) {
        _liveRoomController
          ..danmakuController?.resume()
          ..startLiveMsg();
      }
      await _liveRoomController.playerInit(autoplay: shouldPlay);
    }
    if (!mounted) return;
    plPlayerController.addStatusLister(playerListener);
    super.didPopNext();
  }

  @override
  void didPushNext() {
    removeObserverMobile(this);
    plPlayerController.removeStatusLister(playerListener);

    if (plPlayerController.playerStatus.isPlaying &&
        !isFullScreen &&
        _shouldStartLivePip()) {
      _startLivePipIfNeeded();
    } else {
      _liveRoomController
        ..danmakuController?.clear()
        ..cancelLiveTimer()
        ..closeLiveMsg()
        ..isPlaying = plPlayerController.playerStatus.isPlaying;
    }

    super.didPushNext();
  }

  void playerListener(PlayerStatus status) {
    if (status.isPlaying) {
      _liveRoomController
        ..danmakuController?.resume()
        ..startLiveTimer()
        ..startLiveMsg();
    } else {
      _liveRoomController
        ..danmakuController?.pause()
        ..cancelLiveTimer()
        ..closeLiveMsg();
    }
  }

  @override
  void dispose() {
    final isInLivePip = LivePipOverlayService.isCurrentLiveRoom(
      _liveRoomController.roomId,
    );
    if (!isInLivePip && !_isEnteringPipMode) {
      videoPlayerServiceHandler?.onVideoDetailDispose(heroTag);
    }
    removeObserverMobile(this);
    if (Platform.isAndroid && !plPlayerController.setSystemBrightness) {
      ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
    }
    if (!isInLivePip && !_isEnteringPipMode) {
      PlPlayerController.setPlayCallBack(null);
    }
    plPlayerController.removeStatusLister(playerListener);
    if (_liveRoomController.onRequestInAppPip == _enterLivePipManually) {
      _liveRoomController.onRequestInAppPip = null;
    }
    if (!isInLivePip && !_isEnteringPipMode) {
      plPlayerController.dispose();
    }

    for (final e in LiveContributionRankType.values) {
      Get.delete<ContributionRankController>(
        tag: '${_liveRoomController.roomId}${e.name}',
      );
    }

    if (!isInLivePip && !_isEnteringPipMode) {
      Get.delete<LiveRoomController>(tag: heroTag, force: true);
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (plPlayerController.visible = state == .resumed) {
      if (!plPlayerController.showDanmaku) {
        _liveRoomController
          ..refreshMsgIfNeeded()
          ..startLiveTimer();
        plPlayerController.showDanmaku = true;
      }
    } else if (state == .paused) {
      _liveRoomController.cancelLiveTimer();
      plPlayerController
        ..showDanmaku = false
        ..danmakuController?.clear();
    }
  }

  late double maxWidth;
  late double maxHeight;
  bool isWindowMode = false;
  late EdgeInsets padding;
  late bool isPortrait;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (plPlayerController.isPipMode) {
      child = videoPlayerPanel(
        isFullScreen,
        width: maxWidth,
        height: maxHeight,
        isPipMode: true,
        needDm: !plPlayerController.pipNoDanmaku,
      );
    } else {
      child = childWhenDisabled;
    }
    if (plPlayerController.keyboardControl) {
      child = PlayerFocus(
        plPlayerController: plPlayerController,
        onSendDanmaku: _liveRoomController.onSendDanmaku,
        onRefresh: _liveRoomController.queryLiveUrl,
        child: child,
      );
    }
    // 页面根参照系：归位目标矩形以此量取
    return KeyedSubtree(
      key: _pageRootKey,
      child: Theme(
        data: ThemeUtils.darkTheme,
        child: child,
      ),
    );
  }

  Widget videoPlayerPanel(
    bool isFullScreen, {
    required double width,
    required double height,
    bool isPipMode = false,
    Color fill = Colors.black,
    Alignment alignment = Alignment.center,
    bool needDm = true,
  }) {
    if (!isFullScreen && !plPlayerController.isDesktopPip) {
      _liveRoomController.fsSC.value = null;
    }
    _liveRoomController.isFullScreen = isFullScreen;
    Widget player = Obx(
      key: playerKey,
      () {
        if (_liveRoomController.isLoaded.value && plPlayerController.isLive) {
          final roomInfoH5 = _liveRoomController.roomInfoH5.value;
          return PLVideoPlayer(
            maxWidth: width,
            maxHeight: height,
            isPipMode: isPipMode,
            fill: fill,
            alignment: alignment,
            plPlayerController: plPlayerController,
            headerControl: LiveHeaderControl(
              key: _liveRoomController.headerKey,
              title: roomInfoH5?.roomInfo?.title,
              upName: roomInfoH5?.anchorInfo?.baseInfo?.uname,
              plPlayerController: plPlayerController,
              onSendDanmaku: _liveRoomController.onSendDanmaku,
              onPlayAudio: _liveRoomController.queryLiveUrl,
              isPortrait: isPortrait,
              liveController: _liveRoomController,
              onlineWidget: onlineWidget,
            ),
            bottomControl: BottomControl(
              plPlayerController: plPlayerController,
              liveRoomCtr: _liveRoomController,
              onRefresh: _liveRoomController.queryLiveUrl,
            ),
            danmuWidget: !needDm
                ? null
                : LiveDanmaku(
                    liveRoomController: _liveRoomController,
                    plPlayerController: plPlayerController,
                    isFullScreen: isFullScreen,
                    isPipMode: plPlayerController.isDesktopPip || isPipMode,
                    size: Size(width, height),
                  ),
          );
        }
        return const SizedBox.shrink();
      },
    );
    if (_liveRoomController.showSuperChat &&
        (isFullScreen || plPlayerController.isDesktopPip)) {
      player = Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: player),
          if (kDebugMode) ...[
            Positioned(
              top: 50,
              right: 0,
              child: TextButton(
                onPressed: () {
                  final item = SuperChatItem.random;
                  _liveRoomController
                    ..fsSC.value = item
                    ..addDm(item);
                },
                child: const Text('add superchat'),
              ),
            ),
            Positioned(
              right: 0,
              top: 90,
              child: TextButton(
                onPressed: () {
                  _liveRoomController.fsSC.value = null;
                },
                child: const Text('remove superchat'),
              ),
            ),
          ],
          Positioned(
            left: padding.left + 25,
            bottom: 25,
            width: fullScreenSCWidth,
            child: Obx(() {
              final item = _liveRoomController.fsSC.value;
              if (item == null) {
                return const SizedBox.shrink();
              }
              try {
                return ExtraHitTestStack(
                  key: ValueKey(item.id),
                  clipBehavior: Clip.none,
                  children: [
                    SuperChatCard(
                      item: item,
                      onRemove: () => _liveRoomController.fsSC.value = null,
                      onReport: () => _liveRoomController.reportSC(item),
                    ),
                    Positioned(
                      right: -6,
                      top: -6,
                      child: iconButton(
                        size: 24,
                        iconSize: 14,
                        bgColor: const Color(0xEEFFFFFF),
                        iconColor: Colors.black54,
                        icon: const Icon(Icons.clear),
                        onPressed: () => _liveRoomController.fsSC.value = null,
                      ),
                    ),
                  ],
                );
              } catch (_) {
                if (kDebugMode) rethrow;
                return const SizedBox.shrink();
              }
            }),
          ),
        ],
      );
    }
    final Widget result = popScope(
      canPop: _canPopPage,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: player,
    );
    // 归位动画中：透明占位参与布局（供量取目标矩形）但不可见不可点，
    // 小窗是唯一可见端，恢复握手完成后亮出
    return _pipRestoreInFlight
        ? IgnorePointer(child: Opacity(opacity: 0, child: result))
        : result;
  }

  // 本页能否被 pop 收起：popScope 的 canPop 与手动小窗入口共用同一判定
  bool get _canPopPage => _liveRoomController.canPopPage;

  void _onPopInvokedWithResult(bool didPop, Object? result) {
    if (didPop) {
      final manual = _manualPipRequested;
      _manualPipRequested = false;
      _startLivePipIfNeeded(manual: manual);
    } else {
      // pop 被拦下，手动小窗的一次性豁免不能留给下一次普通返回
      _manualPipRequested = false;
    }
    plPlayerController.onPopInvokedWithResult(
      didPop,
      result,
      pauseOnPop: !_isEnteringPipMode,
    );
  }

  /// 三点菜单「应用内画中画」：不依赖设置开关，把当前直播临时收进小窗。
  /// 复用返回键收起路径（pop → _onPopInvokedWithResult → _startLivePipIfNeeded），
  /// 只是提前把条件凑齐：全屏的先退全屏、暂停的先续播、嵌套页先静默移除
  Future<void> _enterLivePipManually() async {
    if (!mounted || _isEnteringPipMode || _manualPipRequested) {
      return;
    }
    if (plPlayerController.isFullScreen.value) {
      // 全屏时返回键语义是"退出全屏"，页面本就不能被 pop；且直接 pop 会把
      // 播放器单例的 isFullScreen 留在 true、方向也不复位。先退回半屏再走正常流程
      final rectBeforeExit = _livePlayerRect();
      await plPlayerController.triggerFullScreen(status: false);
      if (!mounted) {
        return;
      }
      // 退出全屏会切到半屏的布局分支（与方向是否变化无关），布局落定前
      // _livePlayerRect() 量的还是全屏时的整屏位置，收起动画会从整屏开始。
      // 以播放器矩形变化为落定信号；不能拿 MediaQuery.size 当信号——
      // 移动端退全屏只是隐藏系统栏，size 并不变
      // 量不到基线矩形（播放器未就绪，收起本来也不会有动画）时不必等
      await PipOverlayService.awaitLayoutSettled(
        () => rectBeforeExit == null || _livePlayerRect() != rectBeforeExit,
      );
      if (!mounted) {
        return;
      }
    }
    if (plPlayerController.videoController != null &&
        !plPlayerController.playerStatus.isPlaying) {
      // 手动进小窗是明确的播放意图
      await plPlayerController.play();
      if (!mounted) {
        return;
      }
    }
    if (!_canPopPage || !_shouldStartLivePip(manual: true)) {
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

  /// [manual] 为三点菜单手动触发：不受设置开关约束
  bool _shouldStartLivePip({bool manual = false}) {
    if (!manual && !Pref.enableInAppPip) {
      return false;
    }
    if (LivePipOverlayService.isInPipMode) {
      return false;
    }
    if (plPlayerController.isDesktopPip || plPlayerController.isPipMode) {
      return false;
    }
    if (!plPlayerController.isLive) {
      return false;
    }
    // 如果即将进入听视频界面，不开启小窗(没啥用，直播间没有相关入口，但还是留着吧？)
    if (Get.currentRoute == '/audio') {
      return false;
    }
    return true;
  }

  void _startLivePipIfNeeded({bool manual = false}) {
    if (!_shouldStartLivePip(manual: manual)) {
      return;
    }
    // 设置小窗模式标志
    _liveRoomController.isInPipMode.value = true;
    _isEnteringPipMode = true;
    // 继续播放直播消息
    _liveRoomController.startLiveMsg();

    try {
      LivePipOverlayService.startLivePip(
        context: context,
        heroTag: heroTag,
        roomId: _liveRoomController.roomId,
        plPlayerController: plPlayerController,
        controller: _liveRoomController,
        // 收起动画源矩形：页面播放器当前屏幕位置；量取失败则无动画直接出现
        sourceRect: _livePlayerRect(),
        onClose: () {
          _isEnteringPipMode = false;
          _liveRoomController.isInPipMode.value = false;
          _handleLivePipCloseCleanup();
        },
        onReturn: () {
          _isEnteringPipMode = false;
          Get.toNamed(
            '/liveRoom',
            arguments: {
              'roomId': _liveRoomController.roomId,
              'fromPip': true,
            },
          );
        },
      );
    } catch (e) {
      // PiP 启动失败，重置状态
      _isEnteringPipMode = false;
      _liveRoomController.isInPipMode.value = false;
      logger.e('Failed to start live PiP: $e');
    }
  }

  void _handleLivePipCloseCleanup() {
    if (plPlayerController.isCloseAll) {
      return;
    }
    _liveRoomController.isInPipMode.value = false;
    // 路由 pop 时 onClose 已因 isInPipMode 跳过清理，下方 Get.delete 对已
    // 注销实例是空操作，弹幕流与计时器需在此显式关闭
    _liveRoomController
      ..closeLiveMsg()
      ..cancelLiveTimer()
      ..cancelLikeTimer();
    videoPlayerServiceHandler?.onVideoDetailDispose(heroTag);
    if (Platform.isAndroid && !plPlayerController.setSystemBrightness) {
      ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
    }
    PlPlayerController.setPlayCallBack(null);
    plPlayerController
      ..removeStatusLister(playerListener)
      ..dispose();

    // 彻底清理永久控制器
    Get.delete<LiveRoomController>(tag: heroTag, force: true);
  }

  Widget get childWhenDisabled {
    return Obx(() {
      final isFullScreen = this.isFullScreen || plPlayerController.isDesktopPip;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          const SizedBox.expand(child: ColoredBox(color: Colors.black)),
          if (!isFullScreen)
            Obx(
              () {
                final appBackground = _liveRoomController
                    .roomInfoH5
                    .value
                    ?.roomInfo
                    ?.appBackground;
                Widget child;
                if (appBackground != null && appBackground.isNotEmpty) {
                  child = CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: maxWidth,
                    height: maxHeight,
                    memCacheWidth: maxWidth.cacheSize(context),
                    imageUrl: ImageUtils.safeThumbnailUrl(appBackground),
                    placeholder: (_, _) => const SizedBox.shrink(),
                  );
                } else {
                  child = Image.asset(
                    Assets.livingBackground,
                    fit: BoxFit.cover,
                    width: maxWidth,
                    height: maxHeight,
                    cacheWidth: maxWidth.cacheSize(context),
                  );
                }
                return Positioned.fill(
                  child: Opacity(opacity: 0.6, child: child),
                );
              },
            ),
          ScaffoldLayout(
            appBar: isWindowMode && isFullScreen && !isPortrait
                ? null
                : _buildAppBar(isFullScreen),
            body: isPortrait
                ? Obx(
                    () {
                      if (_liveRoomController.isPortrait.value) {
                        return _buildPP(isFullScreen);
                      }
                      return _buildPH(isFullScreen);
                    },
                  )
                : _buildBodyH(isFullScreen),
          ),
        ],
      );
    });
  }

  Widget _buildPH(bool isFullScreen) {
    final height = maxWidth / Style.aspectRatio16x9;
    final videoHeight = isFullScreen
        ? maxHeight - (isWindowMode && !isPortrait ? 0 : padding.top)
        : height;
    final bottomHeight = maxHeight - padding.top - height - kToolbarHeight;
    return Column(
      children: [
        SizedBox(
          width: maxWidth,
          height: videoHeight,
          child: videoPlayerPanel(
            isFullScreen,
            width: maxWidth,
            height: videoHeight,
          ),
        ),
        Offstage(
          offstage: isFullScreen,
          child: SizedBox(
            width: maxWidth,
            height: max(0, bottomHeight),
            child: _buildBottomWidget,
          ),
        ),
      ],
    );
  }

  Widget _buildPP(bool isFullScreen) {
    final bottomHeight = 70 + padding.bottom;
    final videoHeight = isFullScreen
        ? maxHeight - (isWindowMode && !isPortrait ? 0 : padding.top)
        : maxHeight - bottomHeight;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          bottom: isFullScreen ? 0 : bottomHeight,
          child: videoPlayerPanel(
            width: maxWidth,
            height: videoHeight,
            isFullScreen,
            needDm: isFullScreen,
            alignment: isFullScreen ? Alignment.center : Alignment.topCenter,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 55 + bottomHeight,
          height: maxHeight * 0.32,
          child: Offstage(
            offstage: isFullScreen,
            child: _buildChatWidget(true),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: bottomHeight,
          child: Offstage(
            offstage: isFullScreen,
            child: _buildInputWidget,
          ),
        ),
      ],
    );
  }

  Widget get onlineWidget => GestureDetector(
    onTap: _showRank,
    child: Obx(() {
      if (_liveRoomController.onlineCount.value case final onlineCount?) {
        return Text(
          '高能观众($onlineCount)',
          style: const TextStyle(fontSize: 12, color: Colors.white),
        );
      }
      return const SizedBox.shrink();
    }),
  );

  void _showRank() {
    if (_liveRoomController.ruid case final ruid?) {
      final heightFactor = PlatformUtils.isMobile && !isPortrait ? 1.0 : 0.7;
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        clipBehavior: .hardEdge,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 450),
        builder: (context) => FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: heightFactor,
          child: ContributionRankPanel(
            ruid: ruid,
            roomId: _liveRoomController.roomId,
          ),
        ),
      );
    }
  }

  PreferredSizeWidget _buildAppBar(bool isFullScreen) {
    return AppBar(
      primary: !plPlayerController.removeSafeArea,
      toolbarHeight: isFullScreen ? 0 : null,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(color: Colors.white),
      title: isFullScreen || plPlayerController.isDesktopPip
          ? null
          : Obx(
              () {
                RoomInfoH5Data? roomInfoH5 =
                    _liveRoomController.roomInfoH5.value;
                if (roomInfoH5 == null) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () =>
                      Get.toNamed('/member?mid=${roomInfoH5.roomInfo?.uid}'),
                  child: Row(
                    spacing: 10,
                    mainAxisSize: .min,
                    children: [
                      NetworkImgLayer(
                        width: 34,
                        height: 34,
                        type: .avatar,
                        src: roomInfoH5.anchorInfo!.baseInfo!.face,
                      ),
                      Flexible(
                        child: Column(
                          spacing: 1,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10,
                              mainAxisSize: .min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    roomInfoH5.anchorInfo!.baseInfo!.uname!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onlineWidget,
                              ],
                            ),
                            Row(
                              spacing: 10,
                              mainAxisSize: .min,
                              children: [
                                _liveRoomController.watchedWidget,
                                _liveRoomController.timeWidget,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      actions: [
        // IconButton(
        //   tooltip: '刷新',
        //   onPressed: _liveRoomController.queryLiveUrl,
        //   icon: const Icon(Icons.refresh, size: 20),
        // ),
        StaticPopupMenuButton(
          icon: const Icon(Icons.more_vert, size: 20),
          itemBuilder: (BuildContext context) {
            final liveUrl =
                'https://live.bilibili.com/${_liveRoomController.roomId}';
            return <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () => Utils.copyText(liveUrl),
                child: const Row(
                  spacing: 10,
                  mainAxisSize: .min,
                  children: [
                    Icon(Icons.copy, size: 19),
                    Text('复制链接'),
                  ],
                ),
              ),
              if (PlatformUtils.isMobile)
                PopupMenuItem(
                  onTap: () => ShareUtils.shareText(liveUrl),
                  child: const Row(
                    spacing: 10,
                    mainAxisSize: .min,
                    children: [
                      Icon(Icons.share, size: 19),
                      Text('分享直播间'),
                    ],
                  ),
                ),
              PopupMenuItem(
                onTap: () => PageUtils.inAppWebview(liveUrl, off: true),
                child: const Row(
                  spacing: 10,
                  mainAxisSize: .min,
                  children: [
                    Icon(Icons.open_in_browser, size: 19),
                    Text('浏览器打开'),
                  ],
                ),
              ),
              if (_liveRoomController.roomInfoH5.value != null)
                PopupMenuItem(
                  onTap: () {
                    try {
                      RoomInfoH5Data roomInfo =
                          _liveRoomController.roomInfoH5.value!;
                      PageUtils.pmShare(
                        this.context,
                        content: {
                          "cover": roomInfo.roomInfo!.cover!,
                          "sourceID": _liveRoomController.roomId.toString(),
                          "title": roomInfo.roomInfo!.title!,
                          "url": liveUrl,
                          "authorID": roomInfo.roomInfo!.uid.toString(),
                          "source": "直播",
                          "desc": roomInfo.roomInfo!.title!,
                          "author": roomInfo.anchorInfo!.baseInfo!.uname,
                        },
                      );
                    } catch (e) {
                      SmartDialog.showToast(e.toString());
                    }
                  },
                  child: const Row(
                    spacing: 10,
                    mainAxisSize: .min,
                    children: [
                      Icon(Icons.forward_to_inbox, size: 19),
                      Text('分享至消息'),
                    ],
                  ),
                ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildBodyH(bool isFullScreen) {
    double videoWidth =
        clampDouble(maxHeight / maxWidth * 1.08, 0.56, 0.7) * maxWidth;
    final rightWidth = min(400.0, maxWidth - videoWidth - padding.horizontal);
    videoWidth = maxWidth - rightWidth - padding.horizontal;
    final videoHeight = maxHeight - padding.top - kToolbarHeight;
    final width = isFullScreen ? maxWidth : videoWidth;
    final height = isFullScreen
        ? maxHeight - (isWindowMode && !isPortrait ? 0 : padding.top)
        : videoHeight;
    return Padding(
      padding: isFullScreen
          ? EdgeInsets.zero
          : EdgeInsets.only(left: padding.left, right: padding.right),
      child: Row(
        children: [
          Container(
            width: width,
            height: height,
            margin: EdgeInsets.only(bottom: padding.bottom),
            child: videoPlayerPanel(
              isFullScreen,
              fill: Colors.transparent,
              width: width,
              height: height,
            ),
          ),
          Offstage(
            offstage: isFullScreen,
            child: SizedBox(
              width: rightWidth,
              height: videoHeight,
              child: _buildBottomWidget,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buildBottomWidget => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: _buildChatWidget()),
      _buildInputWidget,
    ],
  );

  Widget _buildChatWidget([bool isPP = false]) {
    Widget chat() => LiveRoomChatPanel(
      key: chatKey,
      isPP: isPP,
      liveRoomController: _liveRoomController,
    );
    return Padding(
      padding: .only(bottom: 12, top: isPortrait ? 12 : 0),
      child: _liveRoomController.showSuperChat
          ? PageView(
              key: pageKey,
              controller: _liveRoomController.pageController,
              physics: tabBarScrollPhysics,
              onPageChanged: _liveRoomController.pageIndex.call,
              horizontalDragGestureRecognizer:
                  CustomHorizontalDragGestureRecognizer.new,
              children: [
                KeepAliveWrapper(child: chat()),
                SuperChatPanel(
                  key: scKey,
                  controller: _liveRoomController,
                ),
              ],
            )
          : chat(),
    );
  }

  Widget get _buildInputWidget {
    final child = Container(
      padding: .only(top: 5, left: 10, right: 10, bottom: padding.bottom),
      height: 70 + padding.bottom,
      decoration: const BoxDecoration(
        borderRadius: .vertical(top: .circular(20)),
        border: Border(top: BorderSide(color: Color(0x1AFFFFFF))),
        color: Color(0x1AFFFFFF),
      ),
      child: GestureDetector(
        onTap: _liveRoomController.onSendDanmaku,
        behavior: .opaque,
        child: Padding(
          padding: const .only(top: 5, bottom: 10),
          child: Align(
            alignment: .topCenter,
            child: Row(
              spacing: 6,
              children: [
                Obx(
                  () {
                    final enableShowLiveDanmaku =
                        plPlayerController.enableShowLiveDanmaku.value;
                    return SizedBox(
                      width: 34,
                      height: 34,
                      child: IconButton(
                        style: IconButton.styleFrom(padding: .zero),
                        onPressed: () {
                          final newVal = !enableShowLiveDanmaku;
                          plPlayerController.enableShowLiveDanmaku.value =
                              newVal;
                          if (!plPlayerController.tempPlayerConf) {
                            GStorage.setting.put(
                              SettingBoxKey.enableShowLiveDanmaku,
                              newVal,
                            );
                          }
                        },
                        icon: enableShowLiveDanmaku
                            ? const Icon(
                                size: 22,
                                CustomIcons.dm_on,
                                color: baseWhite,
                              )
                            : const Icon(
                                size: 22,
                                CustomIcons.dm_off,
                                color: baseWhite,
                              ),
                      ),
                    );
                  },
                ),
                const Expanded(
                  child: Text('发送弹幕', style: TextStyle(color: baseWhite)),
                ),
                Builder(
                  builder: (context) {
                    final isLogin = kDebugMode || _liveRoomController.isLogin;
                    final colorScheme = ColorScheme.of(context);
                    return Material(
                      type: MaterialType.transparency,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            overlayColor: _overlayColor(colorScheme),
                            customBorder: const CircleBorder(),
                            onTap: isLogin
                                ? null
                                : _liveRoomController.toastNotLogin,
                            onTapDown: isLogin
                                ? _liveRoomController.onLikeTapDown
                                : null,
                            onTapUp: isLogin
                                ? _liveRoomController.onLikeTapUp
                                : null,
                            onTapCancel: isLogin
                                ? _liveRoomController.onLikeTapUp
                                : null,
                            child: const SizedBox.square(
                              dimension: 34,
                              child: Icon(
                                size: 22,
                                color: baseWhite,
                                Icons.thumb_up_off_alt,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 30,
                            top: -12,
                            child: Obx(() {
                              final likeClickTime =
                                  _liveRoomController.likeClickTime.value;
                              if (likeClickTime == 0) {
                                return const SizedBox.shrink();
                              }
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 160),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Text(
                                  key: ValueKey(likeClickTime),
                                  'x$likeClickTime',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme.isDark
                                        ? colorScheme.primary
                                        : colorScheme.inversePrimary,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 34,
                  height: 34,
                  child: IconButton(
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => _liveRoomController.onSendDanmaku(true),
                    icon: const Icon(
                      size: 22,
                      color: baseWhite,
                      Icons.emoji_emotions_outlined,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (_liveRoomController.showSuperChat) {
      return Stack(
        children: [
          child,
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Obx(
              () => _BorderIndicator(
                radius: const Radius.circular(20),
                isLeft: _liveRoomController.pageIndex.value == 0,
              ),
            ),
          ),
        ],
      );
    }
    return child;
  }

  WidgetStateProperty<Color?>? _overlayColor(ColorScheme colorScheme) =>
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        final color = states.contains(WidgetState.selected)
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant;
        if (states.contains(WidgetState.pressed)) {
          return color.withValues(alpha: 0.1);
        } else if (states.contains(WidgetState.hovered)) {
          return color.withValues(alpha: 0.08);
        } else if (states.contains(WidgetState.focused)) {
          return color.withValues(alpha: 0.1);
        } else {
          return Colors.transparent;
        }
      });
}

class _BorderIndicator extends LeafRenderObjectWidget {
  const _BorderIndicator({
    required this.radius,
    required this.isLeft,
  });

  final Radius radius;
  final bool isLeft;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBorderIndicator(
      radius: radius,
      isLeft: isLeft,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderBorderIndicator renderObject,
  ) {
    renderObject
      ..radius = radius
      ..isLeft = isLeft;
  }
}

class _RenderBorderIndicator extends RenderBox {
  _RenderBorderIndicator({
    required this._radius,
    required this._isLeft,
  });

  Radius _radius;
  Radius get radius => _radius;
  set radius(Radius value) {
    if (_radius == value) return;
    _radius = value;
    markNeedsLayout();
  }

  bool _isLeft;
  bool get isLeft => _isLeft;
  set isLeft(bool value) {
    if (_isLeft == value) return;
    _isLeft = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.constrainDimensions(constraints.maxWidth, _radius.x);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final size = this.size;
    final canvas = context.canvas;
    final width = size.width / 2;

    BoxBorder.paintNonUniformBorder(
      canvas,
      Rect.fromLTWH(
        offset.dx + (_isLeft ? 0 : width),
        offset.dy,
        width,
        size.height,
      ),
      borderRadius: BorderRadius.only(
        topLeft: _isLeft ? _radius : .zero,
        topRight: _isLeft ? .zero : _radius,
      ),
      textDirection: null,
      top: const BorderSide(),
      color: Colors.white38,
    );
  }
}

class LiveDanmaku extends StatefulWidget {
  final LiveRoomController liveRoomController;
  final PlPlayerController plPlayerController;
  final bool isPipMode;
  final bool isFullScreen;
  final Size size;

  const LiveDanmaku({
    super.key,
    required this.liveRoomController,
    required this.plPlayerController,
    this.isPipMode = false,
    required this.isFullScreen,
    required this.size,
  });

  @override
  State<LiveDanmaku> createState() => _LiveDanmakuState();

  bool get notFullscreen => !isFullScreen || isPipMode;
}

class _LiveDanmakuState extends State<LiveDanmaku> {
  PlPlayerController get plPlayerController => widget.plPlayerController;

  @override
  void didUpdateWidget(LiveDanmaku oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notFullscreen != widget.notFullscreen &&
        !DanmakuOptions.sameFontScale) {
      plPlayerController.danmakuController?.updateOption(
        DanmakuOptions.get(notFullscreen: widget.notFullscreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final option = DanmakuOptions.get(notFullscreen: widget.notFullscreen);
    return Obx(
      () => AnimatedOpacity(
        opacity: plPlayerController.enableShowLiveDanmaku.value
            ? plPlayerController.danmakuOpacity.value
            : 0,
        duration: const Duration(milliseconds: 100),
        child: DanmakuScreen<DanmakuExtra>(
          createdController: (e) {
            widget.liveRoomController.danmakuController =
                plPlayerController.danmakuController = e;
          },
          option: option,
          size: widget.size,
        ),
      ),
    );
  }
}
