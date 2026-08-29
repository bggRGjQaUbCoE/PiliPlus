import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/mini_scaffold.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
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
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

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
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _query = '';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  late double bottom;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return fabAnimWrapper(
      child: refreshIndicator(
        onRefresh: _videoReplyController.onRefresh,
        isClampingScrollPhysics: widget.isNested,
        child: ScaffoldLayout(
          body: CustomScrollView(
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
                  child: _buildReplyHeader(),
                ),
              ),
              Obx(() => _buildBody(_videoReplyController.loadingState.value)),
            ],
          ),
          fab: SlideTransition(
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
      ),
    );
  }

  Widget _buildReplyHeader() {
    if (_isSearching) {
      return Row(
        children: [
          const Icon(Icons.search, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              autofocus: true,
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: '搜索已加载评论',
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          IconButton(
            tooltip: '关闭搜索',
            onPressed: () => setState(() {
              _isSearching = false;
              _query = '';
              _searchController.clear();
            }),
            icon: const Icon(Icons.close, size: 20),
          ),
        ],
      );
    }

    return Obx(() {
      final sortType = _videoReplyController.sortType.value;
      return Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(sortType.desc, style: const TextStyle(fontSize: 13)),
          Row(
            mainAxisSize: .min,
            children: [
              IconButton(
                tooltip: '搜索评论',
                onPressed: () => setState(() => _isSearching = true),
                icon: Icon(
                  Icons.search_outlined,
                  size: 20,
                  color: colorScheme.secondary,
                ),
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
                  sortType.descShort,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  bool _matchesQuery(ReplyInfo reply) {
    final query = _query.toLowerCase();
    bool matches(ReplyInfo item) =>
        item.content.message.toLowerCase().contains(query) ||
        item.member.name.toLowerCase().contains(query) ||
        item.replyControl.location.toLowerCase().contains(query);
    return matches(reply) || reply.replies.any(matches);
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
          final visibleResponse = _query.isEmpty
              ? response
              : response.where(_matchesQuery).toList();
          if (visibleResponse.isEmpty) {
            return HttpError(
              errMsg: '没有找到匹配评论',
              onReload: _videoReplyController.isEnd
                  ? null
                  : _videoReplyController.onLoadMore,
              btnText: '加载更多评论',
            );
          }

          var count = visibleResponse.length + 1;
          final voteCard = _videoReplyController.voteCard;
          final hasVote = voteCard != null;
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
              if (index == visibleResponse.length) {
                if (_query.isEmpty) {
                  _videoReplyController.onLoadMore();
                }
                return Container(
                  height: 125,
                  alignment: .center,
                  margin: .only(bottom: bottom),
                  child: _query.isNotEmpty && !_videoReplyController.isEnd
                      ? TextButton.icon(
                          onPressed: _videoReplyController.onLoadMore,
                          icon: const Icon(Icons.expand_more),
                          label: const Text('加载更多评论'),
                        )
                      : Text(
                          _videoReplyController.isEnd ? '没有更多了' : '加载中...',
                          textAlign: .center,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.outline,
                          ),
                        ),
                );
              } else {
                final item = visibleResponse[index];
                final responseIndex = response.indexOf(item);
                return ReplyItemGrpc(
                  replyItem: item,
                  replyLevel: widget.replyLevel,
                  replyReply: replyReply,
                  onReply: _videoReplyController.onReply,
                  onDelete: (item, subIndex) => _videoReplyController.onRemove(
                    responseIndex,
                    item,
                    subIndex,
                  ),
                  upMid: _videoReplyController.upMid,
                  getTag: () => heroTag,
                  onCheckReply: (item) =>
                      _videoReplyController.onCheckReply(item, isManual: true),
                  onToggleTop: (item) => _videoReplyController.onToggleTop(
                    item,
                    responseIndex,
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
      MiniScaffold.of(context).showBottomSheet(
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
