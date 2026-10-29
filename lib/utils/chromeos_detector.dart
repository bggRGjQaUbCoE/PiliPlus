/// ChromeOS(ARC / ARCVM) 环境判定
///
/// 纯函数实现，不依赖任何平台插件，便于单元测试。
///
/// 判定分强/弱两级信号，避免仅凭 `chromium` 品牌就把普通设备
/// （定制 ROM / 模拟器）误判成 ChromeOS——一旦误判，App 将永久
/// 禁用主动方向请求，且用户无法通过设置恢复。
abstract final class ChromeOSDetector {
  /// 强信号：命中任意一个即可判定为 ChromeOS
  ///
  /// 这些是 ChromeOS 容器特有的系统特性，普通 Android 设备不会声明。
  ///
  /// - `org.chromium.arc[.device_management]`：ARC(Android Runtime for ChromeOS)
  ///   容器自带，实测 ChromeOS ARCVM 设备（kukui_cheets / Android 13）上报的是
  ///   这两个 feature，而非 `com.google.android.feature.*`
  /// - `com.google.android.feature.cros_device_management`：旧版 ARC 上报
  /// - `android.hardware.type.chromebook`：Chromebook 硬件形态
  static const Set<String> strongFeatures = {
    'org.chromium.arc',
    'org.chromium.arc.device_management',
    'com.google.android.feature.cros_device_management',
    'android.hardware.type.chromebook',
  };

  /// ARC / ARCVM 的设备代号特征
  ///
  /// `arcvm` 是 Android 12+ ARC 通用代号，`cheets` 是 ChromeOS ARCVM 代号
  static const List<String> arcDeviceMarkers = ['arcvm', 'cheets'];

  /// ChromeOS 设备代号前缀，如 `cros_cheets`
  static const String crosToken = 'cros';

  /// ARC / ARCVM 的品牌标识
  static const String chromiumBrand = 'chromium';

  /// 判定当前环境是否为 ChromeOS(ARC / ARCVM)
  ///
  /// 判定策略：
  /// 1. 命中任一 [strongFeatures] 或 ARC 设备代号特征 -> 判定为 ChromeOS
  /// 2. 其余情况需要同时命中 `cros` 设备代号与 chromium 品牌两个弱信号
  static bool isChromeOS({
    required String fingerprint,
    required String product,
    required String device,
    required String brand,
    required String manufacturer,
    required Iterable<String> systemFeatures,
  }) {
    // 强信号 1：Chromebook 硬件 / ChromeOS 设备管理特性
    for (final feature in systemFeatures) {
      if (strongFeatures.contains(feature.toLowerCase())) {
        return true;
      }
    }

    final identity = [fingerprint, product, device];

    // 强信号 2：ARC / ARCVM 设备代号
    for (final value in identity) {
      final lower = value.toLowerCase();
      for (final marker in arcDeviceMarkers) {
        if (lower.contains(marker)) {
          return true;
        }
      }
    }

    // 弱信号：需同时满足两项才判定，避免普通设备被误判
    final hasCrosToken = identity.any(
      (value) => _tokens(value.toLowerCase()).contains(crosToken),
    );
    final isChromiumBrand = brand.toLowerCase() == chromiumBrand &&
        manufacturer.toLowerCase() == chromiumBrand;
    return hasCrosToken && isChromiumBrand;
  }

  static Set<String> _tokens(String value) => value
      .split(RegExp('[^a-z0-9]+'))
      .where((element) => element.isNotEmpty)
      .toSet();
}
