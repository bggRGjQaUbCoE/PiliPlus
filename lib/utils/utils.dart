import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Utils {
  static final Random random = Random();

  static const channel = MethodChannel("PiliPlus");

  static final bool isMobile = Platform.isAndroid || Platform.isIOS;

  static final bool isDesktop =
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

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

  static String? _tempDir;

  static Future<String> get temporaryDirectory async {
    return _tempDir ??= (await getTemporaryDirectory()).path;
  }

  static Future<Rect?> get sharePositionOrigin async {
    if (await isIpad) {
      final size = Get.size;
      return Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height / 2,
      );
    }
    return null;
  }

  static Future<void> shareText(String text) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          sharePositionOrigin: await sharePositionOrigin,
        ),
      );
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  static String buildShadersAbsolutePath(
    String baseDirectory,
    List<String> shaders,
  ) {
    return shaders
        .map((shader) => path.join(baseDirectory, shader))
        .join(Platform.isWindows ? ';' : ':');
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

  static void copyText(
    String text, {
    bool needToast = true,
    String? toastText,
  }) {
    Clipboard.setData(ClipboardData(text: text));
    if (needToast) {
      SmartDialog.showToast(toastText ?? '已复制');
    }
  }

  static String makeHeroTag(v) {
    return v.toString() + random.nextInt(9999).toString();
  }

  static int findClosestNumber(int target, List<int> numbers) {
    List<int> filterNums = numbers.where((number) => number <= target).toList();
    return filterNums.isNotEmpty
        ? filterNums.reduce((a, b) => a > b ? a : b)
        : numbers.reduce((a, b) => a > b ? b : a);
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
}
