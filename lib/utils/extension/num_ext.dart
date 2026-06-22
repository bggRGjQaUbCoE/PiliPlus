import 'dart:math' show pow;

import 'package:flutter/foundation.dart' show PlatformDispatcher;

const unitArr = ['B', 'K', 'M', 'G', 'T', 'P'];

final devicePixelRatio =
    PlatformDispatcher.instance.views.first.devicePixelRatio;

extension NumExt on num {
  int? get cacheSize {
    if (this == 0) {
      return null;
    }
    return (this * devicePixelRatio).round();
  }

  String get formatSize {
    var value = this;
    int index = 0;
    while (value >= 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + (unitArr.elementAtOrNull(index) ?? '');
  }
}

extension IntExt on int? {
  int? operator +(int other) => this == null ? null : this! + other;
  int? operator -(int other) => this == null ? null : this! - other;
}

extension DoubleExt on double {
  double toPrecision(int fractionDigits) {
    final mod = pow(10, fractionDigits).toDouble();
    return (this * mod).roundToDouble() / mod;
  }

  bool equals(double other, [double epsilon = 1e-10]) =>
      (this - other).abs() < epsilon;

  double lerp(double a, double b) {
    assert(
      a.isFinite,
      'Cannot interpolate between finite and non-finite values',
    );
    assert(
      b.isFinite,
      'Cannot interpolate between finite and non-finite values',
    );
    assert(isFinite, 't must be finite when interpolating between values');
    return a * (1.0 - this) + b * this;
  }
}
