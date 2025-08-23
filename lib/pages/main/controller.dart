import 'dart:async';
import 'dart:math' show max;

import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/grpc/dyn.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models_new/msgfeed_unread/data.dart';
import 'package:PiliPlus/models_new/single_unread/data.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/mine/view.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/update.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AccountService accountService = Get.find<AccountService>();

  List<NavigationBarType> navigationBars = <NavigationBarType>[];

  StreamController<bool>? bottomBarStream;
  late bool hideTabBar = Pref.hideTabBar;
  late dynamic controller;
  RxInt selectedIndex = 0.obs;

  RxInt dynCount = 0.obs;
  late DynamicBadgeMode dynamicBadgeMode;
  late bool checkDynamic = Pref.checkDynamic;
  late int dynamicPeriod = Pref.dynamicPeriod * 60 * 1000;
  late int _lastCheckDynamicAt = 0;
  late bool hasDyn = false;
  late final DynamicsController dynamicController = Get.put(
    DynamicsController(),
  );

  late bool hasHome = false;
  late final HomeController homeController = Get.put(HomeController());

  late DynamicBadgeMode msgBadgeMode = Pref.msgBadgeMode;
  late Set<MsgUnReadType> msgUnReadTypes = Pref.msgUnReadTypeV2;
  late final RxString msgUnReadCount = ''.obs;
  late int lastCheckUnreadAt = 0;

  final enableMYBar = Pref.enableMYBar;
  final useSideBar = Pref.useSideBar;
  final mainTabBarView = Pref.mainTabBarView;
  late final optTabletNav = Pref.optTabletNav;

  late bool directExitOnBack = Pref.directExitOnBack;

  static const _period = 5 * 60 * 1000;
  late int _lastSelectTime = 0;

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

    hasDyn = navigationBars.contains(NavigationBarType.dynamics);
    if (dynamicBadgeMode != DynamicBadgeMode.hidden) {
      if (hasDyn) {
        if (checkDynamic) {
          _lastCheckDynamicAt = DateTime.now().millisecondsSinceEpoch;
        }
        getUnreadDynamic();
      }
    }

    hasHome = navigationBars.contains(NavigationBarType.home);
    if (msgBadgeMode != DynamicBadgeMode.hidden) {
      if (hasHome) {
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
        !hasHome ||
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

  void getUnreadDynamic() {
    if (!accountService.isLogin.value || !hasDyn) {
      return;
    }
    DynGrpc.dynRed().then((res) {
      if (res != null) {
        setDynCount(res);
      }
    });
  }

  void setDynCount([int count = 0]) {
    if (!hasDyn) return;
    dynCount.value = count;
  }

  void checkUnreadDynamic() {
    if (!hasDyn ||
        !accountService.isLogin.value ||
        dynamicBadgeMode == DynamicBadgeMode.hidden ||
        !checkDynamic) {
      return;
    }
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastCheckDynamicAt >= dynamicPeriod) {
      _lastCheckDynamicAt = now;
      getUnreadDynamic();
    }
  }

  void setNavBarConfig() {
    List<int>? navBarSort =
        (GStorage.setting.get(SettingBoxKey.navBarSort) as List?)?.fromCast();
    int defaultHomePage = Pref.defaultHomePage;
    late final List<NavigationBarType> navigationBars;
    if (navBarSort == null || navBarSort.isEmpty) {
      navigationBars = NavigationBarType.values;
    } else {
      navigationBars = navBarSort
          .map((i) => NavigationBarType.values[i])
          .toList();
    }
    this.navigationBars = navigationBars;
    selectedIndex.value = max(
      0,
      navigationBars.indexWhere((e) => e.index == defaultHomePage),
    );
  }

  void checkDefaultSearch([bool shouldCheck = false]) {
    if (hasHome && homeController.enableSearchWord) {
      if (shouldCheck &&
          navigationBars[selectedIndex.value] != NavigationBarType.home) {
        return;
      }
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - homeController.lateCheckSearchAt >= _period) {
        homeController
          ..lateCheckSearchAt = now
          ..querySearchDefault();
      }
    }
  }

  void checkUnread([bool shouldCheck = false]) {
    if (accountService.isLogin.value &&
        hasHome &&
        msgBadgeMode != DynamicBadgeMode.hidden) {
      if (shouldCheck &&
          navigationBars[selectedIndex.value] != NavigationBarType.home) {
        return;
      }
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastCheckUnreadAt >= _period) {
        lastCheckUnreadAt = now;
        queryUnreadMsg();
      }
    }
  }

  int? _mineIndex;
  void toMinePage() {
    _mineIndex ??= navigationBars.indexOf(NavigationBarType.mine);
    if (_mineIndex != -1) {
      setIndex(_mineIndex!);
    } else {
      Get.to(
        const Material(
          child: ViewSafeArea(
            top: true,
            child: MinePage(),
          ),
        ),
      );
    }
  }

  void setIndex(int value) {
    feedBack();

    final currentNav = navigationBars[value];
    if (value != selectedIndex.value) {
      selectedIndex.value = value;
      if (mainTabBarView) {
        controller.animateTo(value);
      } else {
        controller.jumpToPage(value);
      }
      if (currentNav == NavigationBarType.home) {
        checkDefaultSearch();
        checkUnread();
      } else if (currentNav == NavigationBarType.dynamics) {
        setDynCount();
      }
    } else {
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastSelectTime < 500) {
        EasyThrottle.throttle(
          'topOrRefresh',
          const Duration(milliseconds: 500),
          () {
            if (currentNav == NavigationBarType.home) {
              homeController.onRefresh();
            } else if (currentNav == NavigationBarType.dynamics) {
              dynamicController.onRefresh();
            }
          },
        );
      } else {
        if (currentNav == NavigationBarType.home) {
          homeController.toTopOrRefresh();
        } else if (currentNav == NavigationBarType.dynamics) {
          dynamicController.toTopOrRefresh();
        }
      }
      _lastSelectTime = now;
    }
  }

  void setSearchBar() {
    if (hasHome) {
      homeController.searchBarStream?.add(true);
    }
  }

  @override
  void onClose() {
    bottomBarStream?.close();
    controller.dispose();
    super.onClose();
  }
}
