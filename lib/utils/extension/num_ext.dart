import 'dart:math' show pow;

import 'package:flutter/widgets.dart';

extension ImageExtension on num {
  int? cacheSize(BuildContext context) {
    if (this == 0) {
      return null;
    }
    return (this * MediaQuery.devicePixelRatioOf(context)).round();
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
}
