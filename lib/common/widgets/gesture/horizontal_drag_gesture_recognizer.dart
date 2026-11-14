import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:flutter/gestures.dart'
    show
        Offset,
        GestureRecognizer,
        PointerDownEvent,
        HorizontalDragGestureRecognizer,
        DeviceGestureSettings,
        PointerDeviceKind,
        kPrecisePointerHitSlop,
        kTouchSlop,
        PointerPanZoomStartEvent;

mixin InitialPositionMixin on GestureRecognizer {
  Offset? _initialPosition;
  Offset? get initialPosition => _initialPosition;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    _initialPosition = event.position;
    super.addAllowedPointer(event);
  }

  @override
  void addAllowedPointerPanZoom(PointerPanZoomStartEvent event) {
    _initialPosition = event.position;
    super.addAllowedPointerPanZoom(event);
  }
}

class CustomHorizontalDragGestureRecognizer
    extends HorizontalDragGestureRecognizer
    with InitialPositionMixin {
  CustomHorizontalDragGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    double? touchSlop,
    this.angleRatio = kDefaultAngleRatio,
  }) : _touchSlop = touchSlop;

  /// 单个识别器可覆盖全局「横向滑动阈值」
  final double? _touchSlop;

  /// 判定横向的角度比：|dx| > |dy| * angleRatio
  final double angleRatio;

  @override
  DeviceGestureSettings get gestureSettings => _gestureSettings;
  late final _gestureSettings = DeviceGestureSettings(
    touchSlop: _touchSlop ?? touchSlopH,
  );

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
      angleRatio,
    );
  }

  @override
  Type get runtimeType => HorizontalDragGestureRecognizer;
}

double touchSlopH = Pref.touchSlopH;

const double kDefaultAngleRatio = 3;

bool _computeHitSlop(
  double globalDistanceMoved,
  DeviceGestureSettings settings,
  PointerDeviceKind kind,
  Offset? initialPosition,
  Offset lastPosition,
  double angleRatio,
) {
  switch (kind) {
    case .mouse:
      return globalDistanceMoved > kPrecisePointerHitSlop;
    case .stylus:
    case .invertedStylus:
    case .unknown:
    case .touch:
      return globalDistanceMoved > settings.touchSlop! &&
          _calcAngle(initialPosition!, lastPosition, angleRatio);
    case .trackpad:
      return globalDistanceMoved > settings.touchSlop! &&
          _calcAngle(initialPosition!, lastPosition, angleRatio);
  }
}

bool _calcAngle(
  Offset initialPosition,
  Offset lastPosition,
  double angleRatio,
) {
  final offset = lastPosition - initialPosition;
  return offset.dx.abs() > offset.dy.abs() * angleRatio;
}

final deviceTouchSlop = _calcDeviceTouchSlop();

double _calcDeviceTouchSlop() {
  final view = PlatformDispatcher.instance.views.first;
  final physicalTouchSlop = view.gestureSettings.physicalTouchSlop;
  return physicalTouchSlop == null
      ? kTouchSlop
      : physicalTouchSlop / view.devicePixelRatio;
}
