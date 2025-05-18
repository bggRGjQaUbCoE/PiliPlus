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
  late List<HomeTabType> tabs;
  late TabController tabController;

  RxBool isLogin = false.obs;
  RxString userFace = ''.obs;

  StreamController<bool>? searchBarStream;
  late bool hideSearchBar;
  late bool useSideBar;

  late bool enableSearchWord;
  late RxString defaultSearch = ''.obs;
  late int lateCheckSearchAt = 0;

  ScrollOrRefreshMixin get controller => tabs[tabController.index].ctr();

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
    List<int>? localTabs = GStorage.setting.get(SettingBoxKey.tabBarSort);
    tabs = localTabs?.map((i) => HomeTabType.values[i]).toList() ??
        HomeTabType.values;

    tabController = TabController(
      initialIndex: max(0, tabs.indexOf(HomeTabType.rcmd)),
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
