import 'dart:async';

const _playbackMetricProperties = <String>[
  'estimated-vf-fps',
  'frame-drop-count',
  'decoder-frame-drop-count',
];

/// One read-only sample of mpv's `estimated-vf-fps` estimate and source-session
/// drop counters. FPS comes from that property, not a physical display counter.
class PlaybackMetricSnapshot {
  const PlaybackMetricSnapshot({
    required this.estimatedFps,
    required this.voDrops,
    required this.decoderDrops,
    required this.paused,
  });

  final String estimatedFps;
  final String voDrops;
  final String decoderDrops;
  final bool paused;

  String get estimatedFpsLabel => paused ? '暂停' : estimatedFps;

  String get displayText =>
      'FPS=$estimatedFpsLabel 累计丢帧 VO=$voDrops 解码=$decoderDrops';

  PlaybackMetricSnapshot copyWith({bool? paused}) => PlaybackMetricSnapshot(
    estimatedFps: estimatedFps,
    voDrops: voDrops,
    decoderDrops: decoderDrops,
    paused: paused ?? this.paused,
  );

  factory PlaybackMetricSnapshot.unknown({required bool paused}) =>
      PlaybackMetricSnapshot(
        estimatedFps: '?',
        voDrops: '?',
        decoderDrops: '?',
        paused: paused,
      );

  static String _number(String? value, {required bool decimal}) {
    if (value == null) return '?';
    final parsed = num.tryParse(value.trim());
    if (parsed == null || !parsed.isFinite || parsed < 0) return '?';
    if (!decimal && parsed != parsed.roundToDouble()) return '?';
    if (decimal && parsed == 0) return '?';
    if (!decimal) return parsed.toInt().toString();
    final text = parsed.toStringAsFixed(2);
    return text.endsWith('.00')
        ? text.substring(0, text.length - 3)
        : text.endsWith('0')
        ? text.substring(0, text.length - 1)
        : text;
  }

  factory PlaybackMetricSnapshot.fromProperties(
    Map<String, String?> properties, {
    required bool paused,
  }) => PlaybackMetricSnapshot(
    estimatedFps: _number(properties['estimated-vf-fps'], decimal: true),
    voDrops: _number(properties['frame-drop-count'], decimal: false),
    decoderDrops: _number(
      properties['decoder-frame-drop-count'],
      decimal: false,
    ),
    paused: paused,
  );
}

/// Timer-backed, serial sampler. Stopping invalidates pending reads so they
/// cannot publish after the UI hides or the player/source is replaced.
class PlaybackMetricSampler {
  PlaybackMetricSampler({
    required this.readProperty,
    required this.onSample,
    this.interval = const Duration(seconds: 1),
    this.propertyTimeout = const Duration(seconds: 1),
  });

  final Future<String> Function(String property) readProperty;
  final void Function(PlaybackMetricSnapshot sample) onSample;
  final Duration interval;
  final Duration propertyTimeout;
  Timer? _timer;
  bool _inFlight = false;
  bool _disposed = false;
  int _generation = 0;
  bool _paused = false;

  bool get isRunning => _timer != null;

  void start({required bool paused}) {
    if (_disposed || _timer != null) return;
    _paused = paused;
    final generation = ++_generation;
    _timer = Timer.periodic(interval, (_) => unawaited(_sample(generation)));
    unawaited(_sample(generation));
  }

  void setPaused(bool paused) {
    _paused = paused;
  }

  Future<void> _sample(int generation) async {
    if (_disposed || _timer == null || generation != _generation || _inFlight) {
      return;
    }
    _inFlight = true;
    final values = <String, String?>{};
    try {
      for (final property in _playbackMetricProperties) {
        final rawFuture = Future<String>.sync(() => readProperty(property));
        try {
          values[property] = await rawFuture.timeout(propertyTimeout);
        } on TimeoutException {
          if (!_disposed && _timer != null && generation == _generation) {
            onSample(PlaybackMetricSnapshot.unknown(paused: _paused));
          }
          // Keep the in-flight guard until the underlying player call settles.
          // Future.timeout alone would allow periodic calls to pile up behind
          // a property getter that never returns.
          await rawFuture.then<void>((_) {}, onError: (Object _) {});
          return;
        } catch (_) {
          values[property] = null;
        }
        if (_disposed || _timer == null || generation != _generation) return;
      }
      onSample(
        PlaybackMetricSnapshot.fromProperties(values, paused: _paused),
      );
    } finally {
      _inFlight = false;
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _generation++;
  }

  void dispose() {
    stop();
    _disposed = true;
  }
}
