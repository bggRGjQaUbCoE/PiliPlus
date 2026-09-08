import 'package:PiliPlus/grpc/bilibili/app/dynamic/v1.pb.dart'
    show DynRedReq, TabOffset, DynRedReply;
import 'package:PiliPlus/grpc/bilibili/app/dynamic/v2.pb.dart'
    show
        OpusType,
        OpusDetailReq,
        OpusDetailResp,
        LikeListReq,
        LikeListReply,
        RepostListReq,
        RepostListRsp,
        RepostType;
import 'package:PiliPlus/grpc/grpc_req.dart';
import 'package:PiliPlus/grpc/url.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:fixnum/fixnum.dart';

abstract final class DynGrpc {
  // static Future dynSpace({
  //   required int uid,
  //   required int page,
  // }) {
  //   return _request(
  //     GrpcUrl.dynSpace,
  //     DynSpaceReq(
  //       hostUid: Int64(uid),
  //       localTime: 8,
  //       page: Int64(page),
  //       from: 'space',
  //     ),
  //     DynSpaceRsp.fromBuffer,
  //   );
  // }

  static Future<int?> dynRed() async {
    final res = await GrpcReq.request(
      GrpcUrl.dynRed,
      DynRedReq(tabOffset: [TabOffset(tab: 1)]),
      DynRedReply.fromBuffer,
    );
    return res.dataOrNull?.dynRedItem.count.toInt();
  }

  static Future<LoadingState<OpusDetailResp>> opusDetail({
    OpusType? opusType,
    required int oid,
  }) {
    return GrpcReq.request(
      GrpcUrl.opusDetail,
      OpusDetailReq(
        opusType: opusType,
        oid: Int64(oid),
      ),
      OpusDetailResp.fromBuffer,
    );
  }

  static Future<LoadingState<LikeListReply>> likeList({
    required String dynamicId,
    Int64? dynType,
    Int64? rid,
    Int64? uidOffset,
    required int page,
  }) {
    return GrpcReq.request(
      GrpcUrl.likeList,
      LikeListReq(
        dynamicId: dynamicId,
        dynType: dynType,
        rid: rid,
        uidOffset: uidOffset,
        page: page,
      ),
      LikeListReply.fromBuffer,
    );
  }

  static Future<LoadingState<RepostListRsp>> repostList({
    required String dynamicId,
    Int64? dynType,
    Int64? rid,
    String? offset,
    String? from,
    RepostType repostType = .repost_general,
  }) {
    return GrpcReq.request(
      GrpcUrl.repostList,
      RepostListReq(
        dynamicId: dynamicId,
        dynType: dynType,
        rid: rid,
        offset: offset,
        repostType: repostType,
      ),
      RepostListRsp.fromBuffer,
    );
  }
}
