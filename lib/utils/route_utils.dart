import 'package:flutter/widgets.dart';

/// Completes [route] without accidentally popping a newer route above it.
void completeRoute<T extends Object?>(
  NavigatorState navigator,
  Route<T>? route, [
  T? result,
]) {
  if (route == null || !route.isActive) {
    return;
  }
  if (route.isCurrent) {
    navigator.pop<T>(result);
  } else {
    navigator.removeRoute<T>(route, result);
  }
}
