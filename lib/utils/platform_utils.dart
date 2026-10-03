import 'dart:io' show Platform;

abstract final class PlatformUtils {
  @pragma("vm:platform-const")
  static final bool isMobile = Platform.isAndroid || Platform.isIOS;

  @pragma("vm:platform-const")
  static final bool isDesktop =
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @pragma("vm:platform-const")
  static final bool isDarwin = Platform.isIOS || Platform.isMacOS;

  /// Platforms whose media_kit `VideoController` is a `NativeVideoController`,
  /// i.e. the only ones implementing `VideoOutputManager.SetSize`. Android
  /// only supports `VideoOutputManager.SetSurfaceSize`.
  /// Keep in sync with media-kit's `NativeVideoController.supported`.
  @pragma("vm:platform-const")
  static final bool supportsVideoOutputResize =
      Platform.isIOS ||
      Platform.isMacOS ||
      Platform.isWindows ||
      Platform.isLinux;
}
