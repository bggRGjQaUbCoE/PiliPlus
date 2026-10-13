import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

/// iOS 风格的屏幕左边缘右滑返回手势。
///
/// 背景：GetX 的 [GetPageRoute] 在 iOS 上虽然用了类 Cupertino 的转场动画，
/// 但没有接入 Flutter 底层的返回手势探测器，导致右滑返回手势无效。
/// 这个组件在应用顶层补上左边缘右滑手势，只做手势相关处理，不碰其他功能。
///
/// 生效条件（缺一不可，避免误触和冲突）：
/// * 触摸点落在屏幕左边缘判定区内（与 iOS 系统手势一致）；
/// * 当前路由栈可返回（首页等不可返回时不参与手势竞技，
///   不会抢走抽屉等边缘手势）。
class IosBackGesture extends StatelessWidget {
  const IosBackGesture({
    super.key,
    required this.onBack,
    required this.child,
  });

  final VoidCallback onBack;
  final Widget child;

  /// 左边缘判定区宽度（逻辑像素）
  static const double edgeWidth = 28;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.translucent,
      gestures: <Type, GestureRecognizerFactory>{
        _EdgeBackGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<_EdgeBackGestureRecognizer>(
          () => _EdgeBackGestureRecognizer(),
          (_EdgeBackGestureRecognizer instance) {
            instance.onTriggerBack = onBack;
          },
        ),
      },
      child: child,
    );
  }
}

/// 只在左边缘生效的水平拖拽识别器。
///
/// 通过重写 [addAllowedPointer]，让非边缘触摸完全不参与手势竞技，
/// 从而零干扰页面内部的轮播、标签页等水平手势。
class _EdgeBackGestureRecognizer extends HorizontalDragGestureRecognizer {
  _EdgeBackGestureRecognizer()
      : super(supportedDevices: <PointerDeviceKind>{PointerDeviceKind.touch}) {
    onStart = (_) => _dx = 0;
    onUpdate = (DragUpdateDetails details) => _dx += details.delta.dx;
    onEnd = _handleEnd;
    onCancel = () => _dx = 0;
  }

  VoidCallback? onTriggerBack;

  double _dx = 0;

  /// 触发返回所需的最小水平位移（逻辑像素）
  static const double _minDistance = 48;

  /// 快速甩动时的最小位移和速度
  static const double _minFlingDistance = 24;
  static const double _minFlingVelocity = 500;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    if (event.position.dx <= IosBackGesture.edgeWidth &&
        (Get.key.currentState?.canPop() ?? false)) {
      super.addAllowedPointer(event);
    }
  }

  void _handleEnd(DragEndDetails details) {
    final double velocity = details.primaryVelocity ?? 0;
    if (_dx >= _minDistance ||
        (velocity >= _minFlingVelocity && _dx >= _minFlingDistance)) {
      onTriggerBack?.call();
    }
    _dx = 0;
  }
}
