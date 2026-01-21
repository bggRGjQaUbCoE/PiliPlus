import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DisabledIcon<T extends Widget> extends SingleChildRenderObjectWidget {
  const DisabledIcon({
    super.key,
    required T child,
    this.disable = false,
    this.color,
    this.iconSize,
    double? lineLengthScale,
    StrokeCap? strokeCap,
  }) : lineLengthScale = lineLengthScale ?? 0.9,
       strokeCap = strokeCap ?? StrokeCap.butt,
       super(child: child);

  final bool disable;
  final Color? color;
  final double? iconSize;
  final StrokeCap strokeCap;
  final double lineLengthScale;

  @override
  RenderObject createRenderObject(BuildContext context) {
    late final iconTheme = IconTheme.of(context);
    return RenderMaskedIcon(
      disable: disable,
      iconSize:
          iconSize ??
          (child is Icon ? (child as Icon).size : null) ??
          iconTheme.size ??
          24.0,
      color:
          color ??
          (child is Icon ? (child as Icon).color : null) ??
          iconTheme.color!,
      strokeCap: strokeCap,
      lineLengthScale: lineLengthScale,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMaskedIcon renderObject) {
    late final iconTheme = IconTheme.of(context);
    renderObject
      ..disable = disable
      ..iconSize =
          iconSize ??
          (child is Icon ? (child as Icon?)?.size : null) ??
          iconTheme.size ??
          24.0
      ..color =
          color ??
          (child is Icon ? (child as Icon?)?.color : null) ??
          iconTheme.color!
      ..strokeCap = strokeCap
      ..lineLengthScale = lineLengthScale;
  }
}

class RenderMaskedIcon extends RenderProxyBox {
  RenderMaskedIcon({
    required bool disable,
    required double iconSize,
    required Color color,
    required StrokeCap strokeCap,
    required double lineLengthScale,
  }) : _disable = disable,
       _iconSize = iconSize,
       _color = color,
       _strokeCap = strokeCap,
       _lineLengthScale = lineLengthScale;

  bool _disable;
  bool get disable => _disable;
  set disable(bool value) {
    if (_disable == value) return;
    _disable = value;
    markNeedsPaint();
  }

  double _iconSize;
  double get iconSize => _iconSize;
  set iconSize(double value) {
    if (_iconSize == value) return;
    _iconSize = value;
    markNeedsPaint();
  }

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  StrokeCap _strokeCap;
  StrokeCap get strokeCap => _strokeCap;
  set strokeCap(StrokeCap value) {
    if (_strokeCap == value) return;
    _strokeCap = value;
    markNeedsPaint();
  }

  double _lineLengthScale;
  double get lineLengthScale => _lineLengthScale;
  set lineLengthScale(double value) {
    if (_lineLengthScale == value) return;
    _lineLengthScale = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!disable) {
      return super.paint(context, offset);
    }

    final canvas = context.canvas;

    Size size = this.size;
    final exceedWidth = size.width > _iconSize;
    final exceedHeight = size.height > _iconSize;
    if (exceedWidth || exceedHeight) {
      final dx = exceedWidth ? (size.width - _iconSize) / 2.0 : 0.0;
      final dy = exceedHeight ? (size.height - _iconSize) / 2.0 : 0.0;
      size = Size.square(_iconSize);
      offset = Offset(dx, dy);
    } else if (size.width < _iconSize && size.height < _iconSize) {
      size = Size.square(_iconSize);
    }

    final strokeWidth = size.width / 12;

    var rect = offset & size;

    final sqrt2Width = strokeWidth * sqrt2; // rotate pi / 4

    final path = Path.combine(
      PathOperation.union,
      Path() // bottom
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top + sqrt2Width)
        ..lineTo(rect.right - sqrt2Width, rect.bottom)
        ..close(),
      Path() // top
        ..moveTo(rect.right, rect.top)
        ..lineTo(rect.right, rect.bottom - sqrt2Width)
        ..lineTo(rect.left + sqrt2Width, rect.top),
    );

    canvas
      ..save()
      ..clipPath(path, doAntiAlias: false);
    super.paint(context, .zero);

    canvas.restore();

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap;

    final strokeOffset = strokeWidth * sqrt1_2 / 2;
    rect = rect
        .translate(-strokeOffset, strokeOffset)
        .deflate(size.width * lineLengthScale);
    canvas.drawLine(
      rect.topLeft,
      rect.bottomRight,
      linePaint,
    );
  }

  @override
  bool get isRepaintBoundary => true;
}
