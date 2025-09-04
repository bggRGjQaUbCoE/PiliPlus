import 'dart:async';
import 'dart:ffi';

import 'package:PiliPlus/http/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:media_kit/ffi/src/allocation.dart';
import 'package:media_kit/ffi/src/utf8.dart';
import 'package:media_kit/generated/libmpv/bindings.dart' as generated;
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

  MpvConvertWebp(
    this.url,
    this.outFile,
    this.start,
    double end, {
    this.progress,
  }) : duration = end - start;

  Future<void> _init() async {
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
      },
    );
    _setHeader();
    if (progress != null) {
      _observeProperty('time-pos');
    }
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
        if (prop.name.cast<Utf8>().toDartString() == 'time-pos' &&
            prop.format == generated.mpv_format.MPV_FORMAT_DOUBLE) {
          progress!.value = (prop.data.cast<Double>().value - start) / duration;
        }
        break;
      case generated.mpv_event_id.MPV_EVENT_FILE_LOADED:
        _success = true;
        break;
      case generated.mpv_event_id.MPV_EVENT_LOG_MESSAGE:
        final log = event.ref.data.cast<generated.mpv_event_log_message>().ref;
        final prefix = log.prefix.cast<Utf8>().toDartString().trim();
        final level = log.level.cast<Utf8>().toDartString().trim();
        final text = log.text.cast<Utf8>().toDartString().trim();
        debugPrint('$level $prefix : $text');
      case generated.mpv_event_id.MPV_EVENT_END_FILE ||
          generated.mpv_event_id.MPV_EVENT_SHUTDOWN:
        progress?.value = 1;
        _completer.complete(_success);
        dispose();
        break;
    }
  }

  void _command(List<String> args) {
    final pointers = args.map((e) => e.toNativeUtf8()).toList();
    final arr = calloc<Pointer<Utf8>>(128);
    for (int i = 0; i < args.length; i++) {
      arr[i] = pointers[i];
    }

    _mpv.mpv_command(_ctx, arr.cast());

    calloc.free(arr);
    pointers.forEach(calloc.free);
  }

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

  void _setHeader() {
    final property = 'http-header-fields'.toNativeUtf8();
    // Allocate & fill the [mpv_node] with the headers.
    final value = calloc<generated.mpv_node>();
    final valRef = value.ref
      ..format = generated.mpv_format.MPV_FORMAT_NODE_ARRAY;
    valRef.u.list = calloc<generated.mpv_node_list>();
    final valList = valRef.u.list.ref
      ..num = 2
      ..values = calloc<generated.mpv_node>(2);

    const entries = [
      (
        'user-agent',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
      ),
      ('referer', HttpString.baseUrl),
    ];
    for (int i = 0; i < 2; i++) {
      final (k, v) = entries[i];
      valList.values[i]
        ..format = generated.mpv_format.MPV_FORMAT_STRING
        ..u.string = '$k: $v'.toNativeUtf8().cast();
    }
    _mpv.mpv_set_property(
      _ctx,
      property.cast(),
      generated.mpv_format.MPV_FORMAT_NODE,
      value.cast(),
    );
    // Free the allocated memory.
    calloc.free(property);
    for (int i = 0; i < valList.num; i++) {
      calloc.free(valList.values[i].u.string);
    }
    calloc
      ..free(valList.values)
      ..free(valRef.u.list)
      ..free(value);
  }
}
