import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/user/fav_detail.dart';
import 'package:PiliPlus/pages/common/common_search_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FavSearchController
    extends CommonSearchController<FavDetailData, FavDetailItemData> {
  int type = Get.arguments['type'];
  int mediaId = Get.arguments['mediaId'];
  bool isOwner = Get.arguments['isOwner'];
  dynamic count = Get.arguments['count'];
  dynamic title = Get.arguments['title'];

  @override
  Future<LoadingState<FavDetailData>> customGetData() =>
      UserHttp.userFavFolderDetail(
        pn: currentPage,
        ps: 20,
        mediaId: mediaId,
        keyword: editController.text,
        type: type,
      );

  @override
  List<FavDetailItemData>? getDataList(FavDetailData response) {
    return response.list;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<FavDetailData> response) {
    if (response.response.hasMore == false) {
      isEnd = true;
    }
    return false;
  }

  Future<void> onCancelFav(int index, int id, int? type) async {
    var result = await VideoHttp.favVideo(
      aid: id,
      addIds: '',
      delIds: mediaId.toString(),
      type: type,
    );
    if (result['status']) {
      loadingState.value.data!.removeAt(index);
      loadingState.refresh();
      SmartDialog.showToast('取消收藏');
    }
  }
}
