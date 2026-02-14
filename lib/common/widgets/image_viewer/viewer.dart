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

import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart'
    show touchSlopH;
import 'package:PiliPlus/common/widgets/gesture/image_horizontal_drag_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/gesture/image_tap_gesture_recognizer.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' show FrictionSimulation;
import 'package:flutter/services.dart' show HardwareKeyboard;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart'
    show GetNavigation;

///
/// created by dom on 2026/02/14
///

class Viewer extends StatefulWidget {
  const Viewer({
    super.key,
    required this.minScale,
    required this.maxScale,
    this.isLongPic = false,
    required this.containerSize,
    required this.childSize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.tapGestureRecognizer,
    required this.horizontalDragGestureRecognizer,
    required this.onChangePage,
    required this.child,
  });

  final double minScale;
  final double maxScale;
  final bool isLongPic;
  final Size containerSize;
  final Size childSize;
  final Widget child;

  final ValueChanged<ScaleStartDetails>? onDragStart;
  final ValueChanged<ScaleUpdateDetails>? onDragUpdate;
  final ValueChanged<ScaleEndDetails>? onDragEnd;
  final ValueChanged<int>? onChangePage;

  final ImageTapGestureRecognizer tapGestureRecognizer;
  final ImageHorizontalDragGestureRecognizer horizontalDragGestureRecognizer;

  @override
  State<StatefulWidget> createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> with SingleTickerProviderStateMixin {
  static const double _interactionEndFrictionCoefficient = 0.0001; // 0.0000135
  static const double _scaleFactor = kDefaultMouseScrollToScaleFactor;

  _GestureType? _gestureType;

  Offset? _scalePos;
  late double _scale;
  double? _scaleStart;
  late Offset _position;
  Offset? _referenceFocalPoint;

  late Size _imageSize;

  late final ImageTapGestureRecognizer _tapGestureRecognizer;
  late final ImageHorizontalDragGestureRecognizer
  _horizontalDragGestureRecognizer;
  late final ScaleGestureRecognizer _scaleGestureRecognizer;
  late final DoubleTapGestureRecognizer _doubleTapGestureRecognizer;

  Offset? _downPos;
  AnimationController? _animationController;
  AnimationController get _effectiveAnimationController =>
      _animationController ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      )..addListener(_listener);

  late double _scaleFrom, _scaleTo;
  late Offset _positionFrom, _positionTo;

  Matrix4 get _matrix =>
      Matrix4.translationValues(_position.dx, _position.dy, 0.0)
        ..scaleByDouble(_scale, _scale, _scale, 1.0);

  void _listener() {
    final t = Curves.easeOut.transform(_effectiveAnimationController.value);
    _scale = t.lerp(_scaleFrom, _scaleTo);
    _position = Offset.lerp(_positionFrom, _positionTo, t)!;
    setState(() {});
  }

  void _reset() {
    _scale = widget.minScale;
    _position = .zero;
  }

