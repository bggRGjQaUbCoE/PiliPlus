import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' show max, min;

import 'package:PiliPlus/common/widgets/pip_control_button.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/services/pip_transition_coordinator.dart';
import 'package:PiliPlus/services/route_stack_observer.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart'
    show PointerEnterEvent, PointerExitEvent, PointerScrollEvent;
import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';

class VideoStackManager {
  static int _videoPageCount = 0;

  static void increment() {
    _videoPageCount++;
    _log('increment: count = $_videoPageCount');
  }

  static void decrement() {
    if (_videoPageCount > 0) {
      _videoPageCount--;
      _log('decrement: count = $_videoPageCount');
    }
  }

  static int getCount() => _videoPageCount;

  static bool isReturningToVideo() {
    final result = _videoPageCount > 1;
    if (result) {
      _log('isReturningToVideo check: true (count = $_videoPageCount)');
    }
    return result;
  }

  static void _log(String msg) {
    if (!kDebugMode) return;
    logger.i('[VideoStackManager] $msg');
  }
}

class PipOverlayService {
  static bool isVertical = false;

  static OverlayEntry? _overlayEntry;
  static bool isInPipMode = false;
  static final RxBool _isNativePip = false.obs;
  static bool get isNativePip => _isNativePip.value;
  static set isNativePip(bool value) => _isNativePip.value = value;

  /// 小窗过渡动画协调器(收起/展开的相位机与恢复握手)
  static final PipTransitionCoordinator transition = PipTransitionCoordinator()
    ..onRestoreFinished = _finalizeRestore;

  // 恢复握手完成:执行与旧路径完全相同的非销毁式关闭(清引用/移除 overlay/
  // 同步 auto-PiP),只是从"恢复页 initState 瞬时执行"推迟到了此刻。
  // 传入当前 saved key 使 shouldResetState=false;控制器所有权已由恢复页面
  // 接管,不释放 owner
  static void _finalizeRestore() {
    stopPip(
      callOnClose: false,
      immediate: true,
      targetContextKey: _savedVideoContextKey,
    );
  }

  static VoidCallback? _onCloseCallback;
  static VoidCallback? _onTapToReturnCallback;

  static void onTapToReturn() {
    final callback = _onTapToReturnCallback;
    _onCloseCallback = null;
    _onTapToReturnCallback = null;
    callback?.call();
  }

  // 保存控制器引用，防止被 GC
  static dynamic _savedController;
  static PlPlayerController? _savedPlayerController;
  static String? _savedVideoContextKey;
  static String? get savedVideoContextKey => _savedVideoContextKey;
  static final Map<String, dynamic> _savedControllers = {};

  static bool isVideoLikeRoute(String route) {
    return route.startsWith('/video') || route.startsWith('/liveRoom');
  }

  /// 静默移除 [context] 所在路由正下方连续的视频/直播播放页，返回移除数量。
  /// 手动进小窗前调用：这些页面若留在栈内，当前页 pop 后会作为新顶层收到
  /// didPopNext，发现小窗里不是自己的内容而把小窗关掉。removeRoute 只发
  /// didRemove，RouteObserver 不会据此触发 didPopNext；被移除的页面按普通
  /// 离栈语义 dispose（下一帧），最终由小窗独占播放器。
  /// 这里是破坏性删除，用精确路由名而非 isVideoLikeRoute 的前缀匹配：
  /// /videoWeb（UP 主投稿页）等同前缀的非播放页不能被误删
  static int removeNestedVideoLikeRoutesBelow(BuildContext context) {
    final navigator = Get.key.currentState;
    final current = ModalRoute.of(context);
    if (navigator == null || current == null) {
      return 0;
    }
    const playerRoutes = {'/videoV', '/liveRoom'};
    final nested = routeStackObserver.routesBelowWhile(
      current,
      (route) => playerRoutes.contains(route.settings.name),
    );
    for (final route in nested) {
      navigator.removeRoute(route);
    }
    if (kDebugMode && nested.isNotEmpty) {
      debugPrint('[PiP] Removed ${nested.length} nested video/live routes');
    }
    return nested.length;
  }

