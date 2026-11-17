import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Weeko's two cubic Beziers per corner, with continuous joining curvature.
class G2ShapeBorder extends OutlinedBorder {
  const G2ShapeBorder({required this.radius, this.topOnly = false, super.side});

  final double radius;
  final bool topOnly;

  @override
  G2ShapeBorder copyWith({BorderSide? side}) =>
      G2ShapeBorder(radius: radius, topOnly: topOnly, side: side ?? this.side);

  @override
  G2ShapeBorder scale(double t) =>
      G2ShapeBorder(radius: radius * t, topOnly: topOnly, side: side.scale(t));

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect.deflate(side.width), textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final r = math.min(
      radius,
      math.min(rect.width / 2, rect.height / (topOnly ? 1 : 2)),
    );
    final path = Path();
    void corner(Offset start, Offset tangent0, Offset end, Offset tangent1) {
      final middle = (start + end) / 2 + (tangent0 - tangent1) * .32;
      final a = start + tangent0 * .28;
      final b = start + tangent0 * .64;
      final c = end - tangent1 * .64;
      final d = end - tangent1 * .28;
      path
        ..cubicTo(a.dx, a.dy, b.dx, b.dy, middle.dx, middle.dy)
        ..cubicTo(c.dx, c.dy, d.dx, d.dy, end.dx, end.dy);
    }

    path
      ..moveTo(rect.left + r, rect.top)
      ..lineTo(rect.right - r, rect.top);
    corner(
      Offset(rect.right - r, rect.top),
      Offset(r, 0),
      Offset(rect.right, rect.top + r),
      Offset(0, r),
    );
    if (topOnly) {
      path
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.left, rect.bottom);
    } else {
      path.lineTo(rect.right, rect.bottom - r);
      corner(
        Offset(rect.right, rect.bottom - r),
        Offset(0, r),
        Offset(rect.right - r, rect.bottom),
        Offset(-r, 0),
      );
      path.lineTo(rect.left + r, rect.bottom);
      corner(
        Offset(rect.left + r, rect.bottom),
        Offset(-r, 0),
        Offset(rect.left, rect.bottom - r),
        Offset(0, -r),
      );
    }
    path.lineTo(rect.left, rect.top + r);
    corner(
      Offset(rect.left, rect.top + r),
      Offset(0, -r),
      Offset(rect.left + r, rect.top),
      Offset(r, 0),
    );
    return path..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.solid && side.width > 0) {
      canvas.drawPath(
        getOuterPath(rect.deflate(side.width / 2)),
        side.toPaint(),
      );
    }
  }
}
