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

import 'package:flutter/rendering.dart' show RenderProxyBox;
import 'package:flutter/widgets.dart';

class ReserveButton extends SingleChildRenderObjectWidget {
  const ReserveButton({
    super.key,
    required this.count,
    required this.color,
    required Widget super.child,
  });

  final int count;
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderReserveBtn(count: count, color: color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderReserveBtn renderObject) {
    renderObject
      ..color = color
      ..count = count;
  }
}

class RenderReserveBtn extends RenderProxyBox {
  RenderReserveBtn({
    required int count,
    required this._color,
  }) : _count = count {
    _textPainter = TextPainter(
      textDirection: .ltr,
      text: _getTextSpan(count),
    )..layout();
  }

  int _count;
  int get count => _count;
  set count(int value) {
    if (_count == value) return;
    _count = value;
    _updateTextSpan();
    markNeedsPaint();
  }

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    _updateTextSpan();
    markNeedsPaint();
  }

  late final TextPainter _textPainter;

  void _updateTextSpan() {
    _textPainter
      ..text = _getTextSpan(_count)
      ..layout();
  }

  TextSpan _getTextSpan(int count) {
    return TextSpan(
      text: count.toString(),
      style: TextStyle(
        height: 1,
        fontSize: 12,
        color: _color,
        fontWeight: .bold,
      ),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final size = this.size;
    final dx = offset.dx;
    final dy = offset.dy;
    final width = dx + size.width;
    final height = dy + size.height;
    final offsetDx = dx + 13.0;
    final offsetDy = dy + 14.0;
    final path = Path()
      ..moveTo(dx, dy)
      ..lineTo(offsetDx, dy)
      ..lineTo(offsetDx, offsetDy)
      ..lineTo(width, offsetDy)
      ..lineTo(width, height)
      ..lineTo(dx, height)
      ..close();
    final canvas = context.canvas
      ..save()
      ..clipPath(path);
    context.paintChild(child!, offset);
    canvas.restore();

    _textPainter.paint(canvas, Offset(offset.dx + 15.0, offset.dy));
  }

  @override
  void dispose() {
    _textPainter.dispose();
    super.dispose();
  }
}
