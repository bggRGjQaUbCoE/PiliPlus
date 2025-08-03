import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models_new/history/data.dart';
import 'package:PiliPlus/models_new/history/list.dart';
import 'package:PiliPlus/pages/common/common_search_controller.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class HistorySearchController
    extends CommonSearchController<HistoryData, HistoryItemModel>
    with
        MultiSelectMixin<HistoryItemModel>,
        CommonMultiSelectMixin,
        DeleteItemMixin {
  @override
  Future<LoadingState<HistoryData>> customGetData() => UserHttp.searchHistory(
    pn: page,
    keyword: editController.value.text,
  );

  @override
  List<HistoryItemModel>? getDataList(HistoryData response) {
    return response.list;
  }

  Future<void> onDelHistory(int index, kid, String business) async {
    final String resKid;
    if (business == 'live') {
      resKid = 'live_$kid';
    } else if (business.contains('article')) {
      resKid = 'article_$kid';
    } else {
      resKid = 'archive_$kid';
    }

    var res = await UserHttp.delHistory([resKid]);
    if (res['status']) {
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
    }
    SmartDialog.showToast(res['msg']);
  }

  @override
  void onConfirm() {
    showConfirmDialog(
      context: Get.context!,
      content: '确认删除所选历史记录吗？',
      title: '提示',
      onConfirm: () async {
        SmartDialog.showLoading(msg: '请求中');
        final result = allChecked.toSet();
        final kidList = result.map(
          (item) => '${item.history.business!}_${item.kid!}',
        );
        var response = await UserHttp.delHistory(kidList);
        if (response['status']) {
          afterDelete(result);
        }
        SmartDialog.dismiss();
        SmartDialog.showToast(response['msg']);
      },
    );
  }
}
