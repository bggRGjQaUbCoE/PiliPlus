import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderProxyBox;

class CustomHeightWidget extends SingleChildRenderObjectWidget {
  const CustomHeightWidget({
    super.key,
    required this.height,
    this.offset = .zero,
    required super.child,
  });

  final double height;

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
    required double height,
    required Offset offset,
  }) : _height = height,
       _offset = offset;

  double _height;
  double get height => _height;
  set height(double value) {
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
    child!.layout(constraints, parentUsesSize: true);
    size = constraints.constrainDimensions(constraints.maxWidth, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset + _offset);
  }
}
