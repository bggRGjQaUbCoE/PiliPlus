import 'package:PiliPlus/grpc/bilibili/app/archive/middleware/v1.pb.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pb.dart';
import 'package:PiliPlus/grpc/bilibili/pagination.pb.dart';
import 'package:PiliPlus/grpc/grpc_req.dart';
import 'package:PiliPlus/grpc/url.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:fixnum/fixnum.dart';

class AudioGrpc {
  static Future<LoadingState<PlayURLResp>> audioPlayUrl({
    required Int64 oid,
    required List<Int64> subId,
    required int itemType,
    int qn = 80,
    int fnval = 4048,
  }) {
    return GrpcReq.request(
      GrpcUrl.audioPlayUrl,
      PlayURLReq(
        item: PlayItem(
          oid: oid,
          subId: subId,
          itemType: itemType,
        ),
        playerArgs: PlayerArgs(
          qn: Int64(qn),
          fnval: Int64(fnval),
          forceHost: Int64(2),
          voiceBalance: Int64(1),
        ),
      ),
      PlayURLResp.fromBuffer,
    );
  }

  static Future<LoadingState<PlaylistResp>> audioPlayList({
    PlaylistSource? from,
    required Int64 id,
    Int64? oid,
    List<Int64>? subId,
    int? itemType,
    PageOption? pageOpt,
    Int64? extraId,
    String? next,
    int qn = 80,
    int fnval = 4048,
  }) {
    return GrpcReq.request(
      GrpcUrl.audioPlayList,
      PlaylistReq(
        from: from,
        id: id,
        anchor: PlayItem(
          oid: oid,
          subId: subId,
          itemType: itemType,
        ),
        pageOpt: pageOpt,
        playerArgs: PlayerArgs(
          qn: Int64(qn),
          fnval: Int64(fnval),
          forceHost: Int64(2),
          voiceBalance: Int64(1),
        ),
        extraId: extraId,
        sortOpt: SortOption(order: ListOrder.ORDER_NORMAL),
        pagination: Pagination(pageSize: 20, next: next),
      ),
      PlaylistResp.fromBuffer,
    );
  }

  static Future<LoadingState<ThumbUpResp>> audioThumbUp({
    required Int64 oid,
    required List<Int64> subId,
    required int itemType,
    required ThumbUpReq_ThumbType type,
  }) {
    return GrpcReq.request(
      GrpcUrl.audioThumbUp,
      ThumbUpReq(
        item: PlayItem(
          oid: oid,
          itemType: itemType,
          subId: subId,
        ),
        action: type,
      ),
      ThumbUpResp.fromBuffer,
    );
  }

  static Future<LoadingState<TripleLikeResp>> audioTripleLike({
    required Int64 oid,
    required List<Int64> subId,
    required int itemType,
  }) {
    return GrpcReq.request(
      GrpcUrl.audioTripleLike,
      TripleLikeReq(
        item: PlayItem(
          oid: oid,
          subId: subId,
          itemType: itemType,
        ),
      ),
      TripleLikeResp.fromBuffer,
    );
  }

  static Future<LoadingState<CoinAddResp>> audioCoinAdd({
    required Int64 oid,
    required List<Int64> subId,
    required int itemType,
    required int num,
    bool thumbUp = false,
  }) {
    return GrpcReq.request(
      GrpcUrl.audioCoinAdd,
      CoinAddReq(
        item: PlayItem(
          oid: oid,
          subId: subId,
          itemType: itemType,
        ),
        num: num,
        thumbUp: thumbUp,
      ),
      CoinAddResp.fromBuffer,
    );
  }
}
