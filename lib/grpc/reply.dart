import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:PiliPlus/grpc/bilibili/pagination.pb.dart';
import 'package:PiliPlus/grpc/grpc_repo.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:fixnum/fixnum.dart';

class ReplyGrpc {
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
                      url.extra.goodsItemId != Int64.ZERO ||
                      url.extra.goodsPrefetchedCache.isNotEmpty);
            })) ||
        reply.content.message.contains(Constants.goodsUrlPrefix);
  }

  static bool needRemoveGrpc(ReplyInfo reply, final bool antiGoodsReply) {
    return (ReplyHttp.replyRegExp.pattern.isNotEmpty &&
            ReplyHttp.replyRegExp.hasMatch(reply.content.message)) ||
        (antiGoodsReply && needRemoveGoodGrpc(reply));
  }

  static Future<LoadingState<MainListReply>> mainList({
    int type = 1,
    required int oid,
    required Mode mode,
    required String? offset,
    required Int64? cursorNext,
    required final bool antiGoodsReply,
  }) async {
    final res = await GrpcRepo.request(
      GrpcUrl.mainList,
      MainListReq(
        oid: Int64(oid),
        type: Int64(type),
        rpid: Int64.ZERO,
        cursor: CursorReq(
          mode: mode,
          next: cursorNext,
        ),
        // pagination: FeedPagination(offset: offset ?? ''),
      ),
      MainListReply.fromBuffer,
    );
    if (res.isSuccess) {
      final mainListReply = res.data;
      // keyword filter
      if (mainListReply.hasUpTop() &&
          needRemoveGrpc(mainListReply.upTop, antiGoodsReply)) {
        mainListReply.clearUpTop();
      }

      if (mainListReply.replies.isNotEmpty) {
        mainListReply.replies.removeWhere((item) {
          final hasMatch = needRemoveGrpc(item, antiGoodsReply);
          if (!hasMatch && item.replies.isNotEmpty) {
            item.replies.removeWhere((i) => needRemoveGrpc(i, antiGoodsReply));
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
    required final bool antiGoodsReply,
  }) async {
    final res = await GrpcRepo.request(
      GrpcUrl.detailList,
      DetailListReq(
        oid: Int64(oid),
        type: Int64(type),
        root: Int64(root),
        rpid: Int64(rpid),
        scene: DetailListScene.REPLY,
        mode: mode,
        pagination: FeedPagination(offset: offset ?? ''),
      ),
      DetailListReply.fromBuffer,
    );
    return res
      ..dataOrNull
          ?.root
          .replies
          .removeWhere((item) => needRemoveGrpc(item, antiGoodsReply));
  }

  static Future<LoadingState<DialogListReply>> dialogList({
    int type = 1,
    required int oid,
    required int root,
    required int dialog,
    required String? offset,
    required final bool antiGoodsReply,
  }) async {
    final res = await GrpcRepo.request(
      GrpcUrl.dialogList,
      DialogListReq(
        oid: Int64(oid),
        type: Int64(type),
        root: Int64(root),
        dialog: Int64(dialog),
        pagination: FeedPagination(offset: offset ?? ''),
      ),
      DialogListReply.fromBuffer,
    );
    return res
      ..dataOrNull
          ?.replies
          .removeWhere((item) => needRemoveGrpc(item, antiGoodsReply));
  }
}
