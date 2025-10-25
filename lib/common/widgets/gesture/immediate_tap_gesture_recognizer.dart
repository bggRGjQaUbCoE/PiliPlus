import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class ImmediateTapGestureRecognizer extends OneSequenceGestureRecognizer {
  ImmediateTapGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    this.onTapDown,
    required this.onTapUp,
    this.onTapCancel,
    this.onTap,
  });

  GestureTapDownCallback? onTapDown;

  final GestureTapUpCallback onTapUp;

  final GestureTapCancelCallback? onTapCancel;

  final GestureTapCallback? onTap;

  PointerUpEvent? _up;
  int _activePointer = 0;
  bool _sentTapDown = false;
  bool _wonArena = false;

  @override
  bool isPointerPanZoomAllowed(PointerPanZoomStartEvent event) => false;

  @override
  bool isPointerAllowed(PointerDownEvent event) =>
      _activePointer == 0 && super.isPointerAllowed(event);

  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    _reset(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event.pointer != _activePointer) {
      stopTrackingPointer(event.pointer);
      return;
    }

    if (event is PointerDownEvent) {
      _handleTapDown(event);
    } else if (event is PointerMoveEvent) {
      _handlePointerMove(event);
    } else if (event is PointerUpEvent) {
      _up = event;
      _handlePointerUp(event);
    }

    stopTrackingIfPointerNoLongerDown(event);
  }

  void _handleTapDown(PointerDownEvent event) {
    if (_sentTapDown) return;

    if (onTapDown != null) {
      _sentTapDown = true;
      final details = TapDownDetails(
        globalPosition: event.position,
        localPosition: event.localPosition,
        kind: event.kind,
      );
      invokeCallback<void>('onTapDown', () => onTapDown!(details));
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.delta.distanceSquared > 2.0) {
      _cancelGesture('pointer moved');
      stopTrackingPointer(event.pointer);
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_wonArena) {
      _handleTapUp(event);
    }
  }

  void _handleTapUp(PointerUpEvent event) {
    final details = TapUpDetails(
      globalPosition: event.position,
      localPosition: event.localPosition,
      kind: event.kind,
    );
    invokeCallback<void>('onTapUp', () => onTapUp(details));

    if (onTap != null) {
      invokeCallback<void>('onTap', onTap!);
    }

    _reset();
  }

  void _cancelGesture(String reason) {
    if (_sentTapDown && onTapCancel != null) {
      invokeCallback<void>('onTapCancel: $reason', onTapCancel!);
    }
    _reset();
  }

  void _reset([int pointer = 0]) {
    _activePointer = pointer;
    _up = null;
    _sentTapDown = false;
    _wonArena = false;
  }

  @override
  void acceptGesture(int pointer) {
    super.acceptGesture(pointer);

    if (pointer == _activePointer) {
      _wonArena = true;

      if (_up != null) {
        _handleTapUp(_up!);
      }
    }
  }

  @override
  void rejectGesture(int pointer) {
    super.rejectGesture(pointer);

    if (pointer == _activePointer) {
      _cancelGesture('gesture rejected by arena');
      stopTrackingPointer(pointer);
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    // wait for arena
  }

  @override
  void dispose() {
    _cancelGesture('disposed');
    super.dispose();
  }

  @override
  String get debugDescription => 'immediate tap';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('activePointer', _activePointer))
      ..add(
        FlagProperty(
          'sentTapDown',
          value: _sentTapDown,
          ifTrue: 'has sentTapDown',
        ),
      )
      ..add(FlagProperty('wonArena', value: _wonArena, ifTrue: 'wonArena'))
      ..add(
        DiagnosticsProperty<PointerUpEvent>(
          'pointerUpEvent',
          _up,
          defaultValue: null,
        ),
      );
  }
}
