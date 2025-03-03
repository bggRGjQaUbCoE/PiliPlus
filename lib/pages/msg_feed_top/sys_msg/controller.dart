import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/msg.dart';

import '../../../models/msg/msgfeed_sys_msg.dart';

class SysMsgController extends GetxController {
  static const pageSize = 20;
  RxList<SystemNotifyList> msgFeedSysMsgList = <SystemNotifyList>[].obs;
  bool isLoading = false;
  int cursor = -1;
  bool isEnd = false;

  Future queryMsgFeedSysMsg() async {
    if (isLoading) return;
    isLoading = true;
    final res = await MsgHttp.msgFeedNotify(cursor: cursor, pageSize: pageSize);
    isLoading = false;
    if (res['status']) {
      final data = (res['data'] as List)
          .map((i) => SystemNotifyList.fromJson(i))
          .toList();
      isEnd = data.length + 1 < pageSize; // data.length会比pageSize小1
      if (data.isNotEmpty) {
        if (cursor == -1) {
          msgFeedSysMsgList.assignAll(data);
        } else {
          msgFeedSysMsgList.addAll(data);
        }
        cursor = data.last.cursor ?? -1;
        msgSysUpdateCursor(msgFeedSysMsgList.first.cursor!);
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future msgSysUpdateCursor(int cursor) async {
    var res = await MsgHttp.msgSysUpdateCursor(cursor);
    if (res['status']) {
      SmartDialog.showToast('已读成功');
      return true;
    } else {
      SmartDialog.showToast(res['msg']);
      return false;
    }
  }

  Future onLoad() async {
    if (isEnd) return;
    queryMsgFeedSysMsg();
  }

  Future onRefresh() async {
    cursor = -1;
    queryMsgFeedSysMsg();
  }

  Future onRemove(int index) async {
    var res = await MsgHttp.removeSysMsg(msgFeedSysMsgList[index].id);
    if (res['status']) {
      msgFeedSysMsgList.removeAt(index);
      SmartDialog.showToast('删除成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
