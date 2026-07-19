import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart';
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/async_operation_guard.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class WhisperBlockController
    extends
        CommonListController<KeywordBlockingListReply, KeywordBlockingItem> {
  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  RxInt count = 0.obs;
  final RxBool isAdding = false.obs;
  final _removeGuard = AsyncKeyedOperationGuard<String>();
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

  Future<bool> onAdd(String keyword) async {
    if (isAdding.value) {
      return false;
    }
    isAdding.value = true;
    try {
      final res = await ImGrpc.keywordBlockingAdd(keyword);
      if (res.isSuccess) {
        final list = loadingState.value.dataOrNull;
        if (list != null && !list.any((item) => item.keyword == keyword)) {
          list.add(KeywordBlockingItem(keyword: keyword));
          loadingState.refresh();
          count.value += 1;
        }
        SmartDialog.showToast('添加成功');
        return true;
      }
      res.toast();
      return false;
    } finally {
      isAdding.value = false;
    }
  }

  Future<void> onRemove(KeywordBlockingItem item) {
    final keyword = item.keyword;
    return _removeGuard.run(keyword, () async {
      final res = await ImGrpc.keywordBlockingDelete(keyword);
      if (res.isSuccess) {
        final removed = loadingState.value.dataOrNull?.removeFirstWhere(
          (item) => item.keyword == keyword,
        );
        if (removed == true) {
          loadingState.refresh();
          if (count.value > 0) count.value -= 1;
        }
        SmartDialog.showToast('删除成功');
      } else {
        res.toast();
      }
    });
  }
}
