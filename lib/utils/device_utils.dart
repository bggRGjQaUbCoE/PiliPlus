import 'dart:io' show Platform, exit;

import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/widgets.dart' show WidgetsBinding, Size;
import 'package:nativeapi/nativeapi.dart' as nativeapi show Size;
import 'package:win32/win32.dart' as kernel32;

abstract final class DeviceUtils {
  static final int sdkInt = AndroidHelper.sdkInt();

  static bool get isTablet {
    return size.shortestSide >= 600;
  }

  static Size get size {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    return view.physicalSize / view.devicePixelRatio;
  }

  static String get platformName => PlatformUtils.isDesktop
      ? 'desktop'
      : isTablet
      ? 'pad'
      : 'phone';

  static void exitApp() {
    if (Platform.isWindows) {
      // flutter_inappwebview
      // 6.2.0-beta.2+ https://github.com/pichillilorenzo/flutter_inappwebview/issues/2482
      // 6.1.5 https://github.com/pichillilorenzo/flutter_inappwebview/issues/2512#issuecomment-3031039587
      final hProcess = kernel32.GetCurrentProcess();
      kernel32.TerminateProcess(hProcess, 0);
    } else {
      exit(0);
    }
  }

  static const desktopMinSize = nativeapi.Size(width: 400, height: 720);

  static (String, String)? _fingerprint;

  /// 真实设备名与系统平台串，格式与 App 端上报一致
  /// （如 `PJZ110` / `Android16PJZ110`），登录时作为设备指纹上报
  static Future<(String, String)> get deviceFingerprint async {
    final cached = _fingerprint;
    if (cached != null) return cached;
    try {
      if (Platform.isAndroid) {
        final info = await DeviceInfoPlugin().androidInfo;
        final name = info.model;
        final release = info.version.release ?? '';
        return _fingerprint = (name, 'Android$release$name');
      }
      if (Platform.isIOS) {
        final info = await DeviceInfoPlugin().iosInfo;
        final name = info.utsname.machine;
        return _fingerprint = (name, 'iOS${info.systemVersion}$name');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('device fingerprint error: $e');
    }
    final name = Platform.operatingSystem;
    return _fingerprint = (name, name);
  }
}
