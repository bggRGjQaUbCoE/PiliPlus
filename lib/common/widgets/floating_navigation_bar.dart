// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:flutter/material.dart';

const double _kMaxLabelTextScaleFactor = 1.3;

const _kNavigationHeight = 64.0;
const _kIndicatorHeight = _kNavigationHeight - 2 * _kIndicatorPaddingInt;
const _kIndicatorWidth = 86.0;
const _kIndicatorPaddingInt = 4.0;
const _kIndicatorPadding = EdgeInsets.all(_kIndicatorPaddingInt);
const _kBorderRadius = BorderRadius.all(.circular(_kNavigationHeight / 2));
const _kNavigationShape = RoundedSuperellipseBorder(
  borderRadius: _kBorderRadius,
);

/// ref [NavigationBar]
class FloatingNavigationBar extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  FloatingNavigationBar({
    super.key,
    this.animationDuration = const Duration(milliseconds: 500),
    this.selectedIndex = 0,
    required this.destinations,
    this.onDestinationSelected,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.indicatorColor,
    this.indicatorShape,
    this.labelBehavior,
    this.overlayColor,
    this.labelTextStyle,
    this.labelPadding,
    this.bottomPadding = 8.0,
  }) : assert(destinations.length >= 2),
       assert(0 <= selectedIndex && selectedIndex < destinations.length);

  final Duration animationDuration;
  final int selectedIndex;
  final List<Widget> destinations;
  final ValueChanged<int>? onDestinationSelected;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;
  final NavigationDestinationLabelBehavior? labelBehavior;
  final WidgetStateProperty<Color?>? overlayColor;
  final WidgetStateProperty<TextStyle?>? labelTextStyle;
  final EdgeInsetsGeometry? labelPadding;
  final double bottomPadding;

  VoidCallback _handleTap(int index) {
    return onDestinationSelected != null
        ? () => onDestinationSelected!(index)
        : () {};
  }

  @override
  Widget build(BuildContext context) {
    final defaults = _NavigationBarDefaultsM3(context);

    final navigationBarTheme = NavigationBarTheme.of(context);
    final effectiveLabelBehavior =
        labelBehavior ??
        navigationBarTheme.labelBehavior ??
        defaults.labelBehavior!;

    final padding = MediaQuery.viewPaddingOf(context);

    return UnconstrainedBox(
      child: Padding(
        padding: .fromLTRB(
          padding.left,
          0,
          padding.right,
          bottomPadding + padding.bottom,
        ),
        child: SizedBox(
          height: _kNavigationHeight,
          width: destinations.length * _kIndicatorWidth,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: ElevationOverlay.applySurfaceTint(
                backgroundColor ??
                    navigationBarTheme.backgroundColor ??
                    defaults.backgroundColor!,
                surfaceTintColor ??
                    navigationBarTheme.surfaceTintColor ??
                    defaults.surfaceTintColor,
                elevation ??
                    navigationBarTheme.elevation ??
                    defaults.elevation!,
              ),
              shape: RoundedSuperellipseBorder(
                side: defaults.borderSide,
                borderRadius: _kBorderRadius,
              ),
            ),
            child: Padding(
              padding: _kIndicatorPadding,
              child: Row(
                crossAxisAlignment: .stretch,
                children: <Widget>[
                  for (int i = 0; i < destinations.length; i++)
                    Expanded(
                      child: _SelectableAnimatedBuilder(
                        duration: animationDuration,
                        isSelected: i == selectedIndex,
                        builder: (context, animation) {
                          return _NavigationDestinationInfo(
                            index: i,
                            selectedIndex: selectedIndex,
                            totalNumberOfDestinations: destinations.length,
                            selectedAnimation: animation,
                            labelBehavior: effectiveLabelBehavior,
                            indicatorColor: indicatorColor,
                            indicatorShape: indicatorShape,
                            overlayColor: overlayColor,
                            onTap: _handleTap(i),
                            labelTextStyle: labelTextStyle,
                            labelPadding: labelPadding,
                            child: destinations[i],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingNavigationDestination extends StatelessWidget {
  const FloatingNavigationDestination({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.tooltip,
    this.enabled = true,
  });

  final Widget icon;

  final Widget? selectedIcon;

  final String label;

  final String? tooltip;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final info = _NavigationDestinationInfo.of(context);
    const selectedState = <WidgetState>{WidgetState.selected};
    const unselectedState = <WidgetState>{};
    const disabledState = <WidgetState>{WidgetState.disabled};

    final navigationBarTheme = NavigationBarTheme.of(context);
    final defaults = _NavigationBarDefaultsM3(context);
    final animation = info.selectedAnimation;

    return Stack(
      alignment: .center,
      clipBehavior: .none,
      children: [
        NavigationIndicator(
          animation: animation,
          color:
              info.indicatorColor ??
              navigationBarTheme.indicatorColor ??
              defaults.indicatorColor!,
        ),
        _NavigationDestinationBuilder(
          label: label,
          tooltip: tooltip,
          enabled: enabled,
          buildIcon: (context) {
            final IconThemeData selectedIconTheme =
                navigationBarTheme.iconTheme?.resolve(selectedState) ??
                defaults.iconTheme!.resolve(selectedState)!;
            final IconThemeData unselectedIconTheme =
                navigationBarTheme.iconTheme?.resolve(unselectedState) ??
                defaults.iconTheme!.resolve(unselectedState)!;
            final IconThemeData disabledIconTheme =
                navigationBarTheme.iconTheme?.resolve(disabledState) ??
                defaults.iconTheme!.resolve(disabledState)!;

            final Widget selectedIconWidget = IconTheme.merge(
              data: enabled ? selectedIconTheme : disabledIconTheme,
              child: selectedIcon ?? icon,
            );
            final Widget unselectedIconWidget = IconTheme.merge(
              data: enabled ? unselectedIconTheme : disabledIconTheme,
              child: icon,
            );
            return _StatusTransitionWidgetBuilder(
              animation: animation,
              builder: (context, child) {
                return animation.isForwardOrCompleted
                    ? selectedIconWidget
                    : unselectedIconWidget;
              },
            );
          },
          buildLabel: (context) {
            final TextStyle? effectiveSelectedLabelTextStyle =
                info.labelTextStyle?.resolve(selectedState) ??
                navigationBarTheme.labelTextStyle?.resolve(selectedState) ??
                defaults.labelTextStyle!.resolve(selectedState);
            final TextStyle? effectiveUnselectedLabelTextStyle =
                info.labelTextStyle?.resolve(unselectedState) ??
                navigationBarTheme.labelTextStyle?.resolve(unselectedState) ??
                defaults.labelTextStyle!.resolve(unselectedState);
            final TextStyle? effectiveDisabledLabelTextStyle =
                info.labelTextStyle?.resolve(disabledState) ??
                navigationBarTheme.labelTextStyle?.resolve(disabledState) ??
                defaults.labelTextStyle!.resolve(disabledState);
            final EdgeInsetsGeometry labelPadding =
                info.labelPadding ??
                navigationBarTheme.labelPadding ??
                defaults.labelPadding!;

            final textStyle = enabled
                ? animation.isForwardOrCompleted
                      ? effectiveSelectedLabelTextStyle
                      : effectiveUnselectedLabelTextStyle
                : effectiveDisabledLabelTextStyle;

            return Padding(
              padding: labelPadding,
              child: MediaQuery.withClampedTextScaling(
                maxScaleFactor: _kMaxLabelTextScaleFactor,
                child: Text(label, style: textStyle),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _NavigationDestinationBuilder extends StatefulWidget {
  const _NavigationDestinationBuilder({
    required this.buildIcon,
    required this.buildLabel,
    required this.label,
    this.tooltip,
    this.enabled = true,
  });

  final WidgetBuilder buildIcon;

  final WidgetBuilder buildLabel;

  final String label;

  final String? tooltip;

  final bool enabled;

  @override
  State<_NavigationDestinationBuilder> createState() =>
      _NavigationDestinationBuilderState();
}

class _NavigationDestinationBuilderState
    extends State<_NavigationDestinationBuilder> {
  final GlobalKey iconKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final info = _NavigationDestinationInfo.of(context);

    final child = GestureDetector(
      behavior: .opaque,
      onTap: widget.enabled ? info.onTap : null,
      child: _NavigationBarDestinationLayout(
        icon: widget.buildIcon(context),
        iconKey: iconKey,
        label: widget.buildLabel(context),
      ),
    );
    if (info.labelBehavior == .alwaysShow) {
      return child;
    }
    return _NavigationBarDestinationTooltip(
      message: widget.tooltip ?? widget.label,
      child: child,
    );
  }
}

class _NavigationDestinationInfo extends InheritedWidget {
  const _NavigationDestinationInfo({
    required this.index,
    required this.selectedIndex,
    required this.totalNumberOfDestinations,
    required this.selectedAnimation,
    required this.labelBehavior,
    required this.indicatorColor,
    required this.indicatorShape,
    required this.overlayColor,
    required this.onTap,
    this.labelTextStyle,
    this.labelPadding,
    required super.child,
  });

  final int index;

  final int selectedIndex;

  final int totalNumberOfDestinations;

  final Animation<double> selectedAnimation;

  final NavigationDestinationLabelBehavior labelBehavior;

  final Color? indicatorColor;

  final ShapeBorder? indicatorShape;

  final WidgetStateProperty<Color?>? overlayColor;

  final VoidCallback onTap;

  final WidgetStateProperty<TextStyle?>? labelTextStyle;

  final EdgeInsetsGeometry? labelPadding;

  static _NavigationDestinationInfo of(BuildContext context) {
    final _NavigationDestinationInfo? result = context
        .dependOnInheritedWidgetOfExactType<_NavigationDestinationInfo>();
    assert(
      result != null,
      'Navigation destinations need a _NavigationDestinationInfo parent, '
      'which is usually provided by NavigationBar.',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(_NavigationDestinationInfo oldWidget) {
    return index != oldWidget.index ||
        totalNumberOfDestinations != oldWidget.totalNumberOfDestinations ||
        selectedAnimation != oldWidget.selectedAnimation ||
        labelBehavior != oldWidget.labelBehavior ||
        onTap != oldWidget.onTap;
  }
}

class NavigationIndicator extends StatelessWidget {
  const NavigationIndicator({
    super.key,
    required this.animation,
    this.color,
    this.width = _kIndicatorWidth,
    this.height = _kIndicatorHeight,
  });

  final Animation<double> animation;

  final Color? color;

  final double width;

  final double height;

  static final _anim = Tween<double>(
    begin: .5,
    end: 1.0,
  ).chain(CurveTween(curve: Curves.easeInOutCubicEmphasized));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final double scale = animation.isDismissed
            ? 0.0
            : _anim.evaluate(animation);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(scale, 1.0, 1.0),
          child: child,
        );
      },

      child: _StatusTransitionWidgetBuilder(
        animation: animation,
        builder: (context, child) {
          return _SelectableAnimatedBuilder(
            isSelected: animation.isForwardOrCompleted,
            duration: const Duration(milliseconds: 100),
            alwaysDoFullAnimation: true,
            builder: (context, fadeAnimation) {
              return FadeTransition(
                opacity: fadeAnimation,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: _kNavigationShape,
                    color: color ?? Theme.of(context).colorScheme.secondary,
                  ),
                  child: const SizedBox(
                    width: _kIndicatorWidth,
                    height: _kIndicatorHeight,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NavigationBarDestinationLayout extends StatelessWidget {
  const _NavigationBarDestinationLayout({
    required this.icon,
    required this.iconKey,
    required this.label,
  });

  final Widget icon;

  final GlobalKey iconKey;

  final Widget label;

  @override
  Widget build(BuildContext context) {
    return _DestinationLayoutAnimationBuilder(
      builder: (context, animation) {
        return CustomMultiChildLayout(
          delegate: _NavigationDestinationLayoutDelegate(animation: animation),
          children: <Widget>[
            LayoutId(
              id: _NavigationDestinationLayoutDelegate.iconId,
              child: KeyedSubtree(key: iconKey, child: icon),
            ),
            LayoutId(
              id: _NavigationDestinationLayoutDelegate.labelId,
              child: FadeTransition(
                alwaysIncludeSemantics: true,
                opacity: animation,
                child: label,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DestinationLayoutAnimationBuilder extends StatelessWidget {
  const _DestinationLayoutAnimationBuilder({required this.builder});

  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  Widget build(BuildContext context) {
    final info = _NavigationDestinationInfo.of(context);
    switch (info.labelBehavior) {
      case NavigationDestinationLabelBehavior.alwaysShow:
        return builder(context, kAlwaysCompleteAnimation);
      case NavigationDestinationLabelBehavior.alwaysHide:
        return builder(context, kAlwaysDismissedAnimation);
      case NavigationDestinationLabelBehavior.onlyShowSelected:
        return _CurvedAnimationBuilder(
          animation: info.selectedAnimation,
          curve: Curves.easeInOutCubicEmphasized,
          reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
          builder: builder,
        );
    }
  }
}

class _NavigationBarDestinationTooltip extends StatelessWidget {
  const _NavigationBarDestinationTooltip({
    required this.message,
    required this.child,
  });

  final String message;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      verticalOffset: 34,
      excludeFromSemantics: true,
      preferBelow: false,
      child: child,
    );
  }
}

class _NavigationDestinationLayoutDelegate extends MultiChildLayoutDelegate {
  _NavigationDestinationLayoutDelegate({required this.animation})
    : super(relayout: animation);

  final Animation<double> animation;

  static const int iconId = 1;

  static const int labelId = 2;

  @override
  void performLayout(Size size) {
    double halfWidth(Size size) => size.width / 2;
    double halfHeight(Size size) => size.height / 2;

    final Size iconSize = layoutChild(iconId, BoxConstraints.loose(size));
    final Size labelSize = layoutChild(labelId, BoxConstraints.loose(size));

    final double yPositionOffset = Tween<double>(
      begin: halfHeight(iconSize),

      end: halfHeight(iconSize) + halfHeight(labelSize),
    ).transform(animation.value);
    final double iconYPosition = halfHeight(size) - yPositionOffset;

    positionChild(
      iconId,
      Offset(
        halfWidth(size) - halfWidth(iconSize),
        iconYPosition,
      ),
    );

    positionChild(
      labelId,
      Offset(
        halfWidth(size) - halfWidth(labelSize),

        iconYPosition + iconSize.height,
      ),
    );
  }

  @override
  bool shouldRelayout(_NavigationDestinationLayoutDelegate oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class _StatusTransitionWidgetBuilder extends StatusTransitionWidget {
  const _StatusTransitionWidgetBuilder({
    required super.animation,
    required this.builder,
    // ignore: unused_element_parameter
    this.child,
  });

  final TransitionBuilder builder;

  final Widget? child;

  @override
  Widget build(BuildContext context) => builder(context, child);
}

class _SelectableAnimatedBuilder extends StatefulWidget {
  const _SelectableAnimatedBuilder({
    required this.isSelected,
    this.duration = const Duration(milliseconds: 200),
    this.alwaysDoFullAnimation = false,
    required this.builder,
  });

  final bool isSelected;

  final Duration duration;

  final bool alwaysDoFullAnimation;

  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  _SelectableAnimatedBuilderState createState() =>
      _SelectableAnimatedBuilderState();
}

class _SelectableAnimatedBuilderState extends State<_SelectableAnimatedBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.duration = widget.duration;
    _controller.value = widget.isSelected ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(_SelectableAnimatedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        _controller.forward(from: widget.alwaysDoFullAnimation ? 0 : null);
      } else {
        _controller.reverse(from: widget.alwaysDoFullAnimation ? 1 : null);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}

class _CurvedAnimationBuilder extends StatefulWidget {
  const _CurvedAnimationBuilder({
    required this.animation,
    required this.curve,
    required this.reverseCurve,
    required this.builder,
  });

  final Animation<double> animation;
  final Curve curve;
  final Curve reverseCurve;
  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  _CurvedAnimationBuilderState createState() => _CurvedAnimationBuilderState();
}

class _CurvedAnimationBuilderState extends State<_CurvedAnimationBuilder> {
  late AnimationStatus _animationDirection;
  AnimationStatus? _preservedDirection;

  @override
  void initState() {
    super.initState();
    _animationDirection = widget.animation.status;
    _updateStatus(widget.animation.status);
    widget.animation.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (_animationDirection != status) {
      setState(() {
        _animationDirection = status;
      });
    }
    switch (status) {
      case AnimationStatus.forward || AnimationStatus.reverse
          when _preservedDirection != null:
        break;
      case AnimationStatus.forward || AnimationStatus.reverse:
        setState(() {
          _preservedDirection = status;
        });
      case AnimationStatus.completed || AnimationStatus.dismissed:
        setState(() {
          _preservedDirection = null;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldUseForwardCurve =
        (_preservedDirection ?? _animationDirection) != AnimationStatus.reverse;

    final Animation<double> curvedAnimation = CurveTween(
      curve: shouldUseForwardCurve ? widget.curve : widget.reverseCurve,
    ).animate(widget.animation);

    return widget.builder(context, curvedAnimation);
  }
}

const _indicatorDark = Color(0x15FFFFFF);
const _indicatorLight = Color(0x10000000);

class _NavigationBarDefaultsM3 extends NavigationBarThemeData {
  _NavigationBarDefaultsM3(this.context)
    : super(
        height: _kNavigationHeight,
        elevation: 3.0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      );

  final BuildContext context;
  late final _colors = Theme.of(context).colorScheme;
  late final _textTheme = Theme.of(context).textTheme;

  BorderSide get borderSide => _colors.isDark
      ? const BorderSide(color: Color(0x08FFFFFF))
      : const BorderSide(color: Color(0x08000000));

  @override
  Color? get backgroundColor => _colors.surfaceContainer;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  WidgetStateProperty<IconThemeData?>? get iconTheme {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      return IconThemeData(
        size: 24.0,
        color: states.contains(WidgetState.disabled)
            ? _colors.onSurfaceVariant.withValues(alpha: 0.38)
            : states.contains(WidgetState.selected)
            ? _colors.onSecondaryContainer
            : _colors.onSurfaceVariant,
      );
    });
  }

  @override
  Color? get indicatorColor =>
      _colors.isDark ? _indicatorDark : _indicatorLight;

  @override
  ShapeBorder? get indicatorShape => const StadiumBorder();

  @override
  WidgetStateProperty<TextStyle?>? get labelTextStyle {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      final TextStyle style = _textTheme.labelMedium!;
      return style.apply(
        color: states.contains(WidgetState.disabled)
            ? _colors.onSurfaceVariant.withValues(alpha: 0.38)
            : states.contains(WidgetState.selected)
            ? _colors.onSurface
            : _colors.onSurfaceVariant,
      );
    });
  }

  @override
  EdgeInsetsGeometry? get labelPadding => const EdgeInsets.only(top: 2);
}
