import 'dart:async' show Timer;

import 'package:flutter/widgets.dart' show AppLifecycleState;

/// Turns hardware decoding back on after iOS took it away in the background.
///
/// iOS invalidates VideoToolbox sessions while the app is in the background.
/// mpv falls back to software decoding after a few failed frames and remembers
/// the failure until the decoder is reinitialized, so the video would stay on
/// the software decoder until the player is recreated.
///
/// The failure can show up some time after the app returns: a paused player
/// only decodes again once playback resumes. So this checks shortly after
/// playback is running in the foreground, and only when hardware decoding was
/// active before the app left the foreground. Codecs the device can only decode
/// in software are left alone.
class IOSHwdecRecovery {
  IOSHwdecRecovery({
    required this.getCurrent,
    required this.isPlaying,
    required this.reinit,
  });

  static const checkDelays = [Duration(seconds: 1), Duration(seconds: 3)];

  /// mpv's `hwdec-current`: `no` for software, empty while nothing is loaded.
  final String Function() getCurrent;
  final bool Function() isPlaying;
  final void Function() reinit;

  bool _inForeground = true;
  bool _wasHardware = false;
  bool _armed = false;
  final List<Timer> _timers = [];

  void onLifecycleChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_inForeground) return;
        _inForeground = true;
        _armed = _wasHardware;
        _wasHardware = false;
        onPlaying();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        // The first of these comes while the session is still valid.
        if (!_inForeground) return;
        _inForeground = false;
        _armed = false;
        _cancelTimers();
        final current = getCurrent();
        _wasHardware = current.isNotEmpty && current != 'no';
      case AppLifecycleState.detached:
        dispose();
    }
  }

  /// Call whenever playback starts.
  void onPlaying() {
    if (!_armed || !_inForeground || _timers.isNotEmpty || !isPlaying()) return;
    for (final (index, delay) in checkDelays.indexed) {
      late final Timer timer;
      timer = Timer(delay, () {
        _timers.remove(timer);
        _check(isLast: index == checkDelays.length - 1);
      });
      _timers.add(timer);
    }
  }

  void _check({required bool isLast}) {
    if (!_armed) return;
    // Paused again: wait for the next time playback starts.
    if (!isPlaying()) return;
    if (getCurrent() == 'no') {
      _armed = false;
      _cancelTimers();
      reinit();
    } else if (isLast) {
      _armed = false;
    }
  }

  void _cancelTimers() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }

  void dispose() {
    _armed = false;
    _cancelTimers();
  }
}
