import 'package:PiliPlus/common/widgets/scroll_physics.dart' show ReloadMixin;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

const int ps = 30;

abstract class BaseVideoWebCtr<R, T, V> extends CommonListController<R, T>
    with ReloadMixin {
  final Object mid = Get.arguments['mid'];

  int? totalPage;
  int? count;
  Rx<V> get order;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  void checkIsEnd(int length) {
    if (totalPage != null && page >= totalPage!) {
      isEnd = true;
    } else if (count != null && length >= count!) {
      isEnd = true;
    }
  }

  void queryBySort(V value) {
    if (isLoading) return;
    order.value = value;
    onReload();
  }

  void jumpToPage(int page) {
    isEnd = false;
    reload = true;
    this.page = page;
    loadingState.value = LoadingState.loading();
    queryData();
  }

  @override
  Future<void> onReload() {
    reload = true;
    return super.onReload();
  }
}
