import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/utils/playback_recovery_state.dart';
import 'package:PiliPlus/plugin/pl_player/utils/source_operation_gate.dart';
import 'package:PiliPlus/plugin/pl_player/utils/source_query_coordinator.dart';
import 'package:PiliPlus/plugin/pl_player/utils/source_recovery_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SourceQueryCoordinator', () {
    test('shares same-revision work and does not block a newer source', () async {
      final queries = SourceQueryCoordinator();
      final old = Completer<bool>();
      final next = Completer<bool>();
      final first = queries.run(1, () => old.future);
      expect(queries.run(1, () async => false), same(first));
      final second = queries.run(2, () => next.future);
      old.complete(false);
      expect(await first, isFalse);
      expect(queries.current, same(second));
      next.complete(true);
      expect(await second, isTrue);
      expect(queries.isRunning, isFalse);
    });
  });

  group('SourceOperationGate', () {
    test('a newer owner cancels a queued or in-flight source open', () async {
      final gate = SourceOperationGate();
      final ready = Completer<void>();
      final release = Completer<void>();
      final opened = <String>[];
      var owner = 'A';
      final first = gate.run(
        gate.begin(),
        ownerIsCurrent: () => owner == 'A',
        operation: (isCurrent) async {
          ready.complete();
          await release.future;
          if (isCurrent()) opened.add('A');
        },
      );
      await ready.future;
      owner = 'B';
      final second = gate.run(
        gate.begin(),
        ownerIsCurrent: () => owner == 'B',
        operation: (isCurrent) async {
          if (isCurrent()) opened.add('B');
        },
      );
      release.complete();
      await Future.wait([first, second]);
      expect(opened, ['B']);
    });
  });

  group('PlaybackRecoveryState', () {
    test('temporary pauses preserve intent, user pauses cancel it', () {
      final state = PlaybackRecoveryState()..requestPlay();
      final revision = state.intentRevision;
      state.pause(userInitiated: false);
      expect(state.wantsPlayback, isTrue);
      expect(state.intentRevision, revision);
      state
        ..pause(userInitiated: true)
        ..requestAutoplay();
      expect(state.wantsPlayback, isFalse);
      expect(state.intentRevision, greaterThan(revision));
      expect(
        state.canAutoplay(requested: true, recovering: false, ownerCurrent: true),
        isFalse,
      );
    });

    test('a coalesced query does not autoplay inside recovery', () {
      final state = PlaybackRecoveryState()..requestPlay();
      expect(
        state.canAutoplay(requested: true, recovering: true, ownerCurrent: true),
        isFalse,
      );
      expect(
        state.canAutoplay(requested: true, recovering: false, ownerCurrent: true),
        isTrue,
      );
    });

    test('invalidating pending work does not change playback intent', () {
      final state = PlaybackRecoveryState()..requestPlay();
      final revision = state.intentRevision;
      state.invalidatePending();
      expect(state.wantsPlayback, isTrue);
      expect(state.intentRevision, greaterThan(revision));
    });

    test('a later seek overrides a recovery snapshot', () {
      final state = PlaybackRecoveryState();
      final revision = state.seekRevision;
      state.seek(const Duration(minutes: 8));
      expect(
        state.positionAfter(revision, const Duration(minutes: 2)),
        const Duration(minutes: 8),
      );
      state.resetForNewOwner();
      expect(state.positionAfter(revision, Duration.zero), Duration.zero);
    });

    test('remembers intent when a source refresh pauses in background', () {
      final state = PlaybackRecoveryState()..requestPlay();
      expect(
        state.rememberBackground(playerPlaying: false, replacingSource: true),
        isTrue,
      );
      expect(
        state.resumeAfterBackground(
          wasPlaying: true,
          pausedByBackground: false,
          completed: false,
        ),
        isTrue,
      );
      state.pause(userInitiated: true);
      expect(
        state.resumeAfterBackground(
          wasPlaying: true,
          pausedByBackground: false,
          completed: false,
        ),
        isFalse,
      );
    });

    test('deferred autoplay survives a missed background event', () {
      final state = PlaybackRecoveryState()
        ..requestAutoplay()
        ..deferUntilForeground();
      expect(state.pendingForeground, isTrue);
      expect(
        state.resumeAfterBackground(
          wasPlaying: false,
          pausedByBackground: false,
          completed: false,
        ),
        isTrue,
      );
      state.pause(userInitiated: true);
      expect(state.pendingForeground, isFalse);
    });
  });

  group('SourceRecoveryPolicy', () {
    test('cooldown survives successful source reopen', () {
      final policy = SourceRecoveryPolicy();
      final now = DateTime.utc(2026);
      policy.started(now);
      expect(policy.canStart(now.add(const Duration(seconds: 3))), isFalse);
      expect(policy.canStart(now.add(const Duration(seconds: 20))), isTrue);
      expect(policy.canStart(now, immediate: true), isTrue);
    });

    test('decoder recovery is limited until a healthy interval', () {
      final policy = SourceRecoveryPolicy();
      final start = DateTime.utc(2026);
      for (var i = 0; i < 3; i++) {
        final time = start.add(Duration(seconds: i * 21));
        expect(policy.corruption(time, playing: true, seeking: false), isFalse);
        final second = time.add(const Duration(seconds: 1));
        expect(
          policy.corruption(second, playing: true, seeking: false),
          isTrue,
        );
        policy.started(second);
      }
      final time = start.add(const Duration(seconds: 63));
      expect(policy.corruption(time, playing: true, seeking: false), isFalse);
      expect(
        policy.corruption(
          time.add(const Duration(seconds: 1)),
          playing: true,
          seeking: false,
        ),
        isFalse,
      );
      final healthy = time.add(const Duration(seconds: 70));
      expect(
        policy.corruption(healthy, playing: true, seeking: false),
        isFalse,
      );
      expect(
        policy.corruption(
          healthy.add(const Duration(seconds: 1)),
          playing: true,
          seeking: false,
        ),
        isTrue,
      );
    });

    test('failed opens have at most three exponential retries', () {
      final policy = SourceRecoveryPolicy();
      expect(policy.nextRetryDelay(), const Duration(seconds: 5));
      expect(policy.nextRetryDelay(), const Duration(seconds: 10));
      expect(policy.nextRetryDelay(), const Duration(seconds: 20));
      expect(policy.nextRetryDelay(), isNull);
      policy.resetRetries();
      expect(policy.nextRetryDelay(), const Duration(seconds: 5));
    });
  });
}
