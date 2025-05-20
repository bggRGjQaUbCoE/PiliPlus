import 'dart:async';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/bangumi/info.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/widgets/bangumi_panel.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/action_item.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/action_row_item.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class BangumiIntroPanel extends StatefulWidget {
  final int? cid;
  final String heroTag;
  final Function showEpisodes;
  final Function showIntroDetail;

  const BangumiIntroPanel({
    super.key,
    this.cid,
    required this.heroTag,
    required this.showEpisodes,
    required this.showIntroDetail,
  });

  @override
  State<BangumiIntroPanel> createState() => _BangumiIntroPanelState();
}

class _BangumiIntroPanelState extends State<BangumiIntroPanel>
    with AutomaticKeepAliveClientMixin {
  late BangumiIntroController bangumiIntroController;
  late VideoDetailController videoDetailCtr;

  late final _coinKey = GlobalKey<ActionItemState>();
  late final _favKey = GlobalKey<ActionItemState>();

  bool isProcessing = false;
  Future<void> handleState(FutureOr Function() action) async {
    if (isProcessing.not) {
      isProcessing = true;
      await action();
      isProcessing = false;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    bangumiIntroController =
        Get.put(BangumiIntroController(), tag: widget.heroTag);
    videoDetailCtr = Get.find<VideoDetailController>(tag: widget.heroTag);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ThemeData theme = Theme.of(context);
    final bangumiItem = bangumiIntroController.bangumiItem;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SliverPadding(
      padding: EdgeInsets.only(
        left: StyleString.safeSpace,
        right: StyleString.safeSpace,
        top: StyleString.safeSpace,
        bottom: StyleString.safeSpace + MediaQuery.paddingOf(context).bottom,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () {
                        videoDetailCtr.onViewImage();
                        context.imageView(
                          imgList: [
                            SourceModel(
                              url: bangumiItem.cover!,
                            )
                          ],
                          onDismissed: videoDetailCtr.onDismissed,
                        );
                      },
                      child: Hero(
                        tag: bangumiItem.cover!,
                        child: NetworkImgLayer(
                          width: isLandscape ? 115 / 0.75 : 115,
                          height: isLandscape ? 115 : 115 / 0.75,
                          src: bangumiItem.cover!,
                          semanticsLabel: '封面',
                        ),
                      ),
                    ),
                    if (bangumiItem.rating != null)
                      PBadge(
                        text: '评分 ${bangumiItem.rating!['score']!}',
                        top: null,
                        right: 6,
                        bottom: 6,
                        left: null,
                      ),
                  ],
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.showIntroDetail(
                        bangumiItem, bangumiIntroController.videoTags),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      height: isLandscape ? 115 : 115 / 0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20,
                            children: [
                              Expanded(
                                child: Text(
                                  bangumiItem.title!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Obx(
                                () => FilledButton.tonal(
                                  style: FilledButton.styleFrom(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    foregroundColor:
                                        bangumiIntroController.isFollowed.value
                                            ? theme.colorScheme.outline
                                            : null,
                                    backgroundColor:
                                        bangumiIntroController.isFollowed.value
                                            ? theme.colorScheme.onInverseSurface
                                            : null,
                                  ),
                                  onPressed: bangumiIntroController
                                              .followStatus.value ==
                                          -1
                                      ? null
                                      : () {
                                          if (bangumiIntroController
                                              .isFollowed.value) {
                                            showPgcFollowDialog(
                                              context: context,
                                              type: bangumiIntroController.type,
                                              followStatus:
                                                  bangumiIntroController
                                                      .followStatus.value,
                                              onUpdateStatus: (followStatus) {
                                                if (followStatus == -1) {
                                                  bangumiIntroController
                                                      .bangumiDel();
                                                } else {
                                                  bangumiIntroController
                                                      .bangumiUpdate(
                                                          followStatus);
                                                }
                                              },
                                            );
                                          } else {
                                            bangumiIntroController.bangumiAdd();
                                          }
                                        },
                                  child: Text(
                                    bangumiIntroController.isFollowed.value
                                        ? '已${bangumiIntroController.type}'
                                        : '${bangumiIntroController.type}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 6,
                            children: [
                              StatView(
                                context: context,
                                theme: 'gray',
                                value:
                                    Utils.numFormat(bangumiItem.stat!['views']),
                              ),
                              StatDanMu(
                                context: context,
                                theme: 'gray',
                                value: Utils.numFormat(
                                    bangumiItem.stat!['danmakus']),
                              ),
                              if (isLandscape) ...[
                                areasAndPubTime(theme, bangumiItem),
                                newEpDesc(theme, bangumiItem),
                              ]
                            ],
                          ),
                          SizedBox(height: isLandscape ? 2 : 6),
                          if (!isLandscape) ...[
                            areasAndPubTime(theme, bangumiItem),
                            newEpDesc(theme, bangumiItem),
                          ],
                          const Spacer(),
                          Text(
                            '简介：${bangumiItem.evaluate!}',
                            maxLines: isLandscape ? 2 : 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // 点赞收藏转发 布局样式2
            actionGrid(theme, bangumiItem, bangumiIntroController),
            // 番剧分p
            if (bangumiItem.episodes!.isNotEmpty) ...[
              BangumiPanel(
                heroTag: widget.heroTag,
                pages: bangumiItem.episodes!,
                cid: videoDetailCtr.cid.value,
                changeFuc: bangumiIntroController.changeSeasonOrbangu,
                showEpisodes: widget.showEpisodes,
                newEp: bangumiItem.newEp,
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget actionGrid(ThemeData theme, BangumiInfoModel bangumiItem,
      BangumiIntroController bangumiIntroController) {
    return Material(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Obx(
                () => ActionItem(
                  icon: const Icon(FontAwesomeIcons.thumbsUp),
                  selectIcon: const Icon(FontAwesomeIcons.solidThumbsUp),
                  onTap: () =>
                      handleState(bangumiIntroController.actionLikeVideo),
                  onLongPress: bangumiIntroController.actionOneThree,
                  selectStatus: bangumiIntroController.hasLike.value,
                  isLoading: false,
                  semanticsLabel: '点赞',
                  text: Utils.numFormat(bangumiItem.stat!['likes']!),
                  needAnim: true,
                  hasTriple: bangumiIntroController.hasLike.value &&
                      bangumiIntroController.hasCoin &&
                      bangumiIntroController.hasFav.value,
                  callBack: (start) {
                    if (start) {
                      HapticFeedback.lightImpact();
                      _coinKey.currentState?.controller?.forward();
                      _favKey.currentState?.controller?.forward();
                    } else {
                      _coinKey.currentState?.controller?.reverse();
                      _favKey.currentState?.controller?.reverse();
                    }
                  },
                ),
              ),
              Obx(
                () => ActionItem(
                  key: _coinKey,
                  icon: const Icon(FontAwesomeIcons.b),
                  selectIcon: const Icon(FontAwesomeIcons.b),
                  onTap: () =>
                      handleState(bangumiIntroController.actionCoinVideo),
                  selectStatus: bangumiIntroController.hasCoin,
                  isLoading: false,
                  semanticsLabel: '投币',
                  text: Utils.numFormat(bangumiItem.stat!['coins']!),
                  needAnim: true,
                ),
              ),
              Obx(
                () => ActionItem(
                  key: _favKey,
                  icon: const Icon(FontAwesomeIcons.star),
                  selectIcon: const Icon(FontAwesomeIcons.solidStar),
                  onTap: () =>
                      bangumiIntroController.showFavBottomSheet(context),
                  onLongPress: () => bangumiIntroController
                      .showFavBottomSheet(context, type: 'longPress'),
                  selectStatus: bangumiIntroController.hasFav.value,
                  isLoading: false,
                  semanticsLabel: '收藏',
                  text: Utils.numFormat(bangumiItem.stat!['favorite']!),
                  needAnim: true,
                ),
              ),
              ActionItem(
                icon: const Icon(FontAwesomeIcons.comment),
                selectIcon: const Icon(FontAwesomeIcons.reply),
                onTap: () => videoDetailCtr.tabCtr.animateTo(1),
                selectStatus: false,
                isLoading: false,
                semanticsLabel: '评论',
                text: Utils.numFormat(bangumiItem.stat!['reply']!),
              ),
              ActionItem(
                icon: const Icon(FontAwesomeIcons.shareFromSquare),
                onTap: () => bangumiIntroController.actionShareVideo(context),
                selectStatus: false,
                isLoading: false,
                semanticsLabel: '转发',
                text: Utils.numFormat(bangumiItem.stat!['share']!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionRow(
    BangumiInfoModel bangumiItem,
    BangumiIntroController bangumiIntroController,
    VideoDetailController videoDetailCtr,
  ) {
    return Row(
      spacing: 8,
      children: [
        Obx(
          () => ActionRowItem(
            icon: const Icon(FontAwesomeIcons.thumbsUp),
            onTap: () => handleState(bangumiIntroController.actionLikeVideo),
            selectStatus: bangumiIntroController.hasLike.value,
            isLoading: false,
            text: bangumiItem.stat!['likes']!.toString(),
          ),
        ),
        Obx(
          () => ActionRowItem(
            icon: const Icon(FontAwesomeIcons.b),
            onTap: () => handleState(bangumiIntroController.actionCoinVideo),
            selectStatus: bangumiIntroController.hasCoin,
            isLoading: false,
            text: bangumiItem.stat!['coins']!.toString(),
          ),
        ),
        Obx(
          () => ActionRowItem(
            icon: const Icon(FontAwesomeIcons.heart),
            onTap: () => bangumiIntroController.showFavBottomSheet(context),
            onLongPress: () => bangumiIntroController
                .showFavBottomSheet(context, type: 'longPress'),
            selectStatus: bangumiIntroController.hasFav.value,
            isLoading: false,
            text: bangumiItem.stat!['favorite']!.toString(),
          ),
        ),
        ActionRowItem(
          icon: const Icon(FontAwesomeIcons.comment),
          onTap: () {
            videoDetailCtr.tabCtr.animateTo(1);
          },
          selectStatus: false,
          isLoading: false,
          text: bangumiItem.stat!['reply']!.toString(),
        ),
        ActionRowItem(
          icon: const Icon(FontAwesomeIcons.share),
          onTap: () => bangumiIntroController.actionShareVideo(context),
          selectStatus: false,
          isLoading: false,
          text: '转发',
        ),
      ],
    );
  }

  Widget areasAndPubTime(ThemeData theme, BangumiInfoModel bangumiItem) {
    return Row(
      spacing: 6,
      children: [
        Text(
          (bangumiItem.areas!.isNotEmpty
              ? bangumiItem.areas!.first['name']
              : ''),
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.outline,
          ),
        ),
        Text(
          bangumiItem.publish!['pub_time_show'],
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget newEpDesc(ThemeData theme, BangumiInfoModel bangumiItem) {
    return Text(
      bangumiItem.newEp!['desc'],
      style: TextStyle(
        fontSize: 12,
        color: theme.colorScheme.outline,
      ),
    );
  }
}
