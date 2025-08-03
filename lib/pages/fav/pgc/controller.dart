import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/data.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/list.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FavPgcController
    extends MultiSelectController<FavPgcData, FavPgcItemModel> {
  final int type;
  final int followStatus;

  FavPgcController(this.type, this.followStatus);

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  void onSelect(FavPgcItemModel item, [bool disableSelect = true]) {
    super.onSelect(item, false);
  }

  @override
  void handleSelect([bool checked = false, bool disableSelect = true]) {
    allSelected.value = checked;
    super.handleSelect(checked, false);
  }

  @override
  List<FavPgcItemModel>? getDataList(FavPgcData response) {
    return response.list;
  }

  @override
  Future<LoadingState<FavPgcData>> customGetData() => FavHttp.favPgc(
    mid: Accounts.main.mid,
    type: type,
    followStatus: followStatus,
    pn: page,
  );

  void onDisable() {
    if (checkedCount != 0) {
      handleSelect();
    }
    enableMultiSelect.value = false;
  }

  // 取消追番
  Future<void> pgcDel(int index, seasonId) async {
    var result = await VideoHttp.pgcDel(seasonId: seasonId);
    if (result['status']) {
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
    }
    SmartDialog.showToast(result['msg']);
  }

  @override
  void onConfirm() {
    assert(false, 'call onUpdateList');
  }

  Future<void> onUpdateList(int followStatus) async {
    final updateList = allChecked.toSet();
    final res = await VideoHttp.pgcUpdate(
      seasonId: updateList.map((item) => item.seasonId).toList(),
      status: followStatus,
    );
    if (res['status']) {
      afterDelete(updateList);
      try {
        final ctr = Get.find<FavPgcController>(tag: '$type$followStatus');
        if (ctr.loadingState.value.isSuccess) {
          ctr.loadingState
            ..value.data!.insertAll(
              0,
              updateList.map((item) => item..checked = null),
            )
            ..refresh();
          ctr.allSelected.value = false;
        }
      } catch (e) {
        if (kDebugMode) debugPrint('fav pgc onUpdate: $e');
      }
    }
    SmartDialog.showToast(res['msg']);
  }

  Future<void> onUpdate(int index, int followStatus, int? seasonId) async {
    var result = await VideoHttp.pgcUpdate(
      seasonId: [seasonId],
      status: followStatus,
    );
    if (result['status']) {
      List<FavPgcItemModel> list = loadingState.value.data!;
      final item = list.removeAt(index);
      loadingState.refresh();
      try {
        final ctr = Get.find<FavPgcController>(tag: '$type$followStatus');
        if (ctr.loadingState.value.isSuccess) {
          ctr.loadingState
            ..value.data?.insert(0, item)
            ..refresh();
          ctr.allSelected.value = false;
        }
      } catch (e) {
        if (kDebugMode) debugPrint('fav pgc pgcUpdate: $e');
      }
    }
    SmartDialog.showToast(result['msg']);
  }
}
