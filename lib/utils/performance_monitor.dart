import 'dart:async';
import 'dart:io'; // 替换 dart:ui
// 移除不存在的导入

/// 性能监控工具
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, DateTime> _startTimes = {};
  final Map<String, List<int>> _executionTimes = {};
  final StreamController<PerformanceEvent> _eventController =
      StreamController<PerformanceEvent>.broadcast();

  Stream<PerformanceEvent> get events => _eventController.stream;

  /// 开始性能监控
  void start(String operation) {
    _startTimes[operation] = DateTime.now();
  }

  /// 结束性能监控
  int end(String operation) {
    final startTime = _startTimes[operation];
    if (startTime == null) return 0;

    final duration = DateTime.now().difference(startTime).inMilliseconds;
    _startTimes.remove(operation);

    _executionTimes.putIfAbsent(operation, () => []).add(duration);

    // 发送性能事件
    _eventController.add(
      PerformanceEvent(
        operation: operation,
        duration: duration,
        timestamp: DateTime.now(),
      ),
    );

    print('Performance: $operation took ${duration}ms');

    return duration;
  }

  /// 获取执行统计
  Map<String, PerformanceStats> getStats() {
    final stats = <String, PerformanceStats>{};

    for (final entry in _executionTimes.entries) {
      final times = entry.value;
      if (times.isEmpty) continue;

      times.sort();
      final avg = times.reduce((a, b) => a + b) / times.length;

      stats[entry.key] = PerformanceStats(
        operation: entry.key,
        averageDuration: avg.round(),
        minDuration: times.first,
        maxDuration: times.last,
        executionCount: times.length,
      );
    }

    return stats;
  }

  /// 清理统计数据
  void clear() {
    _startTimes.clear();
    _executionTimes.clear();
  }

  /// 获取内存信息（简化版）
  Future<MemoryInfo> getMemoryInfo() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // 在移动平台上使用简化的内存估算
        final info = ProcessInfo.currentRss;
        return MemoryInfo(
          totalMemoryMB: (info / 1024 / 1024).round(),
          usedMemoryMB: (info / 1024 / 1024).round(),
          availableMemoryMB: 0,
        );
      }

      return MemoryInfo(
        totalMemoryMB: 0,
        usedMemoryMB: 0,
        availableMemoryMB: 0,
      );
    } catch (e) {
      return MemoryInfo(
        totalMemoryMB: 0,
        usedMemoryMB: 0,
        availableMemoryMB: 0,
      );
    }
  }

  void dispose() {
    _eventController.close();
  }
}

/// 性能事件
class PerformanceEvent {
  final String operation;
  final int duration;
  final DateTime timestamp;

  PerformanceEvent({
    required this.operation,
    required this.duration,
    required this.timestamp,
  });
}

/// 性能统计
class PerformanceStats {
  final String operation;
  final int averageDuration;
  final int minDuration;
  final int maxDuration;
  final int executionCount;

  PerformanceStats({
    required this.operation,
    required this.averageDuration,
    required this.minDuration,
    required this.maxDuration,
    required this.executionCount,
  });

  @override
  String toString() {
    return 'PerformanceStats($operation): avg=${averageDuration}ms, '
        'min=${minDuration}ms, max=${maxDuration}ms, count=$executionCount';
  }
}

/// 内存信息
class MemoryInfo {
  final int totalMemoryMB;
  final int usedMemoryMB;
  final int availableMemoryMB;

  MemoryInfo({
    required this.totalMemoryMB,
    required this.usedMemoryMB,
    required this.availableMemoryMB,
  });

  @override
  String toString() {
    return 'MemoryInfo: total=${totalMemoryMB}MB, '
        'used=${usedMemoryMB}MB, available=${availableMemoryMB}MB';
  }
}
