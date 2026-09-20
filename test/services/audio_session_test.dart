import 'dart:async';

import 'package:PiliPlus/services/audio_session.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_test/flutter_test.dart';

class _AudioSession extends Fake implements AudioSession {
  final configured = Completer<void>();
  final calls = <bool>[];
  Future<bool> Function(bool)? activate;

  @override
  Future<void> configure(AudioSessionConfiguration configuration) =>
      configured.future;

  @override
  Stream<AudioInterruptionEvent> get interruptionEventStream =>
      const Stream.empty();

  @override
  Stream<void> get becomingNoisyEventStream => const Stream.empty();

  @override
  Future<bool> setActive(
    bool active, {
    AVAudioSessionSetActiveOptions? avAudioSessionSetActiveOptions,
    AndroidAudioFocusGainType? androidAudioFocusGainType,
    AndroidAudioAttributes? androidAudioAttributes,
    bool? androidWillPauseWhenDucked,
    AudioSessionConfiguration fallbackConfiguration =
        const AudioSessionConfiguration.music(),
  }) async {
    calls.add(active);
    return activate == null ? true : await activate!(active);
  }
}

void main() {
  test('activation waits for session creation and configuration', () async {
    final instance = Completer<AudioSession>();
    final session = _AudioSession();
    final handler = AudioSessionHandler(session: instance.future);
    final activation = handler.setActive(true);
    var ready = false;
    handler.ready.then((_) => ready = true);

    await Future<void>.delayed(Duration.zero);
    expect(session.calls, isEmpty);
    instance.complete(session);
    await Future<void>.delayed(Duration.zero);
    expect(ready, isFalse);
    expect(session.calls, isEmpty);

    session.configured.complete();
    expect(await activation, isTrue);
    expect(ready, isTrue);
    expect(session.calls, [true]);
  });

  test('a new activation waits for pending deactivation', () async {
    final session = _AudioSession()..configured.complete();
    final deactivation = Completer<bool>();
    session.activate = (active) =>
        active ? Future.value(true) : deactivation.future;
    final handler = AudioSessionHandler(session: Future.value(session));
    await handler.ready;

    final pause = handler.setActive(false);
    final play = handler.setActive(true);
    await Future<void>.delayed(Duration.zero);
    expect(session.calls, [false]);

    deactivation.complete(true);
    await pause;
    expect(await play, isTrue);
    expect(session.calls, [false, true]);
  });

  test(
    'a failed session operation does not block subsequent activation',
    () async {
      final session = _AudioSession()
        ..configured.complete()
        ..activate = (active) async {
          if (!active) throw StateError('deactivation failed');
          return true;
        };
      final handler = AudioSessionHandler(session: Future.value(session));

      await expectLater(handler.setActive(false), throwsStateError);
      expect(await handler.setActive(true), isTrue);
      expect(session.calls, [false, true]);
    },
  );

  test('activation denial is returned to the caller', () async {
    final session = _AudioSession()
      ..configured.complete()
      ..activate = (_) async => false;
    final handler = AudioSessionHandler(session: Future.value(session));

    expect(await handler.setActive(true), isFalse);
  });
}
