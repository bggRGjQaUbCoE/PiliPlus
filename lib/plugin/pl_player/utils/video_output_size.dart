import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// Keep the source aspect ratio in mpv; fitting/stretching stays in Flutter.
Size? videoOutputSize({
  required Size source,
  required Size viewport,
  required double devicePixelRatio,
  required BoxFit fit,
  double? aspectRatio,
  double scale = 1,
}) {
  if (!source.isFinite ||
      source.isEmpty ||
      !viewport.isFinite ||
      viewport.isEmpty ||
      !devicePixelRatio.isFinite ||
      devicePixelRatio <= 0 ||
      !scale.isFinite ||
      scale <= 0) {
    return null;
  }
  final display = Size(
    aspectRatio == null ? source.width : source.height * aspectRatio,
    source.height,
  );
  if (!display.isFinite || display.isEmpty) return null;
  final fitted = applyBoxFit(fit, display / devicePixelRatio, viewport);
  // Use the cropped source region, not the full source, for BoxFit.cover.
  final ratio = math.min(
    1.0,
    math.max(
          fitted.destination.width / fitted.source.width,
          fitted.destination.height / fitted.source.height,
        ) *
        scale,
  );
  return Size(
    (source.width * ratio).ceilToDouble(),
    (source.height * ratio).ceilToDouble(),
  );
}

/// Coalesce layout/zoom changes and serialize asynchronous native calls.
/// Native output notifications can invalidate a previously applied request.
class VideoOutputResize {
  VideoOutputResize({required this.resize, required this.onError});

  final Future<void> Function(Size size) resize;
  final void Function(Object error, StackTrace stackTrace) onError;
  static const delay = Duration(milliseconds: 120);

  Size? _target;
  Size? _output;
  Timer? _timer;
  bool _sending = false;
  bool _pending = false;
  bool _disposed = false;

  void request(Size size) {
    if (_disposed || size == _target) return;
    _target = size;
    _schedule();
  }

  void outputChanged(Size size) {
    if (_disposed) return;
    _output = size;
    _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    _pending = false;
    if (_target == null || _output == _target) return;
    _timer = Timer(delay, () {
      _pending = true;
      unawaited(_flush());
    });
  }

  Future<void> _flush() async {
    if (_sending || _disposed) return;
    _sending = true;
    try {
      while (_pending && !_disposed) {
        _pending = false;
        final target = _target!;
        try {
          await resize(target);
        } catch (error, stackTrace) {
          if (!_disposed) onError(error, stackTrace);
        }
      }
    } finally {
      _sending = false;
    }
  }

  /// Hidden routes must not compete with the visible surface for the same player.
  void suspend() {
    _target = null;
    _timer?.cancel();
    _pending = false;
  }

  void dispose() {
    _disposed = true;
    suspend();
  }
}
