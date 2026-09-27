import 'package:flutter/widgets.dart';

/// 根 Navigator 的路由栈镜像。Flutter 不公开 NavigatorState 的历史列表，
/// 需要按位置操作栈内非顶层路由（如静默移除中间页）时从这里读取
class RouteStackObserver extends NavigatorObserver {
  final List<Route<dynamic>> _stack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      final index = _stack.indexOf(oldRoute);
      if (index >= 0) {
        if (newRoute != null) {
          _stack[index] = newRoute;
        } else {
          _stack.removeAt(index);
        }
        return;
      }
    }
    if (newRoute != null) {
      _stack.add(newRoute);
    }
  }

  /// [anchor] 正下方、连续满足 [test] 的路由，按自上而下顺序返回；
  /// 遇到第一个不满足的即停止。anchor 不在栈内时返回空
  List<Route<dynamic>> routesBelowWhile(
    Route<dynamic> anchor,
    bool Function(Route<dynamic> route) test,
  ) {
    final result = <Route<dynamic>>[];
    for (var i = _stack.indexOf(anchor) - 1; i >= 0; i--) {
      final route = _stack[i];
      if (!test(route)) {
        break;
      }
      result.add(route);
    }
    return result;
  }
}

final routeStackObserver = RouteStackObserver();
