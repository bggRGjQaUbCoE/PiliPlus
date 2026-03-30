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

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show
        ContainerRenderObjectMixin,
        MultiChildLayoutParentData,
        RenderBoxContainerDefaultsMixin,
        BoxHitTestResult,
        TransformLayer;

class PlayerBar extends MultiChildRenderObjectWidget {
  const PlayerBar({
    super.key,
    super.children,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderBottomBar();
  }
}

class RenderBottomBar extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  Matrix4? _transform;

  @override
  void performLayout() {
    _transform = null;

    final c = constraints.copyWith(maxWidth: .infinity);
    final RenderBox first = firstChild!..layout(c, parentUsesSize: true);
    final RenderBox last = lastChild!..layout(c, parentUsesSize: true);

    final firstSize = first.size;
    final lastSize = last.size;

    final firstParentData = first.parentData as MultiChildLayoutParentData;
    final lastParentData = last.parentData as MultiChildLayoutParentData;

    final firstWidth = firstSize.width;
    final lastWidth = lastSize.width;
    final totalWidth = firstWidth + lastWidth;
    final maxWidth = constraints.maxWidth;
    final height = math.max(firstSize.height, lastSize.height);
    size = constraints.constrainDimensions(maxWidth, height);

    firstParentData.offset = Offset(0.0, (height - firstSize.height) / 2);
    if (totalWidth <= maxWidth) {
      lastParentData.offset = Offset(
        maxWidth - lastWidth,
        (height - lastSize.height) / 2,
      );
    } else {
      final scale = maxWidth / totalWidth;
      _transform = Matrix4.identity()
        ..translateByDouble(0.0, height * (1 - scale) / 2, 0.0, 1.0)
        ..scaleByDouble(scale, scale, scale, 1.0);
      lastParentData.offset = Offset(
        (maxWidth - lastWidth * scale) / scale,
        (height - lastSize.height) / 2,
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_transform != null) {
      layer = context.pushTransform(
        needsCompositing,
        offset,
        _transform!,
        defaultPaint,
        oldLayer: layer as TransformLayer?,
      );
    } else {
      defaultPaint(context, offset);
      layer = null;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintTransform(
      transform: _transform,
      position: position,
      hitTest: (BoxHitTestResult result, Offset position) {
        return defaultHitTestChildren(result, position: position);
      },
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final childParentData = child.parentData! as MultiChildLayoutParentData;
    final Offset offset = childParentData.offset;
    if (_transform != null) {
      transform
        ..translateByDouble(offset.dx * _transform!.storage[0], offset.dy, 0, 1)
        ..multiply(_transform!);
    } else {
      transform.translateByDouble(offset.dx, offset.dy, 0, 1);
    }
  }
}
