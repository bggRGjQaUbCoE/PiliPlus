import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models_new/history/data.dart';
import 'package:PiliPlus/models_new/history/list.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/common/search/common_search_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:flutter/widgets.dart' show Text;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class HistorySearchController
    extends CommonSearchController<HistoryData, HistoryItemModel>
    with CommonMultiSelectMixin<HistoryItemModel>, DeleteItemMixin {
  @override
  Future<LoadingState<HistoryData>> customGetData() => UserHttp.searchHistory(
    pn: page,
    keyword: editController.value.text,
    account: account,
  );

  @override
  List<HistoryItemModel>? getDataList(HistoryData response) {
    return response.list;
  }

  final account = Accounts.history;

  Future<void> onDelHistory(int index, kid, String business) async {
    final res = await UserHttp.delHistory(
      '${business}_$kid',
      account: account,
    );
    if (res.isSuccess) {
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
      SmartDialog.showToast(L10n.current.historyControllerOnDeleteText);
    } else {
      res.toast();
    }
  }

  @override
  void onRemove() {
    showConfirmDialog(
      context: Get.context!,
      title: Text(L10n.current.notice),
      content: Text(L10n.current.historyControllerOnRemoveContent),
      onConfirm: () async {
        SmartDialog.showLoading(
          msg: L10n.current.pagesCommonCommonIntroControllerActionFavVideoMsg,
        );
        final removeList = allChecked.toSet();
        final response = await UserHttp.delHistory(
          removeList
              .map((item) => '${item.history.business!}_${item.kid!}')
              .join(','),
          account: account,
        );
        if (response.isSuccess) {
          afterDelete(removeList);
          SmartDialog.showToast(L10n.current.historyControllerOnDeleteText);
        } else {
          response.toast();
        }
        SmartDialog.dismiss();
      },
    );
  }
}
