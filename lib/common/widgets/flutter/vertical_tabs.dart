// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show SemanticsRole, lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double _kTabWidth = 51.0;
const double _kTextAndIconTabWidth = 72.0;
const EdgeInsets _kTabLabelPadding = EdgeInsets.symmetric(
  vertical: 7.0,
  horizontal: 5.0,
);

/// A Material Design [VerticalTabBar] tab.
///
/// If both [icon] and [text] are provided, the text is displayed below
/// the icon.
///
/// See also:
///
///  * [VerticalTabBar], which displays a row of tabs.
///  * [TabBarView], which displays a widget for the currently selected tab.
///  * [TabController], which coordinates tab selection between a [VerticalTabBar] and a [TabBarView].
///  * <https://material.io/design/components/tabs.html>
class VerticalTab extends StatelessWidget {
  /// Creates a Material Design [VerticalTabBar] tab.
  ///
  /// At least one of [text], [icon], and [child] must be non-null. The [text]
  /// and [child] arguments must not be used at the same time. The
  /// [iconMargin] is only useful when [icon] and either one of [text] or
  /// [child] is non-null.
  const VerticalTab({
    super.key,
    this.text,
    this.icon,
    this.iconMargin,
    this.width,
    this.child,
  }) : assert(text != null || child != null || icon != null),
       assert(text == null || child == null);

  /// The text to display as the tab's label.
  ///
  /// Must not be used in combination with [child].
  final String? text;

  /// The widget to be used as the tab's label.
  ///
  /// Usually a [Text] widget, possibly wrapped in a [Semantics] widget.
  ///
  /// Must not be used in combination with [text].
  final Widget? child;

  /// An icon to display as the tab's label.
  final Widget? icon;

  /// The margin added around the tab's icon.
  ///
  /// Only useful when used in combination with [icon], and either one of
  /// [text] or [child] is non-null.
  ///
  /// Defaults to 2 pixels of bottom margin. If [ThemeData.useMaterial3] is false,
  /// then defaults to 10 pixels of bottom margin.
  final EdgeInsetsGeometry? iconMargin;

  /// The height of the [VerticalTab].
  ///
  /// If null, the height will be calculated based on the content of the [VerticalTab]. When `icon` is not
  /// null along with `child` or `text`, the default height is 72.0 pixels. Without an `icon`, the
  /// height is 46.0 pixels.
  ///
  /// {@tool snippet}
  ///
  /// The provided tab height cannot be lower than the default height. Use
  /// [PreferredSize] widget to adjust the overall [VerticalTabBar] height and match
  /// the provided tab [height]:
  ///
  /// ```dart
  /// bottom: const PreferredSize(
  ///   preferredSize: Size.fromHeight(20.0),
  ///   child: TabBar(
  ///     tabs: <Widget>[
  ///       Tab(
  ///         text: 'Tab 1',
  ///         height: 20.0,
  ///       ),
  ///       Tab(
  ///         text: 'Tab 2',
  ///         height: 20.0,
  ///       ),
  ///     ],
  ///   ),
  /// ),
  /// ```
  /// {@end-tool}
  final double? width;

  Widget _buildLabelText() {
    return child ?? Text(text!, style: const TextStyle(fontSize: 15));
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    final double calculatedWidth;
    final Widget label;
    if (icon == null) {
      calculatedWidth = _kTabWidth;
      label = _buildLabelText();
    } else if (text == null && child == null) {
      calculatedWidth = _kTabWidth;
      label = icon!;
    } else {
      calculatedWidth = _kTextAndIconTabWidth;
      final EdgeInsetsGeometry effectiveIconMargin =
          iconMargin ??
          (Theme.of(context).useMaterial3
              ? _TabsPrimaryDefaultsM3.iconMargin
              : _TabsDefaultsM2.iconMargin);
      // dom
      label = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: effectiveIconMargin, child: icon),
          Flexible(child: _buildLabelText()),
        ],
      );
    }

    return SizedBox(
      width: width ?? calculatedWidth, // dom
      child: Center(heightFactor: 1.0, child: label),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text, defaultValue: null));
  }
}

class _TabStyle extends AnimatedWidget {
  const _TabStyle({
    required Animation<double> animation,
    required this.isSelected,
    required this.isPrimary,
    required this.labelColor,
    required this.unselectedLabelColor,
    required this.labelStyle,
    required this.unselectedLabelStyle,
    required this.defaults,
    required this.child,
  }) : super(listenable: animation);

  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool isSelected;
  final bool isPrimary;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TabBarThemeData defaults;
  final Widget child;

  WidgetStateColor _resolveWithLabelColor(
    BuildContext context, {
    IconThemeData? iconTheme,
  }) {
    final ThemeData themeData = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    // labelStyle.color (and tabBarTheme.labelStyle.color) is not considered
    // as it'll be a breaking change without a possible migration plan. for
    // details: https://github.com/flutter/flutter/pull/109541#issuecomment-1294241417
    Color selectedColor =
        labelColor ??
        tabBarTheme.labelColor ??
        labelStyle?.color ??
        tabBarTheme.labelStyle?.color ??
        defaults.labelColor!;

    final Color unselectedColor;

    if (selectedColor is WidgetStateColor) {
      unselectedColor = selectedColor.resolve(const <WidgetState>{});
      selectedColor = selectedColor.resolve(const <WidgetState>{
        WidgetState.selected,
      });
    } else {
      // unselectedLabelColor and tabBarTheme.unselectedLabelColor are ignored
      // when labelColor is a WidgetStateColor.
      unselectedColor =
          unselectedLabelColor ??
          tabBarTheme.unselectedLabelColor ??
          unselectedLabelStyle?.color ??
          tabBarTheme.unselectedLabelStyle?.color ??
          iconTheme?.color ??
          (themeData.useMaterial3
              ? defaults.unselectedLabelColor!
              : selectedColor.withAlpha(0xB2)); // 70% alpha
    }

    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Color.lerp(selectedColor, unselectedColor, animation.value)!;
      }
      return Color.lerp(unselectedColor, selectedColor, animation.value)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    final Set<WidgetState> states = isSelected
        ? const <WidgetState>{WidgetState.selected}
        : const <WidgetState>{};

    // To enable TextStyle.lerp(style1, style2, value), both styles must have
    // the same value of inherit. Force that to be inherit=true here.
    final TextStyle selectedStyle = defaults.labelStyle!
        .merge(labelStyle ?? tabBarTheme.labelStyle)
        .copyWith(inherit: true);
    final TextStyle unselectedStyle = defaults.unselectedLabelStyle!
        .merge(
          unselectedLabelStyle ??
              tabBarTheme.unselectedLabelStyle ??
              labelStyle,
        )
        .copyWith(inherit: true);
    final TextStyle textStyle = isSelected
        ? TextStyle.lerp(selectedStyle, unselectedStyle, animation.value)!
        : TextStyle.lerp(unselectedStyle, selectedStyle, animation.value)!;
    final Color defaultIconColor = switch (theme.colorScheme.brightness) {
      Brightness.light => kDefaultIconDarkColor,
      Brightness.dark => kDefaultIconLightColor,
    };
    final IconThemeData? customIconTheme = switch (IconTheme.of(context)) {
      final IconThemeData iconTheme when iconTheme.color != defaultIconColor =>
        iconTheme,
      _ => null,
    };
    final Color iconColor = _resolveWithLabelColor(
      context,
      iconTheme: customIconTheme,
    ).resolve(states);
    final Color labelColor = _resolveWithLabelColor(context).resolve(states);

    return DefaultTextStyle(
      style: textStyle.copyWith(color: labelColor),
      child: IconTheme.merge(
        data: IconThemeData(
          size: customIconTheme?.size ?? 24.0,
          color: iconColor,
        ),
        child: child,
      ),
    );
  }
}

typedef _LayoutCallback =
    void Function(
      List<double> yOffsets,
      TextDirection textDirection,
      double width,
    );

class _TabLabelBarRenderer extends RenderFlex {
  _TabLabelBarRenderer({
    required super.direction,
    required super.mainAxisSize,
    required super.mainAxisAlignment,
    required super.crossAxisAlignment,
    required TextDirection super.textDirection,
    required super.verticalDirection,
    required this.onPerformLayout,
  });

  _LayoutCallback onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    // yOffsets will contain childCount+1 values, giving the offsets of the
    // leading edge of the first tab as the first value, of the leading edge of
    // the each subsequent tab as each subsequent value, and of the trailing
    // edge of the last tab as the last value.
    RenderBox? child = firstChild;
    final List<double> yOffsets = <double>[];
    while (child != null) {
      final FlexParentData childParentData =
          child.parentData! as FlexParentData;
      yOffsets.add(childParentData.offset.dy); // dom
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    yOffsets.add(size.height);
    onPerformLayout(yOffsets, .ltr, size.height);
  }
}

