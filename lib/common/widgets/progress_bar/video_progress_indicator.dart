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

import 'package:flutter/widgets.dart';

class VideoProgressIndicator extends LeafRenderObjectWidget {
  const VideoProgressIndicator({
    super.key,
    required this.color,
    required this.backgroundColor,
    this.radius = 10,
    this.height = 4,
    required this.progress,
  }) : assert(progress >= 0 && progress <= 1);

  final Color color;
  final Color backgroundColor;
  final double radius;
  final double height;
  final double progress;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderProgressBar(
      color: color,
      backgroundColor: backgroundColor,
      radius: radius,
      height: height,
      progress: progress,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderProgressBar renderObject,
  ) {
    renderObject
      ..color = color
      ..backgroundColor = backgroundColor
      ..radius = radius
      ..height = height
      ..progress = progress;
  }
}

class RenderProgressBar extends RenderBox {
  RenderProgressBar({
    required Color color,
    required Color backgroundColor,
    required double radius,
    required double height,
    required double progress,
  }) : _color = color,
       _backgroundColor = backgroundColor,
       _radius = radius,
       _height = height,
       _progress = progress;

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  Color _backgroundColor;
  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color value) {
    if (_backgroundColor == value) return;
    _backgroundColor = value;
    markNeedsPaint();
  }

  double _progress;
  double get progress => _progress;
  set progress(double value) {
    if (_progress == value) return;
    _progress = value;
    markNeedsPaint();
  }

  double _radius;
  double get radius => _radius;
  set radius(double value) {
    if (_radius == value) return;
    _radius = value;
    markNeedsLayout();
  }

  double _height;
  double get height => _height;
  set height(double value) {
    if (_height == value) return;
    _height = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.constrainDimensions(constraints.maxWidth, _radius);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final size = this.size;
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    final paint = Paint()..style = .fill;

    canvas.clipRect(
      .fromLTRB(0, size.height - height, size.width, size.height),
    );

    final radius = Radius.circular(_radius);
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndCorners(
      rect,
      bottomLeft: radius,
      bottomRight: radius,
    );

    if (progress == 0) {
      canvas.drawRRect(rrect, paint..color = _backgroundColor);
    } else if (progress == 1) {
      canvas.drawRRect(rrect, paint..color = _color);
    } else {
      final w = size.width * progress;
      final left = Rect.fromLTRB(0, 0, w, size.height);
      final right = Rect.fromLTRB(w, 0, size.width, size.height);
      canvas
        ..clipRRect(rrect)
        ..drawRect(left, paint..color = _color)
        ..drawRect(right, paint..color = _backgroundColor);
    }
    canvas.restore();
  }
}
