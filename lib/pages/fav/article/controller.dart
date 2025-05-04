import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class FavArticleController extends CommonListController {
  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List? getDataList(response) {
    return response?['items'];
  }

  @override
  bool customHandleResponse(bool isRefresh, Success response) {
    if (response.response?['has_more'] == false) {
      isEnd = true;
    }
    return false;
  }

  @override
  Future<LoadingState> customGetData() =>
      UserHttp.favArticle(page: currentPage);

  Future<void> onRemove(index, id) async {
    final res = await UserHttp.communityAction(opusId: id, action: 4);
    if (res['status']) {
      loadingState.value.data!.removeAt(index);
      loadingState.refresh();
      SmartDialog.showToast('已取消收藏');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
