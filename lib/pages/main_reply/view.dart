import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_floating_header.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/fab_mixin.dart';
import 'package:PiliPlus/pages/main_reply/controller.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/extension/widget_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainReplyPage extends StatefulWidget {
  const MainReplyPage({super.key});

  @override
  State<MainReplyPage> createState() => _MainReplyPageState();

  static void toMainReplyPage({
    required int oid,
    required int replyType,
  }) {
    Get.toNamed(
      '/mainReply',
      arguments: {
        'oid': oid,
        'replyType': replyType,
      },
    );
  }
}

class _MainReplyPageState extends State<MainReplyPage>
    with SingleTickerProviderStateMixin, FabMixin {
  final _controller = Get.put(
    MainReplyController(),
    tag: Utils.generateRandomString(8),
  );

  late EdgeInsets padding;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    padding = MediaQuery.viewPaddingOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('查看评论')),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final direction = notification.direction;
          if (direction == .forward) {
            showFab();
          } else if (direction == .reverse) {
            hideFab();
          }
          return false;
        },
        child: refreshIndicator(
          onRefresh: _controller.onRefresh,
          child: Padding(
            padding: EdgeInsets.only(
              left: padding.left,
              right: padding.right,
            ),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                buildReplyHeader(colorScheme),
                Obx(
                  () => _buildBody(colorScheme, _controller.loadingState.value),
                ),
              ],
            ),
          ),
        ).constraintWidth(),
      ),
      floatingActionButtonLocation: const NoBottomPaddingFabLocation(),
      floatingActionButton: SlideTransition(
        position: fabAnimation,
        child: Padding(
          padding: .only(bottom: padding.bottom + kFloatingActionButtonMargin),
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () {
              try {
                feedBack();
                _controller.onReply(
                  null,
                  oid: _controller.oid,
                  replyType: _controller.replyType,
                );
              } catch (_) {}
            },
            tooltip: '评论',
            child: const Icon(Icons.reply),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    ColorScheme colorScheme,
    LoadingState<List<ReplyInfo>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => SliverPrototypeExtentList.builder(
        itemCount: 10,
        itemBuilder: (_, _) => const VideoReplySkeleton(),
        prototypeItem: const VideoReplySkeleton(),
      ),
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverList.builder(
                itemCount: response.length + 1,
                itemBuilder: (context, index) {
                  if (index == response.length) {
                    _controller.onLoadMore();
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: padding.bottom),
                      height: 125,
                      child: Text(
                        _controller.isEnd ? '没有更多了' : '加载中...',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.outline,
                        ),
                      ),
                    );
                  } else {
                    return ReplyItemGrpc(
                      replyItem: response[index],
                      replyLevel: 1,
                      replyReply: (replyItem, id) =>
                          replyReply(context, replyItem, id, colorScheme),
                      onReply: _controller.onReply,
                      onDelete: (item, subIndex) =>
                          _controller.onRemove(index, item, subIndex),
                      upMid: _controller.upMid,
                      onCheckReply: (item) =>
                          _controller.onCheckReply(item, isManual: true),
                      onToggleTop: (item) => _controller.onToggleTop(
                        item,
                        index,
                        _controller.oid,
                        _controller.replyType,
                      ),
                    );
                  }
                },
              )
            : HttpError(
                errMsg: '还没有评论',
                onReload: _controller.onReload,
              ),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget buildReplyHeader(ColorScheme colorScheme) {
    final secondary = colorScheme.secondary;
    return SliverFloatingHeaderWidget(
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const .fromLTRB(12, 2.5, 6, 2.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () {
                final count = _controller.count.value;
                return Text(
                  '${count == -1 ? 0 : NumUtils.numFormat(count)}条回复',
                );
              },
            ),
            TextButton.icon(
              style: Style.buttonStyle,
              onPressed: _controller.queryBySort,
              icon: Icon(Icons.sort, size: 16, color: secondary),
              label: Obx(
                () => Text(
                  _controller.sortType.value.label,
                  style: TextStyle(fontSize: 13, color: secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void replyReply(
    BuildContext context,
    ReplyInfo replyItem,
    int? id,
    ColorScheme colorScheme,
  ) {
    EasyThrottle.throttle('replyReply', const Duration(milliseconds: 500), () {
      int oid = replyItem.oid.toInt();
      int rpid = replyItem.id.toInt();
      Get.to(
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('评论详情'),
            shape: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
          body: ViewSafeArea(
            child: VideoReplyReplyPanel(
              enableSlide: false,
              id: id,
              oid: oid,
              rpid: rpid,
              isVideoDetail: false,
              replyType: _controller.replyType,
              firstFloor: replyItem,
              upMid: _controller.upMid,
            ),
          ).constraintWidth(),
        ),
        routeName: 'dynamicDetail-Copy',
      );
    });
  }
}
