import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:PiliPlus/models/video/play/url.dart' show Volume;
import 'package:flutter/foundation.dart' show VoidCallback, kDebugMode;
import 'package:media_kit/media_kit.dart' show Player;

class LoudnessActiveSummary {
  const LoudnessActiveSummary({
    required this.enabled,
    required this.modeTitle,
    required this.isBewlyMode,
    this.measuredLufs,
    this.measuredLra,
    this.measuredTp,
    this.baseGainDb,
    required this.targetLufs,
    required this.strength,
    required this.isLive,
    required this.mpvAfFilter,
  });

  final bool enabled;
  final String modeTitle;
  final bool isBewlyMode;
  final double? measuredLufs;
  final double? measuredLra;
  final double? measuredTp;
  final double? baseGainDb;
  final int targetLufs;
  final int strength;
  final bool isLive;
  final String mpvAfFilter;

  String get shortStatusText {
    if (!enabled) return '已关闭';
    if (!isBewlyMode) return modeTitle;
    if (measuredLufs != null && baseGainDb != null) {
      final sign = baseGainDb! >= 0 ? '+' : '';
      final lraSuffix = (measuredLra != null && measuredLra! > 0.1)
          ? ' · LRA ${measuredLra!.toStringAsFixed(1)} LU'
          : '';
      return '原始 ${measuredLufs!.toStringAsFixed(1)} LUFS · 预增益 $sign${baseGainDb!.toStringAsFixed(1)} dB$lraSuffix';
    }
    if (isLive) {
      return '直播低延迟动态均衡中（目标 $targetLufs LUFS）';
    }
    return '自适应动态均衡生效中（目标 $targetLufs LUFS）';
  }
}

enum AudioNormalization {
  disable('禁用'),
  bewly('智能音量平衡'),
  // ref https://github.com/KRTirtho/spotube/commit/da10ab2e291d4ba4d3082b9a6ae535639fb8f1b7
  dynaudnorm('动态平滑 dynaudnorm', 'dynaudnorm=g=5:f=250:r=0.9:p=0.5'),
  loudnorm('标准响度 loudnorm', 'loudnorm=I=-16:LRA=11:TP=-1.5'),
  custom('自定义参数'),
  ;

  final String title;
  final String param;
  const AudioNormalization(this.title, [this.param = '']);

  static const String disableCode = '0';
  static const String bewlyCode = 'bewly';
  static const String dynaudnormCode = '1';
  static const String loudnormCode = '2';
  static const String customCode = '3';

  static const int minTargetLufs = -24;
  static const int maxTargetLufs = -14;
  static const int defaultTargetLufs = -18;

  static const int minStrength = 0;
  static const int maxStrength = 100;
  static const int defaultStrength = 75;

  /// -1.0 dBFS 采样峰值上限 (10^(-1/20) ≈ 0.89125)
  static const double peakLimitLinear = 0.89125;

  /// 原仓库仅 Android 预编译 libmpv 编入了 dynaudnorm / loudnorm / alimiter 滤镜，
  /// 对齐既有设置页门控（Debug 模式或 Android 端开放）。
  static bool get isPlatformSupported => kDebugMode || Platform.isAndroid;

  static bool isEnabledConfig(String config) =>
      config.isNotEmpty && config != disableCode;

  static String getTitleFromConfig(String config) => switch (config) {
    disableCode => disable.title,
    bewlyCode => bewly.title,
    dynaudnormCode => dynaudnorm.title,
    loudnormCode => loudnorm.title,
    customCode => custom.title,
    _ => config,
  };

  static String getSettingSummary({
    required String config,
    required int targetLufs,
    required int strength,
    String fallback = disableCode,
  }) {
    if (!isEnabledConfig(config)) {
      return '当前:「已禁用」';
    }
    if (config == bewlyCode) {
      return '当前:「${bewly.title}」· 目标 $targetLufs LUFS · 强度 $strength%';
    }
    final modeTitle = getTitleFromConfig(config);
    if ((config == loudnormCode || loudnormRegExp.hasMatch(config)) &&
        fallback != disableCode) {
      return '当前:「$modeTitle」，无参数时:「${getTitleFromConfig(fallback)}」';
    }
    return '当前:「$modeTitle」';
  }

