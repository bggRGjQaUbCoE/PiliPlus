import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models_new/msg/msg_like/data.dart';
import 'package:PiliPlus/models_new/msg/msg_like/item.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:PiliPlus/utils/async_operation_guard.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
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
  final _noticeGuard = AsyncKeyedOperationGuard<Object>();

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<void> queryData([bool isRefresh = true]) {
    if (!isRefresh && isEnd) {
      return Future.syncValue(null);
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
    if (!isRefresh) {
      if (loadingState.value case Success(:final response)) {
        latest.insertAll(0, response.first);
        total.insertAll(0, response.second);
      }
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

  Future<void> onRemove(dynamic id) async {
    try {
      final res = await MsgHttp.delMsgfeed(0, id);
      if (res.isSuccess) {
        final pair = loadingState.value.dataOrNull;
        final removedLatest =
            pair?.first.removeFirstWhere((item) => item.id == id) == true;
        final removedTotal =
            pair?.second.removeFirstWhere((item) => item.id == id) == true;
        if (removedLatest || removedTotal) {
          loadingState.refresh();
        }
        SmartDialog.showToast('删除成功');
      } else {
        res.toast();
      }
    } catch (_) {}
  }

  Future<void> onSetNotice(MsgLikeItem item, bool isNotice) {
    final id = item.id;
    if (id == null) return Future<void>.value();
    return _noticeGuard.run(id, () async {
      final noticeState = isNotice ? 1 : 0;
      final res = await MsgHttp.msgSetNotice(
        id: id,
        noticeState: noticeState,
      );
      if (res.isSuccess) {
        final pair = loadingState.value.dataOrNull;
        bool updated = false;
        for (final list in [pair?.first, pair?.second]) {
          if (list == null) continue;
          for (final current in list.where((item) => item.id == id)) {
            current.noticeState = noticeState;
            updated = true;
          }
        }
        if (updated) loadingState.refresh();
        SmartDialog.showToast('设置成功');
      } else {
        res.toast();
      }
    });
  }
}
