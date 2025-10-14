// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' show Quad, Vector3;

class MouseInteractiveViewer extends StatefulWidget {
  const MouseInteractiveViewer({
    super.key,
    this.clipBehavior = Clip.hardEdge,
    this.panAxis = PanAxis.free,
    this.boundaryMargin = EdgeInsets.zero,
    this.constrained = true,
    this.maxScale = 2.5,
    this.minScale = 0.8,
    this.interactionEndFrictionCoefficient = _kDrag,
    this.pointerSignalFallback,
    this.onPointerPanZoomUpdate,
    this.onPointerPanZoomEnd,
    this.onPointerDown,
    this.onInteractionEnd,
    this.onInteractionStart,
    this.onInteractionUpdate,
    this.panEnabled = true,
    this.scaleEnabled = true,
    this.scaleFactor = kDefaultMouseScrollToScaleFactor,
    this.transformationController,
    this.alignment,
    this.trackpadScrollCausesScale = false,

    required this.childKey,
    required this.child,
  }) : assert(minScale > 0),
       assert(interactionEndFrictionCoefficient > 0),
       assert(maxScale > 0),
       assert(maxScale >= minScale);

  final Alignment? alignment;
  final Clip clipBehavior;
  final PanAxis panAxis;
  final EdgeInsets boundaryMargin;
  final Widget child;
  final bool constrained;
  final bool panEnabled;
  final bool scaleEnabled;
  final bool trackpadScrollCausesScale;
  final double scaleFactor;
  final double maxScale;
  final double minScale;
  final double interactionEndFrictionCoefficient;
  final PointerSignalEventListener? pointerSignalFallback;
  final PointerPanZoomUpdateEventListener? onPointerPanZoomUpdate;
  final PointerPanZoomEndEventListener? onPointerPanZoomEnd;
  final PointerDownEventListener? onPointerDown;
  final GestureScaleEndCallback? onInteractionEnd;
  final GestureScaleStartCallback? onInteractionStart;
  final GestureScaleUpdateCallback? onInteractionUpdate;
  final TransformationController? transformationController;
  final GlobalKey childKey;

  static const double _kDrag = 0.0000135;

  @override
  State<MouseInteractiveViewer> createState() => _MouseInteractiveViewerState();
}

