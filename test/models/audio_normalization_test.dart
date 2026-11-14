import 'package:PiliPlus/models/common/audio_normalization.dart';
import 'package:PiliPlus/models/video/play/url.dart' show Volume;
import 'package:flutter_test/flutter_test.dart';

Volume _makeVolume({
  num measuredI = -14.0,
  num measuredLra = 8.0,
  num measuredTp = -1.2,
  num measuredThreshold = -24.5,
}) {
  return Volume(
    measuredI: measuredI,
    measuredLra: measuredLra,
    measuredTp: measuredTp,
    measuredThreshold: measuredThreshold,
    targetOffset: 0,
    targetI: -16,
    targetTp: -1,
  );
}

void main() {
  group('AudioNormalization (Upgraded BewlyCat Engine)', () {
    test('禁用模式返回空字符串以便清空 mpv af 属性，但仍保留 >100% 防削波增益', () {
      expect(
        AudioNormalization.buildMpvAfFilter(
          config: AudioNormalization.disableCode,
          volume: _makeVolume(),
        ),
        isEmpty,
      );
      expect(
        AudioNormalization.buildMpvAfFilter(
          config: AudioNormalization.disableCode,
          volume: _makeVolume(),
          volumeFactor: 2.0,
        ),
        contains('alimiter=level_in='),
      );
      expect(AudioNormalization.isEnabledConfig('0'), isFalse);
      expect(AudioNormalization.isEnabledConfig('bewly'), isTrue);
    });

    test('使用全平台兼容的 alimiter 预增益替代 volume 滤镜，且不含非法或畸变参数', () {
      final volume = _makeVolume(measuredI: -11.0);
      final af = AudioNormalization.buildMpvAfFilter(
        config: AudioNormalization.bewlyCode,
        targetLufs: -18,
        strength: 75,
        volume: volume,
      );

      expect(af.contains('volume='), isFalse);
      expect(af.contains('asc_coeff'), isFalse);
      expect(af.contains('asc='), isFalse);
      expect(af.contains(':s='), isFalse);
      expect(af.contains(':c=1'), isFalse);
      expect(af.contains(':t='), isFalse);
      expect(af, startsWith('lavfi=[alimiter=level_in='));
      expect(af, contains(',dynaudnorm=f=150:'));
      expect(af, contains(':n=1:b=1,'));
      expect(
        af,
        endsWith(
          'alimiter=limit=0.89125:attack=5:release=80:level=0:latency=1]',
        ),
      );

      final baseGain = AudioNormalization.computeBaseGainDb(
        targetLufs: -18,
        strength: 75,
        volume: volume,
      );
      expect(baseGain, -7.0);
    });

    test('>100% 音量增益与音量均衡滤镜组合输出于同一 af 链且互不覆盖', () {
      final af = AudioNormalization.buildMpvAfFilter(
        config: AudioNormalization.bewlyCode,
        targetLufs: -18,
        strength: 75,
        volume: _makeVolume(measuredI: -22.0),
        volumeFactor: 1.5,
      );

      expect(af, startsWith('lavfi=[alimiter=level_in='));
      expect(af, contains('dynaudnorm='));
      expect(
        af,
        contains(
          'alimiter=limit=0.89125:attack=5:release=80:level=0:latency=1,alimiter=level_in=',
        ),
      );
      expect(af.contains('asc_coeff'), isFalse);
    });

    test('过轻/过响视频预增益严格钳制在 [-18 dB, +10 dB] 安全区间', () {
      final quietVolume = _makeVolume(measuredI: -32.0);
      final baseGain = AudioNormalization.computeBaseGainDb(
        targetLufs: -18,
        strength: 100,
        volume: quietVolume,
      );
      expect(baseGain, 10.0);

      final extremeLoudVolume = _makeVolume(measuredI: -1.0);
      final negativeGain = AudioNormalization.computeBaseGainDb(
        targetLufs: -24,
        strength: 100,
        volume: extremeLoudVolume,
      );
      expect(negativeGain, -18.0);
    });

    test('强度 0% 且已有服务端响度时合并为单级 alimiter 以彻底保留原始动态', () {
      final afStrength0 = AudioNormalization.buildMpvAfFilter(
        config: AudioNormalization.bewlyCode,
        targetLufs: -18,
        strength: 0,
        volume: _makeVolume(measuredI: -22.0),
      );
      expect(afStrength0, startsWith('lavfi=[alimiter=level_in='));
      expect(
        afStrength0,
        endsWith('limit=0.89125:attack=5:release=80:level=0:latency=1]'),
      );
      expect(afStrength0.contains('dynaudnorm='), isFalse);
    });

    test('LRA 自适应调制与直播低延迟配置符合预期', () {
      final musicParams = AudioNormalization.resolveBewlyParameters(
        targetLufs: -18,
        strength: 75,
        volume: _makeVolume(measuredLra: 3.5),
      );
      final vlogParams = AudioNormalization.resolveBewlyParameters(
        targetLufs: -18,
        strength: 75,
        volume: _makeVolume(measuredLra: 14.0),
      );
      expect(musicParams.lraFactor, lessThan(vlogParams.lraFactor));
      expect(musicParams.maxGainLinear, lessThan(vlogParams.maxGainLinear));

      final liveGraph = AudioNormalization.buildBewlyFilterGraph(
        targetLufs: -18,
        strength: 75,
        isLive: true,
      );
      expect(liveGraph, contains('dynaudnorm=f=80:g=5:'));
    });

    test('无服务端响度数据（缓存视频/直播/空 Volume）时跳过预增益并保留完整参数边界', () {
      final afNoVolume = AudioNormalization.buildMpvAfFilter(
        config: AudioNormalization.bewlyCode,
        targetLufs: -18,
        strength: 75,
      );
      expect(afNoVolume, startsWith('lavfi=[dynaudnorm=f=150:'));
      expect(afNoVolume.contains('level_in='), isFalse);

      final emptyVolume = Volume.fromJson(const {});
      expect(AudioNormalization.hasValidMeasuredLoudness(emptyVolume), isFalse);
    });

    test('所有强度档位 (0%~100%) 生成的 dynaudnorm 高斯窗口帧数 g 恒为合法奇数且无非法参数', () {
      final gRegex = RegExp(r'dynaudnorm=f=150:g=(\d+):');
      for (int s = 0; s <= 100; s++) {
        final graph = AudioNormalization.buildBewlyFilterGraph(
          targetLufs: -18,
          strength: s,
        );
        expect(graph.contains('asc_coeff'), isFalse);
        final match = gRegex.firstMatch(graph);
        expect(match, isNotNull, reason: 'strength=$s missing g parameter');
        final g = int.parse(match!.group(1)!);
        expect(g.isOdd, isTrue, reason: 'strength=$s produced even g=$g');
        expect(g, inInclusiveRange(5, 9));
      }
    });

    test('兼容原有 dynaudnorm / loudnorm / 自定义滤镜配置（零回归）', () {
      expect(
        AudioNormalization.buildMpvAfFilter(
          config: AudioNormalization.dynaudnormCode,
        ),
        'lavfi=[${AudioNormalization.dynaudnorm.param}]',
      );

      final loudnormWithVol = AudioNormalization.buildMpvAfFilter(
        config: AudioNormalization.loudnormCode,
        volume: _makeVolume(measuredI: -14.2),
      );
      expect(loudnormWithVol, startsWith('lavfi=[loudnorm=LRA='));
      expect(loudnormWithVol, contains('measured_I=-14.2'));

      final loudnormFallbackToBewly = AudioNormalization.buildMpvAfFilter(
        config: AudioNormalization.loudnormCode,
        volume: null,
        fallbackConfig: AudioNormalization.bewlyCode,
      );
      expect(loudnormFallbackToBewly, startsWith('lavfi=[dynaudnorm='));

      final loudnormFallbackDisabled = AudioNormalization.buildMpvAfFilter(
        config: AudioNormalization.loudnormCode,
        volume: null,
        fallbackConfig: AudioNormalization.disableCode,
      );
      expect(loudnormFallbackDisabled, isEmpty);

      final customFilter = AudioNormalization.buildMpvAfFilter(
        config: 'acompressor=threshold=-18dB:ratio=3',
      );
      expect(customFilter, 'lavfi=[acompressor=threshold=-18dB:ratio=3]');
    });

    test('状态摘要与设置页副标题输出符合预期', () {
      final activeSummary = AudioNormalization.describeActiveState(
        config: AudioNormalization.bewlyCode,
        targetLufs: -18,
        strength: 75,
        volume: _makeVolume(measuredI: -13.5, measuredLra: 6.4),
      );
      expect(activeSummary.enabled, isTrue);
      expect(activeSummary.isBewlyMode, isTrue);
      expect(activeSummary.shortStatusText, contains('原始 -13.5 LUFS'));
      expect(activeSummary.shortStatusText, contains('预增益 -4.5 dB'));
      expect(activeSummary.shortStatusText, contains('LRA 6.4 LU'));

      expect(
        AudioNormalization.getSettingSummary(
          config: AudioNormalization.bewlyCode,
          targetLufs: -18,
          strength: 75,
        ),
        '当前:「智能音量平衡」· 目标 -18 LUFS · 强度 75%',
      );
    });
  });
}
