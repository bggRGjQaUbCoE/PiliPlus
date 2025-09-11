import 'dart:math';

import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart' show DynamicStat;
import 'package:PiliPlus/pages/article/controller.dart';
import 'package:PiliPlus/pages/article/widgets/article_ops.dart';
import 'package:PiliPlus/pages/article/widgets/html_render.dart';
import 'package:PiliPlus/pages/article/widgets/opus_content.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_page.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:html/parser.dart' as parser;

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends CommonDynPageState<ArticlePage> {
  @override
  final ArticleController controller = Get.putOrFind(
    ArticleController.new,
    tag: Get.parameters['type']! + Get.parameters['id']!,
  );

  @override
  dynamic get arguments => {
    'id': controller.id,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        controller.showTitle.value =
            scrollController.positions.last.pixels >= 45;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildPage(theme),
            _buildBottom(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(ThemeData theme) {
    double padding = max(maxWidth / 2 - Grid.smallCardWidth, 0);
    if (isPortrait) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildContent(
              theme,
              maxWidth - this.padding.horizontal - 2 * padding - 24,
            ),
            SliverToBoxAdapter(
              child: Divider(
                thickness: 8,
                color: theme.dividerColor.withValues(alpha: 0.05),
              ),
            ),
            buildReplyHeader(theme),
            Obx(() => _buildReplyList(theme, controller.loadingState.value)),
          ],
        ),
      );
    }

    padding = padding / 4;
    final flex = controller.ratio[0].toInt();
    final flex1 = controller.ratio[1].toInt();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: flex,
          child: CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  left: padding,
                  bottom: this.padding.bottom + 100,
                ),
                sliver: _buildContent(
                  theme,
                  (maxWidth - this.padding.horizontal) * flex / (flex + flex1) -
                      padding -
                      32,
                ),
              ),
            ],
          ),
        ),
        VerticalDivider(
          thickness: 8,
          color: theme.dividerColor.withValues(alpha: 0.05),
        ),
        Expanded(
          flex: flex1,
          child: Padding(
            padding: EdgeInsets.only(right: padding),
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: refreshIndicator(
                onRefresh: controller.onRefresh,
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    buildReplyHeader(theme),
                    Obx(
                      () =>
                          _buildReplyList(theme, controller.loadingState.value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme, double maxWidth) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    sliver: Obx(
      () {
        if (controller.isLoaded.value) {
          late Widget content;
          if (controller.opus != null) {
            // if (kDebugMode) debugPrint('json page');
            content = OpusContent(
              opus: controller.opus!,
              callback: imageCallback,
              maxWidth: maxWidth,
            );
          } else if (controller.opusData?.modules.moduleBlocked != null) {
            // if (kDebugMode) debugPrint('moduleBlocked');
            final moduleBlocked = controller.opusData!.modules.moduleBlocked!;
            content = SliverToBoxAdapter(
              child: moduleBlockedItem(theme, moduleBlocked, maxWidth),
            );
          } else if (controller.articleData?.content != null) {
            if (controller.articleData?.type == 3) {
              // json
              return ArticleOpus(ops: controller.articleData?.ops);
            }
            // if (kDebugMode) debugPrint('html page');
            final res = parser.parse(controller.articleData!.content!);
            if (res.body!.children.isEmpty) {
              content = SliverToBoxAdapter(
                child: htmlRender(
                  context: context,
                  html: controller.articleData!.content!,
                  maxWidth: maxWidth,
                  callback: imageCallback,
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
                    callback: imageCallback,
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
              controller.opusData?.modules.moduleAuthor?.pubTs ??
              controller.articleData?.publishTime;
          return SliverMainAxisGroup(
            slivers: [
              if (controller.type != 'read' &&
                  controller
                          .opusData
                          ?.modules
                          .moduleTop
                          ?.display
                          ?.album
                          ?.pics
                          ?.isNotEmpty ==
                      true)
                SliverToBoxAdapter(
                  child: Builder(
                    builder: (context) {
                      final pics = controller
                          .opusData!
                          .modules
                          .moduleTop!
                          .display!
                          .album!
                          .pics!;
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
                                controller.topIndex.value = value;
                              },
                              itemCount: length,
                              itemBuilder: (context, index) {
                                final pic = pics[index];
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => PageUtils.imageView(
                                    quality: 60,
                                    imgList: pics
                                        .map((e) => SourceModel(url: e.url!))
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
                                            imageUrl: ImageUtils.thumbnailUrl(
                                              pic.url,
                                              60,
                                            ),
                                            fadeInDuration: const Duration(
                                              milliseconds: 120,
                                            ),
                                            fadeOutDuration: const Duration(
                                              milliseconds: 120,
                                            ),
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
                              text: '${controller.topIndex.value + 1}/$length',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              if (controller.summary.title != null)
                SliverToBoxAdapter(
                  child: Text(
                    controller.summary.title!,
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
                      '/member?mid=${controller.summary.author?.mid}',
                    ),
                    child: Row(
                      children: [
                        NetworkImgLayer(
                          width: 40,
                          height: 40,
                          type: ImageType.avatar,
                          src: controller.summary.author?.face,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.summary.author?.name ?? '',
                              style: TextStyle(
                                fontSize: theme.textTheme.titleSmall!.fontSize,
                              ),
                            ),
                            if (pubTime != null)
                              Text(
                                DateFormatUtils.format(pubTime),
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
              if (controller.type != 'read' &&
                  controller.opusData?.modules.moduleCollection != null)
                SliverToBoxAdapter(
                  child: opusCollection(
                    theme,
                    controller.opusData!.modules.moduleCollection!,
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
                        controller.commentId,
                        controller.commentType,
                      ),
                    );
                  }
                },
              )
            : HttpError(onReload: controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: controller.isLoaded.value ? controller.onReload : null,
      ),
    };
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    title: Obx(() {
      if (controller.isLoaded.value && controller.showTitle.value) {
        return Text(controller.summary.title ?? '');
      }
      return const SizedBox.shrink();
    }),
    actions: [
      const SizedBox(width: 4),
      if (!isPortrait) ratioWidget(maxWidth),
      IconButton(
        tooltip: '浏览器打开',
        onPressed: () => PageUtils.inAppWebview(controller.url),
        icon: const Icon(Icons.open_in_browser_outlined, size: 19),
      ),
      PopupMenuButton(
        icon: const Icon(Icons.more_vert, size: 19),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            onTap: () => Utils.shareText(controller.url),
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
            onTap: () => Utils.copyText(controller.url),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.copy_rounded, size: 19),
                SizedBox(width: 10),
                Text('复制链接'),
              ],
            ),
          ),
          if (controller.commentType == 12 &&
              controller.stats.value != null &&
              controller.opusData?.modules.moduleBlocked == null)
            PopupMenuItem(
              onTap: () async {
                final summary = controller.summary;
                try {
                  if (summary.cover == null) {
                    if (!await controller.getArticleInfo(true)) {
                      return;
                    }
                  }
                  if (mounted) {
                    PageUtils.pmShare(
                      this.context,
                      content: {
                        "id": controller.commentId,
                        "title": "- 哔哩哔哩专栏",
                        "headline": summary.title!, // throw
                        "source": 6,
                        "thumb": summary.cover!,
                        "author": summary.author!.name,
                        "author_id": summary.author!.mid.toString(),
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
      const SizedBox(width: 6),
    ],
  );

  Widget _buildBottom(ThemeData theme) => Positioned(
    left: 0,
    bottom: 0,
    right: 0,
    child: SlideTransition(
      position: fabAnim,
      child: Builder(
        builder: (context) {
          if (!controller.showDynActionBar) {
            return Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 14,
                  bottom: padding.bottom + 14,
                ),
                child: replyButton,
              ),
            );
          }

          late final primary = theme.colorScheme.primary;
          late final outline = theme.colorScheme.outline;
          late final btnStyle = TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            foregroundColor: outline,
          );

          Widget textIconButton({
            required IconData icon,
            required String text,
            required DynamicStat? stat,
            required VoidCallback onPressed,
            IconData? activitedIcon,
          }) {
            final status = stat?.status == true;
            final color = status ? primary : outline;
            return TextButton.icon(
              onPressed: onPressed,
              icon: Icon(
                status ? activitedIcon : icon,
                size: 16,
                color: color,
              ),
              style: btnStyle,
              label: Text(
                stat?.count != null ? NumUtils.numFormat(stat!.count) : text,
                style: TextStyle(color: color),
              ),
            );
          }

          return Obx(() {
            final stats = controller.stats.value;

            Widget btn = Padding(
              padding: EdgeInsets.only(
                right: 14,
                bottom: 14 + (stats != null ? 0 : padding.bottom),
              ),
              child: replyButton,
            );

            if (stats == null) {
              return Align(
                alignment: Alignment.centerRight,
                child: btn,
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                btn,
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.outline.withValues(
                          alpha: 0.08,
                        ),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: padding.bottom),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (btnContext) {
                            final forward = stats.forward;
                            return textIconButton(
                              text: '转发',
                              icon: FontAwesomeIcons.shareFromSquare,
                              stat: forward,
                              onPressed: () {
                                if (controller.opusData == null &&
                                    controller.articleData?.dynIdStr == null) {
                                  SmartDialog.showToast(
                                    'err: ${controller.id}',
                                  );
                                  return;
                                }
                                final summary = controller.summary;
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (context) => RepostPanel(
                                    item: controller.opusData,
                                    dynIdStr: controller.articleData?.dynIdStr,
                                    pic: summary.cover,
                                    title: summary.title,
                                    uname: summary.author?.name,
                                    callback: () {
                                      if (forward != null) {
                                        int count = forward.count ?? 0;
                                        forward.count = count + 1;
                                        if (btnContext.mounted) {
                                          (btnContext as Element?)
                                              ?.markNeedsBuild();
                                        }
                                      }
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: textIconButton(
                          text: '分享',
                          icon: CustomIcon.share_node,
                          stat: null,
                          onPressed: () => Utils.shareText(controller.url),
                        ),
                      ),
                      Expanded(
                        child: textIconButton(
                          icon: FontAwesomeIcons.star,
                          activitedIcon: FontAwesomeIcons.solidStar,
                          text: '收藏',
                          stat: stats.favorite,
                          onPressed: controller.onFav,
                        ),
                      ),
                      Expanded(
                        child: textIconButton(
                          icon: FontAwesomeIcons.thumbsUp,
                          activitedIcon: FontAwesomeIcons.solidThumbsUp,
                          text: '点赞',
                          stat: stats.like,
                          onPressed: controller.onLike,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
        },
      ),
    ),
  );
}