  /// 等待布局落定：[isReady] 成立即返回，超时则不再等。
  /// 退出全屏后设备转屏由 OS 异步完成，MediaQuery（isPortrait/尺寸）要再过
  /// 若干帧才更新；此时立即判定可 pop 状态或量取源矩形会拿到全屏时的旧值。
  /// 超时后由调用方按当前状态决定（该拒绝就拒绝）
  ///
  /// 用时间而非帧数设限：转屏耗时与显示刷新率无关，高刷屏上同样的帧数
  /// 只有几分之一的时间，按帧计会提前放弃
  static Future<void> awaitLayoutSettled(
    bool Function() isReady, {
    Duration timeout = const Duration(milliseconds: 600),
  }) async {
    // 至少等一帧：退出全屏的状态变更在下一帧才重新布局，此刻量取的矩形
    // 仍是全屏几何；即使 isReady 立刻为真也要让这一帧过去
    await WidgetsBinding.instance.endOfFrame;
    final stopwatch = Stopwatch()..start();
    while (!isReady() && stopwatch.elapsed < timeout) {
      await WidgetsBinding.instance.endOfFrame;
    }
  }

  static void _setEnteringPipFlag(dynamic controller, bool value) {
    try {
      controller.isEnteringPip = value;
    } catch (_) {}
  }

  static void _setSystemAutoPipEnabled(
    PlPlayerController? plPlayerController,
    bool enabled,
  ) {
    // 1. 基础条件判断
    if (!Platform.isAndroid ||
        plPlayerController == null ||
        !plPlayerController.autoPiP ||
        !Pref.enableInAppPipToSystemPip) {
      return;
    }

    if (DeviceUtils.sdkInt >= 31) {
      if (enabled) {
        plPlayerController.enterPip(autoEnter: true);
      } else {
        plPlayerController.disableAutoEnterPip();
      }
    }
  }

  // 释放小窗持有的旧视频页 owner。只能由 stopPip 在清空静态引用前捕获参数后
  // 调用（releaseSavedOwner 标志），避免调用方在 stopPip 之后读取已清空的引用
  // 导致释放静默失效。
  // disposePlayer 语义：owner 页面已离开路由栈（如从列表点开新视频）才允许
  // dispose；owner 仍在栈内（链式进入新视频/直播，稍后会返回恢复）只能暂停——
  // dispose 会消耗 owner 页面持有的 _playerCount 计数，导致后续页面 dispose 时
  // 计数归零、误销毁下层页面正在复用的播放器实例
  static void _releaseSavedVideoOwner({
    required VideoDetailController controller,
    required PlPlayerController? player,
    required bool disposePlayer,
  }) {
    controller
      ..isEnteringPip = false
      ..cancelBlockListener();

    if (player != null) {
      controller.makeHeartBeat();
      if (disposePlayer) {
        videoPlayerServiceHandler?.onVideoDetailDispose(controller.heroTag);
        player.dispose();
      } else {
        player.pause();
      }
    }
  }

  static String _keyPart(Object? value) => value?.toString() ?? '';

  static String? buildVideoContextKey({
    Object? videoType,
    Object? bvid,
    Object? cid,
    Object? epId,
    Object? seasonId,
  }) {
    if (bvid == null &&
        cid == null &&
        epId == null &&
        seasonId == null &&
        videoType == null) {
      return null;
    }
    return [
      _keyPart(videoType),
      _keyPart(bvid),
      _keyPart(cid),
      _keyPart(epId),
      _keyPart(seasonId),
    ].join('|');
  }

  static String? contextKeyFromArgs(Map? args) {
    if (args == null) {
      return null;
    }
    return buildVideoContextKey(
      videoType: args['videoType'],
      bvid: args['bvid'],
      cid: args['cid'],
      epId: args['epId'],
      seasonId: args['seasonId'],
    );
  }

  static String? _contextKeyFromController(dynamic controller) {
    if (controller is! VideoDetailController) {
      return null;
    }
    return buildVideoContextKey(
      videoType: controller.videoType,
      bvid: controller.bvid,
      cid: controller.cid.value,
      epId: controller.epId,
      seasonId: controller.seasonId,
    );
  }

