import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/msg/msgfeed_reply_me.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ReplyMeController
    extends CommonListController<MsgFeedReplyMe, ReplyMeItems> {
  int cursor = -1;
  int cursorTime = -1;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<ReplyMeItems>? getDataList(MsgFeedReplyMe response) {
    return response.items;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<MsgFeedReplyMe> response) {
    final data = response.response;
    if (data.cursor?.isEnd == true) {
      isEnd = true;
    }
    cursor = data.cursor?.id ?? -1;
    cursorTime = data.cursor?.time ?? -1;
    return false;
  }

  @override
  Future onRefresh() {
    cursor = -1;
    cursorTime = -1;
    return super.onRefresh();
  }

  @override
  Future<LoadingState<MsgFeedReplyMe>> customGetData() =>
      MsgHttp.msgFeedReplyMe(cursor: cursor, cursorTime: cursorTime);

  Future onRemove(dynamic id, int index) async {
    try {
      var res = await MsgHttp.delMsgfeed(1, id);
      if (res['status']) {
        loadingState.value.data!.removeAt(index);
        loadingState.refresh();
        SmartDialog.showToast('删除成功');
      } else {
        SmartDialog.showToast(res['msg']);
      }
    } catch (_) {}
  }
}
