import 'dart:async';
import 'dart:io' show Platform;

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/playback_diag_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart'
    show
        HdrDecoderObservation,
        HdrOutputReport,
        PlaybackColorValues,
        PlaybackColorSampler,
        PlaybackColorSnapshot;

import 'package:PiliPlus/plugin/pl_player/widgets/playback_diag_sampler.dart';

String? formatPlaybackColorLine(PlaybackColorSnapshot? snapshot) {
  if (snapshot == null) return null;
  String? values(
    String label,
    PlaybackColorValues color, {
    bool source = false,
  }) {
    final primaries = color.primaries;
    final transfer = color.transfer;
    final range = color.range;
    final hasCore = [primaries, transfer, range].any(
      (value) => value?.isNotEmpty ?? false,
    );
    final parts = <String>[];
    if (hasCore) {
      if (primaries?.isNotEmpty == true &&
          transfer?.isNotEmpty == true &&
          range?.isNotEmpty == true) {
        parts.add('$label=$primaries/$transfer/$range');
      } else {
        final fields = <String>[
          if (primaries?.isNotEmpty ?? false) '色域=$primaries',
          if (transfer?.isNotEmpty ?? false) '传递=$transfer',
          if (range?.isNotEmpty ?? false) '范围=$range',
        ];
        parts.add('$label ${fields.join(' ')}');
      }
    }
    if (color.matrix?.isNotEmpty ?? false) {
      final matrixLabel = !hasCore
          ? source
                ? '片源矩阵'
                : '输出目标矩阵'
          : '矩阵';
      parts.add('$matrixLabel=${color.matrix}');
    }
    return parts.isEmpty ? null : parts.join(' ');
  }

  final parts = <String?>[
    values('片源', snapshot.source, source: true),
    if (snapshot.decoderPassthrough)
      '输出=解码直通'
    else
      values('输出目标', snapshot.outputTarget),
  ].whereType<String>().where((part) => part.isNotEmpty);
  final line = parts.join(' ');
  return line.isEmpty ? null : line;
}

/// 播放诊断信息，默认关闭，由设置开关控制。
class PlaybackDiagBar extends StatefulWidget {
  const PlaybackDiagBar({
    super.key,
    required this.controller,
    this.viewportKey,
  });

