import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class PlayIcon extends LeafRenderObjectWidget {
  const PlayIcon({super.key, this.size = 60});

  final double size;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPlay(size);
  }

  @override
  void updateRenderObject(BuildContext context, RenderPlay renderObject) {
    renderObject.imgSize = size;
  }
}

class RenderPlay extends RenderBox {
  RenderPlay(this._imgSize);

  double _imgSize;
  set imgSize(double value) {
    if (_imgSize == value) return;
    _imgSize = value;
    markNeedsLayout();
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return constraints.constrainDimensions(_imgSize, _imgSize);
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final size = this.size.shortestSide;
    if (offset != .zero || size != 60) {
      canvas.save();
      if (offset != .zero) canvas.translate(offset.dx, offset.dy);
      if (size != 60) {
        canvas.scale(size / 60);
      }
    }
    canvas.drawPicture(_picture);
    if (offset != .zero || size != 60) {
      canvas.restore();
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.label = '播放';
  }

  /// [SvgPicture] can not parse mask filter
  /// fom i0.hdslb.com/bfs/static/player/img/play.svg
  /// scale size from 80 to 60
  static final _picture = () {
    final rec = PictureRecorder();
    final canvas = Canvas(rec);
    final path = Path()
      ..moveTo(41.576, 7.318)
      ..cubicTo(41.244, 5.892, 39.91, 4.886, 38.41, 5.011)
      ..cubicTo(38.068, 5.039, 37.813, 5.13, 37.59, 5.245)
      ..cubicTo(37.37, 5.361, 37.187, 5.506, 37.034, 5.672)
      ..cubicTo(36.957, 5.754, 36.891, 5.844, 36.824, 5.934)
      ..lineTo(36.622, 6.203)
      ..lineTo(36.222, 6.743)
      ..cubicTo(35.694, 7.467, 35.178, 8.2, 34.678, 8.945)
      ..cubicTo(34.179, 9.69, 33.694, 10.445, 33.231, 11.217)
      ..cubicTo(33.092, 11.449, 32.954, 11.683, 32.819, 11.917)
      ..cubicTo(32.258, 11.909, 31.697, 11.902, 31.137, 11.898)
      ..cubicTo(29.094, 11.884, 27.051, 11.891, 25.008, 11.926)
      ..cubicTo(24.871, 11.688, 24.732, 11.452, 24.591, 11.217)
      ..cubicTo(24.128, 10.445, 23.643, 9.69, 23.144, 8.945)
      ..cubicTo(22.645, 8.2, 22.129, 7.467, 21.6, 6.743)
      ..lineTo(21.2, 6.203)
      ..lineTo(20.998, 5.934)
      ..cubicTo(20.931, 5.844, 20.865, 5.754, 20.788, 5.672)
      ..cubicTo(20.635, 5.506, 20.452, 5.361, 20.232, 5.245)
      ..cubicTo(20.009, 5.13, 19.754, 5.039, 19.412, 5.011)
      ..cubicTo(17.956, 4.888, 16.59, 5.85, 16.246, 7.318)
      ..cubicTo(16.168, 7.652, 16.176, 7.924, 16.217, 8.172)
      ..cubicTo(16.26, 8.418, 16.34, 8.636, 16.451, 8.833)
      ..cubicTo(16.506, 8.931, 16.571, 9.023, 16.635, 9.114)
      ..lineTo(16.829, 9.389)
      ..lineTo(17.219, 9.936)
      ..cubicTo(17.743, 10.663, 18.281, 11.381, 18.834, 12.086)
      ..cubicTo(18.845, 12.099, 18.855, 12.112, 18.865, 12.124)
      ..cubicTo(18.025, 12.164, 17.184, 12.209, 16.344, 12.26)
      ..cubicTo(15.523, 12.311, 14.701, 12.365, 13.88, 12.428)
      ..lineTo(12.648, 12.525)
      ..lineTo(12.032, 12.577)
      ..lineTo(11.68, 12.616)
      ..cubicTo(11.562, 12.63, 11.445, 12.651, 11.328, 12.668)
      ..cubicTo(10.39, 12.827, 9.477, 13.141, 8.641, 13.595)
      ..cubicTo(7.804, 14.049, 7.043, 14.641, 6.399, 15.34)
      ..cubicTo(5.754, 16.04, 5.224, 16.845, 4.837, 17.716)
      ..cubicTo(4.45, 18.586, 4.208, 19.521, 4.12, 20.467)
      ..cubicTo(3.808, 23.756, 3.603, 27.055, 3.529, 30.365)
      ..cubicTo(3.453, 33.676, 3.53, 36.99, 3.722, 40.289)
      ..cubicTo(3.77, 41.114, 3.825, 41.939, 3.887, 42.763)
      ..lineTo(3.986, 43.998)
      ..lineTo(4.039, 44.616)
      ..lineTo(4.046, 44.693)
      ..lineTo(4.056, 44.782)
      ..lineTo(4.075, 44.961)
      ..cubicTo(4.087, 45.08, 4.107, 45.198, 4.126, 45.317)
      ..cubicTo(4.278, 46.264, 4.586, 47.189, 5.037, 48.037)
      ..cubicTo(5.486, 48.887, 6.078, 49.66, 6.777, 50.319)
      ..cubicTo(7.475, 50.978, 8.283, 51.522, 9.16, 51.921)
      ..cubicTo(10.035, 52.319, 10.978, 52.575, 11.935, 52.664)
      ..cubicTo(11.998, 52.672, 12.047, 52.675, 12.098, 52.68)
      ..lineTo(12.252, 52.693)
      ..lineTo(12.56, 52.72)
      ..lineTo(13.176, 52.771)
      ..lineTo(14.408, 52.868)
      ..cubicTo(15.23, 52.927, 16.052, 52.985, 16.874, 53.033)
      ..cubicTo(23.449, 53.424, 30.03, 53.502, 36.609, 53.259)
      ..cubicTo(38.254, 53.199, 39.898, 53.118, 41.542, 53.016)
      ..cubicTo(42.364, 52.963, 43.186, 52.908, 44.008, 52.843)
      ..lineTo(45.241, 52.743)
      ..lineTo(45.857, 52.689)
      ..lineTo(46.214, 52.65)
      ..cubicTo(46.334, 52.635, 46.452, 52.614, 46.571, 52.596)
      ..cubicTo(47.52, 52.432, 48.443, 52.112, 49.288, 51.649)
      ..cubicTo(50.134, 51.188, 50.902, 50.586, 51.553, 49.878)
      ..cubicTo(52.204, 49.17, 52.739, 48.353, 53.127, 47.471)
      ..cubicTo(53.321, 47.03, 53.479, 46.573, 53.598, 46.107)
      ..cubicTo(53.631, 45.991, 53.656, 45.873, 53.681, 45.755)
      ..lineTo(53.719, 45.579)
      ..lineTo(53.749, 45.401)
      ..cubicTo(53.77, 45.283, 53.79, 45.164, 53.803, 45.045)
      ..cubicTo(53.818, 44.927, 53.834, 44.8, 53.843, 44.704)
      ..cubicTo(54.179, 41.414, 54.402, 38.111, 54.476, 34.794)
      ..cubicTo(54.553, 31.475, 54.442, 28.153, 54.205, 24.853)
      ..cubicTo(54.145, 24.028, 54.078, 23.204, 54.002, 22.38)
      ..lineTo(53.884, 21.145)
      ..lineTo(53.82, 20.528)
      ..lineTo(53.804, 20.374)
      ..lineTo(53.794, 20.29)
      ..lineTo(53.782, 20.201)
      ..cubicTo(53.766, 20.083, 53.754, 19.964, 53.731, 19.846)
      ..cubicTo(53.578, 18.901, 53.266, 17.979, 52.813, 17.136)
      ..cubicTo(52.362, 16.291, 51.771, 15.522, 51.073, 14.869)
      ..cubicTo(50.375, 14.215, 49.57, 13.677, 48.698, 13.284)
      ..cubicTo(47.827, 12.89, 46.89, 12.64, 45.94, 12.552)
      ..lineTo(45.854, 12.544)
      ..lineTo(45.777, 12.537)
      ..lineTo(45.623, 12.524)
      ..lineTo(45.315, 12.499)
      ..lineTo(44.698, 12.449)
      ..lineTo(43.466, 12.357)
      ..cubicTo(42.644, 12.3, 41.822, 12.247, 41.0, 12.202)
      ..cubicTo(40.326, 12.164, 39.651, 12.131, 38.977, 12.1)
      ..cubicTo(38.98, 12.096, 38.984, 12.091, 38.988, 12.086)
      ..cubicTo(39.542, 11.381, 40.079, 10.663, 40.603, 9.936)
      ..lineTo(40.994, 9.389)
      ..lineTo(41.187, 9.114)
      ..cubicTo(41.252, 9.023, 41.316, 8.931, 41.371, 8.833)
      ..cubicTo(41.482, 8.636, 41.563, 8.418, 41.605, 8.172)
      ..cubicTo(41.646, 7.924, 41.654, 7.652, 41.576, 7.318)
      ..close()
      ..moveTo(21.283, 26.038)
      ..cubicTo(21.321, 25.666, 21.427, 25.305, 21.597, 24.973)
      ..cubicTo(22.351, 23.498, 24.158, 22.913, 25.634, 23.667)
      ..lineTo(26.683, 24.211)
      ..cubicTo(28.428, 25.126, 30.148, 26.088, 31.842, 27.097)
      ..cubicTo(34.726, 28.814, 34.726, 28.814, 37.376, 30.628)
      ..cubicTo(37.694, 30.846, 37.967, 31.123, 38.18, 31.444)
      ..cubicTo(39.096, 32.824, 38.72, 34.686, 37.34, 35.603)
      ..lineTo(36.265, 36.309)
      ..cubicTo(34.823, 37.245, 33.349, 38.161, 31.842, 39.058)
      ..cubicTo(28.87, 40.828, 28.87, 40.828, 25.698, 42.513)
      ..cubicTo(25.352, 42.697, 24.973, 42.811, 24.583, 42.849)
      ..cubicTo(22.934, 43.01, 21.466, 41.805, 21.305, 40.156)
      ..lineTo(21.221, 39.247)
      ..cubicTo(21.04, 37.126, 20.949, 35.005, 20.949, 32.884)
      ..cubicTo(20.949, 29.361, 20.949, 29.361, 21.283, 26.038)
      ..close();

    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3 * 0.8)
      ..maskFilter = const .blur(.normal, 1.0);

    // feOffset dy="2"
    canvas
      ..save()
      ..translate(0, 2)
      ..drawPath(path, paint)
      ..restore();

    // dy=0, blur=3.5
    paint
      ..color = Colors.black.withValues(alpha: 0.2 * 0.8)
      ..maskFilter = const .blur(.normal, 3.5);

    canvas.drawPath(path, paint);

    paint
      ..color = Colors.white.withValues(alpha: 0.8)
      ..maskFilter = null;

    canvas.drawPath(path, paint);

    return rec.endRecording();
  }();
}
