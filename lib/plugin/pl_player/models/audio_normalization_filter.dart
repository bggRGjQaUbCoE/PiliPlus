import 'dart:math' show log, pow;

import 'package:PiliPlus/models/common/audio_normalization.dart';
import 'package:PiliPlus/models/video/play/url.dart';

final _loudnormRegExp = RegExp('loudnorm=([^,]+)');
final _volumeStageRegExp = RegExp('^volume=(.+)\$');
final _highpassStageRegExp = RegExp('^highpass=(.+)\$');
final _lowpassStageRegExp = RegExp('^lowpass=(.+)\$');
final _highshelfStageRegExp = RegExp('^highshelf=(.+)\$');
final _lowshelfStageRegExp = RegExp('^lowshelf=(.+)\$');
final _equalizerStageRegExp = RegExp('^equalizer=(.+)\$');
final _singleDynaudnormRegExp = RegExp('^dynaudnorm=(.+)\$');
final _singleLoudnormRegExp = RegExp('^loudnorm=([^,]+)\$');

typedef ExoEqualizerBand = ({
  double frequencyHz,
  double gainDb,
  double q,
  String type,
});

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
    if (parts.length != 2) return null;
    final value = num.tryParse(parts[1]);
    return value == null ? null : MapEntry(parts[0].toLowerCase(), value);
  }).nonNulls,
);

/// Parses an FFmpeg `volume` stage into a linear multiplier.
///
/// Accepts linear values (`volume=0.8`) and decibel values (`volume=-3dB`).
/// Extra colon-separated options are ignored by this approximation.
double? _parseVolumeMultiplier(String stage) {
  final value = stage.substring('volume='.length).trim();
  final first = value.split(':').first.trim();
  final lower = first.toLowerCase();
  if (lower.endsWith('db')) {
    final decibels = double.tryParse(lower.substring(0, lower.length - 2));
    return decibels == null ? null : pow(10, decibels / 20).toDouble();
  }
  final linear = double.tryParse(lower);
  return linear == null || linear < 0 ? null : linear;
}

double _decibelsOf(double multiplier) => 20 * log(multiplier) / log(10);

double? _parseHighpassHz(String stage) {
  final options = _parseFilterOptions(stage.substring('highpass='.length));
  final frequency = options['f'] ?? options['frequency'];
  final value = frequency?.toDouble();
  return value != null && value.isFinite && value > 0 ? value : null;
}

double? _parseLowpassHz(String stage) {
  final options = _parseFilterOptions(stage.substring('lowpass='.length));
  final frequency = options['f'] ?? options['frequency'];
  final value = frequency?.toDouble();
  return value != null && value.isFinite && value > 0 ? value : null;
}

({double frequencyHz, double gainDb, double q, String type})? _parseShelf(
  String stage,
  String type,
) {
  final options = _parseFilterOptions(
    stage.substring(type.length + 1),
  );
  final frequency =
      options['f']?.toDouble() ?? options['frequency']?.toDouble();
  final gain = options['g']?.toDouble() ?? options['gain']?.toDouble();
  final width = options['w']?.toDouble() ?? options['width']?.toDouble() ?? 1;
  if (frequency == null ||
      gain == null ||
      !frequency.isFinite ||
      frequency <= 0 ||
      !gain.isFinite ||
      !width.isFinite ||
      width <= 0) {
    return null;
  }
  return (frequencyHz: frequency, gainDb: gain, q: width, type: type);
}

({double frequencyHz, double gainDb, double q, String type})? _parseEqualizer(
  String stage,
) {
  final options = _parseFilterOptions(stage.substring('equalizer='.length));
  final frequency = options['f']?.toDouble();
  final gain = options['g']?.toDouble();
  final q = options['w']?.toDouble() ?? options['q']?.toDouble();
  final type =
      RegExp(
            r'(?:^|:)t=([^:]+)',
            caseSensitive: false,
          )
          .firstMatch(stage.substring('equalizer='.length))
          ?.group(1)
          ?.toLowerCase() ??
      'q';
  if (frequency == null ||
      gain == null ||
      q == null ||
      !frequency.isFinite ||
      frequency <= 0 ||
      !gain.isFinite ||
      !q.isFinite ||
      q <= 0 ||
      type != 'q') {
    return null;
  }
  return (frequencyHz: frequency, gainDb: gain, q: q, type: type);
}

