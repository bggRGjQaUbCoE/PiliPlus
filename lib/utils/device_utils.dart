import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/widgets.dart' show WidgetsBinding, Size;

abstract final class DeviceUtils {
  static late int sdkInt;

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
}
