import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart'
    show HdrDecoderObservation, HdrOutputReport;

/// 播放诊断信息行：控制栏内的两行紧凑事实——行1 实际路由（媒体类型、
/// 策略/呈现/输出转移、拓扑、vo、dataspace 路径、降级/错误/验证状态），
/// 行2 实际解码器与流事实（解码器组件名、hwdec 传输模式、编码、
/// 分辨率/帧率、像素格式）。默认关闭，由设置开关控制。
class PlaybackDiagBar extends StatefulWidget {
  const PlaybackDiagBar({super.key, required this.controller});

  final PlPlayerController controller;

  @override
  State<PlaybackDiagBar> createState() => _PlaybackDiagBarState();
}

class _PlaybackDiagBarState extends State<PlaybackDiagBar> {
  static const _line1Style = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static const _line2Style = TextStyle(
    fontSize: 10,
    color: Colors.white70,
  );

  StreamSubscription<Tracks>? _tracksSub;
  StreamSubscription<VideoParams>? _videoParamsSub;

  /// 异步缓存的 `current-tracks/video/decoder`：legacy 分支没有
  /// decoderObservation，用它兜底显示 mpv 当前视频轨解码器名。
  String _asyncDecoder = '';

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void dispose() {
    _tracksSub?.cancel();
    _videoParamsSub?.cancel();
    super.dispose();
  }

