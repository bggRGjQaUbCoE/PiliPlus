import 'dart:convert';
import 'dart:io';

/// Fixed labels keep signed media URLs, local proxy tokens, and account data
/// out of timing diagnostics. The trace is compiled out unless explicitly
/// enabled with --dart-define=CDN_STARTUP_TRACE=true.
enum CdnStartupStage {
  urlRequestStart,
  mainUrlReady,
  qualitySupplementReady,
  sourceSelected,
  sourceDeferred,
  urlFailed,
  playerSourceQueued,
  playerSourceStart,
  playerCreated,
  playerReused,
  proxyStarted,
  proxyRegistered,
  proxyBypassed,
  openStart,
  openReturned,
  playRequested,
  sourceError,
  firstFrameUnavailable,
  firstAudioUnavailable,
  proxyRequest,
  originQueueEnter,
  originSlotGranted,
  candidateReady,
  originHeaders,
  originFirstByte,
  identityValidated,
  firstRangeValidated,
  proxyFirstFlush,
  fallback,
  cancelled,
}

enum CdnStartupTrack { unknown, video, audio }

final class CdnStartupTrace {
  CdnStartupTrace._(this.id, this.parallelEnabled) {
    _clock.start();
  }

  static const enabled = bool.fromEnvironment('CDN_STARTUP_TRACE');
  static int _nextId = 0;

  /// Returns null without allocating a Stopwatch in normal builds.
  static CdnStartupTrace? begin({required bool parallelEnabled}) =>
      enabled ? CdnStartupTrace._(++_nextId, parallelEnabled) : null;

  final int id;
  final bool parallelEnabled;
  final Stopwatch _clock = Stopwatch();

  /// Only enum values and elapsed time leave this method. No request data may
  /// be added to the diagnostic output.
  void mark(
    CdnStartupStage stage, {
    CdnStartupTrack track = CdnStartupTrack.unknown,
    int? requestId,
  }) {
    stdout.writeln(
      jsonEncode({
        'cdn_startup_schema': 1,
        'session': id,
        'parallel': parallelEnabled,
        'elapsed_us': _clock.elapsedMicroseconds,
        'stage': stage.name,
        'track': track.name,
        'request': ?requestId,
      }),
    );
  }
}
