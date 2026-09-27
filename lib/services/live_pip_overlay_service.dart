import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' show max, min;

import 'package:PiliPlus/common/widgets/pip_control_button.dart';
import 'package:PiliPlus/common/widgets/pip_mini_video_content.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/services/pip_transition_coordinator.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart'
    show PointerEnterEvent, PointerExitEvent, PointerScrollEvent;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LivePipOverlayService {
  static OverlayEntry? _overlayEntry;
  static bool _isInPipMode = false;
  static bool isVertical = false;
  static final RxBool _isNativePip = false.obs;
  static bool get isNativePip => _isNativePip.value;
  static set isNativePip(bool value) => _isNativePip.value = value;
  static String? _currentLiveHeroTag;
  static int? _currentRoomId;

  /// 直播小窗过渡动画协调器(与视频小窗各自独立)
  static final PipTransitionCoordinator transition = PipTransitionCoordinator()
    ..onRestoreFinished = _finalizeRestore;

  // 恢复握手完成:执行与旧路径相同的非销毁式关闭,只是从"恢复页 initState
  // 瞬时执行"推迟到了此刻
  static void _finalizeRestore() {
    stopLivePip(callOnClose: false, immediate: true);
  }

  static VoidCallback? _onCloseCallback;
  static VoidCallback? _onReturnCallback;

  static String? get currentHeroTag => _currentLiveHeroTag;
  static int? get currentRoomId => _currentRoomId;

  static void onReturn() {
    final callback = _onReturnCallback;
    _onCloseCallback = null;
    _onReturnCallback = null;
    callback?.call();
  }

  // 保存控制器引用，防止被 GC
  static dynamic _savedController;
  static PlPlayerController? _savedPlayerController;

  static bool _isVideoLikeRoute(String route) {
    return route.startsWith('/video') || route.startsWith('/liveRoom');
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

  static bool get isInPipMode => _isInPipMode;

  static T? getSavedController<T>() => _savedController as T?;

  /// 退休被遗弃的旧直播 controller：其 onClose 在进小窗时因 isInPipMode
  /// 跳过了清理，路由注销后无人再触发，弹幕 WS 流、开播计时器与媒体通知
  /// 条目会随每次恢复/接管泄漏。仅在新页面将新建 controller 接管的路径调用；
  /// didPopNext 归位（页面仍在栈内）复用同一实例，不得调用。
  static void cleanupSavedController() {
    final saved = _savedController;
    if (saved is! LiveRoomController) {
      return;
    }
    saved
      ..closeLiveMsg()
      ..cancelLiveTimer()
      ..cancelLikeTimer();
    videoPlayerServiceHandler?.onVideoDetailDispose(saved.heroTag);
  }

  static void startLivePip({
    required BuildContext context,
    required String heroTag,
    required int roomId,
    required PlPlayerController plPlayerController,
    VoidCallback? onClose,
    VoidCallback? onReturn,
    dynamic controller,
    Rect? sourceRect,
  }) {
    if (_isInPipMode) {
      stopLivePip(callOnClose: true);
    }

    _isInPipMode = true;
    // 收起动画:从页面播放器矩形缩至小窗;sourceRect 为空时直接以活跃态出现
    transition.beginEnter(sourceRect: sourceRect);
    isVertical = plPlayerController.isVertical;
    _currentLiveHeroTag = heroTag;
    _currentRoomId = roomId;
    _onCloseCallback = onClose;
    _onReturnCallback = onReturn;
    _savedController = controller;
    _savedPlayerController = plPlayerController;

    _overlayEntry = OverlayEntry(
      builder: (context) => LivePipWidget(
        heroTag: heroTag,
        roomId: roomId,
        plPlayerController: plPlayerController,
        onClose: () {
          stopLivePip(callOnClose: true, immediate: true);
        },
        onReturn: () {
          // 归位相位启动:overlay 保留并飞向页面,导航由回调负责,
          // 引用统一由握手完成后的 _finalizeRestore(stopLivePip)清理
          if (!transition.beginRestore()) {
            return;
          }
          _onReturnCallback?.call();
        },
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final overlayContext = Get.overlayContext ?? context;
        Overlay.of(overlayContext).insert(_overlayEntry!);

        // 允许应用内小窗继续使用 Auto-PiP 手势
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isInPipMode) return;
          _setSystemAutoPipEnabled(plPlayerController, true);
        });
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error inserting live pip overlay: $e');
        }
        SmartDialog.showToast('小窗启动失败: $e');
        _setSystemAutoPipEnabled(plPlayerController, false);

        // 完整清理所有状态
        _isInPipMode = false;
        transition.reset();
        _currentLiveHeroTag = null;
        _currentRoomId = null;
        _overlayEntry = null;
        _savedController = null;
        _savedPlayerController = null;

        // 通知调用者失败
        onClose?.call();
      }
    });
  }

  static void stopLivePip({bool callOnClose = true, bool immediate = false}) {
    if (!_isInPipMode && _overlayEntry == null) {
      return;
    }

    _isInPipMode = false;
    // 瞬时关闭/握手 finalize 一律复位相位机;若页面此后才上报 attach,
    // 协调器会立即回调防止其停留在透明占位
    transition.reset();
    // isNativePip 是 Rx 变量，不能在 build 阶段（如 initState）同步修改，
    // 否则会触发 Obx rebuild 导致 "setState during build" 错误
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isNativePip = false;
    });
    _currentLiveHeroTag = null;
    _currentRoomId = null;

    final closeCallback = callOnClose ? _onCloseCallback : null;
    final playerController = _savedPlayerController;

    _onCloseCallback = null;
    _onReturnCallback = null;
    _savedController = null;
    _savedPlayerController = null;

    final overlayToRemove = _overlayEntry;
    _overlayEntry = null;

    // 小窗结束后，仅在视频/直播详情页中保留系统 Auto-PiP，其余场景立即关闭防止误触发
    final currentRoute = Get.currentRoute;
    final keepAutoPip = _isVideoLikeRoute(currentRoute);
    _setSystemAutoPipEnabled(playerController, keepAutoPip);

    void removeAndCallback() {
      try {
        overlayToRemove?.remove();
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error removing live pip overlay: $e');
        }
      }
      closeCallback?.call();
    }

    if (immediate) {
      removeAndCallback();
    } else {
      Future.delayed(const Duration(milliseconds: 300), removeAndCallback);
    }

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
  }

  static bool isCurrentLiveRoom(int roomId) {
    return _isInPipMode && _currentRoomId == roomId;
  }
}

