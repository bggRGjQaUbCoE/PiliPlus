import 'package:PiliPlus/grpc/bilibili/app/dynamic/v1.pb.dart'
    show DynRedReq, TabOffset, DynRedReply;
import 'package:PiliPlus/grpc/grpc_req.dart';
import 'package:PiliPlus/grpc/url.dart';

abstract final class DynGrpc {
  static Future<int?> dynRed() async {
    final res = await GrpcReq.request(
      GrpcUrl.dynRed,
      DynRedReq(tabOffset: [TabOffset(tab: 1)]),
      DynRedReply.fromBuffer,
    );
    return res.dataOrNull?.dynRedItem.count.toInt();
  }
}
