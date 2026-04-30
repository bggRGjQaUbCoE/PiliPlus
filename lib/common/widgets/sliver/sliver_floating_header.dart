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
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show RenderSliverSingleBoxAdapter, SliverGeometry, ScrollDirection;

/// ref [SliverFloatingHeader]

class SliverFloatingHeaderWidget extends StatelessWidget {
  const SliverFloatingHeaderWidget({
    super.key,
    required this.child,
    required this.backgroundColor,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return _SliverFloatingHeaderWidget(
      backgroundColor: backgroundColor,
      child: _SliverFloatingHeaderScroll(child: child),
    );
  }
}

class _SliverFloatingHeaderScroll extends StatefulWidget {
  const _SliverFloatingHeaderScroll({required this.child});

  final Widget child;

  @override
  State<_SliverFloatingHeaderScroll> createState() =>
      _SliverFloatingHeaderScrollState();
}

class _SliverFloatingHeaderScrollState
    extends State<_SliverFloatingHeaderScroll> {
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_position != null) {
      _position!.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    _position = Scrollable.maybeOf(context)?.position;
    if (_position != null) {
      _position!.isScrollingNotifier.addListener(_isScrollingListener);
    }
  }

  @override
  void dispose() {
    if (_position != null) {
      _position!.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    super.dispose();
  }

  void _isScrollingListener() {
    assert(_position != null);
    if (_position!.isScrollingNotifier.value) {
      final RenderSliverFloatingHeader? renderer = context
          .findAncestorRenderObjectOfType<RenderSliverFloatingHeader>();
      renderer?.updateScrollStartDirection(_position!.userScrollDirection);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _SliverFloatingHeaderWidget extends SingleChildRenderObjectWidget {
  const _SliverFloatingHeaderWidget({
    required Widget super.child,
    required this.backgroundColor,
  });

  final Color backgroundColor;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderSliverFloatingHeader(backgroundColor: backgroundColor);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverFloatingHeader renderObject,
  ) {
    renderObject.backgroundColor = backgroundColor;
  }
}

class RenderSliverFloatingHeader extends RenderSliverSingleBoxAdapter {
  RenderSliverFloatingHeader({
    required Color backgroundColor,
  }) : _backgroundColor = backgroundColor;

  Color _backgroundColor;
  set backgroundColor(Color value) {
    if (_backgroundColor == value) return;
    _backgroundColor = value;
    markNeedsPaint();
  }

  double? _childPosition;

  double? lastScrollOffset;

  late double effectiveScrollOffset;

  bool get floatingHeaderNeedsToBeUpdated {
    return lastScrollOffset != null &&
        (constraints.scrollOffset < lastScrollOffset! ||
            effectiveScrollOffset < child!.size.height);
  }

  ScrollDirection? _lastStartedScrollDirection;

  void updateScrollStartDirection(ScrollDirection direction) {
    _lastStartedScrollDirection = direction;
  }

  @override
  void performLayout() {
    if (!floatingHeaderNeedsToBeUpdated) {
      effectiveScrollOffset = constraints.scrollOffset;
    } else {
      double delta =
          lastScrollOffset! -
          constraints.scrollOffset; // > 0 when the header is growing
      if (constraints.userScrollDirection == .forward ||
          _lastStartedScrollDirection == .forward) {
        final childExtent = child!.size.height;
        if (effectiveScrollOffset > childExtent) {
          effectiveScrollOffset =
              childExtent; // The header is now just above the start edge of viewport.
        }
      } else {
        // delta > 0 and scrolling forward is a contradiction. Assume that it's noise (set delta to 0).
        delta = clampDouble(delta, -double.infinity, 0);
      }
      effectiveScrollOffset = clampDouble(
        effectiveScrollOffset - delta,
        0.0,
        constraints.scrollOffset,
      );
    }

    child?.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final childExtent = child!.size.height;
    final double paintExtent = childExtent - effectiveScrollOffset;
    final double layoutExtent = childExtent - constraints.scrollOffset;
    geometry = SliverGeometry(
      paintOrigin: math.min(constraints.overlap, 0.0),
      scrollExtent: childExtent,
      paintExtent: clampDouble(
        paintExtent,
        0.0,
        constraints.remainingPaintExtent,
      ),
      layoutExtent: clampDouble(
        layoutExtent,
        0.0,
        constraints.remainingPaintExtent,
      ),
      maxPaintExtent: childExtent,
      hasVisualOverflow: false,
    );

    _childPosition = math.min(0.0, paintExtent - childExtent);
    lastScrollOffset = constraints.scrollOffset;
  }

  @override
  double childMainAxisPosition(covariant RenderObject child) {
    return _childPosition ?? 0;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child == this.child);
    applyPaintTransformForBoxChild(child as RenderBox, transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry!.visible) {
      offset += Offset(0.0, childMainAxisPosition(child!));
      final size = child!.size;
      context.canvas.drawRect(
        Rect.fromLTWH(
          offset.dx,
          offset.dy - 2,
          size.width,
          size.height + 2,
        ),
        Paint()..color = _backgroundColor,
      );
      context.paintChild(child!, offset);
    }
  }

  @override
  bool hitTestSelf({
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) => true;
}
