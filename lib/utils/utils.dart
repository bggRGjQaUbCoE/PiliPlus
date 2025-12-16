import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

abstract class Utils {
  static final random = Random();

  static const channel = MethodChannel(Constants.appName);

  static const jsonEncoder = JsonEncoder.withIndent('    ');

  static String themeUrl(bool isDark) =>
      'native.theme=${isDark ? 2 : 1}&night=${isDark ? 1 : 0}';

  static Future<void> saveBytes2File({
    required String name,
    required Uint8List bytes,
    required List<String> allowedExtensions,
    FileType type = FileType.custom,
  }) async {
    try {
      final path = await FilePicker.platform.saveFile(
        allowedExtensions: allowedExtensions,
        type: type,
        fileName: name,
        bytes: PlatformUtils.isDesktop ? null : bytes,
      );
      if (path == null) {
        SmartDialog.showToast("取消保存");
        return;
      }
      if (PlatformUtils.isDesktop) {
        await File(path).writeAsBytes(bytes);
      }
      SmartDialog.showToast("已保存");
    } catch (e) {
      SmartDialog.showToast("保存失败: $e");
    }
  }

  static int? safeToInt(dynamic value) => switch (value) {
    int e => e,
    String e => int.tryParse(e),
    num e => e.toInt(),
    _ => null,
  };

  static Future<bool> get isWiFi async {
    try {
      return PlatformUtils.isMobile &&
          (await Connectivity().checkConnectivity()).contains(
            ConnectivityResult.wifi,
          );
    } catch (_) {
      return true;
    }
  }

  static Color parseColor(String color) =>
      Color(int.parse(color.replaceFirst('#', 'FF'), radix: 16));

  static int? _sdkInt;
  static Future<int> get sdkInt async {
    return _sdkInt ??= (await DeviceInfoPlugin().androidInfo).version.sdkInt;
  }

  static bool? _isIpad;
  static Future<bool> get isIpad async {
    if (!Platform.isIOS) return false;
    return _isIpad ??= (await DeviceInfoPlugin().iosInfo).model
        .toLowerCase()
        .contains('ipad');
  }

  static Future<Rect?> get sharePositionOrigin async {
    if (await isIpad) {
      final size = Get.size;
      return Rect.fromLTWH(0, 0, size.width, size.height / 2);
    }
    return null;
  }

  static Future<void> shareText(String text) async {
    if (PlatformUtils.isDesktop) {
      copyText(text);
      return;
    }
    try {
      await SharePlus.instance.share(
        ShareParams(text: text, sharePositionOrigin: await sharePositionOrigin),
      );
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

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

  static String makeHeroTag(v) {
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
    final i0 = uri.lastIndexOf('/') + 1;
    final i1 = fileExt ? uri.length : uri.lastIndexOf('.');
    return uri.substring(i0, i1);
  }

  /// When calling this from a `catch` block consider annotating the method
  /// containing the `catch` block with
  /// `@pragma('vm:notify-debugger-on-exception')` to allow an attached debugger
  /// to treat the exception as unhandled.
  static void reportError(Object exception, [StackTrace? stack]) {
    Catcher2.reportCheckedError(exception, stack);
  }
}
