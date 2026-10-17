import 'dart:io' show Platform;

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/utils/desktop/window_controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:tray_manager/tray_manager.dart' as tray_manager show Image;
import 'package:tray_manager/tray_manager.dart';

class TrayController {
  TrayController._();
  static TrayController get instance => _instance;
  static final TrayController _instance = TrayController._();

  TrayIcon? _trayIcon;
  tray_manager.Image? _icon;
  int? _trayListenerId;
  Menu? _trayMenu;
  final List<(MenuItem, int)> _trayMenuItems = <(MenuItem, int)>[];

  final bool showTrayIcon = Pref.showTrayIcon;

  void init() {
    if (!showTrayIcon) return;

    assert(_trayIcon == null);

    final trayIcon = TrayIcon.create();
    if (trayIcon == null) return;

    _trayIcon = trayIcon;
    _trayListenerId = trayIcon.addListener(_trayListener);
    _icon = ImageAsset.fromAsset(
      Platform.isWindows ? Assets.logoIco : Assets.logoLarge,
    );
    trayIcon
      ..icon = _icon
      ..setTooltip(Constants.appName);

    final trayMenu = Menu.create();
    if (trayMenu != null) {
      _trayMenu = trayMenu;
      _addTrayMenuItem(trayMenu, '显示窗口', WindowController.instance.show);
      trayMenu.addSeparator();
      _addTrayMenuItem(
        trayMenu,
        '退出 ${Constants.appName}',
        WindowController.instance.onClose,
      );
      trayIcon.setContextMenu(_trayMenu);
    }

    trayIcon.setVisible(true);

    // "KDE: Activate on a click, ContextMenu on a right click"。
    if (Platform.isLinux) {
      trayIcon.setContextMenuTrigger(.rightClicked);
    }
  }

  void _addTrayMenuItem(Menu menu, String label, void Function() onTap) {
    final item = MenuItem.createWithLabelAndType(label, .normal);
    if (item == null) return;
    final id = item.addListener((MenuEvent event) {
      if (event is MenuItemClickedEvent) {
        onTap();
      }
    });
    _trayMenuItems.add((item, id));
    menu.addItem(item);
  }

  Future<void> _trayListener(TrayIconEvent event) async {
    switch (event) {
      case TrayIconClickedEvent():
        WindowController.instance.toggleVisibility();
      case TrayIconRightClickedEvent():
        _trayIcon!.openContextMenu();
      case TrayIconDoubleClickedEvent():
    }
  }

  void dispose() {
    if (!showTrayIcon) return;

    for (final (item, id) in _trayMenuItems) {
      item
        ..removeListener(id)
        ..dispose();
    }
    _trayMenuItems.clear();

    _trayMenu?.dispose();
    _trayMenu = null;

    _icon?.dispose();
    _icon = null;

    _trayIcon
      ?..removeListener(_trayListenerId!)
      ..dispose();
    _trayIcon = null;
  }
}
