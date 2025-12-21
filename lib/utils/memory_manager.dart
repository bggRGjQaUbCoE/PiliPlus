import 'dart:async';

/// 内存管理工具类 - 防止内存泄漏
class MemoryManager {
  static final Set<Timer> _timers = {};
  static final Set<StreamSubscription> _subscriptions = {};
  static final Map<String, List<Function>> _callbacks = {};

  /// 添加Timer到管理池
  static void addTimer(Timer timer, [String? tag]) {
    _timers.add(timer);
    if (tag != null) {
      _callbacks[tag] ??= [];
      _callbacks[tag]!.add(() => timer.cancel());
    }
  }

  /// 添加StreamSubscription到管理池
  static void addSubscription(StreamSubscription subscription, [String? tag]) {
    _subscriptions.add(subscription);
    if (tag != null) {
      _callbacks[tag] ??= [];
      _callbacks[tag]!.add(() => subscription.cancel());
    }
  }

  /// 添加自定义清理回调
  static void addCallback(String tag, Function callback) {
    _callbacks[tag] ??= [];
    _callbacks[tag]!.add(callback);
  }

  /// 按标签清理资源
  static void disposeByTag(String tag) {
    final callbacks = _callbacks[tag];
    if (callbacks != null) {
      for (final callback in callbacks) {
        try {
          callback();
        } catch (e) {
          // 忽略清理过程中的错误
        }
      }
      callbacks.clear();
      _callbacks.remove(tag);
    }
  }

  /// 清理所有资源
  static void disposeAll() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();

    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    for (final callbacks in _callbacks.values) {
      for (final callback in callbacks) {
        try {
          callback();
        } catch (e) {
          // 忽略清理过程中的错误
        }
      }
    }
    _callbacks.clear();
  }

  /// 获取当前资源统计
  static Map<String, int> getStats() {
    return {
      'timers': _timers.length,
      'subscriptions': _subscriptions.length,
      'tags': _callbacks.length,
    };
  }
}
