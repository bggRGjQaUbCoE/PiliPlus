import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/gestures.dart';

mixin InitialPositionMixin on GestureRecognizer {
  Offset? _initialPosition;
  Offset? get initialPosition => _initialPosition;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    _initialPosition = event.position;
  }
}

class CustomHorizontalDragGestureRecognizer
    extends HorizontalDragGestureRecognizer
    with InitialPositionMixin {
  CustomHorizontalDragGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  });

  @override
  DeviceGestureSettings get gestureSettings => _gestureSettings;
  final _gestureSettings = DeviceGestureSettings(touchSlop: touchSlopH);

  @override
  bool hasSufficientGlobalDistanceToAccept(
    PointerDeviceKind pointerDeviceKind,
    double? deviceTouchSlop,
  ) {
    return _computeHitSlop(
      globalDistanceMoved.abs(),
      gestureSettings,
      pointerDeviceKind,
      _initialPosition,
      lastPosition.global,
    );
  }
}

double touchSlopH = Pref.touchSlopH;

bool _computeHitSlop(
  double globalDistanceMoved,
  DeviceGestureSettings settings,
  PointerDeviceKind kind,
  Offset? initialPosition,
  Offset lastPosition,
) {
  switch (kind) {
    case PointerDeviceKind.mouse:
      return globalDistanceMoved > kPrecisePointerHitSlop;
    case PointerDeviceKind.stylus:
    case PointerDeviceKind.invertedStylus:
    case PointerDeviceKind.unknown:
    case PointerDeviceKind.touch:
      return globalDistanceMoved > settings.touchSlop! &&
          _calc(initialPosition!, lastPosition);
    case PointerDeviceKind.trackpad:
      return globalDistanceMoved > settings.touchSlop!;
  }
}

bool _calc(Offset initialPosition, Offset lastPosition) {
  final offset = lastPosition - initialPosition;
  return offset.dx.abs() > offset.dy.abs() * 3;
}
