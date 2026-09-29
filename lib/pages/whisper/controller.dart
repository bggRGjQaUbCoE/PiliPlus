import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart'
    show Offset, Session, SessionMainReply, SessionPageType, ThreeDotItem;
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models_new/msg/msgfeed_unread.dart';
import 'package:PiliPlus/pages/common/common_whisper_controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:protobuf/protobuf.dart' show PbMap;

typedef MsgFeedTopItem = ({
  bool enabled,
  IconData icon,
  String name,
  String route,
});

class WhisperController extends CommonWhisperController<SessionMainReply> {
  @override
  SessionPageType sessionPageType = SessionPageType.SESSION_PAGE_TYPE_HOME;

  List<MsgFeedTopItem> get msgFeedTopItems => [
    (
      name: L10n.current.msgUnReadTypeReplyTitle,
      icon: Icons.message_outlined,
      route: "/replyMe",
      enabled: true,
    ),
    (
      name: L10n.current.msgUnReadTypeAtTitle,
      icon: Icons.alternate_email_outlined,
      route: "/atMe",
      enabled: true,
    ),
    (
      name: L10n.current.msgUnReadTypeLikeTitle,
      icon: Icons.favorite_border_outlined,
      route: "/likeMe",
      enabled: !disableLikeMsg,
    ),
    (
      name: L10n.current.msgUnReadTypeSysMsgTitle,
      icon: Icons.notifications_none_outlined,
      route: "/sysMsg",
      enabled: true,
    ),
  ];
  final disableLikeMsg = Pref.disableLikeMsg;
  late final RxList<int> unreadCounts;

  PbMap<int, Offset>? offset;

  Rx<List<ThreeDotItem>?> threeDotItems = Rx<List<ThreeDotItem>?>(null);
  Rx<List<ThreeDotItem>?> outsideItem = Rx<List<ThreeDotItem>?>(null);

  @override
  void onInit() {
    super.onInit();
    unreadCounts = List.filled(msgFeedTopItems.length, 0).obs;
    queryMsgFeedUnread();
    queryData();
  }

  Future<void> queryMsgFeedUnread() async {
    final res = await ImGrpc.getTotalUnread(unreadType: 2);
    if (res case Success(:final response)) {
      final data = MsgFeedUnread.fromJson(response.msgFeedUnread.unread);
      final unreadCounts = [
        data.reply,
        data.at,
        disableLikeMsg ? 0 : data.like,
        data.sysMsg,
      ];
      if (!listEquals(this.unreadCounts, unreadCounts)) {
        this.unreadCounts.value = unreadCounts;
      }
    } else {
      res.toast();
    }
  }

  @override
  List<Session>? getDataList(SessionMainReply response) {
    offset = response.paginationParams.offsets;
    isEnd = !response.paginationParams.hasMore;
    return response.sessions;
  }

  @override
  bool customHandleResponse(
    bool isRefresh,
    Success<SessionMainReply> response,
  ) {
    if (isRefresh) {
      threeDotItems.value = response.response.threeDotItems;
      outsideItem.value = response.response.outsideItem;
    }
    return false;
  }

  @override
  Future<LoadingState<SessionMainReply>> customGetData() =>
      ImGrpc.sessionMain(offset: offset);

  @override
  Future<void> onRefresh() {
    offset = null;
    queryMsgFeedUnread();
    return super.onRefresh();
  }
}