sealed class ExoAudioNormalizationResolution {
  const ExoAudioNormalizationResolution();
}

final class ExoAudioNormalizationConfiguration
    extends ExoAudioNormalizationResolution {
  const ExoAudioNormalizationConfiguration({
    required this.gain,
    required this.peak,
    required this.filter,
    this.highpassHz,
    this.lowpassHz,
    this.equalizerFrequencyHz,
    this.equalizerGainDb,
    this.equalizerQ,
    this.equalizerBands = const [],
  });

  final double gain;
  final double peak;
  final String filter;
  final double? highpassHz;
  final double? lowpassHz;
  final double? equalizerFrequencyHz;
  final double? equalizerGainDb;
  final double? equalizerQ;
  final List<ExoEqualizerBand> equalizerBands;

  Map<String, Object> toMap() => {
    'gain': gain,
    'peak': peak,
    'filter': filter,
    ...?highpassHz == null ? null : <String, Object>{'highpassHz': highpassHz!},
    ...?lowpassHz == null ? null : <String, Object>{'lowpassHz': lowpassHz!},
    ...?equalizerFrequencyHz == null
        ? null
        : <String, Object>{'equalizerFrequencyHz': equalizerFrequencyHz!},
    ...?equalizerGainDb == null
        ? null
        : <String, Object>{'equalizerGainDb': equalizerGainDb!},
    ...?equalizerQ == null ? null : <String, Object>{'equalizerQ': equalizerQ!},
    if (equalizerBands.isNotEmpty)
      'equalizerBands': equalizerBands
          .map(
            (band) => <String, Object>{
              'frequencyHz': band.frequencyHz,
              'gainDb': band.gainDb,
              'q': band.q,
              'type': band.type,
            },
          )
          .toList(),
  };
}

/// Media3 approximation of FFmpeg one-pass loudnorm / dynaudnorm.
///
/// Applies windowed RMS-based automatic gain toward [targetRmsDb], bounded by
/// [maxGain], smoothed by [smoothing] per window, then a true-peak limiter at
/// [peak].
final class ExoAudioDynamicNormalizationConfiguration
    extends ExoAudioNormalizationResolution {
  const ExoAudioDynamicNormalizationConfiguration({
    required this.targetRmsDb,
    required this.peak,
    required this.maxGain,
    required this.frameMs,
    required this.smoothing,
    required this.filter,
    this.highpassHz,
    this.lowpassHz,
    this.equalizerFrequencyHz,
    this.equalizerGainDb,
    this.equalizerQ,
    this.equalizerBands = const [],
  });

  final double targetRmsDb;
  final double peak;
  final double maxGain;
  final int frameMs;
  final double smoothing;
  final String filter;
  final double? highpassHz;
  final double? lowpassHz;
  final double? equalizerFrequencyHz;
  final double? equalizerGainDb;
  final double? equalizerQ;
  final List<ExoEqualizerBand> equalizerBands;

  Map<String, Object> toMap() => {
    'gain': 1.0,
    'peak': peak,
    'filter': filter,
    'dynamic': true,
    'targetRmsDb': targetRmsDb,
    'maxGain': maxGain,
    'frameMs': frameMs,
    'smoothing': smoothing,
    ...?highpassHz == null ? null : <String, Object>{'highpassHz': highpassHz!},
    ...?lowpassHz == null ? null : <String, Object>{'lowpassHz': lowpassHz!},
    ...?equalizerFrequencyHz == null
        ? null
        : <String, Object>{'equalizerFrequencyHz': equalizerFrequencyHz!},
    ...?equalizerGainDb == null
        ? null
        : <String, Object>{'equalizerGainDb': equalizerGainDb!},
    ...?equalizerQ == null ? null : <String, Object>{'equalizerQ': equalizerQ!},
    if (equalizerBands.isNotEmpty)
      'equalizerBands': equalizerBands
          .map(
            (band) => <String, Object>{
              'frequencyHz': band.frequencyHz,
              'gainDb': band.gainDb,
              'q': band.q,
              'type': band.type,
            },
          )
          .toList(),
  };
}

