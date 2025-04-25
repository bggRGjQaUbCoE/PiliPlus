import 'dart:math';

import 'package:PiliPlus/common/widgets/article_content.dart';
import 'package:PiliPlus/common/widgets/html_render.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
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
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/common/reply_type.dart';
import 'package:PiliPlus/pages/video/detail/reply_reply/index.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:html/parser.dart' as parser;

import '../../utils/grid.dart';
import 'controller.dart';

class HtmlRenderPage extends StatefulWidget {
  const HtmlRenderPage({super.key});

  @override
  State<HtmlRenderPage> createState() => _HtmlRenderPageState();
}

class _HtmlRenderPageState extends State<HtmlRenderPage>
    with TickerProviderStateMixin {
  late final HtmlRenderController _htmlRenderCtr = Get.put(
    HtmlRenderController(),
    tag: Utils.makeHeroTag(id),
  );
  late String title;
  late String id;
  late String url;
  late String dynamicType;
  late int type;
  bool _isFabVisible = true;
  bool? _imageStatus;
  late AnimationController fabAnimationCtr;

  late final List<double> _ratio = GStorage.dynamicDetailRatio;

  bool get _horizontalPreview =>
      context.orientation == Orientation.landscape &&
      _htmlRenderCtr.horizontalPreview;

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
    title = Get.parameters['title']!;
    id = Get.parameters['id']!;
    url = Get.parameters['url']!;
    dynamicType = Get.parameters['dynamicType']!;
    type = dynamicType == 'picture' ? 11 : 12;
    fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fabAnimationCtr.forward();
    scrollListener();
  }

  @override
  void dispose() {
    fabAnimationCtr.dispose();
    _htmlRenderCtr.scrollController.removeListener(listener);
    super.dispose();
  }

  void scrollListener() {
    _htmlRenderCtr.scrollController.addListener(listener);
  }

  void listener() {
    final ScrollDirection direction1 =
        _htmlRenderCtr.scrollController.positions.first.userScrollDirection;
    late final ScrollDirection direction2 =
        _htmlRenderCtr.scrollController.positions.last.userScrollDirection;
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
                replyType: ReplyType.values[type],
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
            'id': _htmlRenderCtr.id,
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
              'id': _htmlRenderCtr.id,
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
                        controller: _htmlRenderCtr.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          _buildHeader,
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
                          Obx(() => _buildReplyList(
                              _htmlRenderCtr.loadingState.value)),
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
                              controller: _htmlRenderCtr.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.only(left: padding / 4),
                                  sliver: _buildHeader,
                                ),
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
                              await _htmlRenderCtr.onRefresh();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: padding / 4),
                              child: CustomScrollView(
                                controller: _htmlRenderCtr.scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  _buildReplyHeader,
                                  Obx(() => _buildReplyList(
                                      _htmlRenderCtr.loadingState.value)),
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
            if (_htmlRenderCtr.loaded.value) {
              if (_htmlRenderCtr.item != null) {
                return articleContent(
                  context: context,
                  list: _htmlRenderCtr.item!.modules.moduleContent!,
                  callback: _getImageCallback,
                  maxWidth: maxWidth,
                );
              }

              // html
              var res = parser.parse(_htmlRenderCtr.readContent!.content!);
              return SliverList.builder(
                itemCount: res.body!.children.length,
                itemBuilder: (context, index) {
                  return htmlRender(
                    context: context,
                    element: res.body!.children[index],
                    maxWidth: maxWidth,
                    callback: _getImageCallback,
                  );
                },
              );
            }

            return const SliverToBoxAdapter();
          },
        ),
      );

  Widget _buildReplyList(LoadingState<List<ReplyInfo>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return const VideoReplySkeleton();
          },
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverList.builder(
              itemCount: loadingState.response!.length + 1,
              itemBuilder: (context, index) {
                if (index == loadingState.response!.length) {
                  _htmlRenderCtr.onLoadMore();
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    height: 125,
                    child: Text(
                      _htmlRenderCtr.isEnd.not
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
                      _htmlRenderCtr.onReply(
                        context,
                        replyItem: loadingState.response![index],
                        index: index,
                      );
                    },
                    onDelete: (subIndex) =>
                        _htmlRenderCtr.onRemove(index, subIndex),
                    upMid: _htmlRenderCtr.upMid,
                    callback: _getImageCallback,
                    onCheckReply: (item) =>
                        _htmlRenderCtr.onCheckReply(context, item),
                    onToggleTop: (isUpTop, rpid) => _htmlRenderCtr.onToggleTop(
                      index,
                      _htmlRenderCtr.oid,
                      _htmlRenderCtr.type,
                      isUpTop,
                      rpid,
                    ),
                  );
                }
              },
            )
          : HttpError(
              onReload: _htmlRenderCtr.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _htmlRenderCtr.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
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
                onPressed: () => _htmlRenderCtr.queryBySort(),
                icon: const Icon(Icons.sort, size: 16),
                label: Obx(
                  () => Text(
                    _htmlRenderCtr.sortType.value.label,
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

  Widget get _buildHeader => SliverToBoxAdapter(
        child: Obx(
          () => _htmlRenderCtr.loaded.value
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: GestureDetector(
                    onTap: () {
                      if (_htmlRenderCtr.mid != null) {
                        Get.toNamed('/member?mid=${_htmlRenderCtr.mid}');
                      }
                    },
                    child: Row(
                      children: [
                        NetworkImgLayer(
                          width: 40,
                          height: 40,
                          type: 'avatar',
                          src:
                              _htmlRenderCtr.item?.modules.moduleAuthor?.face ??
                                  _htmlRenderCtr.readContent?.author?.face,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _htmlRenderCtr.item?.modules.moduleAuthor?.name ??
                                  _htmlRenderCtr.readContent?.author?.name ??
                                  'null',
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .fontSize,
                              ),
                            ),
                            Text(
                              Utils.timeFormat(_htmlRenderCtr
                                      .item?.modules.moduleAuthor?.pubTs ??
                                  _htmlRenderCtr.readContent?.publishTime),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      );

  PreferredSizeWidget get _buildAppBar => AppBar(
        title: Text(title),
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
              PageUtils.inAppWebview(
                  url.startsWith('http') ? url : 'https:$url');
            },
            icon: const Icon(Icons.open_in_browser_outlined, size: 19),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 19),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () => {
                  _htmlRenderCtr.reqHtml(),
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, size: 19),
                    SizedBox(width: 10),
                    Text('刷新'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  PageUtils.inAppWebview(
                      url.startsWith('http') ? url : 'https:$url');
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_in_new, size: 19),
                    SizedBox(width: 10),
                    Text('浏览器打开'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => Utils.copyText(url),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy_rounded, size: 19),
                    SizedBox(width: 10),
                    Text('复制链接'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => Utils.shareText(url),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share_outlined, size: 19),
                    SizedBox(width: 10),
                    Text('分享'),
                  ],
                ),
              ),
              if (_htmlRenderCtr.dynamicType == 'read' &&
                  _htmlRenderCtr.stats.value != null)
                PopupMenuItem(
                  onTap: () {
                    try {
                      PageUtils.pmShare(
                        content: {
                          "id": _htmlRenderCtr.id.substring(2),
                          "title": "- 哔哩哔哩专栏",
                          "headline": _htmlRenderCtr.summary.title ?? '',
                          "source": 6,
                          "thumb": _htmlRenderCtr.summary.cover ?? '',
                          "author": _htmlRenderCtr.summary.author?.name ?? '',
                          "author_id":
                              _htmlRenderCtr.summary.author?.mid?.toString() ??
                                  '',
                        },
                      );
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
              Widget button = FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  feedBack();
                  _htmlRenderCtr.onReply(
                    context,
                    oid: _htmlRenderCtr.oid,
                    replyType: ReplyType.values[type],
                  );
                },
                tooltip: '评论动态',
                child: const Icon(Icons.reply),
              );
              return _htmlRenderCtr.showDynActionBar.not
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 14,
                          bottom: MediaQuery.of(context).padding.bottom + 14,
                        ),
                        child: button,
                      ),
                    )
                  : Obx(
                      () {
                        Widget actionBtn({
                          bool? activited,
                          required IconData icon,
                          IconData? activitedIcon,
                          required String text,
                          int? count,
                          required VoidCallback onPressed,
                        }) {
                          final colorScheme = Theme.of(context).colorScheme;
                          final color = activited == true
                              ? colorScheme.primary
                              : colorScheme.outline;
                          return TextButton.icon(
                            onPressed: onPressed,
                            icon: Icon(
                              activited == true ? activitedIcon : icon,
                              size: 16,
                              color: color,
                              semanticLabel: text,
                            ),
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              foregroundColor: colorScheme.outline,
                            ),
                            label: Text(
                                count != null ? Utils.numFormat(count) : text),
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
                                    (_htmlRenderCtr.stats.value != null
                                        ? 0
                                        : MediaQuery.of(context)
                                            .padding
                                            .bottom),
                              ),
                              child: button,
                            ),
                            _htmlRenderCtr.stats.value != null
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
                                        bottom: MediaQuery.paddingOf(context)
                                            .bottom),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Builder(
                                              builder: (btnContext) =>
                                                  actionBtn(
                                                    icon: FontAwesomeIcons
                                                        .shareFromSquare,
                                                    text: '转发',
                                                    count: _htmlRenderCtr.stats
                                                        .value!.forward?.count,
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        useSafeArea: true,
                                                        builder: (context) =>
                                                            RepostPanel(
                                                          item: _htmlRenderCtr
                                                              .item,
                                                          callback: () {
                                                            int count =
                                                                _htmlRenderCtr
                                                                        .stats
                                                                        .value!
                                                                        .forward
                                                                        ?.count ??
                                                                    0;
                                                            _htmlRenderCtr
                                                                    .stats
                                                                    .value!
                                                                    .forward
                                                                    ?.count =
                                                                count + 1;
                                                            _htmlRenderCtr.stats
                                                                .refresh();
                                                            if (btnContext
                                                                .mounted) {
                                                              (btnContext
                                                                      as Element?)
                                                                  ?.markNeedsBuild();
                                                            }
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  )),
                                        ),
                                        Expanded(
                                            child: actionBtn(
                                                icon:
                                                    FontAwesomeIcons.shareNodes,
                                                text: '分享',
                                                onPressed: () => Utils.shareText(
                                                    '${HttpString.dynamicShareBaseUrl}/${_htmlRenderCtr.oid}'))),
                                        Expanded(
                                            child: actionBtn(
                                          activitedIcon:
                                              FontAwesomeIcons.solidStar,
                                          icon: FontAwesomeIcons.star,
                                          activited: _htmlRenderCtr
                                              .stats.value!.favorite?.status,
                                          text: '收藏',
                                          count: _htmlRenderCtr
                                              .stats.value!.favorite?.count,
                                          onPressed: _htmlRenderCtr.onFav,
                                        )),
                                        Expanded(
                                          child: Builder(
                                            builder: (context) =>
                                                TextButton.icon(
                                              onPressed: () =>
                                                  RequestUtils.onLikeDynamic(
                                                _htmlRenderCtr.item,
                                                () {
                                                  if (context.mounted) {
                                                    (context as Element?)
                                                        ?.markNeedsBuild();
                                                  }
                                                },
                                              ),
                                              icon: Icon(
                                                _htmlRenderCtr.stats.value?.like
                                                            ?.status ==
                                                        true
                                                    ? FontAwesomeIcons
                                                        .solidThumbsUp
                                                    : FontAwesomeIcons.thumbsUp,
                                                size: 16,
                                                color: _htmlRenderCtr
                                                            .stats
                                                            .value
                                                            ?.like
                                                            ?.status ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                semanticLabel: _htmlRenderCtr
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
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 15, 0),
                                                foregroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                              ),
                                              label: AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                transitionBuilder:
                                                    (child, animation) =>
                                                        ScaleTransition(
                                                            scale: animation,
                                                            child: child),
                                                child: Text(
                                                  _htmlRenderCtr.stats.value
                                                              ?.like?.count !=
                                                          null
                                                      ? Utils.numFormat(
                                                          _htmlRenderCtr
                                                              .stats
                                                              .value!
                                                              .like!
                                                              .count)
                                                      : '点赞',
                                                  style: TextStyle(
                                                    color: _htmlRenderCtr
                                                                .stats
                                                                .value
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
                                  )
                                : const SizedBox.shrink(),
                          ],
                        );
                      },
                    );
            },
          ),
        ),
      );
}
