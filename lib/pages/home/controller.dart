import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin, ScrollOrRefreshMixin {
  late TabController tabController;

  ScrollOrRefreshMixin get controller =>
      HomeTabType.values[tabController.index].ctr();

  @override
  ScrollController get scrollController => controller.scrollController;

  AccountService accountService = Get.find<AccountService>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      initialIndex: HomeTabType.rcmd.index,
      length: HomeTabType.values.length,
      vsync: this,
    );
  }

  @override
  Future<void> onRefresh() {
    return controller.onRefresh();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
