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

import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsConfiguration;

///
/// created by dom on 2026/02/14
///

class LoadingIndicator extends LeafRenderObjectWidget {
  const LoadingIndicator({
    super.key,
    required this.size,
    required this.progress,
  });

  final double size;
  final double progress;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderLoadingIndicator(
      preferredSize: size,
      progress: progress,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderLoadingIndicator renderObject,
  ) {
    renderObject
      ..preferredSize = size
      ..progress = progress;
  }
}

class RenderLoadingIndicator extends RenderBox {
  RenderLoadingIndicator({
    required double preferredSize,
    required double progress,
  }) : _preferredSize = preferredSize,
       _progress = progress;

  double _preferredSize;
  double get preferredSize => _preferredSize;
  set preferredSize(double value) {
    if (_preferredSize == value) return;
    _preferredSize = value;
    markNeedsLayout();
  }

  double _progress;
  double get progress => _progress;
  set progress(double value) {
    if (_progress == value) return;
    _progress = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  void performLayout() {
    size = constraints.constrainDimensions(_preferredSize, _preferredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_progress == 0) {
      return;
    }
    const padding = 8.0;
    const strokeWidth = 1.4;
    const startAngle = -pi / 2;

    final paint = Paint()..isAntiAlias = true;
    final size = this.size;
    final radius = size.width / 2 - strokeWidth;
    final center = size.center(.zero);

    context.canvas
      ..drawCircle(
        center,
        radius,
        paint
          ..style = .fill
          ..color = const Color(0x80000000),
      )
      ..drawCircle(
        center,
        radius,
        paint
          ..style = .stroke
          ..strokeWidth = strokeWidth
          ..color = Colors.white,
      )
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius - padding),
        startAngle,
        progress * 2 * pi,
        true,
        paint..style = .fill,
      );
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config
      ..role = .progressBar
      ..minValue = '0'
      ..maxValue = '100'
      ..value = (_progress * 100).round().toString();
  }

  @override
  bool get isRepaintBoundary => true;
}
