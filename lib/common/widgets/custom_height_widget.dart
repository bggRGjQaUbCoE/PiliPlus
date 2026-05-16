import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderProxyBox, BoxHitTestResult;

class CustomHeightWidget extends SingleChildRenderObjectWidget {
  const CustomHeightWidget({
    super.key,
    this.height,
    this.offset = .zero,
    required Widget super.child,
  });

  final double? height;

  final Offset offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomHeightWidget(
      height: height,
      offset: offset,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderCustomHeightWidget renderObject,
  ) {
    renderObject
      ..height = height
      ..offset = offset;
  }
}

class RenderCustomHeightWidget extends RenderProxyBox {
  RenderCustomHeightWidget({
    this._height,
    required this._offset,
  });

  double? _height;
  double? get height => _height;
  set height(double? value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  Offset _offset;
  Offset get offset => _offset;
  set offset(Offset value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    if (height != null) {
      child!.layout(constraints.copyWith(maxHeight: .infinity));
      size = constraints.constrainDimensions(constraints.maxWidth, height!);
    } else {
      child!.layout(
        constraints.copyWith(maxHeight: .infinity),
        parentUsesSize: true,
      );
      size = constraints.constrainDimensions(
        constraints.maxWidth,
        child!.size.height,
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset + _offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintOffset(
      offset: _offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        assert(transformed == position - _offset);
        return child!.hitTest(result, position: transformed);
      },
    );
  }

  @override
  void applyPaintTransform(covariant RenderObject child, Matrix4 transform) {
    transform.translateByDouble(_offset.dx, _offset.dy, 0.0, 1.0);
  }
}
