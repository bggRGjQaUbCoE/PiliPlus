// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:ffi';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart' show kDebugMode, visibleForTesting;
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:media_kit/ffi/src/allocation.dart';
import 'package:media_kit/ffi/src/utf8.dart';
import 'package:media_kit/generated/libmpv/bindings.dart' as generated;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit/src/player/native/core/initializer.dart';

typedef MpvHandle = Pointer<generated.mpv_handle>;
typedef MpvContextInitializer = Future<MpvHandle> Function();
typedef MpvContextDisposer = void Function(MpvHandle context);

class MpvConvertWebp {
  late final _mpv = NativePlayer.mpv;
  MpvHandle? _ctx;
  final _completer = Completer<bool>();

  @visibleForTesting
  final MpvContextInitializer? contextInitializer;

  @visibleForTesting
  final MpvContextDisposer? contextDisposer;

  bool _success = false;
  bool _disposeRequested = false;

  final String url;
  final String outFile;
  final double start;
  final double duration;
  final RxDouble? progress;
  final WebpPreset preset;

  MpvConvertWebp(
    this.url,
    this.outFile,
    this.start,
    double end, {
    this.progress,
    this.preset = WebpPreset.def,
    this.contextInitializer,
    this.contextDisposer,
  }) : duration = end - start;

  Future<MpvHandle> _createContext() async {
    final enableHA = Pref.enableHA;
    return await Initializer.create(
      _mpv,
      _onEvent,
      options: {
        'o': outFile,
        'start': start.toStringAsFixed(3),
        'end': (start + duration).toStringAsFixed(3),
        'of': 'webp',
        'ovc': 'libwebp_anim',
        'ofopts': 'loop=0',
        'ovcopts': 'preset=${preset.flag}',
        if (enableHA) 'vo': 'gpu',
        if (enableHA)
          'hwdec':
              '${Pref.hardwareDecoding},auto-copy', // transcode only support copy
      },
    );
  }

  Future<bool> _init() async {
    final ctx = await (contextInitializer?.call() ?? _createContext());
    if (_disposeRequested) {
      _disposeContext(ctx);
      return false;
    }
    _ctx = ctx;
    NativePlayer.setHeader(
      _mpv,
      ctx,
      userAgent: BrowserUa.pc,
      referer: HttpString.baseUrl,
    );
    if (progress != null) {
      _observeProperty('time-pos');
    }
    final level = (kDebugMode ? 'info' : 'error').toNativeUtf8();
    _mpv.mpv_request_log_messages(ctx, level);
    calloc.free(level);
    return true;
  }

  void _disposeContext(MpvHandle ctx) {
    if (contextDisposer case final dispose?) {
      dispose(ctx);
    } else {
      Initializer.dispose(ctx);
      _mpv.mpv_terminate_destroy(ctx);
    }
  }

  void dispose() {
    if (_disposeRequested) return;
    _disposeRequested = true;
    if (!_completer.isCompleted) _completer.complete(false);
    if (_ctx case final ctx?) {
      _ctx = null;
      _disposeContext(ctx);
    }
  }

  Future<bool> convert() async {
    try {
      if (await _init() && !_disposeRequested) {
        _command(['loadfile', url]);
      }
    } catch (error) {
      if (kDebugMode) debugPrint('WebpConvert init error: $error');
      dispose();
    }
    return _completer.future;
  }

  Future<void>? _onEvent(Pointer<generated.mpv_event> event) {
    switch (event.ref.event_id) {
      case generated.mpv_event_id.MPV_EVENT_PROPERTY_CHANGE:
        final prop = event.ref.data.cast<generated.mpv_event_property>().ref;
        if (prop.name.toDartString() == 'time-pos' &&
            prop.format == generated.mpv_format.MPV_FORMAT_DOUBLE) {
          progress!.value = (prop.data.cast<Double>().value - start) / duration;
        }
        break;
      case generated.mpv_event_id.MPV_EVENT_FILE_LOADED:
        _success = true;
        break;
      case generated.mpv_event_id.MPV_EVENT_LOG_MESSAGE:
        final log = event.ref.data.cast<generated.mpv_event_log_message>().ref;
        final prefix = log.prefix.toDartString().trim();
        final level = log.level.toDartString().trim();
        final text = log.text.toDartString().trim();
        debugPrint('WebpConvert: $level $prefix : $text');
        if (kDebugMode) {
          if (level == 'error' || level == 'fatal') _success = false;
        } else {
          _success = false;
        }
        break;
      case generated.mpv_event_id.MPV_EVENT_END_FILE ||
          generated.mpv_event_id.MPV_EVENT_SHUTDOWN:
        progress?.value = 1;
        if (!_completer.isCompleted) _completer.complete(_success);
        dispose();
        break;
    }
    return null;
  }

  void _command(List<String> args) {
    final ctx = _ctx;
    if (ctx == null) return;
    final pointers = args.map((e) => e.toNativeUtf8()).toList();
    final arr = calloc<Pointer<Uint8>>(pointers.length + 1);
    for (int i = 0; i < args.length; i++) {
      arr[i] = pointers[i];
    }

    _mpv.mpv_command(ctx, arr);

    calloc.free(arr);
    pointers.forEach(calloc.free);
  }

  void _observeProperty(String property) {
    final ctx = _ctx;
    if (ctx == null) return;
    final name = property.toNativeUtf8();
    _mpv.mpv_observe_property(
      ctx,
      property.hashCode,
      name,
      generated.mpv_format.MPV_FORMAT_DOUBLE,
    );

    calloc.free(name);
  }
}

enum WebpPreset {
  none('none', '无', '不使用预设'),
  def('default', '默认', '默认预设'),
  picture('picture', '图片', '数码照片，如人像、室内拍摄'),
  photo('photo', '照片', '户外摄影，自然光环境'),
  drawing('drawing', '绘图', '手绘或线稿，高对比度细节'),
  icon('icon', '图标', '小型彩色图像'),
  text('text', '文本', '文字类'),
  ;

  final String flag;
  final String name;
  final String desc;

  const WebpPreset(this.flag, this.name, this.desc);
}
