// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_initializing_formals

import 'package:material_ui/material_ui.dart' hide PopupMenuItem;
import 'package:material_ui/material_ui.dart' as material show PopupMenuItem;

const _kDefaultPopupMenuPadding = EdgeInsets.all(8);
const _kMd3eMenuContainerRadius = BorderRadius.all(Radius.circular(16));
const _kMd3eMenuItemRadius = BorderRadius.all(Radius.circular(12));
const _kMd3eMenuItemSelectedRadius = BorderRadius.all(Radius.circular(12));

Future<T?> showStaticPositionMenu<T>({
  required BuildContext context,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  Color? shadowColor,
  Color? surfaceTintColor,
  ShapeBorder? shape,
  EdgeInsetsGeometry? menuPadding,
  Color? color,
  bool useRootNavigator = false,
  BoxConstraints? constraints,
  EdgeInsetsGeometry? menuItemOuterPadding,
  Color? menuItemStateLayerColor,
  Clip clipBehavior = Clip.antiAlias,
  RouteSettings? routeSettings,
  AnimationStyle? popUpAnimationStyle,
  bool? requestFocus,
}) {
  final button = context.findRenderObject();
  final overlay = Overlay.maybeOf(context)?.context.findRenderObject();
  if (button is! RenderBox ||
      overlay is! RenderBox ||
      !button.attached ||
      !overlay.attached ||
      !button.hasSize ||
      !overlay.hasSize) {
    return Future<T?>.value();
  }
  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );
  return showMenu<T>(
    context: context,
    position: position,
    items: _wrapPopupMenuItems(
      items,
      initialValue,
      menuItemOuterPadding,
      menuItemStateLayerColor,
    ),
    initialValue: initialValue,
    elevation: elevation ?? _PopupMenuDefaultsM3(context).elevation,
    shadowColor: shadowColor ?? _PopupMenuDefaultsM3(context).shadowColor,
    surfaceTintColor:
        surfaceTintColor ?? _PopupMenuDefaultsM3(context).surfaceTintColor,
    shape: shape ?? _PopupMenuDefaultsM3(context).shape,
    menuPadding: menuPadding ?? _PopupMenuDefaultsM3(context).menuPadding,
    color: color ?? _PopupMenuDefaultsM3(context).color,
    useRootNavigator: useRootNavigator,
    constraints: constraints,
    clipBehavior: clipBehavior,
    routeSettings: routeSettings,
    popUpAnimationStyle: popUpAnimationStyle,
    requestFocus: requestFocus,
  );
}

List<PopupMenuEntry<T>> _wrapPopupMenuItems<T>(
  List<PopupMenuEntry<T>> items,
  T? initialValue,
  EdgeInsetsGeometry? menuItemOuterPadding,
  Color? menuItemStateLayerColor,
) {
  return items.map((item) {
    if (item is material.PopupMenuItem<T>) {
      return CustomPopupMenuItem<T>(
        value: item.value,
        height: item.height,
        selected: initialValue != null && item.represents(initialValue),
        enabled: item.enabled,
        padding: item.padding,
        labelTextStyle: item.labelTextStyle,
        textStyle: item.textStyle,
        mouseCursor: item.mouseCursor,
        onTap: item.onTap,
        outerPadding: menuItemOuterPadding,
        stateLayerColor: menuItemStateLayerColor,
        child: item.child,
      );
    }
    return item;
  }).toList();
}

class StaticPopupMenuButton<T> extends StatelessWidget {
  const StaticPopupMenuButton({
    super.key,
    required this.itemBuilder,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.padding = _kDefaultPopupMenuPadding,
    this.child,
    this.icon,
    this.iconSize,
    this.enabled = true,
    this.borderRadius,
    this.shape,
    this.menuPadding,
    this.color,
    this.useRootNavigator = false,
    this.constraints,
    this.menuItemOuterPadding,
    this.menuItemStateLayerColor,
    this.clipBehavior = Clip.antiAlias,
    this.routeSettings,
    this.popUpAnimationStyle,
    this.requestFocus,
  });

