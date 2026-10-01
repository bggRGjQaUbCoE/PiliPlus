import 'dart:async';

/// Sanitized snapshots only: hosts, not signed media URLs or session tokens.
abstract final class AcceleratorDiagnostics {
  static Map<String, Object?> latest = const {'state': 'off'};
  static final _updates = StreamController<Map<String, Object?>>.broadcast();
  static Stream<Map<String, Object?>> get updates => _updates.stream;
  static void publish(Map<String, Object?> snapshot) {
    latest = Map.unmodifiable(snapshot);
    _updates.add(latest);
  }
}
