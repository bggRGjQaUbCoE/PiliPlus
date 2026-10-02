import 'dart:async';

import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart'
    show RefreshIndicatorState;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/widgets.dart' show GlobalKey, ScrollController;
import 'package:get/get.dart';

mixin ScrollOrRefreshMixin {
  ScrollController get scrollController;

  String get topOrRefreshThrottleKey =>
      'topOrRefresh_${identityHashCode(this)}';

  String get topAndRefreshThrottleKey =>
      'topAndRefresh_${identityHashCode(this)}';

  Future<void> animateToTop() => scrollController.animToTop();

  Future<void> onRefresh();

  void toTopAndRefresh() {
    EasyThrottle.throttle(
      topAndRefreshThrottleKey,
      const Duration(milliseconds: 500),
      () async {
        if (scrollController.hasClients &&
            scrollController.position.pixels != 0) {
          await animateToTop();
        }
        await showRefresh();
      },
    );
  }

  Future<void> showRefresh() => onRefresh();

  void toTopOrRefresh() {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels == 0) {
        EasyThrottle.throttle(
          topOrRefreshThrottleKey,
          const Duration(milliseconds: 500),
          showRefresh,
        );
      } else {
        animateToTop();
      }
    }
  }
}

abstract class CommonController<R, T> extends GetxController
    with ScrollOrRefreshMixin {
  @override
  final ScrollController scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Future<void> showRefresh() =>
      refreshKey.currentState?.show() ?? onRefresh();

  bool isLoading = false;
  Rx<LoadingState> get loadingState;

  Future<LoadingState<R>> customGetData();

  Future<void> queryData([bool isRefresh = true]);

  bool customHandleResponse(bool isRefresh, Success<R> response) {
    return false;
  }

  bool handleError(String? errMsg) {
    return false;
  }

  @override
  Future<void> onRefresh() {
    return queryData();
  }

  Future<void> onLoadMore() {
    return queryData(false);
  }

  Future<void> onReload() {
    return onRefresh();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
