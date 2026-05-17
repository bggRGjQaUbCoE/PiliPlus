import 'dart:io';

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/desktop/desktop_title_bar.dart';
import 'package:PiliPlus/common/widgets/desktop/tab_manager.dart';
import 'package:PiliPlus/common/widgets/desktop/tab_model.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/router/page_registry.dart';
import 'package:PiliPlus/utils/nav.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class DesktopShell extends StatefulWidget {
  const DesktopShell({super.key});

  @override
  State<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends State<DesktopShell>
    with WindowListener, TrayListener {
  late final TabManager _tabManager;
  late final MainController _mainController;
  late final _setting = GStorage.setting;

  @override
  void initState() {
    super.initState();
    _tabManager = Get.put(TabManager());
    _mainController = Get.put(MainController());
    Nav.bindTabManager(_tabManager);
    windowManager
      ..addListener(this)
      ..setPreventClose(true);
    if (_mainController.showTrayIcon) {
      trayManager.addListener(this);
      _handleTray();
    }
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    Nav.bindTabManager(null);
    super.dispose();
  }

  // --- Window events ---

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
    if (PlPlayerController.instance?.isDesktopPip ?? false) return;
    final offset = await windowManager.getPosition();
    _setting.put(SettingBoxKey.windowPosition, [offset.dx, offset.dy]);
  }

  @override
  Future<void> onWindowResized() async {
    if (PlPlayerController.instance?.isDesktopPip ?? false) return;
    final bounds = await windowManager.getBounds();
    _setting.putAll({
      SettingBoxKey.windowSize: [bounds.width, bounds.height],
      SettingBoxKey.windowPosition: [bounds.left, bounds.top],
    });
  }

  @override
  void onWindowClose() {
    if (_mainController.showTrayIcon && _mainController.minimizeOnExit) {
      windowManager.hide();
      _onHideWindow();
    } else {
      _onClose();
    }
  }

  @override
  void onWindowMinimize() => _onHideWindow();

  @override
  void onWindowRestore() => _onShowWindow();

  // --- Tray events ---

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

  // --- Helpers ---

  void _onHideWindow() {
    if (_mainController.pauseOnMinimize) {
      if (PlPlayerController.instance case final player?) {
        if (_mainController.isPlaying = player.playerStatus.isPlaying) {
          player.pause();
        }
      } else {
        _mainController.isPlaying = false;
      }
    }
  }

  void _onShowWindow() {
    if (_mainController.pauseOnMinimize && _mainController.isPlaying) {
      PlPlayerController.instance?.play();
    }
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

  Future<void> _handleTray() async {
    if (Platform.isWindows) {
      await trayManager.setIcon(Assets.logoIco);
    } else {
      await trayManager.setIcon(Assets.logoLarge);
    }
    if (!Platform.isLinux) {
      await trayManager.setToolTip(Constants.appName);
    }
    final trayMenu = Menu(
      items: [
        MenuItem(key: 'show', label: '显示窗口'),
        MenuItem.separator(),
        MenuItem(key: 'exit', label: '退出 ${Constants.appName}'),
      ],
    );
    await trayManager.setContextMenu(trayMenu);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    windowManager.setBrightness(Theme.of(context).brightness);
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CallbackShortcuts(
      bindings: _shortcuts,
      child: Focus(
        autofocus: true,
        child: ColoredBox(
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              DesktopTitleBar(tabManager: _tabManager),
              Expanded(child: _TabContent(tabManager: _tabManager)),
            ],
          ),
        ),
      ),
    );
  }

  Map<ShortcutActivator, VoidCallback> get _shortcuts => {
        const SingleActivator(LogicalKeyboardKey.keyT, control: true): () =>
            _tabManager.openTab('/home'),
        const SingleActivator(LogicalKeyboardKey.keyW, control: true): () =>
            _tabManager.closeCurrentTab(),
        const SingleActivator(LogicalKeyboardKey.tab, control: true): () =>
            _tabManager.nextTab(),
        const SingleActivator(LogicalKeyboardKey.tab,
            control: true, shift: true): () => _tabManager.previousTab(),
        for (int i = 1; i <= 9; i++)
          SingleActivator(
            LogicalKeyboardKey(48 + i),
            control: true,
          ): () => _tabManager.switchToN(i),
      };
}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.tabManager});

  final TabManager tabManager;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tabs = tabManager.tabs.toList();
      final active = tabManager.activeIndex.value;
      return IndexedStack(
        index: active,
        children: [
          for (int i = 0; i < tabs.length; i++)
            _TabNavigator(key: ValueKey(tabs[i].id), tab: tabs[i]),
        ],
      );
    });
  }
}

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({super.key, required this.tab});

  final TabModel tab;

  @override
  Widget build(BuildContext context) {
    final initialPage = PageRegistry.buildPage(tab.initialRoute);
    return Navigator(
      key: tab.navigatorKey,
      onGenerateRoute: PageRegistry.onGenerateRoute,
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [
          MaterialPageRoute(
            builder: (_) => initialPage ?? const SizedBox.shrink(),
            settings: RouteSettings(name: tab.initialRoute),
          ),
        ];
      },
    );
  }
}
