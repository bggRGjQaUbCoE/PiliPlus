import 'package:PiliPlus/models/common/member/search_type.dart';
import 'package:PiliPlus/pages/member_search/child/controller.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberSearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final tabController = TabController(vsync: this, length: 2);
  final editingController = TextEditingController();
  final focusNode = FocusNode();

  final mid = Get.parameters['mid']!;
  final uname = Get.parameters['uname'];

  final RxBool hasData = false.obs;
  final RxList<int> counts = <int>[-1, -1].obs;

  late final arcCtr = Get.put(
    MemberSearchChildController(this, MemberSearchType.archive),
    tag: Utils.generateRandomString(8),
  );
  late final dynCtr = Get.put(
    MemberSearchChildController(this, MemberSearchType.dynamic),
    tag: Utils.generateRandomString(8),
  );

  void onClear() {
    if (editingController.value.text.isNotEmpty) {
      editingController.clear();
      counts.value = <int>[-1, -1];
      hasData.value = false;
      focusNode.requestFocus();
    } else {
      Get.back();
    }
  }

  void submit() {
    if (editingController.text.isNotEmpty) {
      hasData.value = true;
      arcCtr
        ..scrollController.jumpToTop()
        ..onReload();
      dynCtr
        ..scrollController.jumpToTop()
        ..onReload();
    }
  }

  @override
  void onClose() {
    editingController.dispose();
    focusNode.dispose();
    tabController.dispose();
    super.onClose();
  }
}
