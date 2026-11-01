// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui' as ui show Size;

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/plugin/pl_player/models/animated_capture.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:media_kit/ffi/src/allocation.dart';
import 'package:media_kit/ffi/src/utf8.dart';
import 'package:media_kit/generated/libmpv/bindings.dart' as generated;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit/src/player/native/core/initializer.dart';

class MpvAnimationExporter {
  MpvAnimationExporter(
    this.request,
    this.directory, {
    this.preset = WebpPreset.def,
  });
  final AnimatedCaptureRequest request;
  final Directory directory;
  final WebpPreset preset;
  final progress = 0.0.obs;
  final stage = '正在导出'.obs;
  _EncodeSession? _session;
  bool _cancelled = false;
  final _cancelSignal = Completer<void>();
  int? _rotation;
  ui.Size? _frameSize;
  late int _squarePixelWidth;
  late int _decodedHeight;
  void cancel() {
    _cancelled = true;
    if (!_cancelSignal.isCompleted) _cancelSignal.complete();
    _session?.cancel();
  }

  Future<void> _readOrientation() async {
    if (_cancelled) throw const CaptureCancelled();
    if (_frameSize != null) return;
    final probe = await Player.create(
      configuration: const PlayerConfiguration(
        vo: 'null',
        // This media-kit fork disables video until a VideoController attaches.
        // A headless probe has no controller, so it must enable decoding itself.
        options: {
          'vid': 'auto',
          'aid': 'no',
          'sid': 'no',
          'ao': 'null',
          'hwdec': 'no',
        },
      ),
    );
    final ready = Completer<void>();
    final paramsSubscription = probe.stream.videoParams.listen((params) {
      if (params.w != null && params.h != null && !ready.isCompleted) {
        ready.complete();
      }
    });
    final errorSubscription = probe.stream.error.listen((message) {
      if (!ready.isCompleted) {
        debugPrint('Animation probe: $message');
        ready.completeError(const CaptureException('无法读取视频帧，请重试或切换画质'));
      }
    });
    try {
      if (_cancelled) throw const CaptureCancelled();
      probe.setMediaHeader(
        userAgent: BrowserUa.pc,
        referer: HttpString.baseUrl,
      );
      await Future.wait<void>([
        probe.open(Media(request.url), play: false),
        Future.any<void>([
          ready.future,
          _cancelSignal.future.then<void>(
            (_) => throw const CaptureCancelled(),
          ),
        ]),
      ], eagerError: true).timeout(const Duration(seconds: 30));
      // videoParams describes VO output and may already have consumed rotation.
      // The encoding sessions apply the decoder's original rotation themselves.
      final rotation = int.tryParse(
        probe.getProperty('video-dec-params/rotate'),
      );
      if (rotation == null) {
        throw const CaptureException('无法读取视频方向，请重试');
      }
      final normalizedRotation = rotation % 360;
      if (![0, 90, 180, 270].contains(normalizedRotation)) {
        throw const CaptureException('暂不支持此视频的旋转角度');
      }
      final width = int.tryParse(probe.getProperty('video-dec-params/w'));
      final height = int.tryParse(probe.getProperty('video-dec-params/h'));
      // getProperty formats doubles to six decimal places. Read SAR directly
      // so fractions such as 1/3 cannot lose a pixel when width is truncated.
      final aspectName = 'video-dec-params/par'.toNativeUtf8();
      final aspectValue = calloc<Double>();
      late final double pixelAspect;
      try {
        final result = NativePlayer.mpv.mpv_get_property(
          probe.ctx,
          aspectName,
          generated.mpv_format.MPV_FORMAT_DOUBLE,
          aspectValue.cast(),
        );
        if (result < 0) throw const CaptureException('无法读取视频像素比例，请重试');
        pixelAspect = aspectValue.value;
      } finally {
        calloc
          ..free(aspectName)
          ..free(aspectValue);
      }
      if (width == null ||
          height == null ||
          width <= 0 ||
          height <= 0 ||
          !pixelAspect.isFinite ||
          pixelAspect <= 0 ||
          (width * pixelAspect).truncate() < 1) {
        throw const CaptureException('无法读取视频尺寸，请重试');
      }
      _rotation = normalizedRotation;
      _squarePixelWidth = (width * pixelAspect).truncate();
      _decodedHeight = height;
      _frameSize = normalizedRotation == 90 || normalizedRotation == 270
          ? ui.Size(height.toDouble(), _squarePixelWidth.toDouble())
          : ui.Size(_squarePixelWidth.toDouble(), height.toDouble());
    } on TimeoutException {
      throw const CaptureException('读取视频帧超时，请重试或切换画质');
    } finally {
      await paramsSubscription.cancel();
      await errorSubscription.cancel();
      await probe.dispose();
    }
  }

