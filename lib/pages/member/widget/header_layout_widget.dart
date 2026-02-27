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
import 'package:flutter/rendering.dart' show BoxHitTestResult, BoxParentData;

const double kHeaderHeight = 135.0;

const double kAvatarSize = 80.0;
const double _kAvatarLeftPadding = 20.0;
const double _kAvatarTopPadding = 110.0;
const double _kAvatarEffectiveHeight =
    kAvatarSize - (kHeaderHeight - _kAvatarTopPadding);

const double _kActionsTopPadding = 140.0;
const double _kActionsLeftPadding = 160.0;
const double _kActionsRightPadding = 15.0;

enum HeaderType { header, avatar, actions }

class HeaderLayoutWidget
    extends SlottedMultiChildRenderObjectWidget<HeaderType, RenderBox> {
  final Widget header;
  final Widget avatar;
  final Widget actions;

  const HeaderLayoutWidget({
    super.key,
    required this.header,
    required this.avatar,
    required this.actions,
  });

  @override
  Iterable<HeaderType> get slots => HeaderType.values;

  @override
  Widget childForSlot(HeaderType slot) => switch (slot) {
    .header => header,
    .avatar => avatar,
    .actions => actions,
  };

  @override
  RenderHeaderWidget createRenderObject(BuildContext context) {
    return RenderHeaderWidget();
  }
}

class RenderHeaderWidget extends RenderBox
    with SlottedContainerRenderObjectMixin<HeaderType, RenderBox> {
  Offset _getOffset(RenderBox child) {
    return (child.parentData as BoxParentData).offset;
  }

  void _setOffset(RenderBox child, Offset offset) {
    (child.parentData as BoxParentData).offset = offset;
  }

  @override
  void performLayout() {
    double height = kHeaderHeight;
    final maxWidth = constraints.maxWidth;

    _setOffset(
      childForSlot(HeaderType.header)!..layout(constraints),
      Offset.zero,
    );

    _setOffset(
      childForSlot(HeaderType.avatar)!..layout(constraints),
      const Offset(_kAvatarLeftPadding, _kAvatarTopPadding),
    );

    final actions = childForSlot(HeaderType.actions)!;
    final childSize =
        (actions..layout(
              BoxConstraints(
                maxWidth:
                    maxWidth - _kActionsLeftPadding - _kActionsRightPadding,
              ),
              parentUsesSize: true,
            ))
            .size;
    height += (math.max(_kAvatarEffectiveHeight, childSize.height)) + 5.0;
    _setOffset(
      actions,
      Offset(
        maxWidth - childSize.width - _kActionsRightPadding,
        _kActionsTopPadding,
      ),
    );

    size = constraints.constrainDimensions(maxWidth, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (var child in children) {
      context.paintChild(child, _getOffset(child) + offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (var child in children) {
      final bool isHit = result.addWithPaintOffset(
        offset: _getOffset(child),
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}
