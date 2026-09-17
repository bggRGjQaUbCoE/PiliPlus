import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, DetailListReply, Mode;
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/publish/publish_route.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/video/reply_new/view.dart';
import 'package:PiliPlus/pages/video/reply_reply/reply_tree.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
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
    this.removedReplies,
    this.owner,
  });
  final int? dialog;
  int? id;
  // 视频aid 请求时使用的oid
  int oid;
  // rpid 请求楼中楼回复
  int rpid;
  int replyType;

  /// 继承自父面板的被屏蔽评论数据（rpid → ReplyInfo）
  final Map<Int64, ReplyInfo>? removedReplies;

  /// 数据所有者。为 null 时本控制器自己取数（普通楼中楼面板）；
  /// 非 null 时只读该控制器（"继续此讨论串"面板）。
  ///
  /// 必须经构造函数传入，**不能事后赋值**：GetX 在 `Get.put` 内部就同步调用
  /// `onInit`（lifecycle.dart 的 `onStart → _onStart → onInit`），事后赋值
  /// 会让 `onInit` 读到的仍是 null，从而误判为普通面板去发请求。
  final VideoReplyReplyController? owner;

  /// 楼层的原始数据（来自 owner 或自身）
  List<ReplyInfo> get _rawData =>
      (owner ?? this).loadingState.value.data ?? const [];

  /// 本面板渲染的评论列表：子面板筛出以 rpid 为根的子树，普通面板即整层。
  List<ReplyInfo> get subtreeData =>
      owner == null ? _rawData : extractSubtree(_rawData, Int64(rpid));

  /// 树输入：有效 flat（保留被屏蔽 + 合成缺失父）+ suppressed 映射
  ({List<ReplyInfo> flat, Map<Int64, ReplySuppressReason> suppressed})
      get treeInput => buildTreeInput(
            replies: subtreeData,
            removed: _removedReplies,
            rootId: Int64(rpid),
          );

  /// 已收集的被屏蔽评论（rpid → ReplyInfo），供子面板继承
  Map<Int64, ReplyInfo> get blockedReplies => _removedReplies;

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
    final cacheSortType = Pref.reply2SortType;
    sortType.value = cacheSortType;
    mode = cacheSortType == .time ? Mode.MAIN_LIST_TIME : Mode.MAIN_LIST_HOT;
    // 父面板已过滤掉被屏蔽评论，这里继承其收集结果以重建占位
    if (removedReplies case final removedReplies?) {
      _removedReplies.addAll(removedReplies);
    }
    // 子面板（owner != null）只读父控制器的数据，自己不取数：
    // 它的 subtreeData 从 owner 读，这里发出的请求结果从不被渲染，
    // 只会白费一次请求（且嵌套 root 会被服务端无视，见设计 §2.2）。
    if (owner == null) {
      queryData();
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

    if (data is DetailListReply) {
      if (isRefresh) {
        collapsedRpids.clear();
      }
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
  Future<void> onRefresh() {
    // 刷新会重新取第一页：上一次 load-more 的失败信息已过期，
    // 继续留着会让哨兵行一直显示旧错误并挡住自动翻页
    loadMoreError.value = null;
    // 刷新前清空上一轮收集的被屏蔽评论，请求返回后 detailList 重新收集
    _removedReplies.clear();
    // super 链（ReplyController → CommonListController）负责重置
    // paginationReply / cursorNext / subjectControl / page，并以 isRefresh=true 取数
    return super.onRefresh();
  }

  /// 非刷新请求的失败信息；null 表示无错误。供底部哨兵行显示重试入口。
  final loadMoreError = RxnString();

  @override
  void onLoadMoreError(String? errMsg) {
    loadMoreError.value = errMsg ?? '加载失败';
  }

  /// 用户点「重试」：清掉错误再走一次正常的加载更多入口。
  void retryLoadMore() {
    loadMoreError.value = null;
    onLoadMore();
  }

  /// 正在补全本楼层（一次一页）时为 true
  final isCompletingFloor = false.obs;
  /// 已加载的楼层**唯一条数**（去重后，与 [count] 同量纲；便于 Obx 订阅）
  final floorLoaded = 0.obs;
  bool _completing = false;

  /// 本楼层是否已完整（服务端给出终止信号）
  bool get isFloorComplete => isEnd;

  /// 一次一页地把本楼层补全。可被 `cancelFloorCompletion()` 打断。
  ///
  /// 判停完全基于 [decideFloorLoad]，不依赖任何固定页数/空闲页数常数。
  /// 页间隔 300ms：连续数百个请求需要留间隔，避免触发风控。
  Future<void> ensureFloorComplete() async {
    if (_completing || isEnd) return;
    _completing = true;
    isCompletingFloor.value = true;
    try {
      while (_completing) {
        // 用户滚动可能在加载同一楼层；queryData 遇 isLoading 会直接返回，
        // 若不等它结束，下面会因"游标未推进"误判为翻完而提前收工。
        while (isLoading && _completing) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        if (!_completing) break;

        final total = count.value;
        // 必须用「去重后的唯一条数」：loadingState.data 是裸 addAll 累积的，
        // 而热排序下边界条目会跨页重复返回（见 dedupeRepliesById）。
        // 用原始长度会涨得比真实条数快，从而提前满足 `>= floorTotal` 而静默丢评论——
        // 正是本功能要消灭的那种失败。
        final loaded = dedupeRepliesById(
          loadingState.value.data ?? const [],
        ).length;
        floorLoaded.value = loaded;
        if (decideFloorLoad(
              floorTotal: total,
              floorLoaded: loaded,
              isEnd: isEnd,
              cursorAdvanced: true,
            ) ==
            FloorLoad.done) {
          break;
        }
        final beforeOffset = paginationReply?.nextOffset;
        await queryData(false);
        floorLoaded.value = dedupeRepliesById(
          loadingState.value.data ?? const [],
        ).length;
        if (!_completing) break;
        // 用真实“游标是否推进”重算一次，避免空转
        final advanced = paginationReply?.nextOffset != beforeOffset;
        if (decideFloorLoad(
              floorTotal: count.value,
              floorLoaded: floorLoaded.value,
              isEnd: isEnd,
              cursorAdvanced: advanced,
            ) ==
            FloorLoad.done) {
          break;
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }
    } catch (e) {
      // queryData 的异常路径不会复位 isLoading（common_list_controller.dart:31 置位、:64 复位），
      // 不兜底会永久卡死该控制器之后的所有 queryData（含 onRefresh）。
      // 这里**不复抛**：调用点是 unawaited()，复抛会变成未处理的异步错误。
      // 但也不静默——复用 Task 2 的失败提示通道，让哨兵行能显示错误并重试。
      isLoading = false;
      onLoadMoreError(e.toString());
    } finally {
      _completing = false;
      isCompletingFloor.value = false;
    }
  }

  /// 打断补全（面板关闭时调用）
  void cancelFloorCompletion() {
    _completing = false;
    isCompletingFloor.value = false;
  }

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
    cancelFloorCompletion();
    _controller?.dispose();
    _controller = null;
    // 必须是 super.onClose()：继承链上唯一的 dispose() 是 get 包的
    // ListNotifierMixin.dispose，它不向上链式调用，导致 CommonController 的
    // scrollController.dispose() 与 ReplyController 的 savedReplies.clear()
    // 从不执行。onClose() 由 _onDelete() 触发且有 _isClosed 守卫，恰好一次，
    // 改成 super.onClose() 不会双重释放。
    super.onClose();
  }
}
