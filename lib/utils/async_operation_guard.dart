import 'dart:async' show FutureOr;

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
