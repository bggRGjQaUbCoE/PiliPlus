import 'dart:async';

import 'package:PiliPlus/services/audio_session_coordinator.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'pause interruption pauses and resumes the active dedicated player',
    () async {
      final events = <String>[];
      var playing = true;
      final coordinator = AudioSessionCoordinator((_) async => true);
      final client = _client(
        owner: Object(),
        isPlaying: () => playing,
        onPlay: () {
          playing = true;
          events.add('play');
        },
        onPause: (interrupted) {
          playing = false;
          events.add('pause:$interrupted');
        },
      );
      await coordinator.activate(client);

      await coordinator.handleInterruption(
        AudioInterruptionEvent(true, AudioInterruptionType.pause),
      );
      await coordinator.handleInterruption(
        AudioInterruptionEvent(false, AudioInterruptionType.pause),
      );

      expect(events, ['pause:true', 'play']);
    },
  );

  test('becoming noisy pauses and deactivates the active player', () async {
    final focus = <bool>[];
    var playing = true;
    final owner = Object();
    late final AudioSessionCoordinator coordinator;
    final client = _client(
      owner: owner,
      isPlaying: () => playing,
      onPlay: () => playing = true,
      onPause: (interrupted) async {
        playing = false;
        if (!interrupted) {
          await coordinator.deactivate(owner);
        }
      },
    );
    coordinator = AudioSessionCoordinator((active) async {
      focus.add(active);
      return true;
    });
    await coordinator.activate(client);

    await coordinator.handleBecomingNoisy();

    expect(playing, isFalse);
    expect(focus, [true, false]);
    expect(coordinator.activeClient, isNull);
  });

  test('a stale owner cannot deactivate the current player', () async {
    final focus = <bool>[];
    final coordinator = AudioSessionCoordinator((active) async {
      focus.add(active);
      return true;
    });
    final firstOwner = Object();
    final secondOwner = Object();
    await coordinator.activate(_client(owner: firstOwner));
    final second = _client(owner: secondOwner);
    await coordinator.activate(second);

    expect(await coordinator.deactivate(firstOwner), isTrue);

    expect(coordinator.activeClient, same(second));
    expect(focus, [true, true]);
  });

  test('focus operations converge on the newest owner', () async {
    final firstActivation = Completer<bool>();
    final platformCalls = <bool>[];
    var call = 0;
    final coordinator = AudioSessionCoordinator((active) {
      platformCalls.add(active);
      call++;
      if (call == 1) return firstActivation.future;
      return Future.value(true);
    });
    final owner = Object();
    final activate = coordinator.activate(_client(owner: owner));
    final deactivate = coordinator.deactivate(owner);
    firstActivation.complete(true);

    expect(await activate, isFalse);
    expect(await deactivate, isTrue);
    expect(platformCalls, [true, false]);
    expect(coordinator.activeClient, isNull);
  });

  test('denied focus does not leave a client marked active', () async {
    final coordinator = AudioSessionCoordinator((_) async => false);
    var playCount = 0;
    final client = _client(
      owner: Object(),
      onPlay: () => playCount++,
    );

    final started = await startPlaybackWithAudioFocus(
      activate: () => coordinator.activate(client),
      canStart: () => true,
      start: client.play,
      deactivate: () async {
        await coordinator.deactivate(client.owner);
      },
    );

    expect(started, isFalse);
    expect(playCount, 0);
    expect(coordinator.activeClient, isNull);
  });

  test('a failed focused playback start releases its owner', () async {
    final focus = <bool>[];
    final owner = Object();
    final client = _client(owner: owner);
    final coordinator = AudioSessionCoordinator((active) async {
      focus.add(active);
      return true;
    });

    final start = startPlaybackWithAudioFocus(
      activate: () => coordinator.activate(client),
      canStart: () => true,
      start: () async => throw StateError('native play failed'),
      deactivate: () async {
        await coordinator.deactivate(owner);
      },
    );

    await expectLater(start, throwsStateError);
    expect(focus, [true, false]);
    expect(coordinator.activeClient, isNull);
  });

  test(
    'an interrupted old owner is not resumed after ownership changes',
    () async {
      var firstPlaying = true;
      var firstResumeCount = 0;
      final coordinator = AudioSessionCoordinator((_) async => true);
      final first = _client(
        owner: Object(),
        isPlaying: () => firstPlaying,
        onPlay: () {
          firstPlaying = true;
          firstResumeCount++;
        },
        onPause: (_) => firstPlaying = false,
      );
      await coordinator.activate(first);
      await coordinator.handleInterruption(
        AudioInterruptionEvent(true, AudioInterruptionType.pause),
      );
      await coordinator.activate(_client(owner: Object()));

      await coordinator.handleInterruption(
        AudioInterruptionEvent(false, AudioInterruptionType.pause),
      );

      expect(firstResumeCount, 0);
    },
  );

  test(
    'a ducked old owner is restored exactly before ownership changes',
    () async {
      var firstVolume = 73.0;
      final coordinator = AudioSessionCoordinator((_) async => true);
      final first = AudioPlaybackClient(
        owner: Object(),
        isPlaying: () => true,
        play: () async {},
        pause: (_) async {},
        getVolume: () => firstVolume,
        setVolume: (volume) async => firstVolume = volume,
      );
      await coordinator.activate(first);
      await coordinator.handleInterruption(
        AudioInterruptionEvent(true, AudioInterruptionType.duck),
      );

      expect(firstVolume, 36.5);

      final second = _client(owner: Object());
      await coordinator.activate(second);
      await coordinator.handleInterruption(
        AudioInterruptionEvent(false, AudioInterruptionType.duck),
      );

      expect(firstVolume, 73.0);
      expect(coordinator.activeClient, same(second));
    },
  );

  test(
    'a deferred stale duck write cannot outlive a new owner restore',
    () async {
      final duckStarted = Completer<void>();
      final duckWrite = Completer<void>();
      final restoreStarted = Completer<void>();
      final firstRestore = Completer<void>();
      final volumeWrites = <double>[];
      var firstVolume = 80.0;
      final coordinator = AudioSessionCoordinator((_) async => true);
      final first = AudioPlaybackClient(
        owner: Object(),
        isPlaying: () => true,
        play: () async {},
        pause: (_) async {},
        getVolume: () => firstVolume,
        setVolume: (volume) async {
          volumeWrites.add(volume);
          if (volume == 40) {
            duckStarted.complete();
            await duckWrite.future;
          } else if (!firstRestore.isCompleted) {
            restoreStarted.complete();
            await firstRestore.future;
          }
          firstVolume = volume;
        },
      );
      await coordinator.activate(first);

      final duck = coordinator.handleInterruption(
        AudioInterruptionEvent(true, AudioInterruptionType.duck),
      );
      await duckStarted.future;
      final second = _client(owner: Object());
      final activateSecond = coordinator.activate(second);
      await restoreStarted.future;

      firstRestore.complete();
      expect(await activateSecond, isTrue);
      duckWrite.complete();
      await duck;

      expect(volumeWrites, [40.0, 80.0, 80.0]);
      expect(firstVolume, 80.0);
      expect(coordinator.activeClient, same(second));
    },
  );
}

AudioPlaybackClient _client({
  required Object owner,
  bool Function()? isPlaying,
  void Function()? onPlay,
  FutureOr<void> Function(bool interrupted)? onPause,
}) => AudioPlaybackClient(
  owner: owner,
  isPlaying: isPlaying ?? () => true,
  play: () async => onPlay?.call(),
  pause: (interrupted) async => onPause?.call(interrupted),
);
