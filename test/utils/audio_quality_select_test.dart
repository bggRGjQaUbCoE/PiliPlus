import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:flutter_test/flutter_test.dart';

PlayUrlModel _playUrl(List<int> audioIds) => PlayUrlModel.fromJson({
  'dash': {
    'duration': 0,
    'audio': [
      for (final id in audioIds) {'id': id},
    ],
  },
});

void main() {
  group('AudioQuality.selectAvailableCode', () {
    test(
      'prefers the highest available quality not above the requested one',
      () {
        expect(
          AudioQuality.selectAvailableCode([
            AudioQuality.hiRes.code,
            AudioQuality.k192.code,
            AudioQuality.k64.code,
          ], AudioQuality.hiRes.code),
          AudioQuality.hiRes.code,
        );
        // Dolby is preferred over 192K when Hi-Res is unavailable.
        expect(
          AudioQuality.selectAvailableCode([
            AudioQuality.dolby_30250.code,
            AudioQuality.k192.code,
          ], AudioQuality.hiRes.code),
          AudioQuality.dolby_30250.code,
        );
        // 132K requested: 64K is the closest quality not above it.
        expect(
          AudioQuality.selectAvailableCode([
            AudioQuality.k64.code,
            AudioQuality.k192.code,
          ], AudioQuality.k132.code),
          AudioQuality.k64.code,
        );
      },
    );

    test('falls back to the lowest available quality when all are higher', () {
      expect(
        AudioQuality.selectAvailableCode([
          AudioQuality.hiRes.code,
          AudioQuality.k192.code,
        ], AudioQuality.k64.code),
        AudioQuality.k192.code,
      );
    });

    test(
      'returns null for an empty list and does not throw on unknown ids',
      () {
        expect(AudioQuality.selectAvailableCode(const [], 30251), isNull);
        expect(
          AudioQuality.selectAvailableCode([99999], AudioQuality.hiRes.code),
          99999,
        );
        expect(
          AudioQuality.selectAvailableCode([
            AudioQuality.k192.code,
          ], 99999),
          AudioQuality.k192.code,
        );
      },
    );
  });

  group('PlayUrlModel.findAvailableAudioQuality', () {
    test('keeps Hi-Res audio when it is available', () {
      final playUrl = _playUrl([
        AudioQuality.hiRes.code,
        AudioQuality.k192.code,
        AudioQuality.k132.code,
        AudioQuality.k64.code,
      ]);
      expect(
        playUrl.findAvailableAudioQuality(AudioQuality.hiRes.code),
        AudioQuality.hiRes.code,
      );
    });

    test('does not downgrade to 192K when Dolby audio is available', () {
      final playUrl = _playUrl([
        AudioQuality.dolby_30250.code,
        AudioQuality.k192.code,
      ]);
      expect(
        playUrl.findAvailableAudioQuality(AudioQuality.hiRes.code),
        AudioQuality.dolby_30250.code,
      );
    });

    test('does not upgrade to a quality above the configured one', () {
      final playUrl = _playUrl([AudioQuality.k192.code, AudioQuality.k64.code]);
      expect(
        playUrl.findAvailableAudioQuality(AudioQuality.k132.code),
        AudioQuality.k64.code,
      );
    });

    test('returns null when dash audio is missing', () {
      expect(
        PlayUrlModel.fromJson({}).findAvailableAudioQuality(30251),
        isNull,
      );
      expect(
        PlayUrlModel.fromJson({
          'dash': {'duration': 0},
        }).findAvailableAudioQuality(30251),
        isNull,
      );
    });
  });
}
