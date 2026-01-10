import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:flutter/material.dart' hide ListTile;

class NormalItem extends StatefulWidget {
  final String? title;
  final ValueGetter<String>? getTitle;
  final String? subtitle;
  final ValueGetter<String>? getSubtitle;
  final Widget? leading;
  final ValueGetter<Widget?>? getTrailing;
  final void Function(BuildContext context, VoidCallback setState)? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;

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
    super.key,
  }) : assert(title != null || getTitle != null);

  @override
  State<NormalItem> createState() => _NormalItemState();
}

class _NormalItemState extends State<NormalItem> {
  @override
  Widget build(BuildContext context) {
    late final theme = Theme.of(context);
    return ListTile(
      contentPadding: widget.contentPadding,
      onTap: widget.onTap == null
          ? null
          : () => widget.onTap!(context, refresh),
      title: Text(
        widget.title ?? widget.getTitle!(),
        style: widget.titleStyle ?? theme.textTheme.titleMedium!,
      ),
      subtitle: widget.subtitle != null || widget.getSubtitle != null
          ? Text(
              widget.subtitle ?? widget.getSubtitle!(),
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.outline,
              ),
            )
          : null,
      leading: widget.leading,
      trailing: widget.getTrailing?.call(),
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
