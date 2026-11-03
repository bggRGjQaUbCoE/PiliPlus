/*
 * This file is part of PiliPlus
 *
 * PiliPlus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PiliPlus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with PiliPlus.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class CroppedImage extends LeafRenderObjectWidget {
  const CroppedImage({
    super.key,
    required this.size,
    required this.image,
    required this.srcRect,
    required this.dstRect,
    required this.rrect,
    required this.imgPaint,
    required this.borderPaint,
    this.position,
  });

  final Size size;
  final ui.Image image;
  final Rect srcRect;
  final Rect dstRect;
  final RRect rrect;
  final Paint imgPaint;
  final Paint borderPaint;
  final String? position;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCroppedImage(
      preferredSize: size,
      image: image,
      srcRect: srcRect,
      dstRect: dstRect,
      rrect: rrect,
      imgPaint: imgPaint,
      borderPaint: borderPaint,
      position: position,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderCroppedImage renderObject,
  ) {
    renderObject
      ..preferredSize = size
      ..image = image
      ..srcRect = srcRect
      ..dstRect = dstRect
      ..rrect = rrect
      ..imgPaint = imgPaint
      ..borderPaint = borderPaint
      ..position = position;
  }
}

class RenderCroppedImage extends RenderBox {
  RenderCroppedImage({
    required this._preferredSize,
    required this._image,
    required this._srcRect,
    required this._dstRect,
    required this._rrect,
    required this._imgPaint,
    required this._borderPaint,
    this._position,
  });

  Size _preferredSize;
  Size get preferredSize => _preferredSize;
  set preferredSize(Size value) {
    if (_preferredSize == value) return;
    _preferredSize = value;
    markNeedsLayout();
  }

  ui.Image _image;
  ui.Image get image => _image;
  set image(ui.Image value) {
    if (_image == value) return;
    _image = value;
    markNeedsPaint();
  }

  Rect _srcRect;
  Rect get srcRect => _srcRect;
  set srcRect(Rect value) {
    if (_srcRect == value) return;
    _srcRect = value;
    markNeedsPaint();
  }

  Rect _dstRect;
  Rect get dstRect => _dstRect;
  set dstRect(Rect value) {
    if (_dstRect == value) return;
    _dstRect = value;
    markNeedsPaint();
  }

  RRect _rrect;
  RRect get rrect => _rrect;
  set rrect(RRect value) {
    if (_rrect == value) return;
    _rrect = value;
    markNeedsPaint();
  }

  Paint _imgPaint;
  Paint get imgPaint => _imgPaint;
  set imgPaint(Paint value) {
    if (_imgPaint == value) return;
    _imgPaint = value;
    markNeedsPaint();
  }

  Paint _borderPaint;
  Paint get borderPaint => _borderPaint;
  set borderPaint(Paint value) {
    if (_borderPaint == value) return;
    _borderPaint = value;
    markNeedsPaint();
  }

  String? _position;
  String? get position => _position;
  set position(String? value) {
    if (_position == value) return;
    _position = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.constrain(_preferredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..drawImageRect(image, srcRect, dstRect, _imgPaint)
      ..drawRRect(rrect, _borderPaint);

    if (position != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: position,
          style: const TextStyle(fontSize: 12.5, color: _kPosForeground),
        ),
        textDirection: .ltr,
      )..layout();
      final dx = (size.width - textPainter.width) / 2;
      final dy =
          size.height - textPainter.height - _kPosPaddingV - kPreviewStroke;
      canvas.drawRRect(
        .fromRectAndRadius(
          .fromLTWH(
            dx - _kPosPaddingH,
            dy - _kPosPaddingV,
            textPainter.width + 2 * _kPosPaddingH,
            textPainter.height + 2 * _kPosPaddingV,
          ),
          _kPosRadius,
        ),
        Paint()..color = _kPosBackground,
      );
      textPainter
        ..paint(canvas, Offset(dx, dy))
        ..dispose();
    }
  }

  @override
  bool get isRepaintBoundary => true;
}

const kPreviewStroke = 1.5;
const _kPosPaddingH = 4.0;
const _kPosPaddingV = 2.0;
const _kPosRadius = Radius.circular(2);
const Color _kPosForeground = Color(0xFFFFFFFF);
const Color _kPosBackground = Color(0xCC000000);
