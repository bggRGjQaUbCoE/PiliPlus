import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    required this.child1,
    required this.child2,
    required this.visible,
    super.key,
  });

  final PreferredSizeWidget child1;
  final PreferredSizeWidget child2;
  final bool visible;
  @override
  Size get preferredSize => child1.preferredSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: !visible
          ? KeyedSubtree.wrap(child1, 0)
          : KeyedSubtree.wrap(child2, 1),
    );
  }
}

class MultiSelectAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final MultiSelectMixin ctr;
  final bool? visible;
  final AppBar child;
  final List<Widget>? children;

  const MultiSelectAppBarWidget({
    super.key,
    required this.ctr,
    this.visible,
    this.children,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      visible: visible ?? ctr.enableMultiSelect.value,
      child1: child,
      child2: AppBar(
        bottom: child.bottom,
        leading: IconButton(
          tooltip: '取消',
          onPressed: ctr.handleSelect,
          icon: const Icon(Icons.close_outlined),
        ),
        title: Obx(() => Text('已选: ${ctr.checkedCount}')),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () => ctr.handleSelect(true),
            child: const Text('全选'),
          ),
          ...?children,
          TextButton(
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            onPressed: ctr.onConfirm,
            child: Text(
              '移除',
              style: TextStyle(color: Get.theme.colorScheme.error),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => child.preferredSize;
}