// This class and its renderer class only exist to report the widths of the tabs
// upon layout. The tab widths are only used at paint time (see _IndicatorPainter)
// or in response to input.
class _TabLabelBar extends Flex {
  const _TabLabelBar({
    super.children,
    required this.onPerformLayout,
    required super.mainAxisSize,
  }) : super(
         direction: Axis.vertical, // dom
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start, // dom
         verticalDirection: VerticalDirection.down,
       );

  final _LayoutCallback onPerformLayout;

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _TabLabelBarRenderer(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: .ltr, // getEffectiveTextDirection(context)!,
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

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation!.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging) {
    return clampDouble((currentIndex - controllerValue).abs(), 0.0, 1.0);
  }

  // The TabController animation's value is changing from previousIndex to currentIndex.
  return (controllerValue - currentIndex).abs() /
      (currentIndex - previousIndex).abs();
}

class _DividerPainter extends CustomPainter {
  _DividerPainter({required this.dividerColor, required this.dividerWidth});

  final Color dividerColor;
  final double dividerWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (dividerWidth <= 0.0) {
      return;
    }

    final Paint paint = Paint()
      ..color = dividerColor
      ..strokeWidth = dividerWidth;

    // dom
    final dx = size.width - (paint.strokeWidth / 2);
    canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
  }

  @override
  bool shouldRepaint(_DividerPainter oldDelegate) {
    return oldDelegate.dividerColor != dividerColor ||
        oldDelegate.dividerWidth != dividerWidth;
  }
}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter({
    required this.controller,
    required this.indicator,
    required this.indicatorSize,
    required this.tabKeys,
    required _IndicatorPainter? old,
    required this.indicatorPadding,
    required this.labelPadding,
    this.dividerColor,
    this.dividerWidth,
    required this.showDivider,
    this.devicePixelRatio,
    required this.indicatorAnimation,
    required this.textDirection,
  }) : super(repaint: controller.animation) {
    assert(debugMaybeDispatchCreated('material', '_IndicatorPainter', this));
    if (old != null) {
      saveTabOffsets(old._currentTabOffsets, old._currentTextDirection);
    }
  }

  final TabController controller;
  final Decoration indicator;
  final TabBarIndicatorSize indicatorSize;
  final EdgeInsetsGeometry indicatorPadding;
  final List<GlobalKey> tabKeys;
  final EdgeInsetsGeometry labelPadding;
  final Color? dividerColor;
  final double? dividerWidth;
  final bool showDivider;
  final double? devicePixelRatio;
  final TabIndicatorAnimation indicatorAnimation;
  final TextDirection textDirection;

  // _currentTabOffsets and _currentTextDirection are set each time TabBar
  // layout is completed. These values can be null when TabBar contains no
  // tabs, since there are nothing to lay out.
  List<double>? _currentTabOffsets;
  TextDirection? _currentTextDirection;

  Rect? _currentRect;
  BoxPainter? _painter;
  bool _needsPaint = false;
  void markNeedsPaint() {
    _needsPaint = true;
  }

  void dispose() {
    assert(debugMaybeDispatchDisposed(this));
    _painter?.dispose();
  }

  void saveTabOffsets(List<double>? tabOffsets, TextDirection? textDirection) {
    _currentTabOffsets = tabOffsets;
    _currentTextDirection = textDirection;
  }

  // _currentTabOffsets[index] is the offset of the start edge of the tab at index, and
  // _currentTabOffsets[_currentTabOffsets.length] is the end edge of the last tab.
  int get maxTabIndex => _currentTabOffsets!.length - 2;

  double centerOf(int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    return (_currentTabOffsets![tabIndex] + _currentTabOffsets![tabIndex + 1]) /
        2.0;
  }

  Rect indicatorRect(Size tabBarSize, int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTextDirection != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    double tabLeft, tabRight;
    (tabLeft, tabRight) = switch (_currentTextDirection!) {
      TextDirection.rtl => (
        _currentTabOffsets![tabIndex + 1],
        _currentTabOffsets![tabIndex],
      ),
      TextDirection.ltr => (
        _currentTabOffsets![tabIndex],
        _currentTabOffsets![tabIndex + 1],
      ),
    };

    if (indicatorSize == TabBarIndicatorSize.label) {
      final double tabWidth =
          tabKeys[tabIndex].currentContext!.size!.height; // dom
      final EdgeInsets insets = labelPadding.resolve(_currentTextDirection);
      final double delta =
          ((tabRight - tabLeft) - (tabWidth + insets.vertical)) / 2.0; // dom
      tabLeft += delta + insets.top; // dom
      tabRight = tabLeft + tabWidth;
    }

    final EdgeInsets insets = indicatorPadding.resolve(_currentTextDirection);
    // dom
    final Rect rect = Rect.fromLTWH(
      0,
      tabLeft,
      tabBarSize.width,
      tabRight - tabLeft,
    );

    if (!(rect.size >= insets.collapsedSize)) {
      throw FlutterError(
        'indicatorPadding insets should be less than Tab Size\n'
        'Rect Size : ${rect.size}, Insets: $insets',
      );
    }
    return insets.deflateRect(rect);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _needsPaint = false;
    _painter ??= indicator.createBoxPainter(markNeedsPaint);

    final double value = controller.animation!.value;

    _currentRect = switch (indicatorAnimation) {
      TabIndicatorAnimation.linear => _applyLinearEffect(
        size: size,
        value: value,
      ),
      TabIndicatorAnimation.elastic => _applyElasticEffect(
        size: size,
        value: value,
      ),
    };

    assert(_currentRect != null);

    final ImageConfiguration configuration = ImageConfiguration(
      size: _currentRect!.size,
      textDirection: _currentTextDirection,
      devicePixelRatio: devicePixelRatio,
    );
    if (showDivider && dividerWidth! > 0) {
      final Paint dividerPaint = Paint()
        ..color = dividerColor!
        ..strokeWidth = dividerWidth!;
      final dx = size.width - (dividerPaint.strokeWidth / 2);
      final Offset dividerP1 = Offset(dx, 0);
      final Offset dividerP2 = Offset(dx, size.height);
      // dom
      canvas.drawLine(dividerP1, dividerP2, dividerPaint);
    }
    _painter!.paint(canvas, _currentRect!.topLeft, configuration);
  }

  /// Applies the linear effect to the indicator.
  Rect? _applyLinearEffect({required Size size, required double value}) {
    final double index = controller.index.toDouble();
    final bool ltr = index > value;
    final int from = (ltr ? value.floor() : value.ceil()).clamp(0, maxTabIndex);
    final int to = (ltr ? from + 1 : from - 1).clamp(0, maxTabIndex);
    final Rect fromRect = indicatorRect(size, from);
    final Rect toRect = indicatorRect(size, to);
    return Rect.lerp(fromRect, toRect, (value - from).abs());
  }

  // Ease out sine (decelerating).
  double decelerateInterpolation(double fraction) {
    return math.sin((fraction * math.pi) / 2.0);
  }

  // Ease in sine (accelerating).
  double accelerateInterpolation(double fraction) {
    return 1.0 - math.cos((fraction * math.pi) / 2.0);
  }

  /// Applies the elastic effect to the indicator.
  // dom
  Rect? _applyElasticEffect({required Size size, required double value}) {
    final double index = controller.index.toDouble();
    double progressLeft = (index - value).abs();

    final int to = progressLeft == 0.0 || !controller.indexIsChanging
        ? switch (textDirection) {
            TextDirection.ltr => value.ceil(),
            TextDirection.rtl => value.floor(),
          }.clamp(0, maxTabIndex)
        : controller.index;
    final int from = progressLeft == 0.0 || !controller.indexIsChanging
        ? switch (textDirection) {
            TextDirection.ltr => (to - 1),
            TextDirection.rtl => (to + 1),
          }.clamp(0, maxTabIndex)
        : controller.previousIndex;
    final Rect toRect = indicatorRect(size, to);
    final Rect fromRect = indicatorRect(size, from);
    final Rect rect = Rect.lerp(fromRect, toRect, (value - from).abs())!;

    // If the tab animation is completed, there is no need to stretch the indicator
    // This only works for the tab change animation via tab index, not when
    // dragging a [TabBarView], but it's still ok, to avoid unnecessary calculations.
    if (controller.animation!.isCompleted) {
      return rect;
    }

    final double tabChangeProgress;

    if (controller.indexIsChanging) {
      final int tabsDelta = (controller.index - controller.previousIndex).abs();
      if (tabsDelta != 0) {
        progressLeft /= tabsDelta;
      }
      tabChangeProgress = 1 - clampDouble(progressLeft, 0.0, 1.0);
    } else {
      tabChangeProgress = (index - value).abs();
    }

    // If the animation has finished, there is no need to apply the stretch effect.
    if (tabChangeProgress == 1.0) {
      return rect;
    }

    final double topFraction;
    final double bottomFraction;
    final bool isMovingRight = switch (textDirection) {
      TextDirection.ltr =>
        controller.indexIsChanging ? index > value : value > index,
      TextDirection.rtl =>
        controller.indexIsChanging ? value > index : index > value,
    };
    if (isMovingRight) {
      topFraction = accelerateInterpolation(tabChangeProgress);
      bottomFraction = decelerateInterpolation(tabChangeProgress);
    } else {
      topFraction = decelerateInterpolation(tabChangeProgress);
      bottomFraction = accelerateInterpolation(tabChangeProgress);
    }

    final double lerpRectTop;
    final double lerpRectBottom;

    // The controller.indexIsChanging is true when the Tab is pressed, instead of swipe to change tabs.
    // If the tab is pressed then only lerp between fromRect and toRect.
    if (controller.indexIsChanging) {
      lerpRectTop = lerpDouble(fromRect.top, toRect.top, topFraction)!;
      lerpRectBottom = lerpDouble(
        fromRect.bottom,
        toRect.bottom,
        bottomFraction,
      )!;
    } else {
      // Switch the Rect left and right lerp order based on swipe direction.
      lerpRectTop = switch (isMovingRight) {
        true => lerpDouble(fromRect.top, toRect.top, topFraction)!,
        false => lerpDouble(toRect.top, fromRect.top, topFraction)!,
      };
      lerpRectBottom = switch (isMovingRight) {
        true => lerpDouble(fromRect.bottom, toRect.bottom, bottomFraction)!,
        false => lerpDouble(toRect.bottom, fromRect.bottom, bottomFraction)!,
      };
    }

    return Rect.fromLTRB(rect.left, lerpRectTop, rect.right, lerpRectBottom);
  }

  @override
  bool shouldRepaint(_IndicatorPainter old) {
    return _needsPaint ||
        controller != old.controller ||
        indicator != old.indicator ||
        tabKeys.length != old.tabKeys.length ||
        (!listEquals(_currentTabOffsets, old._currentTabOffsets)) ||
        _currentTextDirection != old._currentTextDirection;
  }
}

