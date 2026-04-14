import 'dart:math' as math;

import 'package:PiliPlus/plugin/pl_player/models/double_tap_type.dart';

class DoubleTapSeekLayout {
  static const int defaultBackwardPercent = 25;
  static const int defaultForwardPercent = 25;
  static const int minSidePercent = 1;
  static const int maxSidePercent = 40;
  static const int minCenterPercent = 20;

  const DoubleTapSeekLayout({
    required this.backwardPercent,
    required this.forwardPercent,
  });

  final int backwardPercent;
  final int forwardPercent;

  int get centerPercent => 100 - backwardPercent - forwardPercent;

  double get backwardFraction => backwardPercent / 100;

  double get centerFraction => centerPercent / 100;

  double get forwardFraction => forwardPercent / 100;

  static int clampBackwardPercent(int value, {required int forwardPercent}) {
    final safeForward = math.max(
      minSidePercent,
      math.min(forwardPercent, maxSidePercent),
    );
    final maxBackward = math.min(
      maxSidePercent,
      100 - minCenterPercent - safeForward,
    );
    return math.max(minSidePercent, math.min(value, maxBackward));
  }

  static int clampForwardPercent(int value, {required int backwardPercent}) {
    final safeBackward = math.max(
      minSidePercent,
      math.min(backwardPercent, maxSidePercent),
    );
    final maxForward = math.min(
      maxSidePercent,
      100 - minCenterPercent - safeBackward,
    );
    return math.max(minSidePercent, math.min(value, maxForward));
  }

  static double clampBackwardPercentDouble(
    double value, {
    required double forwardPercent,
  }) {
    final safeForward = math.max<double>(
      minSidePercent.toDouble(),
      math.min(forwardPercent, maxSidePercent.toDouble()),
    );
    final maxBackward = math.min<double>(
      maxSidePercent.toDouble(),
      100 - minCenterPercent - safeForward,
    );
    return math.max<double>(
      minSidePercent.toDouble(),
      math.min(value, maxBackward),
    );
  }

  static double clampForwardPercentDouble(
    double value, {
    required double backwardPercent,
  }) {
    final safeBackward = math.max<double>(
      minSidePercent.toDouble(),
      math.min(backwardPercent, maxSidePercent.toDouble()),
    );
    final maxForward = math.min<double>(
      maxSidePercent.toDouble(),
      100 - minCenterPercent - safeBackward,
    );
    return math.max<double>(
      minSidePercent.toDouble(),
      math.min(value, maxForward),
    );
  }

  factory DoubleTapSeekLayout.normalize({
    required int backwardPercent,
    required int forwardPercent,
  }) {
    final safeBackward = clampBackwardPercent(
      backwardPercent,
      forwardPercent: forwardPercent,
    );
    final safeForward = clampForwardPercent(
      forwardPercent,
      backwardPercent: safeBackward,
    );
    return DoubleTapSeekLayout(
      backwardPercent: safeBackward,
      forwardPercent: safeForward,
    );
  }

  DoubleTapType resolveType({
    required double tapPosition,
    required double width,
  }) {
    if (width <= 0) {
      return DoubleTapType.center;
    }
    final backwardWidth = width * backwardFraction;
    if (tapPosition < backwardWidth) {
      return DoubleTapType.left;
    }
    final forwardStart = width * (1 - forwardFraction);
    if (tapPosition >= forwardStart) {
      return DoubleTapType.right;
    }
    return DoubleTapType.center;
  }
}
