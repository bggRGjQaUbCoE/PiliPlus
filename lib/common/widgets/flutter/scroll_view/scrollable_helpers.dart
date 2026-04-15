// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// @docImport 'package:flutter/material.dart';
///
/// @docImport 'overscroll_indicator.dart';
/// @docImport 'viewport.dart';

// ignore_for_file: dangling_library_doc_comments

import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/flutter/scroll_view/scrollable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide EdgeDraggingAutoScroller, Scrollable, ScrollableState;

/// An auto scroller that scrolls the [scrollable] if a drag gesture drags close
/// to its edge.
///
/// The scroll velocity is controlled by the [velocityScalar]:
///
/// velocity = (distance of overscroll) * [velocityScalar].
class EdgeDraggingAutoScroller {
  /// Creates a auto scroller that scrolls the [scrollable].
  EdgeDraggingAutoScroller(
    this.scrollable, {
    this.onScrollViewScrolled,
    required this.velocityScalar,
  });

  /// The [Scrollable] this auto scroller is scrolling.
  final ScrollableState scrollable;

  /// Called when a scroll view is scrolled.
  ///
  /// The scroll view may be scrolled multiple times in a row until the drag
  /// target no longer triggers the auto scroll. This callback will be called
  /// in between each scroll.
  final VoidCallback? onScrollViewScrolled;

  /// {@template flutter.widgets.EdgeDraggingAutoScroller.velocityScalar}
  /// The velocity scalar per pixel over scroll.
  ///
  /// It represents how the velocity scale with the over scroll distance. The
  /// auto-scroll velocity = (distance of overscroll) * velocityScalar.
  /// {@endtemplate}
  final double velocityScalar;

  late Rect _dragTargetRelatedToScrollOrigin;

  /// Whether the auto scroll is in progress.
  bool get scrolling => _scrolling;
  bool _scrolling = false;

  double _offsetExtent(Offset offset, Axis scrollDirection) {
    return switch (scrollDirection) {
      Axis.horizontal => offset.dx,
      Axis.vertical => offset.dy,
    };
  }

  double _sizeExtent(Size size, Axis scrollDirection) {
    return switch (scrollDirection) {
      Axis.horizontal => size.width,
      Axis.vertical => size.height,
    };
  }

  AxisDirection get _axisDirection => scrollable.axisDirection;
  Axis get _scrollDirection => axisDirectionToAxis(_axisDirection);

  /// Starts the auto scroll if the [dragTarget] is close to the edge.
  ///
  /// The scroll starts to scroll the [scrollable] if the target rect is close
  /// to the edge of the [scrollable]; otherwise, it remains stationary.
  ///
  /// If the scrollable is already scrolling, calling this method updates the
  /// previous dragTarget to the new value and continues scrolling if necessary.
  void startAutoScrollIfNecessary(Rect dragTarget) {
    final Offset deltaToOrigin = scrollable.deltaToScrollOrigin;
    _dragTargetRelatedToScrollOrigin = dragTarget.translate(
      deltaToOrigin.dx,
      deltaToOrigin.dy,
    );
    if (_scrolling) {
      // The change will be picked up in the next scroll.
      return;
    }
    assert(!_scrolling);
    _scroll();
  }

  /// Stop any ongoing auto scrolling.
  void stopAutoScroll() {
    _scrolling = false;
  }

  Future<void> _scroll() async {
    final scrollRenderBox = scrollable.context.findRenderObject()! as RenderBox;
    final Matrix4 transform = scrollRenderBox.getTransformTo(null);
    final Rect globalRect = MatrixUtils.transformRect(
      transform,
      Rect.fromLTRB(
        0,
        0,
        scrollRenderBox.size.width,
        scrollRenderBox.size.height,
      ),
    );
    final Rect transformedDragTarget = MatrixUtils.transformRect(
      transform,
      _dragTargetRelatedToScrollOrigin,
    );

    assert(
      (globalRect.size.width + precisionErrorTolerance) >=
              transformedDragTarget.size.width &&
          (globalRect.size.height + precisionErrorTolerance) >=
              transformedDragTarget.size.height,
      'Drag target size is larger than scrollable size, which may cause bouncing',
    );
    _scrolling = true;
    double? newOffset;
    const overDragMax = 20.0;

    final Offset deltaToOrigin = scrollable.deltaToScrollOrigin;
    final Offset viewportOrigin = globalRect.topLeft.translate(
      deltaToOrigin.dx,
      deltaToOrigin.dy,
    );
    final double viewportStart = _offsetExtent(
      viewportOrigin,
      _scrollDirection,
    );
    final double viewportEnd =
        viewportStart + _sizeExtent(globalRect.size, _scrollDirection);

    final double proxyStart = _offsetExtent(
      _dragTargetRelatedToScrollOrigin.topLeft,
      _scrollDirection,
    );
    final double proxyEnd = _offsetExtent(
      _dragTargetRelatedToScrollOrigin.bottomRight,
      _scrollDirection,
    );
    switch (_axisDirection) {
      case AxisDirection.up:
      case AxisDirection.left:
        if (proxyEnd > viewportEnd &&
            scrollable.position.pixels > scrollable.position.minScrollExtent) {
          final double overDrag = math.min(proxyEnd - viewportEnd, overDragMax);
          newOffset = math.max(
            scrollable.position.minScrollExtent,
            scrollable.position.pixels - overDrag,
          );
        } else if (proxyStart < viewportStart &&
            scrollable.position.pixels < scrollable.position.maxScrollExtent) {
          final double overDrag = math.min(
            viewportStart - proxyStart,
            overDragMax,
          );
          newOffset = math.min(
            scrollable.position.maxScrollExtent,
            scrollable.position.pixels + overDrag,
          );
        }
      case AxisDirection.right:
      case AxisDirection.down:
        if (proxyStart < viewportStart &&
            scrollable.position.pixels > scrollable.position.minScrollExtent) {
          final double overDrag = math.min(
            viewportStart - proxyStart,
            overDragMax,
          );
          newOffset = math.max(
            scrollable.position.minScrollExtent,
            scrollable.position.pixels - overDrag,
          );
        } else if (proxyEnd > viewportEnd &&
            scrollable.position.pixels < scrollable.position.maxScrollExtent) {
          final double overDrag = math.min(proxyEnd - viewportEnd, overDragMax);
          newOffset = math.min(
            scrollable.position.maxScrollExtent,
            scrollable.position.pixels + overDrag,
          );
        }
    }

    if (newOffset == null ||
        (newOffset - scrollable.position.pixels).abs() < 1.0) {
      // Drag should not trigger scroll.
      _scrolling = false;
      return;
    }
    final duration = Duration(milliseconds: (1000 / velocityScalar).round());
    await scrollable.position.animateTo(
      newOffset,
      duration: duration,
      curve: Curves.linear,
    );
    onScrollViewScrolled?.call();
    if (_scrolling) {
      await _scroll();
    }
  }
}
