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
  Future<void> queryData([bool isRefresh = true]) async {
    if (isLoading || (!isRefresh && isEnd)) return;
    isLoading = true;
    LoadingState<R> response = await customGetData();
    if (response is Success<R>) {
      if (!customHandleResponse(isRefresh, response)) {
        final dataList = getDataList(response.response);
        if (dataList == null || dataList.isEmpty) {
          isEnd = true;
          if (isRefresh) {
            loadingState.value = Success(dataList);
          } else if (hasFooter == true) {
            loadingState.refresh();
          }
          isLoading = false;
          return;
        }
        handleListResponse(dataList);
        if (isRefresh) {
          checkIsEnd(dataList.length);
          loadingState.value = Success(dataList);
        } else if (loadingState.value is Success) {
          final list = loadingState.value.data!..addAll(dataList);
          checkIsEnd(list.length);
          loadingState.refresh();
        }
      }
      page++;
    } else {
      if (isRefresh &&
          !handleError(response is Error ? response.errMsg : null)) {
        loadingState.value = response as LoadingState<List<T>?>;
      }
    }
    isLoading = false;
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
