/*
 * This file is part of PiliPlus
 *
 * PiliPlus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PiliPlus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with PiliPlus.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show listEquals, kDebugMode;
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show BoxHitTestEntry;

@immutable
sealed class BaseSegment {
  final double start;
  final double end;

  const BaseSegment({
    required this.start,
    required this.end,
  });
}

@immutable
class Segment extends BaseSegment {
  final Color color;

  const Segment({
    required super.start,
    required super.end,
    required this.color,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Segment) {
      return start == other.start && end == other.end && color == other.color;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(start, end, color);
}

@immutable
class ViewPointSegment extends BaseSegment {
  final String? title;
  final String? url;
  final int? from;
  final int? to;

  const ViewPointSegment({
    required super.start,
    required super.end,
    this.title,
    this.url,
    this.from,
    this.to,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is ViewPointSegment) {
      return start == other.start &&
          end == other.end &&
          title == other.title &&
          url == other.url &&
          from == other.from &&
          to == other.to;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(start, end, title, url, from, to);
}

class SegmentProgressBar extends BaseSegmentProgressBar<Segment> {
  const SegmentProgressBar({
    super.key,
    super.height = 3.5,
    required super.segments,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderProgressBar(
      height: height,
      segments: segments,
    );
  }
}

class RenderProgressBar extends BaseRenderProgressBar<Segment> {
  RenderProgressBar({
    required super.height,
    required super.segments,
  });

  @override
  void paint(PaintingContext context, Offset offset) {
    final size = this.size;
    final canvas = context.canvas;
    final paint = Paint()..style = PaintingStyle.fill;

    for (final segment in segments) {
      paint.color = segment.color;
      final segmentStart = segment.start * size.width;
      final segmentEnd = segment.end * size.width;

      if (segmentEnd > segmentStart ||
          (segmentEnd == segmentStart && segmentStart > 0)) {
        canvas.drawRect(
          Rect.fromLTRB(
            segmentStart,
            0,
            segmentEnd == segmentStart ? segmentStart + 2 : segmentEnd,
            size.height,
          ),
          paint,
        );
      }
    }
  }
}

class ViewPointSegmentProgressBar
    extends BaseSegmentProgressBar<ViewPointSegment> {
  const ViewPointSegmentProgressBar({
    super.key,
    super.height = 3.5,
    required super.segments,
    this.onSeek,
  });

  final ValueSetter<Duration>? onSeek;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderViewPointProgressBar(
      height: height,
      segments: segments,
      onSeek: onSeek,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderViewPointProgressBar renderObject,
  ) {
    renderObject
      ..height = height
      ..segments = segments
      ..onSeek = onSeek;
  }
}

class RenderViewPointProgressBar
    extends BaseRenderProgressBar<ViewPointSegment> {
  RenderViewPointProgressBar({
    required super.height,
    required super.segments,
    ValueSetter<Duration>? onSeek,
  }) : _onSeek = onSeek,
       _hitTestSelf = onSeek != null {
    if (onSeek != null) {
      _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _onTapUp;
    }
  }

  @override
  void performLayout() {
    size = constraints.constrainDimensions(constraints.maxWidth, _barHeight);
  }

  static const double _barHeight = 15.0;

  @override
  void paint(PaintingContext context, Offset offset) {
    final size = this.size;
    final canvas = context.canvas;
    final paint = Paint()..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, _barHeight),
      paint..color = Colors.grey[600]!.withValues(alpha: 0.45),
    );

    paint.color = Colors.black.withValues(alpha: 0.5);

    for (int index = 0; index < segments.length; index++) {
      final isFirst = index == 0;
      final item = segments[index];
      final segmentStart = item.start * size.width;
      final segmentEnd = item.end * size.width;

      if (segmentEnd > segmentStart ||
          (segmentEnd == segmentStart && segmentStart > 0)) {
        canvas.drawRect(
          Rect.fromLTRB(
            segmentStart,
            0,
            segmentEnd == segmentStart ? segmentStart + 2 : segmentEnd,
            _barHeight + height,
          ),
          paint,
        );

        final title = item.title;
        if (title != null && title.isNotEmpty) {
          ui.Paragraph getParagraph(double size) {
            final builder =
                ui.ParagraphBuilder(
                    ui.ParagraphStyle(
                      textDirection: .ltr,
                      strutStyle: ui.StrutStyle(
                        leading: 0,
                        height: 1,
                        fontSize: size,
                      ),
                    ),
                  )
                  ..pushStyle(
                    ui.TextStyle(
                      color: Colors.white,
                      fontSize: size,
                      height: 1,
                    ),
                  )
                  ..addText(title);
            return builder.build()
              ..layout(const ui.ParagraphConstraints(width: double.infinity));
          }

          late double prevStart;
          if (!isFirst) {
            prevStart = segments[index - 1].start * size.width;
          }
          final width = isFirst ? segmentStart : segmentStart - prevStart;

          const double maxFS = 10;
          const double minFS = 2;

          final space = width - 2;

          final preCalcFS = space / title.length;
          ui.Paragraph? paragraph;
          if (0.5 * minFS <= preCalcFS && preCalcFS <= 1.2 * maxFS) {
            var max = maxFS;
            var min = minFS;
            var mid = preCalcFS.clamp(minFS, maxFS);
            do {
              paragraph?.dispose();
              paragraph = getParagraph(mid);
              var comp = space - paragraph.minIntrinsicWidth;
              if (comp > 0) {
                if (comp < 2) break;
                min = mid;
              } else {
                max = mid;
              }
              mid = min + (max - min) / 2;
            } while (max - min > 0.25);
          } else {
            paragraph = getParagraph(preCalcFS.clamp(minFS, maxFS));
          }

          final textX = isFirst
              ? (segmentStart - paragraph.minIntrinsicWidth) / 2
              : (segmentStart - prevStart - paragraph.minIntrinsicWidth) / 2 +
                    prevStart +
                    1;
          final textY = (_barHeight - paragraph.height) / 2;
          canvas.drawParagraph(paragraph, Offset(textX, textY));
          paragraph.dispose();
        }
      }
    }
  }

  ValueSetter<Duration>? _onSeek;
  set onSeek(ValueSetter<Duration>? value) {
    if (_onSeek == value) {
      return;
    }
    _onSeek = value;
  }

  TapGestureRecognizer? _tapGestureRecognizer;

  @override
  void dispose() {
    _onSeek = null;
    _tapGestureRecognizer
      ?..onTapUp = null
      ..dispose();
    _tapGestureRecognizer = null;
    super.dispose();
  }

  final bool _hitTestSelf;
  @override
  bool hitTestSelf(Offset position) => _hitTestSelf;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer?.addPointer(event);
    }
  }

  void _onTapUp(TapUpDetails details) {
    try {
      final seg = details.localPosition.dx / size.width;
      final item = _segments
          .where((item) => item.start >= seg)
          .reduce((a, b) => a.start < b.start ? a : b);
      if (item.from case final from?) {
        _onSeek?.call(Duration(seconds: from));
      }
      // if (kDebugMode) debugPrint('${item.title},,${item.from}');
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }
}

abstract class BaseSegmentProgressBar<T extends BaseSegment>
    extends LeafRenderObjectWidget {
  const BaseSegmentProgressBar({
    super.key,
    this.height = 3.5,
    required this.segments,
  });

  final double height;
  final List<T> segments;

  @override
  void updateRenderObject(
    BuildContext context,
    BaseRenderProgressBar renderObject,
  ) {
    renderObject
      ..height = height
      ..segments = segments;
  }
}

class BaseRenderProgressBar<T extends BaseSegment> extends RenderBox {
  BaseRenderProgressBar({
    required double height,
    required List<T> segments,
  }) : _height = height,
       _segments = segments;

  double _height;
  double get height => _height;
  set height(double value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  List<T> _segments;
  List<T> get segments => _segments;
  set segments(List<T> value) {
    if (listEquals(_segments, value)) return;
    _segments = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.constrainDimensions(constraints.maxWidth, height);
  }

  @override
  bool get isRepaintBoundary => true;
}
