import 'dart:io' show Platform;
import 'dart:math' show max;

import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// iOS 26+ iPhone 上用系统液态玻璃标签栏作为主导航（见 ios/Runner/SceneDelegate.swift）。
///
/// 原生层不可用时（系统版本过低、非 iPhone）[attach] 返回 false，
/// 继续由 Flutter 绘制导航。
abstract final class IOSNativeTabBar {
  static const _channel = MethodChannel('piliplus/native_tab_bar');

  static bool _enabled = false;
  static bool get enabled => _enabled;

  static ValueChanged<int>? _onSelect;

  /// 原生容器的安全区。Flutter 视图不是窗口根控制器时拿不到系统安全区，
  /// 由原生层转发；为 null 时使用 Flutter 自己的值
  static final safeArea = ValueNotifier<EdgeInsets?>(null);

  static Future<void> init() async {
    if (!Platform.isIOS) return;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'select':
          _onSelect?.call(call.arguments as int);
        case 'safeArea':
          _setSafeArea(call.arguments);
      }
    });
    try {
      _setSafeArea(await _channel.invokeMethod('getSafeArea'));
    } on MissingPluginException {
      // 没有原生标签栏容器
    }
  }

  static void _setSafeArea(Object? value) {
    if (value is! Map) return;
    double side(String key) => (value[key] as num?)?.toDouble() ?? 0;
    safeArea.value = EdgeInsets.fromLTRB(
      side('left'),
      side('top'),
      side('right'),
      side('bottom'),
    );
  }

  static Future<bool> attach({
    required List<NavigationBarType> tabs,
    required int selected,
    required ValueChanged<int> onSelect,
  }) async {
    if (!Platform.isIOS || tabs.length < 2) return false;
    _onSelect = onSelect;
    try {
      _enabled =
          await _channel.invokeMethod<bool>('setTabs', {
            'tabs': [
              for (final e in tabs) {'id': e.name, 'title': e.label},
            ],
            'selected': selected,
          }) ??
          false;
    } on MissingPluginException {
      _enabled = false;
    }
    return _enabled;
  }

  static void setSelected(int index) {
    if (_enabled) _channel.invokeMethod('setSelected', index);
  }

  /// [value] 为 null 时隐藏角标，为空字符串时显示红点
  static void setBadge(int index, String? value) {
    if (_enabled) {
      _channel.invokeMethod('setBadge', {'index': index, 'value': value});
    }
  }

  static void setHidden(bool hidden) {
    if (_enabled) _channel.invokeMethod('setHidden', hidden);
  }
}

/// 用原生层转发的安全区覆盖 [MediaQuery] 的内边距
class NativeSafeArea extends StatelessWidget {
  const NativeSafeArea({super.key, required this.scale, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EdgeInsets?>(
      valueListenable: IOSNativeTabBar.safeArea,
      builder: (context, insets, child) {
        if (insets == null) return child!;
        final mediaQuery = MediaQuery.of(context);
        final viewPadding = insets / scale;
        return MediaQuery(
          data: mediaQuery.copyWith(
            viewPadding: viewPadding,
            padding: viewPadding.copyWith(
              bottom: max(0, viewPadding.bottom - mediaQuery.viewInsets.bottom),
            ),
          ),
          child: child!,
        );
      },
      child: child,
    );
  }
}
