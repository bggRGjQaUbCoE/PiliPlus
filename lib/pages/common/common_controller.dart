import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/widgets.dart' show ScrollController;
import 'package:get/get.dart';

mixin ScrollOrRefreshMixin {
  ScrollController get scrollController;

  void animateToTop() => scrollController.animToTop();

  Future<void> onRefresh();

  void toTopOrRefresh() {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels == 0) {
        EasyThrottle.throttle(
          'topOrRefresh',
          const Duration(milliseconds: 500),
          onRefresh,
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

  bool isLoading = false;
  Rx<LoadingState> get loadingState;

  Future<void>? _activeQuery;
  int _latestQueryGeneration = 0;
  bool _hasPendingRefresh = false;

  Future<LoadingState<R>> customGetData();

  Future<void> queryData([bool isRefresh = true]) {
    if (isClosed) {
      return Future<void>.value();
    }
    if (_activeQuery != null) {
      if (!isRefresh) {
        return Future<void>.value();
      }
      _latestQueryGeneration += 1;
      _hasPendingRefresh = true;
      return _activeQuery!;
    }

    final completer = Completer<void>();
    _activeQuery = completer.future;
    isLoading = true;
    _latestQueryGeneration += 1;
    unawaited(
      _drainQueries(isRefresh).then(
        completer.complete,
        onError: completer.completeError,
      ),
    );
    return completer.future;
  }

  Future<void> _drainQueries(bool isRefresh) async {
    try {
      while (true) {
        final generation = _latestQueryGeneration;
        _hasPendingRefresh = false;
        try {
          await handleQuery(
            isRefresh,
            () => !isClosed && generation == _latestQueryGeneration,
          );
        } catch (_) {
          if (!isClosed && generation == _latestQueryGeneration) {
            rethrow;
          }
        }

        if (isClosed || !_hasPendingRefresh) {
          return;
        }
        isRefresh = true;
      }
    } finally {
      isLoading = false;
      _activeQuery = null;
    }
  }

  Future<void> handleQuery(
    bool isRefresh,
    bool Function() isCurrent,
  );

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