class _ChangeAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _ChangeAnimation(this.controller);

  final TabController controller;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value => _indexChangeProgress(controller);
}

class _DragAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _DragAnimation(this.controller, this.index);

  final TabController controller;
  final int index;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value {
    assert(!controller.indexIsChanging);
    final double controllerMaxValue = (controller.length - 1).toDouble();
    final double controllerValue = clampDouble(
      controller.animation!.value,
      0.0,
      controllerMaxValue,
    );
    return clampDouble((controllerValue - index.toDouble()).abs(), 0.0, 1.0);
  }
}

// This class, and TabBarScrollController, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex. In that case we can
// only compute the scroll position's initial scroll offset (the "correct"
// pixels value) after the TabBar viewport width and scroll limits are known.
class _TabBarScrollPosition extends ScrollPositionWithSingleContext {
  _TabBarScrollPosition({
    required super.physics,
    required super.context,
    required super.oldPosition,
    required this.tabBar,
  }) : super(initialPixels: null);

  final _VerticalTabBarState tabBar;

  bool _viewportDimensionWasNonZero = false;

  // The scroll position should be adjusted at least once.
  bool _needsPixelsCorrection = true;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    bool result = true;
    if (!_viewportDimensionWasNonZero) {
      _viewportDimensionWasNonZero = viewportDimension != 0.0;
    }
    // If the viewport never had a non-zero dimension, we just want to jump
    // to the initial scroll position to avoid strange scrolling effects in
    // release mode: the viewport temporarily may have a dimension of zero
    // before the actual dimension is calculated. In that scenario, setting
    // the actual dimension would cause a strange scroll effect without this
    // guard because the super call below would start a ballistic scroll activity.
    if (!_viewportDimensionWasNonZero || _needsPixelsCorrection) {
      _needsPixelsCorrection = false;
      correctPixels(
        tabBar._initialScrollOffset(
          viewportDimension,
          minScrollExtent,
          maxScrollExtent,
        ),
      );
      result = false;
    }
    return super.applyContentDimensions(minScrollExtent, maxScrollExtent) &&
        result;
  }

  void markNeedsPixelsCorrection() {
    _needsPixelsCorrection = true;
  }
}

// This class, and TabBarScrollPosition, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex.
class _TabBarScrollController extends ScrollController {
  _TabBarScrollController(this.tabBar);

  final _VerticalTabBarState tabBar;

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _TabBarScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      tabBar: tabBar,
    );
  }
}

