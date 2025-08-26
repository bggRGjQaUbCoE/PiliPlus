import 'dart:math' show pi;

import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_controller.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/num_util.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;

abstract class CommonDynPageState<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin {
  CommonDynController get controller;

  late final scaffoldKey = GlobalKey<ScaffoldState>();

  bool get horizontalPreview =>
      context.isLandscape && controller.horizontalPreview;
  Function(List<String> imgList, int index)? imageCallback;

  dynamic get arguments;

  late EdgeInsets padding;
  late bool isPortrait;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    imageCallback = horizontalPreview
        ? (imgList, index) {
            controller.hideFab();
            PageUtils.onHorizontalPreview(
              scaffoldKey,
              this,
              imgList,
              index,
            );
          }
        : null;
    padding = MediaQuery.viewPaddingOf(context);
  }

  Widget buildReplyHeader(ThemeData theme) {
    final secondary = theme.colorScheme.secondary;
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverPersistentHeaderDelegate(
        extent: 45,
        bgColor: theme.colorScheme.surface,
        child: Container(
          height: 45,
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () {
                  final count = controller.count.value;
                  return Text(
                    '${count == -1 ? 0 : NumUtil.numFormat(count)}条回复',
                  );
                },
              ),
              SizedBox(
                height: 35,
                child: TextButton.icon(
                  onPressed: controller.queryBySort,
                  icon: Icon(
                    Icons.sort,
                    size: 16,
                    color: secondary,
                  ),
                  label: Obx(
                    () => Text(
                      controller.sortType.value.label,
                      style: TextStyle(fontSize: 13, color: secondary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget replyList(
    ThemeData theme,
    LoadingState<List<ReplyInfo>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
        itemCount: 12,
        itemBuilder: (context, index) => const VideoReplySkeleton(),
      ),
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverList.builder(
                itemCount: response!.length + 1,
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
                          replyReply(context, replyItem, id, theme),
                      onReply: (replyItem) => controller.onReply(
                        context,
                        replyItem: replyItem,
                      ),
                      onDelete: (item, subIndex) =>
                          controller.onRemove(index, item, subIndex),
                      upMid: controller.upMid,
                      callback: imageCallback,
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
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: controller.onReload,
      ),
    };
  }

  void replyReply(
    BuildContext context,
    ReplyInfo replyItem,
    int? id,
    ThemeData theme,
  ) {
    EasyThrottle.throttle('replyReply', const Duration(milliseconds: 500), () {
      int oid = replyItem.oid.toInt();
      int rpid = replyItem.id.toInt();
      Widget replyReplyPage({bool showBackBtn = true}) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          primary: showBackBtn,
          toolbarHeight: showBackBtn ? null : 45,
          title: const Text('评论详情'),
          titleSpacing: showBackBtn ? null : 12,
          automaticallyImplyLeading: showBackBtn,
          actions: showBackBtn
              ? null
              : [
                  IconButton(
                    tooltip: '关闭',
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: Get.back,
                  ),
                ],
          shape: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
        ),
        body: VideoReplyReplyPanel(
          enableSlide: false,
          id: id,
          oid: oid,
          rpid: rpid,
          isVideoDetail: false,
          replyType: controller.replyType,
          firstFloor: replyItem,
        ),
      );
      if (isPortrait) {
        Get.to(
          replyReplyPage,
          routeName: 'dynamicDetail-Copy',
          arguments: arguments,
        );
      } else {
        ScaffoldState? scaffoldState = Scaffold.maybeOf(context);
        if (scaffoldState != null) {
          controller.hideFab();
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
          margin: const EdgeInsets.only(
            top: 56,
            right: 16,
          ),
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
                  GStorage.setting.put(
                    SettingBoxKey.dynamicDetailRatio,
                    controller.ratio,
                  );
                  (context as Element).markNeedsBuild();
                  setState(() {});
                }
              },
            ),
          ),
        ),
      ),
    ),
    icon: Transform.rotate(
      angle: pi / 2,
      child: const Icon(Icons.splitscreen, size: 19),
    ),
  );

  Widget get replyButton => FloatingActionButton(
    heroTag: null,
    onPressed: () {
      feedBack();
      controller.onReply(
        context,
        oid: controller.oid,
        replyType: controller.replyType,
      );
    },
    tooltip: '评论',
    child: const Icon(Icons.reply),
  );
}
