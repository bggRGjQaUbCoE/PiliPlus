import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/pages/common/common_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LaterSearchController
    extends CommonSearchController<Map, HotVideoItemModel> {
  dynamic mid = Get.arguments['mid'];
  dynamic count = Get.arguments['count'];

  @override
  Future<LoadingState<Map>> customGetData() => UserHttp.seeYouLater(
        page: currentPage,
        keyword: editController.value.text,
      );

  @override
  List<HotVideoItemModel>? getDataList(Map response) {
    return response['list'];
  }

  Future toViewDel(BuildContext context, int index, aid) async {
    var res = await UserHttp.toViewDel(aids: [aid]);
    if (res['status']) {
      loadingState.value.data!.removeAt(index);
      loadingState.refresh();
    }
    SmartDialog.showToast(res['msg']);
  }
}
