import 'dart:math' as math;
import 'dart:ui';

enum AnimatedImageFormat {
  webp('WebP', 'webp'),
  gif('GIF', 'gif');

  const AnimatedImageFormat(this.label, this.extension);
  final String label;
  final String extension;
  String get mimeType => 'image/$extension';
}

/// Preset labels retain their familiar spelling; pixel units are reduced.
enum CaptureAspectRatio {
  free('自由', 0, 0),
  square('1:1', 1, 1),
  landscape4x3('4:3', 4, 3),
  portrait3x4('3:4', 3, 4),
  landscape3x2('3:2', 3, 2),
  portrait2x3('2:3', 2, 3),
  landscape5x4('5:4', 5, 4),
  portrait4x5('4:5', 4, 5),
  landscape16x9('16:9', 16, 9),
  portrait9x16('9:16', 9, 16),
  landscape16x10('16:10', 8, 5),
  portrait10x16('10:16', 5, 8),
  landscape2x1('2:1', 2, 1),
  portrait1x2('1:2', 1, 2),
  ultrawide('21:9', 7, 3);

  const CaptureAspectRatio(this.label, this.numerator, this.denominator);
  final String label;
  final int numerator;
  final int denominator;
  bool get isFree => this == free;
  bool fits(Size frameSize) =>
      isFree ||
      (frameSize.width >= numerator && frameSize.height >= denominator);
}

/// Coordinates are relative to the oriented, square-pixel video frame.
class CaptureRegion {
  const CaptureRegion(this.rect, {this.aspectRatio = CaptureAspectRatio.free});
  static const full = CaptureRegion(Rect.fromLTRB(0, 0, 1, 1));
  final Rect rect;
  final CaptureAspectRatio aspectRatio;

  /// Keep the center and pixel area where possible, then uniformly fit bounds.
  CaptureRegion withAspectRatio(CaptureAspectRatio ratio, Size frameSize) {
    _checkFrame(frameSize);
    if (ratio.isFree) return CaptureRegion(rect);
    if (!ratio.fits(frameSize)) {
      throw ArgumentError('视频尺寸不足以使用 ${ratio.label}');
    }
    final p = ratio.numerator.toDouble();
    final q = ratio.denominator.toDouble();
    final center = Offset(
      (rect.center.dx * frameSize.width).clamp(p / 2, frameSize.width - p / 2),
      (rect.center.dy * frameSize.height).clamp(
        q / 2,
        frameSize.height - q / 2,
      ),
    );
    final area = rect.width * frameSize.width * rect.height * frameSize.height;
    final maximum = math.min(
      2 * math.min(center.dx, frameSize.width - center.dx) / p,
      2 * math.min(center.dy, frameSize.height - center.dy) / q,
    );
    final maximumUnits = (maximum + 1e-7).floor();
    final units = (math.sqrt(area / (p * q)) + 1e-7).floor().clamp(
      1,
      maximumUnits,
    );
    return _fromPixels(
      Rect.fromCenter(center: center, width: p * units, height: q * units),
      frameSize,
      ratio,
    );
  }

  CaptureRegion moved(Offset delta) => CaptureRegion(
    rect.shift(
      Offset(
        delta.dx.clamp(-rect.left, 1 - rect.right),
        delta.dy.clamp(-rect.top, 1 - rect.bottom),
      ),
    ),
    aspectRatio: aspectRatio,
  );

  /// Corner order is top-left, top-right, bottom-right, bottom-left.
  CaptureRegion resizeCorner(int corner, Offset point, Size frameSize) {
    RangeError.checkValidIndex(corner, const [0, 1, 2, 3]);
    final anchor = [
      rect.bottomRight,
      rect.bottomLeft,
      rect.topLeft,
      rect.topRight,
    ][corner];
    if (aspectRatio.isFree) return drawFrom(anchor, point, frameSize);
    return _anchored(
      anchor,
      point,
      frameSize,
      signX: corner == 0 || corner == 3 ? -1 : 1,
      signY: corner == 0 || corner == 1 ? -1 : 1,
    );
  }

