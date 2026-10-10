import 'package:flutter/gestures.dart'
    show TapGestureRecognizer, PointerDownEvent, PointerUpEvent;

class ImageTapGestureRecognizer extends TapGestureRecognizer {
  ImageTapGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    super.preAcceptSlopTolerance,
    super.postAcceptSlopTolerance,
  });

  Duration timeStamp = .zero;

  @override
  void handleTapUp({
    required PointerDownEvent down,
    required PointerUpEvent up,
  }) {
    timeStamp = up.timeStamp;
    super.handleTapUp(down: down, up: up);
  }
}
