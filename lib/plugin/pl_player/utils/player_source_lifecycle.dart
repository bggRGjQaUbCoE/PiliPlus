/// Tracks source requests owned by one application controller.
class PlayerSourceLifecycle {
  int _request = 0;
  bool _closed = false;

  int? get currentRequest => _closed ? null : _request;

  int beginRequest() => ++_request;

  bool isCurrent(int request) => !_closed && request == _request;

  void close() {
    _closed = true;
    _request++;
  }
}

/// Makes a request visible only while a synchronous callback dispatch begins.
/// Async callbacks must capture the request when they synchronously call play.
class SourceCallbackRequestScope {
  int? _request;

  int? get currentRequest => _request;

  int? capture([int? explicitRequest]) => explicitRequest ?? _request;

  Future<void>? dispatch(int request, Future<void>? Function() callback) {
    final previous = _request;
    _request = request;
    try {
      return callback();
    } finally {
      _request = previous;
    }
  }
}