  static String getParamFromConfig(String config) => switch (config) {
    disableCode => disable.param,
    bewlyCode => bewlyCode,
    dynaudnormCode => dynaudnorm.param,
    loudnormCode => loudnorm.param,
    _ => config,
  };

  static final loudnormRegExp = RegExp('loudnorm=([^,]+)');

  static bool hasValidMeasuredLoudness(Volume? volume) {
    if (volume == null || !volume.isNotEmpty) return false;
    final measured = volume.measuredI.toDouble();
    return measured.isFinite && measured < -0.5 && measured > -70.0;
  }

  /// 计算跨视频基准对齐预增益（单位 dB）。无有效服务端响度数据时返回 null。
  ///
  /// 跨视频积分响度 100% 向 [targetLufs] 对齐，限制在 `[-18 dB, +10 dB]` 安全范围；
  /// [strength] 仅控制视频内部动态平滑与轻声提亮深度，两者职责彻底解耦。
  static double? computeBaseGainDb({
    required int targetLufs,
    required int strength,
    Volume? volume,
  }) {
    if (!hasValidMeasuredLoudness(volume)) return null;
    final clampedTarget = targetLufs.clamp(minTargetLufs, maxTargetLufs);
    final delta = clampedTarget - volume!.measuredI.toDouble();
    return delta.clamp(-18.0, 10.0);
  }

  /// 计算 LRA（响度范围）自适应动态平滑系数 `[0.55, 1.0]`：
  /// 原本制作均衡的音乐/播客（LRA <= 4 LU）自动减轻压缩，保留音乐呼吸感；
  /// 高动态起伏的 Vlog/影视（LRA >= 11 LU）释放完整动态均衡深度。
  static double computeLraAdaptiveFactor(Volume? volume) {
    if (volume == null || !hasValidMeasuredLoudness(volume)) return 1.0;
    final lra = volume.measuredLra.toDouble();
    if (!lra.isFinite || lra <= 0.1) return 1.0;
    final t = ((lra - 4.0) / 7.0).clamp(0.0, 1.0);
    return 0.55 + 0.45 * t;
  }

  /// 估算局部有效均衡参数，供真实滤镜图与设置页严格保持同源一致。
  static ({
    double? baseGainDb,
    double targetRms,
    int frameMs,
    int gaussFrames,
    double maxGainLinear,
    double lraFactor,
  }) resolveBewlyParameters({
    required int targetLufs,
    required int strength,
    Volume? volume,
    bool isLive = false,
  }) {
    final clampedTarget = targetLufs.clamp(minTargetLufs, maxTargetLufs);
    final clampedStrength = strength.clamp(minStrength, maxStrength);
    final norm = clampedStrength / 100.0;

    final baseGainDb = computeBaseGainDb(
      targetLufs: clampedTarget,
      strength: clampedStrength,
      volume: volume,
    );

    final lraFactor = computeLraAdaptiveFactor(volume);
    final effectiveNorm = (norm * lraFactor).clamp(0.0, 1.0);

    // 双声道 BS.1770 响度与每声道 RMS 映射：L_LUFS ≈ 2.319 + 20 * log10(rms)
    final targetRms = math
        .pow(10.0, (clampedTarget - 2.319) / 20.0)
        .toDouble()
        .clamp(0.02, 0.35);

    // 直播采用低延迟窗口（f=80, g=5 ≈ 400ms）；
    // 点播采用适中平滑窗口（f=150, g=5..9 ≈ 0.75s..1.35s），兼顾平滑度与切歌/拖动响应速度。
    final int frameMs = isLive ? 80 : 150;
    int gaussFrames;
    if (isLive) {
      gaussFrames = 5;
    } else {
      gaussFrames = (9 - effectiveNorm * 4).round();
      if (gaussFrames.isEven) gaussFrames -= 1;
      gaussFrames = gaussFrames.clamp(5, 9);
    }

    // 最大局部提亮增益：
    // - 有服务端预增益时，补充视频内局部提亮：+3.0 ~ +9.0 dB (经 LRA 自适应缩放)
    // - 无服务端预增益时兼顾整体拉齐：+5.0 ~ +12.0 dB
    final double maxBoostDb = baseGainDb != null
        ? (3.0 + 6.0 * effectiveNorm)
        : (5.0 + 7.0 * effectiveNorm);
    final maxGainLinear = math.pow(10.0, maxBoostDb / 20.0).toDouble();

    return (
      baseGainDb: baseGainDb,
      targetRms: targetRms,
      frameMs: frameMs,
      gaussFrames: gaussFrames,
      maxGainLinear: maxGainLinear,
      lraFactor: lraFactor,
    );
  }

