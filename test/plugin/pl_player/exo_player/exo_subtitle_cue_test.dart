import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_subtitle_cue.dart';
import 'package:PiliPlus/plugin/pl_player/models/exo_player_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses structured Media3 cue data from the event channel', () {
    final event = ExoPlayerEvent.fromMap({
      'subtitle': 'Hello',
      'ready': true,
      'volume': .75,
      'videoDecoder': 'c2.qti.avc.decoder',
      'tracks': [
        {
          'type': 'audio',
          'id': 'audio-aac',
          'groupIndex': 1,
          'trackIndex': 0,
          'selected': true,
          'supported': true,
          'codec': 'mp4a.40.2',
          'channelCount': 2,
          'sampleRate': 48000,
        },
      ],
      'subtitleCues': [
        {
          'text': 'Hello',
          'textAlignment': 'center',
          'line': .8,
          'lineType': 0,
          'lineAnchor': 2,
          'position': .25,
          'positionAnchor': 1,
          'size': .5,
          'windowColor': 0x80000000,
          'shearDegrees': 12,
          'zIndex': 3,
          'segments': [
            {
              'text': 'Hel',
              'bold': true,
              'foregroundColor': 0xFFFF0000,
            },
            {
              'text': 'lo',
              'italic': true,
              'underline': true,
              'relativeSize': 1.5,
            },
          ],
        },
      ],
    });

    expect(event.subtitleCues, hasLength(1));
    expect(event.tracks.single.id, 'audio-aac');
    expect(event.volume, .75);
    expect(event.videoDecoder, 'c2.qti.avc.decoder');
    expect(event.ready, isTrue);
    final cue = event.subtitleCues.single;
    expect(cue.text, 'Hello');
    expect(cue.textAlignment, ExoSubtitleAlignment.center);
    expect(cue.line, .8);
    expect(cue.position, .25);
    expect(cue.size, .5);
    expect(cue.windowColor, 0x80000000);
    expect(cue.shearDegrees, 12);
    expect(cue.zIndex, 3);
    expect(cue.segments, hasLength(2));
    expect(cue.segments.first.bold, isTrue);
    expect(cue.segments.last.italic, isTrue);
  });

  test('parses structured playback diagnostics', () {
    final event = ExoPlayerEvent.fromMap({
      'type': 'error',
      'error': {
        'message': 'Unable to connect',
        'errorCode': 2001,
        'errorCodeName': 'ERROR_CODE_IO_NETWORK_CONNECTION_FAILED',
        'category': 'network',
        'phase': 'source',
        'recoverable': true,
        'positionMs': 12345,
        'playWhenReady': true,
        'httpStatus': 503,
        'uri': 'https://example.com/video.m4s',
        'mediaDescription': 'video: https://example.com/video.m4s',
        'videoDecoder': 'c2.qti.avc.decoder',
        'causeChain': [
          'PlaybackException: Source error',
          'HttpDataSourceException: Unable to connect',
        ],
      },
    });

    final failure = event.failure!;
    expect(failure.category, ExoPlayerFailureCategory.network);
    expect(failure.recoverable, isTrue);
    expect(failure.httpStatus, 503);
    expect(failure.position, const Duration(milliseconds: 12345));
    expect(failure.playWhenReady, isTrue);
    expect(failure.videoDecoder, 'c2.qti.avc.decoder');
    expect(
      failure.diagnostics(retryAttempt: 2, retryLimit: 3),
      contains('retry: 2/3'),
    );
    expect(failure.diagnosticStackTrace.toString(), contains('Caused by'));
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 1,
        limit: 2,
        localSource: false,
        sessionActive: true,
      ),
      isTrue,
    );
    expect(
      exoPlaybackRetryDelay(baseDelayMs: 500, attempt: 2),
      const Duration(seconds: 1),
    );
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 2,
        limit: 2,
        localSource: false,
        sessionActive: true,
      ),
      isFalse,
    );
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 0,
        limit: 2,
        localSource: true,
        sessionActive: true,
      ),
      isFalse,
    );
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 0,
        limit: 2,
        localSource: false,
        sessionActive: false,
      ),
      isFalse,
    );
    expect(
      exoPlaybackRetryDelay(baseDelayMs: 500, attempt: 3),
      const Duration(milliseconds: 1500),
    );
  });

  test('does not retry permanent playback failures', () {
    final failure = ExoPlayerPlaybackFailure.fromMap({
      'message': 'Not found',
      'errorCode': 2004,
      'errorCodeName': 'ERROR_CODE_IO_BAD_HTTP_STATUS',
      'category': 'source',
      'phase': 'source',
      'recoverable': false,
      'positionMs': 0,
      'playWhenReady': true,
      'httpStatus': 404,
    });

    expect(failure.userMessage, contains('HTTP 404'));
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 0,
        limit: 2,
        localSource: false,
        sessionActive: true,
      ),
      isFalse,
    );
  });

  test('applies span styling without discarding the shared base style', () {
    const base = TextStyle(fontSize: 20, color: Colors.white);
    const segment = ExoSubtitleSegment(
      text: 'styled',
      bold: true,
      italic: true,
      underline: true,
      foregroundColor: 0xFF00FF00,
      relativeSize: 1.25,
    );

    final style = segment.applyTo(base);

    expect(style.fontSize, 25);
    expect(style.fontWeight, FontWeight.bold);
    expect(style.fontStyle, FontStyle.italic);
    expect(style.color, const Color(0xFF00FF00));
    expect(style.decoration, TextDecoration.underline);
  });
}
