import 'dart:math';

import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/reply_sort_type.dart';
import 'package:PiliPlus/pages/dynamics/repost_dyn_panel.dart';
import 'package:PiliPlus/pages/video/detail/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/models/common/reply_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/detail/index.dart';
import 'package:PiliPlus/pages/dynamics/widgets/author_panel.dart';
import 'package:PiliPlus/pages/video/detail/reply_reply/index.dart';
import 'package:PiliPlus/utils/feed_back.dart';

import '../../../utils/grid.dart';
import '../widgets/dynamic_panel.dart';

class DynamicDetailPage extends StatefulWidget {
  const DynamicDetailPage({super.key});

  @override
  State<DynamicDetailPage> createState() => _DynamicDetailPageState();
}

class _DynamicDetailPageState extends State<DynamicDetailPage>
    with TickerProviderStateMixin {
  late DynamicDetailController _dynamicDetailController;
  AnimationController? _fabAnimationCtr;
  final RxBool _visibleTitle = false.obs;
  // 回复类型
  late int replyType;
  bool _isFabVisible = true;
  bool? _imageStatus;
  int oid = 0;
  int? opusId;
  bool isOpusId = false;

  late final List<double> _ratio = GStorage.dynamicDetailRatio;

  bool get _horizontalPreview =>
      context.orientation == Orientation.landscape &&
      _dynamicDetailController.horizontalPreview;

  late final _key = GlobalKey<ScaffoldState>();

  get _getImageCallback => _horizontalPreview
      ? (imgList, index) {
          _imageStatus = true;
          bool isFabVisible = _isFabVisible;
          if (isFabVisible) {
            _hideFab();
          }
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
              _imageStatus = null;
              if (isFabVisible) {
                isFabVisible = false;
                _showFab();
              }
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

  @override
  void initState() {
    super.initState();
    // floor 1原创 2转发
    init();

    _fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabAnimationCtr?.forward();
    _dynamicDetailController.scrollController.addListener(listener);
  }

  // 页面初始化
  void init() async {
    Map args = Get.arguments;
    // 楼层
    int floor = args['floor'];
    // 评论类型
    final item = args['item'] as DynamicItemModel;
    int commentType = item.basic?.commentType ?? 11;
    replyType = (commentType == 0) ? 11 : commentType;

    if (floor == 1) {
      oid = int.parse(item.basic!.commentIdStr!);
    } else {
      try {
        final moduleDynamic = item.modules.moduleDynamic!;
        String majorType = moduleDynamic.major!.type!;

        if (majorType == 'MAJOR_TYPE_OPUS') {
          // 转发的动态
          String jumpUrl = moduleDynamic.major!.opus!.jumpUrl!;
          opusId = int.parse(jumpUrl.split('/').last);
          if (opusId != null) {
            isOpusId = true;
            _dynamicDetailController = Get.put(
              DynamicDetailController(oid, replyType),
              tag: Utils.makeHeroTag(opusId),
            );
            await _dynamicDetailController.getCommentParams(opusId!);
            setState(() {});
          }
        } else {
          oid = moduleDynamic.major!.draw!.id!;
        }
      } catch (_) {}
    }
    if (!isOpusId) {
      _dynamicDetailController = Get.put(
        DynamicDetailController(oid, replyType),
        tag: Utils.makeHeroTag(oid),
      );
    }
  }

  // 查看二级评论
  void replyReply(BuildContext context, ReplyInfo replyItem, int? id) {
    EasyThrottle.throttle('replyReply', const Duration(milliseconds: 500), () {
      int oid = replyItem.oid.toInt();
      int rpid = replyItem.id.toInt();
      Widget replyReplyPage(
              [bool automaticallyImplyLeading = true,
              VoidCallback? onDispose]) =>
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('评论详情'),
              titleSpacing: automaticallyImplyLeading ? null : 12,
              automaticallyImplyLeading: automaticallyImplyLeading,
            ),
            body: SafeArea(
              top: false,
              bottom: false,
              child: VideoReplyReplyPanel(
                id: id,
                oid: oid,
                rpid: rpid,
                source: 'dynamic',
                replyType: ReplyType.values[replyType],
                firstFloor: replyItem,
                onDispose: onDispose,
              ),
            ),
          );
      if (this.context.orientation == Orientation.portrait) {
        Get.to(
          replyReplyPage,
          routeName: 'dynamicDetail-Copy',
          arguments: {
            'item': _dynamicDetailController.item,
          },
        );
      } else {
        ScaffoldState? scaffoldState = Scaffold.maybeOf(context);
        if (scaffoldState != null) {
          bool isFabVisible = _isFabVisible;
          if (isFabVisible) {
            _hideFab();
          }
          scaffoldState.showBottomSheet(
            backgroundColor: Colors.transparent,
            (context) => MediaQuery.removePadding(
              context: context,
              removeLeft: true,
              child: replyReplyPage(
                false,
                () {
                  if (isFabVisible && _imageStatus != true) {
                    _showFab();
                  }
                },
              ),
            ),
          );
        } else {
          Get.to(
            replyReplyPage,
            routeName: 'dynamicDetail-Copy',
            arguments: {
              'item': _dynamicDetailController.item,
            },
          );
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dynamicDetailController.scrollController.hasClients) {
        _visibleTitle.value =
            _dynamicDetailController.scrollController.positions.first.pixels >
                55;
      }
    });
  }

  void listener() {
    // 标题
    _visibleTitle.value =
        _dynamicDetailController.scrollController.positions.first.pixels > 55;

    // fab按钮
    final ScrollDirection direction1 = _dynamicDetailController
        .scrollController.positions.first.userScrollDirection;
    late final ScrollDirection direction2 = _dynamicDetailController
        .scrollController.positions.last.userScrollDirection;
    if (direction1 == ScrollDirection.forward ||
        direction2 == ScrollDirection.forward) {
      _showFab();
    } else if (direction1 == ScrollDirection.reverse ||
        direction2 == ScrollDirection.reverse) {
      _hideFab();
    }
  }

  void _showFab() {
    if (!_isFabVisible) {
      _isFabVisible = true;
      _fabAnimationCtr?.forward();
    }
  }

  void _hideFab() {
    if (_isFabVisible) {
      _isFabVisible = false;
      _fabAnimationCtr?.reverse();
    }
  }

  @override
  void dispose() {
    _fabAnimationCtr?.dispose();
    _fabAnimationCtr = null;
    _dynamicDetailController.scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Obx(
          () {
            return AnimatedOpacity(
              opacity: _visibleTitle.value ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: AuthorPanel(
                item: _dynamicDetailController.item,
                source: 'detail', //to remove tag
              ),
            );
          },
        ),
        actions: context.orientation == Orientation.landscape
            ? [
                IconButton(
                  tooltip: '页面比例调节',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 56,
                            right: 16,
                          ),
                          width: context.width / 4,
                          height: 32,
                          child: Builder(
                            builder: (context) => Slider(
                              min: 1,
                              max: 100,
                              value: _ratio.first,
                              onChanged: (value) async {
                                if (value >= 10 && value <= 90) {
                                  _ratio[0] = value;
                                  _ratio[1] = 100 - value;
                                  await GStorage.setting.put(
                                    SettingBoxKey.dynamicDetailRatio,
                                    _ratio,
                                  );
                                  (context as Element).markNeedsBuild();
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Transform.rotate(
                    angle: pi / 2,
                    child: Icon(Icons.splitscreen, size: 19),
                  ),
                ),
                const SizedBox(width: 16),
              ]
            : null,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: context.orientation == Orientation.portrait
            ? refreshIndicator(
                onRefresh: () async {
                  await _dynamicDetailController.onRefresh();
                },
                child: _buildBody(context.orientation),
              )
            : _buildBody(context.orientation),
      ),
    );
  }

  Widget _buildBody(Orientation orientation) => Stack(
        children: [
          Builder(
            builder: (context) {
              double padding = max(context.width / 2 - Grid.smallCardWidth, 0);
              if (orientation == Orientation.portrait) {
                return CustomScrollView(
                  controller: _dynamicDetailController.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: DynamicPanel(
                        item: _dynamicDetailController.item,
                        source: 'detail',
                        callback: _getImageCallback,
                      ),
                    ),
                    replyPersistentHeader(context),
                    Obx(
                      () => replyList(
                          _dynamicDetailController.loadingState.value),
                    ),
                  ]
                      .map<Widget>((e) => SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          sliver: e))
                      .toList(),
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      flex: _ratio[0].toInt(),
                      child: CustomScrollView(
                        controller: _dynamicDetailController.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.only(
                              left: padding / 4,
                              bottom: MediaQuery.paddingOf(context).bottom + 80,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: DynamicPanel(
                                item: _dynamicDetailController.item,
                                source: 'detail',
                                callback: _getImageCallback,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: _ratio[1].toInt(),
                      child: Scaffold(
                        key: _key,
                        backgroundColor: Colors.transparent,
                        body: refreshIndicator(
                          onRefresh: () async {
                            await _dynamicDetailController.onRefresh();
                          },
                          child: CustomScrollView(
                            controller:
                                _dynamicDetailController.scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.only(right: padding / 4),
                                sliver: replyPersistentHeader(context),
                              ),
                              SliverPadding(
                                padding: EdgeInsets.only(right: padding / 4),
                                sliver: Obx(
                                  () => replyList(_dynamicDetailController
                                      .loadingState.value),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          if (_fabAnimationCtr != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ).animate(CurvedAnimation(
                  parent: _fabAnimationCtr!,
                  curve: Curves.easeInOut,
                )),
                child: Builder(
                  builder: (context) {
                    Widget button() => FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            feedBack();
                            _dynamicDetailController.onReply(
                              context,
                              oid: _dynamicDetailController.oid,
                              replyType: ReplyType.values[replyType],
                            );
                          },
                          tooltip: '评论动态',
                          child: const Icon(Icons.reply),
                        );
                    return _dynamicDetailController.showDynActionBar.not
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 14,
                                bottom:
                                    MediaQuery.paddingOf(context).bottom + 14,
                              ),
                              child: button(),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 14, bottom: 14),
                                child: button(),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  border: Border(
                                    top: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.08),
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.paddingOf(context).bottom),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Builder(
                                        builder: (btnContext) =>
                                            TextButton.icon(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              useSafeArea: true,
                                              builder: (context) => RepostPanel(
                                                item: _dynamicDetailController
                                                    .item,
                                                callback: () {
                                                  int count =
                                                      _dynamicDetailController
                                                              .item
                                                              .modules
                                                              .moduleStat
                                                              ?.forward
                                                              ?.count ??
                                                          0;
                                                  _dynamicDetailController
                                                          .item
                                                          .modules
                                                          .moduleStat ??=
                                                      ModuleStatModel();
                                                  _dynamicDetailController
                                                          .item
                                                          .modules
                                                          .moduleStat
                                                          ?.forward ??=
                                                      DynamicStat();
                                                  _dynamicDetailController
                                                      .item
                                                      .modules
                                                      .moduleStat!
                                                      .forward!
                                                      .count = count + 1;
                                                  if (btnContext.mounted) {
                                                    (btnContext as Element?)
                                                        ?.markNeedsBuild();
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.shareFromSquare,
                                            size: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            semanticLabel: "转发",
                                          ),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 15, 0),
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                          label: Text(
                                            _dynamicDetailController
                                                        .item
                                                        .modules
                                                        .moduleStat
                                                        ?.forward
                                                        ?.count !=
                                                    null
                                                ? Utils.numFormat(
                                                    _dynamicDetailController
                                                        .item
                                                        .modules
                                                        .moduleStat!
                                                        .forward!
                                                        .count)
                                                : '转发',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          Utils.shareText(
                                              '${HttpString.dynamicShareBaseUrl}/${_dynamicDetailController.item.idStr}');
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.shareNodes,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          semanticLabel: "分享",
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 0),
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                        label: const Text('分享'),
                                      ),
                                    ),
                                    Expanded(
                                      child: Builder(
                                        builder: (context) => TextButton.icon(
                                          onPressed: () =>
                                              RequestUtils.onLikeDynamic(
                                            _dynamicDetailController.item,
                                            () {
                                              if (context.mounted) {
                                                (context as Element?)
                                                    ?.markNeedsBuild();
                                              }
                                            },
                                          ),
                                          icon: Icon(
                                            _dynamicDetailController
                                                        .item
                                                        .modules
                                                        .moduleStat
                                                        ?.like
                                                        ?.status ==
                                                    true
                                                ? FontAwesomeIcons.solidThumbsUp
                                                : FontAwesomeIcons.thumbsUp,
                                            size: 16,
                                            color: _dynamicDetailController
                                                        .item
                                                        .modules
                                                        .moduleStat
                                                        ?.like
                                                        ?.status ==
                                                    true
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                            semanticLabel:
                                                _dynamicDetailController
                                                            .item
                                                            .modules
                                                            .moduleStat
                                                            ?.like
                                                            ?.status ==
                                                        true
                                                    ? "已赞"
                                                    : "点赞",
                                          ),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 15, 0),
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                          label: AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 400),
                                            transitionBuilder: (Widget child,
                                                Animation<double> animation) {
                                              return ScaleTransition(
                                                  scale: animation,
                                                  child: child);
                                            },
                                            child: Text(
                                              _dynamicDetailController
                                                          .item
                                                          .modules
                                                          .moduleStat
                                                          ?.like
                                                          ?.count !=
                                                      null
                                                  ? Utils.numFormat(
                                                      _dynamicDetailController
                                                          .item
                                                          .modules
                                                          .moduleStat!
                                                          .like!
                                                          .count)
                                                  : '点赞',
                                              style: TextStyle(
                                                color: _dynamicDetailController
                                                            .item
                                                            .modules
                                                            .moduleStat
                                                            ?.like
                                                            ?.status ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
            ),
        ],
      );

  SliverPersistentHeader replyPersistentHeader(BuildContext context) {
    return SliverPersistentHeader(
      delegate: CustomSliverPersistentHeaderDelegate(
        bgColor: Theme.of(context).colorScheme.surface,
        child: Container(
          height: 45,
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: Row(
            children: [
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(
                    '${_dynamicDetailController.count.value != -1 ? _dynamicDetailController.count.value : 0}条回复',
                    key: ValueKey<int>(_dynamicDetailController.count.value),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 35,
                child: TextButton.icon(
                  onPressed: () => _dynamicDetailController.queryBySort(),
                  icon: Icon(
                    Icons.sort,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Obx(() => Text(
                        _dynamicDetailController.sortType.value.label,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
      pinned: true,
    );
  }

  Widget replyList(LoadingState<List<ReplyInfo>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemBuilder: (context, index) {
            return const VideoReplySkeleton();
          },
          itemCount: 8,
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverList.builder(
              itemBuilder: (context, index) {
                if (index == loadingState.response!.length) {
                  _dynamicDetailController.onLoadMore();
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    height: 125,
                    child: Text(
                      _dynamicDetailController.isEnd.not
                          ? '加载中...'
                          : loadingState.response!.isEmpty
                              ? '还没有评论'
                              : '没有更多了',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  );
                } else {
                  return ReplyItemGrpc(
                    replyItem: loadingState.response![index],
                    replyLevel: '1',
                    replyReply: (replyItem, id) =>
                        replyReply(context, replyItem, id),
                    onReply: () {
                      _dynamicDetailController.onReply(
                        context,
                        replyItem: loadingState.response![index],
                        index: index,
                      );
                    },
                    onDelete: (subIndex) =>
                        _dynamicDetailController.onRemove(index, subIndex),
                    upMid: _dynamicDetailController.upMid,
                    callback: _getImageCallback,
                    onCheckReply: (item) =>
                        _dynamicDetailController.onCheckReply(context, item),
                    onToggleTop: (isUpTop, rpid) =>
                        _dynamicDetailController.onToggleTop(
                      index,
                      _dynamicDetailController.oid,
                      _dynamicDetailController.type,
                      isUpTop,
                      rpid,
                    ),
                  );
                }
              },
              itemCount: loadingState.response!.length + 1,
            )
          : HttpError(
              onReload: _dynamicDetailController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _dynamicDetailController.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }
}
