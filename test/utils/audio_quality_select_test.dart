import 'package:PiliPlus/models/common/video/base_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/video_utils.dart';
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
  group('PlayUrlModel.findAvailableAudioQuality', () {
    test('keeps Hi-Res audio when it is available', () {
      final playUrl = _playUrl([
        AudioQuality.hiRes.code,
        AudioQuality.k192.code,
        AudioQuality.k132.code,
        AudioQuality.k64.code,
      ]);
      expect(
        VideoUtils.findTargetAudio(
          playUrl.dash!.audio!,
          AudioQuality.hiRes.code,
        ).id,
        AudioQuality.hiRes.code,
      );
    });

    test('does not downgrade to 192K when Dolby audio is available', () {
      final playUrl = _playUrl([
        AudioQuality.dolby_30250.code,
        AudioQuality.k192.code,
      ]);
      expect(
        VideoUtils.findTargetAudio(
          playUrl.dash!.audio!,
          AudioQuality.hiRes.code,
        ).id,
        AudioQuality.dolby_30250.code,
      );
    });

    test('does not upgrade to a quality above the configured one', () {
      final playUrl = _playUrl([
        AudioQuality.k192.code,
        AudioQuality.k64.code,
      ]);
      expect(
        VideoUtils.findTargetAudio(
          playUrl.dash!.audio!,
          AudioQuality.k132.code,
        ).id,
        AudioQuality.k64.code,
      );
    });

    test('does not upgrade to a quality above the configured one', () {
      final playUrl = _playUrl([
        AudioQuality.k192.code,
        AudioQuality.k132.code,
      ]);
      expect(
        VideoUtils.findTargetAudio(
          playUrl.dash!.audio!,
          AudioQuality.k64.code,
        ).id,
        AudioQuality.k132.code,
      );
    });
  });
}
