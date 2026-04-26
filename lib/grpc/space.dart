import 'package:PiliPlus/grpc/bilibili/app/dynamic/v2.pb.dart';
import 'package:PiliPlus/grpc/bilibili/app/interfaces/v1.pb.dart'
    show SearchArchiveReply, SearchArchiveReq;
import 'package:PiliPlus/grpc/bilibili/pagination.pb.dart';
import 'package:PiliPlus/grpc/grpc_req.dart';
import 'package:PiliPlus/grpc/url.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:fixnum/fixnum.dart';

abstract final class SpaceGrpc {
  static Future<LoadingState<OpusSpaceFlowResp>> opusSpaceFlow({
    required int hostMid,
    String? next,
    required String filterType,
  }) {
    return GrpcReq.request(
      GrpcUrl.opusSpaceFlow,
      OpusSpaceFlowReq(
        hostMid: Int64(hostMid),
        pagination: Pagination(
          pageSize: 20,
          next: next,
        ),
        filterType: filterType,
      ),
      OpusSpaceFlowResp.fromBuffer,
    );
  }

  static Future<LoadingState<SearchArchiveReply>> searchArchive({
    required String keyword,
    required Int64 mid,
    required int pn,
    required Int64 ps,
  }) {
    return GrpcReq.request(
      GrpcUrl.searchArchive,
      SearchArchiveReq(
        keyword: keyword,
        mid: mid,
        pn: Int64(pn),
        ps: ps,
      ),
      SearchArchiveReply.fromBuffer,
    );
  }
}
