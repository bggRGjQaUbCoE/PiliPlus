import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/user/sub_folder.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class SubController
    extends CommonListController<List<SubFolderItemData>?, SubFolderItemData> {
  dynamic mid;

  @override
  void onInit() {
    super.onInit();
    mid = Accounts.main.mid;
    queryData();
  }

  @override
  Future queryData([bool isRefresh = true]) {
    if (mid == 0) {
      loadingState.value = LoadingState.error('账号未登录');
      return Future.value();
    }
    return super.queryData(isRefresh);
  }

  // 取消订阅
  Future<void> cancelSub(SubFolderItemData subFolderItem) async {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('确定取消订阅吗？'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              '取消',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () async {
              var res = await UserHttp.cancelSub(
                  id: subFolderItem.id!, type: subFolderItem.type!);
              if (res['status']) {
                loadingState.value.data!.remove(subFolderItem);
                loadingState.refresh();
                SmartDialog.showToast('取消订阅成功');
              } else {
                SmartDialog.showToast(res['msg']);
              }
              Get.back();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Future<LoadingState<List<SubFolderItemData>?>> customGetData() =>
      UserHttp.userSubFolder(
        pn: currentPage,
        ps: 20,
        mid: mid,
      );
}