  void _subscribe() {
    final player = widget.controller.videoPlayerController;
    if (player == null) return;
    _tracksSub = player.stream.tracks.listen((_) {
      _fetchDecoder();
      if (mounted) setState(() {});
    });
    _videoParamsSub = player.stream.videoParams.listen((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _fetchDecoder() async {
    final player = widget.controller.videoPlayerController;
    if (player == null) return;
    try {
      final value = await player.getPropertyAsync(
        'current-tracks/video/decoder',
      );
      if (mounted && value != _asyncDecoder) {
        setState(() => _asyncDecoder = value);
      }
    } catch (_) {
      // 读取失败按解码器未知处理。
    }
  }

  /// 收集非空段拼接，避免判空逻辑散落。
  String _join(Iterable<String?> parts) => parts
      .whereType<String>()
      .where((part) => part.isNotEmpty)
      .join(' ');

  String? _firstNonEmpty(Iterable<String?> values) {
    for (final value in values) {
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  // ---- 行1：路由事实 ----

  String _routeLine(HdrOutputReport report) {
    final actual = report.actual;
    String line;
    if (actual != null) {
      line = _join([
        // 媒体类型（如 hdr10/dolbyVisionP5/sdr），来源未知时省略。
        report.sourceFacts?.source.kind.name,
        '${actual.strategy.name}/${actual.presentation.name}/'
            '${actual.outputTransfer.name}',
        actual.topology.name,
        if (actual.vo.isNotEmpty) 'vo=${actual.vo}',
        _dataSpaceSegment(report.dataSpacePath),
        // 实际执行的路由本身是降级产物时，标出降级原因。
        if (report.degradeReason != null)
          'degraded:${report.degradeReason!.name}',
      ]);
    } else if (report.degradeReason != null) {
      line = 'degraded:${report.degradeReason!.name}';
    } else if (report.error != null) {
      line = 'route-error:${_truncate(report.error)}';
    } else {
      line = 'route:pending';
    }
    return report.verified ? '$line ✓' : line;
  }

  String? _dataSpaceSegment(String? path) {
    if (path == null || path.isEmpty || path == 'none') return null;
    return 'ds=$path';
  }

  String _truncate(Object? error) {
    final text = error.toString().replaceAll('\n', ' ').trim();
    return text.length > 40 ? text.substring(0, 40) : text;
  }

  // ---- 行2：解码事实 ----

  String _decodeLine(HdrOutputReport report, Player? player) {
    final observation = report.decoderObservation;
    final decoder = _firstNonEmpty([
      observation?.decoderDescription,
      observation?.decoder,
      report.hwdecCurrent,
    ]);
    final hwdecName = _firstNonEmpty([observation?.hwdec, report.hwdecCurrent]);
    // 传输模式（mediacodec/mediacodec-copy/no）：与解码器段相同（解码器
    // 三级回退落到 hwdec 值本身）时不重复显示。
    final transport = hwdecName != null && hwdecName != decoder
        ? 'hwdec=$hwdecName'
        : null;
    // mediacodec-hevc 这类 hwdec 值已含编码名时不重复显示轨编码。
    final codecInHwdec =
        hwdecName != null && hwdecName != 'no' && _hwdecCarriesCodec(hwdecName);
    final fps = _formatFps(player?.state.track.video.fps);
    final dimension = _dimension(player);
    return _join([
      decoder ?? '-',
      transport,
      if (!codecInHwdec) _trackCodec(player),
      if (dimension != null)
        '$dimension${fps == null ? '' : '@$fps'}',
      _pixelFormat(player, observation),
    ]);
  }

  /// mediacodec-hevc / mediacodec-copy-h264 值本身带编码名；
  /// mediacodec、mediacodec-copy、surfacetexture 只是解码族名。
  bool _hwdecCarriesCodec(String hwdec) {
    const families = ['mediacodec-copy', 'mediacodec', 'surfacetexture'];
    var rest = hwdec;
    for (final family in families) {
      if (rest == family) return false;
      if (rest.startsWith('$family-')) {
        rest = rest.substring(family.length + 1);
        break;
      }
    }
    return rest.isNotEmpty && rest != 'no';
  }

  String? _trackCodec(Player? player) {
    final codec = player?.state.track.video.codec;
    return codec == null || codec.isEmpty ? null : codec;
  }

  String? _dimension(Player? player) {
    final state = player?.state;
    final width = state?.videoWidth ?? state?.videoParams.w;
    final height = state?.videoHeight ?? state?.videoParams.h;
    if (width == null || height == null) return null;
    return '${width}x$height';
  }

  String? _formatFps(double? fps) {
    if (fps == null || fps <= 0) return null;
    return fps % 1 == 0 ? fps.toInt().toString() : fps.toString();
  }

  /// 像素格式去重：软解或 hwPixelFormat 缺失时用 pixelFormat；硬解且两者
  /// 不同时显示 `pixel/hw`，相同只显示一次。无 observation 时回退 videoParams。
  String? _pixelFormat(Player? player, HdrDecoderObservation? observation) {
    if (observation != null) {
      if (observation.softwareDecoded || observation.hwPixelFormat.isEmpty) {
        return observation.pixelFormat.isEmpty ? null : observation.pixelFormat;
      }
      if (observation.pixelFormat.isEmpty ||
          observation.pixelFormat == observation.hwPixelFormat) {
        return observation.hwPixelFormat;
      }
      return '${observation.pixelFormat}/${observation.hwPixelFormat}';
    }
    final params = player?.state.videoParams;
    final pf = params?.pixelformat;
    final hw = params?.hwPixelformat;
    final pfText = pf == null || pf.isEmpty ? null : pf;
    final hwText = hw == null || hw.isEmpty ? null : hw;
    if (pfText == null) return hwText;
    if (hwText == null || hwText == pfText) return pfText;
    return '$pfText/$hwText';
  }

  // ---- legacy 分支（无 RoutedVideoPlayback）----

  /// 同步快照仅用于展示，异常按未知处理。
  String _legacyRouteLine(Player? player) {
    String hwdec = '';
    try {
      hwdec = player?.getProperty('hwdec-current') ?? '';
    } catch (_) {}
    final value = switch (hwdec) {
      '' => '-',
      'no' => 'sw',
      _ => hwdec,
    };
    return 'legacy hwdec=$value';
  }

  String _legacyDecodeLine(Player? player) {
    final fps = _formatFps(player?.state.track.video.fps);
    final dimension = _dimension(player);
    return _join([
      _asyncDecoder.isNotEmpty ? _asyncDecoder : '-',
      _trackCodec(player),
      if (dimension != null)
        '$dimension${fps == null ? '' : '@$fps'}',
      _pixelFormat(player, null),
    ]);
  }

  // ---- 构建 ----

  Widget _buildLines({
    required String routeLine,
    required String decodeLine,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          routeLine,
          style: _line1Style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          decodeLine,
          style: _line2Style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = widget.controller;
      // 读取控制栏显隐作为响应触发源：控制栏任何显隐都 rebuild，从而重读 Pref
      controller.showControls.value;
      if (!Pref.showPlaybackDiagBar) {
        return const SizedBox.shrink();
      }
      final player = controller.videoPlayerController;
      final playback = controller.playback;
      final Widget content;
      if (playback != null) {
        content = ValueListenableBuilder<HdrOutputReport>(
          valueListenable: playback.report,
          builder: (_, report, _) => _buildLines(
            routeLine: _routeLine(report),
            decodeLine: _decodeLine(report, player),
          ),
        );
      } else if (controller.videoController != null) {
        content = _buildLines(
          routeLine: _legacyRouteLine(player),
          decodeLine: _legacyDecodeLine(player),
        );
      } else {
        content = const Text(
          'idle',
          style: _line1Style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0x66000000),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: content,
        ),
      );
    });
  }
}
