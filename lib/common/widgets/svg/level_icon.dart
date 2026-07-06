// dart format width=120
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class UserLevel extends LeafRenderObjectWidget {
  const UserLevel(
    this.level, {
    super.key,
    this.height = 11,
    this.flash = false,
  });

  final double height;
  final int level;
  final bool flash;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderLevel(height, level, flash);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderLevel renderObject,
  ) {
    renderObject
      ..height = height
      ..level = level
      ..flash = flash;
  }
}

class RenderLevel extends RenderBox {
  RenderLevel(this._height, this._level, this._flash);

  double _height;
  set height(double value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  int _level;
  set level(int value) {
    if (_level == value) return;
    _level = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  bool _flash;
  set flash(bool value) {
    if (_flash == value) return;
    _flash = value;
    markNeedsLayout();
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return constraints.constrainSizeAndAttemptToPreserveAspectRatio(
      Size(
        (_flash ? LevelCanvas._extendR : LevelCanvas._totalR) * _height / LevelCanvas._totalB,
        _height,
      ),
    );
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final paint = Paint()..color = lookupBackgroundColor(_level);
    LevelCanvas(context.canvas)
      ..save()
      ..translate(offset.dx, offset.dy)
      ..scale(size.height / LevelCanvas._totalB)
      ..drawLevelBack(paint, bolt: _flash)
      ..drawLevelLv()
      ..drawLEDigit(_level, paint..color = Colors.white)
      ..restore();
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.label = '${_flash ? "硬核" : ""}$_level级';
  }

  static Color lookupBackgroundColor(int level) {
    return switch (level) {
      0 || 1 => const Color(0xFFC0C0C0),
      2 => const Color(0xFF8BD29B),
      3 => const Color(0xFF7BCDEF),
      4 => const Color(0xFFFEBB8B),
      5 => const Color(0xFFEE672A),
      _ => const Color(0xFFF04C49),
    };
  }
}

extension type LevelCanvas(Canvas _) implements Canvas {
  // ========== 布局常量 ==========
  static const _r = Radius.circular(20);

  static const double _left = 629;
  static const double _right = 877;
  static const double _colW = 68; // 竖段宽度
  static const double _lColR = _left + _colW; // 697
  static const double _rColL = _right - _colW; // 810

  // 三条横线的边界
  static const double _rowH = 68;
  static const double _rowSp = 146;
  static const double _topY = 55;
  static const double _topYB = _topY + _rowH; // 123
  static const double _midY = _topY + _rowSp; // 201
  static const double _midYB = _midY + _rowH; // 269
  static const double _botY = _midY + _rowSp; // 347
  static const double _botYB = _botY + _rowH; // 415

  // 竖段拼接用的中心线
  static const double _midMid = (_midY + _midYB) / 2; // 235

  static final _boltIcon =
      (ParagraphBuilder(
          ParagraphStyle(
            fontSize: 460,
            fontFamily: Icons.bolt_rounded.fontFamily,
            height: 1,
            fontWeight: FontWeight.w900,
            textDirection: TextDirection.ltr,
          ),
        )..addText(.fromCharCode(Icons.bolt_rounded.codePoint))).build()
        ..layout(const ParagraphConstraints(width: double.infinity));
  void drawBolt() => drawParagraph(_boltIcon, const Offset(840, 5));

  void _draw1(Paint paint) {
    drawRRect(const .fromLTRBXY(673, _botY, 833, _botYB, 20, 20), paint);
    drawRRect(.fromLTRBAndCorners(673, _topY, 787, _topYB, topLeft: _r, bottomLeft: _r, topRight: _r), paint);
    drawRect(const .fromLTRB(719, _topYB, 787, _botY), paint);
  }

  void drawLEDigit(int digit, Paint paint) {
    if (digit == 1) return _draw1(paint);
    final bits = switch (digit) {
      0 => 0x7E,
      2 => 0x6D,
      3 => 0x79,
      4 => 0x33,
      5 => 0x5B,
      6 => 0x5F,
      7 => 0x70,
      8 => 0x7F,
      9 => 0x7B,
      // _ => throw ArgumentError('Unsupported digit: $digit'),
      _ => 0x4F, // `E`
    };

    _drawSegments(
      bits & 0x40 != 0,
      bits & 0x20 != 0,
      bits & 0x10 != 0,
      bits & 0x08 != 0,
      bits & 0x04 != 0,
      bits & 0x02 != 0,
      bits & 0x01 != 0,
      paint,
    );
  }

  void _drawSegments(bool a, bool b, bool c, bool d, bool e, bool f, bool g, Paint paint) {
    // 横段
    if (a) {
      _drawRRect(_left, _topY, _right, _topYB, _r, _r, f ? .zero : _r, b ? .zero : _r, paint);
    }
    if (g) {
      _drawRRect(_left, _midY, _right, _midYB, f ? .zero : _r, b ? .zero : _r, e ? .zero : _r, c ? .zero : _r, paint);
    }
    if (d) {
      _drawRRect(_left, _botY, _right, _botYB, e ? .zero : _r, c ? .zero : _r, _r, _r, paint);
    }

    // 竖段
    // 左上竖段 f
    if (f) {
      final top = (a ? _topYB : _topY) - 1; // 有上横则齐底，否则到顶
      final bottom = (g ? _midY : (e ? _midMid : _midYB)) + 1;
      final rTop = a ? Radius.zero : _r;
      final rBot = g || e ? Radius.zero : _r;
      _drawRRect(_left, top, _lColR, bottom, rTop, rTop, rBot, rBot, paint);
    }

    // 右上竖段 b
    if (b) {
      final top = (a ? _topYB : _topY) - 1;
      final bottom = (g ? _midY : (c ? _midMid : _midYB)) + 1;
      final rTop = a ? Radius.zero : _r;
      final rBot = g || c ? Radius.zero : _r;
      _drawRRect(_rColL, top, _right, bottom, rTop, rTop, rBot, rBot, paint);
    }

    // 左下竖段 e
    if (e) {
      final top = (g ? _midYB : (f ? _midMid : _midY)) - 1;
      final bottom = (d ? _botY : _botYB) + 1;
      final rTop = g || f ? Radius.zero : _r;
      final rBot = d ? Radius.zero : _r;
      _drawRRect(_left, top, _lColR, bottom, rTop, rTop, rBot, rBot, paint);
    }

    // 右下竖段 c
    if (c) {
      final top = (g ? _midYB : (b ? _midMid : _midY)) - 1;
      final bottom = (d ? _botY : _botYB) + 1;
      final rTop = g || b ? Radius.zero : _r;
      final rBot = d ? Radius.zero : _r;
      _drawRRect(_rColL, top, _right, bottom, rTop, rTop, rBot, rBot, paint);
    }
  }

  /// 绘制圆角矩形，四角全零时退化为矩形
  void _drawRRect(double l, double t, double r, double b, Radius tl, Radius tr, Radius bl, Radius br, Paint paint) {
    if (tl == .zero && tr == .zero && bl == .zero && br == .zero) {
      drawRect(.fromLTRB(l, t, r, b), paint);
    } else {
      drawRRect(.fromLTRBAndCorners(l, t, r, b, topLeft: tl, topRight: tr, bottomLeft: bl, bottomRight: br), paint);
    }
  }

  static final _lvPicture = () {
    final recorder = PictureRecorder();
    final paint = Paint()..color = Colors.white;
    final canvas = Canvas(recorder);

    const double vLeft = 296;
    const double lvTop = 106;
    const double llr = 123;
    const double vtb = 282;

    canvas
      // L
      ..drawRRect(.fromLTRBAndCorners(56, lvTop, llr, _botYB, topLeft: _r, topRight: _r, bottomLeft: _r), paint)
      ..drawRRect(.fromLTRBAndCorners(llr - 1, _botY, 256, _botYB, topRight: _r, bottomRight: _r), paint)
      // V
      ..drawRRect(.fromLTRBAndCorners(vLeft, lvTop, 363, vtb + 1, topLeft: _r, topRight: _r), paint)
      ..drawRRect(.fromLTRBAndCorners(476, lvTop, 543, vtb + 1, topLeft: _r, topRight: _r), paint)
      ..drawPath(
        Path()
          ..moveTo(vLeft, vtb)
          ..lineTo(vLeft, 292)
          ..arcToPoint(const Offset(300, 313), radius: const .circular(50), clockwise: false)
          ..lineTo(395, 408)
          ..arcToPoint(const Offset(444, 408), radius: const .circular(50), clockwise: false)
          ..lineTo(539, 313)
          ..arcToPoint(const Offset(543, 292), radius: const .circular(50), clockwise: false)
          ..lineTo(543, vtb)
          ..lineTo(476, vtb)
          ..lineTo(419.5, 340)
          ..lineTo(363, vtb)
          ..close(),
        paint,
      );
    return recorder.endRecording();
  }();

  void drawLevelLv() => drawPicture(_lvPicture);

  static const double _totalR = 930;
  static const double _extendR = 1250;
  static const double _totalB = 466;

  void drawLevelBack(Paint paint, {bool bolt = false}) {
    const radius = Radius.circular(27);
    final double right = bolt ? _extendR : _totalR;
    const double blockTop = 48;
    drawRRect(
      RRect.fromLTRBAndCorners(0, blockTop, right, _totalB, topLeft: radius, bottomLeft: radius, bottomRight: radius),
      paint,
    );
    drawRRect(
      RRect.fromLTRBAndCorners(576, 0, right, blockTop + 1, topLeft: radius, topRight: radius),
      paint,
    );

    if (bolt) drawBolt();
  }
}
