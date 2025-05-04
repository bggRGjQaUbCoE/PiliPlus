import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/user/history.dart';
import 'package:PiliPlus/pages/common/common_search_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class HistorySearchController
    extends CommonSearchController<HistoryData, HisListItem> {
  @override
  Future<LoadingState<HistoryData>> customGetData() => UserHttp.searchHistory(
        pn: currentPage,
        keyword: editController.value.text,
      );

  @override
  List<HisListItem>? getDataList(HistoryData response) {
    return response.list;
  }

  Future onDelHistory(index, kid, business) async {
    String resKid = 'archive_$kid';
    if (business == 'live') {
      resKid = 'live_$kid';
    } else if (business.contains('article')) {
      resKid = 'article_$kid';
    }

    var res = await UserHttp.delHistory([resKid]);
    if (res['status']) {
      loadingState.value.data!.removeAt(index);
      loadingState.refresh();
      SmartDialog.showToast(res['msg']);
    }
  }
}
