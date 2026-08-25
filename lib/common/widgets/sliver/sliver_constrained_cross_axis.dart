import 'package:flutter/rendering.dart'
    show RenderSliverConstrainedCrossAxis, SliverHitTestResult, RenderSliver;
import 'package:material_ui/material_ui.dart';

class CenteredSliverConstrainedCrossAxis extends SliverConstrainedCrossAxis {
  const CenteredSliverConstrainedCrossAxis({
    super.key,
    required super.maxExtent,
    required super.sliver,
  });

  @override
  Widget build(BuildContext context) {
    return SliverZeroFlexParentDataWidget(
      sliver: _CenteredSliverConstrainedCrossAxis(
        maxExtent: maxExtent,
        sliver: sliver,
      ),
    );
  }
}

class _CenteredSliverConstrainedCrossAxis extends SliverConstrainedCrossAxis_ {
  const _CenteredSliverConstrainedCrossAxis({
    required super.maxExtent,
    required super.sliver,
  });

  @override
  CenteredRenderSliverConstrainedCrossAxis createRenderObject(
    BuildContext context,
  ) {
    return CenteredRenderSliverConstrainedCrossAxis(maxExtent: maxExtent);
  }
}

class CenteredRenderSliverConstrainedCrossAxis
    extends RenderSliverConstrainedCrossAxis {
  CenteredRenderSliverConstrainedCrossAxis({required super.maxExtent});

  Offset _offset = .zero;

  @override
  void performLayout() {
    super.performLayout();
    _offset = Offset(
      (constraints.crossAxisExtent - geometry!.crossAxisExtent!) / 2,
      0.0,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset + _offset);
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    return super.hitTestChildren(
      result,
      mainAxisPosition: mainAxisPosition,
      crossAxisPosition: crossAxisPosition - _offset.dx,
    );
  }

  @override
  void applyPaintTransform(RenderSliver child, Matrix4 transform) {
    if (_offset.dx != 0) {
      transform.translateByDouble(_offset.dx, 0.0, 0.0, 1.0);
    }
    super.applyPaintTransform(child, transform);
  }
}