class _MouseInteractiveViewerState extends State<MouseInteractiveViewer>
    with TickerProviderStateMixin {
  late TransformationController _transformer =
      widget.transformationController ?? TransformationController();

  final GlobalKey _parentKey = GlobalKey();
  Animation<Offset>? _animation;
  Animation<double>? _scaleAnimation;
  late Offset _scaleAnimationFocalPoint;
  late AnimationController _controller;
  late AnimationController _scaleController;
  Axis? _currentAxis;
  Offset? _referenceFocalPoint;
  double? _scaleStart;
  double? _rotationStart = 0.0;
  double _currentRotation = 0.0;
  _GestureType? _gestureType;

  static final gestureSettings = DeviceGestureSettings(
    touchSlop: Platform.isIOS ? 9 : 4,
  );

  late final _scaleGestureRecognizer =
      ScaleGestureRecognizer(
          debugOwner: this,
          allowedButtonsFilter: (buttons) => buttons == kPrimaryButton,
          trackpadScrollToScaleFactor: Offset(0, -1 / widget.scaleFactor),
          trackpadScrollCausesScale: widget.trackpadScrollCausesScale,
        )
        ..gestureSettings = gestureSettings
        ..onStart = _onScaleStart
        ..onUpdate = _onScaleUpdate
        ..onEnd = _onScaleEnd;

  final bool _rotateEnabled = false;

  Rect get _boundaryRect {
    assert(widget.childKey.currentContext != null);
    final RenderBox childRenderBox =
        widget.childKey.currentContext!.findRenderObject()! as RenderBox;
    final Size childSize = childRenderBox.size;
    final Rect boundaryRect = widget.boundaryMargin.inflateRect(
      Offset.zero & childSize,
    );
    assert(
      !boundaryRect.isEmpty,
      "InteractiveViewer's child must have nonzero dimensions.",
    );
    assert(
      boundaryRect.isFinite ||
          (boundaryRect.left.isInfinite &&
              boundaryRect.top.isInfinite &&
              boundaryRect.right.isInfinite &&
              boundaryRect.bottom.isInfinite),
      'boundaryRect must either be infinite in all directions or finite in all directions.',
    );
    return boundaryRect;
  }

  Rect get _viewport {
    assert(_parentKey.currentContext != null);
    final RenderBox parentRenderBox =
        _parentKey.currentContext!.findRenderObject()! as RenderBox;
    return Offset.zero & parentRenderBox.size;
  }

  Matrix4 _matrixTranslate(Matrix4 matrix, Offset translation) {
    if (translation == Offset.zero) {
      return matrix.clone();
    }

    final Offset alignedTranslation;

    if (_currentAxis != null) {
      alignedTranslation = switch (widget.panAxis) {
        PanAxis.horizontal => _alignAxis(translation, Axis.horizontal),
        PanAxis.vertical => _alignAxis(translation, Axis.vertical),
        PanAxis.aligned => _alignAxis(translation, _currentAxis!),
        PanAxis.free => translation,
      };
    } else {
      alignedTranslation = translation;
    }

    final Matrix4 nextMatrix = matrix.clone()
      ..translateByDouble(alignedTranslation.dx, alignedTranslation.dy, 0, 1);

    final Quad nextViewport = _transformViewport(nextMatrix, _viewport);

    if (_boundaryRect.isInfinite) {
      return nextMatrix;
    }

    final Quad boundariesAabbQuad = _getAxisAlignedBoundingBoxWithRotation(
      _boundaryRect,
      _currentRotation,
    );

    final Offset offendingDistance = _exceedsBy(
      boundariesAabbQuad,
      nextViewport,
    );
    if (offendingDistance == Offset.zero) {
      return nextMatrix;
    }

    final Offset nextTotalTranslation = _getMatrixTranslation(nextMatrix);
    final double currentScale = matrix.getMaxScaleOnAxis();
    final Offset correctedTotalTranslation = Offset(
      nextTotalTranslation.dx - offendingDistance.dx * currentScale,
      nextTotalTranslation.dy - offendingDistance.dy * currentScale,
    );
    final Matrix4 correctedMatrix = matrix.clone()
      ..setTranslation(
        Vector3(
          correctedTotalTranslation.dx,
          correctedTotalTranslation.dy,
          0.0,
        ),
      );

    final Quad correctedViewport = _transformViewport(
      correctedMatrix,
      _viewport,
    );
    final Offset offendingCorrectedDistance = _exceedsBy(
      boundariesAabbQuad,
      correctedViewport,
    );
    if (offendingCorrectedDistance == Offset.zero) {
      return correctedMatrix;
    }

    if (offendingCorrectedDistance.dx != 0.0 &&
        offendingCorrectedDistance.dy != 0.0) {
      return matrix.clone();
    }

    final Offset unidirectionalCorrectedTotalTranslation = Offset(
      offendingCorrectedDistance.dx == 0.0 ? correctedTotalTranslation.dx : 0.0,
      offendingCorrectedDistance.dy == 0.0 ? correctedTotalTranslation.dy : 0.0,
    );
    return matrix.clone()..setTranslation(
      Vector3(
        unidirectionalCorrectedTotalTranslation.dx,
        unidirectionalCorrectedTotalTranslation.dy,
        0.0,
      ),
    );
  }

  Matrix4 _matrixScale(Matrix4 matrix, double scale) {
    if (scale == 1.0) {
      return matrix.clone();
    }
    assert(scale != 0.0);

    final double currentScale = _transformer.value.getMaxScaleOnAxis();
    final double totalScale = math.max(
      currentScale * scale,
      math.max(
        _viewport.width / _boundaryRect.width,
        _viewport.height / _boundaryRect.height,
      ),
    );
    final double clampedTotalScale = clampDouble(
      totalScale,
      widget.minScale,
      widget.maxScale,
    );
    final double clampedScale = clampedTotalScale / currentScale;
    return matrix.clone()
      ..scaleByDouble(clampedScale, clampedScale, clampedScale, 1);
  }

  Matrix4 _matrixRotate(Matrix4 matrix, double rotation, Offset focalPoint) {
    if (rotation == 0) {
      return matrix.clone();
    }
    final Offset focalPointScene = _transformer.toScene(focalPoint);
    return matrix.clone()
      ..translateByDouble(focalPointScene.dx, focalPointScene.dy, 0, 1)
      ..rotateZ(-rotation)
      ..translateByDouble(-focalPointScene.dx, -focalPointScene.dy, 0, 1);
  }

  bool _gestureIsSupported(_GestureType? gestureType) {
    return switch (gestureType) {
      _GestureType.rotate => _rotateEnabled,
      _GestureType.scale => widget.scaleEnabled,
      _GestureType.pan || null => widget.panEnabled,
    };
  }

  _GestureType _getGestureType(ScaleUpdateDetails details) {
    final double scale = !widget.scaleEnabled ? 1.0 : details.scale;
    final double rotation = !_rotateEnabled ? 0.0 : details.rotation;
    if ((scale - 1).abs() > rotation.abs()) {
      return _GestureType.scale;
    } else if (rotation != 0.0) {
      return _GestureType.rotate;
    } else {
      return _GestureType.pan;
    }
  }

  // Handle the start of a gesture. All of pan, scale, and rotate are handled
  // with GestureDetector's scale gesture.
  void _onScaleStart(ScaleStartDetails details) {
    widget.onInteractionStart?.call(details);

    if (_controller.isAnimating) {
      _controller
        ..stop()
        ..reset();
      _animation?.removeListener(_handleInertiaAnimation);
      _animation = null;
    }
    if (_scaleController.isAnimating) {
      _scaleController
        ..stop()
        ..reset();
      _scaleAnimation?.removeListener(_handleScaleAnimation);
      _scaleAnimation = null;
    }

    _gestureType = null;
    _currentAxis = null;
    _scaleStart = _transformer.value.getMaxScaleOnAxis();
    _referenceFocalPoint = _transformer.toScene(details.localFocalPoint);
    _rotationStart = _currentRotation;
  }

  // Handle an update to an ongoing gesture. All of pan, scale, and rotate are
  // handled with GestureDetector's scale gesture.
  void _onScaleUpdate(ScaleUpdateDetails details) {
    final double scale = _transformer.value.getMaxScaleOnAxis();
    _scaleAnimationFocalPoint = details.localFocalPoint;
    final Offset focalPointScene = _transformer.toScene(
      details.localFocalPoint,
    );

    if (_gestureType == _GestureType.pan) {
      // When a gesture first starts, it sometimes has no change in scale and
      // rotation despite being a two-finger gesture. Here the gesture is
      // allowed to be reinterpreted as its correct type after originally
      // being marked as a pan.
      _gestureType = _getGestureType(details);
    } else {
      _gestureType ??= _getGestureType(details);
    }
    if (!_gestureIsSupported(_gestureType)) {
      widget.onInteractionUpdate?.call(details);
      return;
    }

    switch (_gestureType!) {
      case _GestureType.scale:
        assert(_scaleStart != null);
        // details.scale gives us the amount to change the scale as of the
        // start of this gesture, so calculate the amount to scale as of the
        // previous call to _onScaleUpdate.
        final double desiredScale = _scaleStart! * details.scale;
        final double scaleChange = desiredScale / scale;
        _transformer.value = _matrixScale(_transformer.value, scaleChange);

        // While scaling, translate such that the user's two fingers stay on
        // the same places in the scene. That means that the focal point of
        // the scale should be on the same place in the scene before and after
        // the scale.
        final Offset focalPointSceneScaled = _transformer.toScene(
          details.localFocalPoint,
        );
        _transformer.value = _matrixTranslate(
          _transformer.value,
          focalPointSceneScaled - _referenceFocalPoint!,
        );

        // details.localFocalPoint should now be at the same location as the
        // original _referenceFocalPoint point. If it's not, that's because
        // the translate came in contact with a boundary. In that case, update
        // _referenceFocalPoint so subsequent updates happen in relation to
        // the new effective focal point.
        final Offset focalPointSceneCheck = _transformer.toScene(
          details.localFocalPoint,
        );
        if (_round(_referenceFocalPoint!) != _round(focalPointSceneCheck)) {
          _referenceFocalPoint = focalPointSceneCheck;
        }

      case _GestureType.rotate:
        if (details.rotation == 0.0) {
          widget.onInteractionUpdate?.call(details);
          return;
        }
        final double desiredRotation = _rotationStart! + details.rotation;
        _transformer.value = _matrixRotate(
          _transformer.value,
          _currentRotation - desiredRotation,
          details.localFocalPoint,
        );
        _currentRotation = desiredRotation;

      case _GestureType.pan:
        assert(_referenceFocalPoint != null);
        // details may have a change in scale here when scaleEnabled is false.
        // In an effort to keep the behavior similar whether or not scaleEnabled
        // is true, these gestures are thrown away.
        if (details.scale != 1.0) {
          widget.onInteractionUpdate?.call(details);
          return;
        }
        _currentAxis ??= _getPanAxis(_referenceFocalPoint!, focalPointScene);
        // Translate so that the same point in the scene is underneath the
        // focal point before and after the movement.
        final Offset translationChange =
            focalPointScene - _referenceFocalPoint!;
        _transformer.value = _matrixTranslate(
          _transformer.value,
          translationChange,
        );
        _referenceFocalPoint = _transformer.toScene(details.localFocalPoint);
    }
    widget.onInteractionUpdate?.call(details);
  }

  // Handle the end of a gesture of _GestureType. All of pan, scale, and rotate
  // are handled with GestureDetector's scale gesture.
  void _onScaleEnd(ScaleEndDetails details) {
    widget.onInteractionEnd?.call(details);
    _scaleStart = null;
    _rotationStart = null;
    _referenceFocalPoint = null;

    _animation?.removeListener(_handleInertiaAnimation);
    _scaleAnimation?.removeListener(_handleScaleAnimation);
    _controller.reset();
    _scaleController.reset();

    if (!_gestureIsSupported(_gestureType)) {
      _currentAxis = null;
      return;
    }

    switch (_gestureType) {
      case _GestureType.pan:
        if (details.velocity.pixelsPerSecond.distance < kMinFlingVelocity) {
          _currentAxis = null;
          return;
        }
        final Vector3 translationVector = _transformer.value.getTranslation();
        final Offset translation = Offset(
          translationVector.x,
          translationVector.y,
        );
        final FrictionSimulation frictionSimulationX = FrictionSimulation(
          widget.interactionEndFrictionCoefficient,
          translation.dx,
          details.velocity.pixelsPerSecond.dx,
        );
        final FrictionSimulation frictionSimulationY = FrictionSimulation(
          widget.interactionEndFrictionCoefficient,
          translation.dy,
          details.velocity.pixelsPerSecond.dy,
        );
        final double tFinal = _getFinalTime(
          details.velocity.pixelsPerSecond.distance,
          widget.interactionEndFrictionCoefficient,
        );
        _animation =
            Tween<Offset>(
                begin: translation,
                end: Offset(
                  frictionSimulationX.finalX,
                  frictionSimulationY.finalX,
                ),
              ).animate(
                CurvedAnimation(parent: _controller, curve: Curves.decelerate),
              )
              ..addListener(_handleInertiaAnimation);
        _controller
          ..duration = Duration(milliseconds: (tFinal * 1000).round())
          ..forward();
      case _GestureType.scale:
        if (details.scaleVelocity.abs() < 0.1) {
          _currentAxis = null;
          return;
        }
        final double scale = _transformer.value.getMaxScaleOnAxis();
        final FrictionSimulation frictionSimulation = FrictionSimulation(
          widget.interactionEndFrictionCoefficient * widget.scaleFactor,
          scale,
          details.scaleVelocity / 10,
        );
        final double tFinal = _getFinalTime(
          details.scaleVelocity.abs(),
          widget.interactionEndFrictionCoefficient,
          effectivelyMotionless: 0.1,
        );
        _scaleAnimation =
            Tween<double>(
                begin: scale,
                end: frictionSimulation.x(tFinal),
              ).animate(
                CurvedAnimation(
                  parent: _scaleController,
                  curve: Curves.decelerate,
                ),
              )
              ..addListener(_handleScaleAnimation);
        _scaleController
          ..duration = Duration(milliseconds: (tFinal * 1000).round())
          ..forward();
      case _GestureType.rotate || null:
        break;
    }
  }

  void _receivedPointerSignal(PointerSignalEvent event) {
    final Offset local = event.localPosition;
    final Offset global = event.position;
    final double scaleChange;
    if (event is PointerScrollEvent) {
      if (event.kind == PointerDeviceKind.trackpad) {
        widget.onInteractionStart?.call(
          ScaleStartDetails(focalPoint: global, localFocalPoint: local),
        );

        final Offset localDelta = PointerEvent.transformDeltaViaPositions(
          untransformedEndPosition: global + event.scrollDelta,
          untransformedDelta: event.scrollDelta,
          transform: event.transform,
        );

        final Offset focalPointScene = _transformer.toScene(local);
        final Offset newFocalPointScene = _transformer.toScene(
          local - localDelta,
        );

        _transformer.value = _matrixTranslate(
          _transformer.value,
          newFocalPointScene - focalPointScene,
        );

        widget.onInteractionUpdate?.call(
          ScaleUpdateDetails(
            focalPoint: global - event.scrollDelta,
            localFocalPoint: local - localDelta,
            focalPointDelta: -localDelta,
          ),
        );
        widget.onInteractionEnd?.call(ScaleEndDetails());
        return;
      }
      _handlePointerScrollEvent(event);
      return;
    } else if (event is PointerScaleEvent) {
      scaleChange = event.scale;
    } else {
      return;
    }
    widget.onInteractionStart?.call(
      ScaleStartDetails(focalPoint: global, localFocalPoint: local),
    );

    if (!_gestureIsSupported(_GestureType.scale)) {
      widget.onInteractionUpdate?.call(
        ScaleUpdateDetails(
          focalPoint: global,
          localFocalPoint: local,
          scale: scaleChange,
        ),
      );
      widget.onInteractionEnd?.call(ScaleEndDetails());
      return;
    }

    final Offset focalPointScene = _transformer.toScene(local);
    _transformer.value = _matrixScale(_transformer.value, scaleChange);

    // After scaling, translate such that the event's position is at the
    // same scene point before and after the scale.
    final Offset focalPointSceneScaled = _transformer.toScene(local);
    _transformer.value = _matrixTranslate(
      _transformer.value,
      focalPointSceneScaled - focalPointScene,
    );

    widget.onInteractionUpdate?.call(
      ScaleUpdateDetails(
        focalPoint: global,
        localFocalPoint: local,
        scale: scaleChange,
      ),
    );
    widget.onInteractionEnd?.call(ScaleEndDetails());
  }

  void _handlePointerScrollEvent(PointerScrollEvent event) {
    final Offset local = event.localPosition;
    final Offset global = event.position;

    if (_gestureIsSupported(_GestureType.scale)) {
      late final shift = HardwareKeyboard.instance.isShiftPressed;
      if (HardwareKeyboard.instance.isControlPressed) {
        _handleMouseWheelScale(event, local, global);
        return;
      } else if (shift || HardwareKeyboard.instance.isAltPressed) {
        _handleMouseWheelPanAsScale(event, local, global, shift);
        return;
      } else {
        widget.pointerSignalFallback?.call(event);
      }
    }
    widget.onInteractionUpdate?.call(
      ScaleUpdateDetails(
        focalPoint: global,
        localFocalPoint: local,
        scale: math.exp(-event.scrollDelta.dy / widget.scaleFactor),
      ),
    );
    widget.onInteractionEnd?.call(ScaleEndDetails());
  }

  void _handleMouseWheelScale(
    PointerScrollEvent event,
    Offset local,
    Offset global,
  ) {
    final double scaleChange = math.exp(
      -event.scrollDelta.dy / widget.scaleFactor,
    );
    final Offset focalPointScene = _transformer.toScene(local);
    _transformer.value = _matrixScale(_transformer.value, scaleChange);

    final Offset focalPointSceneScaled = _transformer.toScene(local);
    _transformer.value = _matrixTranslate(
      _transformer.value,
      focalPointSceneScaled - focalPointScene,
    );

    widget.onInteractionUpdate?.call(
      ScaleUpdateDetails(
        focalPoint: global,
        localFocalPoint: local,
        scale: scaleChange,
      ),
    );
    widget.onInteractionEnd?.call(ScaleEndDetails());
  }

  void _handleMouseWheelPanAsScale(
    PointerScrollEvent event,
    Offset local,
    Offset global,
    bool flip,
  ) {
    final Offset translation = flip
        ? event.scrollDelta.flip
        : event.scrollDelta;

    final Offset focalPointScene = _transformer.toScene(local);
    final Offset newFocalPointScene = _transformer.toScene(local - translation);

    _transformer.value = _matrixTranslate(
      _transformer.value,
      newFocalPointScene - focalPointScene,
    );
  }

  void _handleInertiaAnimation() {
    if (!_controller.isAnimating) {
      _currentAxis = null;
      _animation?.removeListener(_handleInertiaAnimation);
      _animation = null;
      _controller.reset();
      return;
    }
    final Vector3 translationVector = _transformer.value.getTranslation();
    final Offset translation = Offset(translationVector.x, translationVector.y);
    _transformer.value = _matrixTranslate(
      _transformer.value,
      _transformer.toScene(_animation!.value) -
          _transformer.toScene(translation),
    );
  }

  void _handleScaleAnimation() {
    if (!_scaleController.isAnimating) {
      _currentAxis = null;
      _scaleAnimation?.removeListener(_handleScaleAnimation);
      _scaleAnimation = null;
      _scaleController.reset();
      return;
    }
    final double desiredScale = _scaleAnimation!.value;
    final double scaleChange =
        desiredScale / _transformer.value.getMaxScaleOnAxis();
    final Offset referenceFocalPoint = _transformer.toScene(
      _scaleAnimationFocalPoint,
    );
    _transformer.value = _matrixScale(_transformer.value, scaleChange);

    final Offset focalPointSceneScaled = _transformer.toScene(
      _scaleAnimationFocalPoint,
    );
    _transformer.value = _matrixTranslate(
      _transformer.value,
      focalPointSceneScaled - referenceFocalPoint,
    );
  }

  void _handleTransformation() {
    setState(() {});
  }

  void _onPointerDown(PointerDownEvent event) {
    widget.onPointerDown?.call(event);
    _scaleGestureRecognizer.addPointer(event);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scaleController = AnimationController(vsync: this);

    _transformer.addListener(_handleTransformation);
  }

  @override
  void didUpdateWidget(MouseInteractiveViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final TransformationController? newController =
        widget.transformationController;
    if (newController == oldWidget.transformationController) {
      return;
    }
    _transformer.removeListener(_handleTransformation);
    if (oldWidget.transformationController == null) {
      _transformer.dispose();
    }
    _transformer = newController ?? TransformationController();
    _transformer.addListener(_handleTransformation);
  }

  @override
  void dispose() {
    _scaleGestureRecognizer.dispose();
    _controller.dispose();
    _scaleController.dispose();
    _transformer.removeListener(_handleTransformation);
    if (widget.transformationController == null) {
      _transformer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.child.key == widget.childKey);

    return Listener(
      key: _parentKey,
      behavior: HitTestBehavior.opaque,
      onPointerSignal: _receivedPointerSignal,
      onPointerDown: _onPointerDown,
      onPointerPanZoomStart: _scaleGestureRecognizer.addPointerPanZoom,
      onPointerPanZoomUpdate: widget.onPointerPanZoomUpdate,
      onPointerPanZoomEnd: widget.onPointerPanZoomEnd,
      child: _InteractiveViewerBuilt(
        childKey: widget.childKey,
        clipBehavior: widget.clipBehavior,
        constrained: widget.constrained,
        matrix: _transformer.value,
        alignment: widget.alignment,
        child: widget.child,
      ),
    );
  }
}

