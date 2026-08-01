import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

abstract final class WindowsFontUtils {
  static Future<List<String>> getInstalledFontFamilies() {
    if (!Platform.isWindows) {
      return Future.value(const <String>[]);
    }
    return Isolate.run(_enumerateInstalledFontFamilies);
  }
}

List<String> _enumerateInstalledFontFamilies() {
  final hdc = GetDC(null);
  if (!hdc.isValid) {
    throw StateError('Failed to acquire a Windows device context.');
  }

  final logFont = calloc<LOGFONT>();
  final fontFamilies = <String, String>{};
  final callback = NativeCallable<FONTENUMPROC>.isolateLocal(
    (
      Pointer<LOGFONT> logFont,
      Pointer<TEXTMETRIC> _,
      int _,
      int _,
    ) {
      final fontFamily = logFont.ref.lfFaceName.trim();
      // Symbol fonts replace ordinary text with pictograms and cannot serve as
      // an application UI font.
      if (logFont.ref.lfCharSet != SYMBOL_CHARSET &&
          fontFamily.isNotEmpty &&
          !fontFamily.startsWith('@')) {
        fontFamilies.putIfAbsent(fontFamily.toLowerCase(), () => fontFamily);
      }
      return 1;
    },
    exceptionalReturn: 0,
  );

  try {
    logFont.ref.lfCharSet = DEFAULT_CHARSET;
    final result = EnumFontFamiliesEx(
      hdc,
      logFont,
      callback.nativeFunction,
      const LPARAM(0),
      0,
    );
    if (result == 0 && fontFamilies.isEmpty) {
      throw StateError('Windows did not return any installed fonts.');
    }
  } finally {
    callback.close();
    calloc.free(logFont);
    ReleaseDC(null, hdc);
  }

  return fontFamilies.values.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
}
