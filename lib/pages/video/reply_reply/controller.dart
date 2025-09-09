import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, DetailListReply, Mode;
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/video/reply_new/view.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/dialog/dialog_route.dart';

class VideoReplyReplyController extends ReplyController
    with GetSingleTickerProviderStateMixin {
  VideoReplyReplyController({
    required this.hasRoot,
    required this.id,
    required this.oid,
    required this.rpid,
    required this.dialog,
    required this.replyType,
    required this.isDialogue,
  });
  final int? dialog;
  final bool isDialogue;
  int? id;
  // 视频aid 请求时使用的oid
  int oid;
  // rpid 请求楼中楼回复
  int rpid;
  int replyType;

  bool hasRoot = false;
  late final Rx<ReplyInfo?> firstFloor = Rx<ReplyInfo?>(null);

  int? index;
  AnimationController? animController;

  late final horizontalPreview = Pref.horizontalPreview;

  @override
  dynamic get sourceId => replyType == 1 ? IdUtils.av2bv(oid) : oid;

  @override
  void onInit() {
    super.onInit();
    mode.value = Mode.MAIN_LIST_TIME;
    queryData();
  }

  @override
  List<ReplyInfo>? getDataList(response) {
    return isDialogue ? response.replies : response.root.replies;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success response) {
    final data = response.response;

    subjectControl = data.subjectControl;
    upMid ??= data.subjectControl.upMid;
    paginationReply = data.paginationReply;
    isEnd = data.cursor.isEnd;

    // reply2Reply // isDialogue.not
    if (data is DetailListReply) {
      count.value = data.root.count.toInt();
      if (isRefresh && !hasRoot) {
        firstFloor.value ??= data.root;
      }
      if (id != null) {
        final id64 = Int64(id!);
        final index = data.root.replies.indexWhere((item) => item.id == id64);
        if (index != -1) {
          this.index = index;
          animController = AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: this,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await Future.delayed(
              const Duration(milliseconds: 800),
              () => animController?.forward(), // may dispose
            );
            this.index = null;
          });
        }
        id = null;
      }
    }

    return false;
  }

  @override
  Future<LoadingState> customGetData() => isDialogue
      ? ReplyGrpc.dialogList(
          type: replyType,
          oid: oid,
          root: rpid,
          dialog: dialog!,
          offset: paginationReply?.nextOffset,
        )
      : ReplyGrpc.detailList(
          type: replyType,
          oid: oid,
          root: rpid,
          rpid: id ?? 0,
          mode: mode.value,
          offset: paginationReply?.nextOffset,
        );

  @override
  void queryBySort() {
    mode.value = mode.value == Mode.MAIN_LIST_HOT
        ? Mode.MAIN_LIST_TIME
        : Mode.MAIN_LIST_HOT;
    onReload();
  }

  @override
  void onReply(
    BuildContext context, {
    int? oid,
    ReplyInfo? replyItem,
    int? replyType,
    int? index,
  }) {
    assert(replyItem != null && index != null);

    final (bool inputDisable, String? hint) = replyHint;
    if (inputDisable) {
      return;
    }

    final oid = replyItem!.oid.toInt();
    final root = replyItem.id.toInt();
    final key = oid + root;

    Navigator.of(context)
        .push(
          GetDialogRoute(
            pageBuilder: (buildContext, animation, secondaryAnimation) {
              return ReplyPage(
                hint: hint,
                oid: oid,
                root: root,
                parent: root,
                replyType: this.replyType,
                replyItem: replyItem,
                items: savedReplies[key],
                onSave: (reply) {
                  if (reply.isEmpty) {
                    savedReplies.remove(key);
                  } else {
                    savedReplies[key] = reply.toList();
                  }
                },
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.linear)),
                ),
                child: child,
              );
            },
          ),
        )
        .then((res) {
          if (res != null) {
            savedReplies.remove(key);
            ReplyInfo replyInfo = RequestUtils.replyCast(res);

            count.value += 1;
            loadingState
              ..value.dataOrNull?.insert(index! + 1, replyInfo)
              ..refresh();
            if (enableCommAntifraud) {
              onCheckReply(replyInfo, isManual: false);
            }
          }
        });
  }

  @override
  void onClose() {
    animController?.dispose();
    animController = null;
    super.dispose();
  }
}
