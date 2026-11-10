import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/grpc/grpc_req.dart';
import 'package:PiliPlus/grpc/url.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/video/video_play_info/subtitle.dart';
import 'package:fixnum/fixnum.dart';

abstract final class DmGrpc {
  static Future<LoadingState<DmSegMobileReply>> dmSegMobile({
    required int cid,
    required int segmentIndex,
    int type = 1,
  }) {
    return GrpcReq.request(
      GrpcUrl.dmSegMobile,
      DmSegMobileReq(
        oid: Int64(cid),
        segmentIndex: Int64(segmentIndex),
        type: type,
      ),
      DmSegMobileReply.fromBuffer,
      isolate: true,
    );
  }

  static Future<LoadingState<DmViewReply>> dmView(int aid, int cid) {
    return GrpcReq.request(
      GrpcUrl.dmView,
      DmViewReq(pid: Int64(aid), oid: Int64(cid), type: 1),
      DmViewReply.fromBuffer,
    );
  }

  static List<Subtitle>? dmViewToSubtitle(DmViewReply? dmView) {
    if (dmView == null) return null;

    if (dmView.hasSubtitle()) {
      final subtitles = dmView.subtitle.subtitles;
      if (subtitles.isNotEmpty) {
        return subtitles
            .map(
              (e) => Subtitle(
                id: e.id.toInt(),
                lan: e.lan,
                lanDoc: e.lanDoc,
                type: e.type.value,
                subtitleUrl: e.subtitleUrl,
                isAi: e.type == .AI,
              ),
            )
            .toList()
          ..sort();
      }
    }

    return null;
  }
}
