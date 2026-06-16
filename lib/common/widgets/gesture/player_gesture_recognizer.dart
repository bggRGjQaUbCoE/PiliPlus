import 'package:flutter/gestures.dart'
    show
        PointerDownEvent,
        GestureRecognizer,
        RecognizerCallback,
        ScaleGestureRecognizer,
        PointerPanZoomStartEvent,
        LongPressGestureRecognizer;

mixin PlayerGestureMixin on GestureRecognizer {
  bool isPosAllowed = true;
  bool _isPosAllowed = true;

  @override
  T? invokeCallback<T>(
    String name,
    RecognizerCallback<T> callback, {
    String Function()? debugReport,
  }) {
    if (!_isPosAllowed) return null;
    return super.invokeCallback(name, callback, debugReport: debugReport);
  }
}

class PlayerScaleGestureRecognizer extends ScaleGestureRecognizer
    with PlayerGestureMixin {
  PlayerScaleGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    super.dragStartBehavior,
    super.trackpadScrollCausesScale,
    super.trackpadScrollToScaleFactor,
  });

  void _handleAllowedPointer() {
    if (isReadyState) {
      _isPosAllowed = isPosAllowed;
    }
  }

  @override
  void addAllowedPointer(PointerDownEvent event) {
    _handleAllowedPointer();
    super.addAllowedPointer(event);
  }

  @override
  void addAllowedPointerPanZoom(PointerPanZoomStartEvent event) {
    _handleAllowedPointer();
    super.addAllowedPointerPanZoom(event);
  }
}

class PlayerLongPressGestureRecognizer extends LongPressGestureRecognizer
    with PlayerGestureMixin {
  PlayerLongPressGestureRecognizer({
    Duration? duration,
    super.postAcceptSlopTolerance,
    super.supportedDevices,
    super.debugOwner,
    super.allowedButtonsFilter,
  });

  @override
  void addAllowedPointer(PointerDownEvent event) {
    if (state == .ready) {
      _isPosAllowed = isPosAllowed;
    }
    super.addAllowedPointer(event);
  }
}
