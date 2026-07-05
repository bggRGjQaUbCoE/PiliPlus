import 'package:PiliPlus/common/widgets/image_grid/image_grid_view.dart'
    show ImageModel;
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show MainListReply, ReplyInfo;
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/reply/vote/reply_vote_mixin.dart';
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

  List<ImageModel> get allImageModels {
    final replies = loadingState.value.dataOrNull;
    if (replies == null || replies.isEmpty) {
      return const [];
    }
    final images = <ImageModel>[];
    void collect(List<ReplyInfo> items) {
      for (final reply in items) {
        if (reply.content.pictures.isNotEmpty) {
          images.addAll(
            reply.content.pictures.map(
              (item) => ImageModel(
                width: item.imgWidth,
                height: item.imgHeight,
                url: item.imgSrc,
              ),
            ),
          );
        }
        if (reply.replies.isNotEmpty) {
          collect(reply.replies);
        }
      }
    }

    collect(replies);
    return images;
  }
}
