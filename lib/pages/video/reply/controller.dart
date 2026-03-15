import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show MainListReply, ReplyInfo;
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoReplyController extends ReplyController<MainListReply>
    with GetSingleTickerProviderStateMixin {
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

  bool _isFabVisible = true;
  late final AnimationController _fabAnimationCtr;
  late final Animation<Offset> animation;
  late final Animation<double> opacityAnimation;

  @override
  void onInit() {
    super.onInit();
    _fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..forward();
    animation = _fabAnimationCtr.drive(
      Tween<Offset>(
        begin: const Offset(0.0, 2.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );
    opacityAnimation = _fabAnimationCtr.drive(
      CurveTween(curve: Curves.easeInOut),
    );
  }

  void showFab() {
    if (!_isFabVisible) {
      _isFabVisible = true;
      _fabAnimationCtr.forward();
    }
  }

  void hideFab() {
    if (_isFabVisible) {
      _isFabVisible = false;
      _fabAnimationCtr.reverse();
    }
  }

  @override
  List<ReplyInfo>? getDataList(MainListReply response) {
    return response.replies;
  }

  @override
  Future<LoadingState<MainListReply>> customGetData() => ReplyGrpc.mainList(
    oid: isPugv ? videoCtr.epId! : aid,
    type: videoType.replyType,
    mode: mode.value,
    cursorNext: cursorNext,
    offset: paginationReply?.nextOffset,
  );

  @override
  void onClose() {
    _fabAnimationCtr.dispose();
    super.onClose();
  }
}
