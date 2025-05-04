import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/black.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/user/black.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class BlackListController
    extends CommonListController<BlackListDataModel, BlackListItem> {
  int pageSize = 50;
  RxInt total = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<BlackListItem>? getDataList(BlackListDataModel response) {
    return response.list;
  }

  @override
  void checkIsEnd(int length) {
    if (length >= total.value) {
      isEnd = true;
    }
  }

  @override
  bool customHandleResponse(
      bool isRefresh, Success<BlackListDataModel> response) {
    total.value = response.response.total ?? 0;
    return false;
  }

  Future onRemove(BuildContext context, int index, name, mid) async {
    showConfirmDialog(
      context: context,
      title: '确定将 $name 移出黑名单？',
      onConfirm: () async {
        var result = await VideoHttp.relationMod(mid: mid, act: 6, reSrc: 11);
        if (result['status']) {
          loadingState.value.data!.removeAt(index);
          total.value -= 1;
          loadingState.refresh();
          SmartDialog.showToast('操作成功');
        }
      },
    );
  }

  @override
  Future<LoadingState<BlackListDataModel>> customGetData() =>
      BlackHttp.blackList(pn: currentPage, ps: pageSize);
}