class _InteractiveViewerBuilt extends StatelessWidget {
  const _InteractiveViewerBuilt({
    required this.child,
    required this.childKey,
    required this.clipBehavior,
    required this.constrained,
    required this.matrix,
    required this.alignment,
  });

  final Widget child;
  final GlobalKey childKey;
  final Clip clipBehavior;
  final bool constrained;
  final Matrix4 matrix;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    Widget child = Transform(
      transform: matrix,
      alignment: alignment,
      child: this.child,
    );

    if (!constrained) {
      child = OverflowBox(
        alignment: Alignment.topLeft,
        minWidth: 0.0,
        minHeight: 0.0,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: child,
      );
    }

    if (clipBehavior != Clip.none) {
      child = ClipRect(clipBehavior: clipBehavior, child: child);
    }

    return child;
  }
}

enum _GestureType { pan, scale, rotate }

double _getFinalTime(
  double velocity,
  double drag, {
  double effectivelyMotionless = 10,
}) {
  return math.log(effectivelyMotionless / velocity) / math.log(drag / 100);
}

Offset _getMatrixTranslation(Matrix4 matrix) {
  final Vector3 nextTranslation = matrix.getTranslation();
  return Offset(nextTranslation.x, nextTranslation.y);
}

Quad _transformViewport(Matrix4 matrix, Rect viewport) {
  final Matrix4 inverseMatrix = matrix.clone()..invert();
  return Quad.points(
    inverseMatrix.transform3(
      Vector3(viewport.topLeft.dx, viewport.topLeft.dy, 0.0),
    ),
    inverseMatrix.transform3(
      Vector3(viewport.topRight.dx, viewport.topRight.dy, 0.0),
    ),
    inverseMatrix.transform3(
      Vector3(viewport.bottomRight.dx, viewport.bottomRight.dy, 0.0),
    ),
    inverseMatrix.transform3(
      Vector3(viewport.bottomLeft.dx, viewport.bottomLeft.dy, 0.0),
    ),
  );
}

