import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MarqueeText extends StatelessWidget {
  final double maxWidth;
  final String text;
  final TextStyle? style;

  const MarqueeText(
    this.text, {
    required this.maxWidth,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: maxWidth);
    final child = Text(
      text,
      style: style,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    if (textPainter.didExceedMaxLines) {
      return SingleWidgetMarquee(
        child,
        duration: const Duration(seconds: 5),
        bounce: true,
      );
    } else {
      return child;
    }
  }
}

class SingleWidgetMarquee extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final bool bounce;
  final double spacing;

  const SingleWidgetMarquee(
    this.child, {
    super.key,
    this.duration,
    this.bounce = false,
    this.spacing = 0,
  });

  @override
  State<StatefulWidget> createState() => _SingleWidgetMarqueeState();
}

class _SingleWidgetMarqueeState extends State<SingleWidgetMarquee>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    reverseDuration: widget.duration,
  )..repeat(reverse: widget.bounce);

  @override
  Widget build(BuildContext context) => widget.bounce
      ? BounceMarquee(
          animation: _controller,
          spacing: widget.spacing,
          child: widget.child,
        )
      : NormalMarquee(
          animation: _controller,
          spacing: widget.spacing,
          child: widget.child,
        );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

abstract class Marquee extends SingleChildRenderObjectWidget {
  final Axis direction;
  final Clip clipBehavior;
  final double spacing;
  final Animation<double> animation;

  const Marquee({
    super.key,
    required this.animation,
    required super.child,
    this.direction = Axis.horizontal,
    this.clipBehavior = Clip.hardEdge,
    this.spacing = 0,
  });

  @override
  void updateRenderObject(
    BuildContext context,
    covariant MarqueeRender renderObject,
  ) {
    renderObject
      ..direction = direction
      ..clipBehavior = clipBehavior
      ..animation = animation
      ..spacing = spacing;
  }
}

class NormalMarquee extends Marquee {
  const NormalMarquee({
    super.key,
    required super.animation,
    required super.child,
    super.direction,
    super.clipBehavior,
    super.spacing,
  });

  @override
  RenderObject createRenderObject(BuildContext context) => _NormalMarqueeRender(
    direction: direction,
    animation: animation,
    clipBehavior: clipBehavior,
    spacing: spacing,
  );
}

class BounceMarquee extends Marquee {
  const BounceMarquee({
    super.key,
    required super.animation,
    required super.child,
    super.direction,
    super.clipBehavior,
    super.spacing,
  });

  @override
  RenderObject createRenderObject(BuildContext context) => _BounceMarqueeRender(
    direction: direction,
    animation: animation,
    clipBehavior: clipBehavior,
    spacing: spacing,
  );
}

abstract class MarqueeRender extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  MarqueeRender({
    required Axis direction,
    required Animation<double> animation,
    required this.clipBehavior,
    required this.spacing,
  }) : _direction = direction,
       _animation = animation,
       assert(spacing.isFinite && !spacing.isNaN);

  Clip clipBehavior;
  double spacing;

  Axis _direction;
  Axis get direction => _direction;
  set direction(Axis value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  Animation<double> _animation;
  Animation<double> get animation => _animation;
  set animation(Animation<double> value) {
    if (_animation == value) return;
    if (_listened) {
      _animation.removeListener(markNeedsPaint);
      value.addListener(markNeedsPaint);
    }
    _animation = value;
  }

  @override
  void detach() {
    _removeListener();
    super.detach();
  }

  bool _listened = false;
  void _addListener() {
    if (!_listened) {
      _animation.addListener(markNeedsPaint);
      _listened = true;
    }
  }

  void _removeListener() {
    if (_listened) {
      _animation.removeListener(markNeedsPaint);
      _listened = false;
    }
  }

  late double _distance;

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }

    if (_direction == Axis.horizontal) {
      child.layout(
        BoxConstraints(maxHeight: constraints.maxHeight),
        parentUsesSize: true,
      );
      size = constraints.constrain(child.size);
      _distance = child.size.width - size.width;
      if (spacing.isNegative) spacing *= -size.width;
    } else {
      child.layout(
        BoxConstraints(maxWidth: constraints.maxWidth),
        parentUsesSize: true,
      );
      size = constraints.constrain(child.size);
      _distance = child.size.height - size.height;
      if (spacing.isNegative) spacing *= -size.height;
    }
    if (_distance > 0) {
      _addListener();
    } else {
      _removeListener();
    }
  }

  @override
  bool get isRepaintBoundary => true;

  void paintCenter(PaintingContext context, Offset offset) {
    if (_direction == Axis.horizontal) {
      context.paintChild(child!, Offset(offset.dx - _distance / 2, offset.dy));
    } else {
      context.paintChild(child!, Offset(offset.dx, offset.dy - _distance / 2));
    }
  }
}

class _BounceMarqueeRender extends MarqueeRender {
  _BounceMarqueeRender({
    required super.direction,
    required super.animation,
    required super.clipBehavior,
    required super.spacing,
  });

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final tick = _animation.value;

    if (_distance > 0) {
      final helfSpacing = spacing / 2.0;
      void paintChild() {
        if (_direction == Axis.horizontal) {
          context.paintChild(
            child!,
            Offset(
              offset.dx + helfSpacing - tick * (_distance + spacing),
              offset.dy,
            ),
          );
        } else {
          context.paintChild(
            child!,
            Offset(
              offset.dx,
              offset.dy + helfSpacing - tick * (_distance + spacing),
            ),
          );
        }
      }

      if (clipBehavior == Clip.none) {
        paintChild();
      } else {
        final rect = Rect.fromLTRB(0, 0, size.width, size.height);
        context.clipRectAndPaint(rect, clipBehavior, rect, paintChild);
      }
    } else {
      paintCenter(context, offset);
    }
  }
}

class _NormalMarqueeRender extends MarqueeRender {
  _NormalMarqueeRender({
    required super.direction,
    required super.animation,
    required super.clipBehavior,
    required super.spacing,
  });

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null) return;

    final tick = _animation.value;

    if (_distance > 0) {
      void paintChild() {
        if (_direction == Axis.horizontal) {
          final w = child.size.width + spacing;
          final dx = tick * w;
          context.paintChild(child, Offset(offset.dx - dx, offset.dy));
          if (dx > _distance) {
            context.paintChild(child, Offset(offset.dx + w - dx, offset.dy));
          }
        } else {
          final h = child.size.height + spacing;
          final dy = tick * h;
          context.paintChild(child, Offset(offset.dx, offset.dy - dy));
          if (dy > _distance) {
            context.paintChild(child, Offset(offset.dx, offset.dy + h - dy));
          }
        }
      }

      if (clipBehavior == Clip.none) {
        paintChild();
      } else {
        final rect = Rect.fromLTRB(0, 0, size.width, size.height);
        context.clipRectAndPaint(rect, clipBehavior, rect, paintChild);
      }
    } else {
      paintCenter(context, offset);
    }
  }
}
