import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show MainListReply, ReplyInfo;
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/pages/video/reply/vote/reply_vote_mixin.dart';
import 'package:PiliPlus/services/breeze/breeze_content.dart';
import 'package:PiliPlus/services/breeze/breeze_rules.dart';
import 'package:PiliPlus/services/breeze/breeze_service.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:get/get.dart';

class VideoReplyController extends ReplyController<MainListReply>
    with ReplyVoteMixin {
  VideoReplyController({
    required this.aid,
    required this.videoType,
    required this.heroTag,
  });
  int aid;
  final VideoType videoType;
  late final isPugv = videoType == VideoType.pugv;

  final String heroTag;
  late final videoCtr = Get.find<VideoDetailController>(tag: heroTag);

  @override
  dynamic get sourceId => IdUtils.av2bv(aid);

  /// The video details the pinned comment is judged with; null until the
  /// intro controller exists.
  Rx<VideoDetailData>? get breezeVideoDetail {
    try {
      return videoCtr.isUgc
          ? Get.find<UgcIntroController>(tag: heroTag).videoDetail
          : Get.find<PgcIntroController>(tag: heroTag).videoDetail;
    } catch (_) {
      return null;
    }
  }

  /// Null until the video details are loaded: the title and uploader are
  /// part of the request, so judging earlier would use missing context.
  BreezeRaw? breezePinnedRaw(ReplyInfo reply) {
    final isUgc = videoCtr.isUgc;
    final detail = breezeVideoDetail?.value;
    final title = detail?.title ?? '';
    // The ugc title is known from the route arguments before the details
    // load; the uploader's name arrives with them.
    final upName = isUgc ? detail?.owner?.name ?? '' : '';
    if (title.isEmpty || (isUgc && upName.isEmpty)) return null;
    final mid = upMid?.toInt() ?? 0;
    return BreezeContent.fromPinnedReply(
      reply,
      upName: upName,
      upMid: mid > 0 ? '$mid' : '',
      title: title,
      url: isUgc
          ? 'https://www.bilibili.com/video/${IdUtils.av2bv(aid)}'
          : 'https://www.bilibili.com/bangumi/play/ep${videoCtr.epId}',
    );
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<MainListReply> response) {
    final handled = super.customHandleResponse(isRefresh, response);
    if (isRefresh && hasUpTop) {
      final reply = response.response.upTop;
      BreezeService.prefetch(() => [breezePinnedRaw(reply)], BreezeKind.pinned);
    }
    return handled;
  }

  @override
  List<ReplyInfo>? getDataList(MainListReply response) {
    return response.replies;
  }

  @override
  Future<LoadingState<MainListReply>> customGetData() => ReplyGrpc.mainList(
    oid: isPugv ? videoCtr.epId! : aid,
    type: videoType.replyType,
    mode: mode,
    cursorNext: cursorNext,
    offset: paginationReply?.nextOffset,
  );
}
