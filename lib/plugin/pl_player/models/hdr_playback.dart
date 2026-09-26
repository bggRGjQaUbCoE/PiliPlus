import 'package:PiliPlus/models/common/video/video_quality.dart';

/// 片源动态范围
///
/// 以解码后的传递函数与色彩元数据为准，画质与编码信息仅作为辅助提示。
enum VideoDynamicRange {
  unknown('未知'),
  sdr('SDR'),
  hdr10('HDR10 (PQ)'),
  hlg('HLG'),
  dolbyVision('杜比视界'),
  hdrVivid('HDR Vivid'),
  ;

  final String label;

  const VideoDynamicRange(this.label);

  bool get isHdr =>
      this != VideoDynamicRange.unknown && this != VideoDynamicRange.sdr;
}

/// 实际输出模式
enum HdrOutputMode {
  sdr('SDR'),
  hdr('HDR'),
  ;

  final String label;

  const HdrOutputMode(this.label);
}

/// HDR 片源未直通时的回退原因
enum HdrFallbackReason {
  notHdr('片源为 SDR'),
  rendererSdr('当前渲染链路仅支持 SDR'),
  paramUnsupported('播放器不支持所需色彩参数'),
  hdrLayerUnsupported('片源 HDR 层无法解码'),
  ;

  final String label;

  const HdrFallbackReason(this.label);
}

/// 片源格式标记，来自画质与编码信息
enum HdrSourceFormat {
  none,
  hdr10,
  dolbyVision,
  hdrVivid,
  ;

  bool get isHdr => this != HdrSourceFormat.none;

  /// 由画质与编码信息推断片源格式
  static HdrSourceFormat from({VideoQuality? quality, String? codecs}) {
    if (codecs != null && codecs.startsWith('dvh1')) {
      return HdrSourceFormat.dolbyVision;
    }
    return switch (quality) {
      VideoQuality.hdr => HdrSourceFormat.hdr10,
      VideoQuality.dolbyVision => HdrSourceFormat.dolbyVision,
      VideoQuality.hdrVivid => HdrSourceFormat.hdrVivid,
      _ => HdrSourceFormat.none,
    };
  }
}

/// 一次播放的 HDR 状态
class HdrPlaybackInfo {
  /// 片源动态范围
  final VideoDynamicRange source;

  /// 实际输出模式
  final HdrOutputMode output;

  /// 未直通时的回退原因
  final HdrFallbackReason reason;

  const HdrPlaybackInfo({
    this.source = VideoDynamicRange.unknown,
    this.output = HdrOutputMode.sdr,
    this.reason = HdrFallbackReason.notHdr,
  });

  /// 尚未识别到片源
  static const unknown = HdrPlaybackInfo();

  bool get isHdrSource => source.isHdr;

  /// 播放信息中的展示文本，例如 `HDR10 (PQ) → SDR（当前渲染链路仅支持 SDR）`
  String get displayText {
    switch (source) {
      case VideoDynamicRange.unknown:
        return source.label;
      case VideoDynamicRange.sdr:
        return source.label;
      case VideoDynamicRange.hdr10:
      case VideoDynamicRange.hlg:
      case VideoDynamicRange.dolbyVision:
      case VideoDynamicRange.hdrVivid:
        return output == HdrOutputMode.hdr
            ? '${source.label} → HDR'
            : '${source.label} → SDR（${reason.label}）';
    }
  }

  @override
  bool operator ==(Object other) =>
      other is HdrPlaybackInfo &&
      other.source == source &&
      other.output == output &&
      other.reason == reason;

  @override
  int get hashCode => Object.hash(source, output, reason);

  @override
  String toString() => displayText;
}
