import 'package:PiliPlus/services/video_together/models.dart';

typedef VideoTogetherPreparePlayback = Future<void>? Function();

abstract interface class VideoTogetherPlayback {
  bool get isReady;
  bool get isPlaying;
  bool get isBuffering;
  bool get keepsPlayingInBackground;
  double get positionSeconds;
  double get durationSeconds;
  double get playbackRate;

  Future<void> prepare();
  Future<void> recover();
  Future<void> play();
  Future<void> pause();
  Future<void> seek(double seconds);
  Future<void> setPlaybackRate(double rate);
}

enum VideoTogetherPlaybackCommand { none, play, pause }

final class VideoTogetherRemotePlaybackReconciler {
  bool? _lastShouldPause;

  VideoTogetherPlaybackCommand reconcile({
    required bool shouldPause,
    required bool isPlaying,
  }) {
    final remoteStateChanged = _lastShouldPause != shouldPause;
    _lastShouldPause = shouldPause;

    if (shouldPause) {
      return remoteStateChanged || isPlaying
          ? VideoTogetherPlaybackCommand.pause
          : VideoTogetherPlaybackCommand.none;
    }
    return remoteStateChanged || !isPlaying
        ? VideoTogetherPlaybackCommand.play
        : VideoTogetherPlaybackCommand.none;
  }

  void reset() => _lastShouldPause = null;
}

final class VideoTogetherRemotePlaybackSynchronizer {
  final _reconciler = VideoTogetherRemotePlaybackReconciler();

  Future<bool> apply({
    required VideoTogetherPlayback playback,
    required VideoTogetherRoom room,
    required double Function() getServerNow,
    required bool syncPlaybackRate,
    required bool waitForLoading,
    required double playingThreshold,
    bool restartPlayback = false,
    bool Function()? isCurrent,
    void Function()? onRemoteCommand,
  }) async {
    bool current() => isCurrent?.call() ?? true;

    Future<bool> applyCommand(Future<void> Function() action) async {
      if (!current()) return false;
      onRemoteCommand?.call();
      try {
        await action();
      } finally {
        onRemoteCommand?.call();
      }
      return current();
    }

    try {
      if (!current()) return false;
      final wasReady = playback.isReady;
      if (!playback.isReady) {
        if (room.paused) return false;
        if (!await applyCommand(playback.prepare)) return false;
        if (!playback.isReady) return false;
      }
      if (restartPlayback && wasReady && !room.paused) {
        if (!await applyCommand(playback.recover)) return false;
        _reconciler.reset();
      }

      if (syncPlaybackRate &&
          (playback.playbackRate - room.playbackRate).abs() > 0.01) {
        if (!await applyCommand(
          () => playback.setPlaybackRate(room.playbackRate),
        )) {
          return false;
        }
      }

      final pauseForMemberLoading =
          VideoTogetherSyncPolicy.shouldPauseForMemberLoading(
            waitForLoadingEnabled: waitForLoading,
            roomWaitsForLoading: room.waitForLoading,
            roomPaused: room.paused,
            localBuffering: playback.isBuffering,
          );
      final shouldPause = room.paused || pauseForMemberLoading;
      final command = _reconciler.reconcile(
        shouldPause: shouldPause,
        isPlaying: playback.isPlaying,
      );
      switch (command) {
        case VideoTogetherPlaybackCommand.none:
          break;
        case VideoTogetherPlaybackCommand.play:
          if (!await applyCommand(playback.play)) return false;
        case VideoTogetherPlaybackCommand.pause:
          if (!await applyCommand(playback.pause)) return false;
      }

      if (!current()) return false;
      final target = shouldPause
          ? room.currentTime
          : room.targetPosition(getServerNow());
      final threshold = VideoTogetherSyncPolicy.correctionThreshold(
        roomPaused: shouldPause,
        playingThreshold: playingThreshold,
      );
      if ((playback.positionSeconds - target).abs() >= threshold) {
        if (!await applyCommand(() => playback.seek(target))) {
          return false;
        }
      }
      return true;
    } catch (_) {
      _reconciler.reset();
      rethrow;
    }
  }

  void reset() => _reconciler.reset();
}

abstract final class VideoTogetherSyncPolicy {
  static const pausedCorrectionThreshold = 0.1;

  static bool canTakeControl({
    required bool hasHeldControl,
    required bool bidirectionalSync,
  }) => bidirectionalSync || hasHeldControl;

  static bool shouldPrioritizeLocalMediaChange({
    required bool pendingMediaChange,
    required bool hasHeldControl,
    required bool bidirectionalSync,
  }) =>
      pendingMediaChange &&
      canTakeControl(
        hasHeldControl: hasHeldControl,
        bidirectionalSync: bidirectionalSync,
      );

  static double correctionThreshold({
    required bool roomPaused,
    required double playingThreshold,
  }) => roomPaused ? pausedCorrectionThreshold : playingThreshold;

  static bool shouldPauseForMemberLoading({
    required bool waitForLoadingEnabled,
    required bool roomWaitsForLoading,
    required bool roomPaused,
    required bool localBuffering,
  }) =>
      waitForLoadingEnabled &&
      roomWaitsForLoading &&
      !roomPaused &&
      !localBuffering;

  static bool advertisedPaused({
    required bool isReady,
    required bool isPlaying,
    required bool isBuffering,
    required bool pausedForMemberLoading,
  }) => !isReady || (!pausedForMemberLoading && (!isPlaying || isBuffering));
}

final class VideoTogetherPlaybackSnapshot {
  const VideoTogetherPlaybackSnapshot({
    required this.capturedAt,
    required this.isReady,
    required this.isPlaying,
    required this.isBuffering,
    required this.positionSeconds,
    required this.durationSeconds,
    required this.playbackRate,
  });

  factory VideoTogetherPlaybackSnapshot.capture(
    VideoTogetherPlayback playback,
    double capturedAt,
  ) => VideoTogetherPlaybackSnapshot(
    capturedAt: capturedAt,
    isReady: playback.isReady,
    isPlaying: playback.isPlaying,
    isBuffering: playback.isBuffering,
    positionSeconds: playback.positionSeconds,
    durationSeconds: playback.durationSeconds,
    playbackRate: playback.playbackRate,
  );

  final double capturedAt;
  final bool isReady;
  final bool isPlaying;
  final bool isBuffering;
  final double positionSeconds;
  final double durationSeconds;
  final double playbackRate;
}

abstract final class VideoTogetherLocalChangeDetector {
  static bool hasUserDrivenChange(
    VideoTogetherPlaybackSnapshot? previous,
    VideoTogetherPlaybackSnapshot current, {
    double seekThreshold = 0.75,
  }) {
    if (previous == null ||
        !previous.isReady ||
        !current.isReady ||
        previous.isBuffering ||
        current.isBuffering) {
      return false;
    }

    if (previous.isPlaying != current.isPlaying) {
      final endedNormally =
          !current.isPlaying &&
          current.durationSeconds > 0 &&
          current.positionSeconds >= current.durationSeconds - 0.5;
      if (!endedNormally) return true;
    }

    if ((previous.playbackRate - current.playbackRate).abs() > 0.01) {
      return true;
    }

    final elapsed = (current.capturedAt - previous.capturedAt).clamp(
      0,
      double.infinity,
    );
    final expectedPosition =
        previous.positionSeconds +
        (previous.isPlaying && !previous.isBuffering
            ? elapsed * previous.playbackRate
            : 0);
    return (current.positionSeconds - expectedPosition).abs() >= seekThreshold;
  }
}