/// A Material Design primary tab bar.
///
/// Primary tabs are placed at the top of the content pane under a top app bar.
/// They display the main content destinations.
///
/// Typically created as the [AppBar.bottom] part of an [AppBar] and in
/// conjunction with a [TabBarView].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=POtoEH-5l40}
///
/// If a [TabController] is not provided, then a [DefaultTabController] ancestor
/// must be provided instead. The tab controller's [TabController.length] must
/// equal the length of the [tabs] list and the length of the
/// [TabBarView.children] list.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// Uses values from [TabBarThemeData] if it is set in the current context.
///
/// {@tool dartpad}
/// This sample shows the implementation of [VerticalTabBar] and [TabBarView] using a [DefaultTabController].
/// Each [VerticalTab] corresponds to a child of the [TabBarView] in the order they are written.
///
/// ** See code in examples/api/lib/material/tabs/tab_bar.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// [VerticalTabBar] can also be implemented by using a [TabController] which provides more options
/// to control the behavior of the [VerticalTabBar] and [TabBarView]. This can be used instead of
/// a [DefaultTabController], demonstrated below.
///
/// ** See code in examples/api/lib/material/tabs/tab_bar.1.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample showcases nested Material 3 [VerticalTabBar]s. It consists of a primary
/// [VerticalTabBar] with nested a secondary [VerticalTabBar]. The primary [VerticalTabBar] uses a
/// [DefaultTabController] while the secondary [VerticalTabBar] uses a [TabController].
///
/// ** See code in examples/api/lib/material/tabs/tab_bar.2.dart **
/// {@end-tool}
///
/// See also:
///
///  * [TabBar.secondary], for a secondary tab bar.
///  * [TabBarView], which displays page views that correspond to each tab.
///  * [TabController], which coordinates tab selection between a [VerticalTabBar] and a [TabBarView].
///  * https://m3.material.io/components/tabs/overview, the Material 3
///     tab bar specification.
class VerticalTabBar extends StatefulWidget {
  /// Creates a Material Design primary tab bar.
  ///
  /// The length of the [tabs] argument must match the [controller]'s
  /// [TabController.length].
  ///
  /// If a [TabController] is not provided, then there must be a
  /// [DefaultTabController] ancestor.
  ///
  /// The [indicatorWeight] parameter defaults to 2.
  ///
  /// The [indicatorPadding] parameter defaults to [EdgeInsets.zero].
  ///
  /// If [indicator] is not null or provided from [TabBarTheme],
  /// then [indicatorWeight] and [indicatorColor] are ignored.
  const VerticalTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.dividerColor,
    this.dividerWidth,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.onHover,
    this.onFocusChange,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
    this.tabAlignment,
    this.textScaler,
    this.indicatorAnimation,
  }) : _isPrimary = true,
       assert(indicator != null || (indicatorWeight > 0.0));

  /// Creates a Material Design secondary tab bar.
  ///
  /// Secondary tabs are used within a content area to further separate related
  /// content and establish hierarchy.
  ///
  /// {@tool dartpad}
  /// This sample showcases nested Material 3 [VerticalTabBar]s. It consists of a primary
  /// [VerticalTabBar] with nested a secondary [VerticalTabBar]. The primary [VerticalTabBar] uses a
  /// [DefaultTabController] while the secondary [VerticalTabBar] uses a [TabController].
  ///
  /// ** See code in examples/api/lib/material/tabs/tab_bar.2.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [VerticalTabBar], for a primary tab bar.
  ///  * [TabBarView], which displays page views that correspond to each tab.
  ///  * [TabController], which coordinates tab selection between a [VerticalTabBar] and a [TabBarView].
  ///  * https://m3.material.io/components/tabs/overview, the Material 3
  ///     tab bar specification.
  const VerticalTabBar.secondary({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.dividerColor,
    this.dividerWidth,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.onHover,
    this.onFocusChange,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
    this.tabAlignment,
    this.textScaler,
    this.indicatorAnimation,
  }) : _isPrimary = false,
       assert(indicator != null || (indicatorWeight > 0.0));

  /// Typically a list of two or more [VerticalTab] widgets.
  ///
  /// The length of this list must match the [controller]'s [TabController.length]
  /// and the length of the [TabBarView.children] list.
  final List<Widget> tabs;

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of [DefaultTabController.of]
  /// will be used.
  final TabController? controller;

  /// Whether this tab bar can be scrolled horizontally.
  ///
  /// If [isScrollable] is true, then each tab is as wide as needed for its label
  /// and the entire [VerticalTabBar] is scrollable. Otherwise each tab gets an equal
  /// share of the available space.
  final bool isScrollable;

  /// The amount of space by which to inset the tab bar.
  ///
  /// When [isScrollable] is false, this will yield the same result as if [VerticalTabBar] was wrapped
  /// in a [Padding] widget. When [isScrollable] is true, the scrollable itself is inset,
  /// allowing the padding to scroll with the tab bar, rather than enclosing it.
  final EdgeInsetsGeometry? padding;

  /// The color of the line that appears below the selected tab.
  ///
  /// If this parameter is null, then the value of the Theme's indicatorColor
  /// property is used.
  ///
  /// If [indicator] is specified or provided from [TabBarThemeData],
  /// this property is ignored.
  final Color? indicatorColor;

  /// The thickness of the line that appears below the selected tab.
  ///
  /// The value of this parameter must be greater than zero.
  ///
  /// If [ThemeData.useMaterial3] is true and [VerticalTabBar] is used to create a
  /// primary tab bar, the default value is 3.0. If the provided value is less
  /// than 3.0, the default value is used.
  ///
  /// If [ThemeData.useMaterial3] is true and [TabBar.secondary] is used to
  /// create a secondary tab bar, the default value is 2.0.
  ///
  /// If [ThemeData.useMaterial3] is false, the default value is 2.0.
  ///
  /// If [indicator] is specified or provided from [TabBarThemeData],
  /// this property is ignored.
  final double indicatorWeight;

  /// The padding for the indicator.
  ///
  /// The default value of this property is [EdgeInsets.zero].
  ///
  /// For [isScrollable] tab bars, specifying [kTabLabelPadding] will align
  /// the indicator with the tab's text for [VerticalTab] widgets and all but the
  /// shortest [VerticalTab.text] values.
  final EdgeInsetsGeometry indicatorPadding;

  /// Defines the appearance of the selected tab indicator.
  ///
  /// If [indicator] is specified or provided from [TabBarThemeData],
  /// the [indicatorColor] and [indicatorWeight] properties are ignored.
  ///
  /// The default, underline-style, selected tab indicator can be defined with
  /// [UnderlineTabIndicator].
  ///
  /// The indicator's size is based on the tab's bounds. If [indicatorSize]
  /// is [TabBarIndicatorSize.tab] the tab's bounds are as wide as the space
  /// occupied by the tab in the tab bar. If [indicatorSize] is
  /// [TabBarIndicatorSize.label], then the tab's bounds are only as wide as
  /// the tab widget itself.
  ///
  /// See also:
  ///
  ///  * [splashBorderRadius], which defines the clipping radius of the splash
  ///    and is generally used with [BoxDecoration.borderRadius].
  final Decoration? indicator;

  /// Whether this tab bar should automatically adjust the [indicatorColor].
  ///
  /// The default value of this property is true.
  ///
  /// If [automaticIndicatorColorAdjustment] is true,
  /// then the [indicatorColor] will be automatically adjusted to [Colors.white]
  /// when the [indicatorColor] is same as [Material.color] of the [Material]
  /// parent widget.
  final bool automaticIndicatorColorAdjustment;

  /// Defines how the selected tab indicator's size is computed.
  ///
  /// The size of the selected tab indicator is defined relative to the
  /// tab's overall bounds if [indicatorSize] is [TabBarIndicatorSize.tab]
  /// (the default) or relative to the bounds of the tab's widget if
  /// [indicatorSize] is [TabBarIndicatorSize.label].
  ///
  /// The selected tab's location appearance can be refined further with
  /// the [indicatorColor], [indicatorWeight], [indicatorPadding], and
  /// [indicator] properties.
  final TabBarIndicatorSize? indicatorSize;

  /// The color of the divider.
  ///
  /// If the [dividerColor] is [Colors.transparent], then the divider will not be drawn.
  ///
  /// If null and [ThemeData.useMaterial3] is false, [TabBarThemeData.dividerColor]
  /// color is used. If that is null and [ThemeData.useMaterial3] is true,
  /// [ColorScheme.outlineVariant] will be used, otherwise divider will not be drawn.
  final Color? dividerColor;

  /// The height of the divider.
  ///
  /// If the [dividerWidth] is zero or negative, then the divider will not be drawn.
  ///
  /// If null and [ThemeData.useMaterial3] is true, [TabBarThemeData.dividerHeight] is used.
  /// If that is also null and [ThemeData.useMaterial3] is true, 1.0 will be used.
  /// Otherwise divider will not be drawn.
  final double? dividerWidth;

  /// The color of selected tab labels.
  ///
  /// If null, then [TabBarThemeData.labelColor] is used. If that is also null and
  /// [ThemeData.useMaterial3] is true, [ColorScheme.primary] will be used,
  /// otherwise the color of the [ThemeData.primaryTextTheme]'s
  /// [TextTheme.bodyLarge] text color is used.
  ///
  /// If [labelColor] (or, if null, [TabBarThemeData.labelColor]) is a
  /// [WidgetStateColor], then the effective tab color will depend on the
  /// [WidgetState.selected] state, i.e. if the [VerticalTab] is selected or not,
  /// ignoring [unselectedLabelColor] even if it's non-null.
  ///
  /// When this color or the [TabBarThemeData.labelColor] is specified, it overrides
  /// the [TextStyle.color] specified for the [labelStyle] or the
  /// [TabBarThemeData.labelStyle].
  ///
  /// See also:
  ///
  ///   * [unselectedLabelColor], for color of unselected tab labels.
  final Color? labelColor;

  /// The color of unselected tab labels.
  ///
  /// If [labelColor] (or, if null, [TabBarThemeData.labelColor]) is a
  /// [WidgetStateColor], then the unselected tabs are rendered with
  /// that [WidgetStateColor]'s resolved color for unselected state, even if
  /// [unselectedLabelColor] is non-null.
  ///
  /// If null, then [TabBarThemeData.unselectedLabelColor] is used. If that is also
  /// null and [ThemeData.useMaterial3] is true, [ColorScheme.onSurfaceVariant]
  /// will be used, otherwise unselected tab labels are rendered with
  /// [labelColor] at 70% opacity.
  ///
  /// When this color or the [TabBarThemeData.unselectedLabelColor] is specified, it
  /// overrides the [TextStyle.color] specified for the [unselectedLabelStyle]
  /// or the [TabBarThemeData.unselectedLabelStyle].
  ///
  /// See also:
  ///
  ///  * [labelColor], for color of selected tab labels.
  final Color? unselectedLabelColor;

  /// The text style of the selected tab labels.
  ///
  /// The color specified in [labelStyle] and [TabBarThemeData.labelStyle] is used
  /// to style the label when [labelColor] or [TabBarThemeData.labelColor] are not
  /// specified.
  ///
  /// If [unselectedLabelStyle] is null, then this text style will be used for
  /// both selected and unselected label styles.
  ///
  /// If this property is null, then [TabBarThemeData.labelStyle] will be used.
  ///
  /// If that is also null and [ThemeData.useMaterial3] is true, [TextTheme.titleSmall]
  /// will be used, otherwise the text style of the [ThemeData.primaryTextTheme]'s
  /// [TextTheme.bodyLarge] definition is used.
  final TextStyle? labelStyle;

  /// The text style of the unselected tab labels.
  ///
  /// The color specified in [unselectedLabelStyle] and [TabBarThemeData.unselectedLabelStyle]
  /// is used to style the label when [unselectedLabelColor] or [TabBarThemeData.unselectedLabelColor]
  /// are not specified.
  ///
  /// If this property is null, then [TabBarThemeData.unselectedLabelStyle] will be used.
  ///
  /// If that is also null and [ThemeData.useMaterial3] is true, [TextTheme.titleSmall]
  /// will be used, otherwise then the [labelStyle] value is used. If [labelStyle] is null,
  /// the text style of the [ThemeData.primaryTextTheme]'s [TextTheme.bodyLarge]
  /// definition is used.
  final TextStyle? unselectedLabelStyle;

  /// The padding added to each of the tab labels.
  ///
  /// If there are few tabs with both icon and text and few
  /// tabs with only icon or text, this padding is vertically
  /// adjusted to provide uniform padding to all tabs.
  ///
  /// If this property is null, then [kTabLabelPadding] is used.
  final EdgeInsetsGeometry? labelPadding;

  /// Defines the ink response focus, hover, and splash colors.
  ///
  /// If non-null, it is resolved against one of [WidgetState.focused],
  /// [WidgetState.hovered], and [WidgetState.pressed].
  ///
  /// [WidgetState.pressed] triggers a ripple (an ink splash), per
  /// the current Material Design spec.
  ///
  /// If the overlay color is null or resolves to null, then if [ThemeData.useMaterial3] is
  /// false, the default values for [InkResponse.focusColor], [InkResponse.hoverColor], [InkResponse.splashColor],
  /// and [InkResponse.highlightColor] will be used instead. If [ThemeData.useMaterial3]
  /// if true, the default values are:
  /// * selected:
  ///   * pressed - ThemeData.colorScheme.primary(0.1)
  ///   * hovered - ThemeData.colorScheme.primary(0.08)
  ///   * focused - ThemeData.colorScheme.primary(0.1)
  /// * pressed - ThemeData.colorScheme.primary(0.1)
  /// * hovered - ThemeData.colorScheme.onSurface(0.08)
  /// * focused - ThemeData.colorScheme.onSurface(0.1)
  final WidgetStateProperty<Color?>? overlayColor;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@template flutter.material.tabs.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// individual tab widgets.
  ///
  /// If [mouseCursor] is a [WidgetStateMouseCursor],
  /// [WidgetStateProperty.resolve] is used for the following [WidgetState]s:
  ///
  ///  * [WidgetState.selected].
  /// {@endtemplate}
  ///
  /// If null, then the value of [TabBarThemeData.mouseCursor] is used. If
  /// that is also null, then [WidgetStateMouseCursor.clickable] is used.
  final MouseCursor? mouseCursor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a long-press
  /// will produce a short vibration, when feedback is enabled.
  ///
  /// Defaults to true.
  final bool? enableFeedback;

  /// An optional callback that's called when the [VerticalTabBar] is tapped.
  ///
  /// The callback is applied to the index of the tab where the tap occurred.
  ///
  /// This callback has no effect on the default handling of taps. It's for
  /// applications that want to do a little extra work when a tab is tapped,
  /// even if the tap doesn't change the TabController's index. TabBar [onTap]
  /// callbacks should not make changes to the TabController since that would
  /// interfere with the default tap handler.
  final ValueChanged<int>? onTap;

  /// An optional callback that's called when a [VerticalTab]'s hover state in the
  /// [VerticalTabBar] changes.
  ///
  /// Called when a pointer enters or exits the ink response area of the [VerticalTab].
  ///
  /// The value passed to the callback is true if a pointer has entered the
  /// [VerticalTab] at `index` and false if a pointer has exited.
  ///
  /// When hover is moved from one tab directly to another, this will be called
  /// twice. First to represent hover exiting the initial tab, and then second
  /// for the pointer entering hover over the next tab.
  ///
  /// {@tool dartpad}
  /// This sample shows how to customize a [VerticalTab] in response to hovering over a
  /// [VerticalTabBar].
  ///
  /// ** See code in examples/api/lib/material/tabs/tab_bar.onHover.dart **
  /// {@end-tool}
  final TabValueChanged<bool>? onHover;

  /// An optional callback that's called when a [VerticalTab]'s focus state in the
  /// [VerticalTabBar] changes.
  ///
  /// Called when the node for the [VerticalTab] at `index` gains or loses focus.
  ///
  /// The value passed to the callback is true if the node has gained focus for
  /// the [VerticalTab] at `index` and false if focus has been lost.
  ///
  /// When focus is moved from one tab directly to another, this will be called
  /// twice. First to represent focus being lost by the initially focused tab,
  /// and then second for the next tab gaining focus.
  ///
  /// {@tool dartpad}
  /// This sample shows how to customize a [VerticalTab] based on focus traversal in
  /// enclosing [VerticalTabBar].
  ///
  /// ** See code in examples/api/lib/material/tabs/tab_bar.onFocusChange.dart **
  /// {@end-tool}
  final TabValueChanged<bool>? onFocusChange;

  /// How the [VerticalTabBar]'s scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

  /// Creates the tab bar's [InkWell] splash factory, which defines
  /// the appearance of "ink" splashes that occur in response to taps.
  ///
  /// Use [NoSplash.splashFactory] to defeat ink splash rendering. For example
  /// to defeat both the splash and the hover/pressed overlay, but not the
  /// keyboard focused overlay:
  ///
  /// ```dart
  /// TabBar(
  ///   splashFactory: NoSplash.splashFactory,
  ///   overlayColor: WidgetStateProperty.resolveWith<Color?>(
  ///     (Set<WidgetState> states) {
  ///       return states.contains(WidgetState.focused) ? null : Colors.transparent;
  ///     },
  ///   ),
  ///   tabs: const <Widget>[
  ///     // ...
  ///   ],
  /// )
  /// ```
  final InteractiveInkFeatureFactory? splashFactory;

  /// Defines the clipping radius of splashes that extend outside the bounds of the tab.
  ///
  /// This can be useful to match the [BoxDecoration.borderRadius] provided as [indicator].
  ///
  /// ```dart
  /// TabBar(
  ///   indicator: BoxDecoration(
  ///     borderRadius: BorderRadius.circular(40),
  ///   ),
  ///   splashBorderRadius: BorderRadius.circular(40),
  ///   tabs: const <Widget>[
  ///     // ...
  ///   ],
  /// )
  /// ```
  ///
  /// If this property is null, it is interpreted as [BorderRadius.zero].
  final BorderRadius? splashBorderRadius;

  /// Specifies the horizontal alignment of the tabs within a [VerticalTabBar].
  ///
  /// If [VerticalTabBar.isScrollable] is false, only [TabAlignment.fill] and
  /// [TabAlignment.center] are supported. Otherwise an exception is thrown.
  ///
  /// If [VerticalTabBar.isScrollable] is true, only [TabAlignment.start], [TabAlignment.startOffset],
  /// and [TabAlignment.center] are supported. Otherwise an exception is thrown.
  ///
  /// If this is null, then the value of [TabBarThemeData.tabAlignment] is used.
  ///
  /// If [TabBarThemeData.tabAlignment] is null and [ThemeData.useMaterial3] is true,
  /// then [TabAlignment.startOffset] is used if [isScrollable] is true,
  /// otherwise [TabAlignment.fill] is used.
  ///
  /// If [TabBarThemeData.tabAlignment] is null and [ThemeData.useMaterial3] is false,
  /// then [TabAlignment.center] is used if [isScrollable] is true,
  /// otherwise [TabAlignment.fill] is used.
  final TabAlignment? tabAlignment;

  /// Specifies the text scaling behavior for the [VerticalTab] label.
  ///
  /// If this is null, then the value of [TabBarThemeData.textScaler] is used. If that is
  /// also null, then the text scaling behavior is determined by the [MediaQueryData.textScaler]
  /// from the ambient [MediaQuery], or 1.0 if there is no [MediaQuery] in scope.
  ///
  /// See also:
  ///   * [TextScaler], which is used to scale text based on the device's text scale factor.
  final TextScaler? textScaler;

  /// Specifies the animation behavior of the tab indicator.
  ///
  /// If this is null, then the value of [TabBarThemeData.indicatorAnimation] is used.
  /// If that is also null, then the tab indicator will animate linearly if the
  /// [indicatorSize] is [TabBarIndicatorSize.tab], otherwise it will animate
  /// with an elastic effect if the [indicatorSize] is [TabBarIndicatorSize.label].
  ///
  /// {@tool dartpad}
  /// This sample shows how to customize the animation behavior of the tab indicator
  /// by using the [indicatorAnimation] property.
  ///
  /// ** See code in examples/api/lib/material/tabs/tab_bar.indicator_animation.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [TabIndicatorAnimation], which specifies the animation behavior of the tab indicator.
  final TabIndicatorAnimation? indicatorAnimation;

  /// Returns whether the [VerticalTabBar] contains a tab with both text and icon.
  ///
  /// [VerticalTabBar] uses this to give uniform padding to all tabs in cases where
  /// there are some tabs with both text and icon and some which contain only
  /// text or icon.
  bool get tabHasTextAndIcon {
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        if (item.preferredSize.height == _kTextAndIconTabWidth) {
          return true;
        }
      }
    }
    return false;
  }

  /// Whether this tab bar is a primary tab bar.
  ///
  /// Otherwise, it is a secondary tab bar.
  final bool _isPrimary;

  @override
  State<VerticalTabBar> createState() => _VerticalTabBarState();
}

