// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library;

import 'package:flutter/material.dart';

class CustomPopupMenuItem<T> extends PopupMenuEntry<T> {
  const CustomPopupMenuItem({
    super.key,
    this.value,
    this.height = kMinInteractiveDimension,
    required this.child,
  });

  final T? value;

  @override
  final double height;

  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  CustomPopupMenuItemState<T, CustomPopupMenuItem<T>> createState() =>
      CustomPopupMenuItemState<T, CustomPopupMenuItem<T>>();
}

class CustomPopupMenuItemState<T, W extends CustomPopupMenuItem<T>>
    extends State<W> {
  @protected
  @override
  Widget build(BuildContext context) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    const Set<WidgetState> states = <WidgetState>{};

    final style =
        popupMenuTheme.labelTextStyle?.resolve(states)! ??
        _PopupMenuDefaultsM3(context).labelTextStyle!.resolve(states)!;

    return ListTileTheme.merge(
      contentPadding: .zero,
      titleTextStyle: style,
      child: AnimatedDefaultTextStyle(
        style: style,
        duration: kThemeChangeDuration,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.height),
          child: Padding(
            padding: _PopupMenuDefaultsM3.menuItemPadding,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: widget.child,
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
      // TODO(quncheng): Update this hard-coded value to use the latest tokens.
      final TextStyle style = _textTheme.labelLarge!;
      if (states.contains(WidgetState.disabled)) {
        return style.apply(color: _colors.onSurface.withValues(alpha: 0.38));
      }
      return style.apply(color: _colors.onSurface);
    });
  }

  @override
  Color? get color => _colors.surfaceContainer;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)));

  // TODO(bleroux): This is taken from https://m3.material.io/components/menus/specs
  // Update this when the token is available.
  @override
  EdgeInsets? get menuPadding => const EdgeInsets.symmetric(vertical: 8.0);

  // TODO(tahatesser): This is taken from https://m3.material.io/components/menus/specs
  // Update this when the token is available.
  static EdgeInsets menuItemPadding  = const EdgeInsets.symmetric(horizontal: 12.0);
}// dart format on

// END GENERATED TOKEN PROPERTIES - PopupMenu