  CaptureRegion drawFrom(Offset anchor, Offset point, Size frameSize) {
    _checkFrame(frameSize);
    point = Offset(point.dx.clamp(0.0, 1.0), point.dy.clamp(0.0, 1.0));
    if (aspectRatio.isFree) {
      final next = Rect.fromPoints(anchor, point);
      if (next.width * frameSize.width < 1 ||
          next.height * frameSize.height < 1) {
        return this;
      }
      return CaptureRegion(next);
    }
    return _anchored(
      anchor,
      point,
      frameSize,
      signX: point.dx < anchor.dx ? -1 : 1,
      signY: point.dy < anchor.dy ? -1 : 1,
    );
  }

  CaptureRegion _anchored(
    Offset anchor,
    Offset point,
    Size frameSize, {
    required int signX,
    required int signY,
  }) {
    _checkFrame(frameSize);
    final p = aspectRatio.numerator.toDouble();
    final q = aspectRatio.denominator.toDouble();
    final ax = anchor.dx * frameSize.width;
    final ay = anchor.dy * frameSize.height;
    final maximum = math.min(
      (signX > 0 ? frameSize.width - ax : ax) / p,
      (signY > 0 ? frameSize.height - ay : ay) / q,
    );
    if (maximum < 1 - 1e-9) return this;
    final dx = (point.dx * frameSize.width - ax) * signX;
    final dy = (point.dy * frameSize.height - ay) * signY;
    // Orthogonal projection onto the ratio's diagonal uses one scale for both
    // dimensions. A fixed sign prevents a dragged corner flipping its anchor.
    final maximumUnits = (maximum + 1e-7).floor();
    final units = (((p * dx + q * dy) / (p * p + q * q)) + 1e-7).floor().clamp(
      1,
      math.max(1, maximumUnits),
    );
    return _fromPixels(
      Rect.fromPoints(
        Offset(ax, ay),
        Offset(ax + signX * p * units, ay + signY * q * units),
      ),
      frameSize,
      aspectRatio,
    );
  }

  Rect pixels(int width, int height) {
    final size = Size(width.toDouble(), height.toDouble());
    _checkFrame(size);
    if (!aspectRatio.isFree) {
      final fitted = withAspectRatio(aspectRatio, size).rect;
      final p = aspectRatio.numerator;
      final q = aspectRatio.denominator;
      final maximum = math.min(width ~/ p, height ~/ q);
      final units =
          (math.min(fitted.width * width / p, fitted.height * height / q) +
                  1e-7)
              .floor()
              .clamp(1, maximum);
      final w = p * units;
      final h = q * units;
      final left = (fitted.center.dx * width - w / 2).round().clamp(
        0,
        width - w,
      );
      final top = (fitted.center.dy * height - h / 2).round().clamp(
        0,
        height - h,
      );
      return Rect.fromLTWH(
        left.toDouble(),
        top.toDouble(),
        w.toDouble(),
        h.toDouble(),
      );
    }
    final left = (rect.left * width).floor().clamp(0, width - 1);
    final top = (rect.top * height).floor().clamp(0, height - 1);
    final right = (rect.right * width).ceil().clamp(left + 1, width);
    final bottom = (rect.bottom * height).ceil().clamp(top + 1, height);
    return Rect.fromLTRB(
      left.toDouble(),
      top.toDouble(),
      right.toDouble(),
      bottom.toDouble(),
    );
  }

  static CaptureRegion _fromPixels(
    Rect pixels,
    Size frameSize,
    CaptureAspectRatio ratio,
  ) => CaptureRegion(
    Rect.fromLTRB(
      pixels.left / frameSize.width,
      pixels.top / frameSize.height,
      pixels.right / frameSize.width,
      pixels.bottom / frameSize.height,
    ),
    aspectRatio: ratio,
  );

  static void _checkFrame(Size size) {
    if (!size.width.isFinite ||
        !size.height.isFinite ||
        size.width < 1 ||
        size.height < 1) {
      throw ArgumentError.value(size, 'frameSize');
    }
  }
}

class AnimatedCaptureRequest {
  const AnimatedCaptureRequest({
    required this.url,
    required this.start,
    required this.end,
    this.format = AnimatedImageFormat.webp,
    this.region = CaptureRegion.full,
  });
  final String url;
  final double start;
  final double end;
  final AnimatedImageFormat format;
  final CaptureRegion region;
}

/// Move one endpoint without rounding its subsecond component.
double stepCaptureTime(double value, int seconds, double videoDuration) =>
    (value + seconds).clamp(0.0, videoDuration).toDouble();
