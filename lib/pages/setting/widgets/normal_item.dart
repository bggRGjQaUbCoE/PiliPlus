part of '../models/model.dart';

class NormalItem extends SettingsItem {
  @override
  final String? title;
  final ValueGetter<String>? getTitle;
  final ValueGetter<String>? getSubtitle;
  final ValueGetter<Widget?>? getTrailing;
  final void Function(BuildContext context, void Function() setState)? onTap;

  @override
  String get effectiveTitle => title ?? getTitle!();
  @override
  String? get effectiveSubtitle => subtitle ?? getSubtitle?.call();

  const NormalItem({
    super.key,
    this.title,
    this.getTitle,
    super.subtitle,
    this.getSubtitle,
    super.leading,
    this.getTrailing,
    this.onTap,
    super.contentPadding,
    super.titleStyle,
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
