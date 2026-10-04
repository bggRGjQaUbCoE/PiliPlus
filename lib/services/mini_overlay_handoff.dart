import 'package:flutter/foundation.dart';

/// The visible view is removed before a playback route is restored. The
/// pending lease keeps the media session alive until that route adopts it.
class MiniOverlayHandoff<T> {
  final ValueNotifier<T?> visible = ValueNotifier(null);
  T? _pending;

  T? get pending => _pending;

  bool show(T session) {
    if (_pending != null) return false;
    visible.value = session;
    return true;
  }

  T? beginRestore() {
    final session = visible.value;
    if (session == null || _pending != null) return null;
    _pending = session;
    visible.value = null;
    return session;
  }

  T? takePending() {
    final session = _pending;
    _pending = null;
    return session;
  }

  T? hideVisible() {
    final session = visible.value;
    visible.value = null;
    return session;
  }
}
