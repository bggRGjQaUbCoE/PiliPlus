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
  SliverMultiBoxAdaptorElement createElement() =>
      SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);

  @override
  RenderSliverFixedWrap createRenderObject(BuildContext context) {
    return RenderSliverFixedWrap(
      childManager: context as SliverMultiBoxAdaptorElement,
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
      ..runSpacing = runSpacing
      ..markRowsDirty();
  }
}

class SliverWrapParentData extends SliverMultiBoxAdaptorParentData {
  double crossAxisOffset = 0.0;

  @override
  String toString() => 'crossAxisOffset=$crossAxisOffset; ${super.toString()}';
}

class _Row {
  final int start;
  final int end;
  final List<double> childWidths;

  _Row(this.start, this.end, this.childWidths);
}

class RenderSliverFixedWrap extends RenderSliverMultiBoxAdaptor {
  RenderSliverFixedWrap({
    required super.childManager,
    required this._mainAxisExtent,
    this._spacing = 0.0,
    this._runSpacing = 0.0,
  }) : assert(_mainAxisExtent > 0.0 && _mainAxisExtent.isFinite);

  double _mainAxisExtent;
  double get mainAxisExtent => _mainAxisExtent;
  set mainAxisExtent(double value) {
    if (_mainAxisExtent == value) return;
    _mainAxisExtent = value;
    markNeedsLayout();
  }

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  double _runSpacing;
  double get runSpacing => _runSpacing;
  set runSpacing(double value) {
    if (_runSpacing == value) return;
    _runSpacing = value;
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

  bool _buildNextRow(int start, BoxConstraints constraints) {
    final int childCount = childManager.childCount;

    if (start >= childCount) {
      return false;
    }

    final sliverConstraints = this.constraints;
    final crossAxisExtent = sliverConstraints.crossAxisExtent;

    final widths = <double>[];
    int idx = start;
    RenderBox? child;
    for (var totalWidth = -_spacing; idx < childCount; idx++) {
      child = _getOrCreateChildAtIndex(idx, constraints, child);
      final childWidth = switch (sliverConstraints.axis) {
        Axis.horizontal => child.size.height,
        Axis.vertical => child.size.width,
      };
      totalWidth += childWidth + _spacing;

      if (totalWidth <= crossAxisExtent) {
        widths.add(childWidth);
      } else {
        break;
      }
    }

    _rows.add(_Row(start, idx - 1, widths));
    return true;
  }

  @override
  void performLayout() {
    childManager
      ..didStartLayout()
      ..setDidUnderflow(false);

    final constraints = this.constraints;

    final childConstraints = constraints.toFixedConstraints(_mainAxisExtent);

    if (firstChild == null) {
      if (!addInitialChild()) {
        geometry = SliverGeometry.zero;
        childManager.didFinishLayout();
        return;
      }
      firstChild!.layout(childConstraints, parentUsesSize: true);
    }

    final scrollOffset = constraints.scrollOffset;
    final firstCacheOffset = scrollOffset + constraints.cacheOrigin;
    final lastCacheOffset = scrollOffset + constraints.remainingCacheExtent;

    final rowHeight = _mainAxisExtent + _runSpacing;
    final firstNeededRow = math.max(0, firstCacheOffset ~/ rowHeight);
    final lastNeededRow = math.max(0, lastCacheOffset ~/ rowHeight);

    while (_rows.length <= lastNeededRow) {
      final startIndex = _rows.isEmpty ? 0 : _rows.last.end + 1;
      if (!_buildNextRow(startIndex, childConstraints)) {
        break;
      }
    }

    assert(firstNeededRow >= 0);

    final firstKeptRow = firstNeededRow.clamp(0, _rows.length - 1);
    final lastKeptRow = lastNeededRow.clamp(0, _rows.length - 1);

    final firstKeptIndex = _rows[firstKeptRow].start;
    final lastKeptIndex = _rows[lastKeptRow].end;

    collectGarbage(
      calculateLeadingGarbage(firstIndex: firstKeptIndex),
      calculateTrailingGarbage(lastIndex: lastKeptIndex),
    );

    RenderBox? child;
    for (var r = firstKeptRow; r <= lastKeptRow; r++) {
      final row = _rows[r];
      final rowStartOffset = r * rowHeight;
      double crossOffset = 0.0;
      for (var i = row.start; i <= row.end; i++) {
        child = _getOrCreateChildAtIndex(i, childConstraints, child);
        (child.parentData as SliverWrapParentData)
          ..layoutOffset = rowStartOffset
          ..crossAxisOffset = crossOffset;
        crossOffset += row.childWidths[i - row.start] + _spacing;
      }
    }

    final childCount = childManager.childCount;
    final endOffset = _rows.last.end == childCount - 1
        ? (_rows.length * rowHeight)
        : (_rows.last.start + 1) * rowHeight;

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

    final paintExtent = calculatePaintOffset(
      constraints,
      from: firstKeptRow * rowHeight,
      to: endOffset,
    );
    final cacheExtent = calculateCacheOffset(
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
