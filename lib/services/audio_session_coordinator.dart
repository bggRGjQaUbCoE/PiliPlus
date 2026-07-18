import 'dart:async' show Completer;

import 'package:audio_session/audio_session.dart';

Future<bool> startPlaybackWithAudioFocus({
  required Future<bool> Function() activate,
  required bool Function() canStart,
  required Future<void> Function() start,
  required Future<void> Function() deactivate,
}) async {
  if (!await activate()) return false;
  if (!canStart()) {
    await deactivate();
    return false;
  }
  try {
    await start();
    return true;
  } catch (_) {
    await deactivate();
    rethrow;
  }
}

final class AudioPlaybackClient {
  const AudioPlaybackClient({
    required this.owner,
    required this.isPlaying,
    required this.play,
    required this.pause,
    this.getVolume,
    this.setVolume,
  });

  final Object owner;
  final bool Function() isPlaying;
  final Future<void> Function() play;
  final Future<void> Function(bool interrupted) pause;
  final double? Function()? getVolume;
  final Future<void> Function(double volume)? setVolume;
}

final class AudioSessionCoordinator {
  AudioSessionCoordinator(this._setPlatformActive);

  final Future<bool> Function(bool active) _setPlatformActive;
  AudioPlaybackClient? _activeClient;
  AudioPlaybackClient? _interruptedClient;
  AudioPlaybackClient? _duckedClient;
  double? _volumeBeforeDuck;

  bool _desiredActive = false;
  bool _platformActive = false;
  int _clientVersion = 0;
  int _desiredVersion = 0;
  int _appliedVersion = 0;
  Future<void>? _focusDrain;
  Future<void> _eventTail = Future<void>.value();

  AudioPlaybackClient? get activeClient => _activeClient;

  Future<bool> activate(AudioPlaybackClient client) async {
    final clientVersion = ++_clientVersion;
    final previousClient = _activeClient;
    if (previousClient != null && !identical(previousClient, client)) {
      if (identical(_duckedClient, previousClient)) {
        await _restoreVolume(previousClient);
      }
      if (identical(_interruptedClient, previousClient)) {
        _interruptedClient = null;
      }
    }
    if (clientVersion != _clientVersion) return false;
    _activeClient = client;
    _desiredActive = true;
    _desiredVersion++;
    await _drainFocusChanges();

    final isCurrent =
        clientVersion == _clientVersion && identical(_activeClient, client);
    if (isCurrent && !_platformActive) {
      _activeClient = null;
      _desiredActive = false;
      _desiredVersion++;
      _appliedVersion = _desiredVersion;
    }
    return isCurrent && _platformActive;
  }

  Future<bool> deactivate(Object owner) async {
    final client = _activeClient;
    if (client == null || !identical(client.owner, owner)) {
      return true;
    }
    final clientVersion = ++_clientVersion;

    if (identical(_duckedClient, client)) {
      await _restoreVolume(client);
    }
    if (clientVersion != _clientVersion) return true;
    if (identical(_interruptedClient, client)) {
      _interruptedClient = null;
    }
    _activeClient = null;
    _desiredActive = false;
    _desiredVersion++;
    await _drainFocusChanges();
    return !_platformActive;
  }

  Future<void> _drainFocusChanges() async {
    if (_focusDrain case final focusDrain?) {
      await focusDrain;
      return;
    }

    late final Future<void> focusDrain;
    focusDrain = () async {
      try {
        while (_appliedVersion != _desiredVersion) {
          final version = _desiredVersion;
          final active = _desiredActive;
          final success = await _setPlatformActive(active);
          if (success) {
            _platformActive = active;
          }
          _appliedVersion = version;
        }
      } finally {
        if (identical(_focusDrain, focusDrain)) {
          _focusDrain = null;
        }
      }
    }();
    _focusDrain = focusDrain;
    await focusDrain;
  }

  Future<void> handleInterruption(AudioInterruptionEvent event) {
    return _enqueueEvent(() => _handleInterruption(event));
  }

  Future<void> _handleInterruption(AudioInterruptionEvent event) async {
    final client = _activeClient;
    if (event.begin) {
      if (client == null || !client.isPlaying()) return;
      switch (event.type) {
        case AudioInterruptionType.duck:
          final volume = client.getVolume?.call();
          final setVolume = client.setVolume;
          if (volume != null && setVolume != null) {
            _duckedClient = client;
            _volumeBeforeDuck = volume;
            try {
              await setVolume(volume * 0.5);
            } finally {
              if (!identical(_duckedClient, client)) {
                await setVolume(volume);
              }
            }
          } else {
            _interruptedClient = client;
            await client.pause(true);
          }
        case AudioInterruptionType.pause:
        case AudioInterruptionType.unknown:
          _interruptedClient = client;
          await client.pause(true);
      }
      return;
    }

    switch (event.type) {
      case AudioInterruptionType.duck:
        if (client != null && identical(client, _duckedClient)) {
          await _restoreVolume(client);
        } else if (client != null && identical(client, _interruptedClient)) {
          _interruptedClient = null;
          await client.play();
        }
      case AudioInterruptionType.pause:
        if (client != null && identical(client, _interruptedClient)) {
          _interruptedClient = null;
          await client.play();
        }
      case AudioInterruptionType.unknown:
        if (identical(client, _interruptedClient)) {
          _interruptedClient = null;
        }
    }
  }

  Future<void> handleBecomingNoisy() {
    return _enqueueEvent(_handleBecomingNoisy);
  }

  Future<void> _handleBecomingNoisy() async {
    final client = _activeClient;
    if (client == null || !client.isPlaying()) return;
    if (identical(client, _duckedClient)) {
      await _restoreVolume(client);
    }
    _interruptedClient = null;
    await client.pause(false);
  }

  Future<void> _enqueueEvent(Future<void> Function() event) async {
    final previous = _eventTail;
    final completed = Completer<void>();
    _eventTail = completed.future;
    try {
      await previous;
      await event();
    } finally {
      completed.complete();
    }
  }

  Future<void> _restoreVolume(AudioPlaybackClient client) async {
    final volume = _volumeBeforeDuck;
    final setVolume = client.setVolume;
    _duckedClient = null;
    _volumeBeforeDuck = null;
    if (volume != null && setVolume != null) {
      await setVolume(volume);
    }
  }
}
