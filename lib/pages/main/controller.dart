import 'dart:async';

import 'package:PiliPlus/grpc/dyn.dart';
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxList<NavigationBarType> navigationBars = <NavigationBarType>[].obs;
  int dynCount = 0;

  StreamController<bool>? bottomBarStream;
  late bool hideTabBar;
  late dynamic controller;
  RxInt selectedIndex = 0.obs;
  RxBool isLogin = false.obs;

  late DynamicBadgeMode dynamicBadgeMode;
  late bool checkDynamic = GStorage.checkDynamic;
  late int dynamicPeriod = GStorage.dynamicPeriod;
  late int _lastCheckDynamicAt = 0;
  late int dynIndex = -1;

  late int homeIndex = -1;
  late DynamicBadgeMode msgBadgeMode = GStorage.msgBadgeMode;
  late Set<MsgUnReadType> msgUnReadTypes = GStorage.msgUnReadTypeV2;
  late final RxString msgUnReadCount = ''.obs;
  late int lastCheckUnreadAt = 0;

  late final mainTabBarView = GStorage.mainTabBarView;
  late bool navSearchStreamDebounce = GStorage.navSearchStreamDebounce;

  @override
  void onInit() {
    super.onInit();
    if (GStorage.autoUpdate) {
      Utils.checkUpdate();
    }

    setNavBarConfig();

    hideTabBar =
        GStorage.setting.get(SettingBoxKey.hideTabBar, defaultValue: true);
    if (navigationBars.length > 1 && hideTabBar) {
      bottomBarStream = StreamController<bool>.broadcast();
    }
    isLogin.value = Accounts.main.isLogin;
    dynamicBadgeMode = DynamicBadgeMode.values[GStorage.setting.get(
        SettingBoxKey.dynamicBadgeMode,
        defaultValue: DynamicBadgeMode.number.index)];

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

  Future<void> queryUnreadMsg() async {
    if (isLogin.value.not || homeIndex == -1 || msgUnReadTypes.isEmpty) {
      msgUnReadCount.value = '';
      return;
    }

    int count = 0;
    final res = await ImGrpc.getTotalUnread();
    if (res.isSuccess) {
      final data = res.data;
      if (msgUnReadTypes.length == MsgUnReadType.values.length) {
        count = data.hasTotalUnread() ? data.totalUnread : 0;
      } else {
        final msgUnread = data.msgFeedUnread.unread;
        for (final item in msgUnReadTypes) {
          switch (item) {
            case MsgUnReadType.pm:
              final pmUnread = data.sessionSingleUnread;
              count += (pmUnread.followUnread +
                      pmUnread.unfollowUnread +
                      pmUnread.dustbinUnread)
                  .toInt();
              break;
            case MsgUnReadType.reply:
              count += msgUnread['reply']?.toInt() ?? 0;
              break;
            case MsgUnReadType.at:
              count += msgUnread['at']?.toInt() ?? 0;
              break;
            case MsgUnReadType.like:
              count += msgUnread['like']?.toInt() ?? 0;
              break;
            case MsgUnReadType.sysMsg:
              count += msgUnread['sys_msg']?.toInt() ?? 0;
              break;
          }
        }
      }
    }

    final countStr = count == 0
        ? ''
        : count > 99
            ? '99+'
            : count.toString();
    if (msgUnReadCount.value == countStr) {
      msgUnReadCount.refresh();
    } else {
      msgUnReadCount.value = countStr;
    }
  }

  Future<void> getUnreadDynamic() async {
    if (!isLogin.value || dynIndex == -1) {
      return;
    }
    DynGrpc.dynRed().then((res) {
      if (res != null) {
        setCount(res);
      }
    });
  }

  Future<void> setCount([int count = 0]) async {
    if (dynIndex == -1 || dynCount == count) return;
    dynCount = count;
    navigationBars.refresh();
  }

  void checkUnreadDynamic() {
    if (dynIndex == -1 ||
        !isLogin.value ||
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
    int defaultHomePage = GStorage.defaultHomePage;
    late final List<NavigationBarType> navigationBars;
    if (navBarSort == null) {
      navigationBars = NavigationBarType.values;
    } else {
      navigationBars =
          navBarSort.map((i) => NavigationBarType.values[i]).toList();
      if (!navBarSort.contains(defaultHomePage)) defaultHomePage = 0;
    }
    this.navigationBars.value = navigationBars;
    selectedIndex.value = defaultHomePage;
  }

  @override
  void onClose() {
    bottomBarStream?.close();
    super.onClose();
  }
}
