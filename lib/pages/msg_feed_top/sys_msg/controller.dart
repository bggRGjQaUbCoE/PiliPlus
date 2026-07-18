import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models_new/msg/msg_sys/data.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class SysMsgController
    extends CommonListController<List<MsgSysItem>?, MsgSysItem> {
  int? cursor;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  void handleListResponse(List<MsgSysItem> dataList) {
    if (cursor == null) {
      msgSysUpdateCursor(dataList.first.cursor);
    }
    cursor = dataList.last.cursor;
  }

  void msgSysUpdateCursor(int? cursor) {
    if (cursor != null) {
      MsgHttp.msgSysUpdateCursor(cursor);
    }
  }

  @override
  Future<void> onRefresh() {
    cursor = null;
    return super.onRefresh();
  }

  Future<void> onRemove(dynamic id, int index) async {
    try {
      final res = await MsgHttp.delSysMsg(id);
      if (res.isSuccess) {
        final removed = loadingState.value.dataOrNull?.removeFirstWhere(
          (item) => item.id == id,
        );
        if (removed == true) loadingState.refresh();
        SmartDialog.showToast('删除成功');
      } else {
        res.toast();
      }
    } catch (_) {}
  }

  @override
  Future<LoadingState<List<MsgSysItem>?>> customGetData() =>
      MsgHttp.msgFeedNotify(cursor: cursor);
}
