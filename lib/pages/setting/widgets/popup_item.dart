import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:material_ui/material_ui.dart' hide ListTile;
import 'package:material_ui/material_ui.dart' as material show PopupMenuItem;

typedef PopupMenuItemSelected<T> = void Function(
  T value,
  VoidCallback setState,
);

List<PopupMenuEntry<T>> enumItemBuilder<T extends EnumWithLabel>(
  Iterable<T> items,
) => items
    .map((e) => CustomPopupMenuItem(value: e, child: Text(e.label)))
    .toList();

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
    this.titleStyle,
    this.descStyle,
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
  final TextStyle? titleStyle;
  final TextStyle? descStyle;

  @override
  State<PopupListTile<T>> createState() => _PopupListTileState<T>();
}

class _PopupListTileState<T> extends State<PopupListTile<T>> {
  final _key = PlatformUtils.isDesktop ? null : GlobalKey();

  void _showButtonMenu(
    BuildContext menuContext,
    TapUpDetails details,
    T value,
  ) {
    final thisOffset = details.globalPosition - details.localPosition;
    final double dx;
    if (PlatformUtils.isDesktop) {
      dx = details.globalPosition.dx + 1;
    } else {
      final thisBox = context.findRenderObject();
      final titleBox = _key!.currentContext!.findRenderObject() as RenderBox;
      final titleOffset = titleBox.localToGlobal(.zero, ancestor: thisBox);
      dx = thisOffset.dx + titleOffset.dx;
    }
    final items = widget.itemBuilder(context).map((item) {
      if (item is CustomPopupMenuItem<T>) {
        return CustomPopupMenuItem<T>(
          value: item.value,
          height: item.height,
          selected: item.represents(value),
          enabled: item.enabled,
          padding: item.padding,
          labelTextStyle: item.labelTextStyle,
          textStyle: item.textStyle,
          mouseCursor: item.mouseCursor,
          onTap: item.onTap,
          borderRadius: item.borderRadius,
          outerPadding: item.outerPadding,
          stateLayerColor: item.stateLayerColor,
          child: item.child,
        );
      }
      if (item is material.PopupMenuItem<T>) {
        return CustomPopupMenuItem<T>(
          value: item.value,
          height: item.height,
          selected: item.represents(value),
          enabled: item.enabled,
          padding: item.padding,
          labelTextStyle: item.labelTextStyle,
          textStyle: item.textStyle,
          mouseCursor: item.mouseCursor,
          onTap: item.onTap,
          child: item.child,
        );
      }
      return item;
    }).toList();
    showMenu<T?>(
      context: menuContext,
      position: RelativeRect.fromLTRB(dx, thisOffset.dy + 5, dx, 0),
      items: items,
      initialValue: value,
      requestFocus: false,
    ).then<void>((newValue) {
      if (!mounted) return;
      if (newValue == null || newValue == value) return;
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
      style: (widget.descStyle ?? theme.textTheme.labelMedium!).copyWith(
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
    final menuTheme = theme.copyWith(highlightColor: Colors.transparent);
    return Theme(
      data: menuTheme,
      child: Builder(
        builder: (menuContext) => Theme(
          data: theme,
          child: ListTile(
            dense: widget.dense,
            safeArea: widget.safeArea,
            enabled: widget.enabled,
            onTapUp: (details) => _showButtonMenu(
              menuContext,
              details,
              value,
            ),
            leading: widget.leading,
            title: title,
            titleTextStyle: widget.titleStyle ?? theme.textTheme.titleMedium,
            subtitle: subtitle,
            trailing: trailing,
          ),
        ),
      ),
    );
  }
}
