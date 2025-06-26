import 'dart:async';
import 'dart:math' show max;

import 'package:PiliPlus/grpc/dyn.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models_new/msgfeed_unread/data.dart';
import 'package:PiliPlus/models_new/single_unread/data.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/update.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AccountService accountService = Get.find<AccountService>();

  List<NavigationBarType> navigationBars = <NavigationBarType>[];
  RxInt dynCount = 0.obs;

  StreamController<bool>? bottomBarStream;
  late bool hideTabBar = Pref.hideTabBar;
  late dynamic controller;
  RxInt selectedIndex = 0.obs;

  late DynamicBadgeMode dynamicBadgeMode;
  late bool checkDynamic = Pref.checkDynamic;
  late int dynamicPeriod = Pref.dynamicPeriod;
  late int _lastCheckDynamicAt = 0;
  late int dynIndex = -1;

  late int homeIndex = -1;
  late DynamicBadgeMode msgBadgeMode = Pref.msgBadgeMode;
  late Set<MsgUnReadType> msgUnReadTypes = Pref.msgUnReadTypeV2;
  late final RxString msgUnReadCount = ''.obs;
  late int lastCheckUnreadAt = 0;

  final enableMYBar = Pref.enableMYBar;
  final useSideBar = Pref.useSideBar;
  final mainTabBarView = Pref.mainTabBarView;
  late bool navSearchStreamDebounce = Pref.navSearchStreamDebounce;
  late final optTabletNav = Pref.optTabletNav;

  late bool directExitOnBack = Pref.directExitOnBack;

  @override
  void onInit() {
    super.onInit();
    if (Pref.autoUpdate) {
      Update.checkUpdate();
    }

    setNavBarConfig();

    controller = mainTabBarView
        ? TabController(
            vsync: this,
            initialIndex: selectedIndex.value,
            length: navigationBars.length,
          )
        : PageController(initialPage: selectedIndex.value);

    if (navigationBars.length > 1 && hideTabBar) {
      bottomBarStream = StreamController<bool>.broadcast();
    }
    dynamicBadgeMode = DynamicBadgeMode.values[Pref.dynamicBadgeMode];

    dynIndex = navigationBars.indexOf(NavigationBarType.dynamics);
    if (dynamicBadgeMode != DynamicBadgeMode.hidden) {
      if (dynIndex != -1) {
        if (checkDynamic) {
          _lastCheckDynamicAt = DateTime.now().millisecondsSinceEpoch;
        }
        getUnreadDynamic();
      }
    }

    homeIndex = navigationBars.indexOf(NavigationBarType.home);
    if (msgBadgeMode != DynamicBadgeMode.hidden) {
      if (homeIndex != -1) {
        lastCheckUnreadAt = DateTime.now().millisecondsSinceEpoch;
        queryUnreadMsg();
      }
    }
  }

  Future<int> _msgUnread() async {
    if (msgUnReadTypes.contains(MsgUnReadType.pm)) {
      var res = await MsgHttp.msgUnread();
      if (res['status']) {
        SingleUnreadData data = res['data'];
        return data.followUnread +
            data.unfollowUnread +
            data.bizMsgFollowUnread +
            data.bizMsgUnfollowUnread +
            data.unfollowPushMsg +
            data.customUnread;
      }
    }
    return 0;
  }

  Future<int> _msgFeedUnread() async {
    int count = 0;
    var remainTypes = Set<MsgUnReadType>.from(msgUnReadTypes)
      ..remove(MsgUnReadType.pm);
    if (remainTypes.isNotEmpty) {
      var res = await MsgHttp.msgFeedUnread();
      if (res['status']) {
        MsgFeedUnreadData data = res['data'];
        for (var item in remainTypes) {
          switch (item) {
            case MsgUnReadType.pm:
              break;
            case MsgUnReadType.reply:
              count += data.reply;
              break;
            case MsgUnReadType.at:
              count += data.at;
              break;
            case MsgUnReadType.like:
              count += data.like;
              break;
            case MsgUnReadType.sysMsg:
              count += data.sysMsg;
              break;
          }
        }
      }
    }
    return count;
  }

  Future<void> queryUnreadMsg([bool isChangeType = false]) async {
    if (!accountService.isLogin.value ||
        homeIndex == -1 ||
        msgUnReadTypes.isEmpty ||
        msgBadgeMode == DynamicBadgeMode.hidden) {
      msgUnReadCount.value = '';
      return;
    }

    var res = await Future.wait([_msgUnread(), _msgFeedUnread()]);

    int count = res.fold(0, (prev, e) => prev + e);

    final countStr = count == 0
        ? ''
        : count > 99
            ? '99+'
            : count.toString();
    if (msgUnReadCount.value == countStr) {
      if (isChangeType) {
        msgUnReadCount.refresh();
      }
    } else {
      msgUnReadCount.value = countStr;
    }
  }

  Future<void> getUnreadDynamic() async {
    if (!accountService.isLogin.value || dynIndex == -1) {
      return;
    }
    DynGrpc.dynRed().then((res) {
      if (res != null) {
        setCount(res);
      }
    });
  }

  Future<void> setCount([int count = 0]) async {
    if (dynIndex == -1 || dynCount.value == count) return;
    dynCount.value = count;
  }

  void checkUnreadDynamic() {
    if (dynIndex == -1 ||
        !accountService.isLogin.value ||
        dynamicBadgeMode == DynamicBadgeMode.hidden ||
        !checkDynamic) {
      return;
    }
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastCheckDynamicAt >= dynamicPeriod * 60 * 1000) {
      _lastCheckDynamicAt = now;
      getUnreadDynamic();
    }
  }

  void setNavBarConfig() {
    List<int>? navBarSort =
        (GStorage.setting.get(SettingBoxKey.navBarSort) as List?)?.cast();
    int defaultHomePage = Pref.defaultHomePage;
    late final List<NavigationBarType> navigationBars;
    if (navBarSort == null) {
      navigationBars = NavigationBarType.values;
    } else {
      navigationBars =
          navBarSort.map((i) => NavigationBarType.values[i]).toList();
    }
    this.navigationBars = navigationBars;
    selectedIndex.value =
        max(0, navigationBars.indexWhere((e) => e.index == defaultHomePage));
  }

  @override
  void onClose() {
    bottomBarStream?.close();
    controller.dispose();
    super.onClose();
  }
}
