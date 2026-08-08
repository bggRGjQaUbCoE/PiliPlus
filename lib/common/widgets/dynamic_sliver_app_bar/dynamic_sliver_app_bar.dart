/*
 * This file is part of PiliPlus
 *
 * PiliPlus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PiliPlus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with PiliPlus.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/custom_height_widget.dart';
import 'package:PiliPlus/common/widgets/dynamic_sliver_app_bar/rendering/sliver_persistent_header.dart';
import 'package:PiliPlus/common/widgets/dynamic_sliver_app_bar/sliver_persistent_header.dart';
import 'package:PiliPlus/common/widgets/only_layout_widget.dart'
    show LayoutCallback;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide SliverPersistentHeader, SliverPersistentHeaderDelegate;
import 'package:flutter/rendering.dart' show RenderOpacity, OpacityLayer;
import 'package:flutter/services.dart';

/// ref [SliverAppBar]
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.leading,
    required this.automaticallyImplyLeading,
    required this.title,
    required this.actions,
    required this.automaticallyImplyActions,
    required this.flexibleSpace,
    required this.bottom,
    required this.elevation,
    required this.scrolledUnderElevation,
    required this.shadowColor,
    required this.surfaceTintColor,
    required this.forceElevated,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconTheme,
    required this.actionsIconTheme,
    required this.primary,
    required this.centerTitle,
    required this.excludeHeaderSemantics,
    required this.titleSpacing,
    required this.collapsedHeight,
    required this.topPadding,
    required this.shape,
    required this.toolbarHeight,
    required this.leadingWidth,
    required this.toolbarTextStyle,
    required this.titleTextStyle,
    required this.systemOverlayStyle,
    required this.forceMaterialTransparency,
    required this.useDefaultSemanticsOrder,
    required this.clipBehavior,
    required this.actionsPadding,
  }) : assert(primary || topPadding == 0.0),
       _bottomHeight = bottom?.preferredSize.height ?? 0.0;

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget>? actions;
  final bool automaticallyImplyActions;
  final Widget flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final bool forceElevated;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double collapsedHeight;
  final double topPadding;
  final ShapeBorder? shape;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double _bottomHeight;
  final bool forceMaterialTransparency;
  final bool useDefaultSemanticsOrder;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry? actionsPadding;

  @override
  double get minExtent => collapsedHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
    double? maxExtent,
  ) {
    maxExtent ??= double.infinity;
    final bool isScrolledUnder =
        overlapsContent ||
        forceElevated ||
        (shrinkOffset > maxExtent - minExtent);
    final effectiveTitle = AnimatedOpacity(
      opacity: isScrolledUnder ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      curve: const Cubic(0.2, 0.0, 0.0, 1.0),
      child: title,
    );

    return FlexibleSpaceBar.createSettings(
      minExtent: minExtent,
      maxExtent: maxExtent,
      currentExtent: math.max(minExtent, maxExtent - shrinkOffset),
      isScrolledUnder: isScrolledUnder,
      hasLeading: leading != null || automaticallyImplyLeading,
      child: AppBar(
        clipBehavior: clipBehavior,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: effectiveTitle,
        actions: actions,
        automaticallyImplyActions: automaticallyImplyActions,
        flexibleSpace: IgnorePointer(
          ignoring: isScrolledUnder,
          child: DynamicFlexibleSpaceBar(background: flexibleSpace),
        ),
        bottom: bottom,
        elevation: isScrolledUnder ? elevation : 0.0,
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        iconTheme: iconTheme,
        actionsIconTheme: actionsIconTheme,
        primary: primary,
        centerTitle: centerTitle,
        excludeHeaderSemantics: excludeHeaderSemantics,
        titleSpacing: titleSpacing,
        shape: shape,
        toolbarHeight: toolbarHeight,
        leadingWidth: leadingWidth,
        toolbarTextStyle: toolbarTextStyle,
        titleTextStyle: titleTextStyle,
        systemOverlayStyle: systemOverlayStyle,
        forceMaterialTransparency: forceMaterialTransparency,
        useDefaultSemanticsOrder: useDefaultSemanticsOrder,
        actionsPadding: actionsPadding,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return leading != oldDelegate.leading ||
        automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
        title != oldDelegate.title ||
        actions != oldDelegate.actions ||
        automaticallyImplyActions != oldDelegate.automaticallyImplyActions ||
        flexibleSpace != oldDelegate.flexibleSpace ||
        bottom != oldDelegate.bottom ||
        _bottomHeight != oldDelegate._bottomHeight ||
        elevation != oldDelegate.elevation ||
        shadowColor != oldDelegate.shadowColor ||
        backgroundColor != oldDelegate.backgroundColor ||
        foregroundColor != oldDelegate.foregroundColor ||
        iconTheme != oldDelegate.iconTheme ||
        actionsIconTheme != oldDelegate.actionsIconTheme ||
        primary != oldDelegate.primary ||
        centerTitle != oldDelegate.centerTitle ||
        titleSpacing != oldDelegate.titleSpacing ||
        topPadding != oldDelegate.topPadding ||
        forceElevated != oldDelegate.forceElevated ||
        toolbarHeight != oldDelegate.toolbarHeight ||
        leadingWidth != oldDelegate.leadingWidth ||
        toolbarTextStyle != oldDelegate.toolbarTextStyle ||
        titleTextStyle != oldDelegate.titleTextStyle ||
        systemOverlayStyle != oldDelegate.systemOverlayStyle ||
        forceMaterialTransparency != oldDelegate.forceMaterialTransparency ||
        useDefaultSemanticsOrder != oldDelegate.useDefaultSemanticsOrder ||
        actionsPadding != oldDelegate.actionsPadding;
  }

  @override
  String toString() {
    return '${describeIdentity(this)}(topPadding: ${topPadding.toStringAsFixed(1)}, bottomHeight: ${_bottomHeight.toStringAsFixed(1)}, ...)';
  }
}

class DynamicSliverAppBar extends StatelessWidget {
  const DynamicSliverAppBar.medium({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    required this.title,
    this.actions,
    this.automaticallyImplyActions = true,
    required this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.forceElevated = false,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.shape,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.useDefaultSemanticsOrder = true,
    this.clipBehavior,
    this.actionsPadding,
    this.onPerformLayout,
  });

  final LayoutCallback? onPerformLayout;

  final Widget? leading;

  final bool automaticallyImplyLeading;

  final Widget title;

  final List<Widget>? actions;

  final bool automaticallyImplyActions;

  final Widget flexibleSpace;

  final PreferredSizeWidget? bottom;

  final double? elevation;

  final double? scrolledUnderElevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final bool forceElevated;

  final Color? backgroundColor;

  final Color? foregroundColor;

  final IconThemeData? iconTheme;

  final IconThemeData? actionsIconTheme;

  final bool primary;

  final bool? centerTitle;

  final bool excludeHeaderSemantics;

  final double? titleSpacing;

  final ShapeBorder? shape;

  final double? leadingWidth;

  final TextStyle? toolbarTextStyle;

  final TextStyle? titleTextStyle;

  final SystemUiOverlayStyle? systemOverlayStyle;

  final bool forceMaterialTransparency;

  final bool useDefaultSemanticsOrder;

  final Clip? clipBehavior;

  final EdgeInsetsGeometry? actionsPadding;

  @override
  Widget build(BuildContext context) {
    final double bottomHeight = bottom?.preferredSize.height ?? 0.0;
    final double topPadding = primary
        ? MediaQuery.viewPaddingOf(context).top
        : 0.0;
    final double effectiveCollapsedHeight =
        topPadding + kToolbarHeight + bottomHeight + 1;

    return SliverPinnedHeader(
      onPerformLayout: onPerformLayout,
      delegate: _SliverAppBarDelegate(
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: title,
        actions: actions,
        automaticallyImplyActions: automaticallyImplyActions,
        flexibleSpace: flexibleSpace,
        bottom: bottom,
        elevation: elevation,
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        forceElevated: forceElevated,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        iconTheme: iconTheme,
        actionsIconTheme: actionsIconTheme,
        primary: primary,
        centerTitle: centerTitle,
        excludeHeaderSemantics: excludeHeaderSemantics,
        titleSpacing: titleSpacing,
        collapsedHeight: effectiveCollapsedHeight,
        topPadding: topPadding,
        shape: shape,
        toolbarHeight: kToolbarHeight,
        leadingWidth: leadingWidth,
        toolbarTextStyle: toolbarTextStyle,
        titleTextStyle: titleTextStyle,
        systemOverlayStyle: systemOverlayStyle,
        forceMaterialTransparency: forceMaterialTransparency,
        useDefaultSemanticsOrder: useDefaultSemanticsOrder,
        clipBehavior: clipBehavior,
        actionsPadding: actionsPadding,
      ),
    );
  }
}

/// ref [FlexibleSpaceBar]
class DynamicFlexibleSpaceBar extends StatelessWidget {
  const DynamicFlexibleSpaceBar({
    super.key,
    required this.background,
    this.collapseMode = CollapseMode.parallax,
  });

  final Widget background;

  final CollapseMode collapseMode;

  static double _getCollapsePadding(
    CollapseMode collapseMode,
    double t,
    FlexibleSpaceBarSettings settings,
  ) {
    switch (collapseMode) {
      case CollapseMode.pin:
        return -(settings.maxExtent - settings.currentExtent);
      case CollapseMode.none:
        return 0.0;
      case CollapseMode.parallax:
        final double deltaExtent = settings.maxExtent - settings.minExtent;
        return -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    final FlexibleSpaceBarSettings settings = context
        .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

    double? height;
    final double opacity;
    final double topPadding;
    if (settings.maxExtent == .infinity) {
      opacity = 1.0;
      topPadding = 0.0;
    } else {
      height = settings.maxExtent;

      final double deltaExtent = settings.maxExtent - settings.minExtent;

      // 0.0 -> Expanded
      // 1.0 -> Collapsed to toolbar
      final double t = clampDouble(
        1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent,
        0.0,
        1.0,
      );

      final double fadeStart = math.max(
        0.0,
        1.0 - kToolbarHeight / deltaExtent,
      );
      const fadeEnd = 1.0;
      assert(fadeStart <= fadeEnd);
      // If the min and max extent are the same, the app bar cannot collapse
      // and the content should be visible, so opacity = 1.
      opacity = settings.maxExtent == settings.minExtent
          ? 1.0
          : 1.0 - Interval(fadeStart, fadeEnd).transform(t);

      topPadding = _getCollapsePadding(collapseMode, t, settings);
    }

    return ClipRect(
      child: CustomHeightWidget(
        height: height,
        offset: Offset(0.0, topPadding),
        child: _FlexibleSpaceHeaderOpacity(
          // IOS is relying on this semantics node to correctly traverse
          // through the app bar when it is collapsed.
          alwaysIncludeSemantics: true,
          opacity: opacity,
          child: background,
        ),
      ),
    );
  }
}

/// [_FlexibleSpaceHeaderOpacity]
class _FlexibleSpaceHeaderOpacity extends SingleChildRenderObjectWidget {
  const _FlexibleSpaceHeaderOpacity({
    required this.opacity,
    required super.child,
    required this.alwaysIncludeSemantics,
  });

  final double opacity;
  final bool alwaysIncludeSemantics;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderFlexibleSpaceHeaderOpacity(
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderFlexibleSpaceHeaderOpacity renderObject,
  ) {
    renderObject
      ..alwaysIncludeSemantics = alwaysIncludeSemantics
      ..opacity = opacity;
  }
}

class _RenderFlexibleSpaceHeaderOpacity extends RenderOpacity {
  _RenderFlexibleSpaceHeaderOpacity({
    super.opacity,
    super.alwaysIncludeSemantics,
  });

  @override
  bool get isRepaintBoundary => false;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }
    if ((opacity * 255).roundToDouble() <= 0) {
      layer = null;
      return;
    }
    assert(needsCompositing);
    layer = context.pushOpacity(
      offset,
      (opacity * 255).round(),
      super.paint,
      oldLayer: layer as OpacityLayer?,
    );
    assert(() {
      layer!.debugCreator = debugCreator;
      return true;
    }());
  }
}
