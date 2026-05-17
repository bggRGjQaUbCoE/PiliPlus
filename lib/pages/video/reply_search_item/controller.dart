import 'package:PiliPlus/models/common/reply/reply_search_type.dart';
import 'package:PiliPlus/pages/video/reply_search_item/child/controller.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/utils/nav.dart';

class ReplySearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ReplySearchController(this.type, this.oid);
  final int type;
  final int oid;

  late final FocusNode focusNode;
  late final TabController tabController;
  late final TextEditingController editingController;

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
      Nav.back();
    }
  }

  @override
  void onInit() {
    super.onInit();
    focusNode = FocusNode();
    tabController = TabController(vsync: this, length: 2);
    editingController = TextEditingController();
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
    focusNode.dispose();
    tabController.dispose();
    editingController.dispose();
    super.onClose();
  }
}
