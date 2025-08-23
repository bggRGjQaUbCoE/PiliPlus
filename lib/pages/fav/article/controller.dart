import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_article/data.dart';
import 'package:PiliPlus/models_new/fav/fav_article/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class FavArticleController
    extends CommonListController<FavArticleData, FavArticleItemModel> {
  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<FavArticleItemModel>? getDataList(FavArticleData response) {
    if (response.hasMore == false) {
      isEnd = true;
    }
    return response.items;
  }

  @override
  Future<LoadingState<FavArticleData>> customGetData() =>
      FavHttp.favArticle(page: page);

  Future<void> onRemove(int index, String id) async {
    final res = await FavHttp.communityAction(opusId: id, action: 4);
    if (res['status']) {
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
      SmartDialog.showToast('已取消收藏');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
