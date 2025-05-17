import 'dart:async';

import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/follow.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/models/follow/result.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DynamicsController extends GetxController
    with GetSingleTickerProviderStateMixin, ScrollOrRefreshMixin {
  @override
  final ScrollController scrollController = ScrollController();
  String? offset = '';
  Rx<FollowUpModel> upData = FollowUpModel().obs;
  // 默认获取全部动态
  RxInt mid = (-1).obs;
  late TabController tabController;
  Set<int> tempBannedList = <int>{};
  late List<Widget> tabsPageList;
  RxBool isLogin = false.obs;
  dynamic ownerMid;
  dynamic face;
  List<UpItem> hasUpdatedUps = <UpItem>[];
  int allFollowedUpsPage = 1;
  int allFollowedUpsTotal = 0;

  late int currentMid = -1;
  late bool showLiveItems = GStorage.expandDynLivePanel;

  final upPanelPosition = GStorage.upPanelPosition;

  DynamicsTabController? get controller {
    try {
      return Get.find<DynamicsTabController>(
          tag: DynamicsTabType.values[tabController.index].name);
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();

    dynamic userInfo = GStorage.userInfo.get('userInfoCache');
    ownerMid = userInfo?.mid;
    face = userInfo?.face;
    isLogin.value = userInfo != null;

    tabController = TabController(
      length: DynamicsTabType.values.length,
      vsync: this,
      initialIndex: GStorage.setting
          .get(SettingBoxKey.defaultDynamicType, defaultValue: 0),
    );
    tabsPageList = DynamicsTabType.values
        .map((e) => DynamicsTabPage(dynamicsType: e))
        .toList();

    queryFollowUp();
  }

  Future<void> queryFollowing2() async {
    if (upData.value.upList != null &&
        upData.value.upList!.length >= allFollowedUpsTotal) {
      return;
    }
    var res = await FollowHttp.followings(
      vmid: ownerMid,
      pn: allFollowedUpsPage,
      ps: 50,
      orderType: 'attention',
    );
    if (res.isSuccess) {
      upData.value.upList ??= <UpItem>[];
      upData.value.upList!.addAll(
        res.data.list!
            .where((e) => hasUpdatedUps.every((e1) => e.mid != e1.mid))
            .map(
              (FollowItemModel e) => UpItem(
                face: e.face,
                mid: e.mid,
                uname: e.uname,
                hasUpdate: false,
              ),
            ),
      );
      allFollowedUpsPage += 1;
      allFollowedUpsTotal = res.data.total!;
      upData.refresh();
    } else {
      res.toast();
    }
  }

  late bool isQuerying = false;
  Future<void> queryFollowUp({type = 'init'}) async {
    if (isQuerying) return;
    isQuerying = true;
    if (!isLogin.value) {
      upData.value.errMsg = '账号未登录';
      upData.refresh();
    }
    upData.value.errMsg = null;
    if (GStorage.setting
        .get(SettingBoxKey.dynamicsShowAllFollowedUp, defaultValue: false)) {
      allFollowedUpsPage = 1;
      final f1 = DynamicsHttp.followUp();
      final f2 = FollowHttp.followings(
        vmid: ownerMid,
        pn: allFollowedUpsPage,
        ps: 50,
        orderType: 'attention',
      );
      final res0 = await f1;
      if (!res0.isSuccess) {
        SmartDialog.showToast("获取关注动态失败：$res0");
        upData.value.errMsg = (res0 as Error).errMsg;
        upData.refresh();
      } else {
        upData.value.liveUsers = res0.data.liveUsers;
        upData.refresh();
        hasUpdatedUps = res0.data.upList!;
      }
      List<UpItem> allFollowedUps = <UpItem>[];
      final res1 = await f2;
      if (!res1.isSuccess) {
        SmartDialog.showToast("获取关注列表失败：$res1");
      } else {
        allFollowedUps = res1.data.list!
            .where((e) => hasUpdatedUps.every((e1) => e.mid != e1.mid))
            .map(
              (e) => UpItem(
                face: e.face,
                mid: e.mid,
                uname: e.uname,
                hasUpdate: false,
              ),
            )
            .toList();
        allFollowedUpsPage += 1;
        allFollowedUpsTotal = res1.data.total!;
      }
      upData.value.upList = hasUpdatedUps + allFollowedUps;
      upData.refresh();
    } else {
      var res = await DynamicsHttp.followUp();
      if (res.isSuccess) {
        upData.value = res.data;
        if (upData.value.upList!.isEmpty) {
          mid.value = -1;
        }
      } else {
        upData.value.errMsg = (res as Error).errMsg;
        upData.refresh();
      }
    }
    isQuerying = false;
  }

  void onSelectUp(int mid) {
    if (this.mid.value == mid) {
      tabController.index = (mid == -1 ? 0 : 4);
      if (mid == -1) {
        queryFollowUp();
      }
      controller?.onReload();
      return;
    }

    this.mid.value = mid;
    tabController.index = (mid == -1 ? 0 : 4);
  }

  @override
  Future<void> onRefresh() async {
    queryFollowUp();
    await controller?.onRefresh();
  }

  @override
  void animateToTop() {
    controller?.animateToTop();
    scrollController.animToTop();
  }

  @override
  void toTopOrRefresh() {
    final ctr = controller;
    if (ctr?.scrollController.hasClients == true) {
      if (ctr!.scrollController.position.pixels == 0) {
        if (scrollController.hasClients &&
            scrollController.position.pixels != 0) {
          scrollController.animToTop();
        }
        EasyThrottle.throttle(
            'topOrRefresh', const Duration(milliseconds: 500), onRefresh);
      } else {
        animateToTop();
      }
    } else {
      super.toTopOrRefresh();
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
