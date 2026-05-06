import 'dart:io';

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/floating_navigation_bar.dart';
import 'package:PiliPlus/common/widgets/flutter/pop_scope.dart';
import 'package:PiliPlus/common/widgets/route_aware_mixin.dart';
import 'package:PiliPlus/common/widgets/scaffold.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/pages/home/view.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/mobile_observer.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends PopScopeState<MainApp>
    with
        RouteAware,
        RouteAwareMixin,
        WidgetsBindingObserver,
        WindowListener,
        TrayListener {
  final _mainController = Get.put(MainController());
  late final _setting = GStorage.setting;
  late EdgeInsets _padding;
  late ThemeData theme;

  @override
  bool get initCanPop => false;

  @override
  void initState() {
    super.initState();
    addObserverMobile(this);
    if (PlatformUtils.isDesktop) {
      windowManager
        ..addListener(this)
        ..setPreventClose(true);
      trayManager.addListener(this);
      _handleTray();
    } else {
      // FlutterSmartDialog throws
      PiliScheme.init();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _padding = MediaQuery.viewPaddingOf(context);
    theme = Theme.of(context);
    if (PlatformUtils.isDesktop) {
      windowManager.setBrightness(theme.brightness);
    }
    _mainController.useBottomNav = MediaQuery.sizeOf(context).isPortrait;
  }

  @override
  void didPopNext() {
    addObserverMobile(this);
    _mainController
      ..checkUnreadDynamic()
      ..checkUnread();
    super.didPopNext();
  }

  @override
  void didPushNext() {
    removeObserverMobile(this);
    super.didPushNext();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == .resumed) {
      _mainController
        ..checkUnreadDynamic()
        ..checkUnread();
    }
  }

  @override
  void dispose() {
    if (PlatformUtils.isDesktop) {
      trayManager.removeListener(this);
      windowManager.removeListener(this);
    }
    removeObserverMobile(this);
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
    if (PlPlayerController.instance?.isDesktopPip ?? false) {
      return;
    }
    final Offset offset = await windowManager.getPosition();
    _setting.put(SettingBoxKey.windowPosition, [offset.dx, offset.dy]);
  }

  @override
  Future<void> onWindowResized() async {
    if (PlPlayerController.instance?.isDesktopPip ?? false) {
      return;
    }
    final Rect bounds = await windowManager.getBounds();
    _setting.putAll({
      SettingBoxKey.windowSize: [bounds.width, bounds.height],
      SettingBoxKey.windowPosition: [bounds.left, bounds.top],
    });
  }

  @override
  void onWindowClose() {
    windowManager.hide();
  }

  Future<void> _onClose() async {
    await GStorage.compact();
    await GStorage.close();
    await trayManager.destroy();
    if (Platform.isWindows) {
      const MethodChannel('window_control').invokeMethod('closeWindow');
    } else {
      exit(0);
    }
  }

  @override
  Future<void> onTrayIconMouseDown() async {
    if (await windowManager.isVisible()) {
      windowManager.hide();
    } else {
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
      await trayManager.setIcon(Assets.logoIco);
    } else {
      await trayManager.setIcon(Assets.logoLarge);
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

  static void _onBack() {
    if (Platform.isAndroid) {
      Utils.channel.invokeMethod('back');
    }
  }

  @override
  void onPopInvokedWithResult(bool didPop, Object? result) {
    if (_mainController.selectedIndex.value != 0) {
      _mainController.setIndex(0);
    } else {
      _onBack();
    }
  }

  Widget? get _bottomNav {
    if (_mainController.floatingNavBar) {
      return Obx(
        () => FloatingNavigationBar(
          onDestinationSelected: _mainController.setIndex,
          selectedIndex: _mainController.selectedIndex.value,
          destinations: NavigationBarType.values
              .map(
                (e) => FloatingNavigationDestination(
                  label: e.label,
                  icon: _buildIcon(type: e),
                  selectedIcon: _buildIcon(type: e, selected: true),
                ),
              )
              .toList(),
        ),
      );
    }
    return Obx(
      () => NavigationBar(
        maintainBottomViewPadding: true,
        onDestinationSelected: _mainController.setIndex,
        selectedIndex: _mainController.selectedIndex.value,
        destinations: NavigationBarType.values
            .map(
              (e) => NavigationDestination(
                label: e.label,
                icon: _buildIcon(type: e),
                selectedIcon: _buildIcon(type: e, selected: true),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _sideBar(ThemeData theme) {
    return context.isTablet
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
                      tilePadding: const .symmetric(
                        vertical: 5,
                        horizontal: 12,
                      ),
                      indicatorShape: const RoundedRectangleBorder(
                        borderRadius: .all(.circular(16)),
                      ),
                      onDestinationSelected: _mainController.setIndex,
                      selectedIndex: _mainController.selectedIndex.value,
                      children: NavigationBarType.values
                          .map(
                            (e) => NavigationDrawerDestination(
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
              selectedIndex: _mainController.selectedIndex.value,
              onDestinationSelected: _mainController.setIndex,
              labelType: .selected,
              leading: userAndSearchVertical(theme),
              destinations: NavigationBarType.values
                  .map(
                    (e) => NavigationRailDestination(
                      label: Text(e.label),
                      icon: _buildIcon(type: e),
                      selectedIcon: _buildIcon(type: e, selected: true),
                    ),
                  )
                  .toList(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _mainController.controller,
      children: NavigationBarType.values.map((i) => i.page).toList(),
    );

    Widget? bottomNav;
    if (_mainController.useBottomNav) {
      bottomNav = _bottomNav;
      child = Row(children: [Expanded(child: child)]);
    } else {
      child = Row(
        children: [
          _sideBar(theme),
          VerticalDivider(
            width: 1,
            endIndent: _padding.bottom,
            color: theme.colorScheme.outline.withValues(alpha: 0.06),
          ),
          Expanded(child: child),
        ],
      );
    }

    child = Padding(
      padding: .only(
        left: _mainController.useBottomNav ? _padding.left : 0.0,
        right: _padding.right,
      ),
      child: child,
    );

    child = scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: _mainController.floatingNavBar
          ? Stack(
              clipBehavior: .none,
              children: [
                child,
                if (bottomNav != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: bottomNav,
                  ),
              ],
            )
          : Column(
              children: [
                Expanded(child: child),
                ?bottomNav,
              ],
            ),
    );

    if (PlatformUtils.isMobile) {
      child = AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: theme.brightness.reverse,
        ),
        child: child,
      );
    }

    return child;
  }

  Widget _buildIcon({required NavigationBarType type, bool selected = false}) {
    final icon = selected ? type.selectIcon : type.icon;
    return type == .dynamics
        ? Obx(
            () {
              final dynCount = _mainController.dynCount.value;
              return Badge(
                isLabelVisible: dynCount > 0,
                label: _mainController.dynamicBadgeMode == .number
                    ? Text(dynCount.toString())
                    : null,
                padding: const .symmetric(horizontal: 6),
                child: icon,
              );
            },
          )
        : icon;
  }

  Widget userAndSearchVertical(ThemeData theme) {
    return Column(
      children: [
        userAvatar(theme: theme, mainController: _mainController),
        const SizedBox(height: 8),
        msgBadge(_mainController),
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
