import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart'
    show SessionPageType, SessionId, Session;
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

abstract class CommonWhisperController<R>
    extends CommonListController<R, Session> {
  SessionPageType get sessionPageType;

  Future<void> onRemove(int index, int talkerId) async {
    final res = await MsgHttp.removeMsg(talkerId);
    if (res.isSuccess) {
      final removed = loadingState.value.dataOrNull?.removeFirstWhere(
        (item) =>
            item.id.hasPrivateId() &&
            item.id.privateId.talkerUid.toInt() == talkerId,
      );
      if (removed == true) loadingState.refresh();
      SmartDialog.showToast('删除成功');
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
      final list = loadingState.value.dataOrNull;
      final currentIndex = list?.indexWhere(
        (current) => const ListEquality<int>().equals(
          current.id.writeToBuffer(),
          sessionId.writeToBuffer(),
        ),
      );
      if (list != null && currentIndex != null && currentIndex != -1) {
        final current = list[currentIndex]..isPinned = !isTop;
        if (!isTop && currentIndex != 0) {
          list
            ..removeAt(currentIndex)
            ..insert(0, current);
        }
        loadingState.refresh();
      }
      SmartDialog.showToast('${isTop ? '移除' : ''}置顶成功');
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
      final list = loadingState.value.dataOrNull;
      final currentIndex = list?.indexWhere(
        (current) =>
            current.id.hasPrivateId() &&
            current.id.privateId.talkerUid == talkerUid,
      );
      if (list != null && currentIndex != null && currentIndex != -1) {
        list[currentIndex].isMuted = !isMuted;
        loadingState.refresh();
      }
      SmartDialog.showToast('设置成功');
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
      SmartDialog.showToast('已标记为已读');
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
