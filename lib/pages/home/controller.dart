import 'dart:async';
import 'dart:math';

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/mine/view.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin, ScrollOrRefreshMixin {
  late List tabs;
  late List tabsCtrList;
  late TabController tabController;

  RxBool isLogin = false.obs;
  RxString userFace = ''.obs;

  StreamController<bool>? searchBarStream;
  late bool hideSearchBar;
  late bool useSideBar;

  late bool enableSearchWord;
  late RxString defaultSearch = ''.obs;
  late int lateCheckSearchAt = 0;

  ScrollOrRefreshMixin get controller {
    final index = tabController.index;
    return tabsCtrList[index]!(
        tag: switch (tabs[index]['type']) {
      HomeTabType.bangumi => HomeTabType.bangumi.name,
      HomeTabType.cinema => HomeTabType.cinema.name,
      _ => null,
    });
  }

  @override
  ScrollController get scrollController => controller.scrollController;

  @override
  void onInit() {
    super.onInit();
    final userInfo = GStorage.userInfo.get('userInfoCache');
    isLogin.value = userInfo != null;
    userFace.value = userInfo != null ? userInfo.face! : '';

    hideSearchBar =
        GStorage.setting.get(SettingBoxKey.hideSearchBar, defaultValue: true);
    if (hideSearchBar) {
      searchBarStream = StreamController<bool>.broadcast();
    }

    enableSearchWord = GStorage.setting
        .get(SettingBoxKey.enableSearchWord, defaultValue: true);
    if (enableSearchWord) {
      lateCheckSearchAt = DateTime.now().millisecondsSinceEpoch;
      querySearchDefault();
    }

    useSideBar =
        GStorage.setting.get(SettingBoxKey.useSideBar, defaultValue: false);

    setTabConfig();
  }

  @override
  Future<void> onRefresh() {
    return controller.onRefresh().catchError((e) => debugPrint(e.toString()));
  }

  void setTabConfig() {
    final defaultTabs = [...homeTabsConfig];
    final tabbarSort = GStorage.tabbarSort;
    defaultTabs
      ..retainWhere(
          (item) => tabbarSort.contains((item['type'] as HomeTabType).name))
      ..sort((a, b) => tabbarSort
          .indexOf((a['type'] as HomeTabType).name)
          .compareTo(tabbarSort.indexOf((b['type'] as HomeTabType).name)));

    tabs = defaultTabs;

    tabsCtrList = tabs.map((e) => e['ctr']).toList();

    tabController = TabController(
      initialIndex: max(0, tabbarSort.indexOf(HomeTabType.rcmd.name)),
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> querySearchDefault() async {
    try {
      var res = await Request().get(Api.searchDefault);
      if (res.data['code'] == 0) {
        defaultSearch.value = res.data['data']['name'];
      }
    } catch (_) {}
  }

  void showUserInfoDialog(context) {
    feedBack();
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => const Dialog(
        child: MinePage(),
      ),
    );
  }

  @override
  void onClose() {
    searchBarStream?.close();
    super.onClose();
  }
}
