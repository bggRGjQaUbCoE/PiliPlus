import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

typedef PopupMenuItemSelected<T> = bool Function(T value);

class PopupMenuText<T> extends StatefulWidget {
  final String title;
  final T initialValue;
  final PopupMenuItemSelected<T> onSelected;
  final PopupMenuItemBuilder<T> itemBuilder;
  final String Function(T) getSelectTitle;

  const PopupMenuText({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onSelected,
    required this.itemBuilder,
    required this.getSelectTitle,
  });

  @override
  State<PopupMenuText<T>> createState() => _PopupMenuTextState();
}

class _PopupMenuTextState<T> extends State<PopupMenuText<T>> {
  late T select = widget.initialValue;

  @override
  void didUpdateWidget(PopupMenuText<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      select = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${widget.title}: '),
        PopupMenuButton<T>(
          initialValue: select,
          onSelected: (value) {
            if (value == select) return;
            if (!widget.onSelected(value)) {
              setState(() {
                select = value;
              });
            }
          },
          itemBuilder: widget.itemBuilder,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.getSelectTitle(select),
                style: TextStyle(
                  height: 1,
                  fontSize: 14,
                  color: secondary,
                ),
                strutStyle: const StrutStyle(
                  height: 1,
                  leading: 0,
                ),
              ),
              Icon(
                MdiIcons.unfoldMoreHorizontal,
                size: MediaQuery.textScalerOf(context).scale(14),
                color: secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