  static void startPip({
    required BuildContext context,
    required PlPlayerController plPlayerController,
    required Widget Function(bool isNative, double width, double height)
    videoPlayerBuilder,
    VoidCallback? onClose,
    VoidCallback? onTapToReturn,
    dynamic controller,
    Map<String, dynamic>? additionalControllers,
    Rect? sourceRect,
  }) {
    if (isInPipMode) {
      return;
    }

    isInPipMode = true;
    // 收起动画:从页面播放器矩形缩至小窗;sourceRect 为空(量取失败的
    // 兜底路径)时直接以活跃态出现
    transition.beginEnter(sourceRect: sourceRect);
    isVertical = false;
    if (controller is VideoDetailController) {
      isVertical = controller.isVertical.value;
    }

    _onCloseCallback = onClose;
    _onTapToReturnCallback = onTapToReturn;
    _savedController = controller;
    _savedPlayerController = plPlayerController;
    _savedVideoContextKey = _contextKeyFromController(controller);
    if (additionalControllers != null) {
      _savedControllers.addAll(additionalControllers);
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => PipWidget(
        videoPlayerBuilder: videoPlayerBuilder,
        onClose: () {
          stopPip(callOnClose: true, immediate: true);
        },
        onTapToReturn: () {
          // 归位相位启动:窗口保持显示并飞向页面,导航由回调负责。
          // 回调不清空——超时回退活跃态后仍可再次展开或关闭,
          // 引用统一由握手完成后的 _finalizeRestore(stopPip)清理
          if (!transition.beginRestore()) {
            return;
          }
          _onTapToReturnCallback?.call();
        },
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final overlayContext = Get.overlayContext ?? context;
        Overlay.of(overlayContext).insert(_overlayEntry!);

        // 允许应用内小窗继续使用 Auto-PiP 手势
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!isInPipMode) return;
          _setSystemAutoPipEnabled(plPlayerController, true);
        });
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error inserting pip overlay: $e');
        }
        _setSystemAutoPipEnabled(plPlayerController, false);
        isInPipMode = false;
        transition.reset();
        _overlayEntry = null;
        _savedController = null;
        _savedPlayerController = null;
        _savedVideoContextKey = null;
        _savedControllers.clear();
      }
    });
  }

  static T? getSavedController<T>() => _savedController as T?;

  static T? getAdditionalController<T>(String key) =>
      _savedControllers[key] as T?;

  static void stopPip({
    bool callOnClose = true,
    bool immediate = false,
    bool resetState = true,
    String? targetContextKey,
    bool releaseSavedOwner = false,
    bool disposeSavedOwnerPlayer = true,
  }) {
    if (!isInPipMode && _overlayEntry == null) {
      return;
    }

    final bool shouldResetState = targetContextKey == null
        ? resetState
        : targetContextKey != _savedVideoContextKey;

    if (kDebugMode) {
      debugPrint(
        '[PiP] Stopping PiP mode (immediate: $immediate, callOnClose: $callOnClose, shouldResetState: $shouldResetState, targetContextKey: $targetContextKey, savedContextKey: $_savedVideoContextKey)',
      );
    }

    isInPipMode = false;
    // 瞬时关闭(X 关闭已在窗体侧播完淡出、被其他视频抢占、握手 finalize 等)
    // 一律复位相位机;若页面此后才上报 attach,协调器会立即回调防止其
    // 停留在透明占位
    transition.reset();
    // isNativePip 是 Rx 变量，不能在 build 阶段（如 initState）同步修改，
    // 否则会触发 Obx rebuild 导致 "setState during build" 错误。
    // 延迟到当前帧结束后再更新。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isNativePip = false;
    });

    final closeCallback = callOnClose ? _onCloseCallback : null;
    final playerController = _savedPlayerController;
    // 静态引用即将被清空，释放 owner 所需的引用必须在此捕获
    final ownerToRelease = releaseSavedOwner ? _savedController : null;
    _onCloseCallback = null;
    _onTapToReturnCallback = null;

    // 清理控制器缓存，防止内存泄漏和状态污染
    if (kDebugMode &&
        (_savedController != null || _savedControllers.isNotEmpty)) {
      debugPrint(
        '[PiP] Clearing cached controllers, resetState: $shouldResetState, targetContextKey: $targetContextKey, savedContextKey: $_savedVideoContextKey',
      );
    }

    // 旧 controller 仍在路由栈内时，不能完整 onClose：
    // TabController/ScrollController 仍会被旧页面再次使用。
    // 若 controller 已由 GetX 关闭，页面已离栈，此时再执行完整清理。
    if (shouldResetState && _savedController is VideoDetailController) {
      final ctrl = _savedController as VideoDetailController;
      ctrl.isEnteringPip = false;
      ctrl.cancelBlockListener();
      if (ctrl.isClosed) {}
      for (final controller in _savedControllers.values) {
        _setEnteringPipFlag(controller, false);
      }
    }

    _savedController = null;
    _savedPlayerController = null;
    _savedVideoContextKey = null;
    _savedControllers.clear();

    final overlayToRemove = _overlayEntry;
    _overlayEntry = null;

    // 小窗结束后，仅在视频/直播详情页中保留系统 Auto-PiP，其余场景立即关闭防止误触发
    final currentRoute = Get.currentRoute;
    final keepAutoPip = isVideoLikeRoute(currentRoute);
    _setSystemAutoPipEnabled(playerController, keepAutoPip);

    // 如果需要清理，先停止播放器
    if (callOnClose && playerController != null) {
      try {
        // 停止播放但不 dispose，因为其他地方可能还在使用
        playerController.pause();
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error pausing player: $e');
        }
      }
    }

    void removeAndCallback() {
      try {
        overlayToRemove?.remove();
        if (kDebugMode) {
          debugPrint('[PiP] Overlay entry removed successfully');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error removing pip overlay: $e');
        }
      }
      // overlay 已移除，此时 dispose 播放器不会留下持有失效纹理的窗口
      if (ownerToRelease is VideoDetailController) {
        _releaseSavedVideoOwner(
          controller: ownerToRelease,
          player: playerController,
          disposePlayer: disposeSavedOwnerPlayer,
        );
      }
      closeCallback?.call();
    }

    if (immediate) {
      removeAndCallback();
    } else {
      Future.delayed(const Duration(milliseconds: 300), removeAndCallback);
    }
  }
}

