// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vector_math/vector_math_64.dart' show Quad, Vector3;

class MouseInteractiveViewer extends StatefulWidget {
  const MouseInteractiveViewer({
    super.key,
    this.clipBehavior = .hardEdge,
    this.panAxis = .free,
    this.boundaryMargin = .zero,
    this.constrained = true,
    this.maxScale = 2.5,
    this.minScale = 0.8,
    this.interactionEndFrictionCoefficient = _kDrag,
    required this.pointerSignalFallback,
    this.onPointerPanZoomUpdate,
    this.onPointerPanZoomEnd,
    required this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    this.onPointerCancel,
    required this.onPanEnd,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onScaleUpdate,
    this.panEnabled = true,
    this.scaleEnabled = true,
    this.rotateEnabled = false,
    this.scaleFactor = kDefaultMouseScrollToScaleFactor,
    required this.transformationController,
    this.alignment,
    this.trackpadScrollCausesScale = false,
    required this.childKey,
    required this.child,
    required this.scaleGestureRecognizer,
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
  final bool rotateEnabled;
  final bool trackpadScrollCausesScale;
  final double scaleFactor;
  final double maxScale;
  final double minScale;
  final double interactionEndFrictionCoefficient;
  final PointerSignalEventListener pointerSignalFallback;
  final PointerPanZoomUpdateEventListener? onPointerPanZoomUpdate;
  final PointerPanZoomEndEventListener? onPointerPanZoomEnd;
  final PointerDownEventListener onPointerDown;
  final PointerMoveEventListener? onPointerMove;
  final PointerUpEventListener? onPointerUp;
  final PointerCancelEventListener? onPointerCancel;
  final GestureScaleEndCallback onPanEnd;
  final GestureScaleStartCallback onPanStart;
  final GestureScaleUpdateCallback onPanUpdate;
  final ValueChanged<double> onScaleUpdate;
  final TransformationController transformationController;
  final GlobalKey childKey;
  final ScaleGestureRecognizer scaleGestureRecognizer;

  static const double _kDrag = 0.0000135;

  @override
  State<MouseInteractiveViewer> createState() => _MouseInteractiveViewerState();
}

class _MouseInteractiveViewerState extends State<MouseInteractiveViewer>
    with TickerProviderStateMixin {
  late TransformationController _transformer;

  final GlobalKey _parentKey = GlobalKey();
  Animation<Offset>? _animation;
  Animation<double>? _scaleAnimation;
  late Offset _scaleAnimationFocalPoint;
  late AnimationController _controller;
  late AnimationController _scaleController;
  late AnimationController _snapController;
  Animation<Matrix4>? _snapAnimation;
  Axis? _currentAxis;
  Offset? _referenceFocalPoint;
  double? _scaleStart;
  double? _rotationStart = 0.0;
  int _gestureStartQuarter = 0;
  _GestureType? _gestureType;

  static final gestureSettings = DeviceGestureSettings(
    touchSlop: Platform.isIOS ? 9 : 4,
  );

  late final ScaleGestureRecognizer _scaleGestureRecognizer;

  static const double _kQuarterTurn = math.pi / 2;
  static const Duration _kSnapDuration = Duration(milliseconds: 255);

  // 矩阵线性部分的旋转角。等比缩放下 m00=s·cosθ、m10=s·sinθ，
  // 角度一律由此反解，不维护独立簿记（外部写矩阵不会失同步）
  double get _matrixRotation {
    final storage = _transformer.value.storage;
    return math.atan2(storage[1], storage[0]);
  }

  int _quarterOf(double rotation) => (rotation / _kQuarterTurn).round();

  double _quarterAngle(int quarter) => switch (quarter % 4) {
    1 => _kQuarterTurn,
    2 => math.pi,
    3 => -_kQuarterTurn,
    _ => 0,
  };

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

    // 旋转态不做边界钳制，合法性由旋转吸附落位恢复
    final double rotation = _matrixRotation;
    if (rotation != 0.0) {
      return nextMatrix;
    }

    final Quad boundariesAabbQuad = _getAxisAlignedBoundingBoxWithRotation(
      _boundaryRect,
      rotation,
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
    double totalScale = currentScale * scale;
    double minScale = widget.minScale;
    if (math.sin(_matrixRotation).abs() > 0.001) {
      // 横竖互换的旋转态：缩放下限放宽到 contain 适配值，钳回由吸附落位完成
      final Size size = _viewport.size;
      minScale = math.min(minScale, size.shortestSide / size.longestSide);
    } else {
      totalScale = math.max(
        totalScale,
        math.max(
          _viewport.width / _boundaryRect.width,
          _viewport.height / _boundaryRect.height,
        ),
      );
    }
    final double clampedTotalScale = clampDouble(
      totalScale,
      minScale,
      widget.maxScale,
    );

    widget.onScaleUpdate(clampedTotalScale);

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
      _GestureType.scale => widget.scaleEnabled,
      _GestureType.pan || null => widget.panEnabled,
    };
  }

  _GestureType _getGestureType(ScaleUpdateDetails details) {
    final double scale = !widget.scaleEnabled ? 1.0 : details.scale;
    if (scale != 1.0) {
      return _GestureType.scale;
    } else {
      return _GestureType.pan;
    }
  }

  bool _isSinglePointer = false;

  // Handle the start of a gesture. All of pan, scale, and rotate are handled
  // with GestureDetector's scale gesture.
  void _onScaleStart(ScaleStartDetails details) {
    if (_isSinglePointer = details.pointerCount == 1) {
      widget.onPanStart(details);
      return;
    }

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
    if (_snapController.isAnimating) {
      _snapController
        ..stop()
        ..reset();
      _snapAnimation?.removeListener(_handleSnapAnimation);
      _snapAnimation = null;
    }

    _gestureType = null;
    _currentAxis = null;
    _scaleStart = _transformer.value.getMaxScaleOnAxis();
    _referenceFocalPoint = _transformer.toScene(details.localFocalPoint);
    _rotationStart = _matrixRotation;
    _gestureStartQuarter = _quarterOf(_rotationStart!);
  }

  // Handle an update to an ongoing gesture. All of pan, scale, and rotate are
  // handled with GestureDetector's scale gesture.
  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_isSinglePointer) {
      widget.onPanUpdate(details);
      return;
    }

