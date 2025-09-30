import 'dart:io';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/tabs.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/pages/home/view.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp>
    with RouteAware, WidgetsBindingObserver, WindowListener, TrayListener {
  final MainController _mainController = Get.put(MainController());
  late final _setting = GStorage.setting;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Utils.isDesktop) {
      windowManager
        ..addListener(this)
        ..setPreventClose(true);
      trayManager.addListener(this);
      _handleTray();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.brightnessOf(context);
    NetworkImgLayer.reduce =
        NetworkImgLayer.reduceLuxColor != null && brightness.isDark;
    if (Utils.isDesktop) {
      windowManager.setBrightness(brightness);
    }
    PageUtils.routeObserver.subscribe(
      this,
      ModalRoute.of(context) as PageRoute,
    );
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addObserver(this);
    _mainController
      ..checkUnreadDynamic()
      ..checkDefaultSearch(true)
      ..checkUnread(useBottomNav);
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
        ..checkUnread(useBottomNav);
    }
  }

  @override
  void dispose() {
    if (Utils.isDesktop) {
      trayManager.removeListener(this);
      windowManager.removeListener(this);
    }
    PageUtils.routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    PiliScheme.listener?.cancel();
    GStorage.close();
    super.dispose();
  }

  @override
  void onWindowMaximize() {
    _setting.put(SettingBoxKey.isWindowMaximized, true);
  }

  @override
  void onWindowUnmaximize() {
    _setting.put(SettingBoxKey.isWindowMaximized, false);
  }

  @override
  Future<void> onWindowMoved() async {
    final Offset offset = await windowManager.getPosition();
    _setting.put(SettingBoxKey.windowPosition, [offset.dx, offset.dy]);
  }

  @override
  Future<void> onWindowResized() async {
    final Rect bounds = await windowManager.getBounds();
    _setting.putAll({
      SettingBoxKey.windowSize: [bounds.width, bounds.height],
      SettingBoxKey.windowPosition: [bounds.left, bounds.top],
    });
  }

  @override
  void onWindowClose() {
    if (_mainController.minimizeOnExit) {
      windowManager.hide();
      _onHideWindow();
    } else {
      _onClose();
    }
  }

  Future<void> _onClose() async {
    await GStorage.compact();
    await GStorage.close();
    if (Platform.isWindows) {
      const MethodChannel('window_control').invokeMethod('closeWindow');
    } else {
      exit(0);
    }
  }

  @override
  void onWindowMinimize() {
    _onHideWindow();
  }

  @override
  void onWindowRestore() {
    _onShowWindow();
  }

  void _onHideWindow() {
    if (_mainController.pauseOnMinimize) {
      _mainController.isPlaying =
          PlPlayerController.instance?.playerStatus.status.value ==
          PlayerStatus.playing;
      PlPlayerController.pauseIfExists();
    }
  }

  void _onShowWindow() {
    if (_mainController.pauseOnMinimize) {
      if (_mainController.isPlaying) {
        PlPlayerController.playIfExists();
      }
    }
  }

  @override
  Future<void> onTrayIconMouseDown() async {
    if (await windowManager.isVisible()) {
      _onHideWindow();
      windowManager.hide();
    } else {
      _onShowWindow();
      windowManager.show();
    }
  }

  @override
  Future<void> onTrayIconRightMouseDown() async {
    // ignore: deprecated_member_use
    trayManager.popUpContextMenu(bringAppToFront: true);
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show':
        windowManager.show();
      case 'exit':
        _onClose();
    }
  }

  Future<void> _handleTray() async {
    if (Platform.isWindows) {
      await trayManager.setIcon('assets/images/logo/app_icon.ico');
    } else {
      await trayManager.setIcon('assets/images/logo/logo_large.png');
    }
    if (!Platform.isLinux) {
      await trayManager.setToolTip(Constants.appName);
    }

    Menu trayMenu = Menu(
      items: [
        MenuItem(key: 'show', label: '显示窗口'),
        MenuItem.separator(),
        MenuItem(key: 'exit', label: '退出 ${Constants.appName}'),
      ],
    );
    await trayManager.setContextMenu(trayMenu);
  }

  void onBack() {
    if (Platform.isAndroid) {
      Utils.channel.invokeMethod('back');
    } else {
      SystemNavigator.pop();
    }
  }

  late bool useBottomNav;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.viewPaddingOf(context);
    useBottomNav =
        !_mainController.useSideBar && MediaQuery.sizeOf(context).isPortrait;
    Widget? bottomNav = useBottomNav
        ? _mainController.navigationBars.length > 1
              ? _mainController.enableMYBar
                    ? Obx(
                        () => NavigationBar(
                          maintainBottomViewPadding: true,
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
          resizeToAvoidBottomInset: false,
          appBar: AppBar(toolbarHeight: 0),
          body: Padding(
            padding: EdgeInsets.only(
              left: useBottomNav ? padding.left : 0.0,
              right: padding.right,
            ),
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
                                                      icon: _buildIcon(
                                                        type: e,
                                                      ),
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
                    endIndent: padding.bottom,
                    color: theme.colorScheme.outline.withValues(alpha: 0.06),
                  ),
                ],
                Expanded(
                  child: _mainController.mainTabBarView
                      ? CustomTabBarView(
                          scrollDirection: useBottomNav
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
