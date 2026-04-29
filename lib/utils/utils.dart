import 'dart:convert' show JsonEncoder, base64;
import 'dart:math' show Random;

import 'package:PiliPlus/common/constants.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, MethodChannel;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

abstract final class Utils {
  static final random = Random();

  static const channel = MethodChannel(Constants.appName);

  static const jsonEncoder = JsonEncoder.withIndent('    ');

  static final numericRegex = RegExp(r'^[\d\.]+$');
  static bool isStringNumeric(String str) {
    return numericRegex.hasMatch(str);
  }

  static String generateRandomString(int length) {
    const characters = '0123456789abcdefghijklmnopqrstuvwxyz';

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ),
    );
  }

  static Future<void> copyText(
    String text, {
    bool needToast = true,
    String? toastText,
  }) {
    if (needToast) {
      SmartDialog.showToast(toastText ?? '已复制');
    }
    return Clipboard.setData(ClipboardData(text: text));
  }

  static String makeHeroTag(dynamic v) {
    return v.toString() + random.nextInt(9999).toString();
  }

  static List<int> generateRandomBytes(int minLength, int maxLength) {
    return List<int>.generate(
      minLength + random.nextInt(maxLength - minLength + 1),
      (_) => 0x26 + random.nextInt(0x59), // dm_img_str不能有`%`
    );
  }

  static String base64EncodeRandomString(int minLength, int maxLength) {
    final randomBytes = generateRandomBytes(minLength, maxLength);
    final randomBase64 = base64.encode(randomBytes);
    return randomBase64.substring(0, randomBase64.length - 2);
  }

  static String getFileName(String uri, {bool fileExt = true}) {
    int slash = -1;
    int dot = -1;
    int qMark = uri.length;

    loop:
    for (int index = uri.length - 1; index >= 0; index--) {
      switch (uri.codeUnitAt(index)) {
        case 0x2F: // `/`
          slash = index;
          break loop;
        case 0x2E: // `.`
          if (dot == -1) dot = index;
          break;
        case 0x3F: // `?`
          qMark = index;
          if (dot > qMark) dot = -1;
          break;
      }
    }
    RangeError.checkNotNegative(slash, '/');
    return uri.substring(slash + 1, (fileExt || dot == -1) ? qMark : dot);
  }

  /// When calling this from a `catch` block consider annotating the method
  /// containing the `catch` block with
  /// `@pragma('vm:notify-debugger-on-exception')` to allow an attached debugger
  /// to treat the exception as unhandled.
  static void reportError(Object exception, [StackTrace? stack]) {
    Catcher2.reportCheckedError(exception, stack);
  }
}
