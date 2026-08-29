import 'dart:async' show unawaited;

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:get/get.dart';

abstract class CommonListController<R, T> extends CommonController<R, T> {
  int get initialPage => 1;

  late int page = initialPage;
  bool isEnd = false;
  bool? hasFooter;
  Future<void>? _activeQuery;

  bool get autoLoadMore => false;

  double get loadMoreTriggerExtent => 600;

  @override
  void onInit() {
    super.onInit();
    if (autoLoadMore) {
      scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients || isLoading || isEnd) return;
    final position = scrollController.position;
    if (position.hasContentDimensions &&
        position.extentAfter <= loadMoreTriggerExtent) {
      unawaited(onLoadMore());
    }
  }

  @override
  Rx<LoadingState<List<T>?>> loadingState =
      LoadingState<List<T>?>.loading().obs;

  void handleListResponse(List<T> dataList) {}

  List<T>? getDataList(R response) {
    return response as List<T>?;
  }

  bool shouldMarkEmptyAsEnd(R response) => true;

  void checkIsEnd(int length) {}

  @override
  Future<void> queryData([bool isRefresh = true]) {
    if (_activeQuery case final activeQuery?) {
      return activeQuery;
    }
    if (!isRefresh && isEnd) return Future.value();

    late final Future<void> trackedQuery;
    trackedQuery = _runQuery(isRefresh).whenComplete(() {
      if (identical(_activeQuery, trackedQuery)) {
        _activeQuery = null;
      }
    });
    _activeQuery = trackedQuery;
    return trackedQuery;
  }

  Future<void> _runQuery(bool isRefresh) async {
    isLoading = true;
    try {
      final LoadingState<R> res = await customGetData();
      if (res case Success(:final response)) {
        if (!customHandleResponse(isRefresh, res)) {
          final dataList = getDataList(response);
          if (dataList == null || dataList.isEmpty) {
            if (shouldMarkEmptyAsEnd(response)) {
              isEnd = true;
            }
            if (isRefresh) {
              loadingState.value = Success(dataList);
            } else if (hasFooter == true) {
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
      } else if (isRefresh && !handleError(res is Error ? res.errMsg : null)) {
        loadingState.value = res as Error;
      }
    } catch (error) {
      if (isRefresh && !handleError(error.toString())) {
        loadingState.value = Error(error.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  void resetForRefresh() {
    page = initialPage;
    isEnd = false;
  }

  @override
  Future<void> onRefresh() async {
    if (_activeQuery case final activeQuery?) {
      await activeQuery;
    }
    resetForRefresh();
    await queryData();
  }

  @override
  Future<void> onLoadMore() {
    if (_activeQuery case final activeQuery?) {
      return activeQuery;
    }
    return super.onLoadMore();
  }

  @override
  Future<void> onReload() {
    loadingState.value = LoadingState<List<T>?>.loading();
    return super.onReload();
  }
}
