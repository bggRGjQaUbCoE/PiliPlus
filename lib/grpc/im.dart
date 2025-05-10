import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart';
import 'package:PiliPlus/grpc/bilibili/im/interfaces/v1.pb.dart';
import 'package:PiliPlus/grpc/bilibili/im/type.pb.dart';
import 'package:PiliPlus/grpc/grpc_repo.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' show PbMap;
import 'package:uuid/uuid.dart';

class ImGrpc {
  static Future<LoadingState<RspSendMsg>> sendMsg({
    required int senderUid,
    required int receiverId,
    required String content,
    MsgType msgType = MsgType.EN_MSG_TYPE_TEXT,
  }) {
    return GrpcRepo.request(
      GrpcUrl.sendMsg,
      ReqSendMsg(
        msg: Msg(
          senderUid: Int64(senderUid),
          receiverType: 1,
          receiverId: Int64(receiverId),
          msgType: msgType.value,
          content: content,
          timestamp: Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          msgStatus: 0,
          newFaceVersion: 1,
        ),
        devId: const Uuid().v4(),
      ),
      RspSendMsg.fromBuffer,
    );
  }

  static Future<LoadingState<RspShareList>> shareList({int size = 10}) {
    return GrpcRepo.request(
      GrpcUrl.shareList,
      ReqShareList(size: size),
      RspShareList.fromBuffer,
    );
  }

  static Future<LoadingState<RspSessionMsg>> syncFetchSessionMsgs({
    required int talkerId,
    Int64? endSeqno,
    Int64? beginSeqno,
  }) {
    return GrpcRepo.request(
      GrpcUrl.syncFetchSessionMsgs,
      ReqSessionMsg(
        talkerId: Int64(talkerId),
        sessionType: 1,
        endSeqno: endSeqno,
        beginSeqno: beginSeqno,
        size: 20,
        devId: '1',
      ),
      RspSessionMsg.fromBuffer,
    );
  }

  static Future<LoadingState<SessionMainReply>> sessionMain({
    PbMap<int, Offset>? offset,
  }) {
    return GrpcRepo.request(
      GrpcUrl.sessionMain,
      SessionMainReq(
        paginationParams: PaginationParams(offsets: offset),
      ),
      SessionMainReply.fromBuffer,
    );
  }

  static Future<LoadingState<SessionSecondaryReply>> sessionSecondary({
    PbMap<int, Offset>? offset,
    SessionPageType? pageType,
  }) {
    return GrpcRepo.request(
      GrpcUrl.sessionSecondary,
      SessionSecondaryReq(
        paginationParams: PaginationParams(offsets: offset),
        pageType: pageType,
      ),
      SessionSecondaryReply.fromBuffer,
    );
  }

  static Future<LoadingState<ClearUnreadReply>> clearUnread({
    SessionPageType? pageType,
    SessionId? sessionId,
  }) {
    return GrpcRepo.request(
      GrpcUrl.clearUnread,
      ClearUnreadReq(
        pageType: pageType,
        sessionId: sessionId,
      ),
      ClearUnreadReply.fromBuffer,
    );
  }

  static Future<LoadingState<SessionUpdateReply>> sessionUpdate({
    SessionPageType? pageType,
    SessionId? sessionId,
  }) {
    return GrpcRepo.request(
      GrpcUrl.sessionUpdate,
      SessionUpdateReq(
        pageType: pageType,
        sessionId: sessionId,
      ),
      SessionUpdateReply.fromBuffer,
    );
  }

  static Future<LoadingState<PinSessionReply>> pinSession({
    SessionId? sessionId,
    Int64? topTimeMicros,
  }) {
    return GrpcRepo.request(
      GrpcUrl.pinSession,
      PinSessionReq(
        sessionId: sessionId,
        topTimeMicros: topTimeMicros,
      ),
      PinSessionReply.fromBuffer,
    );
  }

  static Future<LoadingState<UnPinSessionReply>> unpinSession({
    SessionId? sessionId,
  }) {
    return GrpcRepo.request(
      GrpcUrl.unpinSession,
      UnPinSessionReq(
        sessionId: sessionId,
      ),
      UnPinSessionReply.fromBuffer,
    );
  }

  static Future<LoadingState<DeleteSessionListReply>> deleteSessionList({
    SessionPageType? pageType,
  }) {
    return GrpcRepo.request(
      GrpcUrl.deleteSessionList,
      DeleteSessionListReq(
        pageType: pageType,
      ),
      DeleteSessionListReply.fromBuffer,
    );
  }

  static Future<LoadingState<GetImSettingsReply>> getImSettings(
      {IMSettingType? type}) {
    return GrpcRepo.request(
      GrpcUrl.getImSettings,
      GetImSettingsReq(
        type: type,
      ),
      GetImSettingsReply.fromBuffer,
    );
  }

  static Future<LoadingState<SetImSettingsReply>> setImSettings(
      {PbMap<int, Setting>? settings}) {
    return GrpcRepo.request(
      GrpcUrl.setImSettings,
      SetImSettingsReq(
        settings: settings,
      ),
      SetImSettingsReply.fromBuffer,
    );
  }

  static Future<LoadingState<KeywordBlockingListReply>> keywordBlockingList() {
    return GrpcRepo.request(
      GrpcUrl.keywordBlockingList,
      KeywordBlockingListReq(),
      KeywordBlockingListReply.fromBuffer,
    );
  }

  static Future<LoadingState<KeywordBlockingAddReply>> keywordBlockingAdd(
      String keyword) {
    return GrpcRepo.request(
      GrpcUrl.keywordBlockingAdd,
      KeywordBlockingAddReq(keyword: keyword),
      KeywordBlockingAddReply.fromBuffer,
    );
  }

  static Future<LoadingState<KeywordBlockingDeleteReply>> keywordBlockingDelete(
      String keyword) {
    return GrpcRepo.request(
      GrpcUrl.keywordBlockingDelete,
      KeywordBlockingDeleteReq(keyword: keyword),
      KeywordBlockingDeleteReply.fromBuffer,
    );
  }

  static Future<LoadingState<RspTotalUnread>> getTotalUnread(
      {int? unreadType}) {
    return GrpcRepo.request(
      GrpcUrl.getTotalUnread,
      ReqTotalUnread(unreadType: unreadType, showUnfollowList: 1),
      RspTotalUnread.fromBuffer,
    );
  }
}
