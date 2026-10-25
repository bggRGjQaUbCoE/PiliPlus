import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReplyThreadedIndentBox extends SingleChildRenderObjectWidget {
  const ReplyThreadedIndentBox({
    super.key,
    required this.depth,
    required this.colors,
    this.divColor,
    this.onTapLine,
    this.onTapDot,
    this.onScrollLeft,
    required Widget super.child,
  }) : assert(depth >= 0);

  final int depth;
  final List<Color> colors;
  final Color? divColor;
  final VoidCallback? onTapLine;
  final ValueChanged<int>? onTapDot;
  final VoidCallback? onScrollLeft;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderReplyThreadedIndentBox(
        indentDepth: depth,
        colors: colors,
        divColor: divColor,
        onTapLine: onTapLine,
        onTapDot: onTapDot,
        onScrollLeft: onScrollLeft,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderReplyThreadedIndentBox renderObject,
  ) {
    renderObject
      ..indentDepth = depth
      ..colors = colors
      ..divColor = divColor
      ..onTapLine = onTapLine
      ..onTapDot = onTapDot
      ..onScrollLeft = onScrollLeft;
  }
}

class RenderReplyThreadedIndentBox extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  static const double indentStep = 8;
  static const double lineW = 3;
  static const double dotRadius = 3;
  static const double halfLinePadV = 8;
  static const double hitRadius = 5;
  static const double dragMaxOffset = 60;

  static const double _halfLineW = lineW / 2;
  static double indentWidthOf(int depth) => (depth + 1) * indentStep;

  RenderReplyThreadedIndentBox({
    required this._indentDepth,
    required this._colors,
    required this._divColor,
    this.onTapLine,
    this.onTapDot,
    this._onScrollLeft,
  }) : assert(hitRadius < indentStep);

  /// 避免与 [RenderObject.depth] 重名
  int _indentDepth;
  set indentDepth(int value) {
    if (_indentDepth != value) {
      _indentDepth = value;
      markNeedsLayout();
    }
  }

  List<Color> _colors;
  set colors(List<Color> value) {
    if (_colors != value) {
      assert(!listEquals(_colors, value), '引用不等但值等，colors不应在build中创建');
      _colors = value;
      markNeedsPaint();
    }
  }

  Color? _divColor;
  set divColor(Color? value) {
    if (_divColor != value) {
      _divColor = value;
      markNeedsPaint();
    }
  }

  VoidCallback? _onScrollLeft;
  set onScrollLeft(VoidCallback? value) {
    if (_onScrollLeft != value) {
      _onScrollLeft = value;
      markNeedsSemanticsUpdate();
    }
  }

  VoidCallback? onTapLine;
  ValueChanged<int>? onTapDot;

  late final _tapRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  late final _dragRecognizer = HorizontalDragGestureRecognizer()
    ..onUpdate = _handleDragUpdate
    ..onEnd = _handleDragEnd
    ..onCancel = _handleDragCancel;

  double _dragDelta = 0;

  double get _indentWidth => indentWidthOf(_indentDepth);

  @override
  double computeMinIntrinsicWidth(double height) {
    return _indentWidth + (child?.getMinIntrinsicWidth(height) ?? 0.0);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _indentWidth + (child?.getMaxIntrinsicWidth(height) ?? 0.0);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return child?.getMinIntrinsicHeight(math.max(0.0, width - _indentWidth)) ??
        0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return child?.getMaxIntrinsicHeight(math.max(0.0, width - _indentWidth)) ??
        0.0;
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (child case final child?) {
      final indent = _indentWidth;
      final childConstraints = constraints.deflateWidth(indent);
      final childSize = child.getDryLayout(childConstraints);
      return constraints.constrainDimensions(
        childSize.width + indent,
        childSize.height,
      );
    } else {
      return constraints.constrainDimensions(constraints.maxWidth, 0);
    }
  }

  @override
  void performLayout() {
    if (child case final child?) {
      final indent = _indentWidth;
      final childConstraints = constraints.deflateWidth(indent);
      child.layout(childConstraints, parentUsesSize: true);
      final childSize = child.size;
      size = constraints.constrainDimensions(
        childSize.width + indent,
        childSize.height,
      );
    } else {
      size = constraints.constrainDimensions(constraints.maxWidth, 0);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child case final child?) {
      final canvas = context.canvas;
      final paint = Paint();
      final size = this.size;

      final baseIndentX = offset.dx + _indentWidth;
      final dragIndentX = baseIndentX + _dragDelta;
      final lineX = dragIndentX - _halfLineW;
      final offsetY = offset.dy;

      // 2. 顶部分割线
      if (_divColor case final div?) {
        final dy = offsetY + 0.75;
        canvas.drawLine(
          Offset(baseIndentX - _halfLineW, dy),
          Offset(offset.dx + size.width, dy),
          paint
            ..color = div
            ..strokeWidth = 1.5,
        );
      }

      if (_dragDelta < 0) {
        canvas.clipRect(offset & size);
      }

      if (lineX >= -_halfLineW) {
        // 3. 祖先淡点
        if (_indentDepth > 3) {
          paint.strokeWidth = 0;
          final halfH = offsetY + size.height / 2;
          final base = offset.dx + _dragDelta - dotRadius;
          for (int k = 3; k < _indentDepth; k += 3) {
            final circX = base + indentWidthOf(k);
            if (circX < -dotRadius) continue;
            canvas.drawCircle(
              Offset(circX, halfH),
              dotRadius,
              paint..color = _colors.elementAtLoop(k).withValues(alpha: .55),
            );
          }
        }

        // 4. 自己的彩线
        canvas.drawLine(
          Offset(lineX, offsetY + halfLinePadV),
          Offset(lineX, offsetY + size.height - halfLinePadV),
          paint
            ..color = _colors.elementAtLoop(_indentDepth)
            ..strokeWidth = lineW
            ..strokeCap = .round,
        );

        paint.strokeCap = .butt;
      } else {
        paint.color = _colors.elementAt(_indentDepth);
      }

      // 5. 跳转示意。TODO: 需要更合适的图案
      if (_dragDelta < 0) {
        final eX = offset.dx + size.width;
        final sX = eX + _dragDelta;
        final rect = Rect.fromLTRB(sX, offsetY, eX, offsetY + size.height);
        canvas.drawRect(rect, paint..strokeWidth = 0);
        final triY = math.min(size.height - halfLinePadV * 2, dragMaxOffset);
        final path = Path()
          ..moveTo(
            sX + indentStep + dragMaxOffset / 3,
            offsetY + halfLinePadV * 2,
          )
          ..lineTo(sX + indentStep, offsetY + triY)
          ..relativeLineTo(40, 0)
          ..close();
        canvas
          ..drawPath(path, paint..color = Colors.white)
          ..drawLine(
            Offset(
              sX + indentStep + dragMaxOffset / 3,
              offsetY + halfLinePadV * 2,
            ),
            Offset(
              sX + indentStep + dragMaxOffset / 3,
              offsetY + size.height - halfLinePadV * 2,
            ),
            paint,
          )
          ..drawLine(
            Offset(sX + indentStep, offsetY + size.height - halfLinePadV * 2),
            Offset(
              sX + indentStep + dragMaxOffset * 2 / 3,
              offsetY + size.height - halfLinePadV * 2,
            ),
            paint,
          );
      }

      // 6. 子节点右移绘制
      context.paintChild(child, Offset(dragIndentX, offsetY));
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child case final child?) {
      return result.addWithPaintOffset(
        offset: Offset(_indentWidth + _dragDelta, 0),
        position: position,
        hitTest: (result, transformed) {
          return child.hitTest(result, position: transformed);
        },
      );
    } else {
      return false;
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    transform.translateByDouble(_indentWidth + _dragDelta, 0, 0, 1);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.label = '第${depth + 1}层';
    if (_onScrollLeft != null) {
      config.onScrollLeft = _onScrollLeft;
    }
  }

  int _hitDepth(Offset offset) {
    final x = offset.dx;
    final lineX = _indentWidth - _halfLineW;
    if (x > lineX + hitRadius) return -1;
    if (onTapLine != null && (lineX - x).abs() <= hitRadius) {
      return _indentDepth;
    }
    if (onTapDot != null && _indentDepth > 3) {
      final dy = (offset.dy - size.height / 2).abs();
      if (dy > hitRadius) return -1;
      final dy2 = dy * dy;
      final base = x + _halfLineW;
      const hitRadius2 = hitRadius * hitRadius;
      for (int k = 3; k < _indentDepth; k += 3) {
        final dx = base - indentWidthOf(k);
        if (dx * dx + dy2 <= hitRadius2) {
          return k;
        }
      }
    }
    return -1;
  }

  @override
  bool hitTestSelf(Offset position) {
    return _onScrollLeft != null || _hitDepth(position) != -1;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      if (_hitDepth(event.localPosition) != -1) {
        _tapRecognizer.addPointer(event);
      } else if (_onScrollLeft != null) {
        _dragRecognizer.addPointer(event);
      }
    } else if (_onScrollLeft != null && event is PointerPanZoomStartEvent) {
      _dragRecognizer.addPointerPanZoom(event);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    final indentDepth = _hitDepth(details.localPosition);
    if (indentDepth == _indentDepth) {
      onTapLine?.call();
    } else if (indentDepth != -1) {
      onTapDot?.call(indentDepth);
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragDelta = clampDouble(_dragDelta + details.delta.dx, -dragMaxOffset, 0);
    markNeedsPaint();
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragDelta <= indentStep - dragMaxOffset) {
      _onScrollLeft?.call();
    }
    _dragDelta = 0;
    markNeedsPaint();
  }

  void _handleDragCancel() {
    _dragDelta = 0;
    markNeedsPaint();
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    _dragRecognizer.dispose();
    super.dispose();
  }
}

extension<T> on List<T> {
  T elementAtLoop(int index) {
    assert(isNotEmpty);
    return this[index % length];
  }
}

extension on BoxConstraints {
  BoxConstraints deflateWidth(double width) {
    final double deflatedMinWidth = math.max(0.0, minWidth - width);
    return BoxConstraints(
      minWidth: deflatedMinWidth,
      maxWidth: math.max(deflatedMinWidth, maxWidth - width),
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }
}