  /// 构建全平台兼容的 BewlyCat 风格音频滤镜链（仅使用 Android / iOS / Desktop
  /// 全平台 libmpv 均内置的 `alimiter` 与 `dynaudnorm`，绝不使用 Android 缺失的 `volume` 滤镜）：
  /// 1) 跨视频基准响度预增益（`alimiter=level_in=...:limit=1:attack=5:release=50:level=0:latency=1`，可选）
  /// 2) LRA 自适应动态平衡（`dynaudnorm`，`strength == 0` 且已有预增益时跳过；由 `m` 上限自然约束底噪放大）
  /// 3) `-1.0 dBFS` 前瞻峰值防爆音限制器（`alimiter`，带 `latency=1` 自动延迟补偿）
  static String buildBewlyFilterGraph({
    required int targetLufs,
    required int strength,
    Volume? volume,
    bool isLive = false,
  }) {
    final params = resolveBewlyParameters(
      targetLufs: targetLufs,
      strength: strength,
      volume: volume,
      isLive: isLive,
    );
    final clampedStrength = strength.clamp(minStrength, maxStrength);
    final hasPreGain =
        params.baseGainDb != null && params.baseGainDb!.abs() >= 0.05;
    final preGainLinear = hasPreGain
        ? math
            .pow(10.0, params.baseGainDb! / 20.0)
            .toDouble()
            .clamp(0.015625, 64.0)
        : null;

    // 强度为 0% 且具备服务端精准响度时，合并为单级 alimiter，同时完成预增益与 -1.0 dBFS 峰值限幅
    final applyDynamicStage = clampedStrength > 0 || params.baseGainDb == null;
    if (!applyDynamicStage) {
      if (preGainLinear != null) {
        return 'alimiter='
            'level_in=${preGainLinear.toStringAsFixed(4)}:'
            'limit=${peakLimitLinear.toStringAsFixed(5)}:'
            'attack=5:'
            'release=80:'
            'level=0:'
            'latency=1';
      }
      return 'alimiter='
          'limit=${peakLimitLinear.toStringAsFixed(5)}:'
          'attack=5:'
          'release=80:'
          'level=0:'
          'latency=1';
    }

    final stages = <String>[
      if (preGainLinear != null)
        'alimiter='
            'level_in=${preGainLinear.toStringAsFixed(4)}:'
            'limit=1:'
            'attack=5:'
            'release=50:'
            'level=0:'
            'latency=1',
      'dynaudnorm='
          'f=${params.frameMs}:'
          'g=${params.gaussFrames}:'
          'p=${peakLimitLinear.toStringAsFixed(5)}:'
          'm=${params.maxGainLinear.toStringAsFixed(2)}:'
          'r=${params.targetRms.toStringAsFixed(4)}:'
          'n=1:'
          'b=1',
      'alimiter='
          'limit=${peakLimitLinear.toStringAsFixed(5)}:'
          'attack=5:'
          'release=80:'
          'level=0:'
          'latency=1',
    ];

    return stages.join(',');
  }

