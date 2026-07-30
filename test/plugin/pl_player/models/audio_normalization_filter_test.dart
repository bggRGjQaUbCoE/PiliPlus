import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/plugin/pl_player/models/audio_normalization_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const disabled = '0';

  test('disabled normalization resolves to null', () {
    expect(
      resolveAudioNormalizationFilter(
        config: disabled,
        fallbackConfig: disabled,
      ),
      isNull,
    );
  });

  test('loudnorm uses server measurements when available', () {
    final filter = resolveAudioNormalizationFilter(
      config: '2',
      fallbackConfig: disabled,
      volume: Volume(
        measuredI: -20,
        measuredLra: 8,
        measuredTp: -3,
        measuredThreshold: -30,
        targetOffset: -0.1,
        targetI: -16,
        targetTp: -1.5,
      ),
    );

    expect(filter, contains('I=-16'));
    expect(filter, contains('TP=-3'));
    expect(filter, contains('offset=-0.1'));
    expect(filter, contains('linear=true'));
    expect(filter, contains('measured_I=-20'));
  });

  test('loudnorm is replaced by fallback when measurements are absent', () {
    expect(
      resolveAudioNormalizationFilter(
        config: '2',
        fallbackConfig: '1',
      ),
      'dynaudnorm=g=5:f=250:r=0.9:p=0.5',
    );
  });

  test('custom non-loudnorm filter is preserved', () {
    const custom = 'dynaudnorm=g=3:f=400:r=0.8:p=0.6';
    expect(
      resolveAudioNormalizationFilter(
        config: custom,
        fallbackConfig: disabled,
      ),
      custom,
    );
  });

  test(
    'ExoPlayer configuration derives gain and peak from measured loudnorm',
    () {
      final resolution =
          resolveExoAudioNormalization(
                config: '2',
                fallbackConfig: disabled,
                volume: Volume(
                  measuredI: -20,
                  measuredLra: 8,
                  measuredTp: -1,
                  measuredThreshold: -30,
                  targetOffset: 0,
                  targetI: -16,
                  targetTp: -1.5,
                ),
              )
              as ExoAudioNormalizationConfiguration;

      expect(resolution.gain, closeTo(1.5848932, 0.000001));
      expect(resolution.peak, closeTo(0.8413951, 0.000001));
    },
  );

  test('ExoPlayer keeps dynamic and custom filters as explicit gaps', () {
    expect(
      resolveExoAudioNormalization(config: '1', fallbackConfig: disabled),
      isA<UnsupportedExoAudioNormalization>(),
    );
    expect(
      resolveExoAudioNormalization(
        config: 'volume=0.8',
        fallbackConfig: disabled,
      ),
      isA<UnsupportedExoAudioNormalization>(),
    );
  });
}
