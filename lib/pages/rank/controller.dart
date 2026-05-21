import 'package:PiliPlus/models/common/rank_type.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/rank/zone/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankController extends GetxController
    with GetSingleTickerProviderStateMixin, ScrollOrRefreshMixin {
  RxInt tabIndex = 0.obs;
  late TabController tabController;

  ZoneController get controller {
    final item = RankType.values[tabController.index];
    return Get.find<ZoneController>(tag: '${item.rid}${item.seasonType}');
  }

  @override
  ScrollController get scrollController => controller.scrollController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: RankType.values.length, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  @override
  Future<void> onRefresh() => controller.onRefresh();
}
