import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show ClipRectLayer, LayerHandle, RenderAnimatedSize, RenderProxyBox;

typedef Heights = ({double from, double to});

/// ref [AnimatedSize]
class AnimatedHeight extends StatefulWidget {
  const AnimatedHeight({
    super.key,
    required this.child,
    this.curve = Curves.linear,
    required this.duration,
    this.reverseDuration,
    this.clipBehavior = .hardEdge,
    required this.expand,
  });

  final Widget child;
  final Curve curve;
  final Duration duration;
  final Duration? reverseDuration;
  final Clip clipBehavior;
  final bool expand;

  @override
  State<AnimatedHeight> createState() => _AnimatedHeightState();
}

class _AnimatedHeightState extends State<AnimatedHeight>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return _AnimatedHeight(
      curve: widget.curve,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
      clipBehavior: widget.clipBehavior,
      expand: widget.expand,
      child: widget.child,
    );
  }
}

class _AnimatedHeight extends SingleChildRenderObjectWidget {
  const _AnimatedHeight({
    required Widget super.child,
    this.curve = Curves.linear,
    required this.duration,
    this.reverseDuration,
    required this.vsync,
    this.clipBehavior = .hardEdge,
    required this.expand,
  });

  final Curve curve;
  final Duration duration;
  final Duration? reverseDuration;
  final TickerProvider vsync;
  final Clip clipBehavior;
  final bool expand;

  @override
  RenderAnimatedHeight createRenderObject(BuildContext context) {
    return RenderAnimatedHeight(
      duration: duration,
      reverseDuration: reverseDuration,
      curve: curve,
      vsync: vsync,
      clipBehavior: clipBehavior,
      expand: expand,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderAnimatedHeight renderObject,
  ) {
    renderObject
      ..duration = duration
      ..reverseDuration = reverseDuration
      ..curve = curve
      ..vsync = vsync
      ..clipBehavior = clipBehavior
      ..expand = expand;
  }
}

/// ref [RenderAnimatedSize]
class RenderAnimatedHeight extends RenderProxyBox {
  RenderAnimatedHeight({
    required this._vsync,
    required Duration duration,
    Duration? reverseDuration,
    this._curve = Curves.linear,
    this._clipBehavior = .hardEdge,
    required this._expand,
  }) {
    _controller =
        AnimationController(
          vsync: vsync,
          value: expand ? 1.0 : 0.0,
          duration: duration,
          reverseDuration: reverseDuration,
        )..addListener(() {
          if (_controller.value != _lastValue) {
            markNeedsLayout();
          }
        });
  }

  bool _expand;
  bool get expand => _expand;
  set expand(bool value) {
    if (_expand == value) return;
    _expand = value;
    _lastValue = 0.0;
    _controller.forward(from: 0);
  }

  late final AnimationController _controller;
  bool get isAnimating => _controller.isAnimating;
  bool get _isInvisible => !isAnimating && !expand;

  double? _lastValue;
  Heights? _heights;

  Duration get duration => _controller.duration!;
  set duration(Duration value) {
    if (value == _controller.duration) {
      return;
    }
    _controller.duration = value;
  }

  Duration? get reverseDuration => _controller.reverseDuration;
  set reverseDuration(Duration? value) {
    if (value == _controller.reverseDuration) {
      return;
    }
    _controller.reverseDuration = value;
  }

  Curve _curve;
  Curve get curve => _curve;
  set curve(Curve value) {
    if (value == _curve) {
      return;
    }
    _curve = value;
  }

  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior = .hardEdge;
  set clipBehavior(Clip value) {
    if (value != _clipBehavior) {
      _clipBehavior = value;
      markNeedsPaint();
    }
  }

  TickerProvider get vsync => _vsync;
  TickerProvider _vsync;
  set vsync(TickerProvider value) {
    if (value == _vsync) {
      return;
    }
    _vsync = value;
    _controller.resync(vsync);
  }

  @override
  void detach() {
    _controller.stop();
    super.detach();
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;

    if (_isInvisible) {
      _heights = const (from: 0, to: 0);
      child!.layout(constraints);
      size = constraints.constrain(.zero);
      return;
    }

    _lastValue = _controller.value;

    final childSize = (child!..layout(constraints, parentUsesSize: true)).size;

    final Size animatedSize;

    if (isAnimating && _heights != null) {
      final to = expand ? childSize.height : 0.0;
      if (_heights!.to != to) {
        _heights = (from: size.height, to: to);
      }
      animatedSize = Size(
        childSize.width,
        curve.transform(_controller.value).lerp(_heights!.from, _heights!.to),
      );
    } else {
      animatedSize = childSize;
      _heights = (from: childSize.height, to: childSize.height);
    }

    size = constraints.constrain(animatedSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_isInvisible) {
      _clipRectLayer.layer = null;
      return;
    }

    if (isAnimating && clipBehavior != .none) {
      final Rect rect = Offset.zero & size;
      _clipRectLayer.layer = context.pushClipRect(
        needsCompositing,
        offset,
        rect,
        super.paint,
        clipBehavior: clipBehavior,
        oldLayer: _clipRectLayer.layer,
      );
    } else {
      _clipRectLayer.layer = null;
      super.paint(context, offset);
    }
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    _controller.dispose();
    super.dispose();
  }
}
