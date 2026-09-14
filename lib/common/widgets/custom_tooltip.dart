import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/gestures.dart'
    show
        TapGestureRecognizer,
        HitTestTarget,
        LongPressGestureRecognizer,
        HitTestEntry;
import 'package:flutter/rendering.dart'
    show
        ContainerRenderObjectMixin,
        RenderBoxContainerDefaultsMixin,
        MultiChildLayoutParentData,
        BoxHitTestResult,
        BoxHitTestEntry;
import 'package:flutter/widgets.dart';

// ignore: camel_case_types
enum TriggerMode_ { longPress, tap, mouse }

class CustomTooltip extends StatefulWidget {
  const CustomTooltip({
    super.key,
    this.jumpUrl,
    required this.child,
    required this.indicator,
    required this.triggerMode,
    required this.overlayWidget,
  });

  final Widget child;
  final String? jumpUrl;
  final ValueGetter<Widget> overlayWidget;
  final ValueGetter<Triangle> indicator;
  final TriggerMode_ triggerMode;

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  final OverlayPortalController _overlayController = OverlayPortalController();

  LongPressGestureRecognizer? _longPressRecognizer;
  LongPressGestureRecognizer get longPressRecognizer =>
      _longPressRecognizer ??= LongPressGestureRecognizer()
        ..onLongPress = _scheduleShowTooltip;

  TapGestureRecognizer? _tapGestureRecognizer;
  TapGestureRecognizer get tapGestureRecognizer =>
      _tapGestureRecognizer ??= TapGestureRecognizer()
        ..onTap = _scheduleShowTooltip;

  void _scheduleShowTooltip([_]) {
    _overlayController.show();
  }

  void _scheduleDismissTooltip([_]) {
    _overlayController.hide();
  }

  void _handlePointerDown(PointerDownEvent event) {
    assert(mounted);
    switch (widget.triggerMode) {
      case .longPress:
        longPressRecognizer.addPointer(event);
      case .tap:
        tapGestureRecognizer.addPointer(event);
      case .mouse:
        throw UnimplementedError();
    }
  }

  Widget _buildCustomTooltipOverlay(
    BuildContext context,
    OverlayChildLayoutInfo layoutInfo,
  ) {
    final target = MatrixUtils.transformPoint(
      layoutInfo.childPaintTransform,
      layoutInfo.childSize.topCenter(const Offset(0, -3)),
    );
    final _CustomTooltipOverlay overlayChild = _CustomTooltipOverlay(
      jumpUrl: widget.jumpUrl,
      target: target,
      childSize: layoutInfo.childSize,
      onDismiss: switch (widget.triggerMode) {
        .longPress || .tap => _scheduleDismissTooltip,
        .mouse => null,
      },
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
    _tapGestureRecognizer
      ?..onTap = null
      ..dispose();
    _tapGestureRecognizer = null;
    super.dispose();
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final result = switch (widget.triggerMode) {
      .longPress || .tap => Listener(
        onPointerDown: _handlePointerDown,
        behavior: HitTestBehavior.opaque,
        child: widget.child,
      ),
      .mouse => MouseRegion(
        cursor: MouseCursor.defer,
        onEnter: _scheduleShowTooltip,
        onExit: _scheduleDismissTooltip,
        child: widget.child,
      ),
    };
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: _overlayController,
      overlayChildBuilder: _buildCustomTooltipOverlay,
      child: result,
    );
  }
}

class _CustomTooltipOverlay extends StatelessWidget {
  const _CustomTooltipOverlay({
    this.jumpUrl,
    required this.target,
    required this.childSize,
    required this.onDismiss,
    required this.overlayWidget,
    required this.indicator,
  });

  final String? jumpUrl;
  final Offset target;
  final Size childSize;
  final VoidCallback? onDismiss;
  final ValueGetter<Widget> overlayWidget;
  final ValueGetter<Triangle> indicator;

  @override
  Widget build(BuildContext context) {
    return _ToolTip(
      jumpUrl: jumpUrl,
      target: target,
      childSize: childSize,
      preferBelow: false,
      onDismiss: onDismiss,
      children: [
        overlayWidget(),
        indicator(),
      ],
    );
  }
}

