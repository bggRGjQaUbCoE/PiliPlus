import 'dart:async';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/widgets/pgc_panel.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/action_item.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/num_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PgcIntroPage extends StatefulWidget {
  final int? cid;
  final String heroTag;
  final Function showEpisodes;
  final Function showIntroDetail;

  const PgcIntroPage({
    super.key,
    this.cid,
    required this.heroTag,
    required this.showEpisodes,
    required this.showIntroDetail,
  });

  @override
  State<PgcIntroPage> createState() => _PgcIntroPageState();
}

class _PgcIntroPageState extends State<PgcIntroPage>
    with AutomaticKeepAliveClientMixin {
  late PgcIntroController pgcIntroController;
  late VideoDetailController videoDetailCtr;

  late final _coinKey = GlobalKey<ActionItemState>();
  late final _favKey = GlobalKey<ActionItemState>();

  bool isProcessing = false;
  Future<void> handleState(FutureOr Function() action) async {
    if (!isProcessing) {
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
    pgcIntroController = Get.put(PgcIntroController(), tag: widget.heroTag);
    videoDetailCtr = Get.find<VideoDetailController>(tag: widget.heroTag);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ThemeData theme = Theme.of(context);
    final item = pgcIntroController.pgcItem;
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
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
                              url: item.cover!,
                            ),
                          ],
                          onDismissed: videoDetailCtr.onDismissed,
                        );
                      },
                      child: Hero(
                        tag: item.cover!,
                        child: NetworkImgLayer(
                          width: isLandscape ? 115 / 0.75 : 115,
                          height: isLandscape ? 115 : 115 / 0.75,
                          src: item.cover!,
                          semanticsLabel: '封面',
                        ),
                      ),
                    ),
                    if (item.rating != null)
                      PBadge(
                        text: '评分 ${item.rating!.score!}',
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
                      item,
                      pgcIntroController.videoTags.value,
                    ),
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
                                  item.title!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Obx(
                                () {
                                  final isFollowed =
                                      pgcIntroController.isFollowed.value;
                                  final followStatus =
                                      pgcIntroController.followStatus.value;
                                  return FilledButton.tonal(
                                    style: FilledButton.styleFrom(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                      foregroundColor: isFollowed
                                          ? theme.colorScheme.outline
                                          : null,
                                      backgroundColor: isFollowed
                                          ? theme.colorScheme.onInverseSurface
                                          : null,
                                    ),
                                    onPressed: followStatus == -1
                                        ? null
                                        : () {
                                            if (isFollowed) {
                                              showPgcFollowDialog(
                                                context: context,
                                                type:
                                                    pgcIntroController.pgcType,
                                                followStatus: followStatus,
                                                onUpdateStatus: (followStatus) {
                                                  if (followStatus == -1) {
                                                    pgcIntroController.pgcDel();
                                                  } else {
                                                    pgcIntroController
                                                        .pgcUpdate(
                                                          followStatus,
                                                        );
                                                  }
                                                },
                                              );
                                            } else {
                                              pgcIntroController.pgcAdd();
                                            }
                                          },
                                    child: Text(
                                      isFollowed
                                          ? '已${pgcIntroController.pgcType}'
                                          : pgcIntroController.pgcType,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            spacing: 6,
                            children: [
                              StatWidget(
                                type: StatType.play,
                                value: item.stat!.view,
                              ),
                              StatWidget(
                                type: StatType.danmaku,
                                value: item.stat!.danmaku,
                              ),
                              if (isLandscape) ...[
                                areasAndPubTime(theme, item),
                                newEpDesc(theme, item),
                              ],
                            ],
                          ),
                          SizedBox(height: isLandscape ? 2 : 6),
                          if (!isLandscape) ...[
                            areasAndPubTime(theme, item),
                            newEpDesc(theme, item),
                          ],
                          const Spacer(),
                          Text(
                            '简介：${item.evaluate!}',
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
            actionGrid(theme, item, pgcIntroController),
            // 番剧分p
            if (item.episodes!.isNotEmpty) ...[
              PgcPanel(
                heroTag: widget.heroTag,
                pages: item.episodes!,
                cid: videoDetailCtr.cid.value,
                changeFuc: pgcIntroController.changeSeasonOrbangu,
                showEpisodes: widget.showEpisodes,
                newEp: item.newEp,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget actionGrid(
    ThemeData theme,
    PgcInfoModel item,
    PgcIntroController pgcIntroController,
  ) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Obx(
            () => ActionItem(
              icon: const Icon(FontAwesomeIcons.thumbsUp),
              selectIcon: const Icon(FontAwesomeIcons.solidThumbsUp),
              onTap: () => handleState(pgcIntroController.actionLikeVideo),
              onLongPress: pgcIntroController.actionOneThree,
              selectStatus: pgcIntroController.hasLike.value,
              semanticsLabel: '点赞',
              text: NumUtil.numFormat(item.stat!.like),
              needAnim: true,
              hasTriple:
                  pgcIntroController.hasLike.value &&
                  pgcIntroController.hasCoin &&
                  pgcIntroController.hasFav.value,
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
              onTap: () => handleState(pgcIntroController.actionCoinVideo),
              selectStatus: pgcIntroController.hasCoin,
              semanticsLabel: '投币',
              text: NumUtil.numFormat(item.stat!.coin),
              needAnim: true,
            ),
          ),
          Obx(
            () => ActionItem(
              key: _favKey,
              icon: const Icon(FontAwesomeIcons.star),
              selectIcon: const Icon(FontAwesomeIcons.solidStar),
              onTap: () => pgcIntroController.showFavBottomSheet(context),
              onLongPress: () => pgcIntroController.showFavBottomSheet(
                context,
                isLongPress: true,
              ),
              selectStatus: pgcIntroController.hasFav.value,
              semanticsLabel: '收藏',
              text: NumUtil.numFormat(item.stat!.favorite),
              needAnim: true,
            ),
          ),
          ActionItem(
            icon: const Icon(FontAwesomeIcons.comment),
            selectIcon: const Icon(FontAwesomeIcons.reply),
            onTap: () => videoDetailCtr.tabCtr.animateTo(1),
            selectStatus: false,
            semanticsLabel: '评论',
            text: NumUtil.numFormat(item.stat!.reply),
          ),
          ActionItem(
            icon: const Icon(FontAwesomeIcons.shareFromSquare),
            onTap: () => pgcIntroController.actionShareVideo(context),
            selectStatus: false,
            semanticsLabel: '转发',
            text: NumUtil.numFormat(item.stat!.share),
          ),
        ],
      ),
    );
  }

  Widget areasAndPubTime(ThemeData theme, PgcInfoModel item) {
    return Row(
      spacing: 6,
      children: [
        if (item.areas?.isNotEmpty == true)
          Text(
            item.areas!.first.name!,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.outline,
            ),
          ),
        Text(
          item.publish!.pubTimeShow!,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget newEpDesc(ThemeData theme, PgcInfoModel item) {
    return Text(
      item.newEp!.desc!,
      style: TextStyle(
        fontSize: 12,
        color: theme.colorScheme.outline,
      ),
    );
  }
}
