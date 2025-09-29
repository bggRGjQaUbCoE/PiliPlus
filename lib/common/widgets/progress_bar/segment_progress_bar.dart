import 'package:flutter/material.dart';

class Segment {
  final double start;
  final double end;
  final Color color;
  final String? title;
  final String? url;
  final int? from;
  final int? to;

  Segment(
    this.start,
    this.end,
    this.color, [
    this.title,
    this.url,
    this.from,
    this.to,
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Segment) {
      return start == other.start &&
          end == other.end &&
          color == other.color &&
          title == other.title &&
          url == other.url &&
          from == other.from &&
          to == other.to;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(start, end, color, title, url, from, to);
}

class SegmentProgressBar extends CustomPainter {
  final List<Segment> segmentColors;
  double? _defHeight;

  SegmentProgressBar({
    required this.segmentColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < segmentColors.length; i++) {
      final item = segmentColors[i];
      paint.color = item.color;
      final segmentStart = item.start * size.width;
      final segmentEnd = item.end * size.width;

      if (segmentEnd > segmentStart ||
          (segmentEnd == segmentStart && segmentStart > 0)) {
        if (item.title != null) {
          double fontSize = 10;

          _defHeight ??=
              (TextPainter(
                text: TextSpan(
                  text: item.title,
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                textDirection: TextDirection.ltr,
              )..layout()).height +
              2;

          TextPainter getTextPainter() => TextPainter(
            text: TextSpan(
              text: item.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                height: 1,
              ),
            ),
            strutStyle: StrutStyle(leading: 0, height: 1, fontSize: fontSize),
            textDirection: TextDirection.ltr,
          )..layout();

          TextPainter textPainter = getTextPainter();

          late double prevStart;
          if (i != 0) {
            prevStart = segmentColors[i - 1].start * size.width;
          }
          double width = i == 0 ? segmentStart : segmentStart - prevStart;

          while (textPainter.width > width - 2 && fontSize >= 2) {
            fontSize -= 0.5;
            textPainter = getTextPainter();
          }

          if (i == 0) {
            canvas.drawRect(
              Rect.fromLTRB(
                0,
                -_defHeight!,
                size.width,
                0,
              ),
              Paint()..color = Colors.grey[600]!.withValues(alpha: 0.45),
            );
          }

          canvas.drawRect(
            Rect.fromLTWH(
              segmentStart,
              -_defHeight!,
              segmentEnd == segmentStart ? 2 : segmentEnd - segmentStart,
              size.height + _defHeight!,
            ),
            paint,
          );

          double textX = i == 0
              ? (segmentStart - textPainter.width) / 2
              : (segmentStart - prevStart - textPainter.width) / 2 +
                    prevStart +
                    1;
          double textY = (-_defHeight! - textPainter.height) / 2;
          textPainter.paint(canvas, Offset(textX, textY));
        } else {
          canvas.drawRect(
            Rect.fromLTWH(
              segmentStart,
              0,
              segmentEnd == segmentStart ? 2 : segmentEnd - segmentStart,
              size.height,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(SegmentProgressBar oldDelegate) {
    return segmentColors != oldDelegate.segmentColors;
  }
}
