import 'dart:math' show pi;

import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_controller.dart';
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

abstract class CommonDynPageState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  CommonDynController get controller;

  late final ScrollController scrollController;

  bool get horizontalPreview => !isPortrait && controller.horizontalPreview;

  dynamic get arguments;

  late EdgeInsets padding;
  late bool isPortrait;
  late double maxWidth;
  late double maxHeight;

  bool _showFab = true;

  final fabOffset = const Offset(0, 1);

  late final AnimationController _fabAnimationCtr;
  late final CurvedAnimation _curvedAnimation;
  late final Animation<Offset> fabAnim;

  @override
  void initState() {
    super.initState();
    _fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..forward();
    _curvedAnimation = CurvedAnimation(
      parent: _fabAnimationCtr,
      curve: Curves.easeInOut,
    );
    fabAnim = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    ).animate(_curvedAnimation);
    scrollController = ScrollController()..addListener(listener);
  }

  void listener() {
    final pos = scrollController.positions;
    controller.showTitle.value = pos.first.pixels > 55;
    if (pos.any((e) => e.userScrollDirection == .forward)) {
      showFab();
    } else if (pos.any((e) => e.userScrollDirection == .reverse)) {
      hideFab();
    }
  }

  void showFab() {
    if (!_showFab) {
      _showFab = true;
      _fabAnimationCtr.forward();
    }
  }

  void hideFab() {
    if (_showFab) {
      _showFab = false;
      _fabAnimationCtr.reverse();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    maxWidth = size.width;
    maxHeight = size.height;
    isPortrait = size.isPortrait;
    padding = MediaQuery.viewPaddingOf(context);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(listener)
      ..dispose();
    _curvedAnimation.dispose();
    _fabAnimationCtr.dispose();
    super.dispose();
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
                    '${count == -1 ? 0 : NumUtils.numFormat(count)}条回复',
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
                          replyReply(context, replyItem, id, theme),
                      onReply: (replyItem) => controller.onReply(
                        context,
                        replyItem: replyItem,
                      ),
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

  void replyReply(
    BuildContext context,
    ReplyInfo replyItem,
    int? id,
    ThemeData theme,
  ) {
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
    icon: Transform.rotate(
      angle: pi / 2,
      child: const Icon(Icons.splitscreen, size: 19),
    ),
  );

  Widget get replyButton => FloatingActionButton(
    heroTag: null,
    onPressed: () {
      try {
        feedBack();
        controller.onReply(
          context,
          oid: controller.oid,
          replyType: controller.replyType,
        );
      } catch (_) {}
    },
    tooltip: '评论',
    child: const Icon(Icons.reply),
  );
}
