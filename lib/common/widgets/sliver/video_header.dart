import 'package:PiliPlus/common/widgets/sliver/sliver_pinned_dynamic_header.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';

class VideoHeader extends SliverPinnedDynamicHeader {
  const VideoHeader({
    super.key,
    required super.minExtent,
    required super.maxExtent,
    required this.minVideoHeight,
    required this.onScrollRatioChanged,
    required super.child,
  });

  final double minVideoHeight;
  final ValueChanged<double> onScrollRatioChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderVideoHeader(
      minExtent: minExtent,
      maxExtent: maxExtent,
      minVideoHeight: minVideoHeight,
      onScrollRatioChanged: onScrollRatioChanged,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderVideoHeader renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject.minVideoHeight = minVideoHeight;
  }
}

class RenderVideoHeader extends RenderSliverPinnedDynamicHeader {
  RenderVideoHeader({
    required super.minExtent,
    required super.maxExtent,
    required this.minVideoHeight,
    required this.onScrollRatioChanged,
  });

  double? _scrollRatio;
  double minVideoHeight;
  final ValueChanged<double> onScrollRatioChanged;

  @override
  void performLayout() {
    super.performLayout();
    final scrollOffset = constraints.scrollOffset;
    final offset = scrollOffset - (maxExtent - minVideoHeight);
    final scrollRatio = clampDouble(
      offset.toPrecision(2) / (minVideoHeight - kToolbarHeight).toPrecision(2),
      0.0,
      1.0,
    );
    if (_scrollRatio != scrollRatio) {
      _scrollRatio = scrollRatio;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onScrollRatioChanged(scrollRatio);
      });
    }
  }
}
