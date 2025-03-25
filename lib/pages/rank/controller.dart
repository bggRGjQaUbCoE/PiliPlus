import 'dart:async';

import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/rank/zone/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/models/common/rank_type.dart';

class RankController extends GetxController
    with GetTickerProviderStateMixin, ScrollOrRefreshMixin {
  bool flag = false;
  late RxList tabs = [].obs;
  RxInt initialIndex = 0.obs;
  late TabController tabController;
  late List<Widget> tabsPageList;
  // late final StreamController<bool> searchBarStream =
  //     StreamController<bool>.broadcast();
  late bool enableGradientBg;

  ZoneController get controller => Get.find<ZoneController>(
      tag: tabsConfig[tabController.index]['rid'].toString());

  @override
  ScrollController get scrollController => controller.scrollController;

  @override
  void onInit() {
    super.onInit();
    // enableGradientBg =
    //     setting.get(SettingBoxKey.enableGradientBg, defaultValue: true);
    // 进行tabs配置
    setTabConfig();
  }

  void setTabConfig() async {
    tabs.value = tabsConfig;
    initialIndex.value = 0;
    tabsPageList = tabs.map((item) => ZonePage(rid: item['rid'])).toList();

    tabController = TabController(
      initialIndex: initialIndex.value,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  @override
  Future<void> onRefresh() => controller.onRefresh();
}
