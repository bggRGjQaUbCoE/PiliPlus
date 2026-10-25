import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/sliver/sliver_pinned_header.dart';
import 'package:flutter/widgets.dart';

class LiveSliverPinnedHeader extends SliverPinnedHeader {
  const LiveSliverPinnedHeader({
    super.key,
    required super.child,
    super.backgroundColor,
    required this.areaHeight,
  });

  final double areaHeight;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderLiveSliverPinnedHeader(
        backgroundColor: backgroundColor,
        areaHeight: areaHeight,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderLiveSliverPinnedHeader renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject.areaHeight = areaHeight;
  }
}

class RenderLiveSliverPinnedHeader extends RenderSliverPinnedHeader {
  RenderLiveSliverPinnedHeader({
    required super.backgroundColor,
    required this._areaHeight,
  });

  double _areaHeight;

  set areaHeight(double value) {
    if (_areaHeight == value) return;
    _areaHeight = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    super.performLayout();
    final double childExtent = child!.size.height;
    geometry = geometry!.copyWith(
      paintOrigin: -math.min(
        constraints.scrollOffset,
        childExtent - _areaHeight,
      ),
    );
  }
}
