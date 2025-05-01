import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/reply_sort_type.dart';
import 'package:PiliPlus/pages/video/detail/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/models/common/reply_type.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'controller.dart';

class VideoReplyPanel extends StatefulWidget {
  final String? bvid;
  final int oid;
  final int rpid;
  final String replyLevel;
  final String heroTag;
  final Function(ReplyInfo replyItem, int? rpid) replyReply;
  final VoidCallback? onViewImage;
  final ValueChanged<int>? onDismissed;
  final Function(List<String>, int)? callback;
  final bool? needController;

  const VideoReplyPanel({
    super.key,
    this.bvid,
    required this.oid,
    this.rpid = 0,
    this.replyLevel = '1',
    required this.heroTag,
    required this.replyReply,
    this.onViewImage,
    this.onDismissed,
    this.callback,
    this.needController,
  });

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
    if (widget.needController != false) {
      _videoReplyController.scrollController.addListener(listener);
    } else {
      _videoReplyController.scrollController.removeListener(listener);
    }
  }

  @override
  void dispose() {
    if (widget.needController != false) {
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return refreshIndicator(
      onRefresh: () async {
        await _videoReplyController.onRefresh();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomScrollView(
            controller: widget.needController == false
                ? null
                : _videoReplyController.scrollController,
            physics: widget.needController == false
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
                            onPressed: () =>
                                _videoReplyController.queryBySort(),
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() =>
                  _buildBody(theme, _videoReplyController.loadingState.value)),
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 14,
            right: 14,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 2),
                end: const Offset(0, 0),
              ).animate(CurvedAnimation(
                parent: _videoReplyController.fabAnimationCtr,
                curve: Curves.easeInOut,
              )),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  feedBack();
                  _videoReplyController.onReply(
                    context,
                    oid: _videoReplyController.aid,
                    replyType: ReplyType.video,
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
  }

  Widget _buildBody(ThemeData theme, LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemBuilder: (BuildContext context, index) {
            return const VideoReplySkeleton();
          },
          itemCount: 5,
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverList.builder(
              itemBuilder: (context, index) {
                double bottom = MediaQuery.of(context).padding.bottom;
                if (index == loadingState.response.length) {
                  _videoReplyController.onLoadMore();
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: bottom),
                    height: bottom + 100,
                    child: Text(
                      _videoReplyController.isEnd.not
                          ? '加载中...'
                          : loadingState.response.isEmpty
                              ? '还没有评论'
                              : '没有更多了',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  );
                } else {
                  return ReplyItemGrpc(
                    replyItem: loadingState.response[index],
                    replyLevel: widget.replyLevel,
                    replyReply: widget.replyReply,
                    onReply: () {
                      _videoReplyController.onReply(
                        context,
                        replyItem: loadingState.response[index],
                        index: index,
                      );
                    },
                    onDelete: (subIndex) =>
                        _videoReplyController.onRemove(index, subIndex),
                    upMid: _videoReplyController.upMid,
                    getTag: () => heroTag,
                    onViewImage: widget.onViewImage,
                    onDismissed: widget.onDismissed,
                    callback: widget.callback,
                    onCheckReply: (item) =>
                        _videoReplyController.onCheckReply(context, item),
                    onToggleTop: (isUpTop, rpid) =>
                        _videoReplyController.onToggleTop(
                      index,
                      _videoReplyController.aid,
                      ReplyType.video.index,
                      isUpTop,
                      rpid,
                    ),
                  );
                }
              },
              itemCount: loadingState.response.length + 1,
            )
          : HttpError(
              errMsg: '还没有评论',
              onReload: _videoReplyController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _videoReplyController.onReload,
        ),
    };
  }
}
