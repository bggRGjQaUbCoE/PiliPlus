import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/video/reply/controller.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class VideoReplyPanel extends StatefulWidget {
  const VideoReplyPanel({
    super.key,
    this.replyLevel = 1,
    required this.heroTag,
    this.onViewImage,
    this.onDismissed,
    required this.isNested,
  });

  final int replyLevel;
  final String heroTag;
  final VoidCallback? onViewImage;
  final ValueChanged<int>? onDismissed;
  final bool isNested;

  @override
  State<VideoReplyPanel> createState() => _VideoReplyPanelState();
}

class _VideoReplyPanelState extends State<VideoReplyPanel>
    with AutomaticKeepAliveClientMixin {
  late VideoReplyController _videoReplyController;

  String get heroTag => widget.heroTag;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _videoReplyController = Get.find<VideoReplyController>(tag: heroTag);
    if (_videoReplyController.loadingState.value is Loading) {
      _videoReplyController.queryData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _videoReplyController.showFab();
    if (widget.isNested) {
      _videoReplyController.scrollController.removeListener(listener);
    } else {
      _videoReplyController.scrollController.addListener(listener);
    }
    bottom = MediaQuery.viewPaddingOf(context).bottom;
  }

  @override
  void dispose() {
    if (!widget.isNested) {
      _videoReplyController.scrollController.removeListener(listener);
    }
    super.dispose();
  }

  void listener() {
    final ScrollDirection direction =
        _videoReplyController.scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      if (mounted) {
        _videoReplyController.showFab();
      }
    } else if (direction == ScrollDirection.reverse) {
      if (mounted) {
        _videoReplyController.hideFab();
      }
    }
  }

  late double bottom;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final child = refreshIndicator(
      onRefresh: _videoReplyController.onRefresh,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomScrollView(
            controller: widget.isNested
                ? null
                : _videoReplyController.scrollController,
            physics: widget.isNested
                ? const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  )
                : const AlwaysScrollableScrollPhysics(),
            key: const PageStorageKey<String>('评论'),
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: false,
                floating: true,
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
                          () => Text(
                            _videoReplyController.sortType.value.title,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: TextButton.icon(
                            onPressed: _videoReplyController.queryBySort,
                            icon: Icon(
                              Icons.sort,
                              size: 16,
                              color: theme.colorScheme.secondary,
                            ),
                            label: Obx(
                              () => Text(
                                _videoReplyController.sortType.value.label,
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
              ),
              Obx(
                () => _buildBody(
                  theme,
                  _videoReplyController.loadingState.value,
                ),
              ),
            ],
          ),
          Positioned(
            right: 14,
            bottom: 14 + bottom,
            child: SlideTransition(
              position: _videoReplyController.anim,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  feedBack();
                  _videoReplyController.onReply(
                    context,
                    oid: _videoReplyController.aid,
                    replyType: _videoReplyController.videoType.replyType,
                  );
                },
                tooltip: '发表评论',
                child: const Icon(Icons.reply),
              ),
            ),
          ),
        ],
      ),
    );
    if (widget.isNested) {
      return ExtendedVisibilityDetector(
        uniqueKey: const Key('reply-list'),
        child: child,
      );
    }
    return child;
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<ReplyInfo>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
        itemBuilder: (context, index) => const VideoReplySkeleton(),
        itemCount: 5,
      ),
      Success(:var response) =>
        response != null && response.isNotEmpty
            ? SliverList.builder(
                itemBuilder: (context, index) {
                  if (index == response.length) {
                    _videoReplyController.onLoadMore();
                    return Container(
                      height: 125,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: bottom),
                      child: Text(
                        _videoReplyController.isEnd ? '没有更多了' : '加载中...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    );
                  } else {
                    return ReplyItemGrpc(
                      replyItem: response[index],
                      replyLevel: widget.replyLevel,
                      replyReply: replyReply,
                      onReply: (replyItem) => _videoReplyController.onReply(
                        context,
                        replyItem: replyItem,
                      ),
                      onDelete: (item, subIndex) =>
                          _videoReplyController.onRemove(index, item, subIndex),
                      upMid: _videoReplyController.upMid,
                      getTag: () => heroTag,
                      onViewImage: widget.onViewImage,
                      onDismissed: widget.onDismissed,
                      onCheckReply: (item) => _videoReplyController
                          .onCheckReply(item, isManual: true),
                      onToggleTop: (item) => _videoReplyController.onToggleTop(
                        item,
                        index,
                        _videoReplyController.aid,
                        _videoReplyController.videoType.replyType,
                      ),
                    );
                  }
                },
                itemCount: response.length + 1,
              )
            : HttpError(
                errMsg: '还没有评论',
                onReload: _videoReplyController.onReload,
              ),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _videoReplyController.onReload,
      ),
    };
  }

  // 展示二级回复
  void replyReply(ReplyInfo replyItem, int? id) {
    EasyThrottle.throttle('replyReply', const Duration(milliseconds: 500), () {
      int oid = replyItem.oid.toInt();
      int rpid = replyItem.id.toInt();
      showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        constraints: const BoxConstraints(),
        builder: (context) => VideoReplyReplyPanel(
          id: id,
          oid: oid,
          rpid: rpid,
          firstFloor: replyItem,
          replyType: _videoReplyController.videoType.replyType,
          isVideoDetail: true,
          onViewImage: widget.onViewImage,
          onDismissed: widget.onDismissed,
          isNested: widget.isNested,
        ),
      );
    });
  }
}
