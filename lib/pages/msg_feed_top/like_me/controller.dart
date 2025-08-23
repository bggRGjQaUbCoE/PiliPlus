import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models_new/msg/msg_like/data.dart';
import 'package:PiliPlus/models_new/msg/msg_like/item.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LikeMeController
    extends
        CommonDataController<
          MsgLikeData,
          Pair<List<MsgLikeItem>, List<MsgLikeItem>>
        > {
  int? cursor;
  int? cursorTime;

  bool isEnd = false;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<void> queryData([bool isRefresh = true]) {
    if (!isRefresh && isEnd) {
      return Future.value();
    }
    return super.queryData(isRefresh);
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<MsgLikeData> response) {
    MsgLikeData data = response.response;
    if (data.total?.cursor?.isEnd == true ||
        data.total?.items.isNullOrEmpty == true) {
      isEnd = true;
    }
    cursor = data.total?.cursor?.id;
    cursorTime = data.total?.cursor?.time;
    List<MsgLikeItem> latest = data.latest?.items ?? <MsgLikeItem>[];
    List<MsgLikeItem> total = data.total?.items ?? <MsgLikeItem>[];
    if (!isRefresh && loadingState.value.isSuccess) {
      Pair<List<MsgLikeItem>, List<MsgLikeItem>> pair = loadingState.value.data;
      latest.insertAll(0, pair.first);
      total.insertAll(0, pair.second);
    }
    loadingState.value = Success(Pair(first: latest, second: total));
    return true;
  }

  @override
  Future<void> onRefresh() {
    cursor = null;
    cursorTime = null;
    return super.onRefresh();
  }

  @override
  Future<LoadingState<MsgLikeData>> customGetData() =>
      MsgHttp.msgFeedLikeMe(cursor: cursor, cursorTime: cursorTime);

  Future<void> onRemove(Object id, int index, bool isLatest) async {
    try {
      var res = await MsgHttp.delMsgfeed(0, id);
      if (res['status']) {
        Pair<List<MsgLikeItem>, List<MsgLikeItem>> pair =
            loadingState.value.data;
        if (isLatest) {
          pair.first.removeAt(index);
        } else {
          pair.second.removeAt(index);
        }
        loadingState.refresh();
        SmartDialog.showToast('删除成功');
      } else {
        SmartDialog.showToast(res['msg']);
      }
    } catch (_) {}
  }

  Future<void> onSetNotice(MsgLikeItem item, bool isNotice) async {
    int noticeState = isNotice ? 1 : 0;
    var res = await MsgHttp.msgSetNotice(
      id: item.id!,
      noticeState: noticeState,
    );
    if (res['status']) {
      item.noticeState = noticeState;
      loadingState.refresh();
      SmartDialog.showToast('操作成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
