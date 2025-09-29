import 'dart:async';
import 'dart:convert';

import 'package:PiliPlus/grpc/bilibili/im/interfaces/v1.pb.dart'
    show EmotionInfo, RspSessionMsg;
import 'package:PiliPlus/grpc/bilibili/im/type.pb.dart' show Msg, MsgType;
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class WhisperDetailController extends CommonListController<RspSessionMsg, Msg> {
  AccountService accountService = Get.find<AccountService>();

  final int talkerId = Get.arguments['talkerId'];
  final String name = Get.arguments['name'];
  final String face = Get.arguments['face'];
  final int? mid = Get.arguments['mid'];
  final bool isLive = Get.arguments['isLive'] ?? false;

  Int64? msgSeqno;

  //表情转换图片规则
  List<EmotionInfo>? eInfos;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<RspSessionMsg> response) {
    List<Msg> msgs = response.response.messages;
    if (msgs.isNotEmpty) {
      msgSeqno = msgs.last.msgSeqno;
      if (msgs.length == 1 &&
          msgs.last.msgType == 18 &&
          msgs.last.msgSource == 18) {
        //{content: [{"text":"对方主动回复或关注你前，最多发送1条消息","color_day":"#9499A0","color_nig":"#9499A0"}]}
      } else {
        ackSessionMsg(msgs.last.msgSeqno.toInt());
      }
      eInfos ??= <EmotionInfo>[];
      eInfos!.addAll(response.response.eInfos);
    }
    return false;
  }

  // 消息标记已读
  Future<void> ackSessionMsg(int msgSeqno) async {
    var res = await MsgHttp.ackSessionMsg(
      talkerId: talkerId,
      ackSeqno: msgSeqno,
    );
    if (!res['status']) {
      SmartDialog.showToast(res['msg']);
    }
  }

  late bool _isSending = false;
  Future<void> sendMsg({
    String? message,
    Map? picMsg,
    required VoidCallback onClearText,
    int? msgType,
    int? index,
  }) async {
    assert((message != null) ^ (picMsg != null));
    if (_isSending) return;
    _isSending = true;
    feedBack();
    SmartDialog.dismiss();
    if (!accountService.isLogin.value) {
      SmartDialog.showToast('请先登录');
      return;
    }
    var result = await ImGrpc.sendMsg(
      senderUid: accountService.mid,
      receiverId: mid!,
      content: msgType == 5
          ? message!
          : jsonEncode(picMsg ?? {"content": message!}),
      msgType: MsgType.values[msgType ?? (picMsg != null ? 2 : 1)],
    );
    SmartDialog.dismiss();
    if (result.isSuccess) {
      if (msgType == 5) {
        loadingState
          ..value.data![index!].msgStatus = 1
          ..refresh();
        SmartDialog.showToast('撤回成功');
      } else {
        onRefresh();
        onClearText();
        SmartDialog.showToast('发送成功');
      }
    } else {
      result.toast();
    }
    _isSending = false;
  }

  @override
  List<Msg>? getDataList(RspSessionMsg response) {
    if (response.hasMore == 0) {
      isEnd = true;
    }
    return response.messages;
  }

  @override
  Future<void> onRefresh() {
    msgSeqno = null;
    eInfos = null;
    scrollController.jumpToTop();
    return super.onRefresh();
  }

  @override
  Future<LoadingState<RspSessionMsg>> customGetData() =>
      ImGrpc.syncFetchSessionMsgs(
        talkerId: talkerId,
        beginSeqno: msgSeqno != null ? Int64.ZERO : null,
        endSeqno: msgSeqno,
      );
}