  final PopupMenuItemBuilder<T> itemBuilder;
  final T? initialValue;
  final PopupMenuItemSelected<T>? onSelected;
  final PopupMenuCanceled? onCanceled;
  final String? tooltip;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final EdgeInsetsGeometry padding;
  final Widget? child;
  final Widget? icon;
  final double? iconSize;
  final bool enabled;
  final BorderRadius? borderRadius;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? menuPadding;
  final Color? color;
  final bool useRootNavigator;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? menuItemOuterPadding;
  final Color? menuItemStateLayerColor;
  final Clip clipBehavior;
  final RouteSettings? routeSettings;
  final AnimationStyle? popUpAnimationStyle;
  final bool? requestFocus;

  Future<void> _showButtonMenu(BuildContext context) async {
    final value = await showStaticPositionMenu<T>(
      context: context,
      items: itemBuilder(context),
      initialValue: initialValue,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      menuPadding: menuPadding,
      color: color,
      useRootNavigator: useRootNavigator,
      constraints: constraints,
      menuItemOuterPadding: menuItemOuterPadding,
      menuItemStateLayerColor: menuItemStateLayerColor,
      clipBehavior: clipBehavior,
      routeSettings: routeSettings,
      popUpAnimationStyle: popUpAnimationStyle,
      requestFocus: requestFocus,
    );
    if (value == null) {
      onCanceled?.call();
      return;
    }
    onSelected?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final buttonTheme = Theme.of(context);
    final menuTheme = buttonTheme.copyWith(highlightColor: Colors.transparent);
    return Theme(
      data: menuTheme,
      child: Builder(
        builder: (menuContext) {
          final onPressed = enabled ? () => _showButtonMenu(menuContext) : null;
          if (child case final child?) {
            Widget result = child;
            if (padding != _kDefaultPopupMenuPadding) {
              result = Padding(
                padding: padding,
                child: result,
              );
            }
            if (enabled) {
              result = InkWell(
                onTap: onPressed,
                borderRadius: borderRadius,
                child: result,
              );
            }
            if (tooltip case final tooltip?) {
              result = Tooltip(message: tooltip, child: result);
            }
            return Theme(data: buttonTheme, child: result);
          }
          return Theme(
            data: buttonTheme,
            child: IconButton(
              tooltip:
                  tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
              padding: padding,
              iconSize: iconSize ?? 24,
              onPressed: onPressed,
              icon: icon ?? const Icon(Icons.more_vert),
            ),
          );
        },
      ),
    );
  }
}

class CustomPopupMenuItem<T> extends PopupMenuEntry<T> {
  const CustomPopupMenuItem({
    super.key,
    this.value,
    this.height = kMinInteractiveDimension,
    this.selected = false,
    this.enabled = true,
    this.borderRadius,
    this.padding,
    this.labelTextStyle,
    this.textStyle,
    this.mouseCursor,
    this.onTap,
    this.outerPadding,
    this.stateLayerColor,
    required this.child,
  });

  final T? value;

  @override
  final double height;

  final bool selected;

  final bool enabled;

  final BorderRadius? borderRadius;

  final EdgeInsetsGeometry? padding;

  final WidgetStateProperty<TextStyle?>? labelTextStyle;

  final TextStyle? textStyle;

  final MouseCursor? mouseCursor;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry? outerPadding;

  final Color? stateLayerColor;

  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  CustomPopupMenuItemState<T> createState() => CustomPopupMenuItemState<T>();
}

class CustomPopupMenuItemState<T> extends State<CustomPopupMenuItem<T>> {
  @protected
  @override
  Widget build(BuildContext context) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final Set<WidgetState> states = <WidgetState>{
      if (widget.selected) WidgetState.selected,
      if (!widget.enabled) WidgetState.disabled,
    };

    final colors = ColorScheme.of(context);
    final customStateLayerColor = widget.stateLayerColor;
    final selectedForegroundColor =
        customStateLayerColor ?? colors.onSecondaryContainer;

