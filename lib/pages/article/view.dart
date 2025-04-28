import 'dart:math';

import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/dynamics/result.dart' show DynamicStat;
import 'package:PiliPlus/pages/article/widgets/opus_content.dart';
import 'package:PiliPlus/pages/article/widgets/html_render.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/reply_sort_type.dart';
import 'package:PiliPlus/pages/dynamics/repost_dyn_panel.dart';
import 'package:PiliPlus/pages/video/detail/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/models/common/reply_type.dart';
import 'package:PiliPlus/pages/video/detail/reply_reply/index.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:html/parser.dart' as parser;

import '../../utils/grid.dart';
import 'controller.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage>
    with TickerProviderStateMixin {
  final ArticleController _articleCtr = Get.put(
    ArticleController(),
    tag: Utils.generateRandomString(8),
  );
  bool _isFabVisible = true;
  bool? _imageStatus;
  late AnimationController fabAnimationCtr;

  late final List<double> _ratio = GStorage.dynamicDetailRatio;

  bool get _horizontalPreview =>
      context.orientation == Orientation.landscape &&
      _articleCtr.horizontalPreview;

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
    fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fabAnimationCtr.forward();
    _articleCtr.scrollController.addListener(listener);
  }

  @override
  void dispose() {
    fabAnimationCtr.dispose();
    _articleCtr.scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_articleCtr.scrollController.hasClients) {
        _articleCtr.showTitle.value =
            _articleCtr.scrollController.positions.last.pixels >= 45;
      }
    });
  }

  void listener() {
    _articleCtr.showTitle.value =
        _articleCtr.scrollController.positions.last.pixels >= 45;
    final ScrollDirection direction1 =
        _articleCtr.scrollController.positions.first.userScrollDirection;
    late final ScrollDirection direction2 =
        _articleCtr.scrollController.positions.last.userScrollDirection;
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
      fabAnimationCtr.forward();
    }
  }

  void _hideFab() {
    if (_isFabVisible) {
      _isFabVisible = false;
      fabAnimationCtr.reverse();
    }
  }

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
                replyType: ReplyType.values[_articleCtr.commentType],
                firstFloor: replyItem,
                onDispose: onDispose,
              ),
            ),
          );
      if (this.context.orientation == Orientation.portrait) {
        Get.to(
          replyReplyPage,
          routeName: 'htmlRender-Copy',
          arguments: {
            'id': _articleCtr.id,
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
            routeName: 'htmlRender-Copy',
            arguments: {
              'id': _articleCtr.id,
            },
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar,
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Builder(
              builder: (context) {
                final isPortrait = context.orientation == Orientation.portrait;
                double padding =
                    max(context.width / 2 - Grid.smallCardWidth, 0);
                if (isPortrait) {
                  return LayoutBuilder(builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth - 2 * padding - 24;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: CustomScrollView(
                        controller: _articleCtr.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          _buildContent(maxWidth),
                          SliverToBoxAdapter(
                            child: Divider(
                              thickness: 8,
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.05),
                            ),
                          ),
                          _buildReplyHeader,
                          Obx(() =>
                              _buildReplyList(_articleCtr.loadingState.value)),
                        ],
                      ),
                    );
                  });
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: _ratio[0].toInt(),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final maxWidth =
                                constraints.maxWidth - padding / 4 - 24;
                            return CustomScrollView(
                              controller: _articleCtr.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.only(
                                    left: padding / 4,
                                    bottom:
                                        MediaQuery.paddingOf(context).bottom +
                                            80,
                                  ),
                                  sliver: _buildContent(maxWidth),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      VerticalDivider(
                        thickness: 8,
                        color: Theme.of(context).dividerColor.withOpacity(0.05),
                      ),
                      Expanded(
                        flex: _ratio[1].toInt(),
                        child: Scaffold(
                          key: _key,
                          backgroundColor: Colors.transparent,
                          body: refreshIndicator(
                            onRefresh: () async {
                              await _articleCtr.onRefresh();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: padding / 4),
                              child: CustomScrollView(
                                controller: _articleCtr.scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  _buildReplyHeader,
                                  Obx(() => _buildReplyList(
                                      _articleCtr.loadingState.value)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          _buildBottom,
        ],
      ),
    );
  }

  Widget _buildContent(double maxWidth) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        sliver: Obx(
          () {
            if (_articleCtr.isLoaded.value) {
              late Widget content;
              if (_articleCtr.opus == null) {
                debugPrint('html page');
                final res = parser.parse(_articleCtr.articleData!.content!);
                content = SliverList.separated(
                  itemCount: res.body!.children.length,
                  itemBuilder: (context, index) {
                    return htmlRender(
                      context: context,
                      element: res.body!.children[index],
                      maxWidth: maxWidth,
                      callback: _getImageCallback,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                );
              } else {
                debugPrint('json page');
                content = OpusContent(
                  opus: _articleCtr.opus!,
                  callback: _getImageCallback,
                  maxWidth: maxWidth,
                );
              }

              int? pubTime =
                  _articleCtr.opusData?.modules.moduleAuthor?.pubTs ??
                      _articleCtr.articleData?.publishTime;
              return SliverMainAxisGroup(
                slivers: [
                  if (_articleCtr.summary.title != null)
                    SliverToBoxAdapter(
                      child: Text(
                        _articleCtr.summary.title!,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () => Get.toNamed(
                            '/member?mid=${_articleCtr.summary.author?.mid}'),
                        child: Row(
                          children: [
                            NetworkImgLayer(
                              // TODO Avatar
                              width: 40,
                              height: 40,
                              type: 'avatar',
                              src: _articleCtr.summary.author?.face,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _articleCtr.summary.author?.name ?? '',
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .fontSize,
                                  ),
                                ),
                                if (pubTime != null)
                                  Text(
                                    Utils.dateFormat(pubTime),
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontSize,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  content,
                ],
              );
            }

            return const SliverToBoxAdapter();
          },
        ),
      );

  Widget _buildReplyList(LoadingState<List<ReplyInfo>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return const VideoReplySkeleton();
          },
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverList.builder(
              itemCount: loadingState.response!.length + 1,
              itemBuilder: (context, index) {
                if (index == loadingState.response!.length) {
                  _articleCtr.onLoadMore();
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    height: 125,
                    child: Text(
                      _articleCtr.isEnd.not
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
                      _articleCtr.onReply(
                        context,
                        replyItem: loadingState.response![index],
                        index: index,
                      );
                    },
                    onDelete: (subIndex) =>
                        _articleCtr.onRemove(index, subIndex),
                    upMid: _articleCtr.upMid,
                    callback: _getImageCallback,
                    onCheckReply: (item) =>
                        _articleCtr.onCheckReply(context, item),
                    onToggleTop: (isUpTop, rpid) => _articleCtr.onToggleTop(
                      index,
                      _articleCtr.commentId,
                      _articleCtr.commentType,
                      isUpTop,
                      rpid,
                    ),
                  );
                }
              },
            )
          : HttpError(
              onReload: _articleCtr.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _articleCtr.onReload,
        ),
    };
  }

  Widget get _buildReplyHeader {
    return SliverToBoxAdapter(
      child: Container(
        height: 45,
        padding: const EdgeInsets.only(left: 12, right: 6),
        child: Row(
          children: [
            const Text('回复'),
            const Spacer(),
            SizedBox(
              height: 35,
              child: TextButton.icon(
                onPressed: () => _articleCtr.queryBySort(),
                icon: const Icon(Icons.sort, size: 16),
                label: Obx(
                  () => Text(
                    _articleCtr.sortType.value.label,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar => AppBar(
        title: Obx(() {
          if (_articleCtr.isLoaded.value && _articleCtr.showTitle.value) {
            return Text(_articleCtr.summary.title ?? '');
          }
          return const SizedBox.shrink();
        }),
        actions: [
          const SizedBox(width: 4),
          if (context.orientation == Orientation.landscape)
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
          IconButton(
            tooltip: '浏览器打开',
            onPressed: () {
              PageUtils.inAppWebview(_articleCtr.url);
            },
            icon: const Icon(Icons.open_in_browser_outlined, size: 19),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 19),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () => Utils.shareText(_articleCtr.url),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share_outlined, size: 19),
                    SizedBox(width: 10),
                    Text('分享'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => Utils.copyText(_articleCtr.url),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy_rounded, size: 19),
                    SizedBox(width: 10),
                    Text('复制链接'),
                  ],
                ),
              ),
              if (_articleCtr.commentType == 12 &&
                  _articleCtr.stats.value != null)
                PopupMenuItem(
                  onTap: () async {
                    try {
                      if (_articleCtr.summary.cover == null) {
                        if (!await _articleCtr.getArticleInfo()) {
                          return;
                        }
                      }
                      if (mounted) {
                        PageUtils.pmShare(
                          this.context,
                          content: {
                            "id": _articleCtr.commentId,
                            "title": "- 哔哩哔哩专栏",
                            "headline": _articleCtr.summary.title!, // throw
                            "source": 6,
                            "thumb": _articleCtr.summary.cover!,
                            "author": _articleCtr.summary.author!.name,
                            "author_id":
                                _articleCtr.summary.author!.mid.toString(),
                          },
                        );
                      }
                    } catch (e) {
                      SmartDialog.showToast(e.toString());
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.forward_to_inbox, size: 19),
                      SizedBox(width: 10),
                      Text('分享至动态'),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 6)
        ],
      );

  Widget get _buildBottom => Positioned(
        left: 0,
        bottom: 0,
        right: 0,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: fabAnimationCtr,
            curve: Curves.easeInOut,
          )),
          child: Builder(
            builder: (context) {
              Widget button() => FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      feedBack();
                      _articleCtr.onReply(
                        context,
                        oid: _articleCtr.commentId,
                        replyType: ReplyType.values[_articleCtr.commentType],
                      );
                    },
                    tooltip: '评论动态',
                    child: const Icon(Icons.reply),
                  );
              return _articleCtr.showDynActionBar.not
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 14,
                          bottom: MediaQuery.of(context).padding.bottom + 14,
                        ),
                        child: button(),
                      ),
                    )
                  : Obx(() {
                      Widget textIconButton({
                        required IconData icon,
                        required String text,
                        required DynamicStat? stat,
                        required VoidCallback callback,
                        IconData? activitedIcon,
                      }) {
                        final show = stat?.status == true;
                        final color = show
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline;
                        return TextButton.icon(
                          onPressed: callback,
                          icon: Icon(
                            stat?.status == true ? activitedIcon : icon,
                            size: 16,
                            color: color,
                            semanticLabel: text,
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            foregroundColor:
                                Theme.of(context).colorScheme.outline,
                          ),
                          label: Text(stat?.count != null
                              ? Utils.numFormat(stat!.count)
                              : text),
                        );
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: 14,
                              bottom: 14 +
                                  (_articleCtr.stats.value != null
                                      ? 0
                                      : MediaQuery.of(context).padding.bottom),
                            ),
                            child: button(),
                          ),
                          _articleCtr.stats.value != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
                                              textIconButton(
                                            text: '转发',
                                            icon: FontAwesomeIcons
                                                .shareFromSquare,
                                            stat: _articleCtr
                                                .stats.value?.forward,
                                            callback: () {
                                              if (_articleCtr.opusData ==
                                                      null &&
                                                  _articleCtr.articleData
                                                          ?.dynIdStr ==
                                                      null) {
                                                SmartDialog.showToast(
                                                    'err: ${_articleCtr.id}');
                                                return;
                                              }
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                useSafeArea: true,
                                                builder: (context) =>
                                                    RepostPanel(
                                                  item: _articleCtr.opusData,
                                                  dynIdStr: _articleCtr
                                                      .articleData?.dynIdStr,
                                                  pic:
                                                      _articleCtr.summary.cover,
                                                  title:
                                                      _articleCtr.summary.title,
                                                  uname: _articleCtr
                                                      .summary.author?.name,
                                                  callback: () {
                                                    int count = _articleCtr
                                                            .stats
                                                            .value
                                                            ?.forward
                                                            ?.count ??
                                                        0;
                                                    _articleCtr
                                                        .stats
                                                        .value
                                                        ?.forward
                                                        ?.count = count + 1;
                                                    if (btnContext.mounted) {
                                                      (btnContext as Element?)
                                                          ?.markNeedsBuild();
                                                    }
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: textIconButton(
                                        text: '分享',
                                        icon: FontAwesomeIcons.shareNodes,
                                        stat: null,
                                        callback: () =>
                                            Utils.shareText(_articleCtr.url),
                                      )),
                                      if (_articleCtr.stats.value != null)
                                        Expanded(
                                            child: textIconButton(
                                          icon: FontAwesomeIcons.star,
                                          activitedIcon:
                                              FontAwesomeIcons.solidStar,
                                          text: '收藏',
                                          stat:
                                              _articleCtr.stats.value!.favorite,
                                          callback: _articleCtr.onFav,
                                        )),
                                      Expanded(
                                        child: Builder(
                                          builder: (context) => TextButton.icon(
                                            onPressed: _articleCtr.onLike,
                                            icon: Icon(
                                              _articleCtr.stats.value?.like
                                                          ?.status ==
                                                      true
                                                  ? FontAwesomeIcons
                                                      .solidThumbsUp
                                                  : FontAwesomeIcons.thumbsUp,
                                              size: 16,
                                              color: _articleCtr.stats.value
                                                          ?.like?.status ==
                                                      true
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                              semanticLabel: _articleCtr
                                                          .stats
                                                          .value
                                                          ?.like
                                                          ?.status ==
                                                      true
                                                  ? "已赞"
                                                  : "点赞",
                                            ),
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
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
                                                _articleCtr.stats.value?.like
                                                            ?.count !=
                                                        null
                                                    ? Utils.numFormat(
                                                        _articleCtr.stats.value!
                                                            .like!.count)
                                                    : '点赞',
                                                style: TextStyle(
                                                  color: _articleCtr.stats.value
                                                              ?.like?.status ==
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
                                )
                              : const SizedBox.shrink(),
                        ],
                      );
                    });
            },
          ),
        ),
      );
}
