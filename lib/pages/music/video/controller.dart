import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/music.dart';
import 'package:PiliPlus/models_new/music/bgm_detail.dart';
import 'package:PiliPlus/models_new/music/bgm_recommend_list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef MusicRecommendArgs = ({String id, MusicDetail item});

class MusicRecommendController
    extends CommonListController<List<BgmRecommend>?, BgmRecommend> {
  late final String musicId;
  late final MusicDetail musicDetail;

  final Rx<MusicRecommendOrderType> order =
      MusicRecommendOrderType.defaultOrder.obs;
  List<BgmRecommend>? originalList;

  final isSearchMode = false.obs;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    final MusicRecommendArgs args = Get.arguments;
    musicId = args.id;
    musicDetail = args.item;
    searchController.addListener(_onSearchChanged);
    queryData();
  }

  void _onSearchChanged() {
    applySortAndFilter();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  @override
  void checkIsEnd(int length) {
    isEnd = true;
  }

  @override
  Future<LoadingState<List<BgmRecommend>?>> customGetData() =>
      MusicHttp.bgmRecommend(musicId);

  @override
  bool customHandleResponse(
      bool isRefresh, Success<List<BgmRecommend>?> response) {
    if (response.response != null) {
      originalList = List.from(response.response!);
      isEnd = true;
      applySortAndFilter();
    } else {
      loadingState.value = Success(null);
    }
    return true;
  }

  void applySortAndFilter() {
    if (originalList == null) return;
    
    List<BgmRecommend> filtered = originalList!;
    final keyword = searchController.text.trim().toLowerCase();
    
    if (keyword.isNotEmpty) {
      filtered = filtered.where((item) {
        return (item.title?.toLowerCase().contains(keyword) ?? false) ||
            (item.upNickName?.toLowerCase().contains(keyword) ?? false);
      }).toList();
    }
    
    if (order.value != MusicRecommendOrderType.defaultOrder) {
      filtered = List.from(filtered);
      filtered.sort((a, b) {
        switch (order.value) {
          case MusicRecommendOrderType.play:
            return (b.play ?? 0).compareTo(a.play ?? 0);
          case MusicRecommendOrderType.danmu:
            return (b.danmu ?? 0).compareTo(a.danmu ?? 0);
          case MusicRecommendOrderType.duration:
            return (b.duration ?? 0).compareTo(a.duration ?? 0);
          case MusicRecommendOrderType.defaultOrder:
            return 0;
        }
      });
    }
    
    loadingState.value = Success(filtered);
  }
}
