import 'package:PiliPlus/grpc/bilibili/app/dynamic/v2.pb.dart'
    show LikeListReply, ModuleAuthor;
import 'package:PiliPlus/grpc/dyn.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:get/get.dart';

class DynLikeController
    extends CommonListController<LikeListReply, ModuleAuthor> {
  DynLikeController(this.id, {int count = -1}) : count = RxInt(count);
  final String id;

  Int64? _uidOffset;
  final RxInt count;

  @override
  List<ModuleAuthor>? getDataList(LikeListReply response) {
    count.value = response.totalCount.toInt();
    final list = response.list;
    _uidOffset = list.lastOrNull?.mid;
    if (!response.hasMore) {
      isEnd = true;
    }
    return list;
  }

  @override
  Future<LoadingState<LikeListReply>> customGetData() => DynGrpc.likeList(
    dynamicId: id,
    uidOffset: _uidOffset,
    page: page,
  );

  @override
  Future<void> onRefresh() {
    _uidOffset = null;
    return super.onRefresh();
  }
}
