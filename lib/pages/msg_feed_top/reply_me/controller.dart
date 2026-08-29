import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models_new/msg/msg_reply/data.dart';
import 'package:PiliPlus/models_new/msg/msg_reply/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ReplyMeController
    extends CommonListController<MsgReplyData, MsgReplyItem> {
  int? cursor;
  int? cursorTime;
  final RxString searchQuery = ''.obs;
  int _searchGeneration = 0;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<MsgReplyItem>? getDataList(MsgReplyData response) {
    if (response.cursor?.isEnd == true) {
      isEnd = true;
    }
    cursor = response.cursor?.id;
    cursorTime = response.cursor?.time;
    return response.items;
  }

  @override
  void resetForRefresh() {
    super.resetForRefresh();
    cursor = null;
    cursorTime = null;
  }

  @override
  Future<LoadingState<MsgReplyData>> customGetData() =>
      MsgHttp.msgFeedReplyMe(cursor: cursor, cursorTime: cursorTime);

  List<MsgReplyItem> visibleItems(List<MsgReplyItem> items) {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((item) {
      final fields = [
        item.user?.nickname,
        item.item?.business,
        item.item?.sourceContent,
        item.item?.targetReplyContent,
        item.item?.rootReplyContent,
      ];
      return fields.any(
        (value) => value?.toLowerCase().contains(query) == true,
      );
    }).toList();
  }

  Future<void> updateSearch(String value) async {
    searchQuery.value = value.trim();
    final generation = ++_searchGeneration;
    if (searchQuery.value.isEmpty) return;
    for (var attempt = 0; attempt < 5 && !isEnd; attempt++) {
      if (generation != _searchGeneration) return;
      final items = loadingState.value.dataOrNull;
      if (items != null && visibleItems(items).isNotEmpty) return;
      await onLoadMore();
    }
  }

  Future<void> onRemove(dynamic id) async {
    try {
      final res = await MsgHttp.delMsgfeed(1, id);
      if (res.isSuccess) {
        loadingState.value.data!.removeWhere((item) => item.id == id);
        loadingState.refresh();
        SmartDialog.showToast('删除成功');
      } else {
        res.toast();
      }
    } catch (_) {}
  }
}
