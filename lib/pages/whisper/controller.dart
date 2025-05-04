import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/msg/account.dart';
import 'package:PiliPlus/models/msg/msgfeed_unread.dart';
import 'package:PiliPlus/models/msg/session.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class WhisperController
    extends CommonListController<List<SessionList>?, SessionList> {
  late final List msgFeedTopItems;
  late final RxList<int> unreadCounts;

  int? endTs;

  @override
  void onInit() {
    super.onInit();
    final disableLikeMsg =
        GStorage.setting.get(SettingBoxKey.disableLikeMsg, defaultValue: false);
    msgFeedTopItems = [
      {
        "name": "回复我的",
        "icon": Icons.message_outlined,
        "route": "/replyMe",
        "enabled": true,
      },
      {
        "name": "@我",
        "icon": Icons.alternate_email_outlined,
        "route": "/atMe",
        "enabled": true,
      },
      {
        "name": "收到的赞",
        "icon": Icons.favorite_border_outlined,
        "route": "/likeMe",
        "enabled": !disableLikeMsg,
      },
      {
        "name": "系统通知",
        "icon": Icons.notifications_none_outlined,
        "route": "/sysMsg",
        "enabled": true,
      },
    ];
    unreadCounts =
        List.generate(msgFeedTopItems.length, (index) => 0).toList().obs;
    queryMsgFeedUnread();
    queryData();
  }

  Future queryMsgFeedUnread() async {
    var res = await MsgHttp.msgFeedUnread();
    if (res['status']) {
      final data = MsgFeedUnread.fromJson(res['data']);
      unreadCounts.value = [data.reply, data.at, data.like, data.sysMsg];
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  @override
  Future<LoadingState<List<SessionList>?>> customGetData() =>
      MsgHttp.sessionList(endTs: endTs);

  @override
  bool customHandleResponse(
      bool isRefresh, Success<List<SessionList>?> response) {
    endTs = response.response?.lastOrNull?.sessionTs;
    List<SessionList>? dataList = response.response;
    if (dataList.isNullOrEmpty) {
      isEnd = true;
      if (isRefresh) {
        loadingState.value = LoadingState<List<SessionList>?>.success(dataList);
      }
      isLoading = false;
      return true;
    }
    queryAccountList(dataList!).then((_) {
      if (isRefresh) {
        loadingState.value = LoadingState<List<SessionList>?>.success(dataList);
      } else if (loadingState.value is Success) {
        loadingState.value.data!.addAll(dataList);
        loadingState.refresh();
      }
    });
    return true;
  }

  @override
  Future<void> onRefresh() {
    queryMsgFeedUnread();
    endTs = null;
    return super.onRefresh();
  }

  Future onRemove(int index, int? talkerId) async {
    var res = await MsgHttp.removeMsg(talkerId);
    if (res['status']) {
      loadingState.value.data!.removeAt(index);
      loadingState.refresh();
      SmartDialog.showToast('删除成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future onSetTop(int index, bool isTop, int? talkerId) async {
    var res = await MsgHttp.setTop(
      talkerId: talkerId,
      opType: isTop ? 1 : 0,
    );
    if (res['status']) {
      List<SessionList> list = (loadingState.value as Success).response;
      list[index].topTs = isTop ? 0 : 1;
      if (!isTop) {
        SessionList item = list.removeAt(index);
        list.insert(0, item);
      }
      loadingState.refresh();
      SmartDialog.showToast('${isTop ? '移除' : ''}置顶成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  void onTap(int index) {
    List<SessionList> list = (loadingState.value as Success).response;
    list[index].unreadCount = 0;
    loadingState.refresh();
  }

  Future queryAccountList(List<SessionList> sessionList) async {
    List<int?> midsList = sessionList.map((e) => e.talkerId).toList();
    var res = await MsgHttp.accountList(midsList.join(','));
    if (res['status']) {
      List<AccountListModel> accountList = res['data'];
      Map<int, AccountListModel> accountMap = {};
      for (AccountListModel item in accountList) {
        accountMap[item.mid!] = item;
      }
      for (SessionList item in sessionList) {
        AccountListModel? accountInfo = accountMap[item.talkerId];
        if (accountInfo != null) {
          item.accountInfo = accountInfo;
        }
      }
    }
  }
}
