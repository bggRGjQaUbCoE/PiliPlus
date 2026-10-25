import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/sliver/sliver_pinned_header.dart';
import 'package:flutter/widgets.dart';

class LiveSliverPinnedHeader extends SliverPinnedHeader {
  const LiveSliverPinnedHeader({
    super.key,
    required super.child,
    super.backgroundColor,
    required this.areaHeight,
    required this.callback,
  });

  final double areaHeight;
  final ValueChanged<double> callback;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderLiveSliverPinnedHeader(
        backgroundColor: backgroundColor,
        areaHeight: areaHeight,
        callback: callback,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderLiveSliverPinnedHeader renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..areaHeight = areaHeight
      ..callback = callback;
  }
}

class RenderLiveSliverPinnedHeader extends RenderSliverPinnedHeader {
  RenderLiveSliverPinnedHeader({
    required super.backgroundColor,
    required this._areaHeight,
    required this.callback,
  });

  double _areaHeight;
  set areaHeight(double value) {
    if (_areaHeight == value) return;
    _areaHeight = value;
    markNeedsLayout();
  }

  ValueChanged<double> callback;

  @override
  void performLayout() {
    super.performLayout();
    final double childExtent = child!.size.height;
    final offset = childExtent - _areaHeight;
    geometry = geometry!.copyWith(
      paintOrigin: -math.min(constraints.scrollOffset, offset),
    );
    callback(offset);
  }
}
