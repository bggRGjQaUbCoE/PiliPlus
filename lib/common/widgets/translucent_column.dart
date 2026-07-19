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

import 'package:PiliPlus/common/widgets/animated_height.dart'
    show RenderAnimatedHeight;
import 'package:flutter/rendering.dart'
    show RenderProxyBox, BoxHitTestResult, RenderFlex, FlexParentData;
import 'package:flutter/widgets.dart';

class TranslucentColumn extends Flex {
  const TranslucentColumn({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.spacing,
    super.children,
  }) : super(direction: Axis.vertical);

  @override
  RenderTranslucentColumn createRenderObject(BuildContext context) {
    return RenderTranslucentColumn(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTranslucentColumn renderObject,
  ) {
    renderObject
      ..direction = direction
      ..mainAxisAlignment = mainAxisAlignment
      ..mainAxisSize = mainAxisSize
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = getEffectiveTextDirection(context)
      ..verticalDirection = verticalDirection
      ..textBaseline = textBaseline
      ..clipBehavior = clipBehavior
      ..spacing = spacing;
  }
}

class RenderTranslucentColumn extends RenderFlex {
  RenderTranslucentColumn({
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
  });

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    final width = size.width;
    while (child != null) {
      final childParentData = child.parentData! as FlexParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          if (transformed.dx >= 0.0 &&
              transformed.dx < width &&
              transformed.dy >= 0.0 &&
              transformed.dy < child!.size.height) {
            final hit = child.hitTest(result, position: transformed);
            if (child is RenderAnimatedHeight) {
              return hit;
            }
            if (hit) {
              return true;
            }
            if (child is RenderNoTranslucentArea) {
              return false;
            }
            return true;
          }
          return false;
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

class NoTranslucentArea extends SingleChildRenderObjectWidget {
  const NoTranslucentArea({super.key, required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderNoTranslucentArea();
  }
}

class RenderNoTranslucentArea extends RenderProxyBox {}