    if (widget.rotateEnabled && widget.scaleEnabled) {
      _onRotateScaleUpdate(details);
      return;
    }

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

      case _GestureType.pan:
        assert(_referenceFocalPoint != null);
        // details may have a change in scale here when scaleEnabled is false.
        // In an effort to keep the behavior similar whether or not scaleEnabled
        // is true, these gestures are thrown away.
        if (details.scale != 1.0) {
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
  }

  // Handle the end of a gesture of _GestureType. All of pan, scale, and rotate
  // are handled with GestureDetector's scale gesture.
  void _onScaleEnd(ScaleEndDetails details) {
    if (_isSinglePointer) {
      widget.onPanEnd(details);
      return;
    }

    _scaleStart = null;
    _rotationStart = null;
    _referenceFocalPoint = null;

    _animation?.removeListener(_handleInertiaAnimation);
    _scaleAnimation?.removeListener(_handleScaleAnimation);
    _controller.reset();
    _scaleController.reset();

    if (widget.rotateEnabled && widget.scaleEnabled) {
      _currentAxis = null;
      _snapRotation();
      return;
    }

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
        _animation = _controller.drive(
          Tween<Offset>(
            begin: translation,
            end: Offset(
              frictionSimulationX.finalX,
              frictionSimulationY.finalX,
            ),
          ).chain(CurveTween(curve: Curves.decelerate)),
        )..addListener(_handleInertiaAnimation);
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
        _scaleAnimation = _scaleController.drive(
          Tween<double>(
            begin: scale,
            end: frictionSimulation.x(tFinal),
          ).chain(CurveTween(curve: Curves.decelerate)),
        )..addListener(_handleScaleAnimation);
        _scaleController
          ..duration = Duration(milliseconds: (tFinal * 1000).round())
          ..forward();
      case null:
        break;
    }
  }

  // 双指期间缩放/旋转/平移同时跟手，松手由 _snapRotation 定型
  void _onRotateScaleUpdate(ScaleUpdateDetails details) {
    _scaleAnimationFocalPoint = details.localFocalPoint;

    final double currentScale = _transformer.value.getMaxScaleOnAxis();
    final double desiredScale = _scaleStart! * details.scale;
    if (desiredScale != currentScale) {
      _transformer.value = _matrixScale(
        _transformer.value,
        desiredScale / currentScale,
      );
    }

    final double desiredRotation = _rotationStart! + details.rotation;
    final double currentRotation = _matrixRotation;
    if (desiredRotation != currentRotation) {
      _transformer.value = _matrixRotate(
        _transformer.value,
        currentRotation - desiredRotation,
        details.localFocalPoint,
      );
    }

    // 平移使起始焦点始终锚定在手指下（含缩放/旋转位移的修正）
    final Offset focalPointScene = _transformer.toScene(
      details.localFocalPoint,
    );
    _transformer.value = _matrixTranslate(
      _transformer.value,
      focalPointScene - _referenceFocalPoint!,
    );
    final Offset focalPointSceneCheck = _transformer.toScene(
      details.localFocalPoint,
    );
    if (_round(_referenceFocalPoint!) != _round(focalPointSceneCheck)) {
      _referenceFocalPoint = focalPointSceneCheck;
    }
  }

  // 旋转吸附：换向 → 适配居中；未换向 → 只摆正角度，保留缩放/平移
  void _snapRotation() {
    final Matrix4 matrix = _transformer.value;
    final double rotation = _matrixRotation;
    final int quarter = _quarterOf(rotation);

    final Matrix4 target;
    if ((quarter - _gestureStartQuarter) % 4 != 0) {
      target = _fitCenteredPose(quarter);
    } else {
      final double delta = rotation - _quarterAngle(quarter);
      final Matrix4 straightened = delta == 0.0
          ? matrix
          : _matrixRotate(matrix, delta, _viewport.center);
      // 重组使档位角精确（0° 需 m10 精确为零以恢复边界钳制）
      target = _composePose(
        _getMatrixTranslation(straightened),
        quarter,
        straightened.getMaxScaleOnAxis(),
      );
    }
    if (target == matrix) {
      return;
    }
    _animateSnapTo(target);
  }

  Matrix4 _fitCenteredPose(int quarter) {
    final int q = quarter % 4;
    if (q == 0) {
      return Matrix4.identity();
    }
    final RenderBox childRenderBox =
        widget.childKey.currentContext!.findRenderObject()! as RenderBox;
    final Size size = childRenderBox.size;
    final double scale = q.isOdd ? size.shortestSide / size.longestSide : 1.0;
    final Offset center = size.center(Offset.zero);
    return Matrix4.identity()
      ..translateByDouble(center.dx, center.dy, 0, 1)
      ..rotateZ(_quarterAngle(q))
      ..scaleByDouble(scale, scale, scale, 1)
      ..translateByDouble(-center.dx, -center.dy, 0, 1);
  }

  Matrix4 _composePose(Offset translation, int quarter, double scale) {
    final Matrix4 pose = Matrix4.identity()
      ..translateByDouble(translation.dx, translation.dy, 0, 1);
    if (quarter % 4 != 0) {
      pose.rotateZ(_quarterAngle(quarter));
    }
    return pose..scaleByDouble(scale, scale, scale, 1);
  }

  void _animateSnapTo(Matrix4 target) {
    _snapAnimation =
        _snapController.drive(
            Matrix4Tween(
              begin: _transformer.value.clone(),
              end: target,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
          )
          ..addListener(_handleSnapAnimation);
    _snapController
      ..duration = _kSnapDuration
      ..forward().whenComplete(() {
        // Tween 分解重组有残差，终值显式写入
        _transformer.value = target;
      });
  }

  void _handleSnapAnimation() {
    _transformer.value = _snapAnimation!.value;
    if (!_snapController.isAnimating) {
      _snapAnimation?.removeListener(_handleSnapAnimation);
      _snapAnimation = null;
      _snapController.reset();
    }
  }

  void _receivedPointerSignal(PointerSignalEvent event) {
    GestureBinding.instance.pointerSignalResolver.register(
      event,
      _handlePointerScroll,
    );
  }

  void _handlePointerScroll(PointerSignalEvent event) {
    final Offset local = event.localPosition;
    final Offset global = event.position;
    final double scaleChange;
    if (event is PointerScrollEvent) {
      if (event.kind == PointerDeviceKind.trackpad) {
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

        return;
      }
      _handlePointerScrollEvent(event);
      return;
    } else if (event is PointerScaleEvent) {
      scaleChange = event.scale;
    } else {
      return;
    }

    if (!_gestureIsSupported(_GestureType.scale)) {
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
  }

  void _handlePointerScrollEvent(PointerScrollEvent event) {
    if (_gestureIsSupported(_GestureType.scale)) {
      final Offset local = event.localPosition;
      final Offset global = event.position;
      if (HardwareKeyboard.instance.isControlPressed) {
        _handleMouseWheelScale(event, local, global);
        return;
      }
      final shift = HardwareKeyboard.instance.isShiftPressed;
      if (shift || HardwareKeyboard.instance.isAltPressed) {
        _handleMouseWheelPanAsScale(event, local, global, shift);
        return;
      }
      widget.pointerSignalFallback(event);
    }
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
  }

  void _handleMouseWheelPanAsScale(
    PointerScrollEvent event,
    Offset local,
    Offset global,
    bool flip,
  ) {
    if (_transformer.value[0] == 1.0) return;
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

  @override
  void initState() {
    super.initState();
    _scaleGestureRecognizer = widget.scaleGestureRecognizer
      ..gestureSettings = gestureSettings
      ..onStart = _onScaleStart
      ..onUpdate = _onScaleUpdate
      ..onEnd = _onScaleEnd;
    _controller = AnimationController(vsync: this);
    _scaleController = AnimationController(vsync: this);
    _snapController = AnimationController(vsync: this);

    _transformer = widget.transformationController;
    _transformer.addListener(_handleTransformation);
  }

  @override
  void didUpdateWidget(MouseInteractiveViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newController = widget.transformationController;
    if (newController == oldWidget.transformationController) {
      return;
    }
    _transformer.removeListener(_handleTransformation);
    _transformer = newController;
    _transformer.addListener(_handleTransformation);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    _snapController.dispose();
    _transformer.removeListener(_handleTransformation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.child.key == widget.childKey);

    return Listener(
      key: _parentKey,
      behavior: HitTestBehavior.opaque,
      onPointerSignal: _receivedPointerSignal,
      onPointerDown: widget.onPointerDown,
      onPointerMove: widget.onPointerMove,
      onPointerUp: widget.onPointerUp,
      onPointerCancel: widget.onPointerCancel,
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

enum _GestureType { pan, scale }

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
