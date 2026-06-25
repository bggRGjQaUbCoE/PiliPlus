import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_pinned_header.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_controller.dart';
import 'package:PiliPlus/pages/common/fab_mixin.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DynType implements EnumWithLabel {
  reply('评论'),
  reaction('赞与转发');

  @override
  final String label;
  const DynType(this.label);
}

abstract class CommonDynPageState<T extends StatefulWidget> extends State<T>
    with
        SingleTickerProviderStateMixin<T>,
        BaseFabMixin,
        FabMixin,
        CommonDynPageMixin<T> {}

abstract class CommonDynPageMultiState<T extends StatefulWidget>
    extends State<T>
    with
        TickerProviderStateMixin<T>,
        BaseFabMixin,
        FabMixin,
        CommonDynPageMixin<T> {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: DynType.values.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

mixin CommonDynPageMixin<T extends StatefulWidget>
    on State<T>, TickerProvider, BaseFabMixin<T>, FabMixin<T> {
  CommonDynController get controller;

  bool get horizontalPreview => !isPortrait && controller.horizontalPreview;

  dynamic get arguments;

  late ThemeData theme;
  late EdgeInsets padding;
  late bool isPortrait;
  late double maxWidth;
  late double maxHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    theme = Theme.of(context);
    maxWidth = size.width;
    maxHeight = size.height;
    isPortrait = size.isPortrait;
    padding = MediaQuery.viewPaddingOf(context);
  }

  Widget buildReplyHeader() {
    final secondary = theme.colorScheme.secondary;
    return SliverPinnedHeader(
      backgroundColor: theme.colorScheme.surface,
      child: Padding(
        padding: const .fromLTRB(12, 2.5, 6, 2.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  controller.sortType.value.label,
                  style: TextStyle(fontSize: 13, color: secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget replyList(LoadingState<List<ReplyInfo>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
        itemCount: 12,
        itemBuilder: (context, index) => const VideoReplySkeleton(),
      ),
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverList.builder(
                itemCount: response.length + 1,
                itemBuilder: (context, index) {
                  if (index == response.length) {
                    controller.onLoadMore();
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: padding.bottom),
                      height: 125,
                      child: Text(
                        controller.isEnd ? '没有更多了' : '加载中...',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    );
                  } else {
                    return ReplyItemGrpc(
                      replyItem: response[index],
                      replyLevel: 1,
                      replyReply: (replyItem, id) =>
                          replyReply(context, replyItem, id),
                      onReply: controller.onReply,
                      onDelete: (item, subIndex) =>
                          controller.onRemove(index, item, subIndex),
                      upMid: controller.upMid,
                      onViewImage: hideFab,
                      onCheckReply: (item) =>
                          controller.onCheckReply(item, isManual: true),
                      onToggleTop: (item) => controller.onToggleTop(
                        item,
                        index,
                        controller.oid,
                        controller.replyType,
                      ),
                    );
                  }
                },
              )
            : HttpError(
                errMsg: '还没有评论',
                onReload: controller.onReload,
              ),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: controller.onReload,
      ),
    };
  }

  void replyReply(BuildContext context, ReplyInfo replyItem, int? id) {
    EasyThrottle.throttle('replyReply', const Duration(milliseconds: 500), () {
      int oid = replyItem.oid.toInt();
      int rpid = replyItem.id.toInt();
      Widget replyReplyPage({bool showBackBtn = true}) {
        final child = ViewSafeArea(
          left: showBackBtn,
          right: showBackBtn,
          child: VideoReplyReplyPanel(
            enableSlide: false,
            id: id,
            oid: oid,
            rpid: rpid,
            isVideoDetail: !showBackBtn,
            replyType: controller.replyType,
            firstFloor: replyItem,
            upMid: controller.upMid,
          ),
        );
        if (showBackBtn) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('评论详情'),
              shape: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            body: child,
          );
        }
        return child;
      }

      if (isPortrait) {
        Get.to(
          replyReplyPage,
          routeName: 'dynamicDetail-Copy',
          arguments: arguments,
        );
      } else {
        final scaffoldState = Scaffold.maybeOf(context);
        if (scaffoldState != null) {
          hideFab();
          scaffoldState.showBottomSheet(
            backgroundColor: Colors.transparent,
            (context) => replyReplyPage(showBackBtn: false),
          );
        } else {
          Get.to(
            replyReplyPage,
            routeName: 'dynamicDetail-Copy',
            arguments: arguments,
          );
        }
      }
    });
  }

  Widget ratioWidget(double maxWidth) => IconButton(
    tooltip: '页面比例调节',
    onPressed: () => showDialog(
      context: context,
      builder: (context) => Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: const EdgeInsets.only(top: 56, right: 16),
          width: maxWidth / 4,
          height: 32,
          child: Builder(
            builder: (context) => Slider(
              min: 1,
              max: 100,
              value: controller.ratio.first,
              onChanged: (value) {
                if (value >= 10 && value <= 90) {
                  value = value.toPrecision(2);
                  controller.ratio
                    ..[0] = value
                    ..[1] = 100 - value;

                  (context as Element).markNeedsBuild();
                  setState(() {});
                }
              },
              onChangeEnd: (_) => GStorage.setting.put(
                SettingBoxKey.dynamicDetailRatio,
                controller.ratio,
              ),
            ),
          ),
        ),
      ),
    ),
    icon: const Icon(CustomIcons.splitscreen_rotate_90, size: 19),
  );

  FloatingActionButtonLocation get floatingActionButtonLocation =>
      controller.showDynActionBar
      ? const ActionBarLocation()
      : const NoBottomPaddingFabLocation();

  Widget get fabButton => Padding(
    padding: .only(bottom: padding.bottom + kFloatingActionButtonMargin),
    child: replyButton,
  );

  Widget get replyButton => FloatingActionButton(
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
  );

  Widget fabAnimWrapper(Widget child) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axisDirection == .down) {
          switch (notification.direction) {
            case .forward:
              showFab();
            case .reverse:
              hideFab();
            default:
          }
        }
        return false;
      },
      child: child,
    );
  }
}
