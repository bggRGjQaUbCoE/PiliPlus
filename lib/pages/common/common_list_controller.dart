import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:get/get.dart';

abstract class CommonListController<R, T> extends CommonController<R, T> {
  int page = 1;
  bool isEnd = false;
  bool? hasFooter;

  @override
  Rx<LoadingState<List<T>?>> loadingState =
      LoadingState<List<T>?>.loading().obs;

  void handleListResponse(List<T> dataList) {}

  List<T>? getDataList(R response) {
    return response as List<T>?;
  }

  void checkIsEnd(int length) {}

  @override
  Future<void> queryData([bool isRefresh = true]) {
    if (!isRefresh && isEnd) {
      return Future<void>.value();
    }
    return super.queryData(isRefresh);
  }

  @override
  Future<void> handleQuery(
    bool isRefresh,
    bool Function() isCurrent,
  ) async {
    final LoadingState<R> res = await customGetData();
    if (!isCurrent()) {
      return;
    }
    if (res case Success(:final response)) {
      final isHandled = customHandleResponse(isRefresh, res);
      if (!isCurrent()) {
        return;
      }
      if (!isHandled) {
        final dataList = getDataList(response);
        if (!isCurrent()) {
          return;
        }
        if (dataList == null || dataList.isEmpty) {
          isEnd = true;
          if (isRefresh) {
            loadingState.value = Success(dataList);
          } else if (hasFooter == true) {
            loadingState.refresh();
          }
          return;
        }
        handleListResponse(dataList);
        if (!isCurrent()) {
          return;
        }
        if (isRefresh) {
          checkIsEnd(dataList.length);
          if (!isCurrent()) {
            return;
          }
          loadingState.value = Success(dataList);
        } else if (loadingState.value case Success(:final response)) {
          response!.addAll(dataList);
          checkIsEnd(response.length);
          if (!isCurrent()) {
            return;
          }
          loadingState.refresh();
        }
      }
      if (isCurrent()) {
        page++;
      }
    } else if (isRefresh) {
      final isHandled = handleError(res is Error ? res.errMsg : null);
      if (isCurrent() && !isHandled) {
        loadingState.value = res as Error;
      }
    }
  }

  @override
  Future<void> onRefresh() {
    page = 1;
    isEnd = false;
    return super.onRefresh();
  }

  @override
  Future<void> onReload() {
    loadingState.value = LoadingState<List<T>?>.loading();
    return super.onReload();
  }
}
