import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// 左边缘长按返回手势（与右滑返回互补）。
///
/// 设计：
/// * 判定区：屏幕左边缘 15 逻辑像素（约半个指纹宽，手指一半在屏外）。
/// * 按下后 120ms 无明显移动 → 显示指纹式光圈反馈 + 轻震动。
/// * 继续按住至 800ms 无明显移动 → 触发动作 + 确认震动。
/// * 期间手指移动超过 15px → 取消长按，交给右滑返回处理（动=滑，按=等）。
/// * 非主页：触发返回；主页（不可返回时）：触发刷新。
///
/// 个人使用版本：触发时间写死，不做设置项。
class EdgeLongPressGesture extends StatelessWidget {
  const EdgeLongPressGesture({
    super.key,
    required this.onBack,
    required this.onRefreshHome,
    required this.child,
  });

  final VoidCallback onBack;
  final VoidCallback onRefreshHome;
  final Widget child;

  /// 左边缘判定区宽度（逻辑像素，约半指宽）
  static const double edgeWidth = 15;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.translucent,
      gestures: <Type, GestureRecognizerFactory>{
        _EdgeLongPressRecognizer:
            GestureRecognizerFactoryWithHandlers<_EdgeLongPressRecognizer>(
          () => _EdgeLongPressRecognizer(),
          (_EdgeLongPressRecognizer instance) {
            instance
              ..onTriggerBack = onBack
              ..onTriggerRefresh = onRefreshHome;
          },
        ),
      },
      child: child,
    );
  }
}

/// 左边缘长按识别器。
class _EdgeLongPressRecognizer extends OneSequenceGestureRecognizer {
  _EdgeLongPressRecognizer()
      : super(supportedDevices: <PointerDeviceKind>{PointerDeviceKind.touch});

  VoidCallback? onTriggerBack;
  VoidCallback? onTriggerRefresh;

  @override void didStopTrackingLastPointer(int pointer) { _cancelTimers(); _hideGlow(); _pointer = null; _downPosition = null; } // flutter 3.47新增抽象方法，必须实现
  static const Duration _feedbackDelay = Duration(milliseconds: 120);

  /// 触发动作所需的按住时长
  static const Duration _triggerDelay = Duration(milliseconds: 800);

  /// 取消长按的最大移动距离（逻辑像素）
  static const double _moveSlop = 15;

  int? _pointer;
  Offset? _downPosition;
  Timer? _feedbackTimer;
  Timer? _triggerTimer;
  OverlayEntry? _glowEntry;
  bool _feedbackShown = false;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    if (event.position.dx > EdgeLongPressGesture.edgeWidth) {
      return;
    }
    // 只有可返回、或在主页（可刷新）时参与
    final navigator = Get.key.currentState;
    final canPop = navigator?.canPop() ?? false;
    final isHome = !canPop && _isOnHomeTab();
    if (!canPop && !isHome) {
      return;
    }
    _pointer = event.pointer;
    _downPosition = event.position;
    _feedbackShown = false;
    startTrackingPointer(event.pointer, event.transform);

    _feedbackTimer = Timer(_feedbackDelay, () {
      if (_pointer == null || _feedbackShown) return;
      _feedbackShown = true;
      _showGlow(_downPosition!);
      HapticFeedback.lightImpact();
    });

    _triggerTimer = Timer(_triggerDelay, () {
      if (_pointer == null) return;
      _cancelTimers();
      _hideGlow(animate: false);
      HapticFeedback.mediumImpact();
      _flashGlow(_downPosition!);
      if (canPop) {
        onTriggerBack?.call();
      } else {
        onTriggerRefresh?.call();
      }
      _reset();
    });
  }

  @override
  void handleEvent(PointerEvent event) {
    if (_pointer == null || event.pointer != _pointer) return;
    if (event is PointerMoveEvent && _downPosition != null) {
      final dx = (event.position.dx - _downPosition!.dx).abs();
      final dy = (event.position.dy - _downPosition!.dy).abs();
      if (dx > _moveSlop || dy > _moveSlop) {
        // 手指移动了：取消长按，让右滑手势接管
        _cancelAll();
      }
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _cancelAll();
    }
  }

  bool _isOnHomeTab() {
    // 主页 Tab 时 Get.currentRoute 为 / 或 /home
    final route = Get.currentRoute;
    return route == '/' || route == '/home' || route.isEmpty;
  }

  void _showGlow(Offset position) {
    final overlay = Overlay.maybeOf(Get.context!);
    if (overlay == null) return;
    _glowEntry = OverlayEntry(
      builder: (_) => _PressGlow(position: position),
    );
    overlay.insert(_glowEntry!);
  }

  void _hideGlow({bool animate = true}) {
    _glowEntry?.remove();
    _glowEntry = null;
    _feedbackShown = false;
  }

  void _flashGlow(Offset position) {
    final overlay = Overlay.maybeOf(Get.context!);
    if (overlay == null) return;
    final entry = OverlayEntry(
      builder: (_) => _PressFlash(position: position),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 300), () { if (entry.mounted) entry.remove(); });
  }

  void _cancelTimers() {
    _feedbackTimer?.cancel();
    _triggerTimer?.cancel();
    _feedbackTimer = null;
    _triggerTimer = null;
  }

  void _cancelAll() {
    _cancelTimers();
    _hideGlow();
    _reset();
  }

  void _reset() {
    if (_pointer != null) {
      stopTrackingPointer(_pointer!);
    }
    _pointer = null;
    _downPosition = null;
  }

  @override
  String get debugDescription => 'edge long press';
}

/// 指纹式按压光圈：柔光圆环，按住过程中逐渐变亮。
class _PressGlow extends StatefulWidget {
  const _PressGlow({required this.position});

  final Offset position;

  @override
  State<_PressGlow> createState() => _PressGlowState();
}

class _PressGlowState extends State<_PressGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    // 680ms 内从淡变亮（对应 120ms → 800ms 的按住过程）
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 40,
      top: widget.position.dy - 40,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            final t = _ctrl.value;
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15 + 0.35 * t),
                    blurRadius: 18 + 12 * t,
                    spreadRadius: 2 + 6 * t,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.35 + 0.45 * t),
                  width: 1.5 + t,
                ),
              ),
              child: Center(
                child: Container(
                  width: 28 + 8 * t,
                  height: 28 + 8 * t,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.10 + 0.20 * t),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 触发时的扩散闪光。
class _PressFlash extends StatefulWidget {
  const _PressFlash({required this.position});

  final Offset position;

  @override
  State<_PressFlash> createState() => _PressFlashState();
}

class _PressFlashState extends State<_PressFlash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 60,
      top: widget.position.dy - 60,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            final t = _ctrl.value;
            return Opacity(
              opacity: 1 - t,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 2,
                  ),
                ),
                transform: Matrix4.identity()..scale(0.6 + 0.8 * t),
              ),
            );
          },
        ),
      ),
    );
  }
}
