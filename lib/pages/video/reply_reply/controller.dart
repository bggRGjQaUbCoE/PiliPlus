import 'dart:async';
import 'dart:collection';

import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, DetailListReply;
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/item.dart';
import 'package:PiliPlus/pages/common/publish/publish_route.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/video/reply_new/view.dart';
import 'package:PiliPlus/pages/video/reply_reply/tree.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class VideoReplyReplyController extends ReplyController
    with GetSingleTickerProviderStateMixin, ReplyLocateMixin {
  VideoReplyReplyController({
    required this.hasRoot,
    required this.id,
    required this.oid,
    required this.rpid,
    required this.dialog,
    required this.replyType,
  });
  final int? dialog;
  int? id;
  // 视频aid 请求时使用的oid
  int oid;
  // rpid 请求楼中楼回复
  int rpid;
  int replyType;

  bool hasRoot = false;
  final firstFloor = Rxn<ReplyInfo>();

  final index = RxnInt();

  final listController = ListController();

  late final horizontalPreview = Pref.horizontalPreview;

  @override
  dynamic get sourceId => replyType == 1 ? IdUtils.av2bv(oid) : oid;

  @override
  ReplySortType get prefSortType => Pref.reply2SortType;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<ReplyInfo>? getDataList(response) {
    return dialog != null ? response.replies : response.root.replies;
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
        setIndexById(Int64(id!), data.root.replies);
        id = null;
      }
    }

    return false;
  }

  Iterable<ReplyInfo> getParentChain(int index, ReplyInfo? firstFloor) {
    final data = loadingState.value.data!;
    final item = data[index];
    final replies = [item];
    for (var i = index - 1, parent = item.parent; i >= 0; i--) {
      final item = data[i];
      if (item.id == parent) {
        replies.add(item);
        parent = item.parent;
      }
    }
    if (firstFloor != null && firstFloor.id != replies.last.id) {
      replies.add(firstFloor);
    }
    return replies.reversed;
  }

  bool setIndexById(Int64 id64, [List<ReplyInfo>? replies]) {
    final index = (replies ?? loadingState.value.data!).indexWhere(
      (item) => item.id == id64,
    );
    if (index != -1) {
      this.index.value = index;
      jumpToItem(index);
      return true;
    }
    return false;
  }

  ExtendedNestedScrollController? nestedController;

  @pragma('vm:notify-debugger-on-exception')
  void jumpToItem(int index) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      colorAnimController.forward(from: 0);
      try {
        // ignore: invalid_use_of_visible_for_testing_member
        final offset = listController.getOffsetToReveal(index, 0.25);
        if (offset.isFinite) {
          if (nestedController case final nestedController?) {
            nestedController.nestedPositions.last.localJumpTo(offset);
          } else {
            scrollController.jumpTo(offset);
          }
        }
      } catch (_) {}
    });
  }

  @override
  Future<LoadingState> customGetData() => dialog != null
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
          mode: mode,
          offset: paginationReply?.nextOffset,
        );

  @override
  Future<void> onReload() {
    if (loadingState.value.isSuccess) {
      index.value = null;
    }
    return super.onReload();
  }

  @override
  void onReply(
    ReplyInfo? replyItem, {
    int? oid,
    int? replyType,
    int? index,
    MentionItem? mentionItem,
  }) {
    assert(replyItem != null && index != null);

    final (bool inputDisable, String? hint) = replyHint;
    if (inputDisable) {
      return;
    }

    final oid = replyItem!.oid.toInt();
    final root = replyItem.id.toInt();
    final key = oid + root;

    Get.key.currentState!
        .push(
          PublishRoute(
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
          ),
        )
        .then((replyInfo) {
          if (replyInfo is ReplyInfo) {
            savedReplies.remove(key);

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

  Timer? _replyTimer;
  Future<void>? _inflightReply;
  final progress = RxDouble(0);

  bool get inFetchReply => _replyTimer != null || _inflightReply != null;

  void _cancelReplyTimer() {
    _replyTimer?.cancel();
    _replyTimer = null;
  }

  void nextReplyRound() {
    _replyTimer = null;
    _inflightReply = _fetchNextReply();
  }

  void _createReplyTimer() {
    _replyTimer = Timer(const Duration(milliseconds: 300), nextReplyRound);
  }

  Future<void> _fetchNextReply() async {
    await queryData(false);
    _inflightReply = null;
    if (isEnd) {
      progress.value = 1;
      SmartDialog.showToast('已完成拉取');
    } else {
      progress.value = count.rawValue > 0
          ? (loadingState.rawValue.dataOrNull?.length ?? 0) / count.rawValue
          : 0;
      _createReplyTimer();
    }
  }

  @override
  Future<void> onLoadMore() {
    if (_replyTimer != null) {
      assert(_inflightReply == null);
      _cancelReplyTimer();
      return _inflightReply = _fetchNextReply();
    } else if (_inflightReply != null) {
      return _inflightReply!;
    }
    return super.onLoadMore();
  }

  @override
  Future<void> onRefresh() async {
    if (_inflightReply != null) await _inflightReply;
    _cancelReplyTimer();
    return super.onRefresh();
  }

  @override
  void onClose() {
    _cancelReplyTimer();
    super.onClose();
  }

  final replyTree = Rxn<ReplyTree>();

  void buildTree() {
    final data = loadingState.rawValue.data!;
    final seen = HashSet<Int64>();
    data.retainWhere((i) => seen.add(i.id));
    replyTree.value = ReplyTree.build(
      data: data,
      seen: seen,
      rootId: firstFloor.rawValue?.id ?? data.first.root,
      removed: const {},
    );
  }

  void toggleCollapseTree(int index) {
    replyTree.rawValue!.toggleCollapse(index);
    replyTree.refresh();
  }
}
