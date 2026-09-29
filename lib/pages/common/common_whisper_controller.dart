import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart'
    show SessionPageType, SessionId, Session;
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

abstract class CommonWhisperController<R>
    extends CommonListController<R, Session> {
  SessionPageType get sessionPageType;

  Future<void> onRemove(int index, int talkerId) async {
    final res = await MsgHttp.removeMsg(talkerId);
    if (res.isSuccess) {
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
      SmartDialog.showToast(L10n.current.commonWhisperControllerOnRemoveText);
    } else {
      res.toast();
    }
  }

  Future<void> onSetTop(
    Session item,
    int index,
    bool isTop,
    SessionId sessionId,
  ) async {
    final res = isTop
        ? await ImGrpc.unpinSession(sessionId: sessionId)
        : await ImGrpc.pinSession(sessionId: sessionId);

    if (res.isSuccess) {
      List<Session> list = loadingState.value.data!;
      item.isPinned = isTop ? false : true;
      if (!isTop) {
        list.insert(0, list.removeAt(index));
      }
      loadingState.refresh();
      SmartDialog.showToast(
        L10n.current.commonWhisperControllerOnSetTopText(isTop.toString()),
      );
    } else {
      res.toast();
    }
  }

  Future<void> onSetMute(Session item, bool isMuted, Int64 talkerUid) async {
    final res = await MsgHttp.setMsgDnd(
      uid: Accounts.main.mid,
      setting: isMuted ? 0 : 1,
      dndUid: talkerUid,
    );
    if (res.isSuccess) {
      item.isMuted = !isMuted;
      loadingState.refresh();
      SmartDialog.showToast(L10n.current.settingsSaved);
    } else {
      res.toast();
    }
  }

  Future<void> onClearUnread() async {
    final res = await ImGrpc.clearUnread(pageType: sessionPageType);
    if (res.isSuccess) {
      if (loadingState.value case Success(:final response)) {
        if (response != null && response.isNotEmpty) {
          for (final item in response) {
            if (item.hasUnread()) {
              item.clearUnread();
            }
          }
          loadingState.refresh();
        }
      }
      SmartDialog.showToast(
        L10n.current.commonWhisperControllerOnClearUnreadText,
      );
    } else {
      res.toast();
    }
  }

  Future<void> onDeleteList() async {
    final res = await ImGrpc.deleteSessionList(pageType: sessionPageType);
    if (res.isSuccess) {
      loadingState.value = const Success(null);
    } else {
      res.toast();
    }
  }
}