class _VerticalTabBarState extends State<VerticalTabBar> {
  ScrollController? _scrollController;
  TabController? _controller;
  _IndicatorPainter? _indicatorPainter;
  int? _currentIndex;
  // late double _tabStripWidth;
  late List<GlobalKey> _tabKeys;
  EdgeInsetsGeometry _labelPadding = EdgeInsets.zero;
  bool _debugHasScheduledValidTabsCountCheck = false;

  @override
  void initState() {
    super.initState();
    // If indicatorSize is TabIndicatorSize.label, _tabKeys[i] is used to find
    // the width of tab widget i. See _IndicatorPainter.indicatorRect().
    _tabKeys = widget.tabs.map((Widget tab) => GlobalKey()).toList();
    // _labelPaddings = List<EdgeInsetsGeometry>.filled(
    //   widget.tabs.length,
    //   EdgeInsets.zero,
    //   growable: true,
    // );
  }

  TabBarThemeData get _defaults {
    if (Theme.of(context).useMaterial3) {
      return widget._isPrimary
          ? _TabsPrimaryDefaultsM3(context, widget.isScrollable)
          : _TabsSecondaryDefaultsM3(context, widget.isScrollable);
    } else {
      return _TabsDefaultsM2(context, widget.isScrollable);
    }
  }