  void _initSize() {
    _reset();
    _imageSize = applyBoxFit(
      .scaleDown,
      widget.childSize,
      widget.containerSize,
    ).destination;
    if (widget.isLongPic) {
      final containerWidth = widget.containerSize.width;
      final containerHeight = widget.containerSize.height;
      final imageHeight = _imageSize.height * _scale;
      _position = Offset(
        (1 - _scale) * containerWidth / 2,
        (imageHeight - _scale * containerHeight) / 2,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initSize();

    _tapGestureRecognizer = widget.tapGestureRecognizer;
    _horizontalDragGestureRecognizer = widget.horizontalDragGestureRecognizer;

    _scaleGestureRecognizer = ScaleGestureRecognizer(debugOwner: this)
      ..dragStartBehavior = .start
      ..onStart = _onScaleStart
      ..onUpdate = _onScaleUpdate
      ..onEnd = _onScaleEnd
      ..gestureSettings = DeviceGestureSettings(touchSlop: touchSlopH);
    _doubleTapGestureRecognizer = DoubleTapGestureRecognizer(debugOwner: this)
      ..onDoubleTapDown = _onDoubleTapDown
      ..onDoubleTap = _handleDoubleTap
      ..gestureSettings = MediaQuery.maybeGestureSettingsOf(Get.context!);
  }

  @override
  void didUpdateWidget(Viewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.containerSize != widget.containerSize ||
        oldWidget.childSize != widget.childSize) {
      _initSize();
    }
  }

  @override
  void dispose() {
    _animationController
      ?..removeListener(_listener)
      ..dispose();
    _animationController = null;
    _scaleGestureRecognizer.dispose();
    _doubleTapGestureRecognizer.dispose();
    super.dispose();
  }

  Offset _toScene(Offset localFocalPoint) {
    return (localFocalPoint - _position) / _scale;
  }

  Offset _clampPosition(Offset offset, double scale) {
    final containerSize = widget.containerSize;
    final imageWidth = _imageSize.width * scale;
    final imageHeight = _imageSize.height * scale;

    final center = containerSize * (1 - scale) / 2;

    final dxOffset = (imageWidth - containerSize.width) / 2;
    final dyOffset = (imageHeight - containerSize.height) / 2;

    return Offset(
      imageWidth > containerSize.width
          ? clampDouble(
              offset.dx,
              center.width - dxOffset,
              center.width + dxOffset,
            )
          : center.width,
      imageHeight > containerSize.height
          ? clampDouble(
              offset.dy,
              center.height - dyOffset,
              center.height + dyOffset,
            )
          : center.height,
    );
  }

  Offset _matrixTranslate(Offset translation) {
    if (translation == .zero) {
      return _position;
    }
    return _clampPosition(_position + translation * _scale, _scale);
  }

  void _onDoubleTapDown(TapDownDetails details) {
    _downPos = details.localPosition;
  }

  void _handleDoubleTap() {
    if (_effectiveAnimationController.isAnimating) return;
    _scaleFrom = _scale;
    _positionFrom = _position;

    double endScale;
    if (_scale == widget.minScale) {
      endScale = widget.maxScale * 0.6;
      if (endScale <= widget.minScale) {
        endScale = widget.maxScale;
      }
    } else {
      endScale = widget.minScale;
    }
    final position = _clampPosition(
      Offset.lerp(_downPos!, _position, endScale / _scale)!,
      endScale,
    );

    _scaleTo = endScale;
    _positionTo = position;

    _effectiveAnimationController
      ..duration = const Duration(milliseconds: 300)
      ..forward(from: 0);
  }

  void _onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount == 1) {
      if (widget.isLongPic) {
        final imageHeight = _scale * _imageSize.height;
        final containerHeight = widget.containerSize.height;
        if (_scalePos != null &&
                (_position.dy.equals(
                      (imageHeight - _scale * containerHeight) / 2,
                      1e-6,
                    ) &&
                    details.focalPoint.dy > _scalePos!.dy) ||
            (_position.dy.equals(containerHeight - imageHeight, 1e-6) &&
                details.focalPoint.dy < _scalePos!.dy)) {
          _gestureType = .drag;
          widget.onDragStart?.call(details);
          return;
        }
      } else if (_scale == widget.minScale) {
        _gestureType = .drag;
        widget.onDragStart?.call(details);
        return;
      }
    }

