import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:get/get.dart';

abstract class CommonDataController<R, T> extends CommonController<R, T> {
  @override
  Rx<LoadingState<T>> loadingState = LoadingState<T>.loading().obs;

  @override
  Future<void> handleQuery(
    bool isRefresh,
    bool Function() isCurrent,
  ) async {
    final LoadingState<R> res = await customGetData();
    if (!isCurrent()) {
      return;
    }
    if (res is Success<R>) {
      final isHandled = customHandleResponse(isRefresh, res);
      if (isCurrent() && !isHandled) {
        loadingState.value = res as LoadingState<T>;
      }
    } else if (isRefresh) {
      final isHandled = handleError(res is Error ? res.errMsg : null);
      if (isCurrent() && !isHandled) {
        loadingState.value = res as Error;
      }
    }
  }

  @override
  Future<void> onReload() {
    loadingState.value = LoadingState<T>.loading();
    return super.onReload();
  }
}
