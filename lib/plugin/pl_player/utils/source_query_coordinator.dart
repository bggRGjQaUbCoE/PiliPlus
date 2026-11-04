/// Shares a query for the same source revision without blocking a newer one.
final class SourceQueryCoordinator {
  Future<bool>? _future;
  int? _revision;

  bool get isRunning => _future != null;
  Future<bool>? get current => _future;

  Future<bool> run(int revision, Future<bool> Function() query) {
    final running = _future;
    if (running != null && _revision == revision) return running;

    late final Future<bool> future;
    future = Future<bool>.sync(query).whenComplete(() {
      if (identical(_future, future)) {
        _future = null;
        _revision = null;
      }
    });
    _future = future;
    _revision = revision;
    return future;
  }

  void clear() {
    _future = null;
    _revision = null;
  }
}
