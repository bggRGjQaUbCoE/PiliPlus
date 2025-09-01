import 'dart:async';

import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/dialog/report_member.dart';
import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart';
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models_new/msg/im_user_infos/datum.dart';
import 'package:PiliPlus/models_new/msg/msg_dnd/uid_setting.dart';
import 'package:PiliPlus/models_new/msg/session_ss/data.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class WhisperLinkSettingController extends GetxController {
  WhisperLinkSettingController({
    required this.talkerUid,
  });

  final int talkerUid;
  RxBool isPinned = false.obs;
  late final sessionId = SessionId(
    privateId: PrivateId(talkerUid: Int64(talkerUid)),
  );

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
    getSessionSs();
    getMsgDnd();
    getIsPinned();
  }

  final Rx<LoadingState<List<ImUserInfosData>?>> userState =
      LoadingState<List<ImUserInfosData>?>.loading().obs;
  final Rx<LoadingState<SessionSsData>> sessionSs =
      LoadingState<SessionSsData>.loading().obs;
  final Rx<LoadingState<List<UidSetting>?>> msgDnd =
      LoadingState<List<UidSetting>?>.loading().obs;

  Future<void> getUserInfo() async {
    userState.value = await MsgHttp.imUserInfos(uids: talkerUid.toString());
  }

  Future<void> getSessionSs() async {
    sessionSs.value = await MsgHttp.getSessionSs(talkerUid: talkerUid);
  }

  Future<void> getMsgDnd() async {
    msgDnd.value = await MsgHttp.getMsgDnd(uidsStr: talkerUid);
  }

  Future<void> getIsPinned() async {
    var res = await ImGrpc.sessionUpdate(sessionId: sessionId);
    if (res.isSuccess) {
      isPinned.value = res.data.session.isPinned;
    }
  }

  void setPush(bool isPush) {
    if (isPush) {
      showConfirmDialog(
        context: Get.context!,
        title: '确认关闭内容推送吗？',
        content: '若关闭此开关，你将不再收到该账号的图文消息与稿件推送，但通知类消息不受影响',
        onConfirm: () => _setPush(isPush),
      );
      return;
    }
    _setPush(isPush);
  }

  Future<void> _setPush(bool isPush) async {
    int setting = isPush ? 1 : 0;
    var res = await MsgHttp.setPushSs(
      setting: setting,
      talkerUid: talkerUid,
    );
    if (res['status']) {
      sessionSs
        ..value.data.pushSetting = setting
        ..refresh();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future<void> setPin() async {
    var res = isPinned.value
        ? await ImGrpc.unpinSession(sessionId: sessionId)
        : await ImGrpc.pinSession(sessionId: sessionId);
    if (res.isSuccess) {
      isPinned.value = !isPinned.value;
    } else {
      res.toast();
    }
  }

  Future<void> setMute(bool isMuted) async {
    int setting = isMuted ? 0 : 1;
    var res = await MsgHttp.setMsgDnd(
      uid: Accounts.main.mid,
      setting: setting,
      dndUid: talkerUid,
    );
    if (res['status']) {
      msgDnd
        ..value.data!.first.setting = setting
        ..refresh();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future<void> setBlock(bool isBlocked) async {
    if (isBlocked) {
      var res = await VideoHttp.relationMod(
        mid: talkerUid,
        act: 6,
        reSrc: 11,
      );
      if (res['status']) {
        sessionSs
          ..value.data.followStatus = null
          ..refresh();
      } else {
        SmartDialog.showToast(res['msg']);
      }
    } else {
      showConfirmDialog(
        context: Get.context!,
        title: '确认拉黑该用户',
        content: '加入黑名单后，将自动解除关注关系和对该用户的合集订阅关系，禁止该用户与我互动或查看我的空间',
        onConfirm: () async {
          var res = await VideoHttp.relationMod(
            mid: talkerUid,
            act: 5,
            reSrc: 11,
          );
          if (res['status']) {
            sessionSs
              ..value.data.followStatus = 128
              ..refresh();
          } else {
            SmartDialog.showToast(res['msg']);
          }
        },
      );
    }
  }

  void report() => showMemberReportDialog(
    Get.context!,
    name: userState.value.dataOrNull?.firstOrNull?.name,
    mid: talkerUid,
  );
}
