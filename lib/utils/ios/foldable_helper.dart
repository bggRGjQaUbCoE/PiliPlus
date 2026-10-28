import 'dart:io' show Platform;

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/widgets.dart'
    show WidgetsBinding, WidgetsBindingObserver;

/// 折叠屏 iPhone（iPhone Duo）适配。
///
/// 所有直板 iPhone 的屏幕最短边都小于 600pt，只有折叠屏 iPhone 展开后的内屏
/// （7.6"，约 626×890pt）会达到平板尺寸。因此在 iPhone 上可以直接用当前窗口
/// 尺寸判断展开/合上，无需依赖机型标识符：
///
/// - 展开（内屏）：启用横屏适配（平板布局，允许任意方向）。
///   注意：iPhone Duo 内屏不遵守 supportedInterfaceOrientations，
///   方向锁定在内屏上无效，布局只能依据窗口尺寸。
/// - 合上（外屏）：恢复手机布局并锁定竖屏，与普通 iPhone 一致。
///
/// 非折叠 iPhone 的最短边永远 < 600，自动模式下行为与关闭横屏适配完全相同。
abstract final class IOSFoldableHelper {
  static bool _isIPhone = false;

  /// 当前设备是否为 iPhone（不含 iPad）
  static bool get isIPhone => _isIPhone;

  /// 横屏适配是否由折叠状态自动决定
  static bool get isAuto =>
      _isIPhone &&
      GStorage.setting.get(
        SettingBoxKey.foldableAutoHorizontal,
        defaultValue: true,
      );

  /// 当前是否处于展开状态（窗口最短边 >= 600pt）
  static bool get isUnfolded => DeviceUtils.isTablet;

  static bool? _lastUnfolded;

  static Future<void> init() async {
    if (!Platform.isIOS) return;
    try {
      final info = await DeviceInfoPlugin().iosInfo;
      _isIPhone = info.model.toLowerCase().contains('iphone');
    } catch (e) {
      if (kDebugMode) debugPrint('IOSFoldableHelper init: $e');
    }
    if (!_isIPhone) return;
    WidgetsBinding.instance.addObserver(_FoldObserver());
  }

  static void _onMetricsChanged() {
    final size = DeviceUtils.size;
    // 首帧前视图尺寸可能为 0，忽略
    if (size.isEmpty) return;
    final unfolded = size.shortestSide >= 600;
    if (unfolded == _lastUnfolded) return;
    _lastUnfolded = unfolded;
    if (!isAuto) return;
    // 全屏播放中交给播放器处理，退出全屏时会按新的状态恢复方向
    if (PlPlayerController.instance?.isFullScreen.value ?? false) return;
    applyOrientation();
  }

  /// 按当前折叠状态设置允许的屏幕方向
  static Future<void>? applyOrientation() =>
      isUnfolded ? fullMode() : portraitUpMode();
}

class _FoldObserver with WidgetsBindingObserver {
  @override
  void didChangeMetrics() => IOSFoldableHelper._onMetricsChanged();
}
