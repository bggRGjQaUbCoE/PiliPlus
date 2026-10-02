import 'dart:math' as math;

import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/grpc/dm.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

abstract final class DanmakuDensityTrend {
  static const int segmentLengthMs = 60 * 6 * 1000;
  static const int _targetPointCount = 400;
  static const int _minStepMs = 1000;
  static const int _defaultFontSize = 25;
  static const int _maxConcurrentRequests = 2;
  static const double _densityPower = 0.8;

  static const double _baseWindowMs = 8000.0;
  static const double _baseDensityPerMin = 10.0;
  static const double _minWindowMs = 2000.0;
  static const double _maxWindowMs = 20000.0;

  /// 拉取指定分P(cid)的全部分段弹幕，失败或取消返回 null。
  ///
  /// [build] 可复用该结果以避免重复请求。
  static Future<List<DanmakuElem>?> fetchAll({
    required int cid,
    required int durationMs,
    bool Function()? shouldCancel,
  }) async {
    if (durationMs <= 0 || cid <= 0) return null;

    final segmentCount = (durationMs / segmentLengthMs).ceil();
    var successCount = 0;
    final allElems = <DanmakuElem>[];

    Future<void> requestSegment(int segmentIndex) async {
      if (shouldCancel?.call() == true) return;
      try {
        final res = await DmGrpc.dmSegMobile(
          cid: cid,
          segmentIndex: segmentIndex,
        );
        if (shouldCancel?.call() == true) return;
        if (res case Success(:final response)) {
          successCount++;
          allElems.addAll(response.elems);
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('DanmakuDensityTrend segment=$segmentIndex: $e');
        }
      }
    }

    var nextSegment = 1;
    Future<void> worker() async {
      while (true) {
        if (shouldCancel?.call() == true) return;
        final segmentIndex = nextSegment++;
        if (segmentIndex > segmentCount) return;
        await requestSegment(segmentIndex);
      }
    }

    final workerCount = math.min(_maxConcurrentRequests, segmentCount);
    await Future.wait(List.generate(workerCount, (_) => worker()));

    if (shouldCancel?.call() == true) return null;
    if (successCount == 0 || allElems.isEmpty) return null;
    return allElems;
  }

  static Future<List<double>?> build({
    required int cid,
    required int durationMs,
    bool Function()? shouldCancel,
    List<DanmakuElem>? elems,
  }) async {
    if (durationMs <= 0) return null;

    final allElems =
        elems ??
        await fetchAll(
          cid: cid,
          durationMs: durationMs,
          shouldCancel: shouldCancel,
        );
    if (allElems == null) return null;

    final int stepMs = math.max(
      _minStepMs,
      durationMs ~/ _targetPointCount,
    ).toInt();
    final pointCount = (durationMs / stepMs).ceil() + 1;
    if (pointCount <= 1) return null;

    final validElems = allElems.where(_isDensityElem).toList();
    if (validElems.isEmpty) return null;

    final densityWindowMs = _calculateDynamicWindow(
      validElems.length,
      durationMs,
    );

    final result = _buildGaussian(
      validElems,
      pointCount: pointCount,
      stepMs: stepMs,
      durationMs: durationMs,
      densityWindowMs: densityWindowMs,
    );

    if (result == null) return null;

    final density = validElems.length / (durationMs / 60000);
    final smoothCount = density > 50 ? 3 : (density > 20 ? 1 : 0);

    var smoothed = result;
    for (var pass = 0; pass < smoothCount; pass++) {
      smoothed = _smoothGaussian(smoothed);
    }

    return smoothed;
  }

  static double _calculateDynamicWindow(int elemCount, int durationMs) {
    if (durationMs <= 0 || elemCount <= 0) return _minWindowMs;

    final durationMinutes = durationMs / 1000 / 60;
    final density = elemCount / durationMinutes;

    final densityFactor = math.sqrt(math.max(1.0, density / _baseDensityPerMin));
    final calculatedWindow = _baseWindowMs / densityFactor;

    final maxAllowedWindow = durationMs * 0.12;
    return calculatedWindow.clamp(_minWindowMs, _maxWindowMs).clamp(0, maxAllowedWindow);
  }

  static List<double>? _buildGaussian(
    List<DanmakuElem> elems, {
    required int pointCount,
    required int stepMs,
    required int durationMs,
    required double densityWindowMs,
  }) {
    final result = List<double>.filled(pointCount, 0.0);
    final sigma = densityWindowMs / 3.0;
    final range = 3.0 * sigma;
    final twoSigmaSq = 2.0 * sigma * sigma;

    for (final elem in elems) {
      final progress = elem.progress;
      if (progress < 0 || progress > durationMs) continue;

      final weight = _dispval(elem);
      if (weight <= 0) continue;

      final startIdx = ((progress - range) / stepMs).floor().clamp(0, pointCount - 1);
      final endIdx = ((progress + range) / stepMs).ceil().clamp(0, pointCount - 1);

      for (var i = startIdx; i <= endIdx; i++) {
        final ti = i * stepMs;
        final dt = ti - progress;
        final gauss = math.exp(-(dt * dt) / twoSigmaSq);
        result[i] += weight * gauss;
      }
    }

    for (var i = 0; i < result.length; i++) {
      result[i] = math.pow(result[i], _densityPower).toDouble();
    }

    final maxVal = result.reduce(math.max);
    return maxVal > 0 ? result : null;
  }

  static List<double> _smoothGaussian(List<double> data) {
    final smoothed = List<double>.filled(data.length, 0.0);
    smoothed[0] = data[0];
    smoothed[data.length - 1] = data[data.length - 1];
    for (var i = 1; i < data.length - 1; i++) {
      smoothed[i] = data[i - 1] * 0.25 + data[i] * 0.5 + data[i + 1] * 0.25;
    }
    return smoothed;
  }

  static bool _isDensityElem(DanmakuElem elem) {
    if (elem.content.isEmpty) return false;
    // Code/BAS danmaku are not normal on-screen text density.
    if (elem.mode == 8 || elem.mode == 9) return false;
    return true;
  }

  /// Weighted density contribution inspired by pakku.js `dispval()`.
  static double _dispval(DanmakuElem elem) {
    final textLength = elem.content.characters.length;
    if (textLength <= 0) return 0;

    final fontSize = elem.fontsize > 0 ? elem.fontsize : _defaultFontSize;
    final sizeFactor = (fontSize / _defaultFontSize).clamp(0.7, 2.5);
    return math.sqrt(textLength) * math.pow(sizeFactor, 1.5).toDouble();
  }
}
