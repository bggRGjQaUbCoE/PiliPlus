import 'dart:async';

import 'package:PiliPlus/services/video_together/entry_policy.dart';
import 'package:PiliPlus/services/video_together/models.dart';
import 'package:PiliPlus/services/video_together/navigation.dart';
import 'package:PiliPlus/services/video_together/playback.dart';
import 'package:PiliPlus/services/video_together/preferences.dart';
import 'package:PiliPlus/services/video_together/protocol.dart';
import 'package:PiliPlus/services/video_together/recovery.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoTogetherPlayerEntryPolicy', () {
    test('hides outside a room by default but always shows inside', () {
      expect(
        VideoTogetherPreferences.defaultHidePlayerEntryWhenNotInRoom,
        isTrue,
      );
      expect(
        VideoTogetherPlayerEntryPolicy.shouldShow(
          inRoom: false,
          hideWhenNotInRoom: true,
        ),
        isFalse,
      );
      expect(
        VideoTogetherPlayerEntryPolicy.shouldShow(
          inRoom: true,
          hideWhenNotInRoom: true,
        ),
        isTrue,
      );
      expect(
        VideoTogetherPlayerEntryPolicy.shouldShow(
          inRoom: false,
          hideWhenNotInRoom: false,
        ),
        isTrue,
      );
    });
  });

  group('VideoTogetherNavigationPolicy', () {
    test('uses countdown confirmation by default', () {
      expect(
        VideoTogetherPreferences.defaultNavigationMode,
        VideoTogetherNavigationMode.countdown,
      );
      expect(
        VideoTogetherNavigationPolicy.actionFor(
          mode: VideoTogetherPreferences.defaultNavigationMode,
          isVideoPage: false,
        ),
        VideoTogetherNavigationAction.confirm,
      );
    });

    test('maps all direct modes for video and non-video pages', () {
      expect(
        VideoTogetherNavigationPolicy.actionFor(
          mode: VideoTogetherNavigationMode.always,
          isVideoPage: false,
        ),
        VideoTogetherNavigationAction.open,
      );
      expect(
        VideoTogetherNavigationPolicy.actionFor(
          mode: VideoTogetherNavigationMode.videoPageOnly,
          isVideoPage: true,
        ),
        VideoTogetherNavigationAction.open,
      );
      expect(
        VideoTogetherNavigationPolicy.actionFor(
          mode: VideoTogetherNavigationMode.videoPageOnly,
          isVideoPage: false,
        ),
        VideoTogetherNavigationAction.defer,
      );
      expect(
        VideoTogetherNavigationPolicy.actionFor(
          mode: VideoTogetherNavigationMode.never,
          isVideoPage: true,
        ),
        VideoTogetherNavigationAction.defer,
      );
      expect(
        VideoTogetherNavigationPolicy.actionFor(
          mode: VideoTogetherNavigationMode.countdown,
          isVideoPage: true,
        ),
        VideoTogetherNavigationAction.confirm,
      );
    });

    test('manual room action bypasses every automatic mode', () {
      for (final mode in VideoTogetherNavigationMode.values) {
        expect(
          VideoTogetherNavigationPolicy.actionFor(
            mode: mode,
            isVideoPage: false,
            force: true,
          ),
          VideoTogetherNavigationAction.open,
        );
      }
    });
  });

  group('VideoTogetherNavigationPreferenceMigration', () {
    test('maps legacy enabled and disabled values', () {
      expect(
        VideoTogetherPreferences.resolveNavigationMode(
          legacyAutoOpen: true,
        ),
        VideoTogetherNavigationMode.always,
      );
      expect(
        VideoTogetherPreferences.resolveNavigationMode(
          legacyAutoOpen: false,
        ),
        VideoTogetherNavigationMode.never,
      );
    });

    test('new value wins and invalid values fall back safely', () {
      expect(
        VideoTogetherPreferences.resolveNavigationMode(
          storedMode: 'videoPageOnly',
          legacyAutoOpen: false,
        ),
        VideoTogetherNavigationMode.videoPageOnly,
      );
      expect(
        VideoTogetherPreferences.resolveNavigationMode(
          storedMode: VideoTogetherNavigationMode.countdown.index,
          legacyAutoOpen: false,
        ),
        VideoTogetherNavigationMode.countdown,
      );
      expect(
        VideoTogetherPreferences.resolveNavigationMode(
          storedMode: 'removed-mode',
        ),
        VideoTogetherNavigationMode.countdown,
      );
    });
  });

  group('VideoTogetherProtocol', () {
    test('maps HTTP server address to official WebSocket endpoint', () {
      expect(
        VideoTogetherProtocol.webSocketUri('https://vt.panghair.com:5000/')
            .toString(),
        'wss://vt.panghair.com:5000/ws?language=zh-cn',
      );
      expect(
        VideoTogetherProtocol.webSocketUri('http://localhost:5001/base/')
            .toString(),
        'ws://localhost:5001/base/ws?language=zh-cn',
      );
    });

    test('rejects unsupported server schemes', () {
      expect(
        () => VideoTogetherProtocol.serverUri('ftp://example.com'),
        throwsFormatException,
      );
      expect(
        () => VideoTogetherProtocol.serverUri('example.com'),
        throwsFormatException,
      );
    });

    test('encodes official member field spelling', () {
      final message = VideoTogetherProtocol.memberUpdateRequest(
        roomName: 'room',
        password: 'password',
        userId: 'user',
        isLoading: true,
        currentUrl: 'https://www.bilibili.com/video/BV1xx',
        sendLocalTimestamp: 10,
      );
      expect(message['method'], '/room/update_member');
      final data = message['data']! as Map<String, dynamic>;
      expect(data['isLoadding'], isTrue);
      expect(data.containsKey('isLoading'), isFalse);
    });

    test('uses NTP-compatible four timestamp calculation', () {
      expect(
        VideoTogetherProtocol.clockOffset(
          localSend: 100,
          serverReceive: 102,
          serverSend: 102.2,
          localReceive: 100.4,
        ),
        closeTo(1.9, 0.000001),
      );
      expect(
        VideoTogetherProtocol.roundTrip(
          localSend: 100,
          serverReceive: 102,
          serverSend: 102.2,
          localReceive: 100.4,
        ),
        closeTo(0.2, 0.000001),
      );
    });
  });

  group('VideoTogetherRoom', () {
    test('parses server values and projects a playing position', () {
      final room = VideoTogetherRoom.fromJson({
        'name': 'room',
        'lastUpdateClientTime': 10,
        'lastUpdateServerTime': 10.1,
        'playbackRate': 1.5,
        'currentTime': 20,
        'paused': false,
        'url': 'https://www.bilibili.com/video/BV1xx',
        'duration': 100,
        'public': false,
        'protected': true,
        'videoTitle': 'title',
        'waitForLoadding': true,
        'memberCount': 2,
      });

      expect(room.waitForLoading, isTrue);
      expect(room.memberCount, 2);
      expect(room.targetPosition(12), closeTo(23, 0.000001));
    });

    test('does not advance paused rooms', () {
      final room = VideoTogetherRoom.fromJson({
        'currentTime': 42,
        'paused': true,
      });
      expect(room.targetPosition(999), 42);
    });
  });

  group('VideoTogetherMediaIdentity', () {
    test('matches the same BV and defaults to first part', () {
      final first = VideoTogetherMediaIdentity.fromUrl(
        'https://www.bilibili.com/video/BV1ABC?spm_id_from=333',
      );
      final second = VideoTogetherMediaIdentity.fromUrl(
        'https://m.bilibili.com/video/bv1abc?p=1',
      );
      expect(first.sameAs(second), isTrue);
    });

    test('distinguishes different parts and episodes', () {
      final partOne = VideoTogetherMediaIdentity.fromUrl(
        'https://www.bilibili.com/video/BV1ABC?p=1',
      );
      final partTwo = VideoTogetherMediaIdentity.fromUrl(
        'https://www.bilibili.com/video/BV1ABC?p=2',
      );
      final episodeOne = VideoTogetherMediaIdentity.fromUrl(
        'https://www.bilibili.com/bangumi/play/ep100',
      );
      final episodeTwo = VideoTogetherMediaIdentity.fromUrl(
        'https://www.bilibili.com/bangumi/play/ep101',
      );
      expect(partOne.sameAs(partTwo), isFalse);
      expect(episodeOne.sameAs(episodeTwo), isFalse);
    });

    test('ignores VideoTogether state parameters for generic URLs', () {
      final first = VideoTogetherMediaIdentity.fromUrl(
        'https://example.com/watch?id=1&VideoTogetherRoomName=room',
      );
      final second = VideoTogetherMediaIdentity.fromUrl(
        'https://example.com/watch?id=1',
      );
      expect(first.sameAs(second), isTrue);
    });

    test('removes ignored-only queries and fragments from generic URLs', () {
      final decorated = VideoTogetherMediaIdentity.fromUrl(
        'https://example.com/watch?VideoTogetherRoomName=room#position',
      );
      final plain = VideoTogetherMediaIdentity.fromUrl(
        'https://example.com/watch',
      );
      expect(decorated.sameAs(plain), isTrue);
    });
  });

  group('VideoTogetherLocalChangeDetector', () {
    VideoTogetherPlaybackSnapshot snapshot({
      required double capturedAt,
      required bool isPlaying,
      required double position,
      double rate = 1,
      bool isBuffering = false,
    }) => VideoTogetherPlaybackSnapshot(
      capturedAt: capturedAt,
      isReady: true,
      isPlaying: isPlaying,
      isBuffering: isBuffering,
      positionSeconds: position,
      durationSeconds: 100,
      playbackRate: rate,
    );

    test('does not treat natural playback progress as a local action', () {
      final previous = snapshot(
        capturedAt: 100,
        isPlaying: true,
        position: 10,
      );
      final current = snapshot(
        capturedAt: 100.4,
        isPlaying: true,
        position: 10.4,
      );

      expect(
        VideoTogetherLocalChangeDetector.hasUserDrivenChange(
          previous,
          current,
        ),
        isFalse,
      );
    });

    test('detects play and pause changes', () {
      final previous = snapshot(
        capturedAt: 100,
        isPlaying: true,
        position: 10,
      );
      final current = snapshot(
        capturedAt: 100.2,
        isPlaying: false,
        position: 10.2,
      );

      expect(
        VideoTogetherLocalChangeDetector.hasUserDrivenChange(
          previous,
          current,
        ),
        isTrue,
      );
    });

    test('detects seeks and playback-rate changes', () {
      final previous = snapshot(
        capturedAt: 100,
        isPlaying: true,
        position: 10,
      );
      final seek = snapshot(
        capturedAt: 100.4,
        isPlaying: true,
        position: 20,
      );
      final rate = snapshot(
        capturedAt: 100.4,
        isPlaying: true,
        position: 10.4,
        rate: 2,
      );

      expect(
        VideoTogetherLocalChangeDetector.hasUserDrivenChange(previous, seek),
        isTrue,
      );
      expect(
        VideoTogetherLocalChangeDetector.hasUserDrivenChange(previous, rate),
        isTrue,
      );
    });

    test('ignores buffering transitions', () {
      final previous = snapshot(
        capturedAt: 100,
        isPlaying: true,
        position: 10,
      );
      final buffering = snapshot(
        capturedAt: 100.4,
        isPlaying: false,
        position: 10.1,
        isBuffering: true,
      );

      expect(
        VideoTogetherLocalChangeDetector.hasUserDrivenChange(
          previous,
          buffering,
        ),
        isFalse,
      );

      final resumed = snapshot(
        capturedAt: 100.8,
        isPlaying: true,
        position: 10.2,
      );
      expect(
        VideoTogetherLocalChangeDetector.hasUserDrivenChange(
          buffering,
          resumed,
        ),
        isFalse,
      );
    });
  });

  group('VideoTogetherSyncPolicy', () {
    test('defaults the playing correction threshold to half a second', () {
      expect(VideoTogetherPreferences.defaultSyncThreshold, 0.5);
    });

    test('compatibility mode keeps joined members read-only', () {
      expect(
        VideoTogetherSyncPolicy.canTakeControl(
          hasHeldControl: false,
          bidirectionalSync: false,
        ),
        isFalse,
      );
      expect(
        VideoTogetherSyncPolicy.canTakeControl(
          hasHeldControl: true,
          bidirectionalSync: false,
        ),
        isTrue,
      );
      expect(
        VideoTogetherSyncPolicy.canTakeControl(
          hasHeldControl: false,
          bidirectionalSync: true,
        ),
        isTrue,
      );
    });

    test('a local media change retakes control for a previous controller', () {
      expect(
        VideoTogetherSyncPolicy.shouldPrioritizeLocalMediaChange(
          pendingMediaChange: true,
          hasHeldControl: true,
          bidirectionalSync: false,
        ),
        isTrue,
      );
      expect(
        VideoTogetherSyncPolicy.shouldPrioritizeLocalMediaChange(
          pendingMediaChange: true,
          hasHeldControl: false,
          bidirectionalSync: true,
        ),
        isTrue,
      );
      expect(
        VideoTogetherSyncPolicy.shouldPrioritizeLocalMediaChange(
          pendingMediaChange: true,
          hasHeldControl: false,
          bidirectionalSync: false,
        ),
        isFalse,
      );
    });

    test('uses precise correction while the room is paused', () {
      expect(
        VideoTogetherSyncPolicy.correctionThreshold(
          roomPaused: true,
          playingThreshold: 0.5,
        ),
        0.1,
      );
      expect(
        VideoTogetherSyncPolicy.correctionThreshold(
          roomPaused: false,
          playingThreshold: 0.5,
        ),
        0.5,
      );
    });

    test('uses precise correction during a temporary loading pause', () {
      final shouldPause = VideoTogetherSyncPolicy.shouldPauseForMemberLoading(
        waitForLoadingEnabled: true,
        roomWaitsForLoading: true,
        roomPaused: false,
        localBuffering: false,
      );
      expect(
        VideoTogetherSyncPolicy.correctionThreshold(
          roomPaused: shouldPause,
          playingThreshold: 0.5,
        ),
        0.1,
      );
    });

    test('only non-buffering members pause while waiting for loading', () {
      expect(
        VideoTogetherSyncPolicy.shouldPauseForMemberLoading(
          waitForLoadingEnabled: true,
          roomWaitsForLoading: true,
          roomPaused: false,
          localBuffering: false,
        ),
        isTrue,
      );
      expect(
        VideoTogetherSyncPolicy.shouldPauseForMemberLoading(
          waitForLoadingEnabled: true,
          roomWaitsForLoading: true,
          roomPaused: false,
          localBuffering: true,
        ),
        isFalse,
      );
    });

    test('loading pause does not become a user pause in room state', () {
      expect(
        VideoTogetherSyncPolicy.advertisedPaused(
          isReady: true,
          isPlaying: false,
          isBuffering: false,
          pausedForMemberLoading: true,
        ),
        isFalse,
      );
      expect(
        VideoTogetherSyncPolicy.advertisedPaused(
          isReady: true,
          isPlaying: false,
          isBuffering: false,
          pausedForMemberLoading: false,
        ),
        isTrue,
      );
    });
  });

  group('VideoTogetherRemotePlaybackReconciler', () {
    test(
      'starts an initially idle player even when cached status is stale',
      () {
        final reconciler = VideoTogetherRemotePlaybackReconciler();

        expect(
          reconciler.reconcile(shouldPause: false, isPlaying: true),
          VideoTogetherPlaybackCommand.play,
        );
        expect(
          reconciler.reconcile(shouldPause: false, isPlaying: true),
          VideoTogetherPlaybackCommand.none,
        );
      },
    );

    test('resumes after a remote pause even when local status is stale', () {
      final reconciler = VideoTogetherRemotePlaybackReconciler();

      expect(
        reconciler.reconcile(shouldPause: true, isPlaying: true),
        VideoTogetherPlaybackCommand.pause,
      );
      expect(
        reconciler.reconcile(shouldPause: false, isPlaying: true),
        VideoTogetherPlaybackCommand.play,
      );
    });

    test(
      'retries when the actual player diverges from a stable room state',
      () {
        final reconciler = VideoTogetherRemotePlaybackReconciler();

        expect(
          reconciler.reconcile(shouldPause: false, isPlaying: false),
          VideoTogetherPlaybackCommand.play,
        );
        expect(
          reconciler.reconcile(shouldPause: false, isPlaying: false),
          VideoTogetherPlaybackCommand.play,
        );

        expect(
          reconciler.reconcile(shouldPause: true, isPlaying: true),
          VideoTogetherPlaybackCommand.pause,
        );
        expect(
          reconciler.reconcile(shouldPause: true, isPlaying: true),
          VideoTogetherPlaybackCommand.pause,
        );
      },
    );
  });

  group('VideoTogetherReconnectBackoff', () {
    test('backs off repeated failures and allows forced recovery', () {
      final backoff = VideoTogetherReconnectBackoff();

      expect(backoff.canAttempt(10), isTrue);
      expect(backoff.registerFailure(10), const Duration(seconds: 1));
      expect(backoff.canAttempt(10.9), isFalse);
      expect(backoff.canAttempt(10.9, force: true), isTrue);
      expect(backoff.canAttempt(11), isTrue);

      expect(backoff.registerFailure(11), const Duration(seconds: 2));
      expect(backoff.failureCount, 2);
      expect(backoff.nextAttemptAt, 13);

      backoff.reset();
      expect(backoff.failureCount, 0);
      expect(backoff.canAttempt(0), isTrue);
    });
  });

  group('VideoTogetherReconnectQueue', () {
    test('coalesces reconnect causes without losing recovery flags', () {
      final queue = VideoTogetherReconnectQueue()
        ..add(restartPlayback: true)
        ..add(forceFollower: true)
        ..add(force: true);

      expect(queue.hasPending, isTrue);
      final request = queue.take()!;
      expect(request.forceFollower, isTrue);
      expect(request.force, isTrue);
      expect(request.restartPlayback, isTrue);
      expect(queue.hasPending, isFalse);
      expect(queue.take(), isNull);
    });

    test('clear discards a queued reconnect', () {
      final queue = VideoTogetherReconnectQueue()
        ..add(force: true)
        ..clear();

      expect(queue.hasPending, isFalse);
      expect(queue.take(), isNull);
    });
  });

  group('VideoTogetherConnectionWatchdog', () {
    test('expires a connected socket without server messages', () {
      expect(
        VideoTogetherConnectionWatchdog.isStale(
          lastMessageAt: 100,
          now: 107.9,
        ),
        isFalse,
      );
      expect(
        VideoTogetherConnectionWatchdog.isStale(
          lastMessageAt: 100,
          now: 108,
        ),
        isTrue,
      );
    });

    test('does not expire before the first server message', () {
      expect(
        VideoTogetherConnectionWatchdog.isStale(
          lastMessageAt: 0,
          now: 100,
        ),
        isFalse,
      );
    });

    test('uses monotonic elapsed time for an active socket', () {
      expect(
        VideoTogetherConnectionWatchdog.isStaleElapsed(
          const Duration(milliseconds: 7999),
        ),
        isFalse,
      );
      expect(
        VideoTogetherConnectionWatchdog.isStaleElapsed(
          const Duration(seconds: 8),
        ),
        isTrue,
      );
    });
  });
  group('VideoTogetherLifecyclePolicy', () {
    test('suspends ordinary background playback but keeps PiP active', () {
      expect(
        VideoTogetherLifecyclePolicy.shouldSuspend(
          playbackKeepsPlayingInBackground: false,
        ),
        isTrue,
      );
      expect(
        VideoTogetherLifecyclePolicy.shouldSuspend(
          playbackKeepsPlayingInBackground: true,
        ),
        isFalse,
      );
    });
  });
  group('VideoTogetherRemotePlaybackSynchronizer', () {
    VideoTogetherRoom room({required bool paused}) => VideoTogetherRoom(
      name: 'room',
      lastUpdateClientTime: 10,
      lastUpdateServerTime: 10,
      playbackRate: 1,
      currentTime: 12,
      paused: paused,
      url: 'https://www.bilibili.com/video/BV1ABC',
      duration: 100,
      isPublic: true,
      isProtected: false,
      videoTitle: 'title',
      waitForLoading: false,
      memberCount: 2,
    );

    Future<bool> apply(
      VideoTogetherRemotePlaybackSynchronizer synchronizer,
      _FakeVideoTogetherPlayback playback, {
      required bool paused,
      bool restartPlayback = false,
      bool Function()? isCurrent,
      void Function()? onRemoteCommand,
    }) => synchronizer.apply(
      playback: playback,
      room: room(paused: paused),
      getServerNow: () => 10,
      syncPlaybackRate: true,
      waitForLoading: true,
      playingThreshold: 0.5,
      restartPlayback: restartPlayback,
      isCurrent: isCurrent,
      onRemoteCommand: onRemoteCommand,
    );

    test(
      'prepares the stream before applying an initial remote play',
      () async {
        final synchronizer = VideoTogetherRemotePlaybackSynchronizer();
        final playback = _FakeVideoTogetherPlayback();

        expect(await apply(synchronizer, playback, paused: false), isTrue);
        expect(playback.prepareCount, 1);
        expect(playback.playCount, 1);
        expect(playback.isReady, isTrue);
        expect(playback.isPlaying, isTrue);
        expect(playback.positionSeconds, 12);
      },
    );

    test('retries preparation while the video URL is still loading', () async {
      final synchronizer = VideoTogetherRemotePlaybackSynchronizer();
      final playback = _FakeVideoTogetherPlayback(prepareMakesReady: false);

      expect(await apply(synchronizer, playback, paused: false), isFalse);
      expect(playback.prepareCount, 1);
      expect(playback.playCount, 0);

      playback.prepareMakesReady = true;
      expect(await apply(synchronizer, playback, paused: false), isTrue);
      expect(playback.prepareCount, 2);
      expect(playback.playCount, 1);
    });

    test('restarts an existing stream after connection recovery', () async {
      final synchronizer = VideoTogetherRemotePlaybackSynchronizer();
      final playback = _FakeVideoTogetherPlayback()
        ..isReady = true
        ..isPlaying = true
        ..positionSeconds = 12;

      expect(
        await apply(
          synchronizer,
          playback,
          paused: false,
          restartPlayback: true,
        ),
        isTrue,
      );
      expect(playback.recoverCount, 1);
      expect(playback.playCount, 1);
    });

    test('does not restart a paused room stream', () async {
      final synchronizer = VideoTogetherRemotePlaybackSynchronizer();
      final playback = _FakeVideoTogetherPlayback()
        ..isReady = true
        ..isPlaying = true;

      expect(
        await apply(
          synchronizer,
          playback,
          paused: true,
          restartPlayback: true,
        ),
        isTrue,
      );
      expect(playback.recoverCount, 0);
      expect(playback.pauseCount, 1);
    });
    test('does not initialize the stream while the room is paused', () async {
      final synchronizer = VideoTogetherRemotePlaybackSynchronizer();
      final playback = _FakeVideoTogetherPlayback();

      expect(await apply(synchronizer, playback, paused: true), isFalse);
      expect(playback.prepareCount, 0);
      expect(playback.playCount, 0);
      expect(playback.isReady, isFalse);
    });

    test(
      'keeps local-change suppression active across a delayed seek',
      () async {
        final synchronizer = VideoTogetherRemotePlaybackSynchronizer();
        final seekStarted = Completer<void>();
        final releaseSeek = Completer<void>();
        final playback = _FakeVideoTogetherPlayback(
          onSeek: (seconds) async {
            seekStarted.complete();
            await releaseSeek.future;
          },
        );
        var commandBoundaryCount = 0;

        final future = apply(
          synchronizer,
          playback,
          paused: false,
          onRemoteCommand: () => commandBoundaryCount += 1,
        );
        await seekStarted.future;
        expect(commandBoundaryCount.isOdd, isTrue);

        releaseSeek.complete();
        expect(await future, isTrue);
        expect(commandBoundaryCount.isEven, isTrue);
        expect(commandBoundaryCount, greaterThanOrEqualTo(6));
      },
    );

    test('stops issuing commands after the session epoch changes', () async {
      final synchronizer = VideoTogetherRemotePlaybackSynchronizer();
      final prepareStarted = Completer<void>();
      final releasePrepare = Completer<void>();
      var current = true;
      final playback = _FakeVideoTogetherPlayback(
        onPrepare: () async {
          prepareStarted.complete();
          await releasePrepare.future;
        },
      );

      final future = apply(
        synchronizer,
        playback,
        paused: false,
        isCurrent: () => current,
      );
      await prepareStarted.future;
      current = false;
      releasePrepare.complete();

      expect(await future, isFalse);
      expect(playback.prepareCount, 1);
      expect(playback.playCount, 0);
      expect(playback.positionSeconds, 0);
    });
  });
}

