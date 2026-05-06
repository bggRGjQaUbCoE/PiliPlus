import 'dart:async';

import 'package:PiliPlus/grpc/dyn.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController
    with GetSingleTickerProviderStateMixin, AccountMixin {
  @override
  final AccountService accountService = Get.find<AccountService>();

  bool useBottomNav = false;
  late PageController controller;
  final RxInt selectedIndex = 0.obs;

  final RxInt dynCount = 0.obs;
  late DynamicBadgeMode dynamicBadgeMode;
  late int _lastCheckDynamicAt = 0;
  late final dynamicController = Get.putOrFind(DynamicsController.new);

  late final homeController = Get.putOrFind(HomeController.new);

  late DynamicBadgeMode msgBadgeMode = Pref.msgBadgeMode;
  late Set<MsgUnReadType> msgUnReadTypes = Pref.msgUnReadTypeV2;
  late final RxString msgUnReadCount = ''.obs;
  late int lastCheckUnreadAt = 0;

  final floatingNavBar = Pref.floatingNavBar;

  static const _dynamicPeriod = 5 * 60 * 1000;
  late int _lastSelectTime = 0;

  @override
  void onInit() {
    super.onInit();

    controller = PageController(initialPage: selectedIndex.value);

    dynamicBadgeMode = Pref.dynamicBadgeMode;

    if (dynamicBadgeMode != .hidden) {
      _lastCheckDynamicAt = DateTime.now().millisecondsSinceEpoch;
      getUnreadDynamic();
    }

    if (msgBadgeMode != .hidden) {
      lastCheckUnreadAt = DateTime.now().millisecondsSinceEpoch;
      queryUnreadMsg();
    }
  }

  Future<int> _msgUnread() async {
    final res = await MsgHttp.msgUnread();
    if (res case Success(:final response)) {
      return response.followUnread +
          response.unfollowUnread +
          response.bizMsgFollowUnread +
          response.bizMsgUnfollowUnread +
          response.unfollowPushMsg +
          response.customUnread;
    }
    return 0;
  }

  Future<int> _msgFeedUnread() async {
    int count = 0;
    final res = await MsgHttp.msgFeedUnread();
    if (res case Success(:final response)) {
      for (final item in msgUnReadTypes) {
        switch (item) {
          case .pm:
            continue;
          case .reply:
            count += response.reply;
          case .at:
            count += response.at;
          case .like:
            count += response.like;
            break;
          case .sysMsg:
            count += response.sysMsg;
        }
      }
    }
    return count;
  }

  Future<void> queryUnreadMsg([bool isChangeType = false]) async {
    if (!accountService.isLogin.value ||
        msgUnReadTypes.isEmpty ||
        msgBadgeMode == .hidden) {
      msgUnReadCount.value = '';
      return;
    }

    final hasPm = msgUnReadTypes.contains(MsgUnReadType.pm);
    final res = await Future.wait([
      if (hasPm) _msgUnread(),
      if (!(hasPm && msgUnReadTypes.length == 1)) _msgFeedUnread(),
    ]);
    final count = res.sum;
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

  void getUnreadDynamic() {
    if (!accountService.isLogin.value) {
      return;
    }
    DynGrpc.dynRed().then((res) {
      if (res != null) {
        setDynCount(res);
      }
    });
  }

  void setDynCount([int count = 0]) {
    dynCount.value = count;
  }

  void checkUnreadDynamic() {
    if (!accountService.isLogin.value || dynamicBadgeMode == .hidden) {
      return;
    }
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastCheckDynamicAt >= _dynamicPeriod) {
      _lastCheckDynamicAt = now;
      getUnreadDynamic();
    }
  }

  void checkUnread() {
    if (accountService.isLogin.value && msgBadgeMode != .hidden) {
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastCheckUnreadAt >= _dynamicPeriod) {
        lastCheckUnreadAt = now;
        queryUnreadMsg();
      }
    }
  }

  void toMinePage() {
    setIndex(NavigationBarType.mine.index);
  }

  void setIndex(int value) {
    final currentNav = NavigationBarType.values[value];
    if (value != selectedIndex.value) {
      selectedIndex.value = value;
      controller.jumpToPage(value);
      if (currentNav == .home) {
        checkUnread();
      } else if (currentNav == .dynamics) {
        setDynCount();
      }
    } else {
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastSelectTime < 500) {
        if (currentNav == .home) {
          homeController.onRefresh();
        } else if (currentNav == .dynamics) {
          dynamicController.onRefresh();
        }
      } else {
        if (currentNav == .home) {
          homeController.animateToTop();
        } else if (currentNav == .dynamics) {
          dynamicController.animateToTop();
        }
      }
      _lastSelectTime = now;
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  @override
  void onChangeAccount(bool isLogin) {
    if (isLogin) {
      getUnreadDynamic();
    } else {
      setDynCount();
    }
  }
}