  Decoration _getIndicator(TabBarIndicatorSize indicatorSize) {
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);

    if (widget.indicator != null) {
      return widget.indicator!;
    }
    if (tabBarTheme.indicator != null) {
      return tabBarTheme.indicator!;
    }

    Color color =
        widget.indicatorColor ??
        tabBarTheme.indicatorColor ??
        _defaults.indicatorColor!;
    // ThemeData tries to avoid this by having indicatorColor avoid being the
    // primaryColor. However, it's possible that the tab bar is on a
    // Material that isn't the primaryColor. In that case, if the indicator
    // color ends up matching the material's color, then this overrides it.
    // When that happens, automatic transitions of the theme will likely look
    // ugly as the indicator color suddenly snaps to white at one end, but it's
    // not clear how to avoid that any further.
    //
    // The material's color might be null (if it's a transparency). In that case
    // there's no good way for us to find out what the color is so we don't.
    //
    // TODO(xu-baolin): Remove automatic adjustment to white color indicator
    // with a better long-term solution.
    // https://github.com/flutter/flutter/pull/68171#pullrequestreview-517753917
    if (widget.automaticIndicatorColorAdjustment &&
        color.toARGB32() == Material.maybeOf(context)?.color?.toARGB32()) {
      color = Colors.white;
    }

