// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:ffi';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get_rx/get_rx.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/ffi/src/allocation.dart';
import 'package:media_kit/ffi/src/utf8.dart';
import 'package:media_kit/generated/libmpv/bindings.dart' as generated;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit/src/player/native/core/initializer.dart';

class MpvConvertWebp {
  final _mpv = NativePlayer.mpv;
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
      _mpv,
      _onEvent,
      options: {
        'idle': 'once',
        'o': outFile,
        'start': start.toStringAsFixed(3),
        'end': (start + duration).toStringAsFixed(3),
        'of': 'webp',
        'ovc': 'libwebp_anim',
        'ofopts': 'loop=0',
        'ovcopts': 'preset=${preset.flag}',
        if (enableHA) 'vo': 'gpu',
        if (enableHA) 'hwdec': '${Pref.hardwareDecoding},auto-copy', // transcode only support copy
      },
    );
    _mpv.mpv_request_event(
      _ctx,
      generated.mpv_event_id.MPV_EVENT_VIDEO_RECONFIG,
      0,
    );
    NativePlayer.setHeader(
      _mpv,
      _ctx,
      userAgent: BrowserUa.pc,
      referer: HttpString.baseUrl,
    );
    if (progress != null) {
      _observeProperty('time-pos');
    }
    final level = (kDebugMode ? 'info' : 'error').toNativeUtf8();
    _mpv.mpv_request_log_messages(_ctx, level);
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
      case generated.mpv_event_id.MPV_EVENT_SHUTDOWN:
        progress?.value = 1;
        _completer.complete(_success);
        dispose();
        break;
    }
    return null;
  }

  void _command(List<String> args) {
    final pointers = args.map((e) => e.toNativeUtf8()).toList();
    final arr = calloc<Pointer<Uint8>>(pointers.length + 1);
    for (int i = 0; i < args.length; i++) {
      arr[i] = pointers[i];
    }

    _mpv.mpv_command(_ctx, arr);

    calloc.free(arr);
    pointers.forEach(calloc.free);
  }

  void _observeProperty(String property) {
    final name = property.toNativeUtf8();
    _mpv.mpv_observe_property(
      _ctx,
      property.hashCode,
      name,
      generated.mpv_format.MPV_FORMAT_DOUBLE,
    );

    calloc.free(name);
  }
}

enum WebpPreset {
  none('none'),
  def('default'),
  picture('picture'),
  photo('photo'),
  drawing('drawing'),
  icon('icon'),
  text('text'),
  ;

  final String flag;
  String get name => switch (this) {
    none => L10n.current.webpPresetNoneName,
    def => L10n.current.defaultOption,
    picture => L10n.current.image,
    photo => L10n.current.webpPresetPhotoName,
    drawing => L10n.current.webpPresetDrawingName,
    icon => L10n.current.webpPresetIconName,
    text => L10n.current.text,
  };
  String get desc => switch (this) {
    none => L10n.current.webpPresetNoneDesc,
    def => L10n.current.webpPresetDefDesc,
    picture => L10n.current.webpPresetPictureDesc,
    photo => L10n.current.webpPresetPhotoDesc,
    drawing => L10n.current.webpPresetDrawingDesc,
    icon => L10n.current.webpPresetIconDesc,
    text => L10n.current.webpPresetTextDesc,
  };

  const WebpPreset(this.flag);
}
