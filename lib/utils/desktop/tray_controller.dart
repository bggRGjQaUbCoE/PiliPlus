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
  int? _showMenuId;
  MenuItem? _showMenuItem;
  int? _exitMenuId;
  MenuItem? _exitMenuItem;

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

    _showMenuItem = .createWithLabelAndType('显示窗口', .normal);
    _showMenuId = _showMenuItem!.addListener(_showMenuListener);
    _exitMenuItem = .createWithLabelAndType('退出 ${Constants.appName}', .normal);
    _exitMenuId = _exitMenuItem!.addListener(_exitMenuListener);
    _trayMenu = Menu.create()!
      ..addItem(_showMenuItem)
      ..addSeparator()
      ..addItem(_exitMenuItem);

    trayIcon
      ..setContextMenu(_trayMenu)
      ..setVisible(true);
  }

  void _showMenuListener(MenuEvent event) {
    if (event is MenuItemClickedEvent) {
      WindowController.instance.show();
    }
  }

  void _exitMenuListener(MenuEvent event) {
    if (event is MenuItemClickedEvent) {
      WindowController.instance.onClose();
    }
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

    _showMenuItem
      ?..removeListener(_showMenuId!)
      ..dispose();
    _showMenuId = null;
    _showMenuItem = null;

    _exitMenuItem
      ?..removeListener(_exitMenuId!)
      ..dispose();
    _exitMenuId = null;
    _exitMenuItem = null;

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
