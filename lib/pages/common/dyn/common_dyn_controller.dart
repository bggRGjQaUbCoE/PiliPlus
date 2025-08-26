import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:get/get.dart';

abstract class CommonDynController extends ReplyController<MainListReply>
    with GetSingleTickerProviderStateMixin {
  int get oid;
  int get replyType;

  bool _showFab = true;
  late final AnimationController fabAnimationCtr;
  late final Animation<Offset> fabAnim;

  late final RxBool showTitle = false.obs;

  late final horizontalPreview = Pref.horizontalPreview;
  late final List<double> ratio = Pref.dynamicDetailRatio;

  double offsetDy = 1;

  @override
  void onInit() {
    fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fabAnim =
        Tween<Offset>(
          begin: Offset(0, offsetDy),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: fabAnimationCtr,
            curve: Curves.easeInOut,
          ),
        );
    fabAnimationCtr.forward();
    scrollController.addListener(listener);
    super.onInit();
  }

  void listener() {
    showTitle.value = scrollController.positions.first.pixels > 55;

    final ScrollDirection direction1 =
        scrollController.positions.first.userScrollDirection;
    late final ScrollDirection direction2 =
        scrollController.positions.last.userScrollDirection;
    if (direction1 == ScrollDirection.forward ||
        direction2 == ScrollDirection.forward) {
      showFab();
    } else if (direction1 == ScrollDirection.reverse ||
        direction2 == ScrollDirection.reverse) {
      hideFab();
    }
  }

  void showFab() {
    if (!_showFab) {
      _showFab = true;
      fabAnimationCtr.forward();
    }
  }

  void hideFab() {
    if (_showFab) {
      _showFab = false;
      fabAnimationCtr.reverse();
    }
  }

  @override
  void onClose() {
    fabAnimationCtr.dispose();
    scrollController.removeListener(listener);
    super.onClose();
  }

  @override
  Future<LoadingState<MainListReply>> customGetData() => ReplyGrpc.mainList(
    type: replyType,
    oid: oid,
    mode: mode.value,
    cursorNext: cursorNext,
    offset: paginationReply?.nextOffset,
  );
}
