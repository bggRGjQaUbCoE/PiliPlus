import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

typedef PopupMenuItemSelected<T> = bool Function(T value);

class PopupMenuText<T> extends StatelessWidget {
  final String title;
  final ValueGetter<T> value;
  final PopupMenuItemSelected<T> onSelected;
  final PopupMenuItemBuilder<T> itemBuilder;
  final String Function(T) getSelectTitle;

  const PopupMenuText({
    super.key,
    required this.title,
    required this.value,
    required this.onSelected,
    required this.itemBuilder,
    required this.getSelectTitle,
  });

  @override
  Widget build(BuildContext context) {
    final select = value();
    final secondary = ColorScheme.of(context).secondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$title: '),
        PopupMenuButton<T>(
          initialValue: select,
          onSelected: (value) {
            if (value == select) return;
            if (!onSelected(value)) {
              (context as Element).markNeedsBuild();
            }
          },
          itemBuilder: itemBuilder,
          child: Text.rich(
            style: TextStyle(height: 1, fontSize: 14, color: secondary),
            strutStyle: const StrutStyle(height: 1, leading: 0, fontSize: 14),
            TextSpan(
              text: getSelectTitle(select),
              children: [
                WidgetSpan(
                  alignment: .middle,
                  child: Icon(
                    size: 14,
                    MdiIcons.unfoldMoreHorizontal,
                    color: secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