  static String parse(
    Volume? volume,
    String param, {
    String fallbackConfig = disableCode,
    int targetLufs = defaultTargetLufs,
    int strength = defaultStrength,
    bool isLive = false,
  }) {
    if (volume != null && volume.isNotEmpty) {
      return param.replaceFirstMapped(
        loudnormRegExp,
        (i) =>
            'loudnorm=${volume.format(
              Map.fromEntries(
                i.group(1)!.split(':').map((item) {
                  final parts = item.split('=');
                  return MapEntry(parts[0].toLowerCase(), num.parse(parts[1]));
                }),
              ),
            )}',
      );
    } else {
      final replacement = fallbackConfig == bewlyCode
          ? buildBewlyFilterGraph(
              targetLufs: targetLufs,
              strength: strength,
              isLive: isLive,
            )
          : getParamFromConfig(fallbackConfig);
      return param.replaceFirst(loudnormRegExp, replacement);
    }
  }

  /// 计算 >100% 播放器音量时的无削波增强滤镜（使用三次方曲线，与 mpv 原生手感一致）。
  static String? buildVolumeBoostFilter(double volumeFactor) {
    if (volumeFactor <= 1.0) return null;
    final db = (60 * math.log(volumeFactor) / math.ln10 * 2).round() / 2;
    final gain = math.pow(10, db / 20).toDouble().clamp(1.0, 64.0);
    return 'alimiter=level_in=${gain.toStringAsFixed(3)}:limit=1:level=0';
  }

  /// 构建仅包含音量均衡部分的原始滤镜串（不含 `lavfi=[...]` 外壳及超 100% 音量增益）。
  static String buildNormalizationStages({
    required String config,
    int targetLufs = defaultTargetLufs,
    int strength = defaultStrength,
    Volume? volume,
    String fallbackConfig = disableCode,
    bool isLive = false,
  }) {
    final trimmed = config.trim();
    if (!isEnabledConfig(trimmed) || trimmed == customCode) {
      return '';
    }
    if (trimmed == bewlyCode) {
      return buildBewlyFilterGraph(
        targetLufs: targetLufs,
        strength: strength,
        volume: volume,
        isLive: isLive,
      );
    }
    final rawParam = getParamFromConfig(trimmed);
    var parsed = parse(
      volume,
      rawParam,
      fallbackConfig: fallbackConfig,
      targetLufs: targetLufs,
      strength: strength,
      isLive: isLive,
    ).trim();
    if (parsed.startsWith('lavfi=[') && parsed.endsWith(']')) {
      parsed = parsed.substring(7, parsed.length - 1).trim();
    }
    return parsed;
  }

  /// 构建直接下发给 mpv `setProperty('af', ...)` 的完整滤镜字符串。
  /// 同时合成音量均衡链与 >100% 播放器音量抗削波放大链，互不覆盖。
  static String buildMpvAfFilter({
    required String config,
    int targetLufs = defaultTargetLufs,
    int strength = defaultStrength,
    Volume? volume,
    String fallbackConfig = disableCode,
    bool isLive = false,
    double volumeFactor = 1.0,
  }) {
    final normStages = isPlatformSupported
        ? buildNormalizationStages(
            config: config,
            targetLufs: targetLufs,
            strength: strength,
            volume: volume,
            fallbackConfig: fallbackConfig,
            isLive: isLive,
          )
        : '';
    final boostStage = buildVolumeBoostFilter(volumeFactor);

    if (normStages.isEmpty && boostStage == null) {
      return '';
    }
    if (normStages.isEmpty) {
      return boostStage!;
    }
    if (normStages.startsWith('lavfi=')) {
      return boostStage == null ? normStages : '$normStages,$boostStage';
    }
    final combined =
        boostStage == null ? normStages : '$normStages,$boostStage';
    return 'lavfi=[$combined]';
  }

  static LoudnessActiveSummary describeActiveState({
    required String config,
    required int targetLufs,
    required int strength,
    Volume? volume,
    String fallbackConfig = disableCode,
    bool isLive = false,
  }) {
    final enabled = isEnabledConfig(config);
    final isBewly = config == bewlyCode;
    final filter = buildMpvAfFilter(
      config: config,
      targetLufs: targetLufs,
      strength: strength,
      volume: volume,
      fallbackConfig: fallbackConfig,
      isLive: isLive,
    );
    final validVol = hasValidMeasuredLoudness(volume);
    return LoudnessActiveSummary(
      enabled: enabled && filter.isNotEmpty,
      modeTitle: getTitleFromConfig(config),
      isBewlyMode: isBewly,
      measuredLufs: validVol ? volume!.measuredI.toDouble() : null,
      measuredLra: validVol && volume!.measuredLra.toDouble().isFinite
          ? volume.measuredLra.toDouble()
          : null,
      measuredTp: validVol && volume!.measuredTp.toDouble().isFinite
          ? volume.measuredTp.toDouble()
          : null,
      baseGainDb: isBewly
          ? computeBaseGainDb(
              targetLufs: targetLufs,
              strength: strength,
              volume: volume,
            )
          : null,
      targetLufs: targetLufs.clamp(minTargetLufs, maxTargetLufs),
      strength: strength.clamp(minStrength, maxStrength),
      isLive: isLive,
      mpvAfFilter: filter,
    );
  }
}

