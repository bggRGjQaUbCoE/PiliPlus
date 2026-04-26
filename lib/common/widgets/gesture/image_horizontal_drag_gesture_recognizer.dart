import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart';
import 'package:flutter/gestures.dart';

class ImageHorizontalDragGestureRecognizer
    extends CustomHorizontalDragGestureRecognizer {
  ImageHorizontalDragGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  });

  int? _pointer;

  bool _reset = true;
  bool _hasAcceptedOrRejected = false;

  bool isAtLeftEdge = false;
  bool isAtRightEdge = false;

  @override
  void addPointer(PointerDownEvent event, {bool isPointerAllowed = true}) {
    if (_pointer == event.pointer) {
      return;
    }
    if (!_reset &&
        _pointer != event.pointer &&
        isPointerAllowed &&
        !_hasAcceptedOrRejected) {
      rejectGesture(_pointer!);
      _pointer = event.pointer;
      return;
    }
    _pointer = event.pointer;
    if (isPointerAllowed) {
      super.addPointer(event);
    }
  }

  @override
  void addAllowedPointer(PointerDownEvent event) {
    _reset = false;
    super.addAllowedPointer(event);
  }

  void setAtBothEdges() {
    isAtLeftEdge = isAtRightEdge = true;
  }

  bool _isEdgeAllowed(double dx) {
    if (isAtLeftEdge) {
      if (isAtRightEdge) {
        return true;
      }
      return initialPosition!.dx < dx;
    } else if (isAtRightEdge) {
      return initialPosition!.dx > dx;
    }
    return true;
  }

  @override
  void acceptGesture(int pointer) {
    _hasAcceptedOrRejected = true;
    super.acceptGesture(pointer);
  }

  @override
  void rejectGesture(int pointer) {
    _hasAcceptedOrRejected = true;
    super.rejectGesture(pointer);
  }

  @override
  void stopTrackingPointer(int pointer) {
    _reset = true;
    _hasAcceptedOrRejected = false;

    isAtLeftEdge = false;
    isAtRightEdge = false;
    super.stopTrackingPointer(pointer);
  }

  @override
  bool hasSufficientGlobalDistanceToAccept(
    PointerDeviceKind pointerDeviceKind,
    double? deviceTouchSlop,
  ) {
    return super.hasSufficientGlobalDistanceToAccept(
          pointerDeviceKind,
          deviceTouchSlop,
        ) &&
        _isEdgeAllowed(lastPosition.global.dx);
  }
}
