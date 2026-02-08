import 'dart:ui' as ui;

import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactive_viewer.dart'
    as custom;
import 'package:PiliPlus/common/widgets/only_layout_widget.dart';
import 'package:flutter/material.dart';

/// https://github.com/qq326646683/interactiveviewer_gallery

/// A callback for the [InteractiveViewerBoundary] that is called when the scale
/// changed.
typedef ScaleChanged = void Function(double scale);

/// Builds an [InteractiveViewer] and provides callbacks that are called when a
/// horizontal boundary has been hit.
///
/// The callbacks are called when an interaction ends by listening to the
/// [InteractiveViewer.onInteractionEnd] callback.
class InteractiveViewerBoundary extends StatefulWidget {
  const InteractiveViewerBoundary({
    super.key,
    required this.child,
    required this.boundaryWidth,
    required this.controller,
    required this.maxScale,
    required this.minScale,
    this.onDismissed,
    this.dismissThreshold = 0.2,
    this.onInteractionEnd,
  });

  final double dismissThreshold;
  final VoidCallback? onDismissed;

  final Widget child;

  /// The max width this widget can have.
  ///
  /// If the [InteractiveViewer] can take up the entire screen width, this
  /// should be set to `MediaQuery.of(context).size.width`.
  final double boundaryWidth;

  /// The [TransformationController] for the [InteractiveViewer].
  final TransformationController controller;

  final double maxScale;

  final double minScale;

  final GestureScaleEndCallback? onInteractionEnd;

  @override
  InteractiveViewerBoundaryState createState() =>
      InteractiveViewerBoundaryState();
}

class InteractiveViewerBoundaryState extends State<InteractiveViewerBoundary>
    with SingleTickerProviderStateMixin {
  late final TransformationController _controller;
  late final AnimationController _animateController;
  late final Animation<Decoration> _opacityAnimation;
  double dx = 0, dy = 0;

  Offset _offset = Offset.zero;
  bool _dragging = false;

  late Size _size;

  bool get _isActive => _dragging || _animateController.isAnimating;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    _animateController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _opacityAnimation = _animateController.drive(
      DecorationTween(
        begin: const BoxDecoration(color: Colors.black),
        end: const BoxDecoration(color: Colors.transparent),
      ),
    );

    _animateController.addListener(_updateTransformation);
  }

  void _updateTransformation() {
    final val = _animateController.value;
    final scale = ui.lerpDouble(1.0, 0.25, val)!;

    // Matrix4.identity()
    //   ..translateByDouble(size.width / 2, size.height / 2, 0, 1)
    //   ..translateByDouble(size.width * val * dx, size.height * val * dy, 0, 1)
    //   ..scaleByDouble(scale, scale, 1, 1)
    //   ..translateByDouble(-size.width / 2, -size.height / 2, 0, 1);

    final tmp = (1.0 - scale) / 2.0;
    _controller.value = Matrix4.diagonal3Values(scale, scale, scale)
      ..setTranslationRaw(
        _size.width * (val * dx + tmp),
        _size.height * (val * dy + tmp),
        0,
      );
  }

  void _updateMoveAnimation() {
    dy = _offset.dy.sign;
    if (dy == 0) {
      dx = 0;
    } else {
      dx = _offset.dx / _offset.dy.abs();
    }
  }

  void _handleDragStart(ScaleStartDetails details) {
    _dragging = true;

    if (_animateController.isAnimating) {
      _animateController.stop();
    } else {
      _offset = Offset.zero;
      _animateController.value = 0.0;
    }
    _updateMoveAnimation();
  }

  void _handleDragUpdate(ScaleUpdateDetails details) {
    if (!_isActive || _animateController.isAnimating) {
      return;
    }

    _offset += details.focalPointDelta;
    _updateMoveAnimation();

    if (!_animateController.isAnimating) {
      _animateController.value = _offset.dy.abs() / _size.height;
    }
  }

  void _handleDragEnd(ScaleEndDetails details) {
    if (!_isActive || _animateController.isAnimating) {
      return;
    }

    _dragging = false;

    if (_animateController.isCompleted) {
      return;
    }

    if (!_animateController.isDismissed) {
      // if the dragged value exceeded the dismissThreshold, call onDismissed
      // else animate back to initial position.
      if (_animateController.value > widget.dismissThreshold) {
        widget.onDismissed?.call();
      } else {
        _animateController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animateController
      ..removeListener(_updateTransformation)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutSizeWidget(
      onPerformLayout: (size) => _size = size,
      child: DecoratedBoxTransition(
        decoration: _opacityAnimation,
        child: custom.InteractiveViewer(
          maxScale: widget.maxScale,
          minScale: widget.minScale,
          transformationController: _controller,
          onPanStart: _handleDragStart,
          onPanUpdate: _handleDragUpdate,
          onPanEnd: _handleDragEnd,
          onInteractionEnd: widget.onInteractionEnd,
          isAnimating: () => _animateController.value != 0,
          child: widget.child,
        ),
      ),
    );
  }
}
