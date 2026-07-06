import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reaction/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reaction/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

class DynReactController
    extends CommonListController<DynReactionData, DynReactionItem> {
  DynReactController(this.id, {int count = -1}) : count = RxInt(count);
  final Object id;

  String? _offset;
  final RxInt count;

  @override
  List<DynReactionItem>? getDataList(DynReactionData response) {
    _offset = response.offset;
    if (response.hasMore != true) {
      isEnd = true;
    }
    return response.items;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<DynReactionData> response) {
    if (isRefresh) {
      final res = response.response;
      final total = res.total;
      if (!(total == 0 && res.items?.isNotEmpty == true)) {
        count.value = total;
      }
    }
    return false;
  }

  @override
  Future<LoadingState<DynReactionData>> customGetData() =>
      DynamicsHttp.dynReaction(id: id, offset: _offset);

  @override
  Future<void> onRefresh() {
    _offset = null;
    return super.onRefresh();
  }
}
