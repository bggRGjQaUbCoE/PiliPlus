import 'package:PiliPlus/plugin/pl_player/models/hdr_playback.dart';

/// 解码后的色彩参数，取自 mpv 的 `video-params`
class HdrVideoParams {
  /// 传递函数，例如 pq / hlg / bt.1886
  final String? gamma;

  /// 原始色域，例如 bt.2020 / bt.709
  final String? primaries;

  /// 片源信号峰值
  final double? sigPeak;

  const HdrVideoParams({this.gamma, this.primaries, this.sigPeak});

  bool get isEmpty => gamma == null && primaries == null && sigPeak == null;
}

/// HDR 与 SDR 的输出策略
///
/// 现有渲染链路都是 8 位 SDR 纹理：
/// - Android 经 `SurfaceTexture` 输出
/// - Windows 经 ANGLE 的 `DXGI_FORMAT_B8G8R8A8_UNORM` 纹理输出
/// - Linux 经 `GL_RGBA` / `GL_UNSIGNED_BYTE` 纹理输出
/// - iOS 与 macOS 经 8 位纹理输出
///
/// 因此 HDR 片源统一做色调映射后按 SDR 输出。
/// 若后续接入可直通的渲染链路，只需让 [rendererSupportsHdr] 返回 true，
/// 其余判定与状态展示无需改动。
class HdrPolicy {
  const HdrPolicy._();

  /// 色彩相关参数
  ///
  /// 必须在播放器初始化之后写入：media-kit 会在 `mpv_initialize` 之后
  /// 写入 `hdr-compute-peak=no` 等默认值，覆盖创建播放器时传入的选项。
  static const Map<String, String> videoColorOptions = {
    // 8 位 SDR 纹理链路不向系统输出 HDR 信号
    'target-colorspace-hint': 'no',
    // 纹理按 sRGB 采样
    'target-trc': 'srgb',
    'target-prim': 'bt.709',
    // 恢复 mpv 的自动峰值检测，改善 HDR 到 SDR 的色调映射
    'hdr-compute-peak': 'auto',
  };

  /// 当前渲染链路是否支持原生 HDR 输出
  static bool get rendererSupportsHdr => false;

  /// 传递函数为 HDR 的判断，返回 null 表示无法确定
  static VideoDynamicRange? classifyTransfer(String? gamma, double? sigPeak) {
    if (gamma != null && gamma.isNotEmpty) {
      switch (gamma) {
        case 'pq':
        case 'st2084':
        case 'smpte2084':
          return VideoDynamicRange.hdr10;
        case 'hlg':
        case 'arib-std-b67':
          return VideoDynamicRange.hlg;
      }
      if (gamma.startsWith('gamma') ||
          gamma == 'bt.1886' ||
          gamma == 'srgb' ||
          gamma == 'linear' ||
          gamma == 'bt.709') {
        return VideoDynamicRange.sdr;
      }
    }
    // 传递函数未知时用信号峰值辅助判断，不以位深或色域单独判定 HDR
    if (sigPeak != null && sigPeak > 1.2) {
      return VideoDynamicRange.hdr10;
    }
    return null;
  }

  /// 结合片源标记与解码结果，确定片源类型与实际输出
  static HdrPlaybackInfo resolve({
    HdrVideoParams? decoded,
    HdrSourceFormat hint = HdrSourceFormat.none,
    bool optionUnsupported = false,
  }) {
    final transfer = classifyTransfer(decoded?.gamma, decoded?.sigPeak);

    final VideoDynamicRange source;
    if (hint == HdrSourceFormat.dolbyVision) {
      source = VideoDynamicRange.dolbyVision;
    } else if (hint == HdrSourceFormat.hdrVivid) {
      source = VideoDynamicRange.hdrVivid;
    } else if (transfer != null) {
      source = transfer;
    } else if (hint.isHdr) {
      source = VideoDynamicRange.hdr10;
    } else {
      source = VideoDynamicRange.unknown;
    }

    if (!source.isHdr) {
      return HdrPlaybackInfo(source: source);
    }

    if (rendererSupportsHdr && !optionUnsupported) {
      return HdrPlaybackInfo(source: source, output: HdrOutputMode.hdr);
    }

    final HdrFallbackReason reason;
    if (hint.isHdr && transfer == VideoDynamicRange.sdr) {
      // 片源标记为 HDR，但解码结果是 SDR，说明 HDR 层没有被应用
      reason = HdrFallbackReason.hdrLayerUnsupported;
    } else if (optionUnsupported) {
      reason = HdrFallbackReason.paramUnsupported;
    } else {
      reason = HdrFallbackReason.rendererSdr;
    }
    return HdrPlaybackInfo(
      source: source,
      output: HdrOutputMode.sdr,
      reason: reason,
    );
  }
}

/// 跟踪一次播放会话的 HDR 状态
///
/// 负责换源时重置状态，以及片源从 HDR 切换到 SDR 时重新判定。
class HdrPlaybackTracker {
  HdrSourceFormat _hint = HdrSourceFormat.none;
  HdrPlaybackInfo _info = HdrPlaybackInfo.unknown;

  /// 当前片源格式标记
  HdrSourceFormat get hint => _hint;

  /// 当前 HDR 状态
  HdrPlaybackInfo get info => _info;

  /// 换源时重置，画质标记先于解码参数生效
  HdrPlaybackInfo reset(
    HdrSourceFormat hint, {
    bool optionUnsupported = false,
  }) {
    _hint = hint;
    _info = HdrPolicy.resolve(
      hint: hint,
      optionUnsupported: optionUnsupported,
    );
    return _info;
  }

  /// 解码参数到达时更新，返回状态是否发生变化
  bool update(HdrVideoParams? decoded, {bool optionUnsupported = false}) {
    final next = HdrPolicy.resolve(
      decoded: decoded,
      hint: _hint,
      optionUnsupported: optionUnsupported,
    );
    if (next == _info) {
      return false;
    }
    _info = next;
    return true;
  }
}
