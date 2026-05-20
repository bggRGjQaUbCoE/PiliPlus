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

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/rendering.dart'
    show RenderSliverSingleBoxAdapter, SliverConstraints, SliverGeometry;
import 'package:flutter/widgets.dart';

/// ref [SliverPersistentHeader]
class SliverPinnedDynamicHeader extends SingleChildRenderObjectWidget {
  const SliverPinnedDynamicHeader({
    super.key,
    required Widget super.child,
    required this.minExtent,
    required this.maxExtent,
  });

  final double minExtent;
  final double maxExtent;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverPinnedDynamicHeader(
      minExtent: minExtent,
      maxExtent: maxExtent,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverPinnedDynamicHeader renderObject,
  ) {
    renderObject
      ..minExtent = minExtent
      ..maxExtent = maxExtent;
  }
}

class RenderSliverPinnedDynamicHeader extends RenderSliverSingleBoxAdapter {
  RenderSliverPinnedDynamicHeader({
    required this._minExtent,
    required this._maxExtent,
  });

  double _minExtent;
  double get minExtent => _minExtent;
  set minExtent(double value) {
    if (_minExtent == value) return;
    _minExtent = value;
    markNeedsLayout();
  }

  double _maxExtent;
  double get maxExtent => _maxExtent;
  set maxExtent(double value) {
    // removed
    // if (_maxExtent == value) return;
    _maxExtent = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    final double shrinkOffset = math.min(constraints.scrollOffset, maxExtent);
    child!.layout(
      constraints.asBoxConstraints(
        maxExtent: math.max(minExtent, maxExtent - shrinkOffset),
      ),
      parentUsesSize: true,
    );
    final double childExtent = child!.size.height;
    final double effectiveRemainingPaintExtent = math.max(
      0,
      constraints.remainingPaintExtent - constraints.overlap,
    );
    final double layoutExtent = clampDouble(
      maxExtent - constraints.scrollOffset,
      0.0,
      effectiveRemainingPaintExtent,
    );
    geometry = SliverGeometry(
      scrollExtent: maxExtent,
      paintOrigin: constraints.overlap,
      paintExtent: math.min(childExtent, effectiveRemainingPaintExtent),
      layoutExtent: layoutExtent,
      maxPaintExtent: maxExtent,
      maxScrollObstructionExtent: minExtent,
      cacheExtent: layoutExtent > 0.0
          ? -constraints.cacheOrigin + layoutExtent
          : layoutExtent,
      hasVisualOverflow: false,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry!.visible) {
      context.paintChild(child!, offset);
    }
  }

  @override
  double childMainAxisPosition(RenderBox child) => 0.0;
}
