import 'dart:async' show FutureOr;

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
