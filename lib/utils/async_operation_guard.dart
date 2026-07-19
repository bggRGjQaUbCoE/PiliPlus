import 'dart:async' show Completer, FutureOr;
import 'dart:collection' show Queue;

import 'package:flutter/foundation.dart' show visibleForTesting;

class AsyncOperationGuard {
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  Future<void> run(FutureOr<void> Function() operation) async {
    if (_isProcessing) {
      return;
    }

    _isProcessing = true;
    try {
      await operation();
    } finally {
      _isProcessing = false;
    }
  }
}

class AsyncKeyedOperationGuard<K> {
  final Map<K, AsyncOperationGuard> _guards = {};

  @visibleForTesting
  int get trackedKeyCount => _guards.length;

  Future<void> run(K key, FutureOr<void> Function() operation) async {
    final guard = _guards.putIfAbsent(key, AsyncOperationGuard.new);
    try {
      await guard.run(operation);
    } finally {
      if (!guard.isProcessing && identical(_guards[key], guard)) {
        _guards.remove(key);
      }
    }
  }
}

class AsyncKeyedSerialOperationGuard<Resource, Action> {
  final Map<Resource, _SerialOperationQueue<Action>> _queues = {};

  @visibleForTesting
  int get trackedResourceCount => _queues.length;

  Future<void> run(
    Resource resource,
    Action action,
    FutureOr<void> Function() operation,
  ) {
    final queue = _queues.putIfAbsent(
      resource,
      _SerialOperationQueue<Action>.new,
    );
    return queue.run(action, operation).whenComplete(() {
      if (queue.isIdle && identical(_queues[resource], queue)) {
        _queues.remove(resource);
      }
    });
  }
}

class _SerialOperationQueue<Action> {
  final Queue<_QueuedOperation<Action>> _queue = Queue();
  final Set<Action> _scheduledActions = {};
  bool _isRunning = false;

  bool get isIdle => !_isRunning && _queue.isEmpty;

  Future<void> run(
    Action action,
    FutureOr<void> Function() operation,
  ) {
    if (!_scheduledActions.add(action)) {
      return Future<void>.value();
    }
    final completer = Completer<void>();
    _queue.add((
      action: action,
      operation: operation,
      completer: completer,
    ));
    if (!_isRunning) {
      _drain().ignore();
    }
    return completer.future;
  }

  Future<void> _drain() async {
    _isRunning = true;
    try {
      while (_queue.isNotEmpty) {
        final pending = _queue.removeFirst();
        try {
          await pending.operation();
          pending.completer.complete();
        } catch (error, stackTrace) {
          pending.completer.completeError(error, stackTrace);
        } finally {
          _scheduledActions.remove(pending.action);
        }
      }
    } finally {
      _isRunning = false;
    }
  }
}

typedef _QueuedOperation<Action> = ({
  Action action,
  FutureOr<void> Function() operation,
  Completer<void> completer,
});
