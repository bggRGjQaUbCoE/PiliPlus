import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/card_data_list_item.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/card_list.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/data.dart';
import 'package:PiliPlus/models_new/live/live_second_list/data.dart';
import 'package:PiliPlus/models_new/live/live_second_list/tag.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

class LiveController extends CommonListController {
  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  int? count;

  // area
  int? areaId;
  String? sortType;
  int? parentAreaId;
  final RxInt areaIndex = 0.obs;

  // tag
  final RxInt tagIndex = 0.obs;
  List<LiveSecondTag>? newTags;

  final Rx<Pair<LiveCardList?, LiveCardList?>> topState =
      Pair<LiveCardList?, LiveCardList?>(first: null, second: null).obs;

  @override
  void checkIsEnd(int length) {
    if (count != null && length >= count!) {
      isEnd = true;
    }
  }

  @override
  List? getDataList(response) {
    return response.cardList;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success response) {
    if (isRefresh) {
      final res = response.response;
      if (res case LiveIndexData data) {
        if (data.hasMore == 0) {
          isEnd = true;
        }
        topState.value = Pair(
          first: data.followItem,
          second: data.areaItem,
        );
      } else if (res case LiveSecondData data) {
        count = data.count;
        newTags = data.newTags;
        if (sortType != null) {
          tagIndex.value =
              newTags?.indexWhere((e) => e.sortType == sortType) ?? -1;
        }
      }
    }
    return false;
  }

  @override
  Future<LoadingState> customGetData() {
    if (areaIndex.value != 0) {
      return LiveHttp.liveSecondList(
        pn: page,
        areaId: areaId,
        parentAreaId: parentAreaId,
        sortType: sortType,
      );
    }
    return LiveHttp.liveFeedIndex(pn: page);
  }

  @override
  Future<void> onRefresh() {
    count = null;
    page = 1;
    isEnd = false;
    if (areaIndex.value != 0) {
      queryTop();
    }
    return queryData();
  }

  Future<void> queryTop() async {
    final res = await LiveHttp.liveFeedIndex(pn: page, moduleSelect: true);
    if (res.isSuccess) {
      final data = res.data;
      topState.value = Pair(
        first: data.followItem,
        second: data.areaItem,
      );
      areaIndex.value =
          (data.areaItem?.cardData?.areaEntranceV3?.list?.indexWhere(
                (e) => e.areaV2Id == areaId && e.areaV2ParentId == parentAreaId,
              ) ??
              -2) +
          1;
    }
  }

  void onSelectArea(int index, CardLiveItem? cardLiveItem) {
    if (isLoading) {
      return; // areaIndex conflict
    }
    if (index == areaIndex.value) {
      return;
    }
    tagIndex.value = 0;
    newTags = null;
    sortType = null;
    areaIndex.value = index;
    areaId = cardLiveItem?.areaV2Id;
    parentAreaId = cardLiveItem?.areaV2ParentId;

    count = null;
    page = 1;
    isEnd = false;
    queryData();
  }

  void onSelectTag(int index, String? sortType) {
    if (isLoading) {
      return;
    }
    tagIndex.value = index;
    this.sortType = sortType;

    count = null;
    page = 1;
    isEnd = false;
    queryData();
  }
}
