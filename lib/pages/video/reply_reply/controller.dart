import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, DetailListReply, Mode;
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/publish/publish_route.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/video/reply_new/view.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/pages/video/reply_reply/reply_tree.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class VideoReplyReplyController extends ReplyController
    with GetSingleTickerProviderStateMixin {
  VideoReplyReplyController({
    required this.hasRoot,
    required this.id,
    required this.oid,
    required this.rpid,
    required this.dialog,
    required this.replyType,
    this.seedReplies,
    this.seedRootId,
    this.seedOffset,
  });
  final int? dialog;
  int? id;
  // 视频aid 请求时使用的oid
  int oid;
  // rpid 请求楼中楼回复
  int rpid;
  int replyType;

  // seed 模式：复用父面板已加载数据，不再请求深层评论
  final List<ReplyInfo>? seedReplies;
  final int? seedRootId;
  final String? seedOffset;
  bool get isSeedMode => seedReplies != null;
  Worker? _seedCountWorker;

  /// seed 模式下过滤为深层评论的子树（不含其自身），否则返回原数据
  List<ReplyInfo> get subtreeData {
    final data = loadingState.value.data;
    if (!isSeedMode || data == null) return data ?? const [];
    return extractSubtree(data, Int64(rpid));
  }

  /// 树输入：有效 flat（保留被屏蔽 + 合成缺失父）+ suppressed 映射
  ({List<ReplyInfo> flat, Map<Int64, ReplySuppressReason> suppressed})
      get treeInput => buildTreeInput(
            replies: subtreeData,
            removed: _removedReplies,
            rootId: Int64(rpid),
          );

  bool hasRoot = false;
  final firstFloor = Rxn<ReplyInfo>();

  final index = RxnInt();

  final listController = ListController();

  /// 树状模式下的折叠节点 rpid 集合
  final collapsedRpids = <Int64>{}.obs;

  /// 当前悬停的引导线所属节点 rpid（整条线跨行高亮）；null = 无
  final hoveredLine = Rxn<Int64>();

  /// detailList 过滤掉的被屏蔽评论（rpid → ReplyInfo），树模式保留其数据
  final _removedReplies = <Int64, ReplyInfo>{};

  void toggleCollapse(Int64 rpid) {
    if (!collapsedRpids.remove(rpid)) {
      collapsedRpids.add(rpid);
    }
  }

  AnimationController? _controller;
  AnimationController get animController => _controller ??= AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );

  late final horizontalPreview = Pref.horizontalPreview;

  @override
  dynamic get sourceId => replyType == 1 ? IdUtils.av2bv(oid) : oid;

  @override
  void onInit() {
    super.onInit();
    mode = Mode.MAIN_LIST_TIME;
    if (isSeedMode) {
      // seed 模式：直接用父面板已加载数据，跳过 DetailList(root=深层评论)（该请求必然返回空）
      loadingState.value = Success(seedReplies);
      isEnd = seedOffset == null;
      _refreshSeedCount();
      // 每次数据变化后重算子树计数（增量续拉追加后）
      _seedCountWorker = ever(loadingState, (_) => _refreshSeedCount());
    } else {
      queryData();
    }
  }

  void _refreshSeedCount() {
    final data = loadingState.value.data;
    if (data != null) {
      count.value = extractSubtree(data, Int64(rpid)).length;
    }
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
      if (isRefresh) {
        collapsedRpids.clear();
        _removedReplies.clear();
      }
      // seed 模式的 count 由子树大小决定（见 _refreshSeedCount），不覆盖
      if (!isSeedMode) {
        count.value = data.root.count.toInt();
      }
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

  bool setIndexById(Int64 id64, [List<ReplyInfo>? replies]) {
    final useTree = dialog == null && Pref.replyTreeEnabled;
    if (useTree) {
      final input = buildTreeInput(
        replies: replies ?? subtreeData,
        removed: _removedReplies,
        rootId: Int64(rpid),
      );
      final rows = buildReplyTree(
        flat: input.flat,
        rootId: Int64(rpid),
        collapsed: collapsedRpids,
        maxDepth: Pref.replyTreeMaxDepth,
      );
      final index = rows.indexWhere(
        (row) => row is ReplyTreeItem && row.reply.id == id64,
      );
      if (index != -1) {
        this.index.value = index;
        jumpToItem(index);
        return true;
      }
      return false;
    }
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
      animController.forward(from: 0);
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
  Future<LoadingState> customGetData() {
    if (isSeedMode) {
      return ReplyGrpc.detailList(
        type: replyType,
        oid: oid,
        root: seedRootId ?? 0,
        rpid: 0,
        mode: mode,
        offset: paginationReply?.nextOffset ?? seedOffset,
        removedOut: _removedReplies,
      );
    }
    return dialog != null
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
            removedOut: _removedReplies,
          );
  }

  @override
  void checkIsEnd(int length) {
    if (isSeedMode) return; // seed 模式以 API cursor.isEnd 为准
    super.checkIsEnd(length);
  }

  @override
  Future<void> onRefresh() {
    if (isSeedMode) return _continueSeedLoad();
    return super.onRefresh();
  }

  @override
  Future<void> onLoadMore() {
    if (isSeedMode) return _continueSeedLoad();
    return super.onLoadMore();
  }

  /// seed 模式增量续拉：从 seedOffset 起连续翻页，直到 isEnd 或无新数据
  Future<void> _continueSeedLoad() async {
    if (isLoading || isEnd) return;
    var guard = 0;
    while (!isEnd && guard < 50) {
      guard++;
      final before = loadingState.value.data?.length ?? 0;
      await queryData(false);
      final after = loadingState.value.data?.length ?? 0;
      if (after <= before) break; // 无新数据，避免死循环
    }
  }

  @override
  Future<void> onReload() {
    if (isSeedMode) {
      // seed 模式重新展示 seed 数据，避免 Loading 骨架卡死（排序对子树视图无意义）
      index.value = null;
      loadingState.value = Success(seedReplies);
      _refreshSeedCount();
      return Future.value();
    }
    if (loadingState.value.isSuccess) {
      index.value = null;
    }
    return super.onReload();
  }

  @override
  void queryBySort() {
    if (isSeedMode) return; // 排序对 seed 子树视图无意义
    super.queryBySort();
  }

  @override
  void onReply(
    ReplyInfo? replyItem, {
    int? oid,
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

  @override
  void onClose() {
    _seedCountWorker?.dispose();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }
}
