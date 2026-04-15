import 'package:flutter/gestures.dart'
    show VerticalDragGestureRecognizer, PointerEvent, RecognizerCallback;

typedef IsDyAllowed = bool Function(double dy);

class CustomVerticalDragGestureRecognizer
    extends VerticalDragGestureRecognizer {
  CustomVerticalDragGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  });

  IsDyAllowed? isDyAllowed;

  bool _isDyAllowed = false;

  @override
  bool isPointerAllowed(PointerEvent event) {
    _isDyAllowed = isDyAllowed?.call(event.localPosition.dy) ?? true;
    return super.isPointerAllowed(event);
  }

  @override
  T? invokeCallback<T>(
    String name,
    RecognizerCallback<T> callback, {
    String Function()? debugReport,
  }) {
    if (!_isDyAllowed) return null;
    return super.invokeCallback(name, callback, debugReport: debugReport);
  }

  @override
  void dispose() {
    isDyAllowed = null;
    super.dispose();
  }
}
