import 'dart:async';
import 'dart:ffi';

import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:media_kit/ffi/src/allocation.dart';
import 'package:media_kit/ffi/src/utf8.dart';
import 'package:media_kit/generated/libmpv/bindings.dart' as generated;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit/src/player/native/core/initializer.dart';
import 'package:media_kit/src/player/native/core/native_library.dart';

class MpvConvertWebp {
  final _mpv = generated.MPV(DynamicLibrary.open(NativeLibrary.path));
  late final Pointer<generated.mpv_handle> _ctx;
  final _completer = Completer<bool>();

  bool _success = false;

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
  }) : duration = end - start;

  Future<void> _init() async {
    final enableHA = Pref.enableHA;
    _ctx = await Initializer.create(
      NativeLibrary.path,
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
    NativePlayer.setHeader(
      const {
        'user-agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
        'referer': HttpString.baseUrl,
      },
      _mpv,
      _ctx,
    );
    if (progress != null) {
      _observeProperty('time-pos');
    }
    final level = (kDebugMode ? 'info' : 'error').toNativeUtf8();
    _mpv.mpv_request_log_messages(_ctx, level.cast());
    calloc.free(level);
  }

  void dispose() {
    Initializer.dispose(_ctx);
    _mpv.mpv_terminate_destroy(_ctx);
    if (!_completer.isCompleted) _completer.complete(false);
  }

  Future<bool> convert() async {
    await _init();
    _command(['loadfile', url]);
    return _completer.future;
  }

  Future<void> _onEvent(Pointer<generated.mpv_event> event) async {
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
          _success = level != 'error' && level != 'fatal';
        } else {
          _success = false;
        }
        break;
      case generated.mpv_event_id.MPV_EVENT_END_FILE ||
          generated.mpv_event_id.MPV_EVENT_SHUTDOWN:
        progress?.value = 1;
        _completer.complete(_success);
        dispose();
        break;
    }
  }

  void _command(List<String> args) =>
      NativePlayer.statiCommand(args, _mpv, _ctx);

  void _observeProperty(String property) {
    final name = property.toNativeUtf8();
    _mpv.mpv_observe_property(
      _ctx,
      property.hashCode,
      name.cast(),
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
  text('text', '文本', '文字类');

  final String flag;
  final String name;
  final String desc;

  const WebpPreset(this.flag, this.name, this.desc);
}
