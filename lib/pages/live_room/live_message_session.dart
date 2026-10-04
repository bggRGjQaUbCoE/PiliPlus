import 'dart:async';

enum LiveMessageConnectionState {
  connecting('弹幕连接中'),
  connected('弹幕已连接'),
  retrying('弹幕重连中'),
  stopped('弹幕连接失败，点击重试'),
  suspended('弹幕已暂停');

  const LiveMessageConnectionState(this.label);
  final String label;
}

/// Owns one room/account message session. Every asynchronous attempt gets a
/// different generation, including retries, so late tokens/events are inert.
class LiveMessageSession {
  LiveMessageSession({
    required this.connect,
    required this.disconnect,
    required this.onState,
    this.onConnected,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
      Duration(seconds: 8),
      Duration(seconds: 15),
    ],
    this.attemptTimeout = const Duration(seconds: 25),
    this.stablePeriod = const Duration(seconds: 60),
  });

  final Future<bool> Function(int generation) connect;
  final void Function() disconnect;
  final void Function(LiveMessageConnectionState) onState;
  final void Function(int generation)? onConnected;
  final List<Duration> retryDelays;
  final Duration attemptTimeout;
  final Duration stablePeriod;
  Timer? _retryTimer;
  Timer? _stableTimer;
  int _generation = 0;
  int _failures = 0;
  bool _running = false;
  bool _disposed = false;

  bool get running => _running;
  int get generation => _generation;
  bool isCurrent(int generation) =>
      _running && !_disposed && generation == _generation;

  void start({bool restart = false}) {
    if (_disposed || (_running && !restart)) return;
    stop();
    _running = true;
    _failures = 0;
    _attempt();
  }

  Future<void> _attempt() async {
    if (!_running || _disposed) return;
    final generation = ++_generation;
    disconnect();
    onState(
      _failures == 0
          ? LiveMessageConnectionState.connecting
          : LiveMessageConnectionState.retrying,
    );
    bool connected;
    try {
      connected = await connect(generation).timeout(attemptTimeout);
    } catch (_) {
      connected = false;
    }
    if (!isCurrent(generation)) return;
    if (!connected) {
      connectionLost(generation);
      return;
    }
    onState(LiveMessageConnectionState.connected);
    onConnected?.call(generation);
    // A connection that repeatedly authenticates and immediately disconnects
    // still exhausts its budget. Only a stable interval resets it.
    _stableTimer?.cancel();
    _stableTimer = Timer(stablePeriod, () {
      if (isCurrent(generation)) _failures = 0;
    });
  }

  void connectionLost(int generation) {
    if (!isCurrent(generation)) return;
    ++_generation;
    _stableTimer?.cancel();
    _stableTimer = null;
    disconnect();
    if (_failures >= retryDelays.length) {
      _running = false;
      onState(LiveMessageConnectionState.stopped);
      return;
    }
    final delay = retryDelays[_failures++];
    onState(LiveMessageConnectionState.retrying);
    _retryTimer?.cancel();
    _retryTimer = Timer(delay, _attempt);
  }

  void stop() {
    _running = false;
    ++_generation;
    _retryTimer?.cancel();
    _retryTimer = null;
    _stableTimer?.cancel();
    _stableTimer = null;
    disconnect();
    if (!_disposed) onState(LiveMessageConnectionState.suspended);
  }

  void dispose() {
    stop();
    _disposed = true;
  }
}
