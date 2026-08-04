enum MpvSpeedSlot { k, l }

final class MpvSpeedAction {
  const MpvSpeedAction({
    this.handled = true,
    this.playbackSpeed,
    this.persistSlot,
    this.persistTarget,
  });

  const MpvSpeedAction.ignored()
    : handled = false,
      playbackSpeed = null,
      persistSlot = null,
      persistTarget = null;

  final bool handled;
  final double? playbackSpeed;
  final MpvSpeedSlot? persistSlot;
  final double? persistTarget;
}

final class MpvSpeedShortcutMachine {
  MpvSpeedShortcutMachine({
    required double kTarget,
    required double lTarget,
  }) : _kTarget = _normalize(kTarget),
       _lTarget = _normalize(lTarget);

  static const holdThreshold = Duration(milliseconds: 250);

  double _kTarget;
  double _lTarget;
  MpvSpeedSlot? _pressedSlot;
  MpvSpeedSlot? _latchedSlot;
  MpvSpeedSlot? _learningSlot;
  Duration? _pressedAt;
  double? _pressedRestoreSpeed;
  double? _latchedRestoreSpeed;
  bool _disablePress = false;

  bool get isLatched => _latchedSlot != null;

  MpvSpeedAction keyDown(
    MpvSpeedSlot slot, {
    required double currentSpeed,
    required Duration timeStamp,
    bool repeat = false,
  }) {
    if (repeat || _pressedSlot != null) {
      return const MpvSpeedAction.ignored();
    }

    _pressedSlot = slot;
    _pressedAt = timeStamp;
    _disablePress = false;

    if (_latchedSlot == slot && _latchedRestoreSpeed != null) {
      final restoreSpeed = _latchedRestoreSpeed!;
      _pressedRestoreSpeed = restoreSpeed;
      _disablePress = true;
      _learningSlot = null;
      _clearLatched();
      return MpvSpeedAction(playbackSpeed: restoreSpeed);
    }

    _pressedRestoreSpeed = _latchedRestoreSpeed ?? currentSpeed;
    _clearLatched();
    _learningSlot = slot;
    return MpvSpeedAction(playbackSpeed: _targetFor(slot));
  }

  MpvSpeedAction keyUp(
    MpvSpeedSlot slot, {
    required Duration timeStamp,
  }) {
    if (_pressedSlot != slot ||
        _pressedAt == null ||
        _pressedRestoreSpeed == null) {
      return const MpvSpeedAction.ignored();
    }

    final pressedAt = _pressedAt!;
    final restoreSpeed = _pressedRestoreSpeed!;
    final disablePress = _disablePress;
    _clearPressed();

    if (disablePress) {
      return const MpvSpeedAction();
    }

    if (timeStamp - pressedAt >= holdThreshold) {
      _learningSlot = null;
      return MpvSpeedAction(playbackSpeed: restoreSpeed);
    }

    _latchedSlot = slot;
    _latchedRestoreSpeed = restoreSpeed;
    _learningSlot = slot;
    return const MpvSpeedAction();
  }

  MpvSpeedAction adjust({
    required double currentSpeed,
    required int deltaTenths,
  }) {
    final learningSlot = _learningSlot;
    if (learningSlot == null) {
      return MpvSpeedAction(
        playbackSpeed: _step(currentSpeed, deltaTenths),
      );
    }

    final target = _step(_targetFor(learningSlot), deltaTenths);
    _setTarget(learningSlot, target);
    return MpvSpeedAction(
      playbackSpeed: target,
      persistSlot: learningSlot,
      persistTarget: target,
    );
  }

  MpvSpeedAction releaseAll() {
    double? restoreSpeed;
    if (!_disablePress) {
      restoreSpeed = _pressedRestoreSpeed ?? _latchedRestoreSpeed;
    }

    _clearPressed();
    _clearLatched();
    _learningSlot = null;

    if (restoreSpeed == null) {
      return const MpvSpeedAction.ignored();
    }
    return MpvSpeedAction(playbackSpeed: restoreSpeed);
  }

  double _targetFor(MpvSpeedSlot slot) {
    return switch (slot) {
      MpvSpeedSlot.k => _kTarget,
      MpvSpeedSlot.l => _lTarget,
    };
  }

  void _setTarget(MpvSpeedSlot slot, double value) {
    switch (slot) {
      case MpvSpeedSlot.k:
        _kTarget = value;
      case MpvSpeedSlot.l:
        _lTarget = value;
    }
  }

  void _clearPressed() {
    _pressedSlot = null;
    _pressedAt = null;
    _pressedRestoreSpeed = null;
    _disablePress = false;
  }

  void _clearLatched() {
    _latchedSlot = null;
    _latchedRestoreSpeed = null;
  }

  static double _normalize(double speed) {
    final tenths = (speed * 10).round();
    return (tenths < 1 ? 1 : tenths) / 10;
  }

  static double _step(double speed, int deltaTenths) {
    final tenths = (speed * 10).round() + deltaTenths;
    return (tenths < 1 ? 1 : tenths) / 10;
  }
}
