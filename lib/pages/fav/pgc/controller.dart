import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/data.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/list.dart';
import 'package:PiliPlus/pages/common/multi_select/multi_select_controller.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
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
  final RxBool allSelected = false.obs;

  @override
  void handleSelect({bool checked = false, bool disableSelect = true}) {
    allSelected.value = checked;
    super.handleSelect(checked: checked, disableSelect: disableSelect);
  }

  @override
  List<FavPgcItemModel>? getDataList(FavPgcData response) {
    return response.list;
  }

  @override
  Future<LoadingState<FavPgcData>> customGetData() => FavHttp.favPgc(
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
    final result = await VideoHttp.pgcDel(seasonId: seasonId);
    if (result case Success(:final response)) {
      final removed = loadingState.value.dataOrNull?.removeFirstWhere(
        (item) => item.seasonId == seasonId,
      );
      if (removed == true) {
        loadingState.refresh();
        if (!isEnd) onRefresh().ignore();
      }
      SmartDialog.showToast(response);
    } else {
      result.toast();
    }
  }

  @override
  void onRemove() {
    assert(false, 'call onUpdateList');
  }

  Future<void> onUpdateList(int followStatus) async {
    final removeList = allChecked.toSet();
    final seasonIds = removeList.map((item) => item.seasonId).toSet();
    final res = await VideoHttp.pgcUpdate(
      seasonId: removeList.map((item) => item.seasonId).join(','),
      status: followStatus,
    );
    if (res case Success(:final response)) {
      try {
        final ctr = Get.find<FavPgcController>(tag: '$type$followStatus');
        if (ctr.loadingState.value case Success(:final response)) {
          if (response != null) {
            final targetIds = response.map((item) => item.seasonId).toSet();
            final missingItems = <FavPgcItemModel>[];
            for (final item in removeList) {
              item.checked = false;
              if (targetIds.add(item.seasonId)) missingItems.add(item);
            }
            response.insertAll(0, missingItems);
          }
          ctr
            ..loadingState.refresh()
            ..allSelected.value = false;
          if (!ctr.isEnd) ctr.onRefresh().ignore();
        }
      } catch (e) {
        if (kDebugMode) debugPrint('fav pgc onUpdate: $e');
      }
      await afterDeleteWhere((item) => seasonIds.contains(item.seasonId));
      SmartDialog.showToast(response);
    } else {
      res.toast();
    }
  }

  Future<void> onUpdate(int index, int followStatus, int? seasonId) async {
    final res = await VideoHttp.pgcUpdate(
      seasonId: seasonId.toString(),
      status: followStatus,
    );
    if (res case Success(:final response)) {
      final list = loadingState.value.dataOrNull;
      final currentIndex = list?.indexWhere(
        (item) => item.seasonId == seasonId,
      );
      if (list != null && currentIndex != null && currentIndex != -1) {
        final item = list.removeAt(currentIndex);
        loadingState.refresh();
        if (!isEnd) onRefresh().ignore();
        try {
          final ctr = Get.find<FavPgcController>(tag: '$type$followStatus');
          if (ctr.loadingState.value case Success(:final response)) {
            item.checked = false;
            if (response != null &&
                !response.any(
                  (current) => current.seasonId == item.seasonId,
                )) {
              response.insert(0, item);
            }
            ctr
              ..loadingState.refresh()
              ..allSelected.value = false;
            if (!ctr.isEnd) ctr.onRefresh().ignore();
          }
        } catch (e) {
          if (kDebugMode) debugPrint('fav pgc pgcUpdate: $e');
        }
      }
      SmartDialog.showToast(response);
    } else {
      res.toast();
    }
  }
}
