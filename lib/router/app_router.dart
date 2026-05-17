import 'package:PiliPlus/common/widgets/desktop/desktop_shell.dart';
import 'package:PiliPlus/common/widgets/route_aware_mixin.dart';
import 'package:PiliPlus/pages/main/view.dart';
import 'package:PiliPlus/router/app_routes.dart';
import 'package:PiliPlus/router/page_registry.dart';
import 'package:PiliPlus/utils/nav.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart' show Transition;

Page<T> buildTransitionPage<T>(GoRouterState state, Widget child) {
  final transition = Pref.pageTransition;
  switch (transition) {
    case Transition.fade:
      return CustomTransitionPage<T>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      );
    case Transition.rightToLeft:
      return CustomTransitionPage<T>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      );
    case Transition.leftToRight:
      return CustomTransitionPage<T>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      );
    case Transition.upToDown:
      return CustomTransitionPage<T>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      );
    case Transition.downToUp:
      return CustomTransitionPage<T>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      );
    case Transition.zoom:
      return CustomTransitionPage<T>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            ScaleTransition(scale: animation, child: child),
      );
    case Transition.noTransition:
      return NoTransitionPage<T>(key: state.pageKey, child: child);
    case Transition.cupertino:
      return CupertinoPage<T>(key: state.pageKey, child: child);
    case Transition.native || _:
      return MaterialPage<T>(key: state.pageKey, child: child);
  }
}

GoRouter createRouter() {
  final rootWidget =
      PlatformUtils.isDesktop ? const DesktopShell() : const MainApp();

  final routes = <GoRoute>[
    GoRoute(
      path: AppRoutes.root,
      pageBuilder: (context, state) =>
          buildTransitionPage(state, rootWidget),
    ),
    for (final entry in PageRegistry.pages.entries)
      if (entry.key != AppRoutes.root)
        GoRoute(
          path: entry.key,
          pageBuilder: (context, state) =>
              buildTransitionPage(state, entry.value()),
        ),
  ];

  final router = GoRouter(
    navigatorKey: Nav.navigatorKey,
    initialLocation: AppRoutes.root,
    observers: [
      routeObserver,
      FlutterSmartDialog.observer,
    ],
    routes: routes,
  );

  Nav.init(router);
  return router;
}
