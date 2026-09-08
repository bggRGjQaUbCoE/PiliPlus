// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/rendering.dart' show RenderFlex, FlexParentData;
import 'package:material_ui/material_ui.dart';

class DynTabBar extends TabBar {
  const DynTabBar({
    super.key,
    required super.tabs,
    super.controller,
    super.scrollController,
    super.isScrollable,
    super.padding,
    super.indicatorColor,
    super.automaticIndicatorColorAdjustment,
    super.indicatorWeight,
    super.indicatorPadding,
    super.indicator,
    super.indicatorSize,
    super.dividerColor,
    super.dividerHeight,
    super.labelColor,
    super.labelStyle,
    super.labelPadding,
    super.unselectedLabelColor,
    super.unselectedLabelStyle,
    super.dragStartBehavior,
    super.overlayColor,
    super.mouseCursor,
    super.enableFeedback,
    super.onTap,
    super.onHover,
    super.onFocusChange,
    super.physics,
    super.splashFactory,
    super.splashBorderRadius,
    super.tabAlignment,
    super.textScaler,
    super.indicatorAnimation,
  });

  @override
  State<TabBar> createState() => _DynTabBarState();
}

class _DynTabBarState extends TabBarState {
  @override
  void applyFillAlignment(index, wrappedTabs, effectiveTabAlignment) {
    return;
  }

  @override
  Widget buildTabLabelBar({
    required TabBarLayoutCallback onPerformLayout,
    required MainAxisSize mainAxisSize,
    required List<Widget> children,
  }) {
    return _TabLabelBar(
      onPerformLayout: onPerformLayout,
      mainAxisSize: .max,
      children: children,
    );
  }

  @override
  IndicatorPainter buildIndicator({
    required TabController controller,
    required Decoration indicator,
    required TabBarIndicatorSize indicatorSize,
    required List<GlobalKey> tabKeys,
    required IndicatorPainter? old,
    required EdgeInsetsGeometry indicatorPadding,
    required List<EdgeInsetsGeometry> labelPaddings,
    Color? dividerColor,
    double? dividerHeight,
    required bool showDivider,
    double? devicePixelRatio,
    required TabIndicatorAnimation indicatorAnimation,
    required TextDirection textDirection,
  }) {
    return _IndicatorPainter(
      controller: controller,
      indicator: indicator,
      indicatorSize: indicatorSize,
      indicatorPadding: indicatorPadding,
      tabKeys: tabKeys,
      old: old,
      labelPaddings: labelPaddings,
      dividerColor: dividerColor,
      dividerHeight: dividerHeight,
      showDivider: showDivider,
      devicePixelRatio: devicePixelRatio,
      indicatorAnimation: indicatorAnimation,
      textDirection: textDirection,
    );
  }
}

class _IndicatorPainter extends IndicatorPainter {
  _IndicatorPainter({
    required super.controller,
    required super.indicator,
    required super.indicatorSize,
    required super.tabKeys,
    required super.old,
    required super.indicatorPadding,
    required super.labelPaddings,
    super.dividerColor,
    super.dividerHeight,
    required super.showDivider,
    super.devicePixelRatio,
    required super.indicatorAnimation,
    required super.textDirection,
  }) : super.builder(repaint: IndicatorPainterNotifier());

  int _correctTabIndex(int tabIndex) {
    if (tabIndex == tabKeys.length - 1) return tabIndex + 1;
    return tabIndex;
  }

  @override
  double centerOf(int tabIndex) {
    return super.centerOf(_correctTabIndex(tabIndex));
  }

  @override
  Rect indicatorRect(Size tabBarSize, int tabIndex) {
    return super.indicatorRect(tabBarSize, _correctTabIndex(tabIndex));
  }
}

class _TabLabelBar extends Flex {
  const _TabLabelBar({
    super.children,
    required this.onPerformLayout,
    required super.mainAxisSize,
  }) : super(
         direction: Axis.horizontal,
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.center,
         verticalDirection: VerticalDirection.down,
       );

  final TabBarLayoutCallback onPerformLayout;

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _TabLabelBarRenderer(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context)!,
      verticalDirection: verticalDirection,
      onPerformLayout: onPerformLayout,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _TabLabelBarRenderer renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }
}

class _TabLabelBarRenderer extends RenderFlex {
  _TabLabelBarRenderer({
    required super.direction,
    required super.mainAxisSize,
    required super.mainAxisAlignment,
    required super.crossAxisAlignment,
    required super.textDirection,
    required super.verticalDirection,
    required this.onPerformLayout,
  });

  TabBarLayoutCallback onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    RenderBox? child = firstChild;
    final xOffsets = <double>[];
    while (child != null) {
      final childParentData = child.parentData! as FlexParentData;
      xOffsets.add(childParentData.offset.dx);
      assert(child.parentData == childParentData);
      final nextChild = childParentData.nextSibling;
      if (nextChild == null) {
        final dx = size.width - child.size.width;
        xOffsets.add(dx);
        childParentData.offset = Offset(dx, childParentData.offset.dy);
      }
      child = nextChild;
    }
    assert(textDirection != null);
    switch (textDirection!) {
      case TextDirection.rtl:
        xOffsets.insert(0, size.width);
      case TextDirection.ltr:
        xOffsets.add(size.width);
    }
    onPerformLayout(xOffsets, textDirection!, size.width);
  }
}
