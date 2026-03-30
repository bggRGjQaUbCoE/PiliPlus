import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/gestures.dart';

mixin ImageGestureRecognizerMixin on GestureRecognizer {
  int? _pointer;

  @override
  void addPointer(PointerDownEvent event, {bool isPointerAllowed = true}) {
    if (_pointer == event.pointer) {
      return;
    }
    _pointer = event.pointer;
    if (isPointerAllowed) {
      super.addPointer(event);
    }
  }
}

class ImageHorizontalDragGestureRecognizer
    extends CustomHorizontalDragGestureRecognizer
    with ImageGestureRecognizerMixin {
  ImageHorizontalDragGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  });

  static final double _touchSlop = PlatformUtils.isDesktop
      ? kPrecisePointerHitSlop
      : 3.0;

  @override
  DeviceGestureSettings get gestureSettings => _gestureSettings;
  final _gestureSettings = DeviceGestureSettings(touchSlop: _touchSlop);

  bool isAtLeftEdge = false;
  bool isAtRightEdge = false;

  void setAtBothEdges() {
    isAtLeftEdge = isAtRightEdge = true;
  }

  bool _isEdgeAllowed(double dx) {
    if ((initialPosition!.dx - dx).abs() < _touchSlop) return true;
    if (isAtLeftEdge) {
      if (isAtRightEdge) {
        return _hasAcceptedOrChecked = true;
      }
      _hasAcceptedOrChecked = true;
      return initialPosition!.dx < dx;
    } else if (isAtRightEdge) {
      _hasAcceptedOrChecked = true;
      return initialPosition!.dx > dx;
    }
    return true;
  }

  @override
  void handleEvent(PointerEvent event) {
    if (!_hasAcceptedOrChecked &&
        event is PointerMoveEvent &&
        _pointer == event.pointer) {
      if (!_isEdgeAllowed(event.position.dx)) {
        rejectGesture(event.pointer);
        return;
      }
    }
    super.handleEvent(event);
  }

  bool _hasAcceptedOrChecked = false;

  @override
  void acceptGesture(int pointer) {
    _hasAcceptedOrChecked = true;
    super.acceptGesture(pointer);
  }

  @override
  void stopTrackingPointer(int pointer) {
    _hasAcceptedOrChecked = false;
    isAtLeftEdge = false;
    isAtRightEdge = false;
    super.stopTrackingPointer(pointer);
  }
}
