import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_topic/data.dart';
import 'package:PiliPlus/models_new/fav/fav_topic/topic_item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class FavTopicController
    extends CommonListController<FavTopicData, FavTopicItem> {
  int? total;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  void checkIsEnd(int length) {
    if (total != null && length >= total!) {
      isEnd = true;
    }
  }

  @override
  List<FavTopicItem>? getDataList(FavTopicData response) {
    total = response.topicList?.pageInfo?.total;
    return response.topicList?.topicItems;
  }

  @override
  Future<void> onRefresh() {
    total = null;
    return super.onRefresh();
  }

  @override
  Future<LoadingState<FavTopicData>> customGetData() =>
      FavHttp.favTopic(page: page);

  Future<void> onRemove(int index, int id) async {
    final res = await FavHttp.delFavTopic(id);
    if (res.isSuccess) {
      final removed = loadingState.value.dataOrNull?.removeFirstWhere(
        (item) => item.id == id,
      );
      if (removed == true) {
        loadingState.refresh();
        if (!isEnd) onRefresh().ignore();
      }
      SmartDialog.showToast('已取消收藏');
    } else {
      res.toast();
    }
  }
}
