import 'package:PiliPlus/models/common/reply/reply_search_type.dart';
import 'package:PiliPlus/pages/video/reply_search_item/child/controller.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplySearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ReplySearchController(this.type, this.oid);
  final int type;
  final int oid;

  late final tabController = TabController(vsync: this, length: 2);
  final editingController = TextEditingController();
  final focusNode = FocusNode();

  late final videoCtr = Get.put(
    ReplySearchChildController(this, ReplySearchType.video),
    tag: Utils.generateRandomString(8),
  );
  late final articleCtr = Get.put(
    ReplySearchChildController(this, ReplySearchType.article),
    tag: Utils.generateRandomString(8),
  );

  void onClear() {
    if (editingController.value.text.isNotEmpty) {
      editingController.clear();
      focusNode.requestFocus();
    } else {
      Get.back();
    }
  }

  @override
  void onInit() {
    super.onInit();
    submit();
  }

  void submit() {
    videoCtr
      ..scrollController.jumpToTop()
      ..onReload();
    articleCtr
      ..scrollController.jumpToTop()
      ..onReload();
  }

  @override
  void onClose() {
    editingController.dispose();
    focusNode.dispose();
    tabController.dispose();
    super.onClose();
  }
}
