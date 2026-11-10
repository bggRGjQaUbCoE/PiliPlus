import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/sliver_single_child_delegate.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_floating_header.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, MainListReply;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/fab_mixin.dart';
import 'package:PiliPlus/pages/common/reply/reply_footer_mixin.dart';
import 'package:PiliPlus/pages/common/reply/vote/reply_vote_item.dart';
import 'package:PiliPlus/pages/video/reply/controller.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/utils/feed_back.dart';
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
        FabMixin,
        ReplyFooterMixin<VideoReplyPanel, MainListReply> {
  @override
  late ColorScheme colorScheme;
  @override
  late VideoReplyController controller;

  String get heroTag => widget.heroTag;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VideoReplyController>(tag: heroTag);
    if (controller.loadingState.value is Loading) {
      controller.queryData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.didChangeDependencies(context);
    colorScheme = ColorScheme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return fabAnimWrapper(
      child: refreshIndicator(
        onRefresh: controller.onRefresh,
        isClampingScrollPhysics: widget.isNested,
        child: ScaffoldLayout(
          body: CustomScrollView(
            controller: widget.isNested ? null : controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            key: const PageStorageKey(_VideoReplyPanelState),
            slivers: [
              SliverFloatingHeaderWidget(
                backgroundColor: colorScheme.surface,
                child: Padding(
                  padding: const .fromLTRB(12, 2.5, 6, 2.5),
                  child: Obx(() {
                    final sortType = controller.sortType.value;
                    return Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          sortType.desc,
                          style: const TextStyle(fontSize: 13),
                        ),
                        TextButton.icon(
                          style: Style.buttonStyle,
                          onPressed: controller.queryBySort,
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
                    );
                  }),
                ),
              ),
              Obx(() => _buildBody(controller.loadingState.value)),
            ],
          ),
          fab: SlideTransition(
            position: fabAnimation,
            child: Padding(
              padding: .only(
                right: kFloatingActionButtonMargin,
                bottom: kFloatingActionButtonMargin + padding.bottom,
              ),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  feedBack();
                  controller.onReply(
                    null,
                    oid: controller.videoCtr.aid,
                    replyType: controller.replyType,
                    mentionItem: controller.mentionItem,
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

  Widget _buildBody(LoadingState<List<ReplyInfo>?> loadingState) {
    switch (loadingState) {
      case Loading():
        return const SliverPrototypeExtentList(
          prototypeItem: VideoReplySkeleton(),
          delegate: SliverSingleChildDelegate(
            count: 5,
            child: VideoReplySkeleton(),
          ),
        );
      case Success(:final response):
        if (response != null && response.isNotEmpty) {
          var count = response.length + 1;
          final voteCard = controller.voteCard;
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
              if (index == response.length) {
                return buildFooter();
              } else {
                final item = response[index];
                final child = ReplyItemGrpc(
                  replyItem: item,
                  replyLevel: widget.replyLevel,
                  replyReply: controller.replyReply,
                  onReply: controller.onReply,
                  onDelete: (item, subIndex) =>
                      controller.onRemove(index, item, subIndex),
                  upMid: controller.upMid,
                  getTag: () => heroTag,
                  onCheckReply: controller.onCheckReply,
                  onToggleTop: (item) => controller.onToggleTop(
                    item,
                    index,
                    controller.videoCtr.aid,
                    controller.replyType,
                  ),
                );
                if (item.id == controller.targetRootRpId) {
                  return controller.colorAnimWrapper(
                    colorScheme,
                    child,
                  );
                }
                return child;
              }
            },
            itemCount: count,
          );
        }

        final child = emptyWidget();
        if (controller.voteCard case final voteCard?) {
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
          onReload: controller.onReload,
        );
    }
  }
}