class PipWidget extends StatefulWidget {
  final Widget Function(bool isNative, double width, double height)
  videoPlayerBuilder;
  final VoidCallback onClose;
  final VoidCallback onTapToReturn;

  const PipWidget({
    super.key,
    required this.videoPlayerBuilder,
    required this.onClose,
    required this.onTapToReturn,
  });

  @override
  State<PipWidget> createState() => _PipWidgetState();
}

class _PipWidgetState extends State<PipWidget>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  double? _left;
  double? _top;
  double _scale = PipWindowMemory.scale;
  double _scaleStart = 1.0; // onScaleStart 时记录的起始 scale,捏合按此累乘
  // 捏合/滚轮中尺寸须与位置同帧生效:位置钳制是瞬时的,尺寸若走 250ms
  // 过渡,边缘处会"位置先瞬移、尺寸后长大"地抽搐
  bool _instantResize = false;
  Timer? _wheelResizeTimer;

  PipTransitionCoordinator get _transition => PipOverlayService.transition;
  PipPhase _lastPhase = PipPhase.hidden;

  // 收起/归位的 Rect 插值进度
  late final AnimationController _phaseCtr = AnimationController(
    vsync: this,
    duration: PipTransitionCoordinator.animDuration,
  )..addStatusListener(_onPhaseAnimStatus);

  // X 关闭的缩小淡出
  late final AnimationController _closeCtr = AnimationController(
    vsync: this,
    duration: PipTransitionCoordinator.closeFadeDuration,
  );

  double _baseLong = 200; // 当前设备档的长边基准(未乘 _scale),build 时更新
  double _baseShort = 112;

  double get _width =>
      (PipOverlayService.isVertical ? _baseShort : _baseLong) * _scale;
  double get _height =>
      (PipOverlayService.isVertical ? _baseLong : _baseShort) * _scale;

  bool _showControls = true;
  Timer? _hideTimer;
  // 桌面端:鼠标悬停时控制栏保持显示,移出即隐藏
  bool _hovering = false;

  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _transition.addListener(_onPhaseChanged);
    _lastPhase = _transition.phase;
    if (_lastPhase == PipPhase.entering) {
      _phaseCtr.forward(from: 0);
    } else {
      _phaseCtr.value = 1;
    }
    // 桌面端控制栏初始隐藏,由 hover 显示
    if (PlatformUtils.isDesktop) {
      _showControls = false;
    } else {
      _startHideTimer();
    }
  }

  void _onPhaseChanged() {
    final phase = _transition.phase;
    if (phase != _lastPhase) {
      _lastPhase = phase;
      switch (phase) {
        case PipPhase.entering:
        case PipPhase.restoring:
          _phaseCtr.forward(from: 0);
        case PipPhase.active:
          // 入场完成后的常规落位;或超时回退——窗口直接回到小窗矩形
          _phaseCtr
            ..stop()
            ..value = 1;
        case PipPhase.hidden:
          _phaseCtr.stop();
      }
    }
    if (mounted) setState(() {});
  }

  void _onPhaseAnimStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    switch (_transition.phase) {
      case PipPhase.entering:
        _transition.markEnterDone();
      case PipPhase.restoring:
        _transition.markRestoreAnimationDone();
      case PipPhase.active:
      case PipPhase.hidden:
        break;
    }
  }

  // X 关闭:先播缩小淡出,动画完成后才真正走 stopPip;
  // 期间窗口不可交互。外部若提前移除 overlay(如被抢占),widget 已
  // dispose,then 不会触发
  void _beginClose() {
    if (_isClosing) return;
    _hideTimer?.cancel();
    setState(() => _isClosing = true);
    _closeCtr.forward(from: 0).then((_) {
      if (mounted) widget.onClose();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _transition.removeListener(_onPhaseChanged);
    _phaseCtr
      ..removeStatusListener(_onPhaseAnimStatus)
      ..dispose();
    _closeCtr.dispose();
    _hideTimer?.cancel();
    _wheelResizeTimer?.cancel();
    if (PipOverlayService._overlayEntry != null) {
      PipOverlayService._onCloseCallback = null;
      PipOverlayService._onTapToReturnCallback = null;
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!PipOverlayService.isInPipMode) return;

    // 此处无需重复处理，状态同步由PlPlayerController中的onPipChanged消息统一管理
    // 而且在Controller中已加入了退出延迟，确保系统转场动画完成后再切换布局。
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    // 悬停中不自动隐藏
    if (_hovering) return;
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _resetHideTimer() {
    if (_showControls) {
      _startHideTimer();
    }
  }

  void _onHoverEnter(PointerEnterEvent event) {
    // 收起/归位动画期间 IgnorePointer 已屏蔽事件,此守卫防异常时序
    if (_transition.phase != PipPhase.active || _isClosing) return;
    _hideTimer?.cancel();
    setState(() {
      _hovering = true;
      _showControls = true;
    });
  }

  void _onHoverExit(PointerExitEvent event) {
    _hideTimer?.cancel();
    setState(() {
      _hovering = false;
      _showControls = false;
    });
  }

  void _onTap() {
    // 悬停中由 hover 驱动;触摸/笔等无 hover 场景保留点击切换兜底
    if (_hovering) return;
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  void _onDoubleTap() {
    final screenSize = MediaQuery.of(context).size;
    // 档位目标同样钳入连续区间(上限按方向分流:横屏 0.95×短边;竖屏
    // factor×min(屏高,屏宽×宽高比),竖屏屏 0.8 / 横屏屏 0.95):窄屏/横屏
    // 屏幕上 2.0 档由此封顶不再溢出。钳后与当前值几乎重合(已停在封顶
    // 档)则跳回 1.0 档,保证循环不卡死
    double next = _scale < 1.1 ? 1.5 : (_scale < 1.6 ? 2.0 : 1.0);
    next = PipWindowMemory.clampScaleContinuous(
      next,
      screenSize,
      isVertical: PipOverlayService.isVertical,
    );
    if ((next - _scale).abs() < 0.05) {
      next = PipWindowMemory.clampScaleContinuous(
        1.0,
        screenSize,
        isVertical: PipOverlayService.isVertical,
      );
    }
    // 双击档位切换:按缩放前窗口距屏幕四边的距离,选较近的一对边作为锚定,
    // 缩放后保持该边缘到屏幕边缘的距离不变。
    // 否则贴右窗口放大→缩小会"跑到左边":放大时钳制把 _left 顶到
    // screenW-w2(贴右);缩小时 _left=screenW-w2 落在合法区间内不变,
    // 但右边缘变成 screenW-w2+w3 < screenW,视觉上窗口向左缩。
    final oldLeft = _left ?? 0.0;
    final oldTop = _top ?? 0.0;
    final oldWidth = _width;
    final oldHeight = _height;
    final distLeft = oldLeft;
    final distRight = screenSize.width - oldLeft - oldWidth;
    final distTop = oldTop;
    final distBottom = screenSize.height - oldTop - oldHeight;

    setState(() {
      _scale = next;

      // 水平:距左≤距右则左锚定(_left 不变),否则右锚定(右边缘到屏距离不变)
      final double newLeft = distLeft <= distRight
          ? oldLeft
          : screenSize.width - distRight - _width;
      // 垂直:距上≤距下则上锚定(_top 不变),否则下锚定(下边缘到屏距离不变)
      final double newTop = distTop <= distBottom
          ? oldTop
          : screenSize.height - distBottom - _height;
      // 兜底钳制,防极端窗口/旋转后越界
      _left = newLeft
          .clamp(0.0, max(0.0, screenSize.width - _width))
          .toDouble();
      _top = newTop
          .clamp(0.0, max(0.0, screenSize.height - _height))
          .toDouble();
    });
    PipWindowMemory.scale = _scale;
    PipWindowMemory.position = Offset(_left ?? 0, _top ?? 0);
    _startHideTimer();
  }

  // 捏合/滚轮:绕小窗中心把 _scale 设为目标值(钳入连续区间),再钳位置
  void _applyScaleAroundCenter(double targetScale, Size screenSize) {
    final centerX = _left! + _width / 2;
    final centerY = _top! + _height / 2;
    _scale = PipWindowMemory.clampScaleContinuous(
      targetScale,
      screenSize,
      isVertical: PipOverlayService.isVertical,
    );
    _left = centerX - _width / 2; // _width 已反映新 _scale
    _top = centerY - _height / 2;
    _clampPositionInScreen(screenSize);
  }

  void _clampPositionInScreen(Size screenSize) {
    _left = _left!.clamp(0.0, max(0.0, screenSize.width - _width)).toDouble();
    _top = _top!.clamp(0.0, max(0.0, screenSize.height - _height)).toDouble();
  }

  @override
  void didChangeMetrics() {
    // 屏幕旋转 / 桌面窗口尺寸变化：触发重建，让 build 按新尺寸把小窗位置
    // 钳回界内。仅重建、不改 _left/_top 意图值，窗口恢复时能自动回原位。
    // 系统 PiP 期间尺寸变化来自 PiP 窗口本身，build 会整段跳过几何计算。
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final screenSize = MediaQuery.of(context).size;
      final bool isNative = PipOverlayService.isNativePip;

      // 系统 PiP 模式下直接铺满窗口，且不执行任何自定义尺寸/位置计算：此时
      // MediaQuery 给出的是系统 PiP 窗口自身的尺寸（非整屏），若照常钳制会把
      // 缩放下限强加给小窗并写回会话记忆，退出 PiP 后小窗就永久停在最小档。
      // 收起/归位动画同时让位（相位仍由协调器推进，回到应用内后自然衔接）。
      if (isNative) {
        return Positioned.fill(
          child: ColoredBox(
            color: Colors.black,
            child: AbsorbPointer(
              child: widget.videoPlayerBuilder(
                true,
                screenSize.width,
                screenSize.height,
              ),
            ),
          ),
        );
      }

      // 按当前窗口短边分档:手机维持现状,平板/桌面放大
      _baseLong = PipWindowMemory.basePipLong(screenSize);
      _baseShort = PipWindowMemory.basePipShort(screenSize);
      // 旋转/窗口尺寸变化后按新屏幕重新钳制 scale:竖屏屏拉大后转横屏时
      // 上限变小,超出即自动缩小;同时回写会话记忆,恢复时保持缩小后的值
      _scale = PipWindowMemory.clampScaleContinuous(
        _scale,
        screenSize,
        isVertical: PipOverlayService.isVertical,
      );
      PipWindowMemory.scale = _scale;
      _left ??= (PipWindowMemory.position?.dx ?? screenSize.width - _width - 16)
          .clamp(0.0, max(0.0, screenSize.width - _width))
          .toDouble();
      _top ??= (PipWindowMemory.position?.dy ?? screenSize.height - _height - 100)
          .clamp(0.0, max(0.0, screenSize.height - _height))
          .toDouble();

      return AnimatedBuilder(
        animation: Listenable.merge([_phaseCtr, _closeCtr, _transition]),
        builder: (context, _) {
          final phase = _transition.phase;
          // 显示位置按当前屏幕钳回界内；不回写 _left/_top，窗口恢复时自动归位
          final dispLeft = _left!
              .clamp(0.0, max(0.0, screenSize.width - _width))
              .toDouble();
          final dispTop = _top!
              .clamp(0.0, max(0.0, screenSize.height - _height))
              .toDouble();
          final miniRect = Rect.fromLTWH(dispLeft, dispTop, _width, _height);
          final progress = PipTransitionCoordinator.animCurve.transform(
            _phaseCtr.value,
          );
          final rect = _transition.resolveRect(
            miniRect: miniRect,
            progress: progress,
          );
          final radius = _transition.resolveRadius(base: 8, progress: progress);
          final bool inTransition =
              phase == PipPhase.entering || phase == PipPhase.restoring;
          final bool interactive = phase == PipPhase.active && !_isClosing;

          // 控件触控目标随窗口短边自适应
          final double shortSide = min(_width, _height);
          final double topControl = (shortSide * 0.38)
              .clamp(28.0, 37.0)
              .toDouble();
          final double bottomControl = (shortSide - 2 - topControl - 4)
              .clamp(40.0, 48.0)
              .toDouble();

          // AnimatedPositioned 与下方 AnimatedContainer 共用相同的
          // duration/curve 条件:双击档位切换时位置与尺寸同步 250ms 过渡,
          // 否则右边缘双击放大时"位置先瞬移、尺寸后长大"地抽搐
          // (左边缘因 _left 钳制后仍为 0 不受影响,故仅右侧显现)。
          // inTransition(收起/归位)与 _instantResize(捏合/滚轮)期间归零,
          // 与 AnimatedContainer 行为一致。
          return AnimatedPositioned(
            duration: inTransition || _instantResize
                ? Duration.zero
                : const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            left: rect.left,
            top: rect.top,
            child: IgnorePointer(
              // 收起中/归位中/关闭淡出中不可交互
              ignoring: !interactive,
              child: Listener(
                // 桌面滚轮缩放:绕中心乘性 ±10%/格,同捏合连续区间
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    _instantResize = true;
                    _wheelResizeTimer?.cancel();
                    _wheelResizeTimer = Timer(
                      const Duration(milliseconds: 300),
                      () {
                        if (mounted) {
                          setState(() => _instantResize = false);
                        }
                      },
                    );
                    setState(() {
                      final factor = event.scrollDelta.dy < 0 ? 1.1 : 1 / 1.1;
                      _applyScaleAroundCenter(_scale * factor, screenSize);
                    });
                    PipWindowMemory.scale = _scale;
                    PipWindowMemory.position = Offset(_left!, _top!);
                    if (_showControls) _startHideTimer();
                  }
                },
                child: MouseRegion(
                    onEnter: _onHoverEnter,
                    onExit: _onHoverExit,
                    child: FadeTransition(
                      opacity: _closeCtr.drive(Tween(begin: 1.0, end: 0.0)),
                      child: ScaleTransition(
                        scale: _closeCtr.drive(
                          Tween(
                            begin: 1.0,
                            end: 0.85,
                          ).chain(CurveTween(curve: Curves.easeOut)),
                        ),
                        child: AnimatedContainer(
                          // 过渡中矩形逐帧由协调器插值给出;捏合/滚轮中尺寸须与
                          // 位置同帧生效(见 _instantResize)。两者时长归零,
                          // 仅双击档位切换保留 250ms 尺寸过渡
                          duration: inTransition || _instantResize
                              ? Duration.zero
                              : const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          width: rect.width,
                          height: rect.height,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(radius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(radius),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: _onTap,
                                    onDoubleTap: _onDoubleTap,
                                    // 仅视频区域处理小窗移动/缩放，避免与控制按钮竞争手势。
                                    onScaleStart: (_) {
                                      _hideTimer?.cancel();
                                      _scaleStart = _scale;
                                      _instantResize = true;
                                    },
                                    onScaleUpdate: (details) {
                                      setState(() {
                                        // 平移:单指拖动 / 双指整体移动(focalPointDelta)
                                        _left = _left! + details.focalPointDelta.dx;
                                        _top = _top! + details.focalPointDelta.dy;
                                        // 缩放:双指时 scale≠1;单指恒为 1,仅钳位置
                                        if (details.scale != 1.0) {
                                          _applyScaleAroundCenter(
                                            _scaleStart * details.scale,
                                            screenSize,
                                          );
                                        } else {
                                          _clampPositionInScreen(screenSize);
                                        }
                                      });
                                      PipWindowMemory.position =
                                          Offset(_left!, _top!);
                                      PipWindowMemory.scale = _scale;
                                    },
                                    onScaleEnd: (_) {
                                      setState(() => _instantResize = false);
                                      if (_showControls) {
                                        _startHideTimer();
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: widget.videoPlayerBuilder(
                                        false,
                                        rect.width,
                                        rect.height,
                                      ),
                                    ),
                                  ),
                                ),
                                if (interactive && _showControls) ...[
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: Container(
                                        color: Colors.black.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 左上角关闭：先播缩小淡出再 stopPip。
                                  // 次要按钮触控目标仅比图标大一圈,
                                  // 同系统 PiP 顶部按钮,降低误触
                                  Positioned(
                                    top: 2,
                                    left: 4,
                                    child: PipControlButton(
                                      targetSize: topControl,
                                      onTap: _beginClose,
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 21,
                                      ),
                                    ),
                                  ),
                                  // 右上角还原：归位动画启动，窗口保持显示飞向页面。
                                  // 次要按钮,触控目标仅比图标大一圈
                                  Positioned(
                                    top: 2,
                                    right: 4,
                                    child: PipControlButton(
                                      targetSize: topControl,
                                      onTap: () {
                                        _hideTimer?.cancel();
                                        widget.onTapToReturn();
                                      },
                                      icon: const Icon(
                                        Icons.open_in_full,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                    ),
                                  ),
                                  // 底部控制栏:主操作按钮触控目标自适应(正常档 48,
                                  // 同系统 PiP 的 pip_action_size,图标居中四周留白;
                                  // 窄窗收缩见 bottomControl),间距 8dp
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 4,
                                    child: Row(
                                      children: [
                                        // 后退10秒
                                        Expanded(
                                          child: Center(
                                            child: PipControlButton(
                                              targetSize: bottomControl,
                                              onTap: () {
                                                _resetHideTimer();
                                                final controller =
                                                    PipOverlayService
                                                        .getSavedController<
                                                          VideoDetailController
                                                        >();
                                                final plController =
                                                    controller
                                                        ?.plPlayerController;
                                                if (plController != null) {
                                                  final current = Duration(
                                                    seconds: plController
                                                        .position.value,
                                                  );
                                                  plController.seekTo(
                                                    current -
                                                        const Duration(
                                                          seconds: 10,
                                                        ),
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.replay_10,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // 播放/暂停
                                        Expanded(
                                          child: Center(
                                            child: Obx(() {
                                              final controller =
                                                  PipOverlayService
                                                      .getSavedController<
                                                        VideoDetailController
                                                      >();
                                              final plController =
                                                  controller
                                                      ?.plPlayerController;
                                              final isPlaying =
                                                  plController?.playerStatus ==
                                                      PlayerStatus.playing;
                                              return PipControlButton(
                                                targetSize: bottomControl,
                                                onTap: () {
                                                  _resetHideTimer();
                                                  if (isPlaying) {
                                                    plController?.pause();
                                                  } else {
                                                    plController?.play();
                                                  }
                                                },
                                                icon: Icon(
                                                  isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // 前进10秒
                                        Expanded(
                                          child: Center(
                                            child: PipControlButton(
                                              targetSize: bottomControl,
                                              onTap: () {
                                                _resetHideTimer();
                                                final controller =
                                                    PipOverlayService
                                                        .getSavedController<
                                                          VideoDetailController
                                                        >();
                                                final plController =
                                                    controller
                                                        ?.plPlayerController;
                                                if (plController != null) {
                                                  final current = Duration(
                                                    seconds: plController
                                                        .position.value,
                                                  );
                                                  plController.seekTo(
                                                    current +
                                                        const Duration(
                                                          seconds: 10,
                                                        ),
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.forward_10,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ),
            ),
          );
        },
      );
    });
  }
}
