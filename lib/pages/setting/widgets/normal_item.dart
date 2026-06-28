// Modified by barmxds6ch on 2026-06-28.
// SPDX-License-Identifier: GPL-3.0-only
import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:flutter/material.dart' hide ListTile;

class NormalItem extends StatefulWidget {
  final String? title;
  final ValueGetter<String>? getTitle;
  final String? subtitle;
  final ValueGetter<String>? getSubtitle;
  final Widget? leading;
  final Widget Function(ThemeData theme)? getTrailing;
  final void Function(BuildContext context, VoidCallback setState)? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const NormalItem({
    this.title,
    this.getTitle,
    this.subtitle,
    this.getSubtitle,
    this.leading,
    this.getTrailing,
    this.onTap,
    this.contentPadding,
    this.titleStyle,
    this.subtitleStyle,
    super.key,
  }) : assert(title != null || getTitle != null);

  @override
  State<NormalItem> createState() => _NormalItemState();
}

class _NormalItemState extends State<NormalItem> {
  @override
  Widget build(BuildContext context) {
    late final theme = Theme.of(context);
    Widget? subtitle;
    if ((widget.subtitle ?? widget.getSubtitle?.call()) case final text?) {
      subtitle = Text(
        text,
        style:
            widget.subtitleStyle ??
            theme.textTheme.labelMedium!.copyWith(
              color: theme.colorScheme.outline,
            ),
      );
    }
    return ListTile(
      contentPadding: widget.contentPadding,
      onTap: widget.onTap == null
          ? null
          : () => widget.onTap!(context, refresh),
      title: Text(
        widget.title ?? widget.getTitle!(),
        style: widget.titleStyle ?? theme.textTheme.titleMedium!,
      ),
      subtitle: subtitle,
      leading: widget.leading,
      trailing: widget.getTrailing?.call(theme),
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
