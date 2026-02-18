import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart'
    show
        ContainerRenderObjectMixin,
        RenderBoxContainerDefaultsMixin,
        MultiChildLayoutParentData;
import 'package:flutter/widgets.dart';

class CustomTooltip extends StatefulWidget {
  const CustomTooltip({
    super.key,
    required this.overlayWidget,
    required this.child,
    required this.indicator,
  });

  final Widget child;
  final ValueGetter<Widget> overlayWidget;
  final ValueGetter<Widget> indicator;

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  final OverlayPortalController _overlayController = OverlayPortalController();

  LongPressGestureRecognizer? _longPressRecognizer;
  LongPressGestureRecognizer get longPressRecognizer =>
      _longPressRecognizer ??= LongPressGestureRecognizer()
        ..onLongPress = _scheduleShowTooltip;

  void _scheduleShowTooltip() {
    _overlayController.show();
  }

  void _scheduleDismissTooltip() {
    _overlayController.hide();
  }

  void _handlePointerDown(PointerDownEvent event) {
    assert(mounted);
    longPressRecognizer.addPointer(event);
  }

  Widget _buildCustomTooltipOverlay(
    BuildContext context,
    OverlayChildLayoutInfo layoutInfo,
  ) {
    final target = MatrixUtils.transformPoint(
      layoutInfo.childPaintTransform,
      layoutInfo.childSize.topCenter(Offset.zero),
    );
    final _CustomTooltipOverlay overlayChild = _CustomTooltipOverlay(
      target: target,
      onDismiss: _scheduleDismissTooltip,
      overlayWidget: widget.overlayWidget,
      indicator: widget.indicator,
    );
    return SelectionContainer.maybeOf(context) == null
        ? overlayChild
        : SelectionContainer.disabled(child: overlayChild);
  }

  @protected
  @override
  void dispose() {
    _longPressRecognizer
      ?..onLongPress = null
      ..dispose();
    _longPressRecognizer = null;
    super.dispose();
  }

  @protected
  @override
  Widget build(BuildContext context) {
    Widget result;
    if (PlatformUtils.isMobile) {
      result = Listener(
        onPointerDown: _handlePointerDown,
        behavior: HitTestBehavior.opaque,
        child: widget.child,
      );
    } else {
      result = MouseRegion(
        cursor: MouseCursor.defer,
        onEnter: (_) => _scheduleShowTooltip(),
        onExit: (_) => _scheduleDismissTooltip(),
        child: widget.child,
      );
    }
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: _overlayController,
      overlayChildBuilder: _buildCustomTooltipOverlay,
      child: result,
    );
  }
}

class _CustomTooltipOverlay extends StatelessWidget {
  const _CustomTooltipOverlay({
    required this.target,
    required this.onDismiss,
    required this.overlayWidget,
    required this.indicator,
  });

  final Offset target;
  final VoidCallback onDismiss;
  final ValueGetter<Widget> overlayWidget;
  final ValueGetter<Widget> indicator;

  @override
  Widget build(BuildContext context) {
    return _ToolTip(
      target: target,
      preferBelow: false,
      onTap: PlatformUtils.isMobile ? onDismiss : null,
      children: [
        indicator(),
        overlayWidget(),
      ],
    );
  }
}

class _ToolTip extends MultiChildRenderObjectWidget {
  const _ToolTip({
    super.children,
    this.onTap,
    required this.target,
    required this.preferBelow,
  });

  final VoidCallback? onTap;
  final Offset target;
  final bool preferBelow;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderToolTip(
      onTap: onTap,
      target: target,
      preferBelow: preferBelow,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderToolTip renderObject) {
    renderObject
      ..onTap = onTap
      ..target = target
      ..preferBelow = preferBelow;
  }
}

class _RenderToolTip extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  _RenderToolTip({
    VoidCallback? onTap,
    required Offset target,
    required bool preferBelow,
  }) : _target = target,
       _preferBelow = preferBelow,
       _hitTestSelf = onTap != null {
    if (onTap != null) {
      _tapGestureRecognizer = TapGestureRecognizer()..onTap = onTap;
    }
  }

  TapGestureRecognizer? _tapGestureRecognizer;

  set onTap(VoidCallback? value) {
    _tapGestureRecognizer?.onTap = value;
  }

  @override
  void dispose() {
    _tapGestureRecognizer
      ?..onTap = null
      ..dispose();
    _tapGestureRecognizer = null;
    super.dispose();
  }

  final bool _hitTestSelf;
  @override
  bool hitTestSelf(Offset position) => _hitTestSelf;

  @override
  void handleEvent(PointerEvent event, HitTestEntry<HitTestTarget> entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer?.addPointer(event);
    }
  }

  Offset _target;
  Offset get target => _target;
  set target(Offset value) {
    if (_target == value) return;
    _target = value;
    markNeedsPaint();
  }

  bool _preferBelow;
  bool get preferBelow => _preferBelow;
  set preferBelow(bool value) {
    if (_preferBelow == value) return;
    _preferBelow = value;
    markNeedsPaint();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.constrain(constraints.biggest);

    final c = BoxConstraints.loose(size);
    RenderBox indicator = firstChild!..layout(c, parentUsesSize: true);
    RenderBox overlay = lastChild!..layout(c, parentUsesSize: true);

    final indicatorSize = indicator.size;
    final overlaySize = overlay.size;

    final indicatorParentData =
        indicator.parentData as MultiChildLayoutParentData;
    final overlayParentData = overlay.parentData as MultiChildLayoutParentData;

    Offset offset = positionDependentBox(
      size: size,
      childSize: overlaySize,
      target: target,
      preferBelow: preferBelow,
    );
    offset = Offset(offset.dx, offset.dy - indicatorSize.height + 1);
    overlayParentData.offset = offset;
    indicatorParentData.offset = Offset(
      target.dx - indicatorSize.width / 2,
      offset.dy + overlaySize.height - 1,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as MultiChildLayoutParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childParentData.nextSibling;
    }
  }
}

class Triangle extends LeafRenderObjectWidget {
  const Triangle({
    super.key,
    required this.color,
    required this.size,
  });

  final Color color;
  final Size size;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTriangle(
      color: color,
      preferredSize: size,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTriangle renderObject,
  ) {
    renderObject
      ..color = color
      ..preferredSize = size;
  }
}

class RenderTriangle extends RenderBox {
  RenderTriangle({
    required Color color,
    required Size preferredSize,
  }) : _color = color,
       _preferredSize = preferredSize;

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  Size _preferredSize;
  set preferredSize(Size value) {
    if (_preferredSize == value) return;
    _preferredSize = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    size = constraints.constrain(_preferredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final size = this.size;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(offset.dx, offset.dy)
      ..lineTo(offset.dx + size.width, offset.dy)
      ..lineTo(offset.dx + size.width / 2, size.height + offset.dy)
      ..close();

    context.canvas.drawPath(path, paint);
  }
}
