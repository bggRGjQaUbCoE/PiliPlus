import 'dart:async' show Future, StreamSubscription;

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/services/audio_session_coordinator.dart';
import 'package:audio_session/audio_session.dart';

class AudioSessionHandler {
  AudioSessionHandler() {
    _sessionFuture = _initSession();
    _coordinator = AudioSessionCoordinator(_setPlatformActive);
    ready = _listenForSessionEvents();
  }

  static final Object _legacyPlOwner = Object();

  late final Future<AudioSession> _sessionFuture;
  late final AudioSessionCoordinator _coordinator;
  late final Future<void> ready;
  List<StreamSubscription<void>>? _subscriptions;

  Future<AudioSession> _initSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    return session;
  }

  Future<void> _listenForSessionEvents() async {
    final session = await _sessionFuture;
    _subscriptions = [
      session.interruptionEventStream.listen((event) {
        _coordinator.handleInterruption(event).ignore();
      }),
      session.becomingNoisyEventStream.listen((_) {
        _coordinator.handleBecomingNoisy().ignore();
      }),
    ];
  }

  Future<bool> _setPlatformActive(bool active) async {
    final session = await _sessionFuture;
    return session.setActive(active);
  }

  Future<bool> setActive(
    bool active, {
    Object? owner,
    AudioPlaybackClient? client,
  }) {
    final effectiveOwner =
        owner ?? PlPlayerController.instance ?? _legacyPlOwner;
    if (active) {
      return _coordinator.activate(client ?? _plClient(effectiveOwner));
    }
    return _coordinator.deactivate(effectiveOwner);
  }

  AudioPlaybackClient _plClient(Object owner) => AudioPlaybackClient(
    owner: owner,
    isPlaying: () =>
        PlPlayerController.getPlayerStatusIfExists() == PlayerStatus.playing,
    play: () async {
      await PlPlayerController.playIfExists();
    },
    pause: (interrupted) async {
      await PlPlayerController.pauseIfExists(isInterrupt: interrupted);
    },
    getVolume: PlPlayerController.getVolumeIfExists,
    setVolume: (volume) async {
      await PlPlayerController.setVolumeIfExists(
        volume,
        showIndicator: false,
      );
    },
  );

  Future<void> dispose() async {
    final subscriptions = _subscriptions;
    _subscriptions = null;
    if (subscriptions != null) {
      await Future.wait(
        subscriptions.map((subscription) => subscription.cancel()),
      );
    }
  }
}
