import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:flutter/rendering.dart'
    show ClipRectLayer, LayerHandle, RenderAnimatedSize, RenderProxyBox;
import 'package:material_ui/material_ui.dart';

typedef Heights = ({double from, double to});

/// ref [AnimatedSize]

class AnimatedHeightWidgetExt extends AnimatedHeightWidget {
  const AnimatedHeightWidgetExt({
    super.key,
    required super.child,
    super.curve,
    required super.duration,
    super.reverseDuration,
    super.clipBehavior,
    required super.expand,
  });

  @override
  State<AnimatedHeightWidget> createState() => _AnimatedHeightWidgetExtState();
}

class _AnimatedHeightWidgetExtState extends _AnimatedHeightWidgetState {
  @override
  Widget build(BuildContext context) {
    return AnimatedHeightExt(
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

class AnimatedHeightExt extends AnimatedHeight {
  const AnimatedHeightExt({
    super.key,
    required super.child,
    super.curve,
    required super.duration,
    super.reverseDuration,
    required super.vsync,
    super.clipBehavior,
    required super.expand,
  });

  @override
  RenderAnimatedHeight createRenderObject(BuildContext context) {
    return RenderAnimatedHeightExt(
      duration: duration,
      reverseDuration: reverseDuration,
      curve: curve,
      vsync: vsync,
      clipBehavior: clipBehavior,
      expand: expand,
    );
  }
}

class RenderAnimatedHeightExt extends RenderAnimatedHeight {
  RenderAnimatedHeightExt({
    required super.vsync,
    required super.duration,
    super.reverseDuration,
    super.curve,
    super.clipBehavior,
    required super.expand,
  });

  bool get _isInvisible => !isAnimating && !expand;

  @override
  double animTo(Size childSize) => expand ? childSize.height : 0.0;

  @override
  void performLayout() {
    if (_isInvisible) {
      _heights = const (from: 0, to: 0);
      child!.layout(constraints);
      size = constraints.constrain(.zero);
      return;
    }

    super.performLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_isInvisible) {
      _clipRectLayer.layer = null;
      return;
    }

    super.paint(context, offset);
  }
}

class AnimatedHeightWidget extends StatefulWidget {
  const AnimatedHeightWidget({
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
  State<AnimatedHeightWidget> createState() => _AnimatedHeightWidgetState();
}

class _AnimatedHeightWidgetState extends State<AnimatedHeightWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedHeight(
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

class AnimatedHeight extends SingleChildRenderObjectWidget {
  const AnimatedHeight({
    super.key,
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

  double animTo(Size childSize) => childSize.height;

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;

    _lastValue = _controller.value;

    final childSize = (child!..layout(constraints, parentUsesSize: true)).size;

    final Size animatedSize;

    if (isAnimating && _heights != null) {
      final to = animTo(childSize);
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
