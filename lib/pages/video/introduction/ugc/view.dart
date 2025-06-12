import 'dart:async';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/action_item.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/action_row_item.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/page.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/season.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VideoIntroPanel extends StatefulWidget {
  const VideoIntroPanel({
    super.key,
    required this.heroTag,
    required this.showAiBottomSheet,
    required this.showEpisodes,
    required this.onShowMemberPage,
  });
  final String heroTag;
  final Function showAiBottomSheet;
  final Function showEpisodes;
  final ValueChanged<int?> onShowMemberPage;

  @override
  State<VideoIntroPanel> createState() => _VideoIntroPanelState();
}

class _VideoIntroPanelState extends State<VideoIntroPanel>
    with AutomaticKeepAliveClientMixin {
  late VideoIntroController videoIntroController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    videoIntroController = Get.put(VideoIntroController(), tag: widget.heroTag)
      ..heroTag = widget.heroTag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => videoIntroController.videoDetail.value.title == null
          ? VideoInfo(
              isLoading: true,
              videoIntroController: videoIntroController,
              heroTag: widget.heroTag,
              showAiBottomSheet: widget.showAiBottomSheet,
              showEpisodes: widget.showEpisodes,
              onShowMemberPage: widget.onShowMemberPage,
            )
          : VideoInfo(
              key: ValueKey(widget.heroTag),
              isLoading: false,
              videoIntroController: videoIntroController,
              heroTag: widget.heroTag,
              showAiBottomSheet: widget.showAiBottomSheet,
              showEpisodes: widget.showEpisodes,
              onShowMemberPage: widget.onShowMemberPage,
            ),
    );
  }
}

class VideoInfo extends StatefulWidget {
  final bool isLoading;
  final String heroTag;
  final Function showAiBottomSheet;
  final Function showEpisodes;
  final ValueChanged<int?> onShowMemberPage;
  final VideoIntroController videoIntroController;

  const VideoInfo({
    super.key,
    this.isLoading = false,
    required this.heroTag,
    required this.showAiBottomSheet,
    required this.showEpisodes,
    required this.onShowMemberPage,
    required this.videoIntroController,
  });

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  late final VideoDetailController videoDetailCtr;

  Map get videoItem => videoIntroController.videoItem;
  VideoIntroController get videoIntroController => widget.videoIntroController;
  VideoDetailData get videoDetail =>
      widget.videoIntroController.videoDetail.value;

  late final _coinKey = GlobalKey<ActionItemState>();
  late final _favKey = GlobalKey<ActionItemState>();

  bool isProcessing = false;

  late final _horizontalMemberPage = GStorage.horizontalMemberPage;

