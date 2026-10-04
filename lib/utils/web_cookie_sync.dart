import 'dart:async';

/// Serializes writes to the shared WebView cookie store. A stale account may
/// finish an HTTP login check after a newer account is selected; it must never
/// overwrite that newer account's browser session.
class WebCookieSync<T extends Object> {
  WebCookieSync({
    required this.current,
    required this.replace,
    required this.merge,
    required this.clear,
  });

  final T Function() current;
  final Future<void> Function(T) replace;
  final Future<void> Function(T) merge;
  final Future<void> Function() clear;

  Future<void> _tail = Future<void>.value();

  Future<void> _serial(Future<void> Function() operation) {
    final pending = _tail.then((_) => operation());
    // An earlier failure must not permanently poison the queue. The caller
    // still receives and handles the failure from its own pending future.
    _tail = pending.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return pending;
  }

  Future<void> mergeIfCurrent(T expected) => _serial(() async {
    if (!identical(current(), expected)) return;
    await merge(expected);
    if (!identical(current(), expected)) await clear();
  });

  Future<void> replaceIfCurrent(T expected) => _serial(() async {
    if (!identical(current(), expected)) return;
    await replace(expected);
    if (!identical(current(), expected)) await clear();
  });

  Future<void> clearIfCurrent(T expected) => _serial(() async {
    if (identical(current(), expected)) await clear();
  });

  /// Runs after all earlier account changes and fails closed if the selected
  /// account changes before or during the replacement.
  Future<void> prepare(T expected) => _serial(() async {
    if (!identical(current(), expected)) {
      throw StateError('WebView account changed before synchronization');
    }
    await replace(expected);
    if (!identical(current(), expected)) {
      await clear();
      throw StateError('WebView account changed during synchronization');
    }
  });
}
