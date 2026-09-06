import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_forward/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_forward/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

class DynForwardController
    extends CommonListController<DynForwardData, DynForwardItem> {
  DynForwardController(this.id, {int count = -1}) : count = RxInt(count);

  final String id;
  final RxInt count;
  String? _offset;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<DynForwardItem>? getDataList(DynForwardData response) {
    _offset = response.offset;
    if (response.hasMore != true || response.offset?.isNotEmpty != true) {
      isEnd = true;
    }
    return response.items;
  }

  @override
  bool customHandleResponse(
    bool isRefresh,
    Success<DynForwardData> response,
  ) {
    if (isRefresh) {
      count.value = response.response.total;
    }
    return false;
  }

  @override
  Future<LoadingState<DynForwardData>> customGetData() =>
      DynamicsHttp.dynForward(id: id, offset: _offset);

  @override
  Future<void> onRefresh() {
    _offset = null;
    return super.onRefresh();
  }
}
