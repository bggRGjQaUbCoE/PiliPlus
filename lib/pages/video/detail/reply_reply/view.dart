import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_slide_page.dart';
import 'package:PiliPlus/pages/video/detail/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/detail/reply_new/reply_page.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/models/common/reply_type.dart';
import 'package:get/get_navigation/src/dialog/dialog_route.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'controller.dart';

class VideoReplyReplyPanel extends CommonSlidePage {
  const VideoReplyReplyPanel({
    super.key,
    this.id,
    required this.oid,
    required this.rpid,
    this.dialog,
    this.firstFloor,
    this.source,
    required this.replyType,
    this.isDialogue = false,
    this.onViewImage,
    this.onDismissed,
    this.onDispose,
  });
  final int? id;
  final int oid;
  final int rpid;
  final int? dialog;
  final dynamic firstFloor;
  final String? source;
  final ReplyType replyType;
  final bool isDialogue;
  final VoidCallback? onViewImage;
  final ValueChanged<int>? onDismissed;
  final VoidCallback? onDispose;

  @override
  State<VideoReplyReplyPanel> createState() => _VideoReplyReplyPanelState();
}

class _VideoReplyReplyPanelState
    extends CommonSlidePageState<VideoReplyReplyPanel>
    with TickerProviderStateMixin {
  late VideoReplyReplyController _videoReplyReplyController;
  late final _savedReplies = {};
  late final itemPositionsListener = ItemPositionsListener.create();
  late final _key = GlobalKey<ScaffoldState>();
  late final _listKey = GlobalKey();
  late final _tag =
      Utils.makeHeroTag('${widget.rpid}${widget.dialog}${widget.isDialogue}');

  dynamic get firstFloor =>
      widget.firstFloor ?? _videoReplyReplyController.firstFloor;

  bool get _horizontalPreview =>
      context.orientation == Orientation.landscape &&
      _videoReplyReplyController.horizontalPreview;

  Animation<Color?>? colorAnimation;

  @override
  void initState() {
    super.initState();
    _videoReplyReplyController = Get.put(
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
    widget.onDispose?.call();
    Get.delete<VideoReplyReplyController>(tag: _tag);
    super.dispose();
  }

  Widget _header(ThemeData theme) => firstFloor == null
      ? _sortWidget(theme)
      : ValueListenableBuilder<Iterable<ItemPosition>>(
          valueListenable: itemPositionsListener.itemPositions,
          builder: (context, positions, child) {
            int min = -1;
            if (positions.isNotEmpty) {
              min = positions
                  .where(
                      (ItemPosition position) => position.itemTrailingEdge > 0)
                  .reduce((ItemPosition min, ItemPosition position) =>
                      position.itemTrailingEdge < min.itemTrailingEdge
                          ? position
                          : min)
                  .index;
            }
            return min >= 2 ? _sortWidget(theme) : const SizedBox.shrink();
          },
        );

  @override
  Widget buildPage(ThemeData theme) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          widget.source == 'videoDetail'
              ? Container(
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: theme.dividerColor.withOpacity(0.1),
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
                )
              : Divider(
                  height: 1,
                  color: theme.dividerColor.withOpacity(0.1),
                ),
          Expanded(
            child: enableSlide ? slideList(theme) : buildList(theme),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildList(ThemeData theme) {
    return ClipRect(
      child: refreshIndicator(
        onRefresh: () async {
          await _videoReplyReplyController.onRefresh();
        },
        child: Obx(
          () => Stack(
            clipBehavior: Clip.none,
            children: [
              ScrollablePositionedList.builder(
                key: _listKey,
                itemPositionsListener: itemPositionsListener,
                itemCount:
                    _itemCount(_videoReplyReplyController.loadingState.value),
                itemScrollController: _videoReplyReplyController.itemScrollCtr,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (widget.isDialogue) {
                    return _buildBody(theme,
                        _videoReplyReplyController.loadingState.value, index);
                  } else if (firstFloor != null) {
                    if (index == 0) {
                      return ReplyItemGrpc(
                        replyItem: firstFloor,
                        replyLevel: '2',
                        needDivider: false,
                        onReply: () {
                          _onReply(firstFloor, -1);
                        },
                        upMid: _videoReplyReplyController.upMid,
                        onViewImage: widget.onViewImage,
                        onDismissed: widget.onDismissed,
                        callback: _getImageCallback,
                        onCheckReply: (item) => _videoReplyReplyController
                            .onCheckReply(context, item),
                        onToggleTop: (isUpTop, rpid) =>
                            _videoReplyReplyController.onToggleTop(
                          index,
                          _videoReplyReplyController.oid,
                          _videoReplyReplyController.replyType.index,
                          isUpTop,
                          rpid,
                        ),
                      );
                    } else if (index == 1) {
                      return Divider(
                        height: 20,
                        color: theme.dividerColor.withOpacity(0.1),
                        thickness: 6,
                      );
                    } else if (index == 2) {
                      return _sortWidget(theme);
                    } else {
                      return _buildBody(
                        theme,
                        _videoReplyReplyController.loadingState.value,
                        index - 3,
                      );
                    }
                  } else {
                    if (index == 0) {
                      return _sortWidget(theme);
                    } else {
                      return _buildBody(
                        theme,
                        _videoReplyReplyController.loadingState.value,
                        index - 1,
                      );
                    }
                  }
                },
              ),
              if (!widget.isDialogue &&
                  _videoReplyReplyController.loadingState.value is Success)
                _header(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sortWidget(ThemeData theme) => Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.surface,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => _videoReplyReplyController.count.value != -1
                  ? Text(
                      '相关回复共${_videoReplyReplyController.count.value}条',
                      style: const TextStyle(fontSize: 13),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(
              height: 35,
              child: TextButton.icon(
                onPressed: () => _videoReplyReplyController.queryBySort(),
                icon: Icon(
                  Icons.sort,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
                label: Obx(
                  () => Text(
                    _videoReplyReplyController.mode.value == Mode.MAIN_LIST_HOT
                        ? '按热度'
                        : '按时间',
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
      );

  get _getImageCallback => _horizontalPreview
      ? (imgList, index) {
          final ctr = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 200),
          )..forward();
          PageUtils.onHorizontalPreview(
            _key,
            AnimationController(
              vsync: this,
              duration: Duration.zero,
            ),
            ctr,
            imgList,
            index,
            (value) async {
              if (value == false) {
                await ctr.reverse();
              }
              try {
                ctr.dispose();
              } catch (_) {}
              if (value == false) {
                Get.back();
              }
            },
          );
        }
      : null;

  void _onReply(dynamic item, int index) {
    dynamic oid = item?.oid.toInt();
    dynamic root = item?.id.toInt();
    dynamic key = oid + root;

    Navigator.of(context)
        .push(
      GetDialogRoute(
        pageBuilder: (buildContext, animation, secondaryAnimation) {
          return ReplyPage(
            oid: oid,
            root: root,
            parent: root,
            replyType: widget.replyType,
            replyItem: item,
            initialValue: _savedReplies[key],
            onSave: (reply) {
              _savedReplies[key] = reply;
            },
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.linear;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    )
        .then((res) {
      if (res != null) {
        _savedReplies[key] = null;
        ReplyInfo replyInfo = RequestUtils.replyCast(res);
        List<ReplyInfo> list =
            _videoReplyReplyController.loadingState.value is Success
                ? (_videoReplyReplyController.loadingState.value as Success)
                    .response
                : <ReplyInfo>[];
        list.insert(index + 1, replyInfo);
        _videoReplyReplyController.count.value += 1;
        _videoReplyReplyController.loadingState.refresh();
        if (_videoReplyReplyController.enableCommAntifraud && mounted) {
          _videoReplyReplyController.checkReply(
            context: context,
            oid: oid,
            rpid: root,
            replyType: widget.replyType.index,
            replyId: replyInfo.id.toInt(),
            message: replyInfo.content.message,
            //
            root: replyInfo.root.toInt(),
            parent: replyInfo.parent.toInt(),
            ctime: replyInfo.ctime.toInt(),
            pictures: replyInfo.content.pictures
                .map((item) => item.toProto3Json())
                .toList(),
            mid: replyInfo.mid.toInt(),
          );
        }
      }
    });
  }

  Widget _buildBody(ThemeData theme, LoadingState loadingState, int index) {
    return switch (loadingState) {
      Loading() => IgnorePointer(
          child: CustomScrollView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverList.builder(
                itemBuilder: (context, index) {
                  return const VideoReplySkeleton();
                },
                itemCount: 8,
              )
            ],
          ),
        ),
      Success() => () {
          if (index == loadingState.response.length) {
            _videoReplyReplyController.onLoadMore();
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              height: 125,
              child: Text(
                _videoReplyReplyController.isEnd.not
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
            if (_videoReplyReplyController.index != null &&
                _videoReplyReplyController.index == index) {
              colorAnimation ??= ColorTween(
                begin: theme.colorScheme.onInverseSurface,
                end: theme.colorScheme.surface,
              ).animate(_videoReplyReplyController.controller!);
              return AnimatedBuilder(
                animation: colorAnimation!,
                builder: (context, child) {
                  return ColoredBox(
                    color: colorAnimation!.value ??
                        theme.colorScheme.onInverseSurface,
                    child: _replyItem(loadingState.response[index], index),
                  );
                },
              );
            }
            return _replyItem(loadingState.response[index], index);
          }
        }(),
      Error() => errorWidget(
          errMsg: loadingState.errMsg,
          onReload: _videoReplyReplyController.onReload,
        ),
    };
  }

  Widget _replyItem(replyItem, index) {
    return ReplyItemGrpc(
      replyItem: replyItem,
      replyLevel: widget.isDialogue ? '3' : '2',
      onReply: () {
        _onReply(replyItem, index);
      },
      onDelete: (subIndex) {
        List<ReplyInfo> list =
            (_videoReplyReplyController.loadingState.value as Success).response;
        list.removeAt(index);
        _videoReplyReplyController.count.value -= 1;
        _videoReplyReplyController.loadingState.refresh();
      },
      upMid: _videoReplyReplyController.upMid,
      showDialogue: () {
        _key.currentState?.showBottomSheet(
          backgroundColor: Colors.transparent,
          (context) => VideoReplyReplyPanel(
            oid: replyItem.oid.toInt(),
            rpid: replyItem.root.toInt(),
            dialog: replyItem.dialog.toInt(),
            replyType: widget.replyType,
            source: 'videoDetail',
            isDialogue: true,
          ),
        );
      },
      onViewImage: widget.onViewImage,
      onDismissed: widget.onDismissed,
      callback: _getImageCallback,
      onCheckReply: (item) =>
          _videoReplyReplyController.onCheckReply(context, item),
      onToggleTop: (isUpTop, rpid) => _videoReplyReplyController.onToggleTop(
        index,
        _videoReplyReplyController.oid,
        _videoReplyReplyController.replyType.index,
        isUpTop,
        rpid,
      ),
    );
  }

  int _itemCount(LoadingState loadingState) {
    if (widget.isDialogue) {
      return (loadingState is Success ? loadingState.response.length : 0) + 1;
    }
    int itemCount = 0;
    if (firstFloor != null) {
      itemCount = 2;
    }
    if (loadingState is Success) {
      return loadingState.response.length + itemCount + 2;
    } else {
      return itemCount + 2;
    }
  }
}