    final double effectiveIndicatorWeight = theme.useMaterial3
        ? math.max(widget.indicatorWeight, switch (widget._isPrimary) {
            true => _TabsPrimaryDefaultsM3.indicatorWeight(indicatorSize),
            false => _TabsSecondaryDefaultsM3.indicatorWeight,
          })
        : widget.indicatorWeight;
    // Only Material 3 primary TabBar with label indicatorSize should be rounded.
    final bool primaryWithLabelIndicator = switch (indicatorSize) {
      TabBarIndicatorSize.label => widget._isPrimary,
      TabBarIndicatorSize.tab => false,
    };
    final BorderRadius? effectiveBorderRadius =
        theme.useMaterial3 && primaryWithLabelIndicator
        // dom
        ? BorderRadius.only(
            topRight: Radius.circular(effectiveIndicatorWeight),
            bottomRight: Radius.circular(effectiveIndicatorWeight),
          )
        : null;
    return VerticalUnderlineTabIndicator(
      borderRadius: effectiveBorderRadius,
      borderSide: BorderSide(
        // TODO(tahatesser): Make sure this value matches Material 3 Tabs spec
        // when `preferredSize`and `indicatorWeight` are updated to support Material 3
        // https://m3.material.io/components/tabs/specs#149a189f-9039-4195-99da-15c205d20e30,
        // https://github.com/flutter/flutter/issues/116136
        width: effectiveIndicatorWeight,
        color: color,
      ),
    );
  }

  // If the TabBar is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final TabController? newController =
        widget.controller ?? DefaultTabController.maybeOf(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No TabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an explicit '
          'TabController using the "controller" property, or you must ensure that there '
          'is a DefaultTabController above the ${widget.runtimeType}.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller!.animation!.addListener(_handleTabControllerAnimationTick);
      _controller!.addListener(_handleTabControllerTick);
      _currentIndex = _controller!.index;
    }
  }

  void _initIndicatorPainter() {
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final TabBarIndicatorSize indicatorSize =
        widget.indicatorSize ??
        tabBarTheme.indicatorSize ??
        _defaults.indicatorSize!;

    final _IndicatorPainter? oldPainter = _indicatorPainter;

    final TabIndicatorAnimation defaultTabIndicatorAnimation =
        switch (indicatorSize) {
          TabBarIndicatorSize.label => TabIndicatorAnimation.elastic,
          TabBarIndicatorSize.tab => TabIndicatorAnimation.linear,
        };

    _indicatorPainter = !_controllerIsValid
        ? null
        : _IndicatorPainter(
            controller: _controller!,
            indicator: _getIndicator(indicatorSize),
            indicatorSize: indicatorSize,
            indicatorPadding: widget.indicatorPadding,
            tabKeys: _tabKeys,
            // Passing old painter so that the constructor can copy some values from it.
            old: oldPainter,
            labelPadding: _labelPadding,
            dividerColor:
                widget.dividerColor ??
                tabBarTheme.dividerColor ??
                _defaults.dividerColor,
            dividerWidth:
                widget.dividerWidth ??
                tabBarTheme.dividerHeight ??
                _defaults.dividerHeight,
            showDivider: theme.useMaterial3 && !widget.isScrollable,
            devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
            indicatorAnimation:
                widget.indicatorAnimation ??
                tabBarTheme.indicatorAnimation ??
                defaultTabIndicatorAnimation,
            textDirection: .ltr,
          );

    oldPainter?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTabController();
    _initIndicatorPainter();
  }

  @override
  void didUpdateWidget(VerticalTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _initIndicatorPainter();
      // Adjust scroll position.
      if (_scrollController != null && _scrollController!.hasClients) {
        final ScrollPosition position = _scrollController!.position;
        if (position is _TabBarScrollPosition) {
          position.markNeedsPixelsCorrection();
        }
      }
    } else if (widget.indicatorColor != oldWidget.indicatorColor ||
        widget.indicatorWeight != oldWidget.indicatorWeight ||
        widget.indicatorSize != oldWidget.indicatorSize ||
        widget.indicatorPadding != oldWidget.indicatorPadding ||
        widget.indicator != oldWidget.indicator ||
        widget.dividerColor != oldWidget.dividerColor ||
        widget.dividerWidth != oldWidget.dividerWidth ||
        widget.indicatorAnimation != oldWidget.indicatorAnimation) {
      _initIndicatorPainter();
    }

    if (widget.tabs.length > _tabKeys.length) {
      final int delta = widget.tabs.length - _tabKeys.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (int n) => GlobalKey()));
      // _labelPaddings.addAll(
      //   List<EdgeInsetsGeometry>.filled(delta, EdgeInsets.zero),
      // );
    } else if (widget.tabs.length < _tabKeys.length) {
      _tabKeys.removeRange(widget.tabs.length, _tabKeys.length);
      // _labelPaddings.removeRange(widget.tabs.length, _tabKeys.length);
    }
  }

  @override
  void dispose() {
    _indicatorPainter!.dispose();
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = null;
    _scrollController?.dispose();
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  int get maxTabIndex => _indicatorPainter!.maxTabIndex;

  double _tabScrollOffset(
    int index,
    double viewportWidth,
    double minExtent,
    double maxExtent,
  ) {
    if (!widget.isScrollable) {
      return 0.0;
    }
    double tabCenter = _indicatorPainter!.centerOf(index);
    // double paddingStart;
    // switch (Directionality.of(context)) {
    //   case TextDirection.rtl:
    //     paddingStart = widget.padding?.resolve(TextDirection.rtl).right ?? 0;
    //     tabCenter = _tabStripWidth - tabCenter;
    //   case TextDirection.ltr:
    //     paddingStart = widget.padding?.resolve(TextDirection.ltr).left ?? 0;
    // }
    // dom
    final double paddingTop =
        widget.padding?.resolve(TextDirection.ltr).top ?? 0;
    return clampDouble(
      tabCenter + paddingTop - viewportWidth / 2.0,
      minExtent,
      maxExtent,
    );
  }

  double _tabCenteredScrollOffset(int index) {
    final ScrollPosition position = _scrollController!.position;
    return _tabScrollOffset(
      index,
      position.viewportDimension,
      position.minScrollExtent,
      position.maxScrollExtent,
    );
  }

  double _initialScrollOffset(
    double viewportWidth,
    double minExtent,
    double maxExtent,
  ) {
    return _tabScrollOffset(
      _currentIndex!,
      viewportWidth,
      minExtent,
      maxExtent,
    );
  }

  void _scrollToCurrentIndex() {
    final double offset = _tabCenteredScrollOffset(_currentIndex!);
    _scrollController!.animateTo(
      offset,
      duration: kTabScrollDuration,
      curve: Curves.ease,
    );
  }

  void _scrollToControllerValue() {
    final double? leadingPosition = _currentIndex! > 0
        ? _tabCenteredScrollOffset(_currentIndex! - 1)
        : null;
    final double middlePosition = _tabCenteredScrollOffset(_currentIndex!);
    final double? trailingPosition = _currentIndex! < maxTabIndex
        ? _tabCenteredScrollOffset(_currentIndex! + 1)
        : null;

    final double index = _controller!.index.toDouble();
    final double value = _controller!.animation!.value;
    final double offset = switch (value - index) {
      -1.0 => leadingPosition ?? middlePosition,
      1.0 => trailingPosition ?? middlePosition,
      0 => middlePosition,
      < 0 =>
        leadingPosition == null
            ? middlePosition
            : lerpDouble(middlePosition, leadingPosition, index - value)!,
      _ =>
        trailingPosition == null
            ? middlePosition
            : lerpDouble(middlePosition, trailingPosition, value - index)!,
    };

    _scrollController!.jumpTo(offset);
  }

  void _handleTabControllerAnimationTick() {
    assert(mounted);
    if (!_controller!.indexIsChanging && widget.isScrollable) {
      // Sync the TabBar's scroll position with the TabBarView's PageView.
      _currentIndex = _controller!.index;
      _scrollToControllerValue();
    }
  }

  void _handleTabControllerTick() {
    if (_controller!.index != _currentIndex) {
      _currentIndex = _controller!.index;
      if (widget.isScrollable) {
        _scrollToCurrentIndex();
      }
    }
    setState(() {
      // Rebuild the tabs after a (potentially animated) index change
      // has completed.
    });
  }

  // Called each time layout completes.
  void _saveTabOffsets(
    List<double> tabOffsets,
    TextDirection textDirection,
    double width,
  ) {
    // _tabStripWidth = width;
    _indicatorPainter?.saveTabOffsets(tabOffsets, textDirection);
  }

  void _handleTap(int index) {
    assert(index >= 0 && index < widget.tabs.length);
    _controller!.animateTo(index);
    widget.onTap?.call(index);
  }

  Widget _buildStyledTab(
    Widget child,
    bool isSelected,
    Animation<double> animation,
    TabBarThemeData defaults,
  ) {
    return _TabStyle(
      animation: animation,
      isSelected: isSelected,
      isPrimary: widget._isPrimary,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: widget.labelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      defaults: defaults,
      child: child,
    );
  }

  bool _debugScheduleCheckHasValidTabsCount() {
    if (_debugHasScheduledValidTabsCountCheck) {
      return true;
    }
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      _debugHasScheduledValidTabsCountCheck = false;
      if (!mounted) {
        return;
      }
      assert(() {
        if (_controller!.length != widget.tabs.length) {
          throw FlutterError(
            "Controller's length property (${_controller!.length}) does not match the "
            "number of tabs (${widget.tabs.length}) present in TabBar's tabs property.",
          );
        }
        return true;
      }());
    }, debugLabel: 'TabBar.tabsCountCheck');
    _debugHasScheduledValidTabsCountCheck = true;
    return true;
  }

  bool _debugTabAlignmentIsValid(TabAlignment tabAlignment) {
    assert(() {
      if (widget.isScrollable && tabAlignment == TabAlignment.fill) {
        throw FlutterError(
          '$tabAlignment is only valid for non-scrollable tab bars.',
        );
      }
      if (!widget.isScrollable &&
          (tabAlignment == TabAlignment.start ||
              tabAlignment == TabAlignment.startOffset)) {
        throw FlutterError(
          '$tabAlignment is only valid for scrollable tab bars.',
        );
      }
      return true;
    }());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    assert(_debugScheduleCheckHasValidTabsCount());
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final TabAlignment effectiveTabAlignment =
        widget.tabAlignment ??
        tabBarTheme.tabAlignment ??
        _defaults.tabAlignment!;
    assert(_debugTabAlignmentIsValid(effectiveTabAlignment));

    // final MaterialLocalizations localizations = MaterialLocalizations.of(
    //   context,
    // );
    if (_controller!.length == 0) {
      return LimitedBox(
        maxWidth: 0.0,
        child: SizedBox(
          width: double.infinity,
          height: _kTabWidth + widget.indicatorWeight,
        ),
      );
    }

    final List<Widget> wrappedTabs = List<Widget>.generate(widget.tabs.length, (
      int index,
    ) {
      EdgeInsetsGeometry padding =
          widget.labelPadding ?? tabBarTheme.labelPadding ?? _kTabLabelPadding;
      // const double verticalAdjustment =
      //     (_kTextAndIconTabWidth - _kTabWidth) / 2.0;
      //
      // final Widget tab = widget.tabs[index];
      // if (tab is PreferredSizeWidget &&
      //     tab.preferredSize.height == _kTabWidth &&
      //     widget.tabHasTextAndIcon) {
      //   padding = padding.add(
      //     const EdgeInsets.symmetric(vertical: verticalAdjustment),
      //   );
      // }
      _labelPadding = padding;

      return Center(
        widthFactor: 1.0,
        child: Padding(
          padding: _labelPadding,
          child: KeyedSubtree(key: _tabKeys[index], child: widget.tabs[index]),
        ),
      );
    });

    // If the controller was provided by DefaultTabController and we're part
    // of a Hero (typically the AppBar), then we will not be able to find the
    // controller during a Hero transition. See https://github.com/flutter/flutter/issues/213.
    if (_controller != null) {
      final int previousIndex = _controller!.previousIndex;

      if (_controller!.indexIsChanging) {
        // The user tapped on a tab, the tab controller's animation is running.
        assert(_currentIndex != previousIndex);
        final Animation<double> animation = _ChangeAnimation(_controller!);
        wrappedTabs[_currentIndex!] = _buildStyledTab(
          wrappedTabs[_currentIndex!],
          true,
          animation,
          _defaults,
        );
        wrappedTabs[previousIndex] = _buildStyledTab(
          wrappedTabs[previousIndex],
          false,
          animation,
          _defaults,
        );
      } else {
        // The user is dragging the TabBarView's PageView left or right.
        final int tabIndex = _currentIndex!;
        final Animation<double> centerAnimation = _DragAnimation(
          _controller!,
          tabIndex,
        );
        wrappedTabs[tabIndex] = _buildStyledTab(
          wrappedTabs[tabIndex],
          true,
          centerAnimation,
          _defaults,
        );
        if (_currentIndex! > 0) {
          final int tabIndex = _currentIndex! - 1;
          final Animation<double> previousAnimation = ReverseAnimation(
            _DragAnimation(_controller!, tabIndex),
          );
          wrappedTabs[tabIndex] = _buildStyledTab(
            wrappedTabs[tabIndex],
            false,
            previousAnimation,
            _defaults,
          );
        }
        if (_currentIndex! < widget.tabs.length - 1) {
          final int tabIndex = _currentIndex! + 1;
          final Animation<double> nextAnimation = ReverseAnimation(
            _DragAnimation(_controller!, tabIndex),
          );
          wrappedTabs[tabIndex] = _buildStyledTab(
            wrappedTabs[tabIndex],
            false,
            nextAnimation,
            _defaults,
          );
        }
      }
    }

    // Add the tap handler to each tab. If the tab bar is not scrollable,
    // then give all of the tabs equal flexibility so that they each occupy
    // the same share of the tab bar's overall width.
    final int tabCount = widget.tabs.length;
    for (int index = 0; index < tabCount; index += 1) {
      final Set<WidgetState> selectedState = <WidgetState>{
        if (index == _currentIndex) WidgetState.selected,
      };

      final MouseCursor effectiveMouseCursor =
          WidgetStateProperty.resolveAs<MouseCursor?>(
            widget.mouseCursor,
            selectedState,
          ) ??
          tabBarTheme.mouseCursor?.resolve(selectedState) ??
          WidgetStateMouseCursor.clickable.resolve(selectedState);

      final WidgetStateProperty<Color?> defaultOverlay =
          WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            final Set<WidgetState> effectiveStates = selectedState.toSet()
              ..addAll(states);
            return _defaults.overlayColor?.resolve(effectiveStates);
          });
      wrappedTabs[index] = InkWell(
        mouseCursor: effectiveMouseCursor,
        onTap: () {
          _handleTap(index);
        },
        onHover: (bool value) {
          widget.onHover?.call(value, index);
        },
        onFocusChange: (bool value) {
          widget.onFocusChange?.call(value, index);
        },
        enableFeedback: widget.enableFeedback ?? true,
        overlayColor:
            widget.overlayColor ?? tabBarTheme.overlayColor ?? defaultOverlay,
        splashFactory:
            widget.splashFactory ??
            tabBarTheme.splashFactory ??
            _defaults.splashFactory,
        borderRadius:
            widget.splashBorderRadius ??
            tabBarTheme.splashBorderRadius ??
            _defaults.splashBorderRadius,
        child: Padding(
          padding: EdgeInsets.only(left: widget.indicatorWeight),
          child: wrappedTabs[index],
        ),
      );
      wrappedTabs[index] = MergeSemantics(child: wrappedTabs[index]);
      if (!widget.isScrollable && effectiveTabAlignment == TabAlignment.fill) {
        wrappedTabs[index] = Expanded(child: wrappedTabs[index]);
      }
    }

    Widget tabBar = Semantics(
      role: SemanticsRole.tabBar,
      container: true,
      explicitChildNodes: true,
      child: CustomPaint(
        painter: _indicatorPainter,
        child: _TabStyle(
          animation: kAlwaysDismissedAnimation,
          isSelected: false,
          isPrimary: widget._isPrimary,
          labelColor: widget.labelColor,
          unselectedLabelColor: widget.unselectedLabelColor,
          labelStyle: widget.labelStyle,
          unselectedLabelStyle: widget.unselectedLabelStyle,
          defaults: _defaults,
          child: _TabLabelBar(
            onPerformLayout: _saveTabOffsets,
            mainAxisSize: effectiveTabAlignment == TabAlignment.fill
                ? MainAxisSize.max
                : MainAxisSize.min,
            children: wrappedTabs,
          ),
        ),
      ),
    );

    if (widget.isScrollable) {
      _scrollController ??= _TabBarScrollController(this);
      tabBar = ScrollConfiguration(
        // The scrolling tabs should not show an overscroll indicator.
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          dragStartBehavior: widget.dragStartBehavior,
          scrollDirection: Axis.vertical, // dom
          controller: _scrollController,
          padding: widget.padding,
          physics: widget.physics,
          child: tabBar,
        ),
      );
      if (theme.useMaterial3) {
        final AlignmentGeometry effectiveAlignment =
            switch (effectiveTabAlignment) {
              TabAlignment.center => Alignment.center,
              TabAlignment.start ||
              TabAlignment.startOffset ||
              TabAlignment.fill => AlignmentDirectional.topCenter, // dom
            };

        final Color dividerColor =
            widget.dividerColor ??
            tabBarTheme.dividerColor ??
            _defaults.dividerColor!;
        final double dividerWidth =
            widget.dividerWidth ??
            tabBarTheme.dividerHeight ??
            _defaults.dividerHeight!;

        tabBar = Align(
          widthFactor: 1.0,
          heightFactor: null, // dom
          // heightFactor: dividerWidth > 0 ? null : 1.0,
          alignment: effectiveAlignment,
          child: tabBar,
        );

        if (dividerColor != Colors.transparent && dividerWidth > 0) {
          tabBar = CustomPaint(
            painter: _DividerPainter(
              dividerColor: dividerColor,
              dividerWidth: dividerWidth,
            ),
            child: tabBar,
          );
        }
      }
    } else if (widget.padding != null) {
      tabBar = Padding(padding: widget.padding!, child: tabBar);
    }

    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: widget.textScaler ?? tabBarTheme.textScaler),
      child: tabBar,
    );
  }
}

