import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart' hide ListTile;

typedef PopupMenuItemSelected<T> =
    void Function(T value, VoidCallback setState);

List<PopupMenuEntry<T>> enumItemBuilder<T extends EnumWithLabel>(
  List<T> items,
) => items.map((e) => PopupMenuItem(value: e, child: Text(e.label))).toList();

enum DescPosType { subtitle, title, trailing }

class PopupListTile<T> extends StatefulWidget {
  const PopupListTile({
    super.key,
    this.dense,
    this.safeArea = true,
    this.enabled = true,
    this.leading,
    required this.title,
    this.descPosType = .subtitle,
    required this.value,
    required this.itemBuilder,
    required this.onSelected,
  });

  final bool? dense;
  final bool safeArea;
  final bool enabled;
  final Widget? leading;
  final Widget title;

  final DescPosType descPosType;
  final ValueGetter<(T, String)> value;
  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T> onSelected;

  @override
  State<PopupListTile<T>> createState() => _PopupListTileState<T>();
}

class _PopupListTileState<T> extends State<PopupListTile<T>> {
  final _key = PlatformUtils.isDesktop ? null : GlobalKey();

  void _showButtonMenu(TapUpDetails details, T value) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(box.size.topLeft(.zero));
    final double dx;
    if (PlatformUtils.isDesktop) {
      dx = details.globalPosition.dx + 1;
    } else {
      final box = _key!.currentContext!.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(box.size.topLeft(.zero));
      dx = offset.dx;
    }
    showMenu<T?>(
      context: context,
      position: RelativeRect.fromLTRB(dx, offset.dy + 5, dx, 0),
      items: widget.itemBuilder(context),
      initialValue: value,
      requestFocus: true,
    ).then<void>((T? newValue) {
      if (!mounted) {
        return;
      }
      if (newValue == null || newValue == value) {
        return;
      }
      widget.onSelected(newValue, _refresh);
    });
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (value, descStr) = widget.value();
    Widget title = KeyedSubtree(key: _key, child: widget.title);
    Widget? subtitle;
    Widget? trailing;
    final desc = Text(
      descStr,
      style: TextStyle(
        fontSize: 13,
        color: widget.enabled
            ? theme.colorScheme.secondary
            : theme.disabledColor,
      ),
    );
    switch (widget.descPosType) {
      case DescPosType.subtitle:
        subtitle = desc;
      case DescPosType.title:
        title = Row(
          spacing: 12,
          mainAxisSize: .min,
          children: [title, desc],
        );
      case DescPosType.trailing:
        trailing = desc;
    }
    return ListTile(
      dense: widget.dense,
      safeArea: widget.safeArea,
      enabled: widget.enabled,
      onTapUp: (details) => _showButtonMenu(details, value),
      leading: widget.leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}
