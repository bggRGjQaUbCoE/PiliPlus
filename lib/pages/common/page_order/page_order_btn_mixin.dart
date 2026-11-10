import 'package:PiliPlus/pages/common/page_order/page_order_mixin.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

mixin PageOrderBtnMixin<S extends StatefulWidget, R, T> on State<S> {
  PageOrderMixin<R, T> get controller;

  Widget get pageOrderBtn => Builder(
    builder: (context) => PopupMenuButton<bool>(
      icon: controller.pageDesc
          ? const Icon(MdiIcons.sortNumericDescending)
          : const Icon(MdiIcons.sortNumericAscending),
      initialValue: controller.pageDesc,
      tooltip: '页码顺序',
      onSelected: (value) {
        controller.updatePageOrder(value);
        (context as Element).markNeedsBuild();
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: false, child: Text('正序')),
        PopupMenuItem(value: true, child: Text('倒序')),
      ],
    ),
  );
}
