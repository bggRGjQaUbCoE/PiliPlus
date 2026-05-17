import 'package:flutter/widgets.dart';

final routeObserver = RouteObserver<ModalRoute<dynamic>>();

mixin RouteAwareMixin<T extends StatefulWidget> on State<T>, RouteAware {
  ModalRoute<dynamic>? _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newRoute = ModalRoute.of(context);
    if (newRoute != null && newRoute != _route) {
      if (_route != null) {
        routeObserver.unsubscribe(this);
      }
      _route = newRoute;
      routeObserver.subscribe(this, newRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
