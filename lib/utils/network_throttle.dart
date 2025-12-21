import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';

/// 网络请求节流管理器
class NetworkThrottle {
  static final Map<String, DateTime> _lastRequestTime = {};
  static final Map<String, Timer> _throttleTimers = {};

  /// 节流执行网络请求
  static Future<T?> throttleRequest<T>(
    String key,
    Future<T> Function() request, {
    Duration duration = const Duration(seconds: 5),
    bool force = false,
  }) async {
    final now = DateTime.now();
    final lastTime = _lastRequestTime[key];

    // 如果强制执行或距离上次请求超过间隔时间，立即执行
    if (force || lastTime == null || now.difference(lastTime) >= duration) {
      _lastRequestTime[key] = now;
      return request();
    }

    // 否则，返回null表示被节流
    return null;
  }

  /// 使用EasyDebounce的防抖请求
  static Future<T?> debounceRequest<T>(
    String key,
    Future<T> Function() request, {
    Duration duration = const Duration(milliseconds: 300),
  }) async {
    EasyDebounce.debounce(key, duration, () async {
      try {
        await request();
      } catch (e) {
        // 错误处理
      }
    });

    return null;
  }

  /// 清除指定key的节流
  static void cancel(String key) {
    _throttleTimers[key]?.cancel();
    _throttleTimers.remove(key);
    EasyDebounce.cancel(key);
  }

  /// 清除所有节流
  static void cancelAll() {
    for (final timer in _throttleTimers.values) {
      timer.cancel();
    }
    _throttleTimers.clear();
    _lastRequestTime.clear();
  }
}
