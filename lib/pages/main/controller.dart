import 'dart:async';

import 'package:PiliPlus/grpc/dyn.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/pages/dynamics/view.dart';
import 'package:PiliPlus/pages/home/view.dart';
import 'package:PiliPlus/pages/media/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  List<Widget> pages = <Widget>[];
  RxList navigationBars = [].obs;

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

    dynIndex = navigationBars.indexWhere((e) => e['id'] == 1);
    if (dynamicBadgeMode != DynamicBadgeMode.hidden) {
      if (dynIndex != -1) {
        if (checkDynamic) {
          _lastCheckDynamicAt = DateTime.now().millisecondsSinceEpoch;
        }
        getUnreadDynamic();
      }
    }

    homeIndex = navigationBars.indexWhere((e) => e['id'] == 0);
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
    try {
      bool shouldCheckPM = msgUnReadTypes.contains(MsgUnReadType.pm);
      bool shouldCheckFeed =
          shouldCheckPM ? msgUnReadTypes.length > 1 : msgUnReadTypes.isNotEmpty;
      List res = await Future.wait([
        if (shouldCheckPM) _queryPMUnread(),
        if (shouldCheckFeed) _queryMsgFeedUnread(),
      ]);
      dynamic count = 0;
      if (shouldCheckPM && res.firstOrNull?['status'] == true) {
        count = (res.first['data'] as int?) ?? 0;
      }
      if ((shouldCheckPM.not && res.firstOrNull?['status'] == true) ||
          (shouldCheckPM && res.getOrNull(1)?['status'] == true)) {
        int index = shouldCheckPM.not ? 0 : 1;
        dynamic data = res[index]['data'];
        for (final item in msgUnReadTypes) {
          switch (item) {
            case MsgUnReadType.pm:
              break;
            case MsgUnReadType.reply:
              count += (data['reply'] as int?) ?? 0;
              break;
            case MsgUnReadType.at:
              count += (data['at'] as int?) ?? 0;
              break;
            case MsgUnReadType.like:
              count += (data['like'] as int?) ?? 0;
              break;
            case MsgUnReadType.sysMsg:
              count += (data['sys_msg'] as int?) ?? 0;
              break;
          }
        }
      }
      count = count == 0
          ? ''
          : count > 99
              ? '99+'
              : count.toString();
      if (msgUnReadCount.value == count) {
        msgUnReadCount.refresh();
      } else {
        msgUnReadCount.value = count;
      }
    } catch (e) {
      debugPrint('failed to get unread count: $e');
    }
  }

  Future _queryPMUnread() async {
    try {
      dynamic res = await Request().get(Api.msgUnread);
      if (res.data['code'] == 0) {
        return {
          'status': true,
          'data': ((res.data['data']?['unfollow_unread'] as int?) ?? 0) +
              ((res.data['data']?['follow_unread'] as int?) ?? 0),
        };
      } else {
        return {
          'status': false,
          'msg': res.data['message'],
        };
      }
    } catch (_) {}
  }

  Future _queryMsgFeedUnread() async {
    if (isLogin.value.not) {
      return;
    }
    try {
      dynamic res = await Request().get(Api.msgFeedUnread);
      if (res.data['code'] == 0) {
        return {
          'status': true,
          'data': res.data['data'],
        };
      } else {
        return {
          'status': false,
          'msg': res.data['message'],
        };
      }
    } catch (_) {}
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
    if (dynIndex == -1 || navigationBars[dynIndex]['count'] == count) return;
    navigationBars[dynIndex]['count'] = count;
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
    List defaultNavTabs = [...defaultNavigationBars];
    List navBarSort =
        GStorage.setting.get(SettingBoxKey.navBarSort, defaultValue: [0, 1, 2]);
    defaultNavTabs
      ..retainWhere((item) => navBarSort.contains(item['id']))
      ..sort((a, b) =>
          navBarSort.indexOf(a['id']).compareTo(navBarSort.indexOf(b['id'])));
    navigationBars.value = defaultNavTabs;
    int defaultHomePage = GStorage.setting
        .get(SettingBoxKey.defaultHomePage, defaultValue: 0) as int;
    int defaultIndex =
        navigationBars.indexWhere((item) => item['id'] == defaultHomePage);
    // 如果找不到匹配项，默认索引设置为0或其他合适的值
    selectedIndex.value = defaultIndex != -1 ? defaultIndex : 0;
    pages = navigationBars
        .map<Widget>((e) => switch (e['id']) {
              0 => const HomePage(),
              1 => const DynamicsPage(),
              2 => const MediaPage(),
              _ => throw UnimplementedError(),
            })
        .toList();
  }

  @override
  void onClose() {
    bottomBarStream?.close();
    super.onClose();
  }
}
