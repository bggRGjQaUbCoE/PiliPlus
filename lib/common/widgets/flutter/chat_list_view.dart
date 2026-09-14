// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_initializing_formals

import 'package:PiliPlus/common/widgets/sliver/sliver_constrained_cross_axis.dart';
import 'package:flutter/foundation.dart' show precisionErrorTolerance;
import 'package:flutter/rendering.dart'
    show
        RenderSliverList,
        SliverConstraints,
        SliverMultiBoxAdaptorParentData,
        RenderSliverMultiBoxAdaptor,
        SliverGeometry;
import 'package:flutter/widgets.dart';

class ChatListView extends ListView {
  ChatListView.separated({
    super.key,
    required this.maxExtent,
    super.scrollDirection,
    super.controller,
    super.primary,
    super.physics,
    super.padding,
    required super.itemBuilder,
    // ignore: deprecated_member_use
    super.findChildIndexCallback,
    super.findItemIndexCallback,
    required super.separatorBuilder,
    required super.itemCount,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    // ignore: deprecated_member_use
    super.cacheExtent,
    super.scrollCacheExtent,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    super.hitTestBehavior,
  }) : super.separated(reverse: true);

  final double maxExtent;

  @override
  Widget buildChildLayout(BuildContext context) {
    return CenteredSliverConstrainedCrossAxis(
      maxExtent: maxExtent,
      sliver: ChatSliverList(delegate: childrenDelegate),
    );
  }
}

class ChatSliverList extends SliverList {
  const ChatSliverList({super.key, required super.delegate});

  @override
  RenderChatSliverList createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;
    return RenderChatSliverList(childManager: element);
  }
}

