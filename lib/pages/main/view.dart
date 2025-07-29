import 'dart:io';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/tabs.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/pages/home/view.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();

  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

class _MainAppState extends State<MainApp>
    with RouteAware, WidgetsBindingObserver {
  final MainController _mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();
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
    _mainController
      ..checkUnreadDynamic()
      ..checkDefaultSearch(true)
      ..checkUnread(context.orientation == Orientation.portrait);
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
      _mainController
        ..checkUnreadDynamic()
        ..checkDefaultSearch(true)
        ..checkUnread(context.orientation == Orientation.portrait);
    }
  }

  @override
  void dispose() {
    MainApp.routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    GStorage.close();
    PiliScheme.listener?.cancel();
    super.dispose();
  }

  void onBack() {
    if (Platform.isAndroid) {
      Utils.channel.invokeMethod('back');
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isPortrait = context.orientation == Orientation.portrait;
    final useBottomNav = isPortrait && !_mainController.useSideBar;
    Widget? bottomNav = useBottomNav
        ? _mainController.navigationBars.length > 1
              ? _mainController.enableMYBar
                    ? Obx(
                        () => NavigationBar(
                          onDestinationSelected: _mainController.setIndex,
                          selectedIndex: _mainController.selectedIndex.value,
                          destinations: _mainController.navigationBars
                              .map(
                                (e) => NavigationDestination(
                                  label: e.label,
                                  icon: _buildIcon(type: e),
                                  selectedIcon: _buildIcon(
                                    type: e,
                                    selected: true,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : Obx(
                        () => BottomNavigationBar(
                          currentIndex: _mainController.selectedIndex.value,
                          onTap: _mainController.setIndex,
                          iconSize: 16,
                          selectedFontSize: 12,
                          unselectedFontSize: 12,
                          type: BottomNavigationBarType.fixed,
                          items: _mainController.navigationBars
                              .map(
                                (e) => BottomNavigationBarItem(
                                  label: e.label,
                                  icon: _buildIcon(type: e),
                                  activeIcon: _buildIcon(
                                    type: e,
                                    selected: true,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
              : const SizedBox.shrink()
        : null;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (_mainController.directExitOnBack) {
          onBack();
        } else {
          if (_mainController.selectedIndex.value != 0) {
            _mainController
              ..setIndex(0)
              ..bottomBarStream?.add(true)
              ..setSearchBar();
          } else {
            onBack();
          }
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: theme.brightness.reverse,
        ),
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(toolbarHeight: 0),
          body: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!useBottomNav) ...[
                  _mainController.navigationBars.length > 1
                      ? context.isTablet && _mainController.optTabletNav
                            ? Column(
                                children: [
                                  const SizedBox(height: 25),
                                  userAndSearchVertical(theme),
                                  const Spacer(flex: 2),
                                  Expanded(
                                    flex: 5,
                                    child: SizedBox(
                                      width: 130,
                                      child: Obx(
                                        () => NavigationDrawer(
                                          backgroundColor: Colors.transparent,
                                          tilePadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 12,
                                              ),
                                          indicatorShape:
                                              const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                              ),
                                          onDestinationSelected:
                                              _mainController.setIndex,
                                          selectedIndex: _mainController
                                              .selectedIndex
                                              .value,
                                          children: _mainController
                                              .navigationBars
                                              .map(
                                                (e) =>
                                                    NavigationDrawerDestination(
                                                      label: Text(e.label),
                                                      icon: _buildIcon(type: e),
                                                      selectedIcon: _buildIcon(
                                                        type: e,
                                                        selected: true,
                                                      ),
                                                    ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Obx(
                                () => NavigationRail(
                                  groupAlignment: 0.5,
                                  selectedIndex:
                                      _mainController.selectedIndex.value,
                                  onDestinationSelected:
                                      _mainController.setIndex,
                                  labelType: NavigationRailLabelType.selected,
                                  leading: userAndSearchVertical(theme),
                                  destinations: _mainController.navigationBars
                                      .map(
                                        (e) => NavigationRailDestination(
                                          label: Text(e.label),
                                          icon: _buildIcon(type: e),
                                          selectedIcon: _buildIcon(
                                            type: e,
                                            selected: true,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                      : Container(
                          padding: const EdgeInsets.only(top: 10),
                          width: 80,
                          child: userAndSearchVertical(theme),
                        ),
                  VerticalDivider(
                    width: 1,
                    endIndent: MediaQuery.paddingOf(context).bottom,
                    color: theme.colorScheme.outline.withValues(alpha: 0.06),
                  ),
                ],
                Expanded(
                  child: _mainController.mainTabBarView
                      ? CustomTabBarView(
                          scrollDirection: isPortrait
                              ? Axis.horizontal
                              : Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _mainController.controller,
                          children: _mainController.navigationBars
                              .map((i) => i.page)
                              .toList(),
                        )
                      : PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _mainController.controller,
                          children: _mainController.navigationBars
                              .map((i) => i.page)
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: useBottomNav
              ? _mainController.hideTabBar
                    ? StreamBuilder(
                        stream: _mainController.bottomBarStream?.stream
                            .distinct(),
                        initialData: true,
                        builder: (context, AsyncSnapshot snapshot) {
                          return AnimatedSlide(
                            curve: Curves.easeInOutCubicEmphasized,
                            duration: const Duration(milliseconds: 500),
                            offset: Offset(0, snapshot.data ? 0 : 1),
                            child: bottomNav,
                          );
                        },
                      )
                    : bottomNav
              : null,
        ),
      ),
    );
  }

  Widget _buildIcon({
    required NavigationBarType type,
    bool selected = false,
  }) {
    final icon = selected ? type.selectIcon : type.icon;
    return type == NavigationBarType.dynamics
        ? Obx(
            () {
              final dynCount = _mainController.dynCount.value;
              return Badge(
                isLabelVisible: dynCount > 0,
                label:
                    _mainController.dynamicBadgeMode == DynamicBadgeMode.number
                    ? Text(dynCount.toString())
                    : null,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: icon,
              );
            },
          )
        : icon;
  }

  Widget userAndSearchVertical(ThemeData theme) {
    return Column(
      children: [
        Semantics(
          label: "我的",
          child: Obx(
            () => _mainController.accountService.isLogin.value
                ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      NetworkImgLayer(
                        type: ImageType.avatar,
                        width: 34,
                        height: 34,
                        src: _mainController.accountService.face.value,
                      ),
                      Positioned.fill(
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: _mainController.toMinePage,
                            splashColor: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                            customBorder: const CircleBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -6,
                        bottom: -6,
                        child: Obx(
                          () => MineController.anonymity.value
                              ? IgnorePointer(
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color:
                                          theme.colorScheme.secondaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      size: 16,
                                      MdiIcons.incognito,
                                      color: theme
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  )
                : defaultUser(
                    theme: theme,
                    onPressed: _mainController.toMinePage,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => _mainController.accountService.isLogin.value
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
