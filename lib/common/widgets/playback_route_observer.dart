import 'package:flutter/widgets.dart';

/// Resolves the page reached by a navigation before RouteAware callbacks run.
/// Playback-to-playback navigation replaces the main media; only leaving for
/// a non-playback page can hand that media to the in-app mini player.
class PlaybackRouteObserver<R extends Route<dynamic>> extends RouteObserver<R> {
  final List<Route<dynamic>> _routes = [];
  final Expando<_PopDestination> _popDestinations = Expando();
  int _revision = 0;

  /// Async playback completion must yield to a newer user navigation.
  int get navigationRevision => _revision;

  static bool isPlaybackRoute(Route<dynamic> route) => const {
    '/videoV',
    '/liveRoom',
    '/audio',
  }.contains(route.settings.name?.split('?').first);

  Route<dynamic>? _pageBefore(int index) {
    for (var i = index - 1; i >= 0; i--) {
      if (_routes[i] is PageRoute) return _routes[i];
    }
    return null;
  }

  Route<dynamic>? get _topPage {
    for (final route in _routes.reversed) {
      if (route is PageRoute) return route;
    }
    return null;
  }

  bool canCreateMiniPlayer({
    required Route<dynamic>? ownerRoute,
    bool isPop = false,
  }) {
    if (ownerRoute == null) return false;
    final index = _routes.indexOf(ownerRoute);
    Route<dynamic>? destination;
    if (isPop) {
      // PopScope may run before didPop, or after the route was removed.
      if (index >= 0 && !identical(_topPage, ownerRoute)) return false;
      destination = index >= 0
          ? _pageBefore(index)
          : _popDestinations[ownerRoute]?.route;
      if (index < 0 &&
          (_popDestinations[ownerRoute]?.revision != _revision ||
              !identical(_topPage, destination))) {
        return false;
      }
    } else {
      if (index < 0) return false;
      destination = _topPage;
    }
    return destination != null &&
        !identical(destination, ownerRoute) &&
        !isPlaybackRoute(destination);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _revision++;
    _routes.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _revision++;
    final index = _routes.indexOf(route);
    _popDestinations[route] = _PopDestination(
      index < 0 ? previousRoute : _pageBefore(index),
      _revision,
    );
    _routes.remove(route);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _revision++;
    _routes.remove(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _revision++;
    final index = oldRoute == null ? -1 : _routes.indexOf(oldRoute);
    if (index >= 0) {
      if (newRoute == null) {
        _routes.removeAt(index);
      } else {
        _routes[index] = newRoute;
      }
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class _PopDestination {
  const _PopDestination(this.route, this.revision);
  final Route<dynamic>? route;
  final int revision;
}
