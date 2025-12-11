import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_feed/item.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_feed/topic_card_list.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_feed/topic_sort_by_conf.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_top/top_details.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DynTopicController
    extends CommonListController<TopicCardList?, TopicCardItem> {
  final topicId = Get.parameters['id']!;
  String topicName = Get.parameters['name'] ?? '';

  int sortBy = 0;
  String offset = '';
  Rx<TopicSortByConf?> topicSortByConf = Rx<TopicSortByConf?>(null);

  double? appbarOffset;

  // top
  Rx<bool?> isFav = Rx<bool?>(null);
  Rx<bool?> isLike = Rx<bool?>(null);
  Rx<LoadingState<TopDetails?>> topState =
      LoadingState<TopDetails?>.loading().obs;

  late final isLogin = Accounts.main.isLogin;

  @override
  void onInit() {
    super.onInit();
    queryTop();
    queryData();
  }

  Future<void> queryTop() async {
    topState.value = await DynamicsHttp.topicTop(topicId: topicId);
    if (topState.value.isSuccess) {
      var topicItem = topState.value.data!.topicItem!;
      topicName = topicItem.name;
      isFav.value = topicItem.isFav;
      isLike.value = topicItem.isLike;
    }
  }

  @override
  List<TopicCardItem>? getDataList(TopicCardList? response) {
    offset = response?.offset ?? '';
    topicSortByConf.value = response?.topicSortByConf;
    sortBy = response?.topicSortByConf?.showSortBy ?? 0;
    if (response?.hasMore == false) {
      isEnd = true;
    }
    return response?.items;
  }

  @override
  Future<void> onRefresh() {
    offset = '';
    queryTop();
    return super.onRefresh();
  }

  @override
  Future<void> onReload() {
    if (appbarOffset != null) {
      if (scrollController.hasClients &&
          scrollController.offset > appbarOffset!) {
        scrollController.jumpTo(appbarOffset!);
      }
    } else {
      scrollController.jumpToTop();
    }
    return super.onReload();
  }

  @override
  Future<LoadingState<TopicCardList?>> customGetData() =>
      DynamicsHttp.topicFeed(
        topicId: topicId,
        offset: offset,
        sortBy: sortBy,
      );

  void onSort(int sortBy) {
    this.sortBy = sortBy;
    onReload();
  }

  Future<void> onFav() async {
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    bool isFav = this.isFav.value ?? false;
    var res = isFav
        ? await FavHttp.delFavTopic(topicId)
        : await FavHttp.addFavTopic(topicId);
    if (res.isSuccess) {
      if (isFav) {
        topState.value.data!.topicItem!.fav -= 1;
      } else {
        topState.value.data!.topicItem!.fav += 1;
      }
      this.isFav.value = !isFav;
    } else {
      res.toast();
    }
  }

  Future<void> onLike() async {
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    bool isLike = this.isLike.value ?? false;
    var res = await FavHttp.likeTopic(topicId, isLike);
    if (res.isSuccess) {
      if (isLike) {
        topState.value.data!.topicItem!.like -= 1;
      } else {
        topState.value.data!.topicItem!.like += 1;
      }
      this.isLike.value = !isLike;
    } else {
      res.toast();
    }
  }
}