mixin AudioNormalizationMixin {
  Player? _afPlayer;
  String? _lastBoostAf;
  double _volumeFactor = 1.0;
  String _cachedNormConfig = AudioNormalization.disableCode;
  int _cachedTargetLufs = AudioNormalization.defaultTargetLufs;
  int _cachedStrength = AudioNormalization.defaultStrength;
  Volume? _cachedVolume;
  String _cachedFallbackConfig = AudioNormalization.disableCode;
  bool _cachedIsLive = false;
  Future<void> _volumeUpdate = Future.value();

  double get currentVolumeFactor => _volumeFactor;

  /// 运行时由 [applyCombinedAudioFilters] 统一通过 mpv `af` 下发，不在打开媒体时重复写入 `lavfi-complex`。
  Map<String, String>? audioFilterExtras(
    Volume? volume, {
    Map<String, String>? map,
  }) => map;

  /// 将当前的「音量均衡配置 + 超过 100% 的防削波增益」合成为同一条 `af` 滤镜下发，
  /// 避免调整音量与调节音量均衡互相覆盖。
  void applyCombinedAudioFilters(
    Player? player, {
    required String config,
    required int targetLufs,
    required int strength,
    Volume? volume,
    required String fallbackConfig,
    bool isLive = false,
  }) {
    _cachedNormConfig = config;
    _cachedTargetLufs = targetLufs;
    _cachedStrength = strength;
    _cachedVolume = volume;
    _cachedFallbackConfig = fallbackConfig;
    _cachedIsLive = isLive;

    if (player == null) return;
    _afPlayer = player;
    _lastBoostAf = AudioNormalization.buildVolumeBoostFilter(_volumeFactor);
    final nextAf = AudioNormalization.buildMpvAfFilter(
      config: config,
      targetLufs: targetLufs,
      strength: strength,
      volume: volume,
      fallbackConfig: fallbackConfig,
      isLive: isLive,
      volumeFactor: _volumeFactor,
    );
    try {
      player.setProperty('af', nextAf);
    } catch (_) {}
  }

  /// 上游防削波音量控制（[volume] 为线性倍数，1.0 即 100%）：
  /// mpv `volume` 恒 <= 100，>100% 的增益安全合入 `af` 尾部，绝不破坏已激活的音量均衡链。
  Future<void>? setVolumeCapped(
    Player? player,
    double volume, {
    VoidCallback? reapplyFilters,
  }) {
    assert(volume >= 0);
    if (player == null) return null;
    final previous = _volumeUpdate;
    return _volumeUpdate = () async {
      try {
        await previous;
      } catch (_) {}
      if (!identical(_afPlayer, player)) {
        _afPlayer = player;
        _lastBoostAf = null;
      }
      _volumeFactor = volume;
      final nextBoostAf = AudioNormalization.buildVolumeBoostFilter(volume);
      final boostChanged = _lastBoostAf != nextBoostAf;
      await player.setVolume(volume <= 1 ? volume * 100 : 100);
      if (boostChanged) {
        _lastBoostAf = nextBoostAf;
        if (reapplyFilters != null) {
          reapplyFilters();
        } else {
          applyCombinedAudioFilters(
            player,
            config: _cachedNormConfig,
            targetLufs: _cachedTargetLufs,
            strength: _cachedStrength,
            volume: _cachedVolume,
            fallbackConfig: _cachedFallbackConfig,
            isLive: _cachedIsLive,
          );
        }
      }
    }();
  }
}
