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

import 'package:PiliPlus/common/widgets/slotted_layout_helper.dart';
import 'package:flutter/material.dart';

const double kHeaderHeight = 135.0;

const double kAvatarSize = 80.0;
const double _kAvatarLeftPadding = 20.0;
const double _kAvatarTopPadding = 115.0;
const double _kAvatarEffectiveHeight =
    kAvatarSize - (kHeaderHeight - _kAvatarTopPadding);

const double _kActionsTopPadding = 140.0;
const double _kActionsLeftPadding = 160.0;
const double _kActionsRightPadding = 15.0;

enum HeaderType { avatar, actions, header }

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
    .avatar => avatar,
    .actions => actions,
    .header => header,
  };

  @override
  RenderHeaderWidget createRenderObject(BuildContext context) {
    return RenderHeaderWidget();
  }
}

class RenderHeaderWidget extends RenderBox
    with
        SlottedContainerRenderObjectMixin<HeaderType, RenderBox>,
        SlottedLayoutMixin {
  RenderBox get header => childForSlot(.header)!;
  RenderBox get avatar => childForSlot(.avatar)!;
  RenderBox get actions => childForSlot(.actions)!;

  @override
  Iterable<HeaderType> get slots => HeaderType.values;

  @override
  void performLayout() {
    double height = kHeaderHeight;
    final maxWidth = constraints.maxWidth;

    setOffset(
      header..layout(constraints),
      Offset.zero,
    );

    setOffset(
      avatar..layout(constraints),
      const Offset(_kAvatarLeftPadding, _kAvatarTopPadding),
    );

    final actions = this.actions;
    final childSize =
        (actions..layout(
              BoxConstraints(
                maxWidth: math.max(
                  0.0,
                  maxWidth - _kActionsLeftPadding - _kActionsRightPadding,
                ),
              ),
              parentUsesSize: true,
            ))
            .size;
    height += (math.max(_kAvatarEffectiveHeight, childSize.height)) + 5.0;
    setOffset(
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
    void doPaint(RenderBox child) {
      context.paintChild(child, getOffset(child) + offset);
    }

    doPaint(header);
    doPaint(avatar);
    doPaint(actions);
  }
}