class RenderChatSliverList extends RenderSliverList
    with ExtendedRenderObjectMixin {
  RenderChatSliverList({required super.childManager});

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    childManager
      ..didStartLayout()
      ..setDidUnderflow(false);

    final double scrollOffset =
        constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0);
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0);
    final double targetEndScrollOffset = scrollOffset + remainingExtent;
    final BoxConstraints childConstraints = constraints.asBoxConstraints();
    var leadingGarbage = 0;
    var trailingGarbage = 0;
    var reachedEnd = false;

    if (firstChild == null) {
      if (!addInitialChild()) {
        geometry = SliverGeometry.zero;
        childManager.didFinishLayout();
        return;
      }
    }

    ///
    handleCloseToTrailingBegin();

    RenderBox? leadingChildWithLayout, trailingChildWithLayout;

    RenderBox? earliestUsefulChild = firstChild;

    if (childScrollOffset(firstChild!) == null) {
      var leadingChildrenWithoutLayoutOffset = 0;
      while (earliestUsefulChild != null &&
          childScrollOffset(earliestUsefulChild) == null) {
        earliestUsefulChild = childAfter(earliestUsefulChild);
        leadingChildrenWithoutLayoutOffset += 1;
      }

      collectGarbage(leadingChildrenWithoutLayoutOffset, 0);

      if (firstChild == null) {
        if (!addInitialChild()) {
          geometry = SliverGeometry.zero;
          childManager.didFinishLayout();
          return;
        }
      }
    }

    earliestUsefulChild = firstChild;
    for (
      double earliestScrollOffset = childScrollOffset(earliestUsefulChild!)!;
      earliestScrollOffset > scrollOffset;
      earliestScrollOffset = childScrollOffset(earliestUsefulChild)!
    ) {
      earliestUsefulChild = insertAndLayoutLeadingChild(
        childConstraints,
        parentUsesSize: true,
      );
      if (earliestUsefulChild == null) {
        final childParentData =
            firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
        childParentData.layoutOffset = 0.0;

        if (scrollOffset == 0.0) {
          firstChild!.layout(childConstraints, parentUsesSize: true);
          earliestUsefulChild = firstChild;
          leadingChildWithLayout = earliestUsefulChild;
          trailingChildWithLayout ??= earliestUsefulChild;
          break;
        } else {
          geometry = SliverGeometry(scrollOffsetCorrection: -scrollOffset);
          return;
        }
      }

      final double firstChildScrollOffset =
          earliestScrollOffset - paintExtentOf(firstChild!);

      if (firstChildScrollOffset < -precisionErrorTolerance) {
        geometry = SliverGeometry(
          scrollOffsetCorrection: -firstChildScrollOffset,
        );
        final childParentData =
            firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
        childParentData.layoutOffset = 0.0;
        return;
      }

      final childParentData =
          earliestUsefulChild.parentData! as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset = firstChildScrollOffset;
      assert(earliestUsefulChild == firstChild);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout ??= earliestUsefulChild;
    }

    assert(childScrollOffset(firstChild!)! > -precisionErrorTolerance);

    if (scrollOffset < precisionErrorTolerance) {
      while (indexOf(firstChild!) > 0) {
        final double earliestScrollOffset = childScrollOffset(firstChild!)!;

        earliestUsefulChild = insertAndLayoutLeadingChild(
          childConstraints,
          parentUsesSize: true,
        );
        assert(earliestUsefulChild != null);
        final double firstChildScrollOffset =
            earliestScrollOffset - paintExtentOf(firstChild!);
        final childParentData =
            firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
        childParentData.layoutOffset = 0.0;

        if (firstChildScrollOffset < -precisionErrorTolerance) {
          geometry = SliverGeometry(
            scrollOffsetCorrection: -firstChildScrollOffset,
          );
          return;
        }
      }
    }

    assert(earliestUsefulChild == firstChild);
    assert(childScrollOffset(earliestUsefulChild!)! <= scrollOffset);

    if (leadingChildWithLayout == null) {
      earliestUsefulChild!.layout(childConstraints, parentUsesSize: true);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout = earliestUsefulChild;
    }

    var inLayoutRange = true;
    var child = earliestUsefulChild;
    int index = indexOf(child!);
    double endScrollOffset = childScrollOffset(child)! + paintExtentOf(child);
    bool advance() {
      assert(child != null);
      if (child == trailingChildWithLayout) {
        inLayoutRange = false;
      }
      child = childAfter(child!);
      if (child == null) {
        inLayoutRange = false;
      }
      index += 1;
      if (!inLayoutRange) {
        if (child == null || indexOf(child!) != index) {
          child = insertAndLayoutChild(
            childConstraints,
            after: trailingChildWithLayout,
            parentUsesSize: true,
          );
          if (child == null) {
            return false;
          }
        } else {
          child!.layout(childConstraints, parentUsesSize: true);
        }
        trailingChildWithLayout = child;
      }
      assert(child != null);
      final childParentData =
          child!.parentData! as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset = endScrollOffset;
      assert(childParentData.index == index);
      endScrollOffset = childScrollOffset(child!)! + paintExtentOf(child!);
      return true;
    }

    while (endScrollOffset < scrollOffset) {
      leadingGarbage += 1;
      if (!advance()) {
        assert(leadingGarbage == childCount);
        assert(child == null);

        collectGarbage(leadingGarbage - 1, 0);
        assert(firstChild == lastChild);
        final double extent =
            childScrollOffset(lastChild!)! + paintExtentOf(lastChild!);
        geometry = SliverGeometry(scrollExtent: extent, maxPaintExtent: extent);
        return;
      }
    }

    while (endScrollOffset < targetEndScrollOffset) {
      if (!advance()) {
        reachedEnd = true;
        break;
      }
    }

    if (child != null) {
      child = childAfter(child!);
      while (child != null) {
        trailingGarbage += 1;
        child = childAfter(child!);
      }
    }

    collectGarbage(leadingGarbage, trailingGarbage);

    assert(debugAssertChildListIsNonEmptyAndContiguous());
    final double estimatedMaxScrollOffset;

    ///
    endScrollOffset = handleCloseToTrailingEnd(endScrollOffset);

    if (reachedEnd) {
      estimatedMaxScrollOffset = endScrollOffset;
    } else {
      estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
        constraints,
        firstIndex: indexOf(firstChild!),
        lastIndex: indexOf(lastChild!),
        leadingScrollOffset: childScrollOffset(firstChild!),
        trailingScrollOffset: endScrollOffset,
      );
      assert(
        estimatedMaxScrollOffset >=
            endScrollOffset - childScrollOffset(firstChild!)!,
      );
    }
    final double firstChildScrollOffset = childScrollOffset(firstChild!)!;
    double paintExtent = calculatePaintOffset(
      constraints,
      from: firstChildScrollOffset,
      to: endScrollOffset,
    );
    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: firstChildScrollOffset,
      to: endScrollOffset,
    );
    final double targetEndScrollOffsetForPaint =
        constraints.scrollOffset + constraints.remainingPaintExtent;

    ///
    paintExtent += _closeToTrailingDistance;

    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,

      hasVisualOverflow:
          endScrollOffset > targetEndScrollOffsetForPaint ||
          constraints.scrollOffset > 0.0,
    );

    if (estimatedMaxScrollOffset == endScrollOffset) {
      childManager.setDidUnderflow(true);
    }
    childManager.didFinishLayout();
  }
}

const double kChatListPadding = 14.0;

/// from https://github.com/fluttercandies/extended_list
mixin ExtendedRenderObjectMixin on RenderSliverMultiBoxAdaptor {
  void handleCloseToTrailingBegin() {
    _closeToTrailingDistance = 0.0;
  }

  double handleCloseToTrailingEnd(double endScrollOffset) {
    final extent = constraints.remainingPaintExtent - kChatListPadding;
    if (endScrollOffset < extent) {
      _closeToTrailingDistance = extent - endScrollOffset;
      return extent;
    }
    return endScrollOffset;
  }

  double _closeToTrailingDistance = 0.0;

  @override
  double? childScrollOffset(RenderObject child) {
    return (super.childScrollOffset(child) ?? 0.0) + _closeToTrailingDistance;
  }
}
