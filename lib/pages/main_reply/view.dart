import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/sliver_single_child_delegate.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_floating_header.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, MainListReply;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/fab_mixin.dart';
import 'package:PiliPlus/pages/common/reply/reply_footer_mixin.dart';
import 'package:PiliPlus/pages/main_reply/controller.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/extension/widget_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

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
    with
        SingleTickerProviderStateMixin,
        BaseFabMixin,
        FabMixin,
        ReplyFooterMixin<MainReplyPage, MainListReply> {
  @override
  final MainReplyController controller = Get.put(
    MainReplyController(),
    tag: Utils.generateRandomString(8),
  );

  @override
  late ColorScheme colorScheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(title: const Text('查看评论')),
      body: fabAnimWrapper(
        child: refreshIndicator(
          onRefresh: controller.onRefresh,
          child: Padding(
            padding: EdgeInsets.only(
              left: padding.left,
              right: padding.right,
            ),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                buildReplyHeader(),
                Obx(() => _buildBody(controller.loadingState.value)),
              ],
            ),
          ),
        ).constraintWidth(),
      ),
      fab: SlideTransition(
        position: fabAnimation,
        child: Padding(
          padding: .only(
            right: kFloatingActionButtonMargin + padding.right,
            bottom: kFloatingActionButtonMargin + padding.bottom,
          ),
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () {
              try {
                feedBack();
                controller.onReply(
                  null,
                  oid: controller.oid,
                  replyType: controller.replyType,
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

  Widget _buildBody(LoadingState<List<ReplyInfo>?> loadingState) {
    return switch (loadingState) {
      Loading() => const SliverPrototypeExtentList(
        prototypeItem: VideoReplySkeleton(),
        delegate: SliverSingleChildDelegate(
          count: 10,
          child: VideoReplySkeleton(),
        ),
      ),
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverList.builder(
                itemCount: response.length + 1,
                itemBuilder: (context, index) {
                  if (index == response.length) {
                    return buildFooter();
                  }

                  return ReplyItemGrpc(
                    replyItem: response[index],
                    replyLevel: 1,
                    replyReply: throttleReplyReply,
                    onReply: controller.onReply,
                    onDelete: (item, subIndex) =>
                        controller.onRemove(index, item, subIndex),
                    upMid: controller.upMid,
                    onCheckReply: controller.onCheckReply,
                    onToggleTop: (item) => controller.onToggleTop(
                      item,
                      index,
                      controller.oid,
                      controller.replyType,
                    ),
                  );
                },
              )
            : emptyWidget(),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: controller.onReload,
      ),
    };
  }

  Widget buildReplyHeader() {
    final secondary = colorScheme.secondary;
    return SliverFloatingHeaderWidget(
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const .fromLTRB(12, 2.5, 6, 2.5),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Obx(
              () {
                final count = controller.count.value;
                return Text(
                  '${count == -1 ? 0 : NumUtils.numFormat(count)}条回复',
                );
              },
            ),
            TextButton.icon(
              style: Style.buttonStyle,
              onPressed: controller.queryBySort,
              icon: Icon(Icons.sort, size: 16, color: secondary),
              label: Obx(
                () => Text(
                  controller.sortType.value.descShort,
                  style: TextStyle(fontSize: 13, color: secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void throttleReplyReply(ReplyInfo replyItem, int? id) {
    EasyThrottle.throttle(
      'replyReply',
      const Duration(milliseconds: 500),
      () => replyReply(replyItem, id),
    );
  }

  void replyReply(ReplyInfo replyItem, int? id) {
    Get.to(
      SimpleScaffold(
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
            oid: replyItem.oid.toInt(),
            rpid: replyItem.id.toInt(),
            isVideoDetail: false,
            replyType: controller.replyType,
            firstFloor: replyItem,
            upMid: controller.upMid,
          ),
        ).constraintWidth(),
      ),
      routeName: 'dynamicDetail-Copy',
    );
  }
}
