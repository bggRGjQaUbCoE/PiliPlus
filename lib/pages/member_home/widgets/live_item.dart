part of 'package:PiliPlus/pages/member_home/view.dart';

const _maxWith = 400.0;

class _LiveItem extends SingleChildRenderObjectWidget {
  const _LiveItem({
    required this.color,
    required Widget super.child,
  });

  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderLiveItem(color: color);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderLiveItem renderObject) {
    renderObject.color = color;
  }
}

class _RenderLiveItem extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>
    implements MouseTrackerAnnotation {
  _RenderLiveItem({
    required this._color,
  });

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  Offset _offset = .zero;

  @override
  void performLayout() {
    final maxWidth = constraints.maxWidth;

    final double width;
    final BoxConstraints childConstraints;
    if (maxWidth > _maxWith) {
      width = _maxWith;
      _offset = Offset((maxWidth - _maxWith) / 2, 0);
      childConstraints = BoxConstraints.tightFor(width: width);
    } else {
      width = maxWidth;
      _offset = .zero;
      childConstraints = constraints;
    }
    final childSize =
        (child!..layout(childConstraints, parentUsesSize: true)).size;
    size = constraints.constrainDimensions(maxWidth, childSize.height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final paint = Paint()..color = _color;
    if (_offset != .zero) {
      offset += _offset;
      context.canvas.drawRRect(
        .fromRectAndRadius(
          offset & Size(_maxWith, size.height),
          Style.imgRadius,
        ),
        paint,
      );
    } else {
      context.canvas.drawRect(offset & size, paint);
    }
    context.paintChild(child!, offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintOffset(
      offset: _offset.dx == 0 ? null : _offset,
      position: position,
      hitTest: (result, position) {
        final isHit = child!.hitTest(result, position: position);
        if (isHit) {
          result.add(BoxHitTestEntry(this, position));
        }
        return isHit;
      },
    );
  }

  @override
  void applyPaintTransform(covariant RenderObject child, Matrix4 transform) {
    if (_offset.dx != 0) {
      transform.translateByDouble(_offset.dx, 0.0, 0.0, 1.0);
    }
    super.applyPaintTransform(child, transform);
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.click;

  @override
  PointerEnterEventListener? onEnter;

  @override
  PointerExitEventListener? onExit;

  @override
  bool get validForMouseTracker => false;
}
