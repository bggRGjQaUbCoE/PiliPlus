import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, Mode;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/controller.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
    this.isDialogue = false,
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
  final bool isDialogue;
  final VoidCallback? onViewImage;
  final ValueChanged<int>? onDismissed;

  @override
  State<VideoReplyReplyPanel> createState() => _VideoReplyReplyPanelState();
}

class _VideoReplyReplyPanelState
    extends CommonSlidePageState<VideoReplyReplyPanel> {
  late VideoReplyReplyController _controller;
  late final itemPositionsListener = ItemPositionsListener.create();
  late final _key = GlobalKey<ScaffoldState>();
  late final _listKey = GlobalKey();
  late final _tag = Utils.makeHeroTag(
    '${widget.rpid}${widget.dialog}${widget.isDialogue}',
  );

  ReplyInfo? get firstFloor => widget.firstFloor ?? _controller.firstFloor;

  bool get _horizontalPreview =>
      _controller.horizontalPreview && context.isLandscape;
  Function(List<String> imgList, int index)? _imageCallback;

  Animation<Color?>? colorAnimation;

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
        isDialogue: widget.isDialogue,
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageCallback = _horizontalPreview
        ? (imgList, index) => PageUtils.onHorizontalPreview(
            _key,
            this,
            imgList,
            index,
          )
        : null;
  }

  @override
  Widget buildPage(ThemeData theme) {
    Widget child() => enableSlide ? slideList(theme) : buildList(theme);
    return Scaffold(
      key: _key,
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
                      Text(widget.isDialogue ? '对话列表' : '评论详情'),
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

  @override
  Widget buildList(ThemeData theme) {
    return refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: Obx(
        () => Stack(
          clipBehavior: Clip.none,
          children: [
            ScrollablePositionedList.builder(
              key: _listKey,
              itemPositionsListener: itemPositionsListener,
              itemCount: _itemCount(_controller.loadingState.value),
              itemScrollController: _controller.itemScrollCtr,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (widget.isDialogue) {
                  return _buildBody(
                    theme,
                    _controller.loadingState.value,
                    index,
                  );
                } else if (firstFloor != null) {
                  if (index == 0) {
                    return ReplyItemGrpc(
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
                      callback: _imageCallback,
                      onCheckReply: (item) =>
                          _controller.onCheckReply(item, isManual: true),
                    );
                  } else if (index == 1) {
                    return Divider(
                      height: 20,
                      color: theme.dividerColor.withValues(alpha: 0.1),
                      thickness: 6,
                    );
                  } else if (index == 2) {
                    return _sortWidget(theme);
                  } else {
                    return _buildBody(
                      theme,
                      _controller.loadingState.value,
                      index - 3,
                    );
                  }
                } else {
                  if (index == 0) {
                    return _sortWidget(theme);
                  } else {
                    return _buildBody(
                      theme,
                      _controller.loadingState.value,
                      index - 1,
                    );
                  }
                }
              },
            ),
            if (!widget.isDialogue && _controller.loadingState.value.isSuccess)
              _header(theme),
          ],
        ),
      ),
    );
  }

  Widget _header(ThemeData theme) => firstFloor == null
      ? _sortWidget(theme)
      : ValueListenableBuilder<Iterable<ItemPosition>>(
          valueListenable: itemPositionsListener.itemPositions,
          builder: (context, positions, child) {
            int min = -1;
            if (positions.isNotEmpty) {
              min = positions
                  .where(
                    (ItemPosition position) => position.itemTrailingEdge > 0,
                  )
                  .reduce(
                    (ItemPosition min, ItemPosition position) =>
                        position.itemTrailingEdge < min.itemTrailingEdge
                        ? position
                        : min,
                  )
                  .index;
            }
            return min >= 2 ? _sortWidget(theme) : const SizedBox.shrink();
          },
        );

  Widget _sortWidget(ThemeData theme) => Container(
    height: 40,
    color: theme.colorScheme.surface,
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
                _controller.mode.value == Mode.MAIN_LIST_HOT ? '按热度' : '按时间',
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
  );

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<ReplyInfo>?> loadingState,
    int index,
  ) {
    return switch (loadingState) {
      Loading() => IgnorePointer(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => const VideoReplySkeleton(),
          itemCount: 8,
        ),
      ),
      Success(:var response) => Builder(
        builder: (context) {
          if (index == response!.length) {
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
          } else {
            final child = _replyItem(response[index], index);
            if (_controller.index != null && _controller.index == index) {
              colorAnimation ??= ColorTween(
                begin: theme.colorScheme.onInverseSurface,
                end: theme.colorScheme.surface,
              ).animate(_controller.controller!);
              return AnimatedBuilder(
                animation: colorAnimation!,
                builder: (context, _) {
                  return ColoredBox(
                    color:
                        colorAnimation!.value ??
                        theme.colorScheme.onInverseSurface,
                    child: child,
                  );
                },
              );
            }
            return child;
          }
        },
      ),
      Error(:var errMsg) => errorWidget(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _replyItem(ReplyInfo replyItem, int index) {
    return ReplyItemGrpc(
      replyItem: replyItem,
      replyLevel: widget.isDialogue ? 3 : 2,
      onReply: (replyItem) =>
          _controller.onReply(context, replyItem: replyItem, index: index),
      onDelete: (item, subIndex) => _controller.onRemove(index, item, null),
      upMid: _controller.upMid,
      showDialogue: () => _key.currentState?.showBottomSheet(
        backgroundColor: Colors.transparent,
        constraints: const BoxConstraints(),
        (context) => VideoReplyReplyPanel(
          oid: replyItem.oid.toInt(),
          rpid: replyItem.root.toInt(),
          dialog: replyItem.dialog.toInt(),
          replyType: widget.replyType,
          isVideoDetail: true,
          isDialogue: true,
        ),
      ),
      onViewImage: widget.onViewImage,
      onDismissed: widget.onDismissed,
      callback: _imageCallback,
      onCheckReply: (item) => _controller.onCheckReply(item, isManual: true),
    );
  }

  int _itemCount(LoadingState<List<ReplyInfo>?> loadingState) {
    if (widget.isDialogue) {
      return (loadingState.dataOrNull?.length ?? 0) + 1;
    }
    int itemCount = 0;
    if (firstFloor != null) {
      itemCount = 2;
    }
    return (loadingState.dataOrNull?.length ?? 0) + itemCount + 2;
  }
}
