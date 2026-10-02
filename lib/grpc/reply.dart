import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:PiliPlus/grpc/bilibili/pagination.pb.dart';
import 'package:PiliPlus/grpc/grpc_req.dart';
import 'package:PiliPlus/grpc/url.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/user_whitelist.dart';
import 'package:fixnum/fixnum.dart';

abstract final class ReplyGrpc {
  static bool antiGoodsReply = Pref.antiGoodsReply;
  static RegExp replyRegExp = RegExp(
    Pref.parseBanWordToRegex(Pref.banWordForReply),
    caseSensitive: false,
  );
  static bool enableFilter = replyRegExp.pattern.isNotEmpty;
  static Map<int, String> replyBlockedMids = Pref.replyBlockedMids;
  static int replyMinLevel = Pref.replyMinLevel;
  static bool keepUpOwnerReply = Pref.keepUpOwnerReply;
  static bool keepUpTopReply = Pref.keepUpTopReply;
  static bool keepUpLikeReply = Pref.keepUpLikeReply;
  static bool keepUpReplyReply = Pref.keepUpReplyReply;

  // static Future replyInfo({required int rpid}) {
  //   return _request(
  //     GrpcUrl.replyInfo,
  //     ReplyInfoReq(rpid: Int64(rpid)),
  //     ReplyInfoReply.fromBuffer,
  //     onSuccess: (response) => response.reply,
  //   );
  // }

  // ref BiliRoamingX
  static bool needRemoveGoodGrpc(ReplyInfo reply) {
    return (reply.content.urls.isNotEmpty &&
            reply.content.urls.values.any((url) {
              return url.hasExtra() &&
                  (url.extra.goodsCmControl == Int64.ONE ||
                      url.extra.hasGoodsItemId() ||
                      url.extra.hasGoodsPrefetchedCache());
            })) ||
        reply.content.message.contains(Constants.goodsUrlPrefix);
  }

  static bool needRemoveGrpc(
    ReplyInfo reply, {
    Int64? upMid,
  }) {
    final mid = reply.mid.toInt();
    if (replyBlockedMids.isNotEmpty && replyBlockedMids.containsKey(mid)) {
      return true;
    }
    if (UserWhitelist.contains(mid)) return false;
    if (antiGoodsReply && needRemoveGoodGrpc(reply)) return true;
    final replyControl = reply.replyControl;
    if (keepUpOwnerReply && upMid != null && reply.mid == upMid) return false;
    if (keepUpTopReply && replyControl.isUpTop) return false;
    if (keepUpLikeReply && replyControl.upLike) return false;
    if (keepUpReplyReply && replyControl.upReply) return false;
    return (replyMinLevel > 0 && reply.member.level.toInt() < replyMinLevel) ||
        (enableFilter && replyRegExp.hasMatch(reply.content.message));
  }

  static Future<LoadingState<MainListReply>> mainList({
    int type = 1,
    required int oid,
    required Mode mode,
    required String? offset,
    required Int64? cursorNext,
  }) async {
    final res = await GrpcReq.request(
      GrpcUrl.mainList,
      MainListReq(
        oid: Int64(oid),
        type: Int64(type),
        rpid: Int64.ZERO,
        cursor: CursorReq(
          mode: mode,
          next: cursorNext,
        ),
        // mode: mode,
        // pagination: offset == null ? null : FeedPagination(offset: offset),
      ),
      MainListReply.fromBuffer,
    );
    if (res case Success(:final response)) {
      final upMid = response.subjectControl.upMid;
      // keyword filter
      if (response.hasUpTop() &&
          needRemoveGrpc(
            response.upTop,
            upMid: upMid,
          )) {
        response.clearUpTop();
      }

      if (response.replies.isNotEmpty) {
        response.replies.removeWhere((item) {
          final hasMatch = needRemoveGrpc(
            item,
            upMid: upMid,
          );
          if (!hasMatch && item.replies.isNotEmpty) {
            item.replies.removeWhere((item) {
              return needRemoveGrpc(item, upMid: upMid);
            });
          }
          return hasMatch;
        });
      }
    }
    return res;
  }

  static Future<LoadingState<DetailListReply>> detailList({
    int type = 1,
    required int oid,
    required int root,
    required int rpid,
    required Mode mode,
    required String? offset,
  }) async {
    final res = await GrpcReq.request(
      GrpcUrl.detailList,
      DetailListReq(
        oid: Int64(oid),
        type: Int64(type),
        root: Int64(root),
        rpid: Int64(rpid),
        scene: DetailListScene.REPLY,
        mode: mode,
        pagination: offset == null ? null : FeedPagination(offset: offset),
      ),
      DetailListReply.fromBuffer,
    );
    if (res case Success(:final response)) {
      final upMid = response.subjectControl.upMid;
      response.root.replies.removeWhere((item) {
        return needRemoveGrpc(item, upMid: upMid);
      });
    }
    return res;
  }

  static Future<LoadingState<DialogListReply>> dialogList({
    int type = 1,
    required int oid,
    required int root,
    required int dialog,
    required String? offset,
  }) async {
    final res = await GrpcReq.request(
      GrpcUrl.dialogList,
      DialogListReq(
        oid: Int64(oid),
        type: Int64(type),
        root: Int64(root),
        dialog: Int64(dialog),
        pagination: offset == null ? null : FeedPagination(offset: offset),
      ),
      DialogListReply.fromBuffer,
    );
    if (res case Success(:final response)) {
      final upMid = response.subjectControl.upMid;
      response.replies.removeWhere((item) {
        return needRemoveGrpc(item, upMid: upMid);
      });
    }
    return res;
  }

  static Future<LoadingState<SearchItemReply>> searchItem({
    required int page,
    required SearchItemType itemType,
    required int oid,
    int type = 1,
    String? keyword,
  }) {
    return GrpcReq.request(
      GrpcUrl.searchItem,
      SearchItemReq(
        cursor: SearchItemCursorReq(
          next: Int64(page),
          itemType: itemType,
        ),
        oid: Int64(oid),
        type: Int64(type),
        keyword: keyword,
      ),
      SearchItemReply.fromBuffer,
    );
  }

  static Future<LoadingState<TranslateReplyResp>> translateReply({
    required Int64 type,
    required Int64 oid,
    required Int64 rpid,
  }) {
    return GrpcReq.request(
      GrpcUrl.translateReply,
      TranslateReplyReq(
        type: type,
        oid: oid,
        rpids: [rpid],
      ),
      TranslateReplyResp.fromBuffer,
    );
  }
}
