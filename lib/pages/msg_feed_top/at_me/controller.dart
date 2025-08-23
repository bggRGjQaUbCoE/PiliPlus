import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models_new/msg/msg_at/data.dart';
import 'package:PiliPlus/models_new/msg/msg_at/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AtMeController extends CommonListController<MsgAtData, MsgAtItem> {
  int? cursor;
  int? cursorTime;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<MsgAtItem>? getDataList(MsgAtData response) {
    if (response.cursor?.isEnd == true) {
      isEnd = true;
    }
    cursor = response.cursor?.id;
    cursorTime = response.cursor?.time;
    return response.items;
  }

  @override
  Future<void> onRefresh() {
    cursor = null;
    cursorTime = null;
    return super.onRefresh();
  }

  @override
  Future<LoadingState<MsgAtData>> customGetData() =>
      MsgHttp.msgFeedAtMe(cursor: cursor, cursorTime: cursorTime);

  Future<void> onRemove(Object id, int index) async {
    try {
      var res = await MsgHttp.delMsgfeed(2, id);
      if (res['status']) {
        loadingState
          ..value.data!.removeAt(index)
          ..refresh();
        SmartDialog.showToast('删除成功');
      } else {
        SmartDialog.showToast(res['msg']);
      }
    } catch (_) {}
  }
}
