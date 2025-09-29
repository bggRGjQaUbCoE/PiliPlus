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
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
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
    this.isNested = false,
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
  final bool isNested;

  @override
  State<VideoReplyReplyPanel> createState() => _VideoReplyReplyPanelState();
}

class _VideoReplyReplyPanelState extends State<VideoReplyReplyPanel>
    with SingleTickerProviderStateMixin, CommonSlideMixin {
  late VideoReplyReplyController _controller;
  late final _tag = Utils.makeHeroTag('${widget.rpid}${widget.dialog}');
  Animation<Color?>? colorAnimation;

  late final bool isDialogue = widget.dialog != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = PrimaryScrollController.of(context);
    _controller
      ..didChangeDependencies(context)
      ..nestedController = controller is ExtendedNestedScrollController
          ? controller
          : null;
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
      widget.firstFloor ?? _controller.firstFloor.value;

  ScrollController get scrollController =>
      _controller.nestedController ?? _controller.scrollController;

  @override
  Widget buildList(ThemeData theme) {
    final child = refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        key: ValueKey(scrollController.hashCode),
        controller: scrollController,
        physics: widget.isNested
            ? const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              )
            : const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (!isDialogue) ...[
            if (widget.firstFloor case final firstFloor?)
              _header(theme, firstFloor)
            else
              Obx(() {
                final firstFloor = _controller.firstFloor.value;
                if (firstFloor == null) {
                  return const SliverToBoxAdapter();
                }
                return _header(theme, firstFloor);
              }),
            _sortWidget(theme),
          ],
          Obx(() => _buildBody(theme, _controller.loadingState.value)),
        ],
      ),
    );
    if (widget.isNested) {
      return ExtendedVisibilityDetector(
        uniqueKey: Key(_tag),
        child: child,
      );
    }
    return child;
  }

  Widget _header(ThemeData theme, ReplyInfo firstFloor) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: ReplyItemGrpc(
            replyItem: firstFloor,
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

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<ReplyInfo>?> loadingState,
  ) {
    final jumpIndex = _controller.index.value;
    return switch (loadingState) {
      Loading() => SliverPrototypeExtentList.builder(
        prototypeItem: const VideoReplySkeleton(),
        itemBuilder: (_, _) => const VideoReplySkeleton(),
        itemCount: 8,
      ),
      Success(:var response!) => SuperSliverList.builder(
        listController: _controller.listController,
        itemBuilder: (context, index) {
          if (index == response.length) {
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
          final child = _replyItem(context, response[index], index);
          if (jumpIndex == index) {
            return AnimatedBuilder(
              animation: colorAnimation ??=
                  ColorTween(
                    begin: theme.colorScheme.onInverseSurface,
                    end: theme.colorScheme.surface,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller.animController,
                      curve: const Interval(0.8, 1.0), // 前0.8s不变, 后0.2s开始动画
                    ),
                  ),
              child: child,
              builder: (context, child) {
                return ColoredBox(
                  color: colorAnimation!.value!,
                  child: child,
                );
              },
            );
          }
          return child;
        },
        itemCount: response.length + 1,
      ),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _replyItem(BuildContext context, ReplyInfo replyItem, int index) {
    return ReplyItemGrpc(
      replyItem: replyItem,
      replyLevel: isDialogue ? 3 : 2,
      onReply: (replyItem) =>
          _controller.onReply(this.context, replyItem: replyItem, index: index),
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
          isNested: widget.isNested,
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
}