  final PlPlayerController controller;
  final GlobalKey? viewportKey;

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
  StreamSubscription<bool>? _playingSub;
  StreamSubscription<Playlist>? _playlistSub;
  static const _renderingChannel = MethodChannel(
    'com.example.piliplus/rendering',
  );
  final Future<String> _rootViewType = _readRootViewType();
  Player? _subscribedPlayer;
  int _decoderRequest = 0;
  PlaybackMetricSampler? _metricSampler;
  Player? _metricPlayer;
  String? _metricSourceKey;
  PlaybackMetricSnapshot? _metricSample;
  PlaybackColorSampler? _colorSampler;
  Player? _colorPlayer;
  String? _colorSourceKey;
  PlaybackColorSnapshot? _colorSample;

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
    _playingSub?.cancel();
    _playlistSub?.cancel();
    _metricSampler?.dispose();
    _colorSampler?.dispose();
    super.dispose();
  }

  static Future<String> _readRootViewType() async {
    if (!Platform.isAndroid) return 'n/a';
    try {
      return await _renderingChannel.invokeMethod<String>('rootViewType') ??
          'unknown';
    } on PlatformException catch (_) {
      return 'unknown';
    } on MissingPluginException catch (_) {
      return 'unknown';
    }
  }

  void _subscribe() {
    _tracksSub?.cancel();
    _videoParamsSub?.cancel();
    _playingSub?.cancel();
    _playlistSub?.cancel();
    final player = widget.controller.videoPlayerController;
    _subscribedPlayer = player;
    if (player == null) return;
    _fetchDecoder(player);
    _tracksSub = player.stream.tracks.listen((_) {
      _fetchDecoder(player);
      if (mounted) setState(() {});
    });
    _videoParamsSub = player.stream.videoParams.listen((_) {
      if (mounted) setState(() {});
    });
    _playingSub = player.stream.playing.listen((_) {
      if (mounted) setState(() {});
    });
    _playlistSub = player.stream.playlist.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant PlaybackDiagBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(
      widget.controller.videoPlayerController,
      _subscribedPlayer,
    )) {
      _asyncDecoder = '';
      _subscribe();
    }
  }

  Future<void> _fetchDecoder(Player player) async {
    final request = ++_decoderRequest;
    try {
      final value = await player.getPropertyAsync(
        'current-tracks/video/decoder',
      );
      if (mounted &&
          request == _decoderRequest &&
          identical(player, _subscribedPlayer) &&
          value != _asyncDecoder) {
        setState(() => _asyncDecoder = value);
      }
    } catch (_) {
      if (mounted &&
          request == _decoderRequest &&
          identical(player, _subscribedPlayer) &&
          _asyncDecoder.isNotEmpty) {
        setState(() => _asyncDecoder = '');
      }
    }
  }

  /// 收集非空段拼接，避免判空逻辑散落。
  String _join(Iterable<String?> parts) =>
      parts.whereType<String>().where((part) => part.isNotEmpty).join(' ');

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
        '${actual.strategy.name}/${actual.outputTransfer.name}',
        '输出=${actual.topology.name}',
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
    final readback = report.dataSpaceRequested == null
        ? null
        : 'dsRead=${report.dataSpaceReadback ?? "?"}';
    final peak = actual?.targetPeak == null
        ? null
        : '映射峰值=${actual!.targetPeak}';
    final error = actual != null && report.error != null
        ? 'error:${_truncate(report.error)}'
        : null;
    return _join([line, readback, peak, error]);
  }

  String? _dataSpaceSegment(String? path) {
    if (path == null || path.isEmpty || path == 'none') return null;
    return 'dsPath=$path';
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
    final fps = _formatFps(player?.state.track.video.fps);
    final dimension = _dimension(player);
    return _join([
      decoder ?? '-',
      if (hwdecName != null && hwdecName != decoder) 'hwdec=$hwdecName',
      _trackCodec(player),
      if (dimension != null) '$dimension${fps == null ? '' : ' srcFps=$fps'}',
      _pixelFormat(player, observation),
    ]);
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
      if (dimension != null) '$dimension${fps == null ? '' : ' srcFps=$fps'}',
      _pixelFormat(player, null),
    ]);
  }

  String? _colorLine(PlaybackColorSnapshot? snapshot) {
    return formatPlaybackColorLine(snapshot);
  }

  String _sourceKey(Player? player, int? generation) {
    final state = player?.state;
    final playlist = state?.playlist;
    final index = playlist?.index ?? -1;
    final uri = playlist == null || index < 0 || index >= playlist.medias.length
        ? ''
        : playlist.medias[index].uri;
    return '$generation|$index|$uri';
  }

  void _syncMetricSampler({
    required Player? player,
    required String sourceKey,
    required bool enabled,
  }) {
    if (!identical(player, _metricPlayer)) {
      _metricSampler?.dispose();
      _metricSampler = null;
      _metricPlayer = player;
      _metricSample = null;
    }
    if (sourceKey != _metricSourceKey) {
      _metricSampler?.stop();
      _metricSourceKey = sourceKey;
      _metricSample = null;
    }
    if (player == null) return;
    if (_metricSampler == null) {
      late PlaybackMetricSampler sampler;
      sampler = PlaybackMetricSampler(
        readProperty: (property) => player.getPropertyAsync(
          property,
          waitForInitialization: false,
        ),
        onSample: (sample) {
          if (mounted && identical(_metricSampler, sampler)) {
            setState(() => _metricSample = sample);
          }
        },
      );
      _metricSampler = sampler;
    }
    final sampler = _metricSampler!;
    if (!enabled) {
      sampler.stop();
      _metricSample = null;
      return;
    }
    if (!player.state.playing) {
      sampler.stop();
      _metricSample =
          (_metricSample ?? PlaybackMetricSnapshot.unknown(paused: true))
              .copyWith(paused: true);
      return;
    }
    sampler
      ..setPaused(false)
      ..start(paused: false);
  }

  void _syncColorSampler({
    required Player? player,
    required String sourceKey,
    required bool enabled,
  }) {
    if (!identical(player, _colorPlayer)) {
      _colorSampler?.dispose();
      _colorSampler = null;
      _colorPlayer = player;
      _colorSample = null;
    }
    final identity = '${player?.platform?.fileLoadedEpoch ?? -1}|$sourceKey';
    if (identity != _colorSourceKey) {
      _colorSampler?.stop();
      _colorSourceKey = identity;
      _colorSample = null;
    }
    if (player == null) return;
    if (_colorSampler == null) {
      late PlaybackColorSampler sampler;
      sampler = PlaybackColorSampler(
        readProperty: (property) => player.getPropertyAsync(
          property,
          waitForInitialization: false,
        ),
        sourceIdentity: () =>
            '${player.platform?.fileLoadedEpoch ?? -1}|$_colorSourceKey',
        onSample: (sample) {
          if (mounted && identical(_colorSampler, sampler)) {
            setState(() => _colorSample = sample);
          }
        },
      );
      _colorSampler = sampler;
    }
    final sampler = _colorSampler!;
    if (!enabled) {
      sampler.stop();
      return;
    }
    // Color is static for a loaded source, so retain the last good sample
    // while paused but avoid polling the player until playback resumes.
    if (!player.state.playing) {
      sampler.stop();
      return;
    }
    sampler.start();
  }

  // ---- 构建 ----

  Widget _buildLines({
    required String routeLine,
    required String decodeLine,
    required String? colorLine,
    required String? performanceLine,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<String>(
          future: _rootViewType,
          builder: (_, snapshot) => Text(
            '界面: ${snapshot.data ?? "…"}',
            style: _line2Style,
          ),
        ),
        Text(routeLine, style: _line1Style, softWrap: true),
        Text(decodeLine, style: _line2Style, softWrap: true),
        if (colorLine != null)
          Text(colorLine, style: _line2Style, softWrap: true),
        Text(
          performanceLine ??
              PlaybackMetricSnapshot.unknown(
                paused:
                    !(widget.controller.videoPlayerController?.state.playing ??
                        false),
              ).displayText,
          style: _line2Style,
          softWrap: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = widget.controller;
      final currentPlayer = controller.videoPlayerController;
      if (!identical(currentPlayer, _subscribedPlayer)) {
        _asyncDecoder = '';
        _subscribe();
      }
      // 读取控制栏显隐作为响应触发源：控制栏任何显隐都 rebuild。
      final controlsVisible = controller.showControls.value;
      final player = currentPlayer;
      final playback = controller.playback;
      _syncMetricSampler(
        player: player,
        sourceKey: _sourceKey(player, playback?.report.value.generation),
        enabled:
            Pref.showPlaybackDiagBar &&
            controlsVisible &&
            controller.videoController != null,
      );
      final sourceKey = _sourceKey(player, playback?.report.value.generation);
      final diagEnabled =
          Pref.showPlaybackDiagBar &&
          controlsVisible &&
          controller.videoController != null;
      _syncColorSampler(
        player: player,
        sourceKey: sourceKey,
        enabled: diagEnabled,
      );
      if (!Pref.showPlaybackDiagBar) {
        return const SizedBox.shrink();
      }
      final Widget content;
      if (playback != null) {
        content = ValueListenableBuilder<HdrOutputReport>(
          valueListenable: playback.report,
          builder: (_, report, _) {
            _syncMetricSampler(
              player: player,
              sourceKey: _sourceKey(player, report.generation),
              enabled:
                  Pref.showPlaybackDiagBar &&
                  controlsVisible &&
                  controller.videoController != null,
            );
            _syncColorSampler(
              player: player,
              sourceKey: _sourceKey(player, report.generation),
              enabled:
                  Pref.showPlaybackDiagBar &&
                  controlsVisible &&
                  controller.videoController != null,
            );
            return _buildLines(
              routeLine: _routeLine(report),
              decodeLine: _decodeLine(report, player),
              colorLine: _colorLine(_colorSample),
              performanceLine: _metricSample?.displayText,
            );
          },
        );
      } else if (controller.videoController != null) {
        content = _buildLines(
          routeLine: _legacyRouteLine(player),
          decodeLine: _legacyDecodeLine(player),
          colorLine: _colorLine(_colorSample),
          performanceLine: _metricSample?.displayText,
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
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (widget.controller.showControls.value &&
                  (notification is ScrollUpdateNotification ||
                      notification is OverscrollNotification ||
                      notification is ScrollEndNotification)) {
                widget.controller.hideTaskControls();
              }
              return false;
            },
            child: PlaybackDiagScrollView(
              viewportKey: widget.viewportKey,
              child: content,
            ),
          ),
        ),
      );
    });
  }
}
