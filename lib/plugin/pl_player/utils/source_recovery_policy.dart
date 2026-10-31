/// Bounds automatic source recovery and filters isolated decoder warnings.
final class SourceRecoveryPolicy {
  static const cooldown = Duration(seconds: 20);
  static const errorWindow = Duration(seconds: 3);
  static const healthyInterval = Duration(seconds: 60);
  static const maxCorruptionRecoveries = 3;
  static const maxRetries = 3;

  DateTime? _lastRecovery;
  DateTime? _lastCorruption;
  int _corruptionCount = 0;
  int _corruptionRecoveries = 0;
  int _retryAttempts = 0;

  bool get hasRetryAttempts => _retryAttempts > 0;

  bool canStart(DateTime now, {bool immediate = false}) =>
      immediate ||
      _lastRecovery == null ||
      now.difference(_lastRecovery!) >= cooldown;

  void started(DateTime now) => _lastRecovery = now;

  /// Only repeated corruption outside the opening/seek grace period triggers
  /// a recovery. A corrupt source cannot produce unlimited successful reloads.
  bool corruption(
    DateTime now, {
    required bool playing,
    required bool seeking,
    DateTime? sourceOpenedAt,
    DateTime? lastSeekAt,
  }) {
    if (!playing ||
        seeking ||
        (sourceOpenedAt != null &&
            now.difference(sourceOpenedAt) < errorWindow) ||
        (lastSeekAt != null && now.difference(lastSeekAt) < errorWindow)) {
      return false;
    }
    final previous = _lastCorruption;
    if (previous == null || now.difference(previous) > healthyInterval) {
      _corruptionRecoveries = 0;
    }
    _corruptionCount =
        previous != null && now.difference(previous) <= errorWindow
        ? _corruptionCount + 1
        : 1;
    _lastCorruption = now;
    if (_corruptionCount < 2 ||
        _corruptionRecoveries >= maxCorruptionRecoveries ||
        !canStart(now)) {
      return false;
    }
    _corruptionCount = 0;
    _corruptionRecoveries++;
    return true;
  }

  Duration? nextRetryDelay() {
    if (_retryAttempts >= maxRetries) return null;
    return Duration(seconds: 5 * (1 << _retryAttempts++));
  }

  void resetRetries() => _retryAttempts = 0;

  void resetForNewSource() {
    _lastRecovery = null;
    _lastCorruption = null;
    _corruptionCount = 0;
    _corruptionRecoveries = 0;
    resetRetries();
  }
}