class LivePipWidget extends StatefulWidget {
  final String heroTag;
  final int roomId;
  final PlPlayerController plPlayerController;
  final VoidCallback onClose;
  final VoidCallback onReturn;

  const LivePipWidget({
    super.key,
    required this.heroTag,
    required this.roomId,
    required this.plPlayerController,
    required this.onClose,
    required this.onReturn,
  });

  @override
  State<LivePipWidget> createState() => _LivePipWidgetState();
}

class _LivePipWidgetState extends State<LivePipWidget>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  double? _left;
  double? _top;
  double _scale = PipWindowMemory.scale;
  double _scaleStart = 1.0; // onScaleStart 时记录的起始 scale,捏合按此累乘
  // 捏合/滚轮中尺寸须与位置同帧生效:位置钳制是瞬时的,尺寸若走 250ms
  // 过渡,边缘处会"位置先瞬移、尺寸后长大"地抽搐
  bool _instantResize = false;
  Timer? _wheelResizeTimer;
  double _baseLong = 200; // 当前设备档的长边基准(未乘 _scale),build 时更新
  double _baseShort = 112;
  double get _width =>
      (LivePipOverlayService.isVertical ? _baseShort : _baseLong) * _scale;
  double get _height =>
      (LivePipOverlayService.isVertical ? _baseLong : _baseShort) * _scale;

  bool _showControls = true;
  Timer? _hideTimer;
  // 桌面端:鼠标悬停时控制栏保持显示,移出即隐藏
  bool _hovering = false;
  bool _isClosing = false;
  bool _isRefreshing = false;

  PipTransitionCoordinator get _transition => LivePipOverlayService.transition;
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

  // X 关闭:先播缩小淡出,动画完成后才真正走 stopLivePip
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
    if (LivePipOverlayService._overlayEntry != null) {
      LivePipOverlayService._onCloseCallback = null;
      LivePipOverlayService._onReturnCallback = null;
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!LivePipOverlayService.isInPipMode) return;

    // 此处无需重复处理，由 PlPlayerController 中的 onPipChanged 消息统一处理退出逻辑。
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

  // 刷新:与页面端刷新按钮同源(queryLiveUrl 重新拉流);进行中忽略连点
  Future<void> _onRefresh() async {
    if (_isRefreshing) return;
    _resetHideTimer();
    final controller =
        LivePipOverlayService.getSavedController<LiveRoomController>();
    if (controller == null) return;
    _isRefreshing = true;
    try {
      await controller.queryLiveUrl();
    } finally {
      _isRefreshing = false;
    }
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
      isVertical: LivePipOverlayService.isVertical,
    );
    if ((next - _scale).abs() < 0.05) {
      next = PipWindowMemory.clampScaleContinuous(
        1.0,
        screenSize,
        isVertical: LivePipOverlayService.isVertical,
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
      isVertical: LivePipOverlayService.isVertical,
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
      final bool isNative = LivePipOverlayService.isNativePip;

      // 系统 PiP 模式下直接铺满窗口，且不执行任何自定义尺寸/位置计算：此时
      // MediaQuery 给出的是系统 PiP 窗口自身的尺寸（非整屏），若照常钳制会把
      // 缩放下限强加给小窗并写回会话记忆，退出 PiP 后小窗就永久停在最小档。
      if (isNative) {
        return Positioned.fill(
          child: ColoredBox(
            color: Colors.black,
            child: AbsorbPointer(
              child: PipMiniVideoContent(
                plPlayerController: widget.plPlayerController,
                transition: LivePipOverlayService.transition,
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
        isVertical: LivePipOverlayService.isVertical,
      );
      PipWindowMemory.scale = _scale;

      // 恢复上次摆放位置（会话级记忆）；越界（旋转/窗口尺寸变化）时钳回屏内
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
                                color: Colors.black.withValues(alpha: 0.6),
                                blurRadius: 12,
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
                                      child: PipMiniVideoContent(
                                        plPlayerController:
                                            widget.plPlayerController,
                                        transition:
                                            LivePipOverlayService.transition,
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
                                  // 左上角关闭：先播缩小淡出再 stopLivePip。
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
                                  // 右上角放大/还原：归位动画启动，窗口保持显示飞向页面。
                                  // 次要按钮,触控目标仅比图标大一圈
                                  Positioned(
                                    top: 2,
                                    right: 4,
                                    child: PipControlButton(
                                      targetSize: topControl,
                                      onTap: () {
                                        _hideTimer?.cancel();
                                        widget.onReturn();
                                      },
                                      icon: const Icon(
                                        Icons.open_in_full,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  // 底部控制栏:播放/暂停居中(小窗主键居中的
                                  // 通用心智,与视频小窗键位对齐);左/右等宽
                                  // 单元格使主键精确居中。主操作按钮触控目标
                                  // 自适应(正常档 48,窄窗见 bottomControl)
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 4,
                                    child: Row(
                                      children: [
                                        // 左槽占位,与右侧等宽
                                        const Expanded(
                                          child: SizedBox.shrink(),
                                        ),
                                        // 播放/暂停
                                        Expanded(
                                          child: Center(
                                            child: Obx(() {
                                              final isPlaying =
                                                  widget.plPlayerController
                                                          .playerStatus ==
                                                      PlayerStatus.playing;
                                              return PipControlButton(
                                                targetSize: bottomControl,
                                                onTap: () {
                                                  _resetHideTimer();
                                                  if (isPlaying) {
                                                    widget.plPlayerController
                                                        .pause();
                                                  } else {
                                                    widget.plPlayerController
                                                        .play();
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
                                        // 刷新:直播卡死自救;低频操作降为
                                        // 70% 白(medium-emphasis),平衡主键
                                        // 居中后偏右的视觉重量
                                        Expanded(
                                          child: Center(
                                            child: PipControlButton(
                                              targetSize: bottomControl,
                                              onTap: _onRefresh,
                                              icon: const Icon(
                                                Icons.refresh,
                                                color: Colors.white70,
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
