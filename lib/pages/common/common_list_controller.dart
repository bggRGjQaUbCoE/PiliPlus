import 'dart:async';

import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:get/get.dart';

abstract class CommonListController<R, T> extends CommonController<R, T> {
  int _generation = 0;
  StreamSubscription<bool>? _accountListener;
  StreamSubscription<int>? _roleListener;
  Object? _dataScope;
  Object? get dataScope => null;

  @override
  void onInit() {
    super.onInit();
    _dataScope = dataScope;
    if (_dataScope != null) {
      final accounts = Get.find<AccountService>();
      _accountListener = accounts.isLogin.listen((_) => _checkDataScope());
      _roleListener = accounts.accountRevision.listen((_) => _checkDataScope());
    }
  }

  void _checkDataScope() {
    if (!identical(_dataScope, dataScope)) {
      _dataScope = dataScope;
      onReload();
    }
  }

  @override
  void onClose() {
    _generation++;
    _accountListener?.cancel();
    _roleListener?.cancel();
    super.onClose();
  }

  final refreshing = false.obs;
  final loadingMore = false.obs;
  final refreshError = Rxn<Error>();
  final loadMoreError = Rxn<Error>();
  Future<void>? _scheduledLoad;

  int page = 1;
  bool isEnd = false;
  bool get endIfNullOrEmpty => true;
  bool get hasFooter => false;

  @override
  Rx<LoadingState<List<T>?>> loadingState =
      LoadingState<List<T>?>.loading().obs;

  void handleListResponse(List<T> dataList) {}

  List<T>? getDataList(R response) {
    return response as List<T>?;
  }

  void checkIsEnd(int length) {}

  @override
  Future<void> queryData([bool isRefresh = true]) async {
    if (isClosed) return;
    if (!identical(_dataScope, dataScope)) {
      _dataScope = dataScope;
      return onReload();
    }
    if (isLoading || (!isRefresh && isEnd)) return;
    isLoading = true;
    final generation = _generation;
    final hasContent = loadingState.value.dataOrNull?.isNotEmpty == true;
    if (isRefresh) {
      refreshError.value = null;
      loadMoreError.value = null;
      refreshing.value = hasContent;
      if (!hasContent) loadingState.value = LoadingState.loading();
    } else {
      loadMoreError.value = null;
      loadingMore.value = true;
    }
    try {
      final LoadingState<R> res = await customGetData();
      if (generation != _generation || !identical(_dataScope, dataScope)) {
        return;
      }
      if (res case Success(:final response)) {
        if (!customHandleResponse(isRefresh, res)) {
          final dataList = getDataList(response);
          if (dataList == null || dataList.isEmpty) {
            if (endIfNullOrEmpty) isEnd = true;
            if (isRefresh) {
              loadingState.value = Success(dataList);
            } else if (hasFooter) {
              loadingState.refresh();
            }
            return;
          }
          handleListResponse(dataList);
          if (isRefresh) {
            checkIsEnd(dataList.length);
            loadingState.value = Success(dataList);
          } else if (loadingState.value case Success(:final response)) {
            response!.addAll(dataList);
            checkIsEnd(response.length);
            loadingState.refresh();
          }
        }
        page++;
      } else {
        final error = res as Error;
        if (!isRefresh) {
          loadMoreError.value = error;
        } else if (hasContent) {
          refreshError.value = error;
        } else if (!handleError(error.errMsg)) {
          loadingState.value = error;
        }
      }
    } finally {
      if (generation == _generation) {
        isLoading = false;
        refreshing.value = false;
        loadingMore.value = false;
      }
    }
  }

  @override
  Future<void> onLoadMore() {
    if (isClosed ||
        isLoading ||
        isEnd ||
        loadMoreError.value != null ||
        refreshError.value != null) {
      return Future.value();
    }
    if (_scheduledLoad != null) return _scheduledLoad!;
    final generation = _generation;
    late final Future<void> scheduled;
    scheduled =
        Future<void>.microtask(() async {
          if (generation == _generation && !isClosed) await queryData(false);
        }).whenComplete(() {
          if (identical(_scheduledLoad, scheduled)) _scheduledLoad = null;
        });
    return _scheduledLoad = scheduled;
  }

  Future<void> retryLoadMore() =>
      refreshError.value == null ? queryData(false) : retry();

  Future<void> retry() {
    if (isLoading || isClosed) return Future.value();
    return onRefresh();
  }

  @override
  Future<void> onRefresh() {
    if (isClosed || isLoading) return Future.value();
    page = 1;
    isEnd = false;
    return super.onRefresh();
  }

  @override
  Future<void> onReload() {
    _generation++;
    _scheduledLoad = null;
    isLoading = false;
    refreshing.value = false;
    loadingMore.value = false;
    refreshError.value = loadMoreError.value = null;
    if (scrollController.hasClients) scrollController.jumpTo(0);
    loadingState.value = LoadingState<List<T>?>.loading();
    return super.onReload();
  }
}
