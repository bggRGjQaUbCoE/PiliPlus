import 'package:flutter/gestures.dart'
    show
        GestureRecognizer,
        RecognizerCallback,
        ScaleGestureRecognizer,
        LongPressGestureRecognizer;

mixin PlayerGestureMixin on GestureRecognizer {
  bool isPosAllowed = true;

  @override
  T? invokeCallback<T>(
    String name,
    RecognizerCallback<T> callback, {
    String Function()? debugReport,
  }) {
    if (!isPosAllowed) return null;
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
}
