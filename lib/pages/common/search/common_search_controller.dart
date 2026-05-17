import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/utils/nav.dart';

abstract class CommonSearchController<R, T> extends CommonListController<R, T> {
  final editController = TextEditingController();
  final focusNode = FocusNode();

  void onClear() {
    if (editController.text.isNotEmpty) {
      editController.clear();
    } else {
      Nav.back();
    }
  }

  @override
  Future<void> onRefresh() {
    if (editController.value.text.isEmpty) {
      return Future.syncValue(null);
    }
    return super.onRefresh();
  }

  @override
  void onClose() {
    editController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
