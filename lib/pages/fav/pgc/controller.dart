import 'package:PiliPlus/http/bangumi.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/bangumi/list.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FavPgcController
    extends MultiSelectController<BangumiListDataModel, BangumiListItemModel> {
  final int type;
  final int followStatus;

  FavPgcController(this.type, this.followStatus);

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  void onSelect(int index, [bool disableSelect = true]) {
    super.onSelect(index, false);
  }

  @override
  void handleSelect([bool checked = false, bool disableSelect = true]) {
    allSelected.value = checked;
    super.handleSelect(checked, false);
  }

  @override
  List<BangumiListItemModel>? getDataList(BangumiListDataModel response) {
    return response.list;
  }

  @override
  Future<LoadingState<BangumiListDataModel>> customGetData() =>
      BangumiHttp.bangumiFollowList(
        mid: Accounts.main.mid,
        type: type,
        followStatus: followStatus,
        pn: currentPage,
      );

  void onDisable() {
    if (checkedCount.value != 0) {
      handleSelect();
    }
    enableMultiSelect.value = false;
  }

  // 取消追番
  Future bangumiDel(index, seasonId) async {
    var result = await VideoHttp.bangumiDel(seasonId: seasonId);
    if (result['status']) {
      loadingState.value.data!.removeAt(index);
      loadingState.refresh();
    }
    SmartDialog.showToast(result['msg']);
  }

  Future onUpdateList(followStatus) async {
    List<BangumiListItemModel> dataList =
        (loadingState.value as Success).response as List<BangumiListItemModel>;
    Set<BangumiListItemModel> updateList =
        dataList.where((item) => item.checked == true).toSet();
    final res = await VideoHttp.bangumiUpdate(
      seasonId: updateList.map((item) => item.seasonId).toList(),
      status: followStatus,
    );
    if (res['status']) {
      List<BangumiListItemModel> remainList =
          dataList.toSet().difference(updateList).toList();
      loadingState.value = LoadingState.success(remainList);
      enableMultiSelect.value = false;
      try {
        final ctr = Get.find<FavPgcController>(tag: '$type$followStatus');
        if (ctr.loadingState.value is Success) {
          ctr.loadingState.value.data!
              .insertAll(0, updateList.map((item) => item..checked = null));
          ctr.loadingState.refresh();
          ctr.allSelected.value = false;
        }
      } catch (e) {
        debugPrint('fav pgc onUpdate: $e');
      }
    }
    SmartDialog.showToast(res['msg']);
  }

  Future onUpdate(index, followStatus, seasonId) async {
    var result = await VideoHttp.bangumiUpdate(
      seasonId: [seasonId],
      status: followStatus,
    );
    if (result['status']) {
      List<BangumiListItemModel> list =
          (loadingState.value as Success).response;
      final item = list.removeAt(index);
      loadingState.refresh();
      try {
        final ctr = Get.find<FavPgcController>(tag: '$type$followStatus');
        if (ctr.loadingState.value is Success) {
          ctr.loadingState.value.data!.insert(0, item);
          ctr.loadingState.refresh();
          ctr.allSelected.value = false;
        }
      } catch (e) {
        debugPrint('fav pgc bangumiUpdate: $e');
      }
    }
    SmartDialog.showToast(result['msg']);
  }
}
