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

import 'package:flutter/rendering.dart'
    show BoxHitTestResult, RenderFlex, FlexParentData;
import 'package:flutter/widgets.dart';

class TranslucentRow extends Flex {
  const TranslucentRow({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.spacing,
    super.children,
    required this.extraWidth,
  }) : super(direction: Axis.horizontal);

  final double extraWidth;

  @override
  RenderTranslucentRow createRenderObject(BuildContext context) {
    return RenderTranslucentRow(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing,
      extraWidth: extraWidth,
    );
  }
}

class RenderTranslucentRow extends RenderFlex {
  RenderTranslucentRow({
    super.children,
    super.direction,
    super.mainAxisSize,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.clipBehavior,
    super.spacing,
    required this.extraWidth,
  });

  final double extraWidth;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (position.dx >= 0.0 &&
        position.dx <= extraWidth &&
        position.dy >= 0.0 &&
        position.dy < size.height) {
      return true;
    }
    RenderBox? child = lastChild;
    while (child != null) {
      final childParentData = child.parentData! as FlexParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          final hit = child!.hitTest(result, position: transformed);
          return hit || child.size.contains(transformed);
        },
      );
      if (isHit) {
        return true;
      }
      child = childParentData.previousSibling;
    }
    return false;
  }
}