  // Explicitly orient before cropping. mpv's automatic rotation runs AFTER
  // user filters, which would otherwise crop a rotated preview incorrectly.
  String get geometry {
    final size = _frameSize;
    if (size == null) throw StateError('Video geometry has not been probed');
    if (!request.region.aspectRatio.fits(size)) {
      throw const CaptureException('画面尺寸不足以使用所选比例，请调整比例或画质');
    }
    final crop = request.region.pixels(size.width.toInt(), size.height.toInt());
    final rotate = switch (_rotation) {
      90 => 'transpose=clock,',
      180 => 'hflip,vflip,',
      270 => 'transpose=cclock,',
      _ => '',
    };
    return 'scale=$_squarePixelWidth:$_decodedHeight,setsar=1,$rotate'
        'crop=w=${crop.width.toInt()}:h=${crop.height.toInt()}:'
        'x=${crop.left.toInt()}:y=${crop.top.toInt()}:exact=1';
  }

  Future<void> _run(String output, Map<String, String> options) async {
    if (_cancelled) throw const CaptureCancelled();
    final session = _EncodeSession(
      request.url,
      output,
      options,
      onProgress: (time) => progress.value =
          ((time - request.start) / (request.end - request.start)).clamp(
            0.0,
            1.0,
          ),
    );
    _session = session;
    try {
      if (!await session.run()) {
        if (_cancelled) throw const CaptureCancelled();
        throw StateError('转码失败，请检查视频源及媒体库编码支持');
      }
    } finally {
      _session = null;
    }
    if (_cancelled) throw const CaptureCancelled();
    if (!File(output).existsSync() || await File(output).length() == 0) {
      throw StateError('转码未生成有效文件');
    }
  }

  Future<File> preview() async {
    await _readOrientation();
    final output = '${directory.path}/preview.png';
    await _run(output, {
      'start': request.start.toStringAsFixed(3),
      'frames': '1',
      'of': 'image2',
      'ovc': 'png',
      'ofopts': 'update=1',
      'vf': 'lavfi=[$geometry]',
    });
    return File(output);
  }

  Future<File> export() async {
    if (!request.start.isFinite ||
        !request.end.isFinite ||
        request.start < 0 ||
        request.end <= request.start) {
      throw ArgumentError('开始时间必须早于结束时间');
    }
    await _readOrientation();
    final output = '${directory.path}/capture.${request.format.extension}';
    final trim = 'trim=start=${request.start}:end=${request.end}';
    // Keep the source time base: mpv's accurate-seek filter must not discard
    // rebased output frames when the selected interval starts after zero.
    final base = '$trim,$geometry';
    final seek = {'start': request.start.toStringAsFixed(3), 'hr-seek': 'no'};
    if (request.format == AnimatedImageFormat.webp) {
      stage.value = '正在导出';
      await _run(output, {
        ...seek,
        'of': 'webp',
        'ovc': 'libwebp_anim',
        'ofopts': 'loop=0',
        'ovcopts': 'preset=${preset.flag}',
        'vf': 'lavfi=[$base]',
      });
    } else {
      stage.value = '分析颜色';
      final palette = '${directory.path}/palette.png';
      await _run(palette, {
        ...seek,
        'of': 'image2',
        'ovc': 'png',
        'ofopts': 'update=1',
        'vf': 'lavfi=[$base,fps=15,palettegen,setpts=${request.start}/TB]',
      });
      stage.value = '正在导出';
      progress.value = 0;
      // Escape both the filter option and graph delimiters for local paths.
      final escaped = palette
          .replaceAll(r'\', '/')
          .replaceAll(':', r'\:')
          .replaceAll("'", r"\'");
      await _run(output, {
        ...seek,
        'of': 'gif',
        'ovc': 'gif',
        'ofopts': 'loop=0',
        'vf':
            "lavfi=[$base,fps=15[v];movie=filename='$escaped'[p];[v][p]paletteuse]",
      });
    }
    progress.value = 1;
    return File(output);
  }
}

class CaptureException implements Exception {
  const CaptureException(this.message);
  final String message;
  @override
  String toString() => message;
}

class CaptureCancelled implements Exception {
  const CaptureCancelled();
}

class _EncodeSession {
  _EncodeSession(
    this.url,
    this.output,
    this.options, {
    required this.onProgress,
  });
  final String url;
  final String output;
  final Map<String, String> options;
  final ValueChanged<double> onProgress;
  final _mpv = NativePlayer.mpv;
  Pointer<generated.mpv_handle>? _ctx;
  final _done = Completer<bool>();
  bool _failed = false;
  bool _cancelled = false;

