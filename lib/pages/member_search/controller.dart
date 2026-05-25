import 'package:PiliPlus/pages/member_search/child/controller.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberSearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final FocusNode focusNode;
  late final TabController tabController;
  late final TextEditingController editingController;

  final mid = Get.parameters['mid']!;
  final uname = Get.parameters['uname'];

  final RxBool hasData = false.obs;
  final RxList<int> counts = <int>[-1, -1].obs;

  late final MemberSearchChildController arcCtr;
  late final MemberSearchChildController dynCtr;

  @override
  void onInit() {
    super.onInit();
    focusNode = FocusNode();
    editingController = TextEditingController();
    tabController = TabController(vsync: this, length: 2);
    arcCtr = Get.put(
      MemberSearchChildController(this, .archive),
      tag: Utils.generateRandomString(8),
    );
    dynCtr = Get.put(
      MemberSearchChildController(this, .dynamic),
      tag: Utils.generateRandomString(8),
    );
  }

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

  void submit([_]) {
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
    focusNode.dispose();
    tabController.dispose();
    editingController.dispose();
    super.onClose();
  }
}
