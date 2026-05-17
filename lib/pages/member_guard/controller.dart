import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models_new/member_guard/data.dart';
import 'package:PiliPlus/models_new/member_guard/guard_top_list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/nav.dart';

class MemberGuardController
    extends CommonListController<MemberGuardData, GuardItem> {
  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  final Object ruid = Nav.arguments['ruid'];

  late List<GuardItem> tops;

  @override
  List<GuardItem>? getDataList(MemberGuardData response) {
    return response.guardTopList;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<MemberGuardData> response) {
    if (response.response.hasMore != 1) {
      isEnd = true;
    }
    if (isRefresh) {
      final list = response.response.guardTopList;
      tops = list.take(3).toList();
      if (list.length > 3) {
        list.removeRange(0, 3);
      } else {
        list.clear();
      }
    }
    return false;
  }

  @override
  Future<LoadingState<MemberGuardData>> customGetData() =>
      MemberHttp.memberGuard(ruid: ruid, page: page);
}
