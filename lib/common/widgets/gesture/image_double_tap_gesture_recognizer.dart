import 'package:flutter/gestures.dart'
    show DoubleTapGestureRecognizer, PointerUpEvent;

class ImageDoubleTapGestureRecognizer extends DoubleTapGestureRecognizer {
  ImageDoubleTapGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  });

  Duration timeStamp = .zero;

  @override
  void checkUp(int buttons, PointerUpEvent event) {
    timeStamp = event.timeStamp;
    super.checkUp(buttons, event);
  }
}
