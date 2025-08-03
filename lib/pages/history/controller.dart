import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models_new/history/data.dart';
import 'package:PiliPlus/models_new/history/list.dart';
import 'package:PiliPlus/models_new/history/tab.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:PiliPlus/pages/history/base_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class HistoryController
    extends MultiSelectController<HistoryData, HistoryItemModel>
    with GetSingleTickerProviderStateMixin {
  HistoryController(this.type);

  late final baseCtr = Get.put(HistoryBaseController());

  final String? type;
  TabController? tabController;
  late RxList<HistoryTab> tabs = <HistoryTab>[].obs;

  int? max;
  int? viewAt;

  @override
  RxInt get rxCount => baseCtr.checkedCount;

  @override
  RxBool get enableMultiSelect => baseCtr.enableMultiSelect;

  @override
  void onInit() {
    super.onInit();
    historyStatus();
    queryData();
  }

  @override
  Future<void> onRefresh() {
    max = null;
    viewAt = null;
    return super.onRefresh();
  }

  @override
  List<HistoryItemModel>? getDataList(HistoryData response) {
    return response.list;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<HistoryData> response) {
    HistoryData data = response.response;
    isEnd = data.list.isNullOrEmpty;
    max = data.list?.lastOrNull?.history.oid;
    viewAt = data.list?.lastOrNull?.viewAt;

    if (isRefresh && type == null) {
      if (tabs.isEmpty && data.tab?.isNotEmpty == true) {
        tabs.value = data.tab!;
        tabController = TabController(
          length: data.tab!.length + 1,
          vsync: this,
        );
      }
    }

    return false;
  }

  // 观看历史暂停状态
  Future<void> historyStatus() async {
    var res = await UserHttp.historyStatus();
    if (res['status']) {
      baseCtr.pauseStatus.value = res['data'];
      GStorage.localCache.put(LocalCacheKey.historyPause, res['data']);
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // 删除某条历史记录
  void delHistory(HistoryItemModel item) {
    _onDelete({item});
  }

  // 删除已看历史记录
  void onDelHistory() {
    if (loadingState.value.isSuccess) {
      final set = loadingState.value.data!
          .where((e) => e.progress == -1)
          .toSet();
      if (set.isNotEmpty) {
        _onDelete(set);
      } else {
        SmartDialog.showToast('无已看记录');
      }
    }
  }

  Future<void> _onDelete(Set<HistoryItemModel> result) async {
    SmartDialog.showLoading(msg: '请求中');
    final response = await UserHttp.delHistory(
      result.map((item) => '${item.history.business}_${item.kid}'),
    );
    if (response['status']) {
      afterDelete(result);
    }
    SmartDialog.dismiss();
    SmartDialog.showToast(response['msg']);
  }

  // 删除选中的记录
  @override
  void onConfirm() {
    showConfirmDialog(
      context: Get.context!,
      content: '确认删除所选历史记录吗？',
      title: '提示',
      onConfirm: () => _onDelete(allChecked.toSet()),
    );
  }

  @override
  Future<LoadingState<HistoryData>> customGetData() =>
      UserHttp.historyList(type: type ?? 'all', max: max, viewAt: viewAt);

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }

  @override
  Future<void> onReload() {
    scrollController.jumpToTop();
    return super.onReload();
  }
}
