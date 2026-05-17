import 'package:PiliPlus/common/widgets/desktop/tab_manager.dart';
import 'package:PiliPlus/router/page_registry.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class Nav {
  static late final GoRouter router;
  static final navigatorKey = GlobalKey<NavigatorState>();

  static dynamic _currentExtra;
  static Map<String, String> _currentParams = {};
  static String _previousRoute = '';
  static TabManager? _tabManager;

  static dynamic get arguments => _currentExtra;
  static Map<String, String> get parameters => _currentParams;
  static String get currentRoute =>
      router.routeInformationProvider.value.uri.path;
  static String get previousRoute => _previousRoute;

  static void init(GoRouter goRouter) {
    router = goRouter;
  }

  static void bindTabManager(TabManager? tm) {
    _tabManager = tm;
  }

  static void updateTabTitle(String title) {
    if (_isDesktopTabMode) {
      _tabManager!.activeTab.title.value = title;
    }
  }

  static void goHome({bool closeCurrentTab = false}) {
    if (_isDesktopTabMode) {
      final currentIndex = _tabManager!.activeIndex.value;
      if (closeCurrentTab && !_tabManager!.activeTab.pinned) {
        _tabManager!.switchTo(0);
        _tabManager!.closeTab(currentIndex);
      } else {
        _tabManager!.switchTo(0);
      }
      return;
    }
    router.go('/');
  }

  static bool get _isDesktopTabMode =>
      PlatformUtils.isDesktop && _tabManager != null;

  static Future<T?> push<T extends Object?>(
    String path, {
    dynamic extra,
    Map<String, String>? parameters,
  }) {
    _previousRoute = currentRoute;
    _currentExtra = extra;
    _currentParams = parameters ?? {};

    if (_isDesktopTabMode) {
      if (PageRegistry.newTabRoutes.contains(path)) {
        _tabManager!.openTab(path, arguments: extra);
        return Future<T?>.value(null);
      }
      final nav = _tabManager!.activeNavigator;
      if (nav != null) {
        final builder = PageRegistry.pages[path];
        if (builder != null) {
          return nav.push<T>(MaterialPageRoute(
            builder: (_) => builder(),
            settings: RouteSettings(name: path),
          ));
        }
      }
      return Future<T?>.value(null);
    }

    final uri = parameters != null && parameters.isNotEmpty
        ? Uri(path: path, queryParameters: parameters).toString()
        : path;
    return router.push<T>(uri, extra: extra);
  }

  static void pushReplacement(
    String path, {
    dynamic extra,
    Map<String, String>? parameters,
  }) {
    _previousRoute = currentRoute;
    _currentExtra = extra;
    _currentParams = parameters ?? {};

    if (_isDesktopTabMode) {
      if (PageRegistry.newTabRoutes.contains(path)) {
        _tabManager!.openTab(path, arguments: extra);
        return;
      }
      final nav = _tabManager!.activeNavigator;
      if (nav != null) {
        final builder = PageRegistry.pages[path];
        if (builder != null) {
          nav.pushReplacement(MaterialPageRoute(
            builder: (_) => builder(),
            settings: RouteSettings(name: path),
          ));
        }
      }
      return;
    }

    final uri = parameters != null && parameters.isNotEmpty
        ? Uri(path: path, queryParameters: parameters).toString()
        : path;
    router.pushReplacement(uri, extra: extra);
  }

  static void back<T extends Object?>([T? result]) {
    if (_isDesktopTabMode) {
      final nav = _tabManager!.activeNavigator;
      if (nav != null && nav.canPop()) {
        nav.pop(result);
      }
      return;
    }
    final state = navigatorKey.currentState;
    if (state != null && state.canPop()) {
      state.pop(result);
    }
  }

  static bool canPop() {
    if (_isDesktopTabMode) {
      return _tabManager!.activeNavigator?.canPop() ?? false;
    }
    return navigatorKey.currentState?.canPop() ?? false;
  }

  static void popUntil(bool Function(Route<dynamic>) predicate) {
    if (_isDesktopTabMode) {
      _tabManager!.activeNavigator?.popUntil(predicate);
      return;
    }
    navigatorKey.currentState?.popUntil(predicate);
  }

  static Future<T?> pushRoute<T>(Route<T> route) {
    if (_isDesktopTabMode) {
      final nav = _tabManager!.activeNavigator;
      if (nav != null) {
        return nav.push<T>(route);
      }
      return Future<T?>.value(null);
    }
    return navigatorKey.currentState!.push<T>(route);
  }
}
