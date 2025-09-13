import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, Mode;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/controller.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:super_sliver_list/super_sliver_list.dart';

class VideoReplyReplyPanel extends CommonSlidePage {
  const VideoReplyReplyPanel({
    super.key,
    super.enableSlide,
    this.id,
    required this.oid,
    required this.rpid,
    this.dialog,
    this.firstFloor,
    required this.isVideoDetail,
    required this.replyType,
    this.onViewImage,
    this.onDismissed,
  });
  final int? id;
  final int oid;
  final int rpid;
  final int? dialog;
  final ReplyInfo? firstFloor;
  final bool isVideoDetail;
  final int replyType;
  final VoidCallback? onViewImage;
  final ValueChanged<int>? onDismissed;

  @override
  State<VideoReplyReplyPanel> createState() => _VideoReplyReplyPanelState();
}

class _VideoReplyReplyPanelState
    extends CommonSlidePageState<VideoReplyReplyPanel> {
  late VideoReplyReplyController _controller;
  late final _tag = Utils.makeHeroTag('${widget.rpid}${widget.dialog}');

  Animation<Color?>? colorAnimation;

  bool get isDialogue => widget.dialog != null;

  ScrollController? _scrollController;

  late ScrollController scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.didChangeDependencies(context);
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      VideoReplyReplyController(
        hasRoot: widget.firstFloor != null,
        id: widget.id,
        oid: widget.oid,
        rpid: widget.rpid,
        dialog: widget.dialog,
        replyType: widget.replyType,
      ),
      tag: _tag,
    );
  }

  @override
  void dispose() {
    Get.delete<VideoReplyReplyController>(tag: _tag);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(ThemeData theme) {
    Widget child() => enableSlide ? slideList(theme) : buildList(theme);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget.isVideoDetail
          ? Column(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: theme.dividerColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 12, right: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(isDialogue ? '对话列表' : '评论详情'),
                      IconButton(
                        tooltip: '关闭',
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: Get.back,
                      ),
                    ],
                  ),
                ),
                Expanded(child: child()),
              ],
            )
          : child(),
    );
  }

  ReplyInfo? get firstFloor =>
      _controller.firstFloor.value ?? widget.firstFloor;

  @override
  Widget buildList(ThemeData theme) {
    // ExtendedNestedScrollController 在 ButtomSheet 的 Scaffold 中行为怪异
    scrollController = isDialogue
        ? _scrollController ??= ScrollController()
        : PrimaryScrollController.of(context);
    return refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        key: ValueKey(scrollController.hashCode), // force reset
        controller: scrollController,
        slivers: [
          _buildFirstFloor(theme),
          _sortWidget(theme),
          Obx(() {
            final state = _controller.loadingState.value;
            final int? jump = _controller.index.value;
            if (jump != null) {
              SchedulerBinding.instance.addPostFrameCallback(
                (_) => _jumpToItem(jump),
              );
            }
            return switch (state) {
              Loading() => SliverPrototypeExtentList.builder(
                prototypeItem: const VideoReplySkeleton(),
                itemBuilder: (_, _) => const VideoReplySkeleton(),
                itemCount: 8,
              ),
              Success<List<ReplyInfo>?>(:var response!) =>
                SuperSliverList.builder(
                  itemCount: response.length + 1,
                  listController: _controller.listController,
                  itemBuilder: (context, index) => _buildBody(
                    context,
                    theme,
                    response,
                    index,
                    index == jump,
                  ),
                ),
              Error(:var errMsg) => HttpError(
                isSliver: true,
                errMsg: errMsg,
                onReload: _controller.onReload,
              ),
            };
          }),
        ],
      ),
    );
  }

  Widget _sortWidget(ThemeData theme) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverPersistentHeaderDelegate(
        extent: 40,
        bgColor: theme.colorScheme.surface,
        child: Container(
          height: 40,
          padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () {
                  final count = _controller.count.value;
                  return count != -1
                      ? Text(
                          '相关回复共${NumUtils.numFormat(count)}条',
                          style: const TextStyle(fontSize: 13),
                        )
                      : const SizedBox.shrink();
                },
              ),
              SizedBox(
                height: 35,
                child: TextButton.icon(
                  onPressed: _controller.queryBySort,
                  icon: Icon(
                    Icons.sort,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  label: Obx(
                    () => Text(
                      _controller.mode.value == Mode.MAIN_LIST_HOT
                          ? '按热度'
                          : '按时间',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstFloor(ThemeData theme) {
    return Obx(
      () => firstFloor == null || isDialogue
          ? const SliverToBoxAdapter()
          : SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: ReplyItemGrpc(
                    replyItem: firstFloor!,
                    replyLevel: 2,
                    needDivider: false,
                    onReply: (replyItem) => _controller.onReply(
                      context,
                      replyItem: replyItem,
                      index: -1,
                    ),
                    upMid: _controller.upMid,
                    onViewImage: widget.onViewImage,
                    onDismissed: widget.onDismissed,
                    onCheckReply: (item) =>
                        _controller.onCheckReply(item, isManual: true),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 20,
                    color: theme.dividerColor.withValues(alpha: 0.1),
                    thickness: 6,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    List<ReplyInfo> data,
    int index,
    bool highLight,
  ) {
    if (index == data.length) {
      _controller.onLoadMore();
      return Container(
        height: 125,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          bottom: MediaQuery.viewPaddingOf(context).bottom,
        ),
        child: Text(
          _controller.isEnd ? '没有更多了' : '加载中...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.outline,
          ),
        ),
      );
    }

    final child = _replyItem(context, data[index], index);
    if (highLight) {
      return AnimatedBuilder(
        animation: colorAnimation ??=
            ColorTween(
              begin: theme.colorScheme.onInverseSurface,
              end: theme.colorScheme.surface,
            ).animate(
              CurvedAnimation(
                parent: _controller.animController,
                curve: const Interval(0.8, 1.0),
              ),
            ),
        builder: (context, _) {
          return ColoredBox(
            color: colorAnimation!.value!,
            child: child,
          );
        },
      );
    }
    return child;
  }

  Widget _replyItem(BuildContext context, ReplyInfo replyItem, int index) {
    return ReplyItemGrpc(
      replyItem: replyItem,
      replyLevel: isDialogue ? 3 : 2,
      onReply: (replyItem) =>
          _controller.onReply(context, replyItem: replyItem, index: index),
      onDelete: (item, subIndex) => _controller.onRemove(index, item, null),
      upMid: _controller.upMid,
      showDialogue: () => Scaffold.of(context).showBottomSheet(
        backgroundColor: Colors.transparent,
        constraints: const BoxConstraints(),
        (context) => VideoReplyReplyPanel(
          oid: replyItem.oid.toInt(),
          rpid: replyItem.root.toInt(),
          dialog: replyItem.dialog.toInt(),
          replyType: widget.replyType,
          isVideoDetail: true,
        ),
      ),
      jumpToDialogue: () {
        if (!_controller.setIndexById(replyItem.parent)) {
          SmartDialog.showToast('评论可能已被删除');
        }
      },
      onViewImage: widget.onViewImage,
      onDismissed: widget.onDismissed,
      onCheckReply: (item) => _controller.onCheckReply(item, isManual: true),
    );
  }

  void _jumpToItem(int index) {
    final offset = _controller.listController.getOffsetToReveal(index, 0.25);
    if (offset.isFinite) {
      final pos = scrollController.positions.last;
      final minExtent = pos.minScrollExtent;
      final maxExtent = pos.maxScrollExtent;
      final pixels = pos.pixels;
      // If the scroll view is already at the edge don't do anything.
      // Otherwise this may result in scrollbar handle artifacts.
      if ((offset <= minExtent && pixels == minExtent) ||
          (offset >= maxExtent && pixels == maxExtent)) {
        return;
      }
      pos.jumpTo(offset);
    }
  }
}