    var style =
        widget.labelTextStyle?.resolve(states) ??
        widget.textStyle ??
        popupMenuTheme.labelTextStyle?.resolve(states)! ??
        _PopupMenuDefaultsM3(context).labelTextStyle!.resolve(states)!;
    if (widget.selected && customStateLayerColor != null) {
      style = style.copyWith(color: selectedForegroundColor);
    }
    //使用Flutter原始的颜色方案，来计算选中状态的颜色
    final selectedColor = customStateLayerColor == null
        ? colors.secondaryContainer
        : Theme.of(context).brightness == Brightness.dark
        ? const Color(0x40CCCCCC)
        : const Color(0x66BCBCBC);
    final stateLayerColor = widget.selected
        ? selectedForegroundColor
        : customStateLayerColor ?? colors.onSurface;

    final onTap = !widget.enabled || widget.value == null && widget.onTap == null
        ? null
        : () {
            Navigator.pop<T>(context, widget.value);
            widget.onTap?.call();
          };
    final borderRadius = widget.borderRadius ??
        (widget.selected ? _kMd3eMenuItemSelectedRadius : _kMd3eMenuItemRadius);

    return ListTileTheme.merge(
      contentPadding: .zero,
      titleTextStyle: style,
      iconColor: widget.selected ? selectedForegroundColor : colors.outline,
      child: Padding(
        padding: widget.outerPadding ?? _PopupMenuDefaultsM3.menuItemOuterPadding,
        child: Material(
          color: widget.selected ? selectedColor : Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            mouseCursor: widget.mouseCursor,
            highlightColor: stateLayerColor.withValues(alpha: 0.1),
            hoverColor: stateLayerColor.withValues(alpha: 0.08),
            focusColor: widget.selected
                ? Colors.transparent
                : stateLayerColor.withValues(alpha: 0.1),
            splashColor: stateLayerColor.withValues(alpha: 0.1),
            child: AnimatedDefaultTextStyle(
              style: style,
              duration: kThemeChangeDuration,
              child: IconTheme.merge(
                data: IconThemeData(
                  size: 20,
                  color: widget.selected
                      ? selectedForegroundColor
                      : colors.outline,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: widget.height),
                  child: Padding(
                    padding: widget.padding ?? _PopupMenuDefaultsM3.menuItemPadding,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPopupMenuDivider extends PopupMenuEntry<Never> {
  const CustomPopupMenuDivider({
    super.key,
    required this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.radius,
  });

  @override
  final double height;

  final double? thickness;

  final double? indent;

  final double? endIndent;

  final BorderRadiusGeometry? radius;

  @override
  bool represents(void value) => false;

  @override
  State<CustomPopupMenuDivider> createState() => _CustomPopupMenuDividerState();
}

class _CustomPopupMenuDividerState extends State<CustomPopupMenuDivider> {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: widget.height,
      thickness: widget.thickness,
      indent: widget.indent,
      color: ColorScheme.of(context).outline.withValues(alpha: 0.2),
      endIndent: widget.endIndent,
      radius: widget.radius,
    );
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - PopupMenu

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _PopupMenuDefaultsM3 extends PopupMenuThemeData {
  _PopupMenuDefaultsM3(this.context)
    : super(elevation: 3.0);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override WidgetStateProperty<TextStyle?>? get labelTextStyle {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      final TextStyle style = _textTheme.labelLarge!.copyWith(
        letterSpacing: 0.1,
        fontWeight: FontWeight.w500,
      );
      if (states.contains(WidgetState.disabled)) {
        return style.apply(color: _colors.onSurface.withValues(alpha: 0.38));
      }
      if (states.contains(WidgetState.selected)) {
        return style.apply(color: _colors.onSecondaryContainer);
      }
      return style.apply(color: _colors.onSurface);
    });
  }

  @override
  Color? get color => _colors.surfaceContainerLow;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape => const RoundedRectangleBorder(borderRadius: _kMd3eMenuContainerRadius);

  // TODO(bleroux): This is taken from https://m3.material.io/components/menus/specs
  // Update this when the token is available.
  @override
  EdgeInsets? get menuPadding => const EdgeInsets.symmetric(vertical: 4.0);

  // TODO(tahatesser): This is taken from https://m3.material.io/components/menus/specs
  // Update this when the token is available.
  static EdgeInsets menuItemPadding  = const EdgeInsets.symmetric(horizontal: 16.0);

  static EdgeInsets menuItemOuterPadding = const EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 2,
  );
}// dart format on

// END GENERATED TOKEN PROPERTIES - PopupMenu
