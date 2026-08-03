import 'dart:math' show pow;

import 'package:PiliPlus/models/common/audio_normalization.dart';
import 'package:PiliPlus/models/video/play/url.dart';

final _loudnormRegExp = RegExp('loudnorm=([^,]+)');
final _singleDynaudnormRegExp = RegExp('^dynaudnorm=(.+)\$');
final _singleLoudnormRegExp = RegExp('^loudnorm=([^,]+)\$');

String? resolveAudioNormalizationFilter({
  required String config,
  required String fallbackConfig,
  Volume? volume,
}) {
  var filter = AudioNormalization.getParamFromConfig(config);
  if (filter.isEmpty) return null;

  if (volume != null && volume.isNotEmpty) {
    filter = filter.replaceFirstMapped(
      _loudnormRegExp,
      (match) =>
          'loudnorm=${volume.format(_parseFilterOptions(match.group(1)!))}',
    );
  } else {
    filter = filter.replaceFirst(
      _loudnormRegExp,
      AudioNormalization.getParamFromConfig(fallbackConfig),
    );
  }

  return filter.isEmpty ? null : filter;
}

Map<String, num> _parseFilterOptions(String options) => Map.fromEntries(
  options.split(':').map((item) {
    final parts = item.split('=');
    final value = num.tryParse(parts[1]);
    return value == null ? null : MapEntry(parts[0].toLowerCase(), value);
  }).nonNulls,
);

sealed class ExoAudioNormalizationResolution {
  const ExoAudioNormalizationResolution();
}

final class ExoAudioNormalizationConfiguration
    extends ExoAudioNormalizationResolution {
  const ExoAudioNormalizationConfiguration({
    required this.gain,
    required this.peak,
    required this.filter,
  });

  final double gain;
  final double peak;
  final String filter;

  Map<String, Object> toMap() => {'gain': gain, 'peak': peak, 'filter': filter};
}

/// Media3 approximation of FFmpeg one-pass loudnorm / dynaudnorm.
///
/// Applies windowed RMS-based automatic gain toward [targetRmsDb], bounded by
/// [maxGain], smoothed by [smoothing] per window, then a true-peak limiter at
/// [peak]. It intentionally does not replicate arbitrary chained FFmpeg
/// filters, which remain `UnsupportedExoAudioNormalization`.
final class ExoAudioDynamicNormalizationConfiguration
    extends ExoAudioNormalizationResolution {
  const ExoAudioDynamicNormalizationConfiguration({
    required this.targetRmsDb,
    required this.peak,
    required this.maxGain,
    required this.frameMs,
    required this.smoothing,
    required this.filter,
  });

  final double targetRmsDb;
  final double peak;
  final double maxGain;
  final int frameMs;
  final double smoothing;
  final String filter;

  Map<String, Object> toMap() => {
    'gain': 1.0,
    'peak': peak,
    'filter': filter,
    'dynamic': true,
    'targetRmsDb': targetRmsDb,
    'maxGain': maxGain,
    'frameMs': frameMs,
    'smoothing': smoothing,
  };
}

final class UnsupportedExoAudioNormalization
    extends ExoAudioNormalizationResolution {
  const UnsupportedExoAudioNormalization(this.filter);

  final String filter;
}

ExoAudioNormalizationResolution? resolveExoAudioNormalization({
  required String config,
  required String fallbackConfig,
  Volume? volume,
}) {
  final filter = resolveAudioNormalizationFilter(
    config: config,
    fallbackConfig: fallbackConfig,
    volume: volume,
  );
  if (filter == null) return null;

  final dynaudnorm = _singleDynaudnormRegExp.firstMatch(filter);
  if (dynaudnorm != null) {
    final options = _parseFilterOptions(dynaudnorm.group(1)!);
    return ExoAudioDynamicNormalizationConfiguration(
      targetRmsDb: -16,
      peak: 1,
      maxGain: (options['g'] ?? 5).toDouble().clamp(1, 100).toDouble(),
      frameMs: (options['f'] ?? 250).toInt().clamp(20, 2000).toInt(),
      smoothing: (options['r'] ?? 0.9).toDouble().clamp(0.01, 1).toDouble(),
      filter: filter,
    );
  }

  final match = _singleLoudnormRegExp.firstMatch(filter);
  if (match == null) return UnsupportedExoAudioNormalization(filter);
  final options = _parseFilterOptions(match.group(1)!);
  final measuredI = options['measured_i']?.toDouble();
  final measuredTp = options['measured_tp']?.toDouble();
  if (measuredI == null || measuredI >= 0 || measuredTp == null) {
    final targetI = (options['i'] ?? -24).toDouble().clamp(-70, -5).toDouble();
    final targetTp = (options['tp'] ?? -2).toDouble().clamp(-9, 0).toDouble();
    return ExoAudioDynamicNormalizationConfiguration(
      targetRmsDb: targetI,
      peak: pow(10, targetTp / 20).toDouble(),
      maxGain: 10,
      frameMs: 3000,
      smoothing: 0.35,
      filter: filter,
    );
  }

  final targetI = (options['i'] ?? -24).toDouble().clamp(-70, -5).toDouble();
  final targetTp = (options['tp'] ?? -2).toDouble().clamp(-9, 0).toDouble();
  final offset = (options['offset'] ?? 0).toDouble();
  final gainDb = (targetI - measuredI + offset).clamp(-24, 24);
  return ExoAudioNormalizationConfiguration(
    gain: pow(10, gainDb / 20).toDouble(),
    peak: pow(10, targetTp / 20).toDouble(),
    filter: filter,
  );
}
