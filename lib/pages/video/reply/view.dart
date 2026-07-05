import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_floating_header.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/fab_mixin.dart';
import 'package:PiliPlus/pages/video/reply/controller.dart';
import 'package:PiliPlus/pages/video/reply/vote/reply_vote_item.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoReplyPanel extends StatefulWidget {
  const VideoReplyPanel({
    super.key,
    this.replyLevel = 1,
    required this.heroTag,
    required this.isNested,
  });

  final int replyLevel;
  final String heroTag;
  final bool isNested;

  @override
  State<VideoReplyPanel> createState() => _VideoReplyPanelState();
}

class _VideoReplyPanelState extends State<VideoReplyPanel>
    with
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        BaseFabMixin,
        FabMixin {
  late ColorScheme colorScheme;
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
    colorScheme = ColorScheme.of(context);
    bottom = MediaQuery.viewPaddingOf(context).bottom;
  }

  late double bottom;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final child = NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        switch (notification.direction) {
          case .forward:
            showFab();
          case .reverse:
            hideFab();
          case _:
        }
        return false;
      },
      child: refreshIndicator(
        onRefresh: _videoReplyController.onRefresh,
        isClampingScrollPhysics: widget.isNested,
        child: Stack(
          clipBehavior: .none,
          children: [
            CustomScrollView(
              controller: widget.isNested
                  ? null
                  : _videoReplyController.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              key: const PageStorageKey(_VideoReplyPanelState),
              slivers: [
                SliverFloatingHeaderWidget(
                  backgroundColor: colorScheme.surface,
                  child: Padding(
                    padding: const .fromLTRB(12, 2.5, 6, 2.5),
                    child: Obx(() {
                      final sortType = _videoReplyController.sortType.value;
                      return Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            sortType.title,
                            style: const TextStyle(fontSize: 13),
                          ),
                          TextButton.icon(
                            style: Style.buttonStyle,
                            onPressed: _videoReplyController.queryBySort,
                            icon: Icon(
                              Icons.sort,
                              size: 16,
                              color: colorScheme.secondary,
                            ),
                            label: Text(
                              sortType.label,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                Obx(() => _buildBody(_videoReplyController.loadingState.value)),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: fabAnimation,
                child: Padding(
                  padding: .only(
                    right: kFloatingActionButtonMargin,
                    bottom: kFloatingActionButtonMargin + bottom,
                  ),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      feedBack();
                      _videoReplyController.onReply(
                        null,
                        oid: _videoReplyController.aid,
                        replyType: _videoReplyController.videoType.replyType,
                      );
                    },
                    tooltip: '发表评论',
                    child: const Icon(Icons.reply),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (widget.isNested) {
      return ExtendedVisibilityDetector(
        uniqueKey: const ValueKey(VideoReplyPanel),
        child: child,
      );
    }
    return child;
  }

  Widget _buildBody(LoadingState<List<ReplyInfo>?> loadingState) {
    switch (loadingState) {
      case Loading():
        return SliverList.builder(
          itemBuilder: (context, index) => const VideoReplySkeleton(),
          itemCount: 5,
        );
      case Success(:final response):
        if (response != null && response.isNotEmpty) {
          var count = response.length + 1;
          final voteCard = _videoReplyController.voteCard;
          final hasVote = voteCard != null;
          final allPicArr = _videoReplyController.allImageModels;
          if (hasVote) {
            count++;
          }
          return SliverList.builder(
            itemBuilder: (context, index) {
              if (hasVote) {
                if (index == 0) {
                  return buildVoteCard(context, colorScheme, voteCard);
                } else {
                  index--;
                }
              }
              if (index == response.length) {
                _videoReplyController.onLoadMore();
                return Container(
                  height: 125,
                  alignment: .center,
                  margin: .only(bottom: bottom),
                  child: Text(
                    _videoReplyController.isEnd ? '没有更多了' : '加载中...',
                    textAlign: .center,
                    style: TextStyle(fontSize: 12, color: colorScheme.outline),
                  ),
                );
              } else {
                return ReplyItemGrpc(
                  replyItem: response[index],
                  replyLevel: widget.replyLevel,
                  replyReply: replyReply,
                  onReply: _videoReplyController.onReply,
                  onDelete: (item, subIndex) =>
                      _videoReplyController.onRemove(index, item, subIndex),
                  upMid: _videoReplyController.upMid,
                  getTag: () => heroTag,
                  onCheckReply: (item) => _videoReplyController
                      .onCheckReply(item, isManual: true),
                  allPicArr: allPicArr,
                  onToggleTop: (item) => _videoReplyController.onToggleTop(
                    item,
                    index,
                    _videoReplyController.aid,
                    _videoReplyController.videoType.replyType,
                  ),
                );
              }
            },
            itemCount: count,
          );
        }

        final child = HttpError(
          errMsg: '还没有评论',
          onReload: _videoReplyController.onReload,
        );
        if (_videoReplyController.voteCard case final voteCard?) {
          return SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: buildVoteCard(context, colorScheme, voteCard),
              ),
              child,
            ],
          );
        }
        return child;
      case Error(:final errMsg):
        return HttpError(
          errMsg: errMsg,
          onReload: _videoReplyController.onReload,
        );
    }
  }

  // 展示二级回复
  void replyReply(ReplyInfo replyItem, int? id) {
    EasyThrottle.throttle('replyReply', const Duration(milliseconds: 500), () {
      int oid = replyItem.oid.toInt();
      int rpid = replyItem.id.toInt();
      Scaffold.of(context).showBottomSheet(
        backgroundColor: Colors.transparent,
        constraints: const BoxConstraints(),
        (context) => VideoReplyReplyPanel(
          id: id,
          oid: oid,
          rpid: rpid,
          firstFloor: replyItem.replyControl.isNote ? null : replyItem,
          replyType: _videoReplyController.videoType.replyType,
          isVideoDetail: true,
          isNested: widget.isNested,
          upMid: _videoReplyController.upMid,
        ),
      );
    });
  }
}
