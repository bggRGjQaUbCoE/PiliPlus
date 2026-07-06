import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderSliverToBoxAdapter;

class TrendingHeader extends SliverToBoxAdapter {
  const TrendingHeader({
    super.key,
    required this.offset,
    required this.onScrollRatioChanged,
    required super.child,
  });

  final double offset;
  final ValueChanged<double> onScrollRatioChanged;

  @override
  RenderSliverToBoxAdapter createRenderObject(BuildContext context) {
    return RenderTrendingHeader(
      offset: offset,
      onScrollRatioChanged: onScrollRatioChanged,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTrendingHeader renderObject,
  ) {
    renderObject.offset = offset;
  }
}

class RenderTrendingHeader extends RenderSliverToBoxAdapter {
  RenderTrendingHeader({
    required this.offset,
    required this.onScrollRatioChanged,
  });

  double offset;
  double? _scrollRatio;
  final ValueChanged<double> onScrollRatioChanged;

  @override
  void performLayout() {
    super.performLayout();
    final scrollOffset = constraints.scrollOffset;
    final scrollRatio = clampDouble(scrollOffset / offset, 0.0, 1.0);
    if (_scrollRatio != scrollRatio) {
      _scrollRatio = scrollRatio;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onScrollRatioChanged(scrollRatio);
      });
    }
  }
}
