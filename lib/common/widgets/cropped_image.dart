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
  });

  final Size size;
  final ui.Image image;
  final Rect srcRect;
  final Rect dstRect;
  final RRect rrect;
  final Paint imgPaint;
  final Paint borderPaint;

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
      ..borderPaint = borderPaint;
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

  @override
  void performLayout() {
    size = constraints.constrain(_preferredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas
      ..drawImageRect(image, srcRect, dstRect, _imgPaint)
      ..drawRRect(rrect, _borderPaint);
  }

  @override
  bool get isRepaintBoundary => true;
}
