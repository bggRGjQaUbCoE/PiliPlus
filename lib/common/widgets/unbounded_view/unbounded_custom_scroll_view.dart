import 'package:PiliPlus/common/widgets/unbounded_view/unbounded_render_viewport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UnboundedCustomScrollView extends CustomScrollView {
  const UnboundedCustomScrollView({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.scrollBehavior,
    super.shrinkWrap,
    super.center,
    super.anchor,
    super.cacheExtent,
    super.paintOrder,
    super.slivers,
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    super.hitTestBehavior,
  }) : assert(center == null || !shrinkWrap);

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset offset,
    AxisDirection axisDirection,
    List<Widget> slivers,
  ) {
    return UnboundedViewport(
      axisDirection: axisDirection,
      offset: offset,
      slivers: slivers,
      cacheExtent: cacheExtent,
      center: center,
      anchor: anchor,
      paintOrder: paintOrder,
      clipBehavior: clipBehavior,
    );
  }
}

class UnboundedViewport extends Viewport {
  UnboundedViewport({
    super.key,
    super.axisDirection,
    super.crossAxisDirection,
    super.anchor,
    required super.offset,
    super.center,
    super.cacheExtent,
    super.cacheExtentStyle,
    super.paintOrder,
    super.clipBehavior,
    super.slivers,
  });

  @override
  RenderViewport createRenderObject(BuildContext context) {
    return UnboundedRenderViewport(
      axisDirection: axisDirection,
      crossAxisDirection:
          crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
      cacheExtentStyle: cacheExtentStyle,
      paintOrder: paintOrder,
      clipBehavior: clipBehavior,
    );
  }
}
