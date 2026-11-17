import 'package:PiliPlus/common/widgets/scroll_intent.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

abstract class CommonPageState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  final _scrollIntent = ScrollVisibility();
  bool _tickerEnabled = true;
  RxDouble? _barOffset;
  RxBool? _showTopBar;
  RxBool? _showBottomBar;
  final _mainController = Get.find<MainController>();

  bool get needsCorrection => false;
  bool get isScrollPageActive => true;
  bool get restoreBarsOnTickerResume => true;

  @override
  void initState() {
    super.initState();
    _barOffset = _mainController.barOffset;
    _showBottomBar = _mainController.showBottomBar;
    if (Get.isRegistered<HomeController>()) {
      _showTopBar = Get.find<HomeController>().showTopBar;
    }
    WidgetsBinding.instance.addObserver(this);
  }

  Widget onBuild(Widget child) {
    if (_barOffset != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: onNotificationType2,
        child: child,
      );
    }
    if (_showTopBar != null || _showBottomBar != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: onNotificationType1,
        child: child,
      );
    }
    return child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final enabled = TickerMode.valuesOf(context).enabled;
    if (enabled && !_tickerEnabled && isScrollPageActive) {
      _scrollIntent.reset();
      if (restoreBarsOnTickerResume) _mainController.restoreBars();
    }
    _tickerEnabled = enabled;
  }

  void _restoreBars() {
    _scrollIntent.reset();
    _mainController.restoreBars();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _tickerEnabled &&
        isScrollPageActive) {
      _restoreBars();
    }
  }

  bool onNotificationType1(ScrollNotification notification) {
    if (!_tickerEnabled ||
        !isScrollPageActive ||
        !_mainController.useBottomNav) {
      return false;
    }
    switch (_scrollIntent.update(notification)) {
      case .forward:
        _showTopBar?.value = true;
        _showBottomBar?.value = true;
      case .reverse:
        _showTopBar?.value = false;
        _showBottomBar?.value = false;
      case .idle || null:
        break;
    }
    return false;
  }

  void _updateOffset(double scrollDelta) {
    _barOffset!.value = clampDouble(
      _barOffset!.value + scrollDelta,
      0.0,
      Style.topBarHeight,
    );
  }

  bool onNotificationType2(ScrollNotification notification) {
    if (!_tickerEnabled ||
        !isScrollPageActive ||
        !_mainController.useBottomNav) {
      return false;
    }

    final metrics = notification.metrics;
    if (metrics.axis == .horizontal) return false;

    final intent = _scrollIntent.update(notification);
    if (notification is ScrollStartNotification) {
      if (_mainController.bottomBarSettling.value) {
        if (_mainController.bottomNavVisibility.value case final visibility?) {
          _barOffset!.value = (1 - visibility) * Style.topBarHeight;
        }
      }
      _mainController.bottomBarSettling.value = false;
    }
    if (notification is ScrollEndNotification) {
      _mainController.bottomBarSettling.value = true;
      _barOffset!.value =
          intent == .forward ||
              (intent == null && _barOffset!.value < Style.topBarHeight / 2)
          ? 0
          : Style.topBarHeight;
    }
    if (notification is ScrollUpdateNotification) {
      if (intent == null) return false;
      final pixel = metrics.pixels;
      final scrollDelta = notification.scrollDelta ?? 0;
      if (pixel < 0.0 && scrollDelta > 0) return false;
      if (needsCorrection) {
        final value = _barOffset!.value;
        final newValue = clampDouble(
          value + scrollDelta,
          0.0,
          Style.topBarHeight,
        );
        final offset = value - newValue;
        if (offset != 0) {
          _barOffset!.value = newValue;
          if (pixel < 0.0 && scrollDelta < 0.0 && value > 0.0) {
            return false;
          }
          Scrollable.of(notification.context!).position.correctBy(offset);
        }
      } else {
        _updateOffset(scrollDelta);
      }
      return false;
    }

    if (notification is OverscrollNotification && intent == .forward) {
      _barOffset!.value = 0;
    }

    return false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _barOffset = null;
    _showTopBar = null;
    _showBottomBar = null;
    super.dispose();
  }
}
