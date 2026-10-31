import 'dart:io' show Platform, exit;

import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/chromeos_detector.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/widgets.dart' show WidgetsBinding, Size;
import 'package:nativeapi/nativeapi.dart' as nativeapi show Size;
import 'package:win32/win32.dart' as kernel32;

abstract final class DeviceUtils {
  static final int sdkInt = AndroidHelper.sdkInt();

  /// ChromeOS 判定结果
  ///
  /// null 表示尚未完成判定或判定失败，此时 [isChromeOS] 退化为 false
  static bool? _isChromeOS;

  /// 当前是否运行在 ChromeOS(ARC / ARCVM) 上
  ///
  /// ChromeOS 的窗口方向由系统决定，App 不应再主动请求方向
  static bool get isChromeOS => _isChromeOS ?? false;

  /// 设备是否为平板
  static bool get isTablet {
    return size.shortestSide >= 600;
  }

  /// 当前窗口尺寸
  ///
  /// 随窗口/分屏变化，适合判断当前朝向
  static Size get size {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    return view.physicalSize / view.devicePixelRatio;
  }

  static String get platformName => PlatformUtils.isDesktop
      ? 'desktop'
      : isTablet
      ? 'pad'
      : 'phone';

  /// 初始化设备信息，用于识别 ChromeOS
  ///
  /// 需在读取 [Pref] 相关设置前调用
  static Future<void> init() async {
    if (!Platform.isAndroid) {
      // 非 Android 平台可确定不是 ChromeOS
      _isChromeOS = false;
      return;
    }
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      _isChromeOS = ChromeOSDetector.isChromeOS(
        fingerprint: info.fingerprint,
        product: info.product,
        device: info.device,
        brand: info.brand,
        manufacturer: info.manufacturer,
        systemFeatures: info.systemFeatures,
      );
      if (kDebugMode) {
        debugPrint(
          'DeviceUtils.init: isChromeOS=$_isChromeOS, '
          'fingerprint=${info.fingerprint}, product=${info.product}, '
          'device=${info.device}, brand=${info.brand}, '
          'manufacturer=${info.manufacturer}',
        );
      }
    } catch (e) {
      debugPrint('DeviceUtils.init error: $e');
      // 保持 _isChromeOS 为 null，[isChromeOS] 退化为 false
    }
  }

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
}
