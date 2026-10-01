import 'dart:math' as math;

import 'package:PiliPlus/services/video_accelerator/accelerator_config.dart';

/// Time-weighted, debiased EWMA. Values are bits/second, never bytes/second.
class ThroughputEwma {
  ThroughputEwma(this.halfLifeSeconds);
  final double halfLifeSeconds;
  double _estimate = 0, _weight = 0;

  void sample(double seconds, double bitsPerSecond) {
    if (seconds <= 0 ||
        !seconds.isFinite ||
        bitsPerSecond < 0 ||
        !bitsPerSecond.isFinite) {
      return;
    }
    final decay = math.pow(0.5, seconds / halfLifeSeconds).toDouble();
    _estimate = _estimate * decay + bitsPerSecond * (1 - decay);
    _weight += seconds;
  }

  double? get value => _weight == 0
      ? null
      : _estimate / (1 - math.pow(0.5, _weight / halfLifeSeconds));
}

class CdnStats {
  CdnStats([AcceleratorConfig config = const AcceleratorConfig()])
    : fast = ThroughputEwma(config.ewmaFastHalfLifeSeconds),
      slow = ThroughputEwma(config.ewmaSlowHalfLifeSeconds);
  final ThroughputEwma fast, slow;
  int errors = 0, timeouts = 0, successes = 0;
  Duration? lastSuccess, blockedUntil, ttfb;
  double? get throughputBps {
    final a = fast.value, b = slow.value;
    return a == null || b == null ? null : math.min(a, b);
  }

  void success(int bytes, Duration elapsed, Duration firstByte, Duration now) {
    final seconds = elapsed.inMicroseconds / 1e6;
    if (seconds <= 0) return;
    final rate = bytes * 8 / seconds;
    fast.sample(seconds, rate);
    slow.sample(seconds, rate);
    successes++;
    lastSuccess = now;
    ttfb = firstByte;
    blockedUntil = null;
  }

  bool available(Duration now) => blockedUntil == null || now >= blockedUntil!;
  bool fresh(Duration now, Duration ttl) =>
      lastSuccess != null && now - lastSuccess! < ttl;
}
