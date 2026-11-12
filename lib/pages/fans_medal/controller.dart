import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_config_plugs/data.dart';
import 'package:PiliPlus/models_new/live/live_fans_medal/data.dart';
import 'package:PiliPlus/models_new/live/live_fans_medal/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart' show RxnInt;

class FansMedalController
    extends CommonListController<FansMedalData, FansMedalItem> {
  final count = RxnInt();

  ConfigPlusData? config;

  Future<bool> getConfigPlus() async {
    final res = await LiveHttp.liveConfigPlugs();
    if (res case Success(:final response)) {
      config = response;
      return true;
    } else {
      res.toast();
      return false;
    }
  }

  Future<bool> setConfigPlus({
    required String key,
    required bool status,
  }) async {
    final res = await LiveHttp.liveEditPlugs(key: key, status: status ? 1 : 0);
    if (res.isSuccess) {
      switch (key) {
        case ConfigPlusData.kCloseSpaceMedalKey:
          config!.closeSpaceMedal = status;
        case ConfigPlusData.kOnlyShowWearingKey:
          config!.onlyShowWearing = status;
      }
      return true;
    } else {
      res.toast();
      return false;
    }
  }

  @override
  void checkIsEnd(int length) {
    final count = this.count.value;
    if (count != null && length >= count) {
      isEnd = true;
    }
  }

  @override
  List<FansMedalItem>? getDataList(FansMedalData response) {
    count.value = response.totalNumber;
    return response.list;
  }

  @override
  Future<LoadingState<FansMedalData>> customGetData() =>
      LiveHttp.fansMedalPanel(page: page);

  Future<bool> onWear(FansMedalItem item, {bool refresh = true}) async {
    final res = await LiveHttp.wearFansMedal(medalId: item.uinfoMedal.id!);
    if (res.isSuccess) {
      for (final e in loadingState.value.data!) {
        if (e.medal.wearingStatus == 1) {
          e.medal.wearingStatus = 0;
          break;
        }
      }
      item.medal.wearingStatus = 1;
      if (refresh) loadingState.refresh();
      return true;
    } else {
      res.toast();
      return false;
    }
  }

  Future<bool> onTakeOff(FansMedalItem item, {bool refresh = true}) async {
    final res = await LiveHttp.takeOffFansMedal();
    if (res.isSuccess) {
      item.medal.wearingStatus = 0;
      if (refresh) loadingState.refresh();
      return true;
    } else {
      res.toast();
      return false;
    }
  }

  Future<void> onDel(FansMedalItem item) async {
    if (kDebugMode) {
      loadingState
        ..value.data!.remove(item)
        ..refresh();
      return;
    }
    // final res = await LiveHttp.delFansMedal(medalId: item.uinfoMedal.id!);
    // if (res.isSuccess) {
    //   loadingState
    //     ..value.data!.remove(item)
    //     ..refresh();
    // } else {
    //   res.toast();
    // }
  }
}
