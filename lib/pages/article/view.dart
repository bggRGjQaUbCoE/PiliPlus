import 'dart:math';

import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart' show DynamicStat;
import 'package:PiliPlus/pages/article/controller.dart';
import 'package:PiliPlus/pages/article/widgets/html_render.dart';
import 'package:PiliPlus/pages/article/widgets/opus_content.dart';
import 'package:PiliPlus/pages/article/widgets/read_opus.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as parser;

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
  late final AnimationController fabAnimationCtr;
  late final Animation<Offset> _anim;

  late final List<double> _ratio = GStorage.dynamicDetailRatio;

  bool get _horizontalPreview =>
      context.orientation == Orientation.landscape &&
      _articleCtr.horizontalPreview;

  late final _key = GlobalKey<ScaffoldState>();

  Function(dynamic imgList, dynamic index)? get _getImageCallback =>
      _horizontalPreview
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
    _anim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: fabAnimationCtr,
      curve: Curves.easeInOut,
    ));
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
      Widget replyReplyPage({
        bool automaticallyImplyLeading = true,
        VoidCallback? onDispose,
      }) =>
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
                enableSlide: false,
                id: id,
                oid: oid,
                rpid: rpid,
                source: 'dynamic',
                replyType: _articleCtr.commentType,
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
                automaticallyImplyLeading: false,
                onDispose: () {
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
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (context) {
                  final isPortrait =
                      context.orientation == Orientation.portrait;
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
                            _buildContent(theme, maxWidth),
                            SliverToBoxAdapter(
                              child: Divider(
                                thickness: 8,
                                color:
                                    theme.dividerColor.withValues(alpha: 0.05),
                              ),
                            ),
                            _buildReplyHeader(theme),
                            Obx(() => _buildReplyList(
                                theme, _articleCtr.loadingState.value)),
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
                                    sliver: _buildContent(theme, maxWidth),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        VerticalDivider(
                          thickness: 8,
                          color: theme.dividerColor.withValues(alpha: 0.05),
                        ),
                        Expanded(
                          flex: _ratio[1].toInt(),
                          child: Scaffold(
                            key: _key,
                            backgroundColor: Colors.transparent,
                            body: refreshIndicator(
                              onRefresh: _articleCtr.onRefresh,
                              child: Padding(
                                padding: EdgeInsets.only(right: padding / 4),
                                child: CustomScrollView(
                                  controller: _articleCtr.scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    _buildReplyHeader(theme),
                                    Obx(() => _buildReplyList(
                                        theme, _articleCtr.loadingState.value)),
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
            _buildBottom(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, double maxWidth) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        sliver: Obx(
          () {
            if (_articleCtr.isLoaded.value) {
              late Widget content;
              if (_articleCtr.opus != null) {
                debugPrint('json page');
                content = OpusContent(
                  opus: _articleCtr.opus!,
                  callback: _getImageCallback,
                  maxWidth: maxWidth,
                );
              } else if (_articleCtr.opusData?.modules.moduleBlocked != null) {
                debugPrint('moduleBlocked');
                final moduleBlocked =
                    _articleCtr.opusData!.modules.moduleBlocked!;
                content = SliverToBoxAdapter(
                  child: moduleBlockedItem(theme, moduleBlocked, maxWidth),
                );
              } else if (_articleCtr.articleData?.content != null) {
                if (_articleCtr.articleData?.type == 3) {
                  // json
                  return ReadOpus(ops: _articleCtr.articleData?.ops);
                }
                debugPrint('html page');
                final res = parser.parse(_articleCtr.articleData!.content!);
                if (res.body!.children.isEmpty) {
                  content = SliverToBoxAdapter(
                    child: htmlRender(
                      context: context,
                      html: _articleCtr.articleData!.content!,
                      maxWidth: maxWidth,
                      callback: _getImageCallback,
                    ),
                  );
                } else {
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
                }
              } else {
                content = const SliverToBoxAdapter(child: Text('NULL'));
              }

              int? pubTime =
                  _articleCtr.opusData?.modules.moduleAuthor?.pubTs ??
                      _articleCtr.articleData?.publishTime;
              return SliverMainAxisGroup(
                slivers: [
                  if (_articleCtr.type != 'read' &&
                      _articleCtr.opusData?.modules.moduleTop?.display?.album
                              ?.pics?.isNotEmpty ==
                          true)
                    SliverToBoxAdapter(
                      child: Builder(
                        builder: (context) {
                          final pics = _articleCtr.opusData!.modules.moduleTop!
                              .display!.album!.pics!;
                          final length = pics.length;
                          final first = pics.first;
                          double height;
                          double paddingRight;
                          if (first.height != null && first.width != null) {
                            final ratio = first.height! / first.width!;
                            height = min(maxWidth * ratio, Get.height * 0.55);
                            paddingRight = (maxWidth - height / ratio) / 2 + 12;
                          } else {
                            height = Get.height * 0.55;
                            paddingRight = 12;
                          }
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: height,
                                width: maxWidth,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: PageView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  onPageChanged: (value) {
                                    _articleCtr.topIndex.value = value;
                                  },
                                  itemCount: length,
                                  itemBuilder: (context, index) {
                                    final pic = pics[index];
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => context.imageView(
                                        imgList: pics
                                            .map(
                                                (e) => SourceModel(url: e.url!))
                                            .toList(),
                                        initialPage: index,
                                      ),
                                      child: Hero(
                                        tag: pic.url!,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned.fill(
                                              child: CachedNetworkImage(
                                                fit: pic.isLongPic == true
                                                    ? BoxFit.cover
                                                    : null,
                                                imageUrl: Utils.thumbnailImgUrl(
                                                    pic.url, 60),
                                              ),
                                            ),
                                            if (pic.isLongPic == true)
                                              PBadge(
                                                text: '长图',
                                                type: PBadgeType.primary,
                                                right: paddingRight,
                                                bottom: 12,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Obx(
                                () => PBadge(
                                    top: 12,
                                    right: paddingRight,
                                    type: PBadgeType.gray,
                                    text:
                                        '${_articleCtr.topIndex.value + 1}/$length'),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  if (_articleCtr.summary.title != null)
                    SliverToBoxAdapter(
                      child: Text(
                        _articleCtr.summary.title!,
                        style: const TextStyle(
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
                              type: ImageType.avatar,
                              src: _articleCtr.summary.author?.face,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _articleCtr.summary.author?.name ?? '',
                                  style: TextStyle(
                                    fontSize:
                                        theme.textTheme.titleSmall!.fontSize,
                                  ),
                                ),
                                if (pubTime != null)
                                  Text(
                                    Utils.dateFormat(pubTime),
                                    style: TextStyle(
                                      color: theme.colorScheme.outline,
                                      fontSize:
                                          theme.textTheme.labelSmall!.fontSize,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_articleCtr.type != 'read' &&
                      _articleCtr.opusData?.modules.moduleCollection != null)
                    SliverToBoxAdapter(
                      child: opusCollection(
                        theme,
                        _articleCtr.opusData!.modules.moduleCollection!,
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

  Widget _buildReplyList(
      ThemeData theme, LoadingState<List<ReplyInfo>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return const VideoReplySkeleton();
          },
        ),
      Success(:var response) => response?.isNotEmpty == true
          ? SliverList.builder(
              itemCount: response!.length + 1,
              itemBuilder: (context, index) {
                if (index == response.length) {
                  _articleCtr.onLoadMore();
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    height: 125,
                    child: Text(
                      _articleCtr.isEnd ? '没有更多了' : '加载中...',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  );
                } else {
                  return ReplyItemGrpc(
                    replyItem: response[index],
                    replyLevel: '1',
                    replyReply: (replyItem, id) =>
                        replyReply(context, replyItem, id),
                    onReply: () => _articleCtr.onReply(
                      context,
                      replyItem: response[index],
                      index: index,
                    ),
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
          : HttpError(onReload: _articleCtr.onReload),
      Error(:var errMsg) => HttpError(
          errMsg: errMsg,
          onReload: _articleCtr.onReload,
        ),
    };
  }

  Widget _buildReplyHeader(ThemeData theme) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverPersistentHeaderDelegate(
        extent: 40,
        bgColor: theme.colorScheme.surface,
        child: Container(
          height: 45,
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                  '${_articleCtr.count.value == -1 ? 0 : Utils.numFormat(_articleCtr.count.value)}条回复')),
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
              onPressed: () => showDialog(
                context: context,
                builder: (context) => Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(
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
                        onChanged: (value) {
                          if (value >= 10 && value <= 90) {
                            _ratio[0] = value;
                            _ratio[1] = 100 - value;
                            GStorage.setting.put(
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
              ),
              icon: Transform.rotate(
                angle: pi / 2,
                child: const Icon(Icons.splitscreen, size: 19),
              ),
            ),
          IconButton(
            tooltip: '浏览器打开',
            onPressed: () => PageUtils.inAppWebview(_articleCtr.url),
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
                  _articleCtr.stats.value != null &&
                  _articleCtr.opusData?.modules.moduleBlocked == null)
                PopupMenuItem(
                  onTap: () async {
                    try {
                      if (_articleCtr.summary.cover == null) {
                        if (!await _articleCtr.getArticleInfo(true)) {
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
                      Text('分享至消息'),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 6)
        ],
      );

  Widget _buildBottom(ThemeData theme) => Positioned(
        left: 0,
        bottom: 0,
        right: 0,
        child: SlideTransition(
          position: _anim,
          child: Builder(
            builder: (context) {
              Widget button() => FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      feedBack();
                      _articleCtr.onReply(
                        context,
                        oid: _articleCtr.commentId,
                        replyType: _articleCtr.commentType,
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
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline;
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
                            foregroundColor: theme.colorScheme.outline,
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
                                    color: theme.colorScheme.surface,
                                    border: Border(
                                      top: BorderSide(
                                        color: theme.colorScheme.outline
                                            .withValues(alpha: 0.08),
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
                                        icon: CustomIcon.share_node,
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
                                                  ? theme.colorScheme.primary
                                                  : theme.colorScheme.outline,
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
                                              foregroundColor:
                                                  theme.colorScheme.outline,
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
                                                      ? theme
                                                          .colorScheme.primary
                                                      : theme
                                                          .colorScheme.outline,
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
