import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverFixedWrap extends SliverMultiBoxAdaptorWidget {
  final double mainAxisExtent;
  final double spacing;
  final double runSpacing;

  const SliverFixedWrap({
    super.key,
    required super.delegate,
    required this.mainAxisExtent,
    this.spacing = 0,
    this.runSpacing = 0,
  });

  @override
  SliverWrapElement createElement() =>
      SliverWrapElement(this, replaceMovedChildren: true);

  @override
  RenderSliverFixedWrap createRenderObject(BuildContext context) {
    return RenderSliverFixedWrap(
      childManager: context as SliverWrapElement,
      mainAxisExtent: mainAxisExtent,
      spacing: spacing,
      runSpacing: runSpacing,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverFixedWrap renderObject,
  ) {
    renderObject
      ..mainAxisExtent = mainAxisExtent
      ..spacing = spacing
      ..runSpacing = runSpacing;
  }
}

class SliverWrapParentData extends SliverMultiBoxAdaptorParentData {
  double crossAxisOffset = 0.0;

  @override
  String toString() => 'crossAxisOffset=$crossAxisOffset; ${super.toString()}';
}

class _Row {
  final int startIndex;
  final int endIndex;
  final List<double> childWidths;

  _Row({
    required this.startIndex,
    required this.endIndex,
    required this.childWidths,
  });
}

class RenderSliverFixedWrap extends RenderSliverMultiBoxAdaptor {
  RenderSliverFixedWrap({
    required super.childManager,
    required double mainAxisExtent,
    double spacing = 0.0,
    double runSpacing = 0.0,
  }) : _mainAxisExtent = mainAxisExtent,
       _spacing = spacing,
       _runSpacing = runSpacing {
    assert(mainAxisExtent > 0.0 && mainAxisExtent.isFinite);
  }

  double _mainAxisExtent;
  double get mainAxisExtent => _mainAxisExtent;
  set mainAxisExtent(double value) {
    if (_mainAxisExtent == value) return;
    _mainAxisExtent = value;
    markRowsDirty();
    markNeedsLayout();
  }

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markRowsDirty();
    markNeedsLayout();
  }

  double _runSpacing;
  double get runSpacing => _runSpacing;
  set runSpacing(double value) {
    if (_runSpacing == value) return;
    _runSpacing = value;
    markRowsDirty();
    markNeedsLayout();
  }

  final List<_Row> _rows = [];

  void markRowsDirty() {
    _rows.clear();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverWrapParentData) {
      child.parentData = SliverWrapParentData();
    }
  }

  @override
  double childCrossAxisPosition(RenderBox child) {
    return (child.parentData as SliverWrapParentData).crossAxisOffset;
  }

  double _childCrossExtent(RenderBox child) {
    assert(child.hasSize);
    return switch (constraints.axis) {
      Axis.horizontal => child.size.height,
      Axis.vertical => child.size.width,
    };
  }

  RenderBox _getOrCreateChildAtIndex(
    int index,
    BoxConstraints constraints,
    RenderBox? child,
  ) {
    assert(firstChild != null);

    if (index < indexOf(firstChild!)) {
      do {
        child = insertAndLayoutLeadingChild(constraints, parentUsesSize: true);
        assert(child != null);
      } while (indexOf(child!) > index);

      assert(indexOf(child) == index);

      return child;
    } else if (index > indexOf(lastChild!)) {
      do {
        child = insertAndLayoutChild(
          constraints,
          after: lastChild,
          parentUsesSize: true,
        );
        assert(child != null);
      } while (indexOf(child!) < index);

      assert(indexOf(child) == index);

      return child;
    } else {
      child = firstChild;
      while (indexOf(child!) < index) {
        child = childAfter(child);
      }
      if (indexOf(child) == index) {
        child.layout(constraints, parentUsesSize: true);
        return child;
      }
      throw RangeError.value(index, 'index', 'Value not included in children');
    }
  }

  bool _buildNextRow(int start, BoxConstraints childConstraints) {
    final int childCount = childManager.childCount;

    if (start >= childCount) {
      return false;
    }

    final crossAxisExtent = constraints.crossAxisExtent;

    final List<double> widths = [];
    int idx = start;
    RenderBox? child;
    for (var totalWidth = -_spacing; idx < childCount; idx++) {
      child = _getOrCreateChildAtIndex(idx, childConstraints, child);
      final childWidth = _childCrossExtent(child);
      totalWidth += childWidth + _spacing;

      if (totalWidth <= crossAxisExtent) {
        widths.add(childWidth);
      } else {
        break;
      }
    }

    _rows.add(_Row(startIndex: start, endIndex: idx - 1, childWidths: widths));
    return true;
  }

  @override
  void performLayout() {
    childManager
      ..didStartLayout()
      ..setDidUnderflow(false);

    final constraints = this.constraints;
    final childCount = childManager.childCount;

    final rowHeight = _mainAxisExtent + _runSpacing;

    final scrollOffset = constraints.scrollOffset;

    final firstCacheOffset = scrollOffset + constraints.cacheOrigin;
    final lastCacheOffset = scrollOffset + constraints.remainingCacheExtent;

    final firstNeededRow = math.max(0, firstCacheOffset ~/ rowHeight);
    final lastNeededRow = math.max(0, lastCacheOffset ~/ rowHeight);

    if (firstChild == null) {
      if (!addInitialChild()) {
        geometry = SliverGeometry.zero;
        childManager.didFinishLayout();
        return;
      }
      firstChild!.layout(
        constraints.toFixedConstraints(_mainAxisExtent),
        parentUsesSize: true,
      );
    }

    while (_rows.length <= lastNeededRow) {
      final int startIndex = _rows.isEmpty ? 0 : _rows.last.endIndex + 1;
      if (!_buildNextRow(
        startIndex,
        constraints.toFixedConstraints(_mainAxisExtent),
      )) {
        break;
      }
    }

    assert(firstNeededRow >= 0);

    final int firstKeptRow = firstNeededRow.clamp(0, _rows.length - 1);
    final int lastKeptRow = lastNeededRow.clamp(0, _rows.length - 1);

    final int firstKeptIndex = _rows[firstKeptRow].startIndex;
    final int lastKeptIndex = _rows[lastKeptRow].endIndex;

    collectGarbage(
      calculateLeadingGarbage(firstIndex: firstKeptIndex),
      calculateTrailingGarbage(lastIndex: lastKeptIndex),
    );

    RenderBox? child;
    for (var r = firstKeptRow; r <= lastKeptRow; r++) {
      final row = _rows[r];
      final rowStartOffset = r * rowHeight;
      double crossOffset = 0.0;
      for (var i = row.startIndex; i <= row.endIndex; i++) {
        child = _getOrCreateChildAtIndex(
          i,
          constraints.toFixedConstraints(_mainAxisExtent),
          child,
        );
        (child.parentData as SliverWrapParentData)
          ..layoutOffset = rowStartOffset
          ..crossAxisOffset = crossOffset;
        crossOffset += row.childWidths[i - row.startIndex] + _spacing;
      }
    }

    final endOffset = _rows.last.endIndex == childCount - 1
        ? (_rows.length * rowHeight)
        : (_rows.last.startIndex + 1) * rowHeight;

    final double estimatedMaxScrollOffset;
    if (_rows.length <= lastNeededRow || childCount == 0) {
      estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
        constraints,
        firstIndex: firstKeptIndex,
        lastIndex: lastKeptIndex,
        leadingScrollOffset: firstKeptRow * rowHeight,
        trailingScrollOffset: endOffset,
      );
    } else {
      estimatedMaxScrollOffset = _rows.length * rowHeight;
    }

    final double paintExtent = calculatePaintOffset(
      constraints,
      from: firstKeptRow * rowHeight,
      to: endOffset,
    );
    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: firstCacheOffset,
      to: lastCacheOffset,
    );

    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      hasVisualOverflow:
          endOffset >
          constraints.scrollOffset + constraints.remainingPaintExtent,
    );

    if (estimatedMaxScrollOffset <= endOffset) {
      childManager.setDidUnderflow(true);
    }

    childManager.didFinishLayout();
  }

  @override
  void dispose() {
    markRowsDirty();
    super.dispose();
  }
}

class SliverWrapElement extends SliverMultiBoxAdaptorElement {
  SliverWrapElement(SliverFixedWrap super.widget, {super.replaceMovedChildren});

  @override
  void performRebuild() {
    (renderObject as RenderSliverFixedWrap).markRowsDirty();
    super.performRebuild();
  }
}

extension on SliverConstraints {
  BoxConstraints toFixedConstraints(double mainAxisExtent) {
    switch (axis) {
      case Axis.horizontal:
        return BoxConstraints(
          minHeight: 0,
          maxHeight: crossAxisExtent,
          minWidth: mainAxisExtent,
          maxWidth: mainAxisExtent,
        );
      case Axis.vertical:
        return BoxConstraints(
          minWidth: 0,
          maxWidth: crossAxisExtent,
          minHeight: mainAxisExtent,
          maxHeight: mainAxisExtent,
        );
    }
  }
}
