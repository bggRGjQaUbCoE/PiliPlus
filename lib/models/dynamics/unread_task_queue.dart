/// 串行执行同账号、同代数的扫描；账号变化时只等待旧任务，不能复用它的结果。
///
/// 前台刷新和后台续扫可以共享一个当前任务。旧账号任务结束后，新账号必须独立执行，
/// 防止“等待了旧请求就误以为新账号也扫描过”的首次切换漏报。
class DynamicUnreadTaskQueue {
  /// 当前任务的账号对象和请求代数共同确定结果归属。
  Object? _account;
  int? _generation;
  Future<Set<int>>? _pending;

  /// 同一归属复用结果，其他归属排队执行；finally 始终释放自己的任务引用。
  Future<Set<int>> run(
    Object account,
    int generation,
    Future<Set<int>> Function() job,
  ) async {
    final existing = _pending;
    if (existing != null) {
      final reusable =
          identical(account, _account) && generation == _generation;
      try {
        final result = await existing;
        if (reusable) return result;
      } catch (_) {
        // 同账号调用者保留原异常；旧账号失败不能阻断新账号自己的扫描。
        if (reusable) rethrow;
      }
      return run(account, generation, job);
    }
    final future = job();
    _account = account;
    _generation = generation;
    _pending = future;
    try {
      return await future;
    } finally {
      if (identical(_pending, future)) _pending = null;
    }
  }
}
