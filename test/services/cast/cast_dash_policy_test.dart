import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/services/cast/cast_dash_policy.dart';
import 'package:flutter_test/flutter_test.dart';

VideoItem _video({
  required int id,
  required String codecs,
  int bandwidth = 1000000,
  int width = 1920,
  int height = 1080,
  String mimeType = 'video/mp4',
}) {
  return VideoItem(
    id: id,
    baseUrl: 'https://example.com/video/$id.m4s',
    bandWidth: bandwidth,
    mimeType: mimeType,
    codecs: codecs,
    width: width,
    height: height,
    quality: VideoQuality.fromCode(id),
  );
}

AudioItem _audio({
  required int id,
  required String codecs,
  int bandwidth = 128000,
  String mimeType = 'audio/mp4',
}) {
  return AudioItem()
    ..id = id
    ..baseUrl = 'https://example.com/audio/$id.m4s'
    ..bandWidth = bandwidth
    ..mimeType = mimeType
    ..codecs = codecs
    ..quality = AudioQuality.fromCode(id).desc;
}

void main() {
  group('CastDashTrackSelector video selection', () {
    test('prefers avc1 over hevc/hvc1 even when AVC is lower quality', () {
      final videos = [
        _video(id: 116, codecs: 'hev1.1.6.L120.90', bandwidth: 3000000),
        _video(id: 80, codecs: 'avc1.640028', bandwidth: 1500000),
        _video(id: 64, codecs: 'avc1.64001F', bandwidth: 800000),
      ];

      final selected = CastDashTrackSelector.selectVideo(videos, targetQn: 116);

      expect(selected, isNotNull);
      expect(selected!.id, 80);
      expect(selected.codecs, 'avc1.640028');
    });

    test('prefers avc1 over av01 even when AV1 is higher quality', () {
      final videos = [
        _video(id: 125, codecs: 'av01.0.12M.08', bandwidth: 5000000),
        _video(id: 80, codecs: 'avc1.640028', bandwidth: 1500000),
      ];

      final selected = CastDashTrackSelector.selectVideo(videos, targetQn: 125);

      expect(selected, isNotNull);
      expect(selected!.id, 80);
    });

    test('selects exact hevc target when no avc1 track is available', () {
      final videos = [
        _video(id: 120, codecs: 'hev1.1.6.L120.90', bandwidth: 4000000),
        _video(id: 116, codecs: 'hev1.1.6.L90.90', bandwidth: 3000000),
      ];

      final selected = CastDashTrackSelector.selectVideo(videos, targetQn: 120);

      expect(selected, isNotNull);
      expect(selected!.id, 120);
    });

    test('falls back to av01 when neither avc1 nor hevc is available', () {
      final videos = [
        _video(id: 125, codecs: 'av01.0.12M.08', bandwidth: 5000000),
      ];

      final selected = CastDashTrackSelector.selectVideo(videos, targetQn: 125);

      expect(selected, isNotNull);
      expect(selected!.id, 125);
    });

    test('returns null when video list is empty', () {
      final selected = CastDashTrackSelector.selectVideo([], targetQn: 80);

      expect(selected, isNull);
    });
  });

  group('CastDashTrackSelector quality-tier matching', () {
    test('selects exact target quality when available within codec family', () {
      final videos = [
        _video(id: 80, codecs: 'avc1.640028', bandwidth: 1500000),
        _video(id: 64, codecs: 'avc1.64001F', bandwidth: 800000),
      ];

      final selected = CastDashTrackSelector.selectVideo(videos, targetQn: 64);

      expect(selected, isNotNull);
      expect(selected!.id, 64);
    });

    test('selects highest quality below target when exact match is absent', () {
      final videos = [
        _video(id: 64, codecs: 'avc1.64001F', bandwidth: 800000),
        _video(id: 32, codecs: 'avc1.4D401E', bandwidth: 400000),
      ];

      final selected = CastDashTrackSelector.selectVideo(videos, targetQn: 80);

      expect(selected, isNotNull);
      expect(selected!.id, 64);
    });

    test(
      'selects lowest quality above target when no lower quality exists',
      () {
        final videos = [
          _video(id: 116, codecs: 'hev1.1.6.L120.90'),
          _video(id: 80, codecs: 'avc1.640028'),
        ];

        final selected = CastDashTrackSelector.selectVideo(
          videos,
          targetQn: 120,
        );

        expect(selected, isNotNull);
        expect(selected!.id, 80);
      },
    );

    test(
      'selects lower-bandwidth track when two have same quality and codec',
      () {
        final videos = [
          _video(id: 80, codecs: 'avc1.640028', bandwidth: 2000000),
          _video(id: 80, codecs: 'avc1.640028', bandwidth: 1200000),
        ];

        final selected = CastDashTrackSelector.selectVideo(
          videos,
          targetQn: 80,
        );

        expect(selected, isNotNull);
        expect(selected!.bandWidth, 1200000);
      },
    );
  });

  group('CastDashTrackSelector audio selection', () {
    test('selects mp4a AAC audio track', () {
      final audios = [
        _audio(id: 30280, codecs: 'mp4a.40.2'),
        _audio(id: 30232, codecs: 'mp4a.40.2', bandwidth: 66000),
      ];

      final selected = CastDashTrackSelector.selectAacAudio(audios);

      expect(selected, isNotNull);
      expect(selected!.codecs, contains('mp4a'));
    });

    test('ignores Dolby Digital Plus (ec-3) audio tracks', () {
      final audios = [
        _audio(id: 30250, codecs: 'ec-3'),
      ];

      final selected = CastDashTrackSelector.selectAacAudio(audios);

      expect(selected, isNull);
    });

    test('ignores FLAC audio tracks', () {
      final audios = [
        _audio(id: 30251, codecs: 'flac'),
      ];

      final selected = CastDashTrackSelector.selectAacAudio(audios);

      expect(selected, isNull);
    });

    test('selects mp4a AAC from a mixed list ignoring non-AAC tracks', () {
      final audios = [
        _audio(id: 30250, codecs: 'ec-3'),
        _audio(id: 30251, codecs: 'flac'),
        _audio(id: 30280, codecs: 'mp4a.40.2'),
      ];

      final selected = CastDashTrackSelector.selectAacAudio(audios);

      expect(selected, isNotNull);
      expect(selected!.id, 30280);
    });

    test('returns null when audio list is empty', () {
      final selected = CastDashTrackSelector.selectAacAudio([]);

      expect(selected, isNull);
    });

    test('returns null when no AAC track exists in list', () {
      final audios = [
        _audio(id: 30250, codecs: 'ec-3'),
        _audio(id: 30255, codecs: 'ec-3'),
      ];

      final selected = CastDashTrackSelector.selectAacAudio(audios);

      expect(selected, isNull);
    });
  });

  group('CastDashPlan', () {
    test('is available only when both playable video and AAC audio exist', () {
      final dash = Dash(
        video: [
          _video(id: 80, codecs: 'avc1.640028'),
          _video(id: 64, codecs: 'avc1.64001F'),
        ],
        audio: [
          _audio(id: 30280, codecs: 'mp4a.40.2'),
        ],
      );

      final plan = CastDashTrackSelector.plan(dash, targetVideoQn: 80);

      expect(plan.isAvailable, isTrue);
      expect(plan.video, isNotNull);
      expect(plan.audio, isNotNull);
    });

    test('is unavailable when no video track exists', () {
      final dash = Dash(
        video: [],
        audio: [
          _audio(id: 30280, codecs: 'mp4a.40.2'),
        ],
      );

      final plan = CastDashTrackSelector.plan(dash, targetVideoQn: 80);

      expect(plan.isAvailable, isFalse);
    });

    test('is unavailable when no AAC audio track exists', () {
      final dash = Dash(
        video: [
          _video(id: 80, codecs: 'avc1.640028'),
        ],
        audio: [
          _audio(id: 30250, codecs: 'ec-3'),
        ],
      );

      final plan = CastDashTrackSelector.plan(dash, targetVideoQn: 80);

      expect(plan.isAvailable, isFalse);
    });

    test('is unavailable when video list is null', () {
      final dash = Dash(
        audio: [
          _audio(id: 30280, codecs: 'mp4a.40.2'),
        ],
      );

      final plan = CastDashTrackSelector.plan(dash, targetVideoQn: 80);

      expect(plan.isAvailable, isFalse);
    });

    test('is unavailable when audio list is null', () {
      final dash = Dash(
        video: [
          _video(id: 80, codecs: 'avc1.640028'),
        ],
      );

      final plan = CastDashTrackSelector.plan(dash, targetVideoQn: 80);

      expect(plan.isAvailable, isFalse);
    });
  });
}
