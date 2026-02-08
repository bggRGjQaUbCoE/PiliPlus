import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show TransformationController;

class ImageHorizontalDragGestureRecognizer
    extends HorizontalDragGestureRecognizer {
  ImageHorizontalDragGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    required this.width,
    required this.transformationController,
  });

  Offset? _initialPosition;

  double width;
  final TransformationController transformationController;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    _initialPosition = event.position;
  }

  bool _isBoundaryAllowed() {
    if (_initialPosition == null) {
      return true;
    }
    final storage = transformationController.value.storage;
    final scale = storage[0];
    if (scale <= 1.0) {
      return true;
    }
    final double xOffset = storage[12];
    final double boundaryEnd = width * scale;
    final int xPos = (boundaryEnd + xOffset).round();
    return (boundaryEnd.round() == xPos &&
            lastPosition.global.dx > _initialPosition!.dx) ||
        (width.round() == xPos &&
            lastPosition.global.dx < _initialPosition!.dx);
  }

  @override
  bool hasSufficientGlobalDistanceToAccept(
    PointerDeviceKind pointerDeviceKind,
    double? deviceTouchSlop,
  ) {
    return globalDistanceMoved.abs() >
            computeHitSlop(pointerDeviceKind, gestureSettings) &&
        _isBoundaryAllowed();
  }
}
