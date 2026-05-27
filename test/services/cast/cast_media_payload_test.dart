import 'package:PiliPlus/services/cast/cast_media_payload.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CastMediaPayload', () {
    test('uses the media URL as content id and infers HLS content type', () {
      final payload = CastMediaPayload(
        url: Uri.parse('https://example.com/video/master.m3u8?token=abc'),
        title: 'Episode 1',
        cover: Uri.parse('https://example.com/cover.jpg'),
        position: const Duration(seconds: 42),
        duration: const Duration(minutes: 24),
        qualityCode: 80,
      );

      expect(
        payload.contentId,
        'https://example.com/video/master.m3u8?token=abc',
      );
      expect(payload.contentType, 'application/x-mpegURL');
      expect(payload.customData, containsPair('qualityCode', 80));
      expect(payload.customData, containsPair('title', 'Episode 1'));
    });

    test('infers common video content types from URL paths', () {
      expect(
        CastMediaPayload(
          url: Uri.parse('https://example.com/video.mp4'),
          title: 'MP4',
        ).contentType,
        'video/mp4',
      );
      expect(
        CastMediaPayload(
          url: Uri.parse('https://example.com/video.webm'),
          title: 'WebM',
        ).contentType,
        'video/webm',
      );
      expect(
        CastMediaPayload(
          url: Uri.parse('https://example.com/video.flv'),
          title: 'FLV',
        ).contentType,
        'video/x-flv',
      );
    });

    test('infers application/dash+xml for .mpd DASH manifest URLs', () {
      expect(
        CastMediaPayload(
          url: Uri.parse('https://example.com/dash/manifest.mpd'),
          title: 'DASH',
        ).contentType,
        'application/dash+xml',
      );
      expect(
        CastMediaPayload(
          url: Uri.parse('https://proxy.local/stream.mpd?sid=1'),
          title: 'Proxied DASH',
        ).contentType,
        'application/dash+xml',
      );
    });

    test('accepts explicit contentType and uses it instead of inference', () {
      final payload = CastMediaPayload(
        url: Uri.parse('https://example.com/video.mp4'),
        title: 'Explicit DASH',
        contentType: 'application/dash+xml',
      );

      expect(payload.contentType, 'application/dash+xml');
    });

    test('explicit contentType survives copyWith unchanged', () {
      final payload = CastMediaPayload(
        url: Uri.parse('https://example.com/stream.mpd'),
        title: 'DASH',
        contentType: 'application/dash+xml',
        qualityCode: 80,
      );

      final reloaded = payload.copyWith(
        url: Uri.parse('https://example.com/stream-1080.mpd'),
        qualityCode: 112,
      );

      expect(reloaded.contentType, 'application/dash+xml');
      expect(reloaded.qualityCode, 112);
      expect(reloaded.contentId, 'https://example.com/stream-1080.mpd');
    });

    test(
      'copyWith overrides explicit contentType when a new value is given',
      () {
        final payload = CastMediaPayload(
          url: Uri.parse('https://example.com/video.mp4'),
          title: 'Video',
          contentType: 'video/mp4',
        );

        final switched = payload.copyWith(contentType: 'application/dash+xml');

        expect(switched.contentType, 'application/dash+xml');
      },
    );

    test('copyWith falls back to inference when contentType is cleared', () {
      final payload = CastMediaPayload(
        url: Uri.parse('https://example.com/video.mp4'),
        title: 'Video',
        contentType: 'application/dash+xml',
      );

      final cleared = payload.copyWith(clearContentType: true);

      expect(cleared.contentType, 'video/mp4');
    });

    test(
      'clearContentType on a payload without explicit contentType is a no-op',
      () {
        final payload = CastMediaPayload(
          url: Uri.parse('https://example.com/video.mp4'),
          title: 'Video',
        );

        final result = payload.copyWith(clearContentType: true);

        expect(result.contentType, 'video/mp4');
      },
    );

    test('keeps playback position when replacing URL for quality reload', () {
      final current = CastMediaPayload(
        url: Uri.parse('https://example.com/video-720.mp4'),
        title: 'Episode 1',
        cover: Uri.parse('https://example.com/cover.jpg'),
        position: const Duration(minutes: 3, seconds: 15),
        duration: const Duration(minutes: 24),
        qualityCode: 64,
      );

      final reloaded = current.copyWith(
        url: Uri.parse('https://example.com/video-1080.mp4'),
        qualityCode: 80,
      );

      expect(reloaded.position, const Duration(minutes: 3, seconds: 15));
      expect(reloaded.title, 'Episode 1');
      expect(reloaded.cover, Uri.parse('https://example.com/cover.jpg'));
      expect(reloaded.duration, const Duration(minutes: 24));
      expect(reloaded.qualityCode, 80);
      expect(reloaded.contentId, 'https://example.com/video-1080.mp4');
    });

    test('can clear nullable metadata when media metadata changes', () {
      final current = CastMediaPayload(
        url: Uri.parse('https://example.com/video.mp4'),
        title: 'Episode 1',
        cover: Uri.parse('https://example.com/cover.jpg'),
        duration: const Duration(minutes: 24),
        qualityCode: 80,
      );

      final cleared = current.copyWith(
        clearCover: true,
        clearDuration: true,
        clearQualityCode: true,
      );

      expect(cleared.cover, isNull);
      expect(cleared.duration, isNull);
      expect(cleared.qualityCode, isNull);
      expect(cleared.customData, isNot(contains('qualityCode')));
    });
  });
}
