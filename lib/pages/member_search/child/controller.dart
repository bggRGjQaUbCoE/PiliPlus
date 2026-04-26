import 'package:PiliPlus/grpc/bilibili/app/interfaces/v1.pb.dart'
    show SearchArchiveReply;
import 'package:PiliPlus/grpc/space.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/common/member/search_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/member_search/controller.dart';
import 'package:fixnum/fixnum.dart' show Int64;

class MemberSearchChildController extends CommonListController {
  MemberSearchChildController(this.controller, this.searchType);

  final MemberSearchController controller;
  final MemberSearchType searchType;

  // archive
  late final _ps = Int64(20);
  late final _midInt64 = Int64(int.parse(controller.mid));

  // dynamic
  String? offset;

  @override
  void checkIsEnd(int length) {
    final count = controller.counts[searchType.index];
    if (count != -1 && length >= count) {
      isEnd = true;
    }
  }

  @override
  List? getDataList(response) {
    switch (searchType) {
      case MemberSearchType.archive:
        SearchArchiveReply data = response;
        controller.counts[searchType.index] = data.total.toInt();
        return data.archives;
      case MemberSearchType.dynamic:
        DynamicsDataModel data = response;
        offset = data.offset;
        if (data.hasMore == false) {
          isEnd = true;
        }
        controller.counts[searchType.index] = data.total ?? 0;
        return data.items;
    }
  }

  @override
  Future<void> onRefresh() {
    offset = null;
    return super.onRefresh();
  }

  @override
  Future<LoadingState> customGetData() {
    return switch (searchType) {
      MemberSearchType.archive => SpaceGrpc.searchArchive(
        mid: _midInt64,
        pn: page,
        ps: _ps,
        keyword: controller.editingController.text,
      ),
      MemberSearchType.dynamic => MemberHttp.dynSearch(
        mid: controller.mid,
        pn: page,
        offset: offset ?? '',
        keyword: controller.editingController.text,
      ),
    };
  }
}
