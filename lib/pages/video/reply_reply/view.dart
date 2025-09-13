import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/sliver_pinned_top_header.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, Mode;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/controller.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;

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
  final _listKey = UniqueKey();
  late final _tag = Utils.makeHeroTag(
    '${widget.rpid}${widget.dialog}${widget.isDialogue}',
  );

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

  ReplyInfo? get firstFloor =>
      widget.firstFloor ?? _controller.firstFloor.value;

  @override
  Widget buildList(ThemeData theme) {
    return refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: Obx(() {
        final state = _controller.loadingState.value;
        final noIndex = _controller.index == null || widget.isDialogue;

        final List<Widget> slivers;
        switch (state) {
          case Loading():
            slivers = [
              SliverPrototypeExtentList.builder(
                prototypeItem: const VideoReplySkeleton(),
                itemBuilder: (_, _) => const VideoReplySkeleton(),
                itemCount: 8,
              ),
            ];
            break;
          case Success<List<ReplyInfo>?>(:var response!):
            final jumpIndex = _controller.index;
            slivers = [
              if (jumpIndex != null)
                SliverList.builder(
                  itemCount: jumpIndex,
                  itemBuilder: (context, index) => _buildBody(
                    context,
                    theme,
                    response,
                    index,
                  ),
                ),
              SliverList.builder(
                key: _listKey,
                itemCount: response.length - (jumpIndex ?? 0) + 1,
                itemBuilder: (context, index) => _buildBody(
                  context,
                  theme,
                  response,
                  index + (jumpIndex ?? 0),
                ),
              ),
            ];
            break;
          case Error(:var errMsg):
            slivers = [
              HttpError(
                isSliver: true,
                errMsg: errMsg,
                onReload: _controller.onReload,
              ),
            ];
            break;
        }
        return CustomScrollView(
          key: ValueKey(context.orientation), // force reset
          physics: state is Loading
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
          // key: PageStorageKey(_tag),
          center: noIndex ? null : _listKey,
          anchor: noIndex ? 0 : 0.25,
          slivers: [..._buildFirstFloor(theme), ...slivers],
        );
      }),
    );
  }

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

  List<Widget> _buildFirstFloor(ThemeData theme) {
    return [
      if (!widget.isDialogue && firstFloor != null) ...[
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
      SliverPinnedTopPersistentHeader(child: _sortWidget(theme)),
    ];
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    List<ReplyInfo> data,
    int index,
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
    } else {
      final child = _replyItem(data[index], index);
      if (_controller.index != null && _controller.index == index) {
        return AnimatedBuilder(
          animation: colorAnimation ??= ColorTween(
            begin: theme.colorScheme.onInverseSurface,
            end: theme.colorScheme.surface,
          ).animate(_controller.controller!),
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
      onCheckReply: (item) => _controller.onCheckReply(item, isManual: true),
    );
  }
}
