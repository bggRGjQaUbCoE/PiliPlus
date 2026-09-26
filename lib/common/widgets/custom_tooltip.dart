import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/gestures.dart'
    show
        TapGestureRecognizer,
        HitTestTarget,
        LongPressGestureRecognizer,
        HitTestEntry;
import 'package:flutter/rendering.dart'
    show
        BoxHitTestResult,
        BoxHitTestEntry,
        HitTestEntry,
        RenderObjectWithChildMixin;
import 'package:flutter/widgets.dart';

// ignore: camel_case_types
enum TriggerMode_ { longPress, tap, mouse }

class CustomTooltip extends StatefulWidget {
  const CustomTooltip({
    super.key,
    this.jumpUrl,
    required this.color,
    required this.shadow,
    required this.child,
    required this.triggerMode,
    required this.overlayWidget,
  });

  final Widget child;
  final Color color;
  final Color shadow;
  final String? jumpUrl;
  final ValueGetter<Widget> overlayWidget;
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
      color: widget.color,
      shadow: widget.shadow,
      jumpUrl: widget.jumpUrl,
      target: target,
      childSize: layoutInfo.childSize,
      onDismiss: switch (widget.triggerMode) {
        .longPress || .tap => _scheduleDismissTooltip,
        .mouse => null,
      },
      overlayWidget: widget.overlayWidget,
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
    required this.color,
    required this.shadow,
    required this.target,
    required this.childSize,
    required this.onDismiss,
    required this.overlayWidget,
  });

  final Color color;
  final Color shadow;
  final String? jumpUrl;
  final Offset target;
  final Size childSize;
  final VoidCallback? onDismiss;
  final ValueGetter<Widget> overlayWidget;

  @override
  Widget build(BuildContext context) {
    return _ToolTip(
      color: color,
      shadow: shadow,
      jumpUrl: jumpUrl,
      target: target,
      childSize: childSize,
      preferBelow: false,
      onDismiss: onDismiss,
      child: overlayWidget(),
    );
  }
}

class _ToolTip extends SingleChildRenderObjectWidget {
  const _ToolTip({
    required Widget super.child,
    this.jumpUrl,
    this.onDismiss,
    required this.color,
    required this.shadow,
    required this.target,
    required this.childSize,
    required this.preferBelow,
  });

  final String? jumpUrl;
  final VoidCallback? onDismiss;
  final Color color;
  final Color shadow;
  final Offset target;
  final Size childSize;
  final bool preferBelow;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderToolTip(
      color: color,
      shadow: shadow,
      jumpUrl: jumpUrl,
      onDismiss: onDismiss,
      target: target,
      childSize: childSize,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderToolTip renderObject) {
    renderObject
      ..color = color
      ..shadow = shadow
      ..target = target;
  }
}

class _RenderToolTip extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  _RenderToolTip({
    String? jumpUrl,
    this._onDismiss,
    required this._color,
    required this._shadow,
    required this._target,
    required this._childSize,
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
      _isChildHit = child!.size.contains(position - _offset);
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

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  Color _shadow;
  Color get shadow => _shadow;
  set shadow(Color value) {
    if (_shadow == value) return;
    _shadow = value;
    markNeedsPaint();
  }

  Offset _target;
  Offset get target => _target;
  set target(Offset value) {
    if (_target == value) return;
    _target = value;
    markNeedsPaint();
  }

  bool _invert = false;
  Offset _offset = .zero;
  static const indicatorSize = Size(14, 8);

  @override
  void performLayout() {
    size = constraints.constrain(constraints.biggest);

    final overlaySize =
        (child!..layout(constraints.loosen(), parentUsesSize: true)).size;

    const margin = 10.0;
    if (target.dy < indicatorSize.height + overlaySize.height + margin) {
      _invert = true;
      final target_ = target.translate(0, _childSize.height + 6);
      final offset = positionDependentBox(
        size: size,
        childSize: overlaySize,
        target: target_,
        preferBelow: true,
        margin: margin,
      );
      _offset = Offset(offset.dx, offset.dy + indicatorSize.height - 1);
    } else {
      _invert = false;
      final offset = positionDependentBox(
        size: size,
        childSize: overlaySize,
        target: target,
        preferBelow: false,
        margin: margin,
      );
      _offset = Offset(offset.dx, offset.dy - indicatorSize.height + 1);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    offset += _offset;

    final overlaySize = child!.size;
    final rrect = RRect.fromRectAndRadius(
      offset & overlaySize,
      const .circular(8),
    );
    final paint = Paint()..color = color;
    canvas
      ..drawShadow(Path()..addRRect(rrect), shadow, 2, true)
      ..drawRRect(rrect, paint);

    final Path path;
    if (_invert) {
      final offset_ = Offset(
        target.dx - indicatorSize.width / 2,
        offset.dy - indicatorSize.height,
      );
      path = Path()
        ..moveTo(offset_.dx, offset_.dy + indicatorSize.height)
        ..lineTo(offset_.dx + indicatorSize.width / 2, offset_.dy)
        ..lineTo(
          offset_.dx + indicatorSize.width,
          offset_.dy + indicatorSize.height,
        );
      canvas
        ..drawPath(path, paint)
        ..drawPath(
          path,
          paint
            ..style = .stroke
            ..color = const Color(0x1F9E9E9E),
        );
    } else {
      final offset_ = Offset(
        target.dx - indicatorSize.width / 2,
        offset.dy + overlaySize.height - 1,
      );
      path = Path()
        ..moveTo(offset_.dx, offset_.dy)
        ..lineTo(
          offset_.dx + indicatorSize.width / 2,
          offset_.dy + indicatorSize.height,
        )
        ..lineTo(offset_.dx + indicatorSize.width, offset_.dy);
      canvas
        ..drawShadow(path, shadow, 2, true)
        ..drawPath(path, paint);
    }

    context.paintChild(child!, offset);
  }
}