class _ToolTip extends MultiChildRenderObjectWidget {
  const _ToolTip({
    super.children,
    this.jumpUrl,
    this.onDismiss,
    required this.target,
    required this.childSize,
    required this.preferBelow,
  });

  final String? jumpUrl;
  final VoidCallback? onDismiss;
  final Offset target;
  final Size childSize;
  final bool preferBelow;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderToolTip(
      jumpUrl: jumpUrl,
      onDismiss: onDismiss,
      target: target,
      childSize: childSize,
      preferBelow: preferBelow,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderToolTip renderObject) {
    renderObject
      ..target = target
      ..preferBelow = preferBelow;
  }
}

class _RenderToolTip extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  _RenderToolTip({
    String? jumpUrl,
    this._onDismiss,
    required this._target,
    required this._childSize,
    required this._preferBelow,
  }) : _hitTestSelf = _onDismiss != null {
    if (jumpUrl != null && jumpUrl.isNotEmpty) {
      _tapGestureRecognizer = TapGestureRecognizer()
        ..onTap = () {
          _onDismiss?.call();
          PageUtils.handleWebview(jumpUrl);
        };
    }
  }

  final VoidCallback? _onDismiss;
  late bool _isChildHit = false;
  TapGestureRecognizer? _tapGestureRecognizer;

  final bool _hitTestSelf;
  @override
  bool hitTestSelf(Offset position) => _hitTestSelf;

  @override
  void handleEvent(PointerEvent event, HitTestEntry<HitTestTarget> entry) {
    if (event is PointerDownEvent) {
      if (_isChildHit) {
        _tapGestureRecognizer?.addPointer(event);
      } else {
        _onDismiss?.call();
      }
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (_hitTestSelf) {
      _isChildHit = defaultHitTestChildren(result, position: position);
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _tapGestureRecognizer
      ?..onTap = null
      ..dispose();
    _tapGestureRecognizer = null;
    super.dispose();
  }

  final Size _childSize;

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
    RenderTriangle indicator = (lastChild! as RenderTriangle)
      ..layout(c, parentUsesSize: true);
    RenderBox overlay = firstChild!..layout(c, parentUsesSize: true);

    final indicatorSize = indicator.size;
    final overlaySize = overlay.size;

    final indicatorParentData =
        indicator.parentData as MultiChildLayoutParentData;
    final overlayParentData = overlay.parentData as MultiChildLayoutParentData;

    const margin = 10.0;
    if (target.dy < indicatorSize.height + overlaySize.height + margin) {
      indicator._invert = true;
      final target_ = target.translate(0, _childSize.height + 6);
      final offset = positionDependentBox(
        size: size,
        childSize: overlaySize,
        target: target_,
        preferBelow: true,
        margin: margin,
      );
      overlayParentData.offset = Offset(
        offset.dx,
        offset.dy + indicatorSize.height - 1,
      );
      indicatorParentData.offset = Offset(
        target.dx - indicatorSize.width / 2,
        offset.dy,
      );
    } else {
      indicator._invert = false;
      final offset = positionDependentBox(
        size: size,
        childSize: overlaySize,
        target: target,
        preferBelow: preferBelow,
        margin: margin,
      );
      overlayParentData.offset = Offset(
        offset.dx,
        offset.dy - indicatorSize.height + 1,
      );
      indicatorParentData.offset = Offset(
        target.dx - indicatorSize.width / 2,
        offset.dy + overlaySize.height - indicatorSize.height,
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
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
    required this._color,
    required this._preferredSize,
  });

  bool _invert = false;

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

    final Path path;
    if (_invert) {
      path = Path()
        ..moveTo(offset.dx, offset.dy + size.height)
        ..lineTo(offset.dx + size.width / 2, offset.dy)
        ..lineTo(offset.dx + size.width, offset.dy + size.height);
    } else {
      path = Path()
        ..moveTo(offset.dx, offset.dy)
        ..lineTo(offset.dx + size.width / 2, offset.dy + size.height)
        ..lineTo(offset.dx + size.width, offset.dy);
    }

    context.canvas
      ..drawPath(path, paint)
      ..drawPath(
        path,
        paint
          ..color = borderColor
          ..style = .stroke
          ..strokeWidth = 1.2,
      );
  }
}

const borderColor = Color(0x1F9E9E9E);
