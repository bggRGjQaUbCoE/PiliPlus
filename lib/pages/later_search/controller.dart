import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models_new/later/data.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/common/common_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LaterSearchController
    extends CommonSearchController<LaterData, LaterItemModel> {
  dynamic mid = Get.arguments['mid'];
  dynamic count = Get.arguments['count'];

  @override
  Future<LoadingState<LaterData>> customGetData() => UserHttp.seeYouLater(
    page: page,
    keyword: editController.value.text,
  );

  @override
  List<LaterItemModel>? getDataList(LaterData response) {
    return response.list;
  }

  Future<void> toViewDel(BuildContext context, int index, int aid) async {
    var res = await UserHttp.toViewDel(aids: [aid]);
    if (res['status']) {
      loadingState.value.data!.removeAt(index);
      loadingState.refresh();
    }
    SmartDialog.showToast(res['msg']);
  }

  // @override
  // void onConfirm() {
  //   showConfirmDialog(
  //     context: Get.context!,
  //     content: '确认删除所选稍后再看吗？',
  //     title: '提示',
  //     onConfirm: () async {
  //       final result = allChecked.toSet();
  //       SmartDialog.showLoading(msg: '请求中');
  //       var res = await UserHttp.toViewDel(
  //         aids: result.map((item) => item.aid!),
  //       );
  //       if (res['status']) {
  //         afterDelete(result);
  //       }
  //       SmartDialog.dismiss();
  //       SmartDialog.showToast(res['msg']);
  //     },
  //   );
  // }
}
