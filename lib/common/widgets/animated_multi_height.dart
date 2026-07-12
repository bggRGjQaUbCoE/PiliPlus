import 'package:PiliPlus/common/widgets/animated_height.dart' show Heights;
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show ClipRectLayer, LayerHandle, PipelineOwner, RenderProxyBox;

class AnimatedMultiHeight extends StatefulWidget {
  const AnimatedMultiHeight({
    super.key,
    required Widget this.child,
    this.curve = Curves.linear,
    required this.duration,
    this.reverseDuration,
    this.clipBehavior = .hardEdge,
    this.onEnd,
    required this.expand,
  });

  final Widget? child;
  final Curve curve;
  final Duration duration;
  final Duration? reverseDuration;
  final Clip clipBehavior;
  final VoidCallback? onEnd;
  final bool expand;

  @override
  State<AnimatedMultiHeight> createState() => _AnimatedMultiHeightState();
}

class _AnimatedMultiHeightState extends State<AnimatedMultiHeight>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return _AnimatedMultiHeight(
      curve: widget.curve,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
      clipBehavior: widget.clipBehavior,
      onEnd: widget.onEnd,
      expand: widget.expand,
      child: widget.child,
    );
  }
}

class _AnimatedMultiHeight extends SingleChildRenderObjectWidget {
  const _AnimatedMultiHeight({
    super.child,
    this.curve = Curves.linear,
    required this.duration,
    this.reverseDuration,
    required this.vsync,
    this.clipBehavior = .hardEdge,
    this.onEnd,
    required this.expand,
  });

  final Curve curve;
  final Duration duration;
  final Duration? reverseDuration;
  final TickerProvider vsync;
  final Clip clipBehavior;
  final VoidCallback? onEnd;
  final bool expand;

  @override
  RenderAnimatedMultiHeight createRenderObject(BuildContext context) {
    return RenderAnimatedMultiHeight(
      duration: duration,
      reverseDuration: reverseDuration,
      curve: curve,
      vsync: vsync,
      clipBehavior: clipBehavior,
      onEnd: onEnd,
      expand: expand,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderAnimatedMultiHeight renderObject,
  ) {
    renderObject
      ..duration = duration
      ..reverseDuration = reverseDuration
      ..curve = curve
      ..vsync = vsync
      ..clipBehavior = clipBehavior
      ..onEnd = onEnd
      ..expand = expand;
  }
}

class RenderAnimatedMultiHeight extends RenderProxyBox {
  RenderAnimatedMultiHeight({
    required TickerProvider vsync,
    required Duration duration,
    Duration? reverseDuration,
    this._curve = Curves.linear,
    this._clipBehavior = .hardEdge,
    this._onEnd,
    required this._expand,
  }) : _vsync = vsync {
    _controller =
        AnimationController(
          vsync: vsync,
          value: _expand ? 1.0 : 0.0,
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
    _controller.forward(from: 0.0);
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

  VoidCallback? get onEnd => _onEnd;
  VoidCallback? _onEnd;
  set onEnd(VoidCallback? value) {
    if (value == _onEnd) {
      return;
    }
    _onEnd = value;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _controller.addStatusListener(_animationStatusListener);
  }

  @override
  void detach() {
    _controller
      ..stop()
      ..removeStatusListener(_animationStatusListener);
    super.detach();
  }

  @override
  void performLayout() {
    _lastValue = _controller.value;

    final BoxConstraints constraints = this.constraints;
    final childSize = (child!..layout(constraints, parentUsesSize: true)).size;

    final Size animatedSize;
    if (isAnimating && _heights != null) {
      final to = childSize.height;
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

  void _animationStatusListener(AnimationStatus status) {
    if (status.isCompleted) {
      _onEnd?.call();
    }
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
