import 'dart:async' show Completer;

typedef AudioRequestOperation =
    Future<bool> Function(bool Function() isCurrent);

class LatestAudioRequestCoordinator {
  int _generation = 0;
  bool _closed = false;

  Future<bool> run(AudioRequestOperation operation) async {
    final generation = ++_generation;
    bool isCurrent() => !_closed && generation == _generation;

    final result = await operation(isCurrent);
    return result && isCurrent();
  }

  void close() {
    _closed = true;
    _generation++;
  }
}

class SharedAsyncInitializer<T extends Object> {
  SharedAsyncInitializer({this.disposeDiscarded});

  final Future<void> Function(T value)? disposeDiscarded;
  Future<T?>? _initializing;
  T? _value;
  int _generation = 0;

  Future<T?> getOrCreate(Future<T> Function() create) async {
    if (_value case final value?) {
      return value;
    }
    if (_initializing case final initializing?) {
      return initializing;
    }

    final generation = _generation;
    late final Future<T?> initializing;
    initializing = () async {
      try {
        final value = await create();
        if (generation == _generation) {
          _value = value;
          return value;
        }
        await disposeDiscarded?.call(value);
        return null;
      } finally {
        if (identical(_initializing, initializing)) {
          _initializing = null;
        }
      }
    }();
    _initializing = initializing;
    return initializing;
  }

  Future<void> clear() async {
    _generation++;
    final value = _value;
    _value = null;
    _initializing = null;
    if (value != null) {
      await disposeDiscarded?.call(value);
    }
  }
}

class SerializedAudioOpener {
  Future<void> _tail = Future<void>.value();

  Future<bool> run({
    required bool Function() isCurrent,
    required Future<bool> Function() open,
    required Future<void> Function() onStale,
  }) async {
    final previous = _tail;
    final completed = Completer<void>();
    _tail = completed.future;
    try {
      await previous;
      if (!isCurrent()) return false;
      late final bool opened;
      try {
        opened = await open();
      } catch (_) {
        await onStale();
        rethrow;
      }
      if (!opened || !isCurrent()) {
        await onStale();
        return false;
      }
      return true;
    } finally {
      completed.complete();
    }
  }
}

Future<bool> openCurrentAudioUrl({
  required String? url,
  required bool Function() isCurrent,
  required Future<bool> Function(String url) open,
}) async {
  final normalizedUrl = url?.trim();
  if (normalizedUrl == null || normalizedUrl.isEmpty || !isCurrent()) {
    return false;
  }
  final opened = await open(normalizedUrl);
  return opened && isCurrent();
}
