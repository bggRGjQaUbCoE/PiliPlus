import 'dart:io' show Platform;

abstract final class PlatformUtils {
  @pragma("vm:platform-const")
  static final bool isMobile = Platform.isAndroid || Platform.isIOS;

  @pragma("vm:platform-const")
  static final bool isDesktop =
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @pragma("vm:platform-const")
  static final bool isDarwin = Platform.isIOS || Platform.isMacOS;

  /// Linux 下是否运行在 Wayland 会话（强制 X11 后端时不算）。
  ///
  /// Wayland 的 GDK workArea 只是显示器几何，不包含顶栏、窗口间隙等占用，
  /// 窗口尺寸相关计算需要特殊处理。
  static final bool isWayland =
      Platform.isLinux &&
      Platform.environment['WAYLAND_DISPLAY'] != null &&
      Platform.environment['GDK_BACKEND'] != 'x11';
}
