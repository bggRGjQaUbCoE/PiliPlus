import 'dart:async';

import 'package:PiliPlus/grpc/grpc_repo.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/common.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/pages/dynamics/view.dart';
import 'package:PiliPlus/pages/home/view.dart';
import 'package:PiliPlus/pages/media/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/utils/storage.dart';
import '../../models/common/dynamic_badge_mode.dart';
import '../../models/common/nav_bar_config.dart';

class MainController extends GetxController {
  List<Widget> pages = <Widget>[];
  RxList navigationBars = [].obs;

  final StreamController<bool> bottomBarStream =
      StreamController<bool>.broadcast();
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
  late List<MsgUnReadType> msgUnReadTypes = GStorage.msgUnReadTypeV2;
  late final RxString msgUnReadCount = ''.obs;
  late int lastCheckUnreadAt = 0;

  late final mainTabBarView = GStorage.mainTabBarView;

  @override
  void onInit() {
    super.onInit();
    if (GStorage.autoUpdate) {
      Utils.checkUpdate();
    }
    hideTabBar =
        GStorage.setting.get(SettingBoxKey.hideTabBar, defaultValue: true);
    isLogin.value = Accounts.main.isLogin;
    dynamicBadgeMode = DynamicBadgeMode.values[GStorage.setting.get(
        SettingBoxKey.dynamicBadgeMode,
        defaultValue: DynamicBadgeMode.number.index)];

    setNavBarConfig();

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

  Future queryUnreadMsg() async {
    if (isLogin.value.not || homeIndex == -1 || msgUnReadTypes.isEmpty) {
      msgUnReadCount.value = '';
      return;
    }
    try {
      bool shouldCheckPM = msgUnReadTypes.contains(MsgUnReadType.pm);
      bool shouldCheckFeed =
          ([...msgUnReadTypes]..remove(MsgUnReadType.pm)).isNotEmpty;
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
        if (msgUnReadTypes.contains(MsgUnReadType.reply)) {
          count += (res[index]['data']['reply'] as int?) ?? 0;
        }
        if (msgUnReadTypes.contains(MsgUnReadType.at)) {
          count += (res[index]['data']['at'] as int?) ?? 0;
        }
        if (msgUnReadTypes.contains(MsgUnReadType.like)) {
          count += (res[index]['data']['like'] as int?) ?? 0;
        }
        if (msgUnReadTypes.contains(MsgUnReadType.sysMsg)) {
          count += (res[index]['data']['sys_msg'] as int?) ?? 0;
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

  void getUnreadDynamic() async {
    if (!isLogin.value || dynIndex == -1) {
      return;
    }
    if (GlobalData().grpcReply) {
      await GrpcRepo.dynRed().then((res) {
        if (res['status']) {
          setCount(res['data']);
        }
      });
    } else {
      await CommonHttp.unReadDynamic().then((res) {
        if (res['status']) {
          setCount(res['data']);
        }
      });
    }
  }

  void setCount([int count = 0]) async {
    if (dynIndex == -1 || navigationBars[dynIndex]['count'] == count) return;
    navigationBars[dynIndex]['count'] = count; // 修改 count 属性为新的值
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

  void setNavBarConfig() async {
    List defaultNavTabs = [...defaultNavigationBars];
    List navBarSort =
        GStorage.setting.get(SettingBoxKey.navBarSort, defaultValue: [0, 1, 2]);
    defaultNavTabs.retainWhere((item) => navBarSort.contains(item['id']));
    defaultNavTabs.sort((a, b) =>
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
}
