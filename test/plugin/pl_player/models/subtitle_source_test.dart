import 'package:PiliPlus/plugin/pl_player/models/subtitle_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerSubtitleFormat', () {
    test('maps supported file extensions case-insensitively', () {
      expect(
        PlayerSubtitleFormat.fromFileName('caption.VTT'),
        PlayerSubtitleFormat.webVtt,
      );
      expect(
        PlayerSubtitleFormat.fromFileName('caption.srt?download=1'),
        PlayerSubtitleFormat.subRip,
      );
      expect(
        PlayerSubtitleFormat.fromFileName('caption.ASS#track'),
        PlayerSubtitleFormat.subStationAlpha,
      );
      expect(
        PlayerSubtitleFormat.fromFileName('caption.ssa'),
        PlayerSubtitleFormat.subStationAlpha,
      );
      expect(PlayerSubtitleFormat.fromFileName('caption.json'), isNull);
    });

    test('uses Media3-compatible MIME types', () {
      expect(PlayerSubtitleFormat.webVtt.mimeType, 'text/vtt');
      expect(PlayerSubtitleFormat.subRip.mimeType, 'application/x-subrip');
      expect(PlayerSubtitleFormat.subStationAlpha.mimeType, 'text/x-ssa');
    });
  });
}
