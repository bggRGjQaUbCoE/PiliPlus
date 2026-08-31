import 'dart:async';
import 'dart:collection';

final class AsyncTaskPool {
  AsyncTaskPool(this.maxConcurrent) {
    if (maxConcurrent <= 0) {
      throw ArgumentError.value(
        maxConcurrent,
        'maxConcurrent',
        'must be greater than zero',
      );
    }
  }

  final int maxConcurrent;
  final Queue<Completer<void>> _waiters = Queue<Completer<void>>();
  int _activeCount = 0;

  Future<T> run<T>(Future<T> Function() task) async {
    await _acquire();
    try {
      return await task();
    } finally {
      _release();
    }
  }

  Future<void> _acquire() {
    if (_activeCount < maxConcurrent) {
      _activeCount += 1;
      return Future<void>.value();
    }
    final waiter = Completer<void>();
    _waiters.addLast(waiter);
    return waiter.future;
  }

  void _release() {
    if (_waiters.isEmpty) {
      _activeCount -= 1;
    } else {
      _waiters.removeFirst().complete();
    }
  }
}