final class _FakeVideoTogetherPlayback implements VideoTogetherPlayback {
  _FakeVideoTogetherPlayback({
    this.prepareMakesReady = true,
    this.onPrepare,
    this.onSeek,
  });

  bool prepareMakesReady;
  final Future<void> Function()? onPrepare;
  final Future<void> Function(double seconds)? onSeek;
  int prepareCount = 0;
  int playCount = 0;
  int pauseCount = 0;
  int recoverCount = 0;

  @override
  bool isReady = false;

  @override
  bool isPlaying = false;

  @override
  bool isBuffering = false;
  @override
  bool get keepsPlayingInBackground => false;

  @override
  double positionSeconds = 0;

  @override
  double durationSeconds = 100;

  @override
  double playbackRate = 1;

  @override
  Future<void> prepare() async {
    prepareCount += 1;
    await onPrepare?.call();
    if (prepareMakesReady) isReady = true;
  }

  @override
  Future<void> recover() async {
    recoverCount += 1;
  }

  @override
  Future<void> play() async {
    playCount += 1;
    isPlaying = true;
  }

  @override
  Future<void> pause() async {
    pauseCount += 1;
    isPlaying = false;
  }

  @override
  Future<void> seek(double seconds) async {
    positionSeconds = seconds;
    await onSeek?.call(seconds);
  }

  @override
  Future<void> setPlaybackRate(double rate) async {
    playbackRate = rate;
  }
}