    _scaleStart = _scale;
    _referenceFocalPoint = _toScene(details.localFocalPoint);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_gestureType == .drag) {
      widget.onDragUpdate?.call(details);
      return;
    }

    if (details.scale != 1.0) {
      _gestureType = .scale;
      _scale = clampDouble(
        _scaleStart! * details.scale,
        widget.minScale,
        widget.maxScale,
      );

      final Offset focalPointSceneScaled = _toScene(details.localFocalPoint);
      _position = _matrixTranslate(
        focalPointSceneScaled - _referenceFocalPoint!,
      );
      setState(() {});
    } else {
      _gestureType = .pan;
      final Offset focalPointScene = _toScene(details.localFocalPoint);
      final Offset translationChange = focalPointScene - _referenceFocalPoint!;
      _position = _matrixTranslate(translationChange);
      _referenceFocalPoint = _toScene(details.localFocalPoint);
      setState(() {});
    }
  }

  /// ref [InteractiveViewer]
  void _onScaleEnd(ScaleEndDetails details) {
    switch (_gestureType) {
      case _GestureType.pan:
        if (details.velocity.pixelsPerSecond.distance < kMinFlingVelocity) {
          return;
        }
        final FrictionSimulation frictionSimulationX = FrictionSimulation(
          _interactionEndFrictionCoefficient,
          _position.dx,
          details.velocity.pixelsPerSecond.dx,
        );
        final FrictionSimulation frictionSimulationY = FrictionSimulation(
          _interactionEndFrictionCoefficient,
          _position.dy,
          details.velocity.pixelsPerSecond.dy,
        );
        final double tFinal = _getFinalTime(
          details.velocity.pixelsPerSecond.distance,
          _interactionEndFrictionCoefficient,
        );
        final position = _clampPosition(
          Offset(frictionSimulationX.finalX, frictionSimulationY.finalX),
          _scale,
        );

        _scaleFrom = _scaleTo = _scale;
        _positionFrom = _position;
        _positionTo = position;

        _effectiveAnimationController
          ..duration = Duration(milliseconds: (tFinal * 1000).round())
          ..forward(from: 0);
      case _GestureType.scale:
        // if (details.scaleVelocity.abs() < 0.1) {
        //   return;
        // }
        // final double scale = _scale;
        // final FrictionSimulation frictionSimulation = FrictionSimulation(
        //   _interactionEndFrictionCoefficient * _scaleFactor,
        //   scale,
        //   details.scaleVelocity / 10,
        // );
        // final double tFinal = _getFinalTime(
        //   details.scaleVelocity.abs(),
        //   _interactionEndFrictionCoefficient,
        //   effectivelyMotionless: 0.1,
        // );
        // _scaleAnimation = _scaleController.drive(
        //   Tween<double>(
        //     begin: scale,
        //     end: frictionSimulation.x(tFinal),
        //   ).chain(CurveTween(curve: Curves.decelerate)),
        // )..addListener(_handleScaleAnimation);
        // _effectiveAnimationController
        //   ..duration = Duration(milliseconds: (tFinal * 1000).round())
        //   ..forward(from: 0);
        break;
      case _GestureType.drag:
        widget.onDragEnd?.call(details);
      case null:
    }
    _scalePos = null;
    _gestureType = null;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: .opaque,
      onPointerDown: _onPointerDown,
      onPointerPanZoomStart: _onPointerPanZoomStart,
      onPointerSignal: _onPointerSignal,
      child: ClipRRect(
        child: Transform(
          transform: _matrix,
          child: widget.child,
        ),
      ),
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    _scalePos = event.position;
    _tapGestureRecognizer.addPointer(event);
    _doubleTapGestureRecognizer.addPointer(event);
    _horizontalDragGestureRecognizer
      ..isBoundaryAllowed = _isBoundaryAllowed
      ..addPointer(event);
    _scaleGestureRecognizer.addPointer(event);
  }

  void _onPointerPanZoomStart(PointerPanZoomStartEvent event) {
    _scaleGestureRecognizer.addPointerPanZoom(event);
  }

  bool _isBoundaryAllowed(Offset? initialPosition, OffsetPair lastPosition) {
    if (initialPosition == null) {
      return true;
    }
    if (_scale <= 1.0) {
      return true;
    }
    final containerWidth = widget.containerSize.width;
    final imageWidth = _imageSize.width * _scale;
    if (imageWidth <= containerWidth) {
      return true;
    }
    final dx = (1 - _scale) * containerWidth / 2;
    final dxOffset = (imageWidth - containerWidth) / 2;
    if (initialPosition.dx < lastPosition.global.dx) {
      return _position.dx.equals(dx + dxOffset);
    } else {
      return _position.dx.equals(dx - dxOffset);
    }
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (widget.onChangePage != null &&
          !HardwareKeyboard.instance.isControlPressed) {
        widget.onChangePage!.call(event.scrollDelta.dy < 0 ? -1 : 1);
        return;
      }
      final double scaleChange = math.exp(-event.scrollDelta.dy / _scaleFactor);
      final Offset local = event.localPosition;
      final Offset focalPointScene = _toScene(local);
      _scale = clampDouble(
        _scale * scaleChange,
        widget.minScale,
        widget.maxScale,
      );
      final Offset focalPointSceneScaled = _toScene(local);
      _position = _matrixTranslate(focalPointSceneScaled - focalPointScene);
      setState(() {});
    }
  }
}

enum _GestureType { pan, scale, drag }

double _getFinalTime(
  double velocity,
  double drag, {
  double effectivelyMotionless = 10,
}) {
  return math.log(effectivelyMotionless / velocity) / math.log(drag / 100);
}
