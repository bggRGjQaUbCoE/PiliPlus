import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show MainListReply, ReplyInfo;
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainReplyController extends ReplyController<MainListReply>
    with GetSingleTickerProviderStateMixin {
  late final int oid;
  late final int replyType;

  @override
  int get sourceId => oid;

  bool _showFab = true;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    oid = args['oid'];
    replyType = args['replyType'];

    queryData();
  }

  void showFab() {
    if (!_showFab) {
      _showFab = true;
      _fabAnimationCtr.forward();
    }
  }

  void hideFab() {
    if (_showFab) {
      _showFab = false;
      _fabAnimationCtr.reverse();
    }
  }

  @override
  Future<LoadingState<MainListReply>> customGetData() => ReplyGrpc.mainList(
    type: replyType,
    oid: oid,
    mode: mode.value,
    cursorNext: cursorNext,
    offset: paginationReply?.nextOffset,
  );

  @override
  List<ReplyInfo>? getDataList(MainListReply response) => response.replies;

  late final AnimationController _fabAnimationCtr = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..forward();

  late final Animation<Offset> fabAnim = Tween<Offset>(
    begin: const Offset(0, 2),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _fabAnimationCtr, curve: Curves.easeInOut));

  @override
  void onClose() {
    _fabAnimationCtr.dispose();
    super.onClose();
  }
}
