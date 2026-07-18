typedef LatestRequestOperation<T> =
    Future<void> Function(T request, bool Function() isCurrent);
typedef LatestRequestMerge<T> = T Function(T previous, T next);

typedef VideoRequestIntent = ({
  bool fromReset,
  bool autoFullScreenFlag,
  int? initialProgress,
});

VideoRequestIntent mergeVideoRequestIntent(
  VideoRequestIntent previous,
  VideoRequestIntent next,
) => (
  fromReset: previous.fromReset && next.fromReset,
  autoFullScreenFlag: previous.autoFullScreenFlag || next.autoFullScreenFlag,
  initialProgress: previous.initialProgress ?? next.initialProgress,
);

class LatestRequestRunner<T> {
  LatestRequestRunner(this._operation, {this.merge});

  final LatestRequestOperation<T> _operation;
  final LatestRequestMerge<T>? merge;

  late T _latestRequest;
  int _latestRequestId = 0;
  Future<void>? _activeRequest;

  bool get isRunning => _activeRequest != null;

  Future<void> run(T request) {
    if (_activeRequest case final activeRequest?) {
      _latestRequest = switch (merge) {
        final merge? => merge(_latestRequest, request),
        null => request,
      };
      _latestRequestId += 1;
      return activeRequest;
    }

    _latestRequest = request;
    _latestRequestId += 1;
    final future = Future<void>.microtask(_drain);
    _activeRequest = future;
    return future;
  }

  Future<void> _drain() async {
    try {
      while (true) {
        final requestId = _latestRequestId;
        final request = _latestRequest;

        try {
          await _operation(
            request,
            () => requestId == _latestRequestId,
          );
        } catch (_) {
          if (requestId == _latestRequestId) {
            rethrow;
          }
        }

        if (requestId == _latestRequestId) {
          return;
        }
      }
    } finally {
      _activeRequest = null;
    }
  }
}