final class UnsupportedExoAudioNormalization
    extends ExoAudioNormalizationResolution {
  const UnsupportedExoAudioNormalization(this.filter, {this.unsupportedStage});

  final String filter;

  /// The exact chain stage that cannot be mapped, when known.
  final String? unsupportedStage;
}

/// Resolves a possibly chained FFmpeg audio-normalization filter for Media3.
///
/// Supported primitives are `volume=` plus at most one `loudnorm=` or
/// `dynaudnorm=` stage, peaking `equalizer=t=q` stages, and RBJ
/// `highshelf=`/`lowshelf=` stages.
/// Volume stages are folded into the normalized output (volume-last
/// semantics), which also approximates volume-before-loudness chains because
/// loudness normalization re-normalizes the result. Unknown stages or more
/// than one loudness stage remain unsupported and are reported with the
/// offending stage name.
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

  final chain = filter
      .split(',')
      .map((stage) => stage.trim())
      .where((stage) => stage.isNotEmpty)
      .toList();

  var volumeMultiplier = 1.0;
  final loudnessStages = <String>[];
  double? highpassHz;
  double? lowpassHz;
  double? equalizerFrequencyHz;
  double? equalizerGainDb;
  double? equalizerQ;
  final equalizerBands = <ExoEqualizerBand>[];
  String? unsupportedStage;
  for (final stage in chain) {
    if (_volumeStageRegExp.hasMatch(stage)) {
      final parsed = _parseVolumeMultiplier(stage);
      if (parsed == null) {
        unsupportedStage = stage;
        break;
      }
      volumeMultiplier *= parsed;
      continue;
    }
    if (_highpassStageRegExp.hasMatch(stage)) {
      final parsed = _parseHighpassHz(stage);
      if (parsed == null || highpassHz != null) {
        unsupportedStage = stage;
        break;
      }
      highpassHz = parsed;
      continue;
    }
    if (_lowpassStageRegExp.hasMatch(stage)) {
      final parsed = _parseLowpassHz(stage);
      if (parsed == null || lowpassHz != null) {
        unsupportedStage = stage;
        break;
      }
      lowpassHz = parsed;
      continue;
    }
    if (_highshelfStageRegExp.hasMatch(stage)) {
      final parsed = _parseShelf(stage, 'highshelf');
      if (parsed == null) {
        unsupportedStage = stage;
        break;
      }
      equalizerBands.add(parsed);
      continue;
    }
    if (_lowshelfStageRegExp.hasMatch(stage)) {
      final parsed = _parseShelf(stage, 'lowshelf');
      if (parsed == null) {
        unsupportedStage = stage;
        break;
      }
      equalizerBands.add(parsed);
      continue;
    }
    if (_equalizerStageRegExp.hasMatch(stage)) {
      final parsed = _parseEqualizer(stage);
      if (parsed == null) {
        unsupportedStage = stage;
        break;
      }
      equalizerBands.add(parsed);
      if (equalizerBands.length == 1) {
        equalizerFrequencyHz = parsed.frequencyHz;
        equalizerGainDb = parsed.gainDb;
        equalizerQ = parsed.q;
      }
      continue;
    }
    if (_singleDynaudnormRegExp.hasMatch(stage) ||
        _singleLoudnormRegExp.hasMatch(stage)) {
      loudnessStages.add(stage);
      continue;
    }
    unsupportedStage = stage;
    break;
  }
  if (unsupportedStage != null) {
    return UnsupportedExoAudioNormalization(
      filter,
      unsupportedStage: unsupportedStage,
    );
  }
  if (loudnessStages.length > 1) {
    return UnsupportedExoAudioNormalization(
      filter,
      unsupportedStage: loudnessStages[1],
    );
  }

  if (volumeMultiplier <= 0) {
    return ExoAudioNormalizationConfiguration(
      gain: 0,
      peak: 1,
      filter: filter,
      highpassHz: highpassHz,
      lowpassHz: lowpassHz,
      equalizerFrequencyHz: equalizerFrequencyHz,
      equalizerGainDb: equalizerGainDb,
      equalizerQ: equalizerQ,
      equalizerBands: equalizerBands,
    );
  }

  final volumeDb = _decibelsOf(volumeMultiplier);
  final stage = loudnessStages.isEmpty ? null : loudnessStages.first;
  if (stage == null) {
    return ExoAudioNormalizationConfiguration(
      gain: volumeMultiplier,
      peak: 1,
      filter: filter,
      highpassHz: highpassHz,
      lowpassHz: lowpassHz,
      equalizerFrequencyHz: equalizerFrequencyHz,
      equalizerGainDb: equalizerGainDb,
      equalizerQ: equalizerQ,
      equalizerBands: equalizerBands,
    );
  }

  final dynaudnorm = _singleDynaudnormRegExp.firstMatch(stage);
  if (dynaudnorm != null) {
    final options = _parseFilterOptions(dynaudnorm.group(1)!);
    return ExoAudioDynamicNormalizationConfiguration(
      targetRmsDb: -16 + volumeDb,
      peak: 1,
      maxGain: (options['g'] ?? 5).toDouble().clamp(1, 100).toDouble(),
      frameMs: (options['f'] ?? 250).toInt().clamp(20, 2000).toInt(),
      smoothing: (options['r'] ?? 0.9).toDouble().clamp(0.01, 1).toDouble(),
      filter: filter,
      highpassHz: highpassHz,
      lowpassHz: lowpassHz,
      equalizerFrequencyHz: equalizerFrequencyHz,
      equalizerGainDb: equalizerGainDb,
      equalizerQ: equalizerQ,
      equalizerBands: equalizerBands,
    );
  }

  final match = _singleLoudnormRegExp.firstMatch(stage)!;
  final options = _parseFilterOptions(match.group(1)!);
  final measuredI = options['measured_i']?.toDouble();
  final measuredTp = options['measured_tp']?.toDouble();
  if (measuredI == null || measuredI >= 0 || measuredTp == null) {
    final targetI = (options['i'] ?? -24).toDouble().clamp(-70, -5).toDouble();
    final targetTp = (options['tp'] ?? -2).toDouble().clamp(-9, 0).toDouble();
    return ExoAudioDynamicNormalizationConfiguration(
      targetRmsDb: targetI + volumeDb,
      peak: pow(10, targetTp / 20).toDouble(),
      maxGain: 10,
      frameMs: 3000,
      smoothing: 0.35,
      filter: filter,
      highpassHz: highpassHz,
      lowpassHz: lowpassHz,
      equalizerFrequencyHz: equalizerFrequencyHz,
      equalizerGainDb: equalizerGainDb,
      equalizerQ: equalizerQ,
      equalizerBands: equalizerBands,
    );
  }

  final targetI = (options['i'] ?? -24).toDouble().clamp(-70, -5).toDouble();
  final targetTp = (options['tp'] ?? -2).toDouble().clamp(-9, 0).toDouble();
  final offset = (options['offset'] ?? 0).toDouble();
  final gainDb = (targetI - measuredI + offset).clamp(-24, 24);
  return ExoAudioNormalizationConfiguration(
    gain: pow(10, gainDb / 20).toDouble() * volumeMultiplier,
    peak: pow(10, targetTp / 20).toDouble(),
    filter: filter,
    highpassHz: highpassHz,
    lowpassHz: lowpassHz,
    equalizerFrequencyHz: equalizerFrequencyHz,
    equalizerGainDb: equalizerGainDb,
    equalizerQ: equalizerQ,
    equalizerBands: equalizerBands,
  );
}
