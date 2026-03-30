import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/common/member/archive_order_type_web.dart';
import 'package:PiliPlus/models_new/member/search_archive/data.dart';
import 'package:PiliPlus/models_new/member/search_archive/slist.dart';
import 'package:PiliPlus/models_new/member/search_archive/vlist.dart';
import 'package:PiliPlus/pages/member_video_web/base/controller.dart';
import 'package:get/get.dart';

class MemberVideoWebCtr
    extends
        BaseVideoWebCtr<
          SearchArchiveData,
          VListItemModel,
          ArchiveOrderTypeWeb
        > {
  int? _totalCount;
  @override
  final Rx<ArchiveOrderTypeWeb> order = Rx(.pubdate);

  int tid = 0;
  String? specialType;
  List<ListTag>? tags;

  @override
  List<VListItemModel>? getDataList(SearchArchiveData response) {
    return response.list?.vlist;
  }

  @override
  bool customHandleResponse(
    bool isRefresh,
    Success<SearchArchiveData> response,
  ) {
    if (isRefresh) {
      final data = response.response;
      if (data.page?.count case final count?) {
        if (tid == 0 && specialType == null) {
          _totalCount = count;
        }
        this.count = count;
        totalPage = (count / ps).ceil();
      }
      final tags = data.list?.tags;
      if (tags?.isNotEmpty ?? false) {
        this.tags = tags!
          ..insert(0, ListTag(tid: 0, name: '全部类型', count: _totalCount));
      }
    }
    return false;
  }

  @override
  Future<LoadingState<SearchArchiveData>> customGetData() =>
      MemberHttp.searchArchive(
        mid: mid,
        ps: ps,
        pn: page,
        order: order.value,
        tid: tid,
        specialType: specialType,
      );
}
