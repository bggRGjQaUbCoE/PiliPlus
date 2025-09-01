import 'dart:math';

import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/marquee.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/music.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/music/bgm_detail.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_page.dart';
import 'package:PiliPlus/pages/music/controller.dart';
import 'package:PiliPlus/pages/music/video/view.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/date_util.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/num_util.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class MusicDetailPage extends StatefulWidget {
  const MusicDetailPage({super.key});

  @override
  State<MusicDetailPage> createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends CommonDynPageState<MusicDetailPage> {
  @override
  late final MusicDetailController controller = Get.putOrFind(
    MusicDetailController.new,
    tag: Get.parameters['musicId']!,
  );

  @override
  dynamic get arguments => null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: isPortrait
            ? refreshIndicator(
                onRefresh: controller.onRefresh,
                child: _buildBody(theme),
              )
            : _buildBody(theme),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    title: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Obx(
        () {
          final info = controller.infoState.value;
          late final showTitle = controller.showTitle.value;
          return info.isSuccess
              ? AnimatedOpacity(
                  opacity: showTitle ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: !showTitle,
                    child: Row(
                      spacing: 8,
                      children: [
                        NetworkImgLayer(
                          src: info.data.mvCover,
                          width: 36,
                          height: 36,
                          type: ImageType.avatar,
                        ),
                        Text(info.data.musicTitle!),
                      ],
                    ),
                  ),
                )
              : const SizedBox(height: 40);
        },
      ),
    ),
    actions: isPortrait
        ? null
        : [
            ratioWidget(maxWidth),
            const SizedBox(width: 16),
          ],
  );

  Widget _buildBody(ThemeData theme) => Obx(() {
    switch (controller.infoState.value) {
      case Success(:final response):
        double padding = max(maxWidth / 2 - Grid.smallCardWidth, 0);
        final Widget child;
        if (isPortrait) {
          child = Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildCard(theme, response, maxWidth),
                ),
                SliverToBoxAdapter(
                  child: _buildChart(theme, response, maxWidth),
                ),
                buildReplyHeader(theme),
                Obx(() => replyList(theme, controller.loadingState.value)),
              ],
            ),
          );
        } else {
          padding = padding / 4;
          final flex = controller.ratio[0].toInt();
          final flex1 = controller.ratio[1].toInt();
          final leftWidth =
              (maxWidth - this.padding.horizontal) * (flex / (flex + flex1)) -
              padding;
          child = Row(
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
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildCard(theme, response, leftWidth),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: padding,
                        bottom: this.padding.bottom + 100,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildChart(theme, response, leftWidth),
                      ),
                    ),
                  ],
                ),
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
                        controller: controller
                            .scrollController, // debug: The provided ScrollController is attached to more than one ScrollPosition.
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          buildReplyHeader(theme),
                          Obx(
                            () =>
                                replyList(theme, controller.loadingState.value),
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
        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            _buildBottom(theme, response),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  });

  Widget _buildBottom(ThemeData theme, MusicDetail item) {
    final outline = theme.colorScheme.outline;

    Widget textIconButton({
      required IconData icon,
      required String text,
      int? count,
      bool status = false,
      required VoidCallback onPressed,
      IconData? activitedIcon,
    }) {
      final color = status ? theme.colorScheme.primary : outline;
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(
          status ? activitedIcon : icon,
          size: 16,
          color: color,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          foregroundColor: outline,
        ),
        label: Text(
          count != null ? NumUtil.numFormat(count) : text,
          style: TextStyle(color: color),
        ),
      );
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SlideTransition(
        position: fabAnim,
        child: controller.showDynActionBar
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 14, bottom: 14),
                    child: replyButton,
                  ),
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
                        // TODO
                        // Expanded(
                        //   child: textIconButton(
                        //     icon: FontAwesomeIcons.shareFromSquare,
                        //     text: '转发',
                        //     count: item.musicShares,
                        //     onPressed: () {
                        //       final data = controller.infoState.value.dataOrNull;
                        //       if (data != null) {
                        //         showModalBottomSheet(
                        //           context: context,
                        //           isScrollControlled: true,
                        //           useSafeArea: true,
                        //           builder: (context) => RepostPanel(
                        //             rid: controller.oid,
                        //             dynType: null,
                        //             pic: data.mvCover,
                        //             title: data.musicTitle,
                        //           ),
                        //         );
                        //       }
                        //     },
                        //   ),
                        // ),
                        Expanded(
                          child: textIconButton(
                            icon: CustomIcon.share_node,
                            text: '分享',
                            onPressed: () =>
                                Utils.shareText(controller.shareUrl),
                          ),
                        ),
                        Expanded(
                          child: Builder(
                            builder: (context) => textIconButton(
                              icon: FontAwesomeIcons.thumbsUp,
                              activitedIcon: FontAwesomeIcons.solidThumbsUp,
                              text: '点赞',
                              count: item.wishCount,
                              status: item.wishListen ?? false,
                              onPressed: () async {
                                if (!Accounts.main.isLogin) {
                                  SmartDialog.showToast('请先登录');
                                  return;
                                }
                                final hasLike = item.wishListen ?? false;
                                final res = await MusicHttp.wishUpdate(
                                  controller.musicId,
                                  hasLike,
                                );
                                if (res.isSuccess) {
                                  if (hasLike) {
                                    item.wishCount--;
                                  } else {
                                    item.wishCount++;
                                  }
                                  item.wishListen = !hasLike;
                                  if (context.mounted) {
                                    (context as Element).markNeedsBuild();
                                  }
                                } else {
                                  res.toast();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 14,
                    bottom: padding.bottom + 14,
                  ),
                  child: replyButton,
                ),
              ),
      ),
    );
  }

  Widget _buildArtist(Artist artist, TextStyle? style) {
    Widget child = Text('${artist.identity}: ${artist.name}', style: style);
    if (!artist.face.isNullOrEmpty) {
      child = Row(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        children: [
          NetworkImgLayer(
            src: artist.face,
            width: 15,
            height: 15,
            type: ImageType.avatar,
          ),
          child,
        ],
      );
    }
    child = GestureDetector(
      onTap: artist.mid == null || artist.mid == 0
          ? () => Utils.copyText(artist.name!)
          : () => Get.toNamed(
              '/member',
              parameters: {'mid': artist.mid!.toString()},
            ),
      child: child,
    );
    return child;
  }

  Widget _buildRank(
    int? rank,
    String name,
    ThemeData theme, [
    VoidCallback? onTap,
  ]) {
    final outline = theme.colorScheme.outline;
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(NumUtil.numFormat(rank)),
        Text(
          name,
          style: theme.textTheme.bodySmall!.copyWith(color: outline),
        ),
      ],
    );
    return onTap == null
        ? child
        : InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                  Icon(
                    size: 18,
                    color: outline,
                    Icons.keyboard_arrow_right,
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildCard(ThemeData theme, MusicDetail item, double maxWidth) {
    final textTheme = theme.textTheme;
    return SizedBox(
      width: maxWidth,
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => PageUtils.imageView(
                      imgList: [SourceModel(url: item.mvCover!)],
                    ),
                    child: Hero(
                      tag: item.mvCover!,
                      child: NetworkImgLayer(
                        src: item.mvCover,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 2,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          // TODO: android intent ACTION_MEDIA_SEARCH
                          onTap: () => Utils.copyText(
                            item.musicTitle!,
                          ),
                          behavior: HitTestBehavior.opaque,
                          child: MarqueeText(
                            item.musicTitle!,
                            spacing: 30,
                            style: textTheme.titleMedium,
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 2,
                          children: [
                            if (!item.artistsList.isNullOrEmpty)
                              for (var artist in item.artistsList!)
                                _buildArtist(artist, textTheme.bodySmall),
                            if (!item.musicPublish.isNullOrEmpty)
                              Text(
                                '发行日期：${item.musicPublish}',
                                style: textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Wrap(
                          spacing: 16,
                          children: [
                            if (!item.musicRank.isNullOrEmpty)
                              PBadge(
                                text: item.musicRank,
                                type: PBadgeType.secondary,
                                isStack: false,
                                fontSize: 11,
                              ),
                            if (item.mvCid != null && item.mvCid != 0)
                              GestureDetector(
                                onTap: () => PageUtils.toVideoPage(
                                  bvid: item.mvBvid,
                                  cid: item.mvCid!,
                                  aid: item.mvAid,
                                ),
                                child: ColoredBox(
                                  color: theme.colorScheme.secondaryContainer
                                      .withValues(alpha: 0.5),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 3,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.play_circle_outline,
                                          size: 11,
                                          color: theme
                                              .colorScheme
                                              .onSecondaryContainer,
                                        ),
                                        Text(
                                          '看MV',
                                          style: TextStyle(
                                            color: theme
                                                .colorScheme
                                                .onSecondaryContainer,
                                            height: 1,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          strutStyle: const StrutStyle(
                                            leading: 0,
                                            height: 1,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SelectableText(
                [
                  if (!(item.originArtist ?? item.originArtistList)
                      .isNullOrEmpty)
                    '原唱：${item.originArtist ?? item.originArtistList}',
                  if (!item.album.isNullOrEmpty) '专辑：${item.album}',
                  if (!item.musicSource.isNullOrEmpty) '出处：${item.musicSource}',
                ].join('\n'),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('热歌榜排名'),
                  _buildRank(item.hotSongHeat?.lastHeat, '热度', theme),
                  _buildRank(item.listenPv, '总播放量', theme),
                  _buildRank(
                    item.musicRelation,
                    '使用稿件量',
                    theme,
                    () => Get.to(
                      const MusicRecommandPage(),
                      arguments: (id: controller.musicId, item: item),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildChart(ThemeData theme, MusicDetail item, double maxWidth) {
    final heat = item.hotSongHeat?.songHeat;
    if (heat == null || heat.isEmpty) return null;
    final colorScheme = theme.colorScheme;
    int maxHeat = heat.first.heat;
    int minHeat = heat.first.heat;
    for (int i = 1; i < heat.length; i++) {
      final h = heat[i].heat;
      if (h > maxHeat) maxHeat = h;
      if (h < minHeat) minHeat = h;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        spacing: 8,
        children: [
          Text('近${heat.length}日热度趋势', style: theme.textTheme.titleMedium),
          SizedBox(
            width: maxWidth,
            height: maxWidth * 0.5,
            child: Padding(
              padding: const EdgeInsetsGeometry.only(top: 4, right: 22),
              child: LineChart(
                LineChartData(
                  lineTouchData: const LineTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 55,
                        showTitles: true,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30 * sqrt2,
                        getTitlesWidget: (index, meta) {
                          return SideTitleWidget(
                            angle: -pi / 4,
                            space: 8 * sqrt2,
                            meta: meta,
                            child: Text(
                              DateUtil.shortFormat.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  heat[index.toInt()].date * 1000,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: colorScheme.onSurface),
                  ),
                  minX: 0,
                  maxX: (heat.length - 1).toDouble(),
                  minY: minHeat.toDouble(),
                  maxY: maxHeat.toDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        heat.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          heat[index].heat.toDouble(),
                        ),
                      ),
                      color: colorScheme.primary,
                      barWidth: 1,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.5),
                            colorScheme.onPrimary.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