  Future<bool> run() async {
    try {
      final ctx = await Initializer.create(
        _mpv,
        _onEvent,
        options: {
          'idle': 'once',
          'o': output,
          'audio': 'no',
          'sub': 'no',
          'hwdec': 'no',
          'video-rotate': 'no',
          ...options,
        },
      );
      _ctx = ctx;
      if (_cancelled) {
        _dispose();
        return false;
      }
      NativePlayer.setHeader(
        _mpv,
        ctx,
        userAgent: BrowserUa.pc,
        referer: HttpString.baseUrl,
      );
      final name = 'time-pos'.toNativeUtf8();
      _mpv.mpv_observe_property(
        ctx,
        1,
        name,
        generated.mpv_format.MPV_FORMAT_DOUBLE,
      );
      calloc.free(name);
      final level = 'error'.toNativeUtf8();
      _mpv.mpv_request_log_messages(ctx, level);
      calloc.free(level);
      final args = ['loadfile', url].map((e) => e.toNativeUtf8()).toList();
      final pointers = calloc<Pointer<Uint8>>(args.length + 1);
      for (var i = 0; i < args.length; i++) {
        pointers[i] = args[i];
      }
      final result = _mpv.mpv_command(ctx, pointers);
      calloc.free(pointers);
      args.forEach(calloc.free);
      if (result < 0) {
        _failed = true;
        _dispose();
      }
      return await _done.future;
    } finally {
      _dispose();
    }
  }

  void cancel() {
    _cancelled = true;
    _dispose();
  }

  void _dispose() {
    final ctx = _ctx;
    _ctx = null;
    if (ctx != null) {
      Initializer.dispose(ctx);
      _mpv.mpv_terminate_destroy(ctx);
    }
    if (!_done.isCompleted) _done.complete(false);
  }

  Future<void>? _onEvent(Pointer<generated.mpv_event> event) {
    switch (event.ref.event_id) {
      case generated.mpv_event_id.MPV_EVENT_PROPERTY_CHANGE:
        final prop = event.ref.data.cast<generated.mpv_event_property>().ref;
        if (prop.format == generated.mpv_format.MPV_FORMAT_DOUBLE) {
          onProgress(prop.data.cast<Double>().value);
        }
        break;
      case generated.mpv_event_id.MPV_EVENT_LOG_MESSAGE:
        final log = event.ref.data.cast<generated.mpv_event_log_message>().ref;
        _failed = true;
        debugPrint('AnimationExport: ${log.text.toDartString()}');
        break;
      case generated.mpv_event_id.MPV_EVENT_END_FILE:
        final end = event.ref.data.cast<generated.mpv_event_end_file>().ref;
        if (end.error < 0) _failed = true;
        break;
      case generated.mpv_event_id.MPV_EVENT_SHUTDOWN:
        if (!_done.isCompleted) _done.complete(!_failed && !_cancelled);
        break;
    }
    return null;
  }
}

enum WebpPreset {
  none('none', '无', '不使用预设'),
  def('default', '默认', '默认预设'),
  picture('picture', '图片', '数码照片，如人像、室内拍摄'),
  photo('photo', '照片', '户外摄影，自然光环境'),
  drawing('drawing', '绘图', '手绘或线稿，高对比度细节'),
  icon('icon', '图标', '小型彩色图像'),
  text('text', '文本', '文字类');

  final String flag;
  final String name;
  final String desc;

  const WebpPreset(this.flag, this.name, this.desc);
}
