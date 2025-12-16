import 'package:PiliPlus/models/common/live_search_type.dart';
import 'package:PiliPlus/pages/live_search/child/controller.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveSearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final tabController = TabController(vsync: this, length: 2);
  final editingController = TextEditingController();
  final focusNode = FocusNode();

  final mid = Get.parameters['mid'];
  final uname = Get.parameters['uname'];

  final RxBool hasData = false.obs;
  final RxList<int> counts = <int>[-1, -1].obs;

  late final roomCtr = Get.put(
    LiveSearchChildController(this, LiveSearchType.room),
    tag: Utils.generateRandomString(8),
  );
  late final userCtr = Get.put(
    LiveSearchChildController(this, LiveSearchType.user),
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
      if (IdUtils.digitOnlyRegExp.hasMatch(editingController.text)) {
        PageUtils.toLiveRoom(int.parse(editingController.text));
      } else {
        hasData.value = true;
        roomCtr
          ..scrollController.jumpToTop()
          ..onReload();
        userCtr
          ..scrollController.jumpToTop()
          ..onReload();
      }
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
