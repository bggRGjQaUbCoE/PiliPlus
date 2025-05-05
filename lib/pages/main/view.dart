import 'dart:io';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/tabs.dart';
import 'package:PiliPlus/models/common/dynamic_badge_mode.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/dynamics/view.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/home/view.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/event_bus.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stream_transform/stream_transform.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();

  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

class _MainAppState extends State<MainApp>
    with SingleTickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  final MainController _mainController = Get.put(MainController());
  late final _homeController = Get.put(HomeController());
  late final _dynamicController = Get.put(DynamicsController());

  late int _lastSelectTime = 0;
  late bool enableMYBar;
  late bool useSideBar;

  @override
  void initState() {
    super.initState();
    _lastSelectTime = DateTime.now().millisecondsSinceEpoch;
    _mainController.controller = _mainController.mainTabBarView
        ? TabController(
            vsync: this,
            initialIndex: _mainController.selectedIndex.value,
            length: _mainController.navigationBars.length,
          )
        : PageController(initialPage: _mainController.selectedIndex.value);
    enableMYBar =
        GStorage.setting.get(SettingBoxKey.enableMYBar, defaultValue: true);
    useSideBar =
        GStorage.setting.get(SettingBoxKey.useSideBar, defaultValue: false);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MainApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addObserver(this);
    _mainController.checkUnreadDynamic();
    _checkDefaultSearch(true);
    _checkUnread(context.orientation == Orientation.portrait);
    super.didPopNext();
  }

  @override
  void didPushNext() {
    WidgetsBinding.instance.removeObserver(this);
    super.didPushNext();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _mainController.checkUnreadDynamic();
      _checkDefaultSearch(true);
      _checkUnread(context.orientation == Orientation.portrait);
    }
  }

  void _checkDefaultSearch([bool shouldCheck = false]) {
    if (_mainController.homeIndex != -1 && _homeController.enableSearchWord) {
      if (shouldCheck &&
          _mainController.pages[_mainController.selectedIndex.value]
              is! HomePage) {
        return;
      }
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - _homeController.lateCheckSearchAt >= 5 * 60 * 1000) {
        _homeController
          ..lateCheckSearchAt = now
          ..querySearchDefault();
      }
    }
  }

  void _checkUnread([bool shouldCheck = false]) {
    if (_mainController.isLogin.value &&
        _mainController.homeIndex != -1 &&
        _mainController.msgBadgeMode != DynamicBadgeMode.hidden) {
      if (shouldCheck &&
          _mainController.pages[_mainController.selectedIndex.value]
              is! HomePage) {
        return;
      }
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - _mainController.lastCheckUnreadAt >= 5 * 60 * 1000) {
        _mainController
          ..lastCheckUnreadAt = now
          ..queryUnreadMsg();
      }
    }
  }

  Future<void> setIndex(int value) async {
    feedBack();

    if (value != _mainController.selectedIndex.value) {
      _mainController.selectedIndex.value = value;
      if (_mainController.mainTabBarView) {
        _mainController.controller.animateTo(value);
      } else {
        _mainController.controller.jumpToPage(value);
      }
      dynamic currentPage = _mainController.pages[value];
      if (currentPage is HomePage) {
        _checkDefaultSearch();
        _checkUnread();
      } else if (currentPage is DynamicsPage) {
        _mainController.setCount();
      }
    } else {
      dynamic currentPage = _mainController.pages[value];

      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastSelectTime < 500) {
        EasyThrottle.throttle('topOrRefresh', const Duration(milliseconds: 500),
            () {
          if (currentPage is HomePage) {
            _homeController.onRefresh();
          } else if (currentPage is DynamicsPage) {
            _dynamicController.onRefresh();
          }
        });
      } else {
        if (currentPage is HomePage) {
          _homeController.toTopOrRefresh();
        } else if (currentPage is DynamicsPage) {
          _dynamicController.toTopOrRefresh();
        }
      }
      _lastSelectTime = now;
    }
  }

  @override
  void dispose() {
    MainApp.routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    GStorage.close();
    EventBus().off(EventName.loginEvent);
    PiliScheme.listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isPortrait = context.orientation == Orientation.portrait;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (_mainController.selectedIndex.value != 0) {
          setIndex(0);
          _mainController.bottomBarStream?.add(true);
          _homeController.searchBarStream?.add(true);
        } else {
          if (Platform.isAndroid) {
            Utils.channel.invokeMethod('back');
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: theme.brightness.reverse,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (useSideBar || !isPortrait) ...[
                Obx(
                  () => _mainController.navigationBars.length > 1
                      ? context.isTablet && GStorage.optTabletNav
                          ? Column(
                              children: [
                                SizedBox(
                                    height:
                                        MediaQuery.paddingOf(context).top + 50),
                                userAndSearchVertical(theme),
                                const Spacer(flex: 2),
                                Expanded(
                                  flex: 5,
                                  child: SizedBox(
                                    width: 130,
                                    child: MediaQuery.removePadding(
                                      context: context,
                                      removeRight: true,
                                      child: NavigationDrawer(
                                        backgroundColor: Colors.transparent,
                                        tilePadding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        indicatorShape:
                                            const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                        ),
                                        onDestinationSelected: setIndex,
                                        selectedIndex:
                                            _mainController.selectedIndex.value,
                                        children: [
                                          ..._mainController.navigationBars
                                              .map((e) {
                                            return NavigationDrawerDestination(
                                              label: Text(e['label']),
                                              icon: _buildIcon(
                                                id: e['id'],
                                                count: e['count'],
                                                icon: e['icon'],
                                              ),
                                              selectedIcon: _buildIcon(
                                                id: e['id'],
                                                count: e['count'],
                                                icon: e['selectIcon'],
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : NavigationRail(
                              groupAlignment: 0.5,
                              selectedIndex:
                                  _mainController.selectedIndex.value,
                              onDestinationSelected: setIndex,
                              labelType: NavigationRailLabelType.selected,
                              leading: userAndSearchVertical(theme),
                              destinations: _mainController.navigationBars
                                  .map(
                                    (e) => NavigationRailDestination(
                                      icon: _buildIcon(
                                        id: e['id'],
                                        count: e['count'],
                                        icon: e['icon'],
                                      ),
                                      selectedIcon: _buildIcon(
                                        id: e['id'],
                                        count: e['count'],
                                        icon: e['selectIcon'],
                                      ),
                                      label: Text(e['label']),
                                    ),
                                  )
                                  .toList(),
                            )
                      : SafeArea(
                          right: false,
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            width: 80,
                            child: userAndSearchVertical(theme),
                          ),
                        ),
                ),
                VerticalDivider(
                  width: 1,
                  indent: MediaQuery.of(context).padding.top,
                  endIndent: MediaQuery.of(context).padding.bottom,
                  color: theme.colorScheme.outline.withOpacity(0.06),
                ),
              ],
              Expanded(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  left: isPortrait,
                  child: _mainController.mainTabBarView
                      ? CustomTabBarView(
                          scrollDirection:
                              isPortrait ? Axis.horizontal : Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _mainController.controller,
                          children: _mainController.pages,
                        )
                      : PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _mainController.controller,
                          children: _mainController.pages,
                        ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: useSideBar || !isPortrait
              ? null
              : StreamBuilder(
                  stream: _mainController.hideTabBar
                      ? _mainController.navSearchStreamDebounce
                          ? _mainController.bottomBarStream?.stream
                              .distinct()
                              .throttle(const Duration(milliseconds: 500))
                          : _mainController.bottomBarStream?.stream.distinct()
                      : null,
                  initialData: true,
                  builder: (context, AsyncSnapshot snapshot) {
                    return AnimatedSlide(
                      curve: Curves.easeInOutCubicEmphasized,
                      duration: const Duration(milliseconds: 500),
                      offset: Offset(0, snapshot.data ? 0 : 1),
                      child: enableMYBar
                          ? Obx(
                              () => _mainController.navigationBars.length > 1
                                  ? NavigationBar(
                                      onDestinationSelected: setIndex,
                                      selectedIndex:
                                          _mainController.selectedIndex.value,
                                      destinations:
                                          _mainController.navigationBars.map(
                                        (e) {
                                          return NavigationDestination(
                                            icon: _buildIcon(
                                              id: e['id'],
                                              count: e['count'],
                                              icon: e['icon'],
                                            ),
                                            selectedIcon: _buildIcon(
                                              id: e['id'],
                                              count: e['count'],
                                              icon: e['selectIcon'],
                                            ),
                                            label: e['label'],
                                          );
                                        },
                                      ).toList(),
                                    )
                                  : const SizedBox.shrink(),
                            )
                          : Obx(
                              () => _mainController.navigationBars.length > 1
                                  ? BottomNavigationBar(
                                      currentIndex:
                                          _mainController.selectedIndex.value,
                                      onTap: setIndex,
                                      iconSize: 16,
                                      selectedFontSize: 12,
                                      unselectedFontSize: 12,
                                      type: BottomNavigationBarType.fixed,
                                      items: _mainController.navigationBars
                                          .map(
                                            (e) => BottomNavigationBarItem(
                                              icon: _buildIcon(
                                                id: e['id'],
                                                count: e['count'],
                                                icon: e['icon'],
                                              ),
                                              activeIcon: _buildIcon(
                                                id: e['id'],
                                                count: e['count'],
                                                icon: e['selectIcon'],
                                              ),
                                              label: e['label'],
                                            ),
                                          )
                                          .toList(),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildIcon({
    required int id,
    required int count,
    required Widget icon,
  }) =>
      id == 1 &&
              _mainController.dynamicBadgeMode != DynamicBadgeMode.hidden &&
              count > 0
          ? Badge(
              label: _mainController.dynamicBadgeMode == DynamicBadgeMode.number
                  ? Text(count.toString())
                  : null,
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: icon,
            )
          : icon;

  Widget userAndSearchVertical(ThemeData theme) {
    return Column(
      children: [
        Semantics(
          label: "我的",
          child: Obx(
            () => _homeController.isLogin.value
                ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      NetworkImgLayer(
                        type: 'avatar',
                        width: 34,
                        height: 34,
                        src: _homeController.userFace.value,
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () =>
                                _homeController.showUserInfoDialog(context),
                            splashColor: theme.colorScheme.primaryContainer
                                .withOpacity(0.3),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -6,
                        bottom: -6,
                        child: Obx(() => MineController.anonymity.value
                            ? IgnorePointer(
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    size: 16,
                                    MdiIcons.incognito,
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()),
                      ),
                    ],
                  )
                : defaultUser(
                    theme: theme,
                    onPressed: () =>
                        _homeController.showUserInfoDialog(context),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => _homeController.isLogin.value
              ? msgBadge(_mainController)
              : const SizedBox.shrink(),
        ),
        IconButton(
          tooltip: '搜索',
          icon: const Icon(
            Icons.search_outlined,
            semanticLabel: '搜索',
          ),
          onPressed: () => Get.toNamed('/search'),
        ),
      ],
    );
  }
}
