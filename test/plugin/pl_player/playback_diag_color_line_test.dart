import 'package:PiliPlus/plugin/pl_player/widgets/playback_diag_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit_video/media_kit_video.dart'
    show PlaybackColorValues, PlaybackColorSnapshot;

void main() {
  test('keeps source metadata separate from GPU render target', () {
    final line = formatPlaybackColorLine(
      const PlaybackColorSnapshot(
        source: PlaybackColorValues(
          primaries: 'bt.2020',
          transfer: 'hlg',
          range: 'limited',
          matrix: 'bt.2020-ncl',
        ),
        outputTarget: PlaybackColorValues(
          primaries: 'bt.2020',
          transfer: 'pq',
          range: 'limited',
        ),
      ),
    );

    expect(
      line,
      '片源=bt.2020/hlg/limited 矩阵=bt.2020-ncl '
      '输出目标=bt.2020/pq/limited',
    );
  });

  test('omits missing fields without placeholders', () {
    final line = formatPlaybackColorLine(
      const PlaybackColorSnapshot(
        source: PlaybackColorValues(primaries: 'bt.709', range: 'limited'),
      ),
    );

    expect(line, '片源 色域=bt.709 范围=limited');
    expect(line, isNot(contains('?')));
    expect(line, isNot(contains('不可用')));
  });

  test('labels matrix-only values with their stage', () {
    expect(
      formatPlaybackColorLine(
        const PlaybackColorSnapshot(
          source: PlaybackColorValues(matrix: 'bt.709'),
          outputTarget: PlaybackColorValues(matrix: 'rgb'),
        ),
      ),
      '片源矩阵=bt.709 输出目标矩阵=rgb',
    );
  });

  test('direct decode does not present a guessed display color', () {
    expect(
      formatPlaybackColorLine(
        const PlaybackColorSnapshot(
          source: PlaybackColorValues(primaries: 'bt.2020'),
          outputTarget: PlaybackColorValues(transfer: 'pq'),
          decoderPassthrough: true,
        ),
      ),
      '片源 色域=bt.2020 输出=解码直通',
    );
  });

  test('returns no line when no color field is known', () {
    expect(
      formatPlaybackColorLine(const PlaybackColorSnapshot()),
      isNull,
    );
  });
}
