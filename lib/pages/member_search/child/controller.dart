import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/common/member/search_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models_new/member/search_archive/data.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/member_search/controller.dart';

class MemberSearchChildController extends CommonListController {
  MemberSearchChildController(this.controller, this.searchType);

  final MemberSearchController controller;
  final MemberSearchType searchType;

  dynamic offset;

  @override
  void checkIsEnd(int length) {
    switch (searchType) {
      case MemberSearchType.archive:
        if (controller.counts.first != -1 &&
            length >= controller.counts.first) {
          isEnd = true;
        }
        break;
      case MemberSearchType.dynamic:
        if (controller.counts[1] != -1 && length >= controller.counts[1]) {
          isEnd = true;
        }
        break;
    }
  }

  @override
  List? getDataList(response) {
    switch (searchType) {
      case MemberSearchType.archive:
        SearchArchiveData data = response;
        controller.counts[searchType.index] = data.page?.count ?? 0;
        return data.list?.vlist;
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
      MemberSearchType.archive => MemberHttp.searchArchive(
        mid: controller.mid!,
        pn: page,
        keyword: controller.editingController.text,
        order: 'pubdate',
      ),
      MemberSearchType.dynamic => MemberHttp.dynSearch(
        mid: controller.mid!,
        pn: page,
        offset: offset ?? '',
        keyword: controller.editingController.text,
      ),
    };
  }
}