// Hand coded defaults based on Material Design 2.
class _TabsDefaultsM2 extends TabBarThemeData {
  _TabsDefaultsM2(this.context, this.isScrollable)
    : super(indicatorSize: TabBarIndicatorSize.tab);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final bool isDark = Theme.brightnessOf(context) == Brightness.dark;
  late final Color primaryColor = isDark ? Colors.grey[900]! : Colors.blue;
  final bool isScrollable;

  @override
  Color? get indicatorColor =>
      _colors.secondary == primaryColor ? Colors.white : _colors.secondary;

  @override
  Color? get labelColor => Theme.of(context).primaryTextTheme.bodyLarge!.color!;

  @override
  TextStyle? get labelStyle => Theme.of(context).primaryTextTheme.bodyLarge;

  @override
  TextStyle? get unselectedLabelStyle =>
      Theme.of(context).primaryTextTheme.bodyLarge;

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment =>
      isScrollable ? TabAlignment.start : TabAlignment.fill;

  static const EdgeInsetsGeometry iconMargin = EdgeInsets.only(bottom: 10);
}

// BEGIN GENERATED TOKEN PROPERTIES - Tabs

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _TabsPrimaryDefaultsM3 extends TabBarThemeData {
  _TabsPrimaryDefaultsM3(this.context, this.isScrollable)
      : super(indicatorSize: TabBarIndicatorSize.label);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;
  final bool isScrollable;

  // This value comes from Divider widget defaults. Token db deprecated 'primary-navigation-tab.divider.color' token.
  @override
  Color? get dividerColor => _colors.outlineVariant;

  // This value comes from Divider widget defaults. Token db deprecated 'primary-navigation-tab.divider.height' token.
  @override
  double? get dividerHeight => 1.0;

  @override
  Color? get indicatorColor => _colors.primary;

  @override
  Color? get labelColor => _colors.primary;

  @override
  TextStyle? get labelStyle => _textTheme.titleSmall;

  @override
  Color? get unselectedLabelColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get unselectedLabelStyle => _textTheme.titleSmall;

  @override
  WidgetStateProperty<Color?> get overlayColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.primary.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.primary.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primary.withValues(alpha:0.1);
        }
        return null;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.primary.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurface.withValues(alpha:0.1);
      }
      return null;
    });
  }

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment => isScrollable ? TabAlignment.startOffset : TabAlignment.fill;

  static double indicatorWeight(TabBarIndicatorSize indicatorSize) {
    return switch (indicatorSize) {
      TabBarIndicatorSize.label => 3.0,
      TabBarIndicatorSize.tab   => 2.0,
    };
  }

  // TODO(davidmartos96): This value doesn't currently exist in
  // https://m3.material.io/components/tabs/specs
  // Update this when the token is available.
  static const EdgeInsetsGeometry iconMargin = EdgeInsets.only(bottom: 2);
}

class _TabsSecondaryDefaultsM3 extends TabBarThemeData {
  _TabsSecondaryDefaultsM3(this.context, this.isScrollable)
      : super(indicatorSize: TabBarIndicatorSize.tab);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;
  final bool isScrollable;

  // This value comes from Divider widget defaults. Token db deprecated 'secondary-navigation-tab.divider.color' token.
  @override
  Color? get dividerColor => _colors.outlineVariant;

  // This value comes from Divider widget defaults. Token db deprecated 'secondary-navigation-tab.divider.height' token.
  @override
  double? get dividerHeight => 1.0;

  @override
  Color? get indicatorColor => _colors.primary;

  @override
  Color? get labelColor => _colors.onSurface;

  @override
  TextStyle? get labelStyle => _textTheme.titleSmall;

  @override
  Color? get unselectedLabelColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get unselectedLabelStyle => _textTheme.titleSmall;

  @override
  WidgetStateProperty<Color?> get overlayColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurface.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSurface.withValues(alpha:  0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onSurface.withValues(alpha:0.1);
        }
        return null;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurface.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurface.withValues(alpha:0.1);
      }
      return null;
    });
  }

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment => isScrollable ? TabAlignment.startOffset : TabAlignment.fill;

  static double indicatorWeight = 2.0;
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Tabs

/// Used with [TabBar.indicator] to draw a horizontal line below the
/// selected tab.
///
/// The selected tab underline is inset from the tab's boundary by [insets].
/// The [borderSide] defines the line's color and weight.
///
/// The [TabBar.indicatorSize] property can be used to define the indicator's
/// bounds in terms of its (centered) widget with [TabBarIndicatorSize.label],
/// or the entire tab with [TabBarIndicatorSize.tab].
class VerticalUnderlineTabIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  const VerticalUnderlineTabIndicator({
    this.borderRadius,
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  });

  /// The radius of the indicator's corners.
  ///
  /// If this value is non-null, rounded rectangular tab indicator is
  /// drawn, otherwise rectangular tab indicator is drawn.
  final BorderRadius? borderRadius;

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the tab
  /// indicator's bounds in terms of its (centered) tab widget with
  /// [TabBarIndicatorSize.label], or the entire tab with
  /// [TabBarIndicatorSize.tab].
  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is VerticalUnderlineTabIndicator) {
      return VerticalUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is VerticalUnderlineTabIndicator) {
      return VerticalUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _VerticalUnderlinePainter(this, borderRadius, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    // dom
    return Rect.fromLTWH(
      indicator.left,
      indicator.top,
      borderSide.width,
      indicator.height,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    if (borderRadius != null) {
      return Path()..addRRect(
        borderRadius!.toRRect(_indicatorRectFor(rect, textDirection)),
      );
    }
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _VerticalUnderlinePainter extends BoxPainter {
  _VerticalUnderlinePainter(
    this.decoration,
    this.borderRadius,
    super.onChanged,
  );

  final VerticalUnderlineTabIndicator decoration;
  final BorderRadius? borderRadius;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Paint paint;
    if (borderRadius != null) {
      paint = Paint()..color = decoration.borderSide.color;
      final Rect indicator = decoration._indicatorRectFor(rect, textDirection);
      final RRect rrect = RRect.fromRectAndCorners(
        indicator,
        topLeft: borderRadius!.topLeft,
        topRight: borderRadius!.topRight,
        bottomRight: borderRadius!.bottomRight,
        bottomLeft: borderRadius!.bottomLeft,
      );
      canvas.drawRRect(rrect, paint);
    } else {
      paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.square;
      final Rect indicator = decoration
          ._indicatorRectFor(rect, textDirection)
          .deflate(decoration.borderSide.width / 2.0);
      // dom
      canvas.drawLine(indicator.topLeft, indicator.bottomLeft, paint);
    }
  }
}
