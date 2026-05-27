import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/services/cast/cast_dash_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

VideoItem _videoSegment() {
  return VideoItem(
    id: 80,
    baseUrl: 'https://example.com/video/80.m4s',
    bandWidth: 1500000,
    mimeType: 'video/mp4',
    codecs: 'avc1.640028',
    width: 1920,
    height: 1080,
    frameRate: '30',
    segmentBase: {
      'Initialization': '0-999',
      'indexRange': '1000-4999',
    },
    quality: VideoQuality.fromCode(80),
  );
}

AudioItem _audioSegment() {
  return AudioItem()
    ..id = 30280
    ..baseUrl = 'https://example.com/audio/30280.m4s'
    ..bandWidth = 128000
    ..mimeType = 'audio/mp4'
    ..codecs = 'mp4a.40.2'
    ..segmentBase = {
      'Initialization': '0-499',
      'indexRange': '500-1999',
    }
    ..quality = AudioQuality.fromCode(30280).desc;
}

void main() {
  group('castDashContentType', () {
    test('exposes application/dash+xml as the DASH content type constant', () {
      expect(castDashContentType, 'application/dash+xml');
    });
  });

  group('CastDashManifest XML structure', () {
    test('produces root MPD element with DASH namespace', () {
      final xml = CastDashManifest.build(
        video: _videoSegment(),
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, contains('<MPD'));
      expect(xml, contains('xmlns="urn:mpeg:dash:schema:mpd:2011"'));
      expect(xml, contains('</MPD>'));
    });

    test('includes video AdaptationSet with mimeType and codecs', () {
      final xml = CastDashManifest.build(
        video: _videoSegment(),
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, contains('mimeType="video/mp4"'));
      expect(xml, contains('codecs="avc1.640028"'));
      expect(xml, contains('width="1920"'));
      expect(xml, contains('height="1080"'));
    });

    test('includes frameRate in video Representation when present', () {
      final video = _videoSegment();
      final xml = CastDashManifest.build(
        video: video,
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, contains('frameRate="30"'));
    });

    test('omits frameRate attribute when video has no frame rate', () {
      final video = VideoItem(
        id: 80,
        baseUrl: 'https://example.com/video/80.m4s',
        bandWidth: 1500000,
        mimeType: 'video/mp4',
        codecs: 'avc1.640028',
        width: 1920,
        height: 1080,
        segmentBase: {
          'Initialization': '0-999',
          'indexRange': '1000-4999',
        },
        quality: VideoQuality.fromCode(80),
      );

      final xml = CastDashManifest.build(
        video: video,
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, isNot(contains('frameRate')));
    });

    test('includes audio AdaptationSet with mimeType and codecs', () {
      final xml = CastDashManifest.build(
        video: _videoSegment(),
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, contains('mimeType="audio/mp4"'));
      expect(xml, contains('codecs="mp4a.40.2"'));
    });

    test('wraps AdaptationSets in a Period element', () {
      final xml = CastDashManifest.build(
        video: _videoSegment(),
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, contains('<Period'));
      expect(xml, contains('</Period>'));
    });
  });

  group('CastDashManifest SegmentBase and Initialization', () {
    test('emits SegmentBase indexRange from video segmentBase map', () {
      final xml = CastDashManifest.build(
        video: _videoSegment(),
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, contains('indexRange="1000-4999"'));
    });

    test('emits Initialization range inside SegmentBase', () {
      final xml = CastDashManifest.build(
        video: _videoSegment(),
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, contains('range="0-999"'));
    });

    test('omits SegmentBase when segmentBase map is null', () {
      final video = VideoItem(
        id: 64,
        baseUrl: 'https://example.com/video/64.m4s',
        bandWidth: 800000,
        mimeType: 'video/mp4',
        codecs: 'avc1.64001F',
        quality: VideoQuality.fromCode(64),
      );
      final audio = AudioItem()
        ..id = 30280
        ..baseUrl = 'https://example.com/audio/30280.m4s'
        ..bandWidth = 128000
        ..mimeType = 'audio/mp4'
        ..codecs = 'mp4a.40.2'
        ..quality = AudioQuality.fromCode(30280).desc;

      final xml = CastDashManifest.build(
        video: video,
        audio: audio,
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, isNot(contains('SegmentBase')));
    });
  });

  group('CastDashManifest BaseURL', () {
    test('prepends baseUrl to video segment path in BaseURL element', () {
      final xml = CastDashManifest.build(
        video: _videoSegment(),
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(
        xml,
        contains('<BaseURL>https://proxy.local/video/80.m4s</BaseURL>'),
      );
    });

    test('prepends baseUrl to audio segment path in BaseURL element', () {
      final xml = CastDashManifest.build(
        video: _videoSegment(),
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(
        xml,
        contains('<BaseURL>https://proxy.local/audio/30280.m4s</BaseURL>'),
      );
    });

    test(
      'joins baseUrl with trailing slash and path without leading slash',
      () {
        final xml = CastDashManifest.build(
          video: _videoSegment(),
          audio: _audioSegment(),
          baseUrl: 'https://proxy.local/dash/',
        );

        expect(
          xml,
          contains('<BaseURL>https://proxy.local/dash/video/80.m4s</BaseURL>'),
        );
      },
    );
  });

  group('CastDashManifest XML escaping', () {
    test('escapes ampersand in segment URLs', () {
      final video = VideoItem(
        id: 80,
        baseUrl: 'https://example.com/video/80.m4s?token=a&b=c',
        bandWidth: 1500000,
        mimeType: 'video/mp4',
        codecs: 'avc1.640028',
        width: 1920,
        height: 1080,
        segmentBase: {
          'Initialization': '0-999',
          'indexRange': '1000-4999',
        },
        quality: VideoQuality.fromCode(80),
      );

      final xml = CastDashManifest.build(
        video: video,
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, contains('token=a&amp;b=c'));
      expect(xml, isNot(contains('token=a&b=c')));
    });
  });

  group('CastDashManifest bandwidth', () {
    test('sets bandwidth attribute on each Representation', () {
      final xml = CastDashManifest.build(
        video: _videoSegment(),
        audio: _audioSegment(),
        baseUrl: 'https://proxy.local/',
      );

      expect(xml, contains('bandwidth="1500000"'));
      expect(xml, contains('bandwidth="128000"'));
    });
  });
}
