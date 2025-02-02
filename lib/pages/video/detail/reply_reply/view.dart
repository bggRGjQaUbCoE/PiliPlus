import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/video/reply/item.dart';
import 'package:PiliPlus/pages/video/detail/reply/widgets/reply_item.dart';
import 'package:PiliPlus/pages/video/detail/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/detail/reply_new/reply_page.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/models/common/reply_type.dart';
import 'package:get/get_navigation/src/dialog/dialog_route.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'controller.dart';

class VideoReplyReplyPanel extends StatefulWidget {
  const VideoReplyReplyPanel({
    super.key,
    this.id,
    this.oid,
    this.rpid,
    this.dialog,
    this.firstFloor,
    this.source,
    required this.replyType,
    this.isDialogue = false,
    this.isTop = false,
    this.onViewImage,
    this.onDismissed,
  });
  final int? id;
  final int? oid;
  final int? rpid;
  final int? dialog;
  final dynamic firstFloor;
  final String? source;
  final ReplyType replyType;
  final bool isDialogue;
  final bool isTop;
  final VoidCallback? onViewImage;
  final ValueChanged<int>? onDismissed;

  @override
  State<VideoReplyReplyPanel> createState() => _VideoReplyReplyPanelState();
}

class _VideoReplyReplyPanelState extends State<VideoReplyReplyPanel>
    with SingleTickerProviderStateMixin {
  late VideoReplyReplyController _videoReplyReplyController;
  late final _savedReplies = {};
  late final itemPositionsListener = ItemPositionsListener.create();
  late final _key = GlobalKey<ScaffoldState>();

  dynamic get firstFloor =>
      widget.firstFloor ?? _videoReplyReplyController.firstFloor;

  bool get _horizontalPreview =>
      context.orientation == Orientation.landscape &&
      _videoReplyReplyController.horizontalPreview;

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
      tag: '${widget.rpid}${widget.dialog}${widget.isDialogue}',
    );
  }

  @override
  void dispose() {
    _videoReplyReplyController.controller?.stop();
    _videoReplyReplyController.controller?.dispose();
    _videoReplyReplyController.controller = null;
    Get.delete<VideoReplyReplyController>(
      tag: '${widget.rpid}${widget.dialog}${widget.isDialogue}',
    );
    super.dispose();
  }

  Widget get _header => firstFloor == null
      ? _sortWidget
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
            return min >= 2 ? _sortWidget : const SizedBox.shrink();
          },
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      body: Container(
        // height: widget.source == 'videoDetail'
        //     ? Utils.getSheetHeight(context)
        //     : null,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            if (widget.source == 'videoDetail')
              Container(
                height: 45,
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
            Divider(
              height: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
            Expanded(
              child: refreshIndicator(
                onRefresh: () async {
                  await _videoReplyReplyController.onRefresh();
                },
                child: Obx(
                  () => Stack(
                    children: [
                      ScrollablePositionedList.builder(
                        itemPositionsListener: itemPositionsListener,
                        itemCount: _itemCount(
                            _videoReplyReplyController.loadingState.value),
                        itemScrollController:
                            _videoReplyReplyController.itemScrollCtr,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (widget.isDialogue) {
                            return _buildBody(
                                _videoReplyReplyController.loadingState.value,
                                index);
                          } else if (firstFloor != null) {
                            if (index == 0) {
                              return GlobalData().grpcReply
                                  ? ReplyItemGrpc(
                                      replyItem: firstFloor,
                                      replyLevel: '2',
                                      showReplyRow: false,
                                      replyType: widget.replyType,
                                      needDivider: false,
                                      onReply: () {
                                        _onReply(firstFloor, -1);
                                      },
                                      upMid: _videoReplyReplyController.upMid,
                                      isTop: widget.isTop,
                                      onViewImage: widget.onViewImage,
                                      onDismissed: widget.onDismissed,
                                      callback: _getImageCallback,
                                    )
                                  : ReplyItem(
                                      replyItem: firstFloor,
                                      replyLevel: '2',
                                      showReplyRow: false,
                                      replyType: widget.replyType,
                                      needDivider: false,
                                      onReply: () {
                                        _onReply(firstFloor, -1);
                                      },
                                      onViewImage: widget.onViewImage,
                                      onDismissed: widget.onDismissed,
                                      callback: _getImageCallback,
                                    );
                            } else if (index == 1) {
                              return Divider(
                                height: 20,
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.1),
                                thickness: 6,
                              );
                            } else if (index == 2) {
                              return _sortWidget;
                            } else {
                              return _buildBody(
                                  _videoReplyReplyController.loadingState.value,
                                  index - 3);
                            }
                          } else {
                            if (index == 0) {
                              return _sortWidget;
                            } else {
                              return _buildBody(
                                  _videoReplyReplyController.loadingState.value,
                                  index - 1);
                            }
                          }
                        },
                      ),
                      if (!widget.isDialogue &&
                          _videoReplyReplyController.loadingState.value
                              is Success)
                        _header,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _sortWidget => Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
        color: Theme.of(context).colorScheme.surface,
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
            if (GlobalData().grpcReply)
              SizedBox(
                height: 35,
                child: TextButton.icon(
                  onPressed: () => _videoReplyReplyController.queryBySort(),
                  icon: Icon(
                    Icons.sort,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Obx(
                    () => Text(
                      _videoReplyReplyController.mode.value ==
                              Mode.MAIN_LIST_HOT
                          ? '按热度'
                          : '按时间',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.secondary,
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
          Utils.onHorizontalPreview(
            _key,
            AnimationController(
              vsync: this,
              duration: Duration.zero,
            ),
            ctr,
            imgList,
            index,
            () async {
              await ctr.reverse();
              ctr.dispose();
              Get.back();
            },
          );
        }
      : null;

  void _onReply(dynamic item, int index) {
    dynamic oid = item?.oid.toInt();
    dynamic root = GlobalData().grpcReply ? item?.id.toInt() : item?.rpid;
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
        if (GlobalData().grpcReply) {
          ReplyInfo replyInfo = Utils.replyCast(res);
          List list = _videoReplyReplyController.loadingState.value is Success
              ? (_videoReplyReplyController.loadingState.value as Success)
                  .response
              : <ReplyInfo>[];
          list.insert(index + 1, replyInfo);
          _videoReplyReplyController.count.value += 1;
          _videoReplyReplyController.loadingState.value =
              LoadingState.success(list);
          if (_videoReplyReplyController.enableCommAntifraud && mounted) {
            _videoReplyReplyController.checkReply(
              context,
              oid,
              root,
              widget.replyType.index,
              replyInfo.id.toInt(),
              replyInfo.content.message,
            );
          }
        } else {
          List list = _videoReplyReplyController.loadingState.value is Success
              ? (_videoReplyReplyController.loadingState.value as Success)
                  .response
              : <ReplyItemModel>[];
          ReplyItemModel replyInfo = ReplyItemModel.fromJson(res, '');
          list.insert(index + 1, replyInfo);
          _videoReplyReplyController.count.value += 1;
          _videoReplyReplyController.loadingState.value =
              LoadingState.success(list);
          if (_videoReplyReplyController.enableCommAntifraud && mounted) {
            _videoReplyReplyController.checkReply(
              context,
              oid,
              root,
              widget.replyType.index,
              replyInfo.rpid ?? 0,
              replyInfo.content?.message ?? '',
            );
          }
        }
      }
    });
  }

  Widget _buildBody(LoadingState loadingState, int index) {
    return switch (loadingState) {
      Loading() => CustomScrollView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return const VideoReplySkeleton();
                },
                childCount: 8,
              ),
            )
          ],
        ),
      Success() => () {
          if (index == loadingState.response.length) {
            _videoReplyReplyController.onLoadMore();
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              height: MediaQuery.of(context).padding.bottom + 100,
              child: Text(
                _videoReplyReplyController.isEnd.not
                    ? '加载中...'
                    : loadingState.response.isEmpty
                        ? '还没有评论'
                        : '没有更多了',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            );
          } else {
            return _videoReplyReplyController.index == index
                ? AnimatedBuilder(
                    animation: _videoReplyReplyController.colorAnimation!,
                    builder: (context, child) {
                      return ColoredBox(
                        color: _videoReplyReplyController
                                .colorAnimation?.value ??
                            Theme.of(Get.context!).colorScheme.onInverseSurface,
                        child: _replyItem(loadingState.response[index], index),
                      );
                    },
                  )
                : _replyItem(loadingState.response[index], index);
          }
        }(),
      Error() => replyErrorWidget(
          context,
          false,
          loadingState.errMsg,
          _videoReplyReplyController.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }

  Widget _replyItem(replyItem, index) {
    return GlobalData().grpcReply
        ? ReplyItemGrpc(
            replyItem: replyItem,
            replyLevel: widget.isDialogue ? '3' : '2',
            showReplyRow: false,
            replyType: widget.replyType,
            onReply: () {
              _onReply(replyItem, index);
            },
            onDelete: (rpid, frpid) {
              List list =
                  (_videoReplyReplyController.loadingState.value as Success)
                      .response;
              list = list.where((item) => item.id != rpid).toList();
              _videoReplyReplyController.count.value -= 1;
              _videoReplyReplyController.loadingState.value =
                  LoadingState.success(list);
            },
            upMid: _videoReplyReplyController.upMid,
            showDialogue: () {
              _key.currentState?.showBottomSheet(
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
          )
        : ReplyItem(
            replyItem: replyItem,
            replyLevel: '2',
            showReplyRow: false,
            replyType: widget.replyType,
            onReply: () {
              _onReply(replyItem, index);
            },
            onDelete: (rpid, frpid) {
              List list =
                  (_videoReplyReplyController.loadingState.value as Success)
                      .response;
              list.removeWhere((item) => item.rpid == rpid);
              _videoReplyReplyController.count.value -= 1;
              _videoReplyReplyController.loadingState.value =
                  LoadingState.success(list);
            },
            onViewImage: widget.onViewImage,
            onDismissed: widget.onDismissed,
            callback: _getImageCallback,
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
