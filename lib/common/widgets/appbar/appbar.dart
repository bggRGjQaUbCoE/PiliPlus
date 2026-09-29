import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class MultiSelectAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final MultiSelectBase ctr;
  final bool? visible;
  final AppBar child;
  final List<Widget>? actions;

  const MultiSelectAppBarWidget({
    super.key,
    required this.ctr,
    this.visible,
    this.actions,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (visible ?? ctr.enableMultiSelect.value) {
      final style = TextButton.styleFrom(visualDensity: VisualDensity.compact);
      final colorScheme = ColorScheme.of(context);
      return AppBar(
        bottom: child.bottom,
        leading: IconButton(
          tooltip: L10n.current.cancel,
          onPressed: ctr.handleSelect,
          icon: const Icon(Icons.close_outlined),
        ),
        title: Obx(
          () => Text(
            L10n.current.multiSelectAppBarWidgetTitle(
              ctr.checkedCount,
            ),
          ),
        ),
        actions: [
          TextButton(
            style: style,
            onPressed: () => ctr.handleSelect(checked: true),
            child: Text(L10n.current.multiSelectAppBarWidgetChild),
          ),
          ...?actions,
          TextButton(
            style: style,
            onPressed: () {
              if (ctr.checkedCount == 0) {
                return;
              }
              ctr.onRemove();
            },
            child: Text(
              L10n.current.remove,
              style: TextStyle(color: colorScheme.error),
            ),
          ),
          const SizedBox(width: 6),
        ],
      );
    }
    return child;
  }

  @override
  Size get preferredSize => child.preferredSize;
}
