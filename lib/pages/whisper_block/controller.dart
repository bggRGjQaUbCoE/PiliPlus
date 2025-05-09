import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart';
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class WhisperBlockController extends CommonListController<
    KeywordBlockingListReply, KeywordBlockingItem> {
  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  RxInt count = 0.obs;
  int? listLimit;
  int? charLimit;

  @override
  List<KeywordBlockingItem>? getDataList(KeywordBlockingListReply response) {
    count.value = response.items.length;
    listLimit = response.listLimit;
    charLimit = response.charLimit;
    return response.items;
  }

  @override
  Future<LoadingState<KeywordBlockingListReply>> customGetData() =>
      ImGrpc.keywordBlockingList();

  Future<void> onAdd(String keyword) async {
    final res = await ImGrpc.keywordBlockingAdd(keyword);
    if (res.isSuccess) {
      Get.back();
      loadingState
        ..value.data!.add(KeywordBlockingItem(keyword: keyword))
        ..refresh();
      count.value += 1;
      SmartDialog.showToast('添加成功');
    } else {
      res.toast();
    }
  }

  Future<void> onRemove(KeywordBlockingItem item) async {
    final res = await ImGrpc.keywordBlockingDelete(item.keyword);
    if (res.isSuccess) {
      loadingState
        ..value.data!.remove(item)
        ..refresh();
      count.value -= 1;
      SmartDialog.showToast('删除成功');
    } else {
      res.toast();
    }
  }
}