  Widget _buildVideoTitle(ThemeData theme, [bool isExpand = false]) =>
      videoDetailCtr.plPlayerController.enableSponsorBlock
          ? Obx(
              () => Text.rich(
                TextSpan(
                  children: [
                    if (videoDetailCtr.videoLabel.value.isNotEmpty) ...[
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.shield_outlined,
                                    size: 16,
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                  ),
                                  Icon(
                                    Icons.play_arrow_rounded,
                                    size: 12,
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                  ),
                                ],
                              ),
                              Text(
                                videoDetailCtr.videoLabel.value,
                                textScaler: TextScaler.noScaling,
                                strutStyle:
                                    const StrutStyle(leading: 0, height: 1),
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 13,
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const TextSpan(text: ' '),
                    ],
                    TextSpan(
                        text:
                            '${videoDetail.title ?? videoItem['title'] ?? ''}'),
                  ],
                ),
                maxLines: isExpand ? null : 2,
                overflow: isExpand ? null : TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
            )
          : Text(
              '${videoDetail.title ?? videoItem['title'] ?? ''}',
              maxLines: isExpand ? null : 2,
              overflow: isExpand ? null : TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            );

  Future<void> handleState(FutureOr Function() action) async {
    if (!isProcessing) {
      isProcessing = true;
      await action();
      isProcessing = false;
    }
  }

  @override
  void initState() {
    super.initState();

    videoDetailCtr = Get.find<VideoDetailController>(tag: widget.heroTag);

    if (videoIntroController.expandableCtr == null) {
      bool alwaysExapndIntroPanel = GStorage.alwaysExapndIntroPanel;

      videoIntroController.expandableCtr = ExpandableController(
        initialExpanded: alwaysExapndIntroPanel,
      );

      if (!alwaysExapndIntroPanel && GStorage.exapndIntroPanelH) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.orientation == Orientation.landscape &&
              videoIntroController.expandableCtr?.expanded == false) {
            videoIntroController.expandableCtr?.toggle();
          }
        });
      }
    }
  }

  // 视频介绍
  void showIntroDetail() {
    if (widget.isLoading) {
      return;
    }
    feedBack();
    videoIntroController.expandableCtr?.toggle();
  }

  // 用户主页
  void onPushMember() {
    feedBack();
    int? mid =
        !widget.isLoading ? videoDetail.owner?.mid : videoItem['owner']?.mid;
    if (mid != null) {
      if (context.orientation == Orientation.landscape &&
          _horizontalMemberPage) {
        widget.onShowMemberPage(mid);
      } else {
        Get.toNamed(
          '/member?mid=$mid&from_view_aid=${videoDetailCtr.oid.value}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SliverLayoutBuilder(
      builder: (BuildContext context, SliverConstraints constraints) {
        bool isHorizontal = context.orientation == Orientation.landscape &&
            constraints.crossAxisExtent >
                constraints.viewportMainAxisExtent * 1.25;
        return SliverPadding(
          padding: const EdgeInsets.only(
            left: StyleString.safeSpace,
            right: StyleString.safeSpace,
            top: 10,
          ),
          sliver: SliverToBoxAdapter(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: showIntroDetail,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: Row(
                      children: [
                        if (videoItem['staff'] == null) ...[
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: onPushMember,
                                behavior: HitTestBehavior.opaque,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() => PendantAvatar(
                                          avatar: videoIntroController
                                              .userStat['card']?['face'],
                                          size: 35,
                                          badgeSize: 14,
                                          isVip: (videoIntroController
                                                          .userStat['card']
                                                      ?['vip']?['status'] ??
                                                  -1) >
                                              0,
                                          officialType: videoIntroController
                                                  .userStat['card']
                                              ?['official_verify']?['type'],
                                          // garbPendantImage: videoIntroController.userStat.value['card']?['pendant']?['image'],
                                        )),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(
                                          () => Text(
                                            videoIntroController
                                                        .userStat['card']
                                                    ?['name'] ??
                                                "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: (videoIntroController.userStat[
                                                                          'card']
                                                                      ?['vip']
                                                                  ?['status'] ??
                                                              -1) >
                                                          0 &&
                                                      videoIntroController
                                                                      .userStat[
                                                                  'card']?[
                                                              'vip']?['type'] ==
                                                          2
                                                  ? context.vipColor
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 0),
                                        Obx(
                                          () => Text(
                                            '${Utils.numFormat(videoIntroController.userStat['follower'])}粉丝    ${videoIntroController.userStat['archive_count'] != null ? '${Utils.numFormat(videoIntroController.userStat['archive_count'])}视频' : ''}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: theme.colorScheme.outline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          followButton(context, theme),
                        ] else
                          Expanded(
                            child: SelfSizedHorizontalList(
                              gapSize: 25,
                              itemCount: videoItem['staff'].length,
                              childBuilder: (index) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  int? ownerMid = !widget.isLoading
                                      ? videoDetail.owner?.mid
                                      : videoItem['owner']?.mid;
                                  if (videoItem['staff'][index].mid ==
                                          ownerMid &&
                                      context.orientation ==
                                          Orientation.landscape &&
                                      _horizontalMemberPage) {
                                    widget.onShowMemberPage(ownerMid);
                                  } else {
                                    Get.toNamed(
                                      '/member?mid=${videoItem['staff'][index].mid}&from_view_aid=${videoDetailCtr.oid.value}',
                                    );
                                  }
                                },
                                child: Row(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        NetworkImgLayer(
                                          type: ImageType.avatar,
                                          src: videoItem['staff'][index].face,
                                          width: 35,
                                          height: 35,
                                          fadeInDuration: Duration.zero,
                                          fadeOutDuration: Duration.zero,
                                        ),
                                        if ((videoItem['staff'][index]
                                                    .official
                                                    ?.type ??
                                                -1) !=
                                            -1)
                                          Positioned(
                                            right: -2,
                                            bottom: -2,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    theme.colorScheme.surface,
                                              ),
                                              child: Icon(
                                                Icons.offline_bolt,
                                                color: videoItem['staff'][index]
                                                            .official
                                                            ?.type ==
                                                        0
                                                    ? const Color(0xFFFFCC00)
                                                    : Colors.lightBlueAccent,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        Positioned(
                                          top: 0,
                                          right: -6,
                                          child: Obx(() => videoIntroController
                                                              .staffRelations[
                                                          'status'] ==
                                                      true &&
                                                  videoIntroController
                                                              .staffRelations[
                                                          '${videoItem['staff'][index].mid}'] ==
                                                      null
                                              ? Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    customBorder:
                                                        const CircleBorder(),
                                                    onTap: () => RequestUtils
                                                        .actionRelationMod(
                                                      context: context,
                                                      mid: videoItem['staff']
                                                              [index]
                                                          .mid,
                                                      isFollow: false,
                                                      callback: (val) {
                                                        videoIntroController
                                                                .staffRelations[
                                                            '${videoItem['staff'][index].mid}'] = true;
                                                      },
                                                    ),
                                                    child: Ink(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      decoration: BoxDecoration(
                                                        color: theme.colorScheme
                                                            .secondaryContainer,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        MdiIcons.plus,
                                                        size: 16,
                                                        color: theme.colorScheme
                                                            .onSecondaryContainer,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink()),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          videoItem['staff'][index].name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: videoItem['staff'][index]
                                                            .vip
                                                            .status >
                                                        0 &&
                                                    videoItem['staff'][index]
                                                            .vip
                                                            .type ==
                                                        2
                                                ? context.vipColor
                                                : null,
                                          ),
                                        ),
                                        Text(
                                          videoItem['staff'][index].title,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: theme.colorScheme.outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (isHorizontal) ...[
                          const SizedBox(width: 10),
                          Expanded(
                              child: actionGrid(context, videoIntroController)),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ExpandablePanel(
                    controller: videoIntroController.expandableCtr,
                    collapsed: GestureDetector(
                      onLongPress: () {
                        Feedback.forLongPress(context);
                        Utils.copyText(
                            '${videoDetail.title ?? videoItem['title'] ?? ''}');
                      },
                      child: _buildVideoTitle(theme),
                    ),
                    expanded: GestureDetector(
                      onLongPress: () {
                        Feedback.forLongPress(context);
                        Utils.copyText(
                            '${videoDetail.title ?? videoItem['title'] ?? ''}');
                      },
                      child: _buildVideoTitle(theme, true),
                    ),
                    theme: const ExpandableThemeData(
                      animationDuration: Duration(milliseconds: 300),
                      scrollAnimationDuration: Duration(milliseconds: 300),
                      crossFadePoint: 0,
                      fadeCurve: Curves.ease,
                      sizeCurve: Curves.linear,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          GestureDetector(
                            onTap: () => Utils.copyText(
                                '${videoIntroController.videoDetail.value.bvid}'),
                            child: Text(
                              videoIntroController.videoDetail.value.bvid ?? '',
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                          StatWidget(
                            type: StatType.play,
                            value: !widget.isLoading
                                ? videoDetail.stat?.view
                                : videoItem['stat']?.view,
                            color: theme.colorScheme.outline,
                          ),
                          StatWidget(
                            type: StatType.danmaku,
                            value: !widget.isLoading
                                ? videoDetail.stat?.danmaku
                                : videoItem['stat']?.danmu,
                            color: theme.colorScheme.outline,
                          ),
                          Text(
                            Utils.dateFormat(
                                !widget.isLoading
                                    ? videoDetail.pubdate
                                    : videoItem['pubdate'],
                                formatType: 'detail'),
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          if (MineController.anonymity.value)
                            Icon(
                              MdiIcons.incognito,
                              size: 15,
                              color: theme.colorScheme.outline,
                              semanticLabel: '无痕',
                            ),
                          if (videoIntroController.isShowOnlineTotal)
                            Obx(
                              () => Text(
                                '${videoIntroController.total.value}人在看',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (videoIntroController.enableAi)
                        Positioned(
                          right: 10,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Semantics(
                              label: 'AI总结',
                              child: GestureDetector(
                                onTap: () async {
                                  if (videoIntroController.aiConclusionResult ==
                                      null) {
                                    await videoIntroController.aiConclusion();
                                  }
                                  if (videoIntroController.aiConclusionResult ==
                                      null) {
                                    return;
                                  }
                                  if (videoIntroController.aiConclusionResult!
                                              .summary?.isNotEmpty ==
                                          true ||
                                      videoIntroController.aiConclusionResult!
                                              .outline?.isNotEmpty ==
                                          true) {
                                    widget.showAiBottomSheet();
                                  } else {
                                    SmartDialog.showToast("当前视频不支持AI视频总结");
                                  }
                                },
                                child: Image.asset('assets/images/ai.png',
                                    height: 22),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  if (videoIntroController.videoDetail.value.argueInfo?.argueMsg
                              ?.isNotEmpty ==
                          true &&
                      videoIntroController.showArgueMsg) ...[
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              size: 13,
                              Icons.error_outline,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 2)),
                          TextSpan(
                            text:
                                '${videoIntroController.videoDetail.value.argueInfo!.argueMsg}',
                          )
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                  ExpandablePanel(
                    controller: videoIntroController.expandableCtr,
                    collapsed: const SizedBox.shrink(),
                    expanded: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        if (videoIntroController
                                .videoDetail.value.descV2?.isNotEmpty ==
                            true) ...[
                          SelectableText.rich(
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.2,
                            ),
                            TextSpan(
                              children: [
                                buildContent(theme,
                                    videoIntroController.videoDetail.value),
                              ],
                            ),
                          ),
                        ],
                        if (videoIntroController.videoTags?.isNotEmpty ==
                            true) ...[
                          GestureDetector(
                            onTap: () {},
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 8),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: videoIntroController.videoTags!
                                    .map(
                                      (item) => SearchText(
                                        fontSize: 13,
                                        text: item.tagName!,
                                        onTap: (tagName) => Get.toNamed(
                                          '/searchResult',
                                          parameters: {'keyword': tagName},
                                        ),
                                        onLongPress: Utils.copyText,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    theme: const ExpandableThemeData(
                      animationDuration: Duration(milliseconds: 300),
                      scrollAnimationDuration: Duration(milliseconds: 300),
                      crossFadePoint: 0,
                      fadeCurve: Curves.ease,
                      sizeCurve: Curves.linear,
                    ),
                  ),
                  Obx(
                    () => videoIntroController.queryVideoIntroData["status"]
                        ? const SizedBox.shrink()
                        : Center(
                            child: TextButton.icon(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                videoIntroController
                                    .queryVideoIntroData["status"] = true;
                                videoIntroController.queryVideoIntro();
                                if (videoDetailCtr.videoUrl.isNullOrEmpty &&
                                    !videoDetailCtr.isQuerying) {
                                  videoDetailCtr.queryVideoUrl();
                                }
                              },
                              label: const Text("点此重新加载"),
                            ),
                          ),
                  ),
                  // 点赞收藏转发 布局样式2
                  if (!isHorizontal) ...[
                    const SizedBox(height: 8),
                    actionGrid(context, videoIntroController),
                  ],
                  // 合集
                  if (!widget.isLoading &&
                      videoDetail.ugcSeason != null &&
                      (context.orientation != Orientation.landscape ||
                          (context.orientation == Orientation.landscape &&
                              !videoDetailCtr
                                  .plPlayerController.horizontalSeasonPanel)))
                    Obx(
                      () => SeasonPanel(
                        key: ValueKey(videoIntroController.videoDetail.value),
                        heroTag: widget.heroTag,
                        changeFuc: videoIntroController.changeSeasonOrbangu,
                        showEpisodes: widget.showEpisodes,
                        videoIntroController: videoIntroController,
                      ),
                    ),
                  if (!widget.isLoading &&
                      videoDetail.pages != null &&
                      videoDetail.pages!.length > 1 &&
                      (context.orientation != Orientation.landscape ||
                          (context.orientation == Orientation.landscape &&
                              !videoDetailCtr.plPlayerController
                                  .horizontalSeasonPanel))) ...[
                    Obx(
                      () => PagesPanel(
                        key: ValueKey(videoIntroController.videoDetail.value),
                        heroTag: widget.heroTag,
                        videoIntroController: videoIntroController,
                        bvid: videoIntroController.bvid,
                        showEpisodes: widget.showEpisodes,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Obx followButton(BuildContext context, ThemeData t) {
    return Obx(
      () {
        int attr = videoIntroController.followStatus['attribute'] ?? 0;
        return TextButton(
          onPressed: () => videoIntroController.actionRelationMod(context),
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(vertical: -2.8),
            foregroundColor: attr != 0
                ? t.colorScheme.outline
                : t.colorScheme.onSecondaryContainer,
            backgroundColor: attr != 0
                ? t.colorScheme.onInverseSurface
                : t.colorScheme.secondaryContainer,
          ),
          child: Text(
            switch (attr) {
              1 => '悄悄关注',
              2 => '已关注',
              4 || 6 => '已互关',
              128 => '已拉黑',
              -10 => '特别关注',
              _ => ' 关注 '
            },
            style: const TextStyle(fontSize: 13),
          ),
        );
      },
    );
  }

  Widget actionGrid(
      BuildContext context, VideoIntroController videoIntroController) {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(
            () => ActionItem(
              icon: const Icon(FontAwesomeIcons.thumbsUp),
              selectIcon: const Icon(FontAwesomeIcons.solidThumbsUp),
              onTap: () => handleState(videoIntroController.actionLikeVideo),
              onLongPress: () =>
                  handleState(videoIntroController.actionOneThree),
              selectStatus: videoIntroController.hasLike.value,
              isLoading: widget.isLoading,
              semanticsLabel: '点赞',
              text: !widget.isLoading
                  ? Utils.numFormat(videoDetail.stat!.like!)
                  : '-',
              needAnim: true,
              hasTriple: videoIntroController.hasLike.value &&
                  videoIntroController.hasCoin &&
                  videoIntroController.hasFav.value,
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
              icon: const Icon(FontAwesomeIcons.thumbsDown),
              selectIcon: const Icon(FontAwesomeIcons.solidThumbsDown),
              onTap: () => handleState(videoIntroController.actionDislikeVideo),
              selectStatus: videoIntroController.hasDislike.value,
              isLoading: widget.isLoading,
              semanticsLabel: '点踩',
              text: "点踩",
            ),
          ),
          Obx(
            () => ActionItem(
              key: _coinKey,
              icon: const Icon(FontAwesomeIcons.b),
              selectIcon: const Icon(FontAwesomeIcons.b),
              onTap: () => handleState(videoIntroController.actionCoinVideo),
              selectStatus: videoIntroController.hasCoin,
              isLoading: widget.isLoading,
              semanticsLabel: '投币',
              text: !widget.isLoading
                  ? Utils.numFormat(videoDetail.stat!.coin!)
                  : '-',
              needAnim: true,
            ),
          ),
          Obx(
            () => ActionItem(
              key: _favKey,
              icon: const Icon(FontAwesomeIcons.star),
              selectIcon: const Icon(FontAwesomeIcons.solidStar),
              onTap: () => videoIntroController.showFavBottomSheet(context),
              onLongPress: () => videoIntroController
                  .showFavBottomSheet(context, type: 'longPress'),
              selectStatus: videoIntroController.hasFav.value,
              isLoading: widget.isLoading,
              semanticsLabel: '收藏',
              text: !widget.isLoading
                  ? Utils.numFormat(videoDetail.stat!.favorite!)
                  : '-',
              needAnim: true,
            ),
          ),
          Obx(
            () => ActionItem(
              icon: const Icon(FontAwesomeIcons.clock),
              selectIcon: const Icon(FontAwesomeIcons.solidClock),
              onTap: () => handleState(videoIntroController.viewLater),
              selectStatus: videoIntroController.hasLater.value,
              isLoading: widget.isLoading,
              semanticsLabel: '再看',
              text: '再看',
            ),
          ),
          ActionItem(
            icon: const Icon(FontAwesomeIcons.shareFromSquare),
            onTap: () => videoIntroController.actionShareVideo(context),
            selectStatus: false,
            isLoading: widget.isLoading,
            semanticsLabel: '分享',
            text: !widget.isLoading
                ? Utils.numFormat(videoDetail.stat!.share!)
                : '分享',
          ),
        ],
      ),
    );
  }

  Widget actionRow(
    BuildContext context,
    VideoIntroController videoIntroController,
    VideoDetailController videoDetailCtr,
  ) {
    return Row(children: <Widget>[
      Obx(
        () => ActionRowItem(
          icon: const Icon(FontAwesomeIcons.thumbsUp),
          onTap: () => handleState(videoIntroController.actionLikeVideo),
          selectStatus: videoIntroController.hasLike.value,
          isLoading: widget.isLoading,
          text: !widget.isLoading ? videoDetail.stat!.like!.toString() : '-',
        ),
      ),
      const SizedBox(width: 8),
      Obx(
        () => ActionRowItem(
          icon: const Icon(FontAwesomeIcons.b),
          onTap: () => handleState(videoIntroController.actionCoinVideo),
          selectStatus: videoIntroController.hasCoin,
          isLoading: widget.isLoading,
          text: !widget.isLoading ? videoDetail.stat!.coin!.toString() : '-',
        ),
      ),
      const SizedBox(width: 8),
      Obx(
        () => ActionRowItem(
          icon: const Icon(FontAwesomeIcons.heart),
          onTap: () => videoIntroController.showFavBottomSheet(context),
          onLongPress: () => videoIntroController.showFavBottomSheet(context,
              type: 'longPress'),
          selectStatus: videoIntroController.hasFav.value,
          isLoading: widget.isLoading,
          text:
              !widget.isLoading ? videoDetail.stat!.favorite!.toString() : '-',
        ),
      ),
      const SizedBox(width: 8),
      ActionRowItem(
        icon: const Icon(FontAwesomeIcons.comment),
        onTap: () => videoDetailCtr.tabCtr.animateTo(1),
        selectStatus: false,
        isLoading: widget.isLoading,
        text: !widget.isLoading ? videoDetail.stat!.reply!.toString() : '-',
      ),
      const SizedBox(width: 8),
      ActionRowItem(
        icon: const Icon(FontAwesomeIcons.share),
        onTap: () => videoIntroController.actionShareVideo(context),
        selectStatus: false,
        isLoading: widget.isLoading,
        text: '转发',
      ),
    ]);
  }

  InlineSpan buildContent(ThemeData theme, VideoDetailData content) {
    final List descV2 = content.descV2!;
    // type
    // 1 普通文本
    // 2 @用户
    final List<TextSpan> spanChildren = List.generate(descV2.length, (index) {
      final currentDesc = descV2[index];
      switch (currentDesc.type) {
        case 1:
          final List<InlineSpan> spanChildren = <InlineSpan>[];
          final RegExp urlRegExp = RegExp(
            '${Constants.urlPattern}|av\\d+|bv[a-z\\d]{10}',
            caseSensitive: false,
          );

          (currentDesc.rawText as String).splitMapJoin(
            urlRegExp,
            onMatch: (Match match) {
              String matchStr = match[0]!;
              if (RegExp(r'^av\d+$', caseSensitive: false).hasMatch(matchStr)) {
                try {
                  int aid = int.parse(matchStr.substring(2));
                  IdUtils.av2bv(aid);
                  spanChildren.add(
                    TextSpan(
                      text: matchStr,
                      style: TextStyle(color: theme.colorScheme.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => PiliScheme.videoPush(aid, null),
                    ),
                  );
                } catch (e) {
                  spanChildren.add(TextSpan(text: matchStr));
                }
              } else if (RegExp(r'^bv[a-z\d]{10}$', caseSensitive: false)
                  .hasMatch(matchStr)) {
                try {
                  IdUtils.bv2av(matchStr);
                  spanChildren.add(
                    TextSpan(
                      text: matchStr,
                      style: TextStyle(color: theme.colorScheme.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => PiliScheme.videoPush(null, matchStr),
                    ),
                  );
                } catch (e) {
                  spanChildren.add(TextSpan(text: matchStr));
                }
              } else {
                spanChildren.add(
                  TextSpan(
                    text: matchStr,
                    style: TextStyle(color: theme.colorScheme.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        try {
                          PageUtils.handleWebview(matchStr);
                        } catch (err) {
                          SmartDialog.showToast(err.toString());
                        }
                      },
                  ),
                );
              }
              return '';
            },
            onNonMatch: (String nonMatchStr) {
              spanChildren.add(TextSpan(text: nonMatchStr));
              return '';
            },
          );
          return TextSpan(children: spanChildren);
        case 2:
          final Color colorSchemePrimary = theme.colorScheme.primary;
          final String heroTag = Utils.makeHeroTag(currentDesc.bizId);
          return TextSpan(
            text: '@${currentDesc.rawText}',
            style: TextStyle(color: colorSchemePrimary),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(
                    '/member?mid=${currentDesc.bizId}',
                    arguments: {'face': '', 'heroTag': heroTag},
                  ),
          );
        default:
          return const TextSpan();
      }
    });
    return TextSpan(children: spanChildren);
  }
}
