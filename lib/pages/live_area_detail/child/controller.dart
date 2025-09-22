import 'dart:math';

import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/card_data_list_item.dart';
import 'package:PiliPlus/models_new/live/live_second_list/data.dart';
import 'package:PiliPlus/models_new/live/live_second_list/tag.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

class LiveAreaChildController
    extends CommonListController<LiveSecondData, CardLiveItem> {
  LiveAreaChildController(this.areaId, this.parentAreaId);
  final dynamic areaId;
  final dynamic parentAreaId;

  int? count;

  String? sortType;

  // tag
  final RxInt tagIndex = 0.obs;
  List<LiveSecondTag>? newTags;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  void checkIsEnd(int length) {
    if (count != null && length >= count!) {
      isEnd = true;
    }
  }

  @override
  List<CardLiveItem>? getDataList(LiveSecondData response) {
    count = response.count;
    newTags = response.newTags;
    tagIndex.value = max(
      0,
      newTags?.indexWhere((e) => e.sortType == sortType) ?? 0,
    );
    return response.cardList;
  }

  @override
  Future<LoadingState<LiveSecondData>> customGetData() =>
      LiveHttp.liveSecondList(
        pn: page,
        areaId: areaId,
        parentAreaId: parentAreaId,
        sortType: sortType,
      );

  void onSelectTag(int index, String? sortType) {
    if (isLoading) {
      return;
    }
    tagIndex.value = index;
    this.sortType = sortType;

    onRefresh();
  }
}
