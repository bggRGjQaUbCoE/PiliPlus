import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart';
import 'package:PiliPlus/models/common/dynamic/dyn_swipe_sensitivity.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:material_ui/material_ui.dart';

/// 动态页横向滑动用的手势识别器工厂
///
/// 官方 bilibili 的左右滑动比 PiliPlus 默认更「跟手」：抬指位移很小就能拖动，
/// 且对斜向手势更宽容。这里通过 [sensitivity] 控制这两个维度。
HorizontalDragGestureRecognizer dynamicHorizontalDragRecognizer(
  DynSwipeSensitivity sensitivity,
) {
  return CustomHorizontalDragGestureRecognizer(
    touchSlop: deviceTouchSlop + sensitivity.extraSlop,
    angleRatio: sensitivity.angleRatio,
  );
}

Widget tabBarView({
  required List<Widget> children,
  TabController? controller,
  HitTestBehavior hitTestBehavior = .opaque,
  HorizontalDragGestureRecognizer Function()? recognizer,
  ScrollPhysics? physics,
}) => TabBarView(
  controller: controller,
  physics: physics ?? tabBarScrollPhysics,
  hitTestBehavior: hitTestBehavior,
  horizontalDragGestureRecognizer:
      recognizer ?? CustomHorizontalDragGestureRecognizer.new,
  children: children,
);

/// 与 [tabBarView] 一致的横向分页容器，用于逐 UP 浏览
///
/// 用 builder 懒加载：只有可见页会创建，避免一次发起几十个请求。
Widget dynPageView({
  required PageController controller,
  required int itemCount,
  required IndexedWidgetBuilder itemBuilder,
  required DynSwipeSensitivity sensitivity,
  ValueChanged<int>? onPageChanged,
  ScrollPhysics physics = tabBarScrollPhysics,
}) => PageView.builder(
  controller: controller,
  physics: PageScrollPhysics().applyTo(physics),
  onPageChanged: onPageChanged,
  horizontalDragGestureRecognizer: () =>
      dynamicHorizontalDragRecognizer(sensitivity),
  itemCount: itemCount,
  itemBuilder: itemBuilder,
);

SpringDescription kSpringDescription = _customSpringDescription();

SpringDescription _customSpringDescription() {
  final List<double> springDescription = Pref.springDescription;
  return SpringDescription(
    mass: springDescription[0],
    stiffness: springDescription[1],
    damping: springDescription[2],
  );
}

const tabBarScrollPhysics = _TabBarViewScrollPhysics();

class _TabBarViewScrollPhysics extends ClampingScrollPhysics {
  const _TabBarViewScrollPhysics({super.parent});

  @override
  _TabBarViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _TabBarViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => kSpringDescription;
}

mixin ReloadMixin {
  late bool reload = false;
}

class ReloadScrollPhysics extends AlwaysScrollableScrollPhysics {
  const ReloadScrollPhysics({super.parent, required this.controller});

  final ReloadMixin controller;

  @override
  ReloadScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ReloadScrollPhysics(
      parent: buildParent(ancestor),
      controller: controller,
    );
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    if (controller.reload) {
      controller.reload = false;
      return 0;
    }
    return super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );
  }
}

final platformClampingPhysics = PlatformUtils.isDarwin
    ? const BouncingScrollPhysicsExt()
    : const ClampingScrollPhysics();

final platformAlwaysClampingPhysics = PlatformUtils.isDarwin
    ? const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysicsExt())
    : const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics());

class BouncingScrollPhysicsExt extends BouncingScrollPhysics
    with ClampingBoundaryMixin {
  const BouncingScrollPhysicsExt({super.parent});

  @override
  BouncingScrollPhysicsExt applyTo(ScrollPhysics? ancestor) {
    return BouncingScrollPhysicsExt(parent: buildParent(ancestor));
  }
}

/// [ClampingScrollPhysics.applyBoundaryConditions]
mixin ClampingBoundaryMixin on ScrollPhysics {
  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      // Underscroll.
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      // Overscroll.
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      // Hit top edge.
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      // Hit bottom edge.
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }
}
