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

import 'package:PiliPlus/common/widgets/dynamic_sliver_app_bar/sliver_persistent_header.dart';
import 'package:PiliPlus/common/widgets/only_layout_widget.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/rendering.dart' hide LayoutCallback;
import 'package:flutter/widgets.dart'
    hide SliverPersistentHeader, SliverPersistentHeaderDelegate;

/// ref [SliverPersistentHeader]

Rect? _trim(
  Rect? original, {
  double top = -double.infinity,
  double right = double.infinity,
  double bottom = double.infinity,
  double left = -double.infinity,
}) => original?.intersect(Rect.fromLTRB(left, top, right, bottom));

abstract class RenderSliverPersistentHeader extends RenderSliver
    with RenderObjectWithChildMixin<RenderBox>, RenderSliverHelpers {
  RenderSliverPersistentHeader({RenderBox? child}) {
    this.child = child;
  }

  SliverPersistentHeaderElement? element;

  double get minExtent =>
      (element!.widget as SliverPinnedHeader).delegate.minExtent;

  bool _needsUpdateChild = true;

  double get lastShrinkOffset => _lastShrinkOffset;
  double _lastShrinkOffset = 0.0;

  bool get lastOverlapsContent => _lastOverlapsContent;
  bool _lastOverlapsContent = false;

  @protected
  void updateChild(
    double shrinkOffset,
    bool overlapsContent,
    double? maxExtent,
  ) {
    assert(element != null);
    element!.build(shrinkOffset, overlapsContent, maxExtent);
  }

  @override
  void markNeedsLayout() {
    _needsUpdateChild = true;
    super.markNeedsLayout();
  }

  @protected
  void updateChildIfNeeded(
    double scrollOffset,
    double? maxExtent, {
    bool overlapsContent = false,
  }) {
    final double shrinkOffset = maxExtent == null
        ? scrollOffset
        : math.min(scrollOffset, maxExtent);
    if (_needsUpdateChild ||
        _lastShrinkOffset != shrinkOffset ||
        _lastOverlapsContent != overlapsContent) {
      invokeLayoutCallback<SliverConstraints>((SliverConstraints constraints) {
        assert(constraints == this.constraints);
        updateChild(shrinkOffset, overlapsContent, maxExtent);
      });
      _lastShrinkOffset = shrinkOffset;
      _lastOverlapsContent = overlapsContent;
      _needsUpdateChild = false;
    }
  }

  @override
  double childMainAxisPosition(covariant RenderObject child) =>
      super.childMainAxisPosition(child);

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    assert(geometry!.hitTestExtent > 0.0);
    if (child != null) {
      return hitTestBoxChild(
        BoxHitTestResult.wrap(result),
        child!,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
      );
    }
    return false;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child == this.child);
    applyPaintTransformForBoxChild(child as RenderBox, transform);
  }

  void triggerRebuild() {
    markNeedsLayout();
  }
}

class SliverPinnedHeader extends RenderObjectWidget {
  const SliverPinnedHeader({
    super.key,
    required this.delegate,
    this.onPerformLayout,
  });

  final SliverPersistentHeaderDelegate delegate;
  final LayoutCallback? onPerformLayout;

  @override
  SliverPersistentHeaderElement createElement() =>
      SliverPersistentHeaderElement(this);

  @override
  RenderSliverPinnedHeader createRenderObject(BuildContext context) {
    return RenderSliverPinnedHeader(onPerformLayout: onPerformLayout);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverPinnedHeader renderObject,
  ) {
    renderObject.onPerformLayout = onPerformLayout;
  }
}

class RenderSliverPinnedHeader extends RenderSliverPersistentHeader {
  RenderSliverPinnedHeader({
    super.child,
    this.onPerformLayout,
  });

  LayoutCallback? onPerformLayout;

  ({double crossAxisExtent, double maxExtent})? _maxExtent;
  double? get maxExtent => _maxExtent?.maxExtent;

  void _rawLayout() {
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    _maxExtent = (
      crossAxisExtent: constraints.crossAxisExtent,
      maxExtent: child!.size.height,
    );
    onPerformLayout?.call(child!.size);
  }

  void _layout() {
    final double shrinkOffset = math.min(
      constraints.scrollOffset,
      _maxExtent!.maxExtent,
    );
    child!.layout(
      constraints.asBoxConstraints(
        maxExtent: math.max(minExtent, _maxExtent!.maxExtent - shrinkOffset),
      ),
      parentUsesSize: true,
    );
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    final bool overlapsContent = constraints.overlap > 0.0;

    if (_maxExtent == null) {
      updateChildIfNeeded(
        constraints.scrollOffset,
        _maxExtent?.maxExtent,
        overlapsContent: overlapsContent,
      );
      _rawLayout();
    } else {
      if (_maxExtent!.crossAxisExtent == constraints.crossAxisExtent) {
        updateChildIfNeeded(
          constraints.scrollOffset,
          _maxExtent?.maxExtent,
          overlapsContent: overlapsContent,
        );
        _layout();
      } else {
        _needsUpdateChild = true;
        updateChildIfNeeded(
          constraints.scrollOffset,
          null,
          overlapsContent: overlapsContent,
        );
        _rawLayout();
        if (constraints.scrollOffset > 0.0) {
          _needsUpdateChild = true;
          updateChildIfNeeded(
            constraints.scrollOffset,
            _maxExtent?.maxExtent,
            overlapsContent: overlapsContent,
          );
          _layout();
        }
      }
    }
    final childExtent = child!.size.height;
    final maxExtent = _maxExtent!.maxExtent;
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

  @override
  void showOnScreen({
    RenderObject? descendant,
    Rect? rect,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
  }) {
    final Rect? localBounds = descendant != null
        ? MatrixUtils.transformRect(
            descendant.getTransformTo(this),
            rect ?? descendant.paintBounds,
          )
        : rect;

    final Rect? newRect = _trim(localBounds, top: 0);

    super.showOnScreen(
      descendant: this,
      rect: newRect,
      duration: duration,
      curve: curve,
    );
  }
}
