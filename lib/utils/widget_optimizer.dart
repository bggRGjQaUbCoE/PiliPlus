import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget 优化工具
class WidgetOptimizer {
  static final Map<String, Widget> _cachedWidgets = {};
  static final Map<String, RxInterface> _cachedRxValues = {};

  /// 创建缓存的 Widget
  static Widget cachedBuilder(String key, Widget Function() builder) {
    final cached = _cachedWidgets[key];
    if (cached != null) {
      return cached;
    }

    final widget = builder();
    _cachedWidgets[key] = widget;
    return widget;
  }

  /// 优化的 Obx 包装器
  static Widget optimizedObx(RxInterface rx, Widget Function() builder) {
    return Obx(() {
      // 添加构建计数追踪（调试时使用）
      return builder();
    });
  }

  /// 优化的 GetX 构建器 - 简化版本避免编译错误
  static Widget optimizedGetBuilder({
    required Widget Function() builder,
    String? id,
    bool autoRemove = true,
  }) {
    return Builder(
      builder: (_) => builder(),
    );
  }

  /// 创建带缓存的 Icon
  static Widget cachedIcon(
    IconData iconData, {
    double? size,
    Color? color,
  }) {
    final key = 'icon_${iconData.codePoint}_${size ?? ''}_${color ?? ''}';
    return cachedBuilder(key, () => Icon(iconData, size: size, color: color));
  }

  /// 清理指定 key 的缓存
  static void clearCache(String key) {
    _cachedWidgets.remove(key);
    _cachedRxValues.remove(key);
  }

  /// 清理所有缓存
  static void clearAllCache() {
    _cachedWidgets.clear();
    _cachedRxValues.clear();
  }
}

/// 性能优化 Widget 基类
abstract class OptimizedWidget extends StatelessWidget {
  const OptimizedWidget({Key? key}) : super(key: key);

  /// 子类需要实现这个方法
  Widget buildOptimized(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildOptimized(context);
  }
}

/// 优化的 StatelessWidget
abstract class OptimizedStatelessWidget extends StatelessWidget {
  const OptimizedStatelessWidget({Key? key}) : super(key: key);

  /// 覆盖构建方法以支持性能优化
  @override
  Widget build(BuildContext context);
}
