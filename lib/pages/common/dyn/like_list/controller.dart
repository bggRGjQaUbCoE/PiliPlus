import 'package:PiliPlus/grpc/bilibili/app/dynamic/v2.pb.dart'
    show LikeListReply, ModuleAuthor;
import 'package:PiliPlus/grpc/dyn.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

class DynLikeController
    extends CommonListController<LikeListReply, ModuleAuthor> {
  DynLikeController(this.id, {int count = -1}) : count = RxInt(count);
  final String id;

  final RxInt count;

  @override
  List<ModuleAuthor>? getDataList(LikeListReply response) {
    count.value = response.totalCount.toInt();
    if (!response.hasMore) {
      isEnd = true;
    }
    return response.list;
  }

  @override
  Future<LoadingState<LikeListReply>> customGetData() =>
      DynGrpc.likeList(dynamicId: id, page: page);
}
