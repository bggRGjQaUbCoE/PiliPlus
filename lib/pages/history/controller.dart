import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:PiliPlus/pages/history/base_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/user/history.dart';
import 'package:PiliPlus/utils/storage.dart';

class HistoryController extends MultiSelectController
    with GetTickerProviderStateMixin {
  HistoryController(this.type);

  late final baseCtr = Get.put(HistoryBaseController());

  final String? type;
  TabController? tabController;
  late RxList<HisTabItem> tabs = <HisTabItem>[].obs;

  int? max;
  int? viewAt;

  @override
  void onInit() {
    super.onInit();
    historyStatus();
    queryData();
  }

  @override
  Future onRefresh() {
    max = null;
    viewAt = null;
    return super.onRefresh();
  }

  @override
  onSelect(int index) {
    List list = (loadingState.value as Success).response;
    list[index].checked = !(list[index]?.checked ?? false);
    baseCtr.checkedCount.value =
        list.where((item) => item.checked == true).length;
    loadingState.value = LoadingState.success(list);
    if (baseCtr.checkedCount.value == 0) {
      baseCtr.enableMultiSelect.value = false;
    }
  }

  @override
  void handleSelect([bool checked = false]) {
    if (loadingState.value is Success) {
      List list = (loadingState.value as Success).response;
      if (list.isNotEmpty) {
        loadingState.value = LoadingState.success(
            list.map((item) => item..checked = checked).toList());
        baseCtr.checkedCount.value = checked ? list.length : 0;
      }
    }
    if (checked.not) {
      baseCtr.enableMultiSelect.value = false;
    }
  }

  @override
  bool customHandleResponse(Success response) {
    HistoryData data = response.response;
    isEnd = data.list.isNullOrEmpty || data.list!.length < 20;
    max = data.list?.lastOrNull?.history.oid;
    viewAt = data.list?.lastOrNull?.viewAt;
    if (currentPage == 1) {
      if (type == null && tabs.isEmpty && data.tab?.isNotEmpty == true) {
        tabs.value = data.tab!;
        tabController =
            TabController(length: data.tab!.length + 1, vsync: this);
      }
    } else if (loadingState.value is Success) {
      data.list ??= <HisListItem>[];
      data.list!.insertAll(
        0,
        List<HisListItem>.from((loadingState.value as Success).response),
      );
    }
    loadingState.value = LoadingState.success(data.list);
    return true;
  }

  // 观看历史暂停状态
  Future historyStatus() async {
    var res = await UserHttp.historyStatus();
    if (res['status']) {
      baseCtr.pauseStatus.value = res['data'];
      GStorage.localCache.put(LocalCacheKey.historyPause, res['data']);
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // 删除某条历史记录
  Future delHistory(kid, business) async {
    _onDelete(((loadingState.value as Success).response as List)
        .where((e) => e.kid == kid)
        .toList());
  }

  // 删除已看历史记录
  void onDelHistory() {
    if (loadingState.value is Success) {
      List list = ((loadingState.value as Success).response as List)
          .where((e) => e.progress == -1)
          .toList();
      if (list.isNotEmpty) {
        _onDelete(list);
      } else {
        SmartDialog.showToast('无已看记录');
      }
    }
  }

  void _onDelete(List result) async {
    SmartDialog.showLoading(msg: '请求中');
    List kidList = result.map((item) {
      return '${item.history?.business}_${item.kid}';
    }).toList();
    dynamic response = await UserHttp.delHistory(kidList);
    if (response['status']) {
      List remainList = ((loadingState.value as Success).response as List)
          .toSet()
          .difference(result.toSet())
          .toList();
      if (remainList.isNotEmpty) {
        loadingState.value = LoadingState.success(remainList);
      } else {
        onReload();
      }
      if (baseCtr.enableMultiSelect.value) {
        baseCtr.checkedCount.value = 0;
        baseCtr.enableMultiSelect.value = false;
      }
    }
    SmartDialog.dismiss();
    SmartDialog.showToast(response['msg']);
  }

  // 删除选中的记录
  void onDelCheckedHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确认删除所选历史记录吗？'),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                if (loadingState.value is Success) {
                  _onDelete(((loadingState.value as Success).response as List)
                      .where((e) => e.checked == true)
                      .toList());
                }
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  @override
  Future<LoadingState> customGetData() =>
      UserHttp.historyList(type: type ?? 'all', max: max, viewAt: viewAt);

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }
}
