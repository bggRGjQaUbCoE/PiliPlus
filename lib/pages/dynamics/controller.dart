import 'dart:async';

import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/follow.dart';
import 'package:PiliPlus/models/common/dynamics_type.dart';
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
  Rx<UpItem> upInfo = UpItem().obs;
  late TabController tabController;
  RxList<int> tempBannedList = <int>[].obs;
  late List<Widget> tabsPageList;
  RxInt initialValue = 0.obs;
  RxBool isLogin = false.obs;
  dynamic ownerMid;
  dynamic face;
  RxBool isLoadingDynamic = false.obs;
  List<UpItem> hasUpdatedUps = <UpItem>[];
  int allFollowedUpsPage = 1;
  int allFollowedUpsTotal = 0;

  late int currentMid = -1;
  late bool showLiveItems = GStorage.expandDynLivePanel;

  DynamicsTabController get controller => Get.find<DynamicsTabController>(
      tag: tabsConfig[tabController.index]['tag']);

  @override
  void onInit() {
    super.onInit();

    dynamic userInfo = GStorage.userInfo.get('userInfoCache');
    ownerMid = userInfo?.mid;
    face = userInfo?.face;
    isLogin.value = userInfo != null;

    tabController = TabController(
      length: tabsConfig.length,
      vsync: this,
      initialIndex: GStorage.setting
          .get(SettingBoxKey.defaultDynamicType, defaultValue: 0),
    );
    tabsPageList =
        tabsConfig.map((e) => DynamicsTabPage(dynamicsType: e['tag'])).toList();

    queryFollowUp();
  }

  Future<void> onSelectType(value) async {
    initialValue.value = value;
  }

  Future queryFollowing2() async {
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
    if (res['status']) {
      upData.value.upList ??= <UpItem>[];
      upData.value.upList!.addAll(
        res['data']
            .list
            .where((e) => hasUpdatedUps.every((e1) => e.mid != e1.mid))
            .map<UpItem>(
              (FollowItemModel e) => UpItem(
                face: e.face,
                mid: e.mid,
                uname: e.uname,
                hasUpdate: false,
              ),
            ),
      );
      allFollowedUpsPage += 1;
      allFollowedUpsTotal = res['data'].total;
      upData.refresh();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  late bool isQuerying = false;
  Future queryFollowUp({type = 'init'}) async {
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
      Future f1 = DynamicsHttp.followUp();
      Future f2 = FollowHttp.followings(
        vmid: ownerMid,
        pn: allFollowedUpsPage,
        ps: 50,
        orderType: 'attention',
      );
      List<dynamic> ress = await Future.wait([f1, f2]);
      if (!ress[0]['status']) {
        SmartDialog.showToast("获取关注动态失败：${ress[0]['msg']}");
        upData.value.errMsg = ress[0]['msg'];
        upData.refresh();
      } else {
        upData.value.liveUsers = ress[0]['data'].liveUsers;
        upData.refresh();
        hasUpdatedUps = ress[0]['data'].upList!;
      }
      List<UpItem> allFollowedUps = <UpItem>[];
      if (!ress[1]['status']) {
        SmartDialog.showToast("获取关注列表失败：${ress[1]['msg']}");
      } else {
        allFollowedUps = (ress[1]['data'].list as List)
            .where((e) => hasUpdatedUps.every((e1) => e.mid != e1.mid))
            .map<UpItem>(
              (e) => UpItem(
                face: e.face,
                mid: e.mid,
                uname: e.uname,
                hasUpdate: false,
              ),
            )
            .toList();
        allFollowedUpsPage += 1;
        allFollowedUpsTotal = ress[1]['data'].total;
      }
      upData.value.upList = hasUpdatedUps + allFollowedUps;
      upData.refresh();
    } else {
      var res = await DynamicsHttp.followUp();
      if (res['status']) {
        upData.value = res['data'];
        if (upData.value.upList!.isEmpty) {
          mid.value = -1;
        }
      } else {
        upData.value.errMsg = res['msg'];
        upData.refresh();
      }
    }
    isQuerying = false;
  }

  Future<void> onSelectUp(mid) async {
    if (this.mid == mid) {
      tabController.index = (mid == -1 ? 0 : 4);
      if (mid == -1) {
        queryFollowUp();
      }
      controller.onReload();
      return;
    }

    this.mid.value = mid;
    tabController.index = (mid == -1 ? 0 : 4);
  }

  @override
  Future<void> onRefresh() async {
    queryFollowUp();
    await controller.onRefresh();
  }

  @override
  Future<void> animateToTop() async {
    controller.animateToTop();
    scrollController.animToTop();
  }

  @override
  void toTopOrRefresh() {
    final ctr = controller;
    if (ctr.scrollController.hasClients) {
      if (ctr.scrollController.position.pixels == 0) {
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
