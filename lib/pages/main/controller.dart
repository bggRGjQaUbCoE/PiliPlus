import 'dart:async';

import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/grpc/dyn.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/mine/view.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/update.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class MainController extends GetxController
    with GetTickerProviderStateMixin, AccountMixin {
  @override
  final AccountService accountService = Get.find<AccountService>();

  List<NavigationBarType> navigationBars = <NavigationBarType>[];

  RxDouble? barOffset;
  RxBool? showBottomBar;
  late final bool hideBottomBar;
  late final barHideType = Pref.barHideType;
  bool useBottomNav = true;
  late dynamic controller;
  final RxInt selectedIndex = 0.obs;
  final navRevision = 0.obs;
  final bottomNavHeight = 0.0.obs;
  final bottomNavVisibility = ValueNotifier<double?>(null);
  final bottomBarSettling = false.obs;
  Future<bool> Function()? mallGoBack;

  bool get mallEnabled => Pref.enableMall;

  Future<void> onMallBack() async {
    if (await mallGoBack?.call() == true ||
        isClosed ||
        navigationBars[selectedIndex.value] != .mall) {
      return;
    }
    final home = navigationBars.indexOf(.home);
    setIndex(
      home < 0 ? navigationBars.indexWhere((page) => page != .mall) : home,
    );
    restoreBars();
  }

  void restoreBars() {
    bottomBarSettling.value = true;
    barOffset?.value = 0;
    showBottomBar?.value = true;
    setSearchBar();
  }

  final RxInt dynCount = 0.obs;
  late DynamicBadgeMode dynamicBadgeMode;
  late bool checkDynamic = Pref.checkDynamic;
  late int dynamicPeriod = Pref.dynamicPeriod * 60 * 1000;
  late int _lastCheckDynamicAt = 0;
  late bool hasDyn = false;
  late final dynamicController = Get.putOrFind(DynamicsController.new);

  late bool hasHome = false;
  late final homeController = Get.putOrFind(HomeController.new);

  late final disableLikeMsg = Pref.disableLikeMsg;
  late DynamicBadgeMode msgBadgeMode = Pref.msgBadgeMode;
  late Set<MsgUnReadType> msgUnReadTypes = Pref.msgUnReadTypeV2;
  late final RxnString msgUnReadCount = RxnString(null);
  late int lastCheckUnreadAt = 0;

  final enableMYBar = Pref.enableMYBar;
  late final floatingNavBar = Pref.floatingNavBar;
  final useSideBar = Pref.useSideBar;
  final hideSideBarLabel = Pref.hideSideBarLabel;
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

    controller = _createPageController();
    hideBottomBar = !useSideBar && Pref.hideBottomBar;
    if (hideBottomBar) {
      switch (barHideType) {
        case .instant:
          showBottomBar = RxBool(true);
        case .sync:
          barOffset ??= RxDouble(0.0);
      }
    }

    dynamicBadgeMode = Pref.dynamicBadgeMode;

    hasDyn = navigationBars.contains(NavigationBarType.dynamics);
    if (dynamicBadgeMode != DynamicBadgeMode.hidden) {
      if (hasDyn && navigationBars[selectedIndex.value] != .dynamics) {
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
      final res = await MsgHttp.msgUnread();
      if (res case Success(:final response)) {
        return response.followUnread +
            response.unfollowUnread +
            response.bizMsgFollowUnread +
            response.bizMsgUnfollowUnread +
            response.unfollowPushMsg +
            response.customUnread;
      }
    }
    return 0;
  }

  Future<int> _msgFeedUnread() async {
    int count = 0;
    final remainTypes = Set<MsgUnReadType>.from(msgUnReadTypes)
      ..remove(MsgUnReadType.pm);
    if (remainTypes.isNotEmpty) {
      final res = await MsgHttp.msgFeedUnread();
      if (res case Success(:final response)) {
        for (final item in remainTypes) {
          switch (item) {
            case MsgUnReadType.pm:
              break;
            case MsgUnReadType.reply:
              count += response.reply;
              break;
            case MsgUnReadType.at:
              count += response.at;
              break;
            case MsgUnReadType.like:
              if (!disableLikeMsg) count += response.like;
              break;
            case MsgUnReadType.sysMsg:
              count += response.sysMsg;
              break;
          }
        }
      }
    }
    return count;
  }

  void clearUnreadMsg() {
    msgUnReadCount.value = null;
  }

  Future<void> queryUnreadMsg([bool isChangeType = false]) async {
    if (!accountService.isLogin.value ||
        !hasHome ||
        msgUnReadTypes.isEmpty ||
        msgBadgeMode == DynamicBadgeMode.hidden) {
      clearUnreadMsg();
      return;
    }

    final res = await Future.wait([_msgUnread(), _msgFeedUnread()]);

    final count = res.sum;

    final countStr = count == 0
        ? null
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

  static List<NavigationBarType> resolveNavigation(
    Iterable<Object?>? saved, {
    required bool showMall,
  }) {
    final bars = {
      for (final index in (saved ?? const []).whereType<int>())
        if (index >= 0 && index < NavigationBarType.primary.length)
          NavigationBarType.primary[index],
    }.toList();
    if (bars.isEmpty) bars.addAll(NavigationBarType.primary);
    if (showMall) {
      final mine = bars.indexOf(.mine);
      bars.insert(mine < 0 ? bars.length : mine, .mall);
    }
    return bars;
  }

  void setNavBarConfig() {
    navigationBars = resolveNavigation(
      GStorage.setting.get(SettingBoxKey.navBarSort) as List?,
      showMall: mallEnabled,
    );
    final preferred = Pref.defaultHomePage;
    final target = navigationBars.indexOf(
      preferred == NavigationBarType.mall && !mallEnabled
          ? NavigationBarType.home
          : preferred,
    );
    selectedIndex.value = target < 0 ? 0 : target;
  }

  Object _createPageController() => mainTabBarView
      ? TabController(
          vsync: this,
          initialIndex: selectedIndex.value,
          length: navigationBars.length,
        )
      : PageController(initialPage: selectedIndex.value, keepPage: false);

  void refreshMallNavigation() {
    if (mallEnabled == navigationBars.contains(NavigationBarType.mall)) return;
    final previous = controller;
    final current = navigationBars[selectedIndex.value];
    final hasMall = mallEnabled;
    final bars = navigationBars.where((page) => page != .mall).toList();
    if (hasMall) {
      final mine = bars.indexOf(.mine);
      bars.insert(mine < 0 ? bars.length : mine, .mall);
    }
    final target = bars.indexOf(
      current == NavigationBarType.mall && !hasMall
          ? NavigationBarType.home
          : current,
    );
    navigationBars = bars;
    selectedIndex.value = target < 0 ? 0 : target;
    controller = _createPageController();
    FocusManager.instance.primaryFocus?.unfocus();
    restoreBars();
    navRevision.value++;
    WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
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

  void toMinePage() {
    final mineIndex = navigationBars.indexOf(NavigationBarType.mine);
    if (mineIndex != -1) {
      setIndex(mineIndex);
    } else {
      Get.to(
        const Material(
          child: ViewSafeArea(
            top: true,
            child: MinePage(showBackBtn: true),
          ),
        ),
      );
    }
  }

  void setIndex(int value) {
    feedBack();

    final currentNav = navigationBars[value];
    if (currentNav == .mall || value != selectedIndex.value) restoreBars();
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
          () => switch (currentNav) {
            .home => homeController.showRefresh(),
            .dynamics => dynamicController.showRefresh(),
            .mine || .mall => null,
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
      homeController.showTopBar?.value = true;
    }
  }

  bool refreshRecommendations() {
    if (navigationBars[selectedIndex.value] == NavigationBarType.home &&
        homeController.tabs[homeController.tabController.index] ==
            HomeTabType.rcmd) {
      homeController.showRefresh();
      return true;
    }
    return false;
  }

  @override
  void onClose() {
    bottomNavVisibility.dispose();
    barOffset?.close();
    controller.dispose();
    super.onClose();
  }

  @override
  void onChangeAccount(bool isLogin) {
    if (isLogin) {
      queryUnreadMsg();
      getUnreadDynamic();
    } else {
      setDynCount();
    }
  }
}
