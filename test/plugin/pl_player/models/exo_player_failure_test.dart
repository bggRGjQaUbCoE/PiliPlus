import 'package:PiliPlus/plugin/pl_player/models/exo_player_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ExoPlayerPlaybackFailure decoderFailure() => const ExoPlayerPlaybackFailure(
    message: 'Decoder init failed',
    errorCode: 4002,
    errorCodeName: 'ERROR_CODE_DECODER_INIT_FAILED',
    category: ExoPlayerFailureCategory.decoder,
    phase: 'renderer',
    recoverable: false,
    position: Duration.zero,
    playWhenReady: true,
    videoDecoder: 'c2.qti.avc.decoder',
  );

  test('decoder failure triggers one software fallback retry', () {
    expect(
      shouldRetryExoPlaybackFailure(
        decoderFailure(),
        attempt: 0,
        limit: 0,
        localSource: false,
        sessionActive: true,
      ),
      isTrue,
    );
  });

  test('decoder failure does not retry again after fallback', () {
    expect(
      shouldRetryExoPlaybackFailure(
        decoderFailure(),
        attempt: 1,
        limit: 3,
        localSource: false,
        sessionActive: true,
        softwareFallbackAttempted: true,
      ),
      isFalse,
    );
  });

  test('decoder fallback requires an active session', () {
    expect(
      shouldRetryExoPlaybackFailure(
        decoderFailure(),
        attempt: 0,
        limit: 1,
        localSource: false,
        sessionActive: false,
      ),
      isFalse,
    );
  });

  test('local decoder failure still falls back to software', () {
    expect(
      shouldRetryExoPlaybackFailure(
        decoderFailure(),
        attempt: 0,
        limit: 1,
        localSource: true,
        sessionActive: true,
      ),
      isTrue,
    );
  });

  test('network retry is unaffected by the software fallback flag', () {
    const failure = ExoPlayerPlaybackFailure(
      message: 'timeout',
      errorCode: 1002,
      errorCodeName: 'ERROR_CODE_IO_NETWORK_CONNECTION_TIMEOUT',
      category: ExoPlayerFailureCategory.network,
      phase: 'source',
      recoverable: true,
      position: Duration.zero,
      playWhenReady: true,
    );

    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 0,
        limit: 1,
        localSource: false,
        sessionActive: true,
        softwareFallbackAttempted: true,
      ),
      isTrue,
    );
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 1,
        limit: 1,
        localSource: false,
        sessionActive: true,
        softwareFallbackAttempted: true,
      ),
      isFalse,
    );
  });
}
