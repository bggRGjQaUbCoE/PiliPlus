import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space_cheese/data.dart';
import 'package:PiliPlus/models_new/space/space_cheese/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class FavCheeseController
    extends CommonListController<SpaceCheeseData, SpaceCheeseItem> {
  final mid = Accounts.main.mid;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<SpaceCheeseItem>? getDataList(SpaceCheeseData response) {
    isEnd = response.page?.next == false;
    return response.items;
  }

  @override
  Future<LoadingState<SpaceCheeseData>> customGetData() =>
      FavHttp.favPugv(mid: mid, page: page);

  Future<void> onRemove(int index, int sid) async {
    final res = await FavHttp.delFavPugv(sid);
    if (res.isSuccess) {
      final removed = loadingState.value.dataOrNull?.removeFirstWhere(
        (item) => item.seasonId == sid,
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
