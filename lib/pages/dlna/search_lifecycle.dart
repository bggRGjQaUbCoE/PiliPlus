import 'dart:async' show FutureOr;

final class SearchLifecycle<T extends Object> {
  SearchLifecycle({
    required this.startOperation,
    required this.stopOperation,
  });

  final Future<T> Function() startOperation;
  final FutureOr<void> Function() stopOperation;

  bool _isSearching = false;
  bool _isDisposed = false;

  bool get isSearching => _isSearching;

  Future<T?> start() async {
    if (_isDisposed || _isSearching) return null;
    _isSearching = true;
    try {
      final resource = await startOperation();
      if (_isDisposed) {
        await stopOperation();
        return null;
      }
      return resource;
    } catch (_) {
      await stopOperation();
      rethrow;
    } finally {
      _isSearching = false;
    }
  }

  Future<void> stop() async {
    await stopOperation();
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await stopOperation();
  }
}
