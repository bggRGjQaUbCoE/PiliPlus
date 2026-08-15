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

  test('ExoPlayer maps the dynaudnorm preset to dynamic normalization', () {
    final resolution =
        resolveExoAudioNormalization(
              config: '1',
              fallbackConfig: disabled,
            )
            as ExoAudioDynamicNormalizationConfiguration;

    expect(resolution.targetRmsDb, -16);
    expect(resolution.peak, 1);
    expect(resolution.maxGain, 5);
    expect(resolution.frameMs, 250);
    expect(resolution.smoothing, 0.9);
    expect(resolution.toMap()['dynamic'], isTrue);
  });

  test(
    'ExoPlayer maps one-pass loudnorm without measurements to dynamic normalization',
    () {
      final resolution =
          resolveExoAudioNormalization(
                config: '2',
                fallbackConfig: '2',
              )
              as ExoAudioDynamicNormalizationConfiguration;

      expect(resolution.targetRmsDb, -16);
      expect(resolution.peak, closeTo(0.8413951, 0.000001));
      expect(resolution.maxGain, 10);
      expect(resolution.frameMs, 3000);
      expect(resolution.smoothing, 0.35);
    },
  );

  test('ExoPlayer supports a volume-only chain', () {
    final resolution =
        resolveExoAudioNormalization(
              config: 'volume=0.8',
              fallbackConfig: disabled,
            )
            as ExoAudioNormalizationConfiguration;

    expect(resolution.gain, closeTo(0.8, 0.000001));
    expect(resolution.peak, 1);
  });

  test('ExoPlayer maps a highpass stage with frequency', () {
    final resolution =
        resolveExoAudioNormalization(
              config: 'highpass=f=120,volume=0.8',
              fallbackConfig: disabled,
            )
            as ExoAudioNormalizationConfiguration;

    expect(resolution.highpassHz, 120);
    expect(resolution.gain, closeTo(0.8, 0.000001));
  });

  test('ExoPlayer maps a lowpass stage with frequency', () {
    final resolution =
        resolveExoAudioNormalization(
              config: 'lowpass=f=1200,volume=0.8',
              fallbackConfig: disabled,
            )
            as ExoAudioNormalizationConfiguration;

    expect(resolution.lowpassHz, 1200);
    expect(resolution.gain, closeTo(0.8, 0.000001));
  });

  test('ExoPlayer maps a peaking equalizer stage', () {
    final resolution =
        resolveExoAudioNormalization(
              config: 'equalizer=f=1000:t=q:w=1.2:g=4,volume=0.8',
              fallbackConfig: disabled,
            )
            as ExoAudioNormalizationConfiguration;

    expect(resolution.equalizerFrequencyHz, 1000);
    expect(resolution.equalizerGainDb, 4);
    expect(resolution.equalizerQ, 1.2);
    expect(resolution.equalizerBands, hasLength(1));
    expect(resolution.equalizerBands.single.type, 'q');
    expect(resolution.gain, closeTo(0.8, 0.000001));
  });

  test('ExoPlayer maps shelf stages', () {
    for (final type in ['highshelf', 'lowshelf']) {
      final resolution =
          resolveExoAudioNormalization(
                config: '$type=f=1000:w=1:g=4',
                fallbackConfig: disabled,
              )
              as ExoAudioNormalizationConfiguration;

      expect(resolution.equalizerBands.single.type, type);
      expect(
        (resolution.toMap()['equalizerBands'] as List<Object?>).single,
        containsPair('type', type),
      );
    }
  });

  test('ExoPlayer maps multiple peaking equalizer stages in chain order', () {
    final resolution =
        resolveExoAudioNormalization(
              config:
                  'equalizer=f=1000:t=q:w=1.2:g=4,equalizer=f=2000:t=q:w=0.7:g=-3',
              fallbackConfig: disabled,
            )
            as ExoAudioNormalizationConfiguration;

    expect(resolution.equalizerBands, hasLength(2));
    expect(resolution.equalizerBands.first.frequencyHz, 1000);
    expect(resolution.equalizerBands.last.gainDb, -3);
    expect(
      (resolution.toMap()['equalizerBands'] as List<Object?>).length,
      2,
    );
  });

  test('ExoPlayer rejects malformed or repeated highpass stages', () {
    expect(
      resolveExoAudioNormalization(
        config: 'highpass=f=abc',
        fallbackConfig: disabled,
      ),
      isA<UnsupportedExoAudioNormalization>(),
    );
    expect(
      resolveExoAudioNormalization(
        config: 'highpass=f=100,highpass=f=200',
        fallbackConfig: disabled,
      ),
      isA<UnsupportedExoAudioNormalization>(),
    );
  });

  test('ExoPlayer rejects malformed or repeated lowpass stages', () {
    expect(
      resolveExoAudioNormalization(
        config: 'lowpass=f=abc',
        fallbackConfig: disabled,
      ),
      isA<UnsupportedExoAudioNormalization>(),
    );
    expect(
      resolveExoAudioNormalization(
        config: 'lowpass=f=100,lowpass=f=200',
        fallbackConfig: disabled,
      ),
      isA<UnsupportedExoAudioNormalization>(),
    );
  });

  test('ExoPlayer rejects malformed or unsupported equalizers', () {
    for (final config in [
      'equalizer=f=abc:t=q:w=1:g=2',
      'equalizer=f=1000:t=h:w=1:g=2',
      'equalizer=f=1000:t=x:w=1:g=2',
    ]) {
      expect(
        resolveExoAudioNormalization(config: config, fallbackConfig: disabled),
        isA<UnsupportedExoAudioNormalization>(),
      );
    }
  });

  test('ExoPlayer parses decibel volume stages', () {
    final resolution =
        resolveExoAudioNormalization(
              config: 'volume=-3dB',
              fallbackConfig: disabled,
            )
            as ExoAudioNormalizationConfiguration;

    expect(resolution.gain, closeTo(0.7079458, 0.000001));
  });

  test('ExoPlayer folds volume into the dynaudnorm target', () {
    final resolution =
        resolveExoAudioNormalization(
              config: 'dynaudnorm=g=5:f=250:r=0.9:p=0.5,volume=0.5',
              fallbackConfig: disabled,
            )
            as ExoAudioDynamicNormalizationConfiguration;

    expect(resolution.targetRmsDb, closeTo(-22.0205999, 0.000001));
    expect(resolution.maxGain, 5);
    expect(resolution.frameMs, 250);
  });

  test('ExoPlayer folds volume into one-pass loudnorm', () {
    final resolution =
        resolveExoAudioNormalization(
              config: 'loudnorm=I=-16:LRA=11:TP=-1.5,volume=0.8',
              fallbackConfig: '2',
            )
            as ExoAudioDynamicNormalizationConfiguration;

    expect(resolution.targetRmsDb, closeTo(-17.9382003, 0.000001));
    expect(resolution.peak, closeTo(0.8413951, 0.000001));
  });

  test('ExoPlayer folds volume into measured loudnorm gain', () {
    final resolution =
        resolveExoAudioNormalization(
              config: 'loudnorm=I=-16:LRA=11:TP=-1.5,volume=0.8',
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

    expect(resolution.gain, closeTo(1.2679146, 0.000001));
    expect(resolution.peak, closeTo(0.8413951, 0.000001));
  });

  test('ExoPlayer reports the exact unsupported chain stage', () {
    final resolution =
        resolveExoAudioNormalization(
              config: 'volume=0.8,compressor=threshold=0.5:ratio=2',
              fallbackConfig: disabled,
            )
            as UnsupportedExoAudioNormalization;

    expect(resolution.unsupportedStage, 'compressor=threshold=0.5:ratio=2');
  });

  test('ExoPlayer rejects chains with multiple loudness stages', () {
    final resolution =
        resolveExoAudioNormalization(
              config: 'loudnorm=I=-16,dynaudnorm=g=5',
              fallbackConfig: '2',
            )
            as UnsupportedExoAudioNormalization;

    expect(resolution.unsupportedStage, 'dynaudnorm=g=5');
  });

  test('ExoPlayer rejects malformed volume stages', () {
    expect(
      resolveExoAudioNormalization(
        config: 'volume=abc',
        fallbackConfig: disabled,
      ),
      isA<UnsupportedExoAudioNormalization>(),
    );
  });
}
