// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatListView extends BoxScrollView {
  ChatListView.separated({
    super.key,
    super.scrollDirection,
    super.controller,
    super.primary,
    super.physics,
    super.padding,
    required NullableIndexedWidgetBuilder itemBuilder,
    @Deprecated(
      'Use findItemIndexCallback instead. '
      'findChildIndexCallback returns child indices (which include separators), '
      'while findItemIndexCallback returns item indices (which do not). '
      'If you were multiplying results by 2 to account for separators, '
      'you can remove that workaround when migrating to findItemIndexCallback. '
      'This feature was deprecated after v3.37.0-1.0.pre.',
    )
    ChildIndexGetter? findChildIndexCallback,
    ChildIndexGetter? findItemIndexCallback,
    required IndexedWidgetBuilder separatorBuilder,
    required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    super.cacheExtent,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    super.hitTestBehavior,
  }) : assert(itemCount >= 0),
       assert(
         findItemIndexCallback == null || findChildIndexCallback == null,
         'Cannot provide both findItemIndexCallback and findChildIndexCallback. '
         'Use findItemIndexCallback as findChildIndexCallback is deprecated.',
       ),
       childrenDelegate = SliverChildBuilderDelegate(
         (BuildContext context, int index) {
           final int itemIndex = index ~/ 2;
           if (index.isEven) {
             return itemBuilder(context, itemIndex);
           }
           return separatorBuilder(context, itemIndex);
         },
         findChildIndexCallback: findItemIndexCallback != null
             ? (Key key) {
                 final int? itemIndex = findItemIndexCallback(key);
                 return itemIndex == null ? null : itemIndex * 2;
               }
             : findChildIndexCallback,
         childCount: _computeActualChildCount(itemCount),
         addAutomaticKeepAlives: addAutomaticKeepAlives,
         addRepaintBoundaries: addRepaintBoundaries,
         addSemanticIndexes: addSemanticIndexes,
         semanticIndexCallback: (Widget widget, int index) {
           return index.isEven ? index ~/ 2 : null;
         },
       ),
       super(semanticChildCount: itemCount, reverse: true);

  final SliverChildDelegate childrenDelegate;

  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverChatList(delegate: childrenDelegate);
  }

  static int _computeActualChildCount(int itemCount) {
    return math.max(0, itemCount * 2 - 1);
  }
}

class SliverChatList extends SliverMultiBoxAdaptorWidget {
  const SliverChatList({super.key, required super.delegate});

  @override
  SliverMultiBoxAdaptorElement createElement() =>
      SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);

  @override
  RenderSliverChatList createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;
    return RenderSliverChatList(childManager: element);
  }
}

class RenderSliverChatList extends RenderSliverMultiBoxAdaptor
    with ExtendedRenderObjectMixin {
  RenderSliverChatList({required super.childManager});

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
