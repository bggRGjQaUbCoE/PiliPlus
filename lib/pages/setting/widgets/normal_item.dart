import 'package:PiliPlus/common/widgets/list_tile.dart';
import 'package:flutter/material.dart' hide ListTile;

typedef StringGetter = String Function();

class NormalItem extends StatefulWidget {
  final String? title;
  final StringGetter? getTitle;
  final String? subtitle;
  final StringGetter? getSubtitle;
  final String? setKey;
  final Widget? leading;
  final Widget Function()? getTrailing;
  final Function? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;

  const NormalItem({
    this.title,
    this.getTitle,
    this.subtitle,
    this.getSubtitle,
    this.setKey,
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
    return ListTile(
      contentPadding: widget.contentPadding,
      onTap: () => widget.onTap?.call(() {
        setState(() {});
      }),
      title: Text(
        widget.title ?? widget.getTitle!(),
        style: widget.titleStyle ?? Theme.of(context).textTheme.titleMedium!,
      ),
      subtitle: widget.subtitle != null || widget.getSubtitle != null
          ? Text(
              widget.subtitle ?? widget.getSubtitle!(),
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            )
          : null,
      leading: widget.leading,
      trailing: widget.getTrailing?.call(),
    );
  }
}
