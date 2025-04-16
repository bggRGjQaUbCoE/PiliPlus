import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DisabledIcon<T extends Widget> extends SingleChildRenderObjectWidget {
  final Color? color;
  final double lineLengthScale;
  final StrokeCap strokeCap;

  const DisabledIcon({
    super.key,
    required T child,
    this.color,
    double? lineLengthScale,
    StrokeCap? strokeCap,
  })  : lineLengthScale = lineLengthScale ?? 0.9,
        strokeCap = strokeCap ?? StrokeCap.butt,
        super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMaskedIcon(
      color ??
          (child is Icon
              ? (child as Icon).color ?? IconTheme.of(context).color!
              : IconTheme.of(context).color!),
      lineLengthScale,
      strokeCap,
    );
  }

  T enable() => child as T;
}

class RenderMaskedIcon extends RenderProxyBox {
  final Color color;
  final double lineLengthScale;
  final StrokeCap strokeCap;

  RenderMaskedIcon(this.color, this.lineLengthScale, this.strokeCap);

  @override
  void paint(PaintingContext context, Offset offset) {
    final strokeWidth = size.width / 12;

    final canvas = context.canvas;
    var rect = offset & size;

    final sqrt2Width = strokeWidth * sqrt2; // rotate pi / 4

    // final path = Path.combine(
    //   PathOperation.difference,
    //   Path()..addRect(rect),
    //   Path()..moveTo(rect.left, rect.top)
    //   ..relativeLineTo(sqrt2Width, 0)
    //   ..lineTo(rect.right, rect.bottom - sqrt2Width)
    //   ..lineTo(rect.right, rect.bottom)
    //   ..close(),
    // );

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
          ..lineTo(rect.left + sqrt2Width, rect.top));

    canvas.save();

    canvas.clipPath(path, doAntiAlias: false);
    super.paint(context, offset);

    context.canvas.restore();

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
}

extension DisabledIconExt on Icon {
  DisabledIcon<Icon> disable([double? lineLengthScale]) =>
      DisabledIcon(lineLengthScale: lineLengthScale, child: this);
}
