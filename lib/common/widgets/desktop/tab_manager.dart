import 'package:PiliPlus/common/widgets/desktop/tab_model.dart';
import 'package:PiliPlus/router/app_routes.dart';
import 'package:PiliPlus/router/page_registry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabManager extends GetxController {
  final tabs = <TabModel>[].obs;
  final activeIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabs.addAll([
      TabModel(
        id: 'pinned-home',
        initialRoute: AppRoutes.home,
        pinned: true,
        title: '首页',
        icon: Icons.home,
      ),
      TabModel(
        id: 'pinned-dynamics',
        initialRoute: AppRoutes.dynamics,
        pinned: true,
        title: '动态',
        icon: Icons.motion_photos_on,
      ),
      TabModel(
        id: 'pinned-mine',
        initialRoute: AppRoutes.mine,
        pinned: true,
        title: '我的',
        icon: Icons.person,
      ),
    ]);
  }

  TabModel get activeTab => tabs[activeIndex.value];

  NavigatorState? get activeNavigator =>
      activeTab.navigatorKey.currentState;

  void switchTo(int index) {
    if (index >= 0 && index < tabs.length) {
      activeIndex.value = index;
    }
  }

  void openTab(
    String route, {
    dynamic arguments,
    bool switchTo = true,
  }) {
    final tab = TabModel(
      id: '${route}_${DateTime.now().millisecondsSinceEpoch}',
      initialRoute: route,
      initialArguments: arguments,
      title: PageRegistry.titleForRoute(route),
    );
    tabs.add(tab);
    if (switchTo) {
      activeIndex.value = tabs.length - 1;
    }
  }

  void closeTab(int index) {
    if (index < 0 || index >= tabs.length) return;
    final tab = tabs[index];
    if (tab.pinned) return;

    tabs.removeAt(index);
    if (activeIndex.value >= tabs.length) {
      activeIndex.value = tabs.length - 1;
    } else if (activeIndex.value > index) {
      activeIndex.value--;
    } else if (activeIndex.value == index) {
      activeIndex.value = activeIndex.value.clamp(0, tabs.length - 1);
    }
  }

  void closeCurrentTab() {
    closeTab(activeIndex.value);
  }

  void nextTab() {
    if (tabs.isNotEmpty) {
      activeIndex.value = (activeIndex.value + 1) % tabs.length;
    }
  }

  void previousTab() {
    if (tabs.isNotEmpty) {
      activeIndex.value = (activeIndex.value - 1 + tabs.length) % tabs.length;
    }
  }

  void switchToN(int n) {
    if (n == 9) {
      switchTo(tabs.length - 1);
    } else if (n > 0 && n <= tabs.length) {
      switchTo(n - 1);
    }
  }
}
