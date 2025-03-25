import 'dart:async';

import 'package:PiliPlus/http/follow.dart';
import 'package:PiliPlus/pages/dynamics/tab/controller.dart';
import 'package:PiliPlus/pages/dynamics/tab/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/models/common/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/utils/storage.dart';

import '../../models/follow/result.dart';
import '../common/common_controller.dart';

class DynamicsController extends GetxController
    with GetTickerProviderStateMixin, ScrollOrRefreshMixin {
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
  List<UpItem> allFollowedUps = <UpItem>[];
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

  onSelectType(value) async {
    initialValue.value = value;
  }

  Future queryFollowing2() async {
    if (allFollowedUps.length >= allFollowedUpsTotal) {
      SmartDialog.showToast('没有更多了');
      return;
    }
    var res = await FollowHttp.followings(
      vmid: ownerMid,
      pn: allFollowedUpsPage,
      ps: 50,
      orderType: 'attention',
    );
    if (res['status']) {
      allFollowedUps.addAll(res['data'].list.map<UpItem>((FollowItemModel e) =>
          UpItem(
              face: e.face,
              mid: e.mid,
              uname: e.uname,
              hasUpdate: hasUpdatedUps.any((element) =>
                  (element.mid == e.mid) && (element.hasUpdate == true)))));
      allFollowedUpsPage += 1;
      allFollowedUpsTotal = res['data'].total;
      upData.value.upList = allFollowedUps;
      upData.refresh();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future queryFollowUp({type = 'init'}) async {
    if (!isLogin.value) {
      upData.value.errMsg = '账号未登录';
      upData.refresh();
    }
    upData.value.errMsg = null;
    if (type == 'init') {
      upData.value.upList = [];
      upData.value.liveUsers = LiveUsers();
    }
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
      if (!ress[1]['status']) {
        SmartDialog.showToast("获取关注列表失败：${ress[1]['msg']}");
      } else {
        allFollowedUps = ress[1]['data']
            .list
            .map<UpItem>((FollowItemModel e) => UpItem(
                face: e.face,
                mid: e.mid,
                uname: e.uname,
                hasUpdate: hasUpdatedUps.any((element) =>
                    (element.mid == e.mid) && (element.hasUpdate == true))))
            .toList();
        allFollowedUpsPage += 1;
        allFollowedUpsTotal = ress[1]['data'].total;
      }
      upData.value.upList =
          allFollowedUpsTotal > 0 ? allFollowedUps : hasUpdatedUps;
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
  }

  onSelectUp(mid) async {
    if (mid == this.mid.value) {
      this.mid.refresh();
      return;
    }
    this.mid.value = mid;
    tabController.index = (mid == -1 ? 0 : 4);
  }

  @override
  onRefresh() async {
    queryFollowUp();
    await controller.onRefresh();
  }

  // 返回顶部并刷新
  @override
  void animateToTop() async {
    controller.animateToTop();
    scrollController.animToTop();
  }

  @override
  FutureOr<void> toTopOrRefresh() {
    if (scrollController.hasClients && controller.scrollController.hasClients) {
      if (scrollController.position.pixels == 0 &&
          controller.scrollController.position.pixels == 0) {
        return onRefresh();
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
