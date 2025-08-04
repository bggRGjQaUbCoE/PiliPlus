import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiSelectAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final MultiSelectBase ctr;
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
    if (visible ?? ctr.enableMultiSelect.value) {
      return AppBar(
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
      );
    }
    return child;
  }

  @override
  Size get preferredSize => child.preferredSize;
}