Quad _getAxisAlignedBoundingBoxWithRotation(Rect rect, double rotation) {
  final Matrix4 rotationMatrix = Matrix4.identity()
    ..translateByDouble(rect.size.width / 2, rect.size.height / 2, 0, 1)
    ..rotateZ(rotation)
    ..translateByDouble(-rect.size.width / 2, -rect.size.height / 2, 0, 1);
  final Quad boundariesRotated = Quad.points(
    rotationMatrix.transform3(Vector3(rect.left, rect.top, 0.0)),
    rotationMatrix.transform3(Vector3(rect.right, rect.top, 0.0)),
    rotationMatrix.transform3(Vector3(rect.right, rect.bottom, 0.0)),
    rotationMatrix.transform3(Vector3(rect.left, rect.bottom, 0.0)),
  );
  // ignore: invalid_use_of_visible_for_testing_member
  return InteractiveViewer.getAxisAlignedBoundingBox(boundariesRotated);
}

Offset _exceedsBy(Quad boundary, Quad viewport) {
  final List<Vector3> viewportPoints = <Vector3>[
    viewport.point0,
    viewport.point1,
    viewport.point2,
    viewport.point3,
  ];
  Offset largestExcess = Offset.zero;
  for (final Vector3 point in viewportPoints) {
    // ignore: invalid_use_of_visible_for_testing_member
    final Vector3 pointInside = InteractiveViewer.getNearestPointInside(
      point,
      boundary,
    );
    final Offset excess = Offset(
      pointInside.x - point.x,
      pointInside.y - point.y,
    );
    if (excess.dx.abs() > largestExcess.dx.abs()) {
      largestExcess = Offset(excess.dx, largestExcess.dy);
    }
    if (excess.dy.abs() > largestExcess.dy.abs()) {
      largestExcess = Offset(largestExcess.dx, excess.dy);
    }
  }

  return _round(largestExcess);
}

Offset _round(Offset offset) {
  return Offset(
    double.parse(offset.dx.toStringAsFixed(9)),
    double.parse(offset.dy.toStringAsFixed(9)),
  );
}

Offset _alignAxis(Offset offset, Axis axis) {
  return switch (axis) {
    Axis.horizontal => Offset(offset.dx, 0.0),
    Axis.vertical => Offset(0.0, offset.dy),
  };
}

Axis? _getPanAxis(Offset point1, Offset point2) {
  if (point1 == point2) {
    return null;
  }
  final double x = point2.dx - point1.dx;
  final double y = point2.dy - point1.dy;
  return x.abs() > y.abs() ? Axis.horizontal : Axis.vertical;
}

extension on Offset {
  Offset get flip => Offset(dy, dx);
}
