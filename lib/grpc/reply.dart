import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:PiliPlus/grpc/bilibili/pagination.pb.dart';
import 'package:PiliPlus/grpc/grpc_req.dart';
import 'package:PiliPlus/grpc/url.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:fixnum/fixnum.dart';

abstract final class ReplyGrpc {
  static final RegExp _whitespaceRegExp = RegExp(r'\s+');

  static bool antiGoodsReply = Pref.antiGoodsReply;
  static bool filterMentionDominatedReply = Pref.filterMentionDominatedReply;
  static int mentionFilterThreshold = Pref.mentionFilterThreshold;
  static RegExp replyRegExp = RegExp(
    Pref.banWordForReply,
    caseSensitive: false,
  );
  static bool enableFilter = replyRegExp.pattern.isNotEmpty;

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

  static bool needRemoveMentionGrpc(ReplyInfo reply) {
    final content = reply.content;
    if (content.pictures.isNotEmpty) {
      return false;
    }

    String message = content.message;
    for (final emote in content.emotes.keys) {
      message = message.replaceAll(emote, '\uFFFC');
    }
    message = message.replaceAll(_whitespaceRegExp, '');
    if (message.isEmpty || content.atNameToMid.isEmpty) {
      return false;
    }

    final mentionTokens =
        content.atNameToMid.keys
            .map((name) => '@${name.replaceAll(_whitespaceRegExp, '')}')
            .toList()
          ..sort((a, b) => b.length.compareTo(a.length));

    for (final mention in mentionTokens) {
      final prefix = '回复$mention';
      if (message.startsWith(prefix)) {
        final remaining = message.substring(prefix.length);
        if (remaining.startsWith(':') || remaining.startsWith('：')) {
          message = remaining.substring(1);
          break;
        }
      }
    }
    if (message.isEmpty) {
      return false;
    }

    String remaining = message;
    int mentionLength = 0;
    for (final mention in mentionTokens) {
      final prevLength = remaining.length;
      remaining = remaining.replaceAll(mention, '');
      mentionLength += prevLength - remaining.length;
    }
    return mentionLength * 100 >= message.length * mentionFilterThreshold;
  }

  static bool needRemoveGrpc(
    ReplyInfo reply, {
    bool applyMentionFilter = true,
  }) {
    return (enableFilter && replyRegExp.hasMatch(reply.content.message)) ||
        (applyMentionFilter &&
            filterMentionDominatedReply &&
            needRemoveMentionGrpc(reply)) ||
        (antiGoodsReply && needRemoveGoodGrpc(reply));
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
        // cursor: CursorReq(
        //   mode: mode,
        //   next: cursorNext,
        // ),
        mode: mode,
        pagination: offset == null ? null : FeedPagination(offset: offset),
      ),
      MainListReply.fromBuffer,
    );
    if (res case Success(:final response)) {
      // keyword filter
      if (response.hasUpTop() && needRemoveGrpc(response.upTop)) {
        response.clearUpTop();
      }

      if (response.replies.isNotEmpty) {
        response.replies.removeWhere((item) {
          final hasMatch = needRemoveGrpc(item);
          if (!hasMatch && item.replies.isNotEmpty) {
            item.replies.removeWhere(needRemoveGrpc);
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
    return res..dataOrNull?.root.replies.removeWhere(needRemoveGrpc);
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
    return res
      ..dataOrNull?.replies.removeWhere(
        (reply) => needRemoveGrpc(reply, applyMentionFilter: false),
      );
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
