import 'dart:async';

import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/video/detail/index.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/video_detail_res.dart';
import 'package:PiliPlus/pages/video/detail/introduction/controller.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'widgets/action_item.dart';
import 'widgets/action_row_item.dart';
import 'widgets/page.dart';
import 'widgets/season.dart';

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
  final ValueChanged onShowMemberPage;

  @override
  State<VideoIntroPanel> createState() => _VideoIntroPanelState();
}

class _VideoIntroPanelState extends State<VideoIntroPanel>
    with AutomaticKeepAliveClientMixin {
  late VideoIntroController videoIntroController;

  // 添加页面缓存
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
              loadingStatus: true,
              videoIntroController: videoIntroController,
              heroTag: widget.heroTag,
              showAiBottomSheet: widget.showAiBottomSheet,
              showEpisodes: widget.showEpisodes,
              onShowMemberPage: widget.onShowMemberPage,
            )
          : VideoInfo(
              key: ValueKey(widget.heroTag),
              loadingStatus: false,
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
  final bool loadingStatus;
  final String heroTag;
  final Function showAiBottomSheet;
  final Function showEpisodes;
  final ValueChanged onShowMemberPage;
  final VideoIntroController videoIntroController;

  const VideoInfo({
    super.key,
    this.loadingStatus = false,
    required this.heroTag,
    required this.showAiBottomSheet,
    required this.showEpisodes,
    required this.onShowMemberPage,
    required this.videoIntroController,
  });

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> with TickerProviderStateMixin {
  late final VideoDetailController videoDetailCtr;

  Map get videoItem => videoIntroController.videoItem;
  VideoIntroController get videoIntroController => widget.videoIntroController;
  VideoDetailData get videoDetail =>
      widget.videoIntroController.videoDetail.value;

  late final _coinKey = GlobalKey<ActionItemState>();
  late final _favKey = GlobalKey<ActionItemState>();

  bool isProcessing = false;

  late final _horizontalMemberPage = GStorage.horizontalMemberPage;

  Widget _buildVideoTitle([bool isExpand = false]) => videoDetailCtr
          .enableSponsorBlock
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
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                size: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                              Icon(
                                Icons.play_arrow_rounded,
                                size: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                            ],
                          ),
                          Text(
                            videoDetailCtr.videoLabel.value,
                            textScaler: TextScaler.linear(1),
                            strutStyle: StrutStyle(leading: 0, height: 1),
                            style: TextStyle(
                              height: 1,
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextSpan(text: ' '),
                ],
                TextSpan(
                    text: '${videoDetail.title ?? videoItem['title'] ?? ''}'),
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

  void handleState(Future Function() action) async {
    if (isProcessing.not) {
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

      if (alwaysExapndIntroPanel.not && GStorage.exapndIntroPanelH) {
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
  showIntroDetail() {
    if (widget.loadingStatus) {
      return;
    }
    feedBack();
    // widget.showIntroDetail();
    videoIntroController.expandableCtr?.toggle();
  }

  // 用户主页
  onPushMember() {
    feedBack();
    int? mid = !widget.loadingStatus
        ? videoDetail.owner?.mid
        : videoItem['owner']?.mid;
    if (mid != null) {
      if (context.orientation == Orientation.landscape &&
          _horizontalMemberPage) {
        widget.onShowMemberPage(mid);
      } else {
        // memberHeroTag = Utils.makeHeroTag(mid);
        // String face = !loadingStatus
        //     ? videoDetail.owner!.face
        //     : videoItem['owner'].face;
        Get.toNamed(
          '/member?mid=$mid',
          // arguments: {
          //   'face': face,
          //   'heroTag': memberHeroTag,
          // },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);
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
                        Expanded(
                          child: videoItem['staff'] == null
                              ? GestureDetector(
                                  onTap: onPushMember,
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Obx(
                                        () => Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            NetworkImgLayer(
                                              type: 'avatar',
                                              src: videoIntroController.userStat
                                                      .value['card']?['face'] ??
                                                  '',
                                              width: 35,
                                              height: 35,
                                              fadeInDuration: Duration.zero,
                                              fadeOutDuration: Duration.zero,
                                            ),
                                            if ((videoIntroController.userStat
                                                                .value['card']
                                                            ?['official_verify']
                                                        ?['type'] ??
                                                    -1) !=
                                                -1)
                                              Positioned(
                                                right: -2,
                                                bottom: -2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                  ),
                                                  child: Icon(
                                                    Icons.offline_bolt,
                                                    color: videoIntroController
                                                                        .userStat
                                                                        .value['card']
                                                                    ?[
                                                                    'official_verify']
                                                                ?['type'] ==
                                                            0
                                                        ? Colors.yellow
                                                        : Colors
                                                            .lightBlueAccent,
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(
                                              () => Text(
                                                videoIntroController.userStat
                                                            .value['card']
                                                        ?['name'] ??
                                                    "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: (videoIntroController
                                                                          .userStat
                                                                          .value['card']?['vip']
                                                                      ?[
                                                                      'status'] ??
                                                                  -1) >
                                                              0 &&
                                                          videoIntroController
                                                                      .userStat
                                                                      .value['card']
                                                                  ?[
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
                                                '${Utils.numFormat(videoIntroController.userStat.value['follower'])}粉丝    ${videoIntroController.userStat.value['archive_count'] != null ? '${Utils.numFormat(videoIntroController.userStat.value['archive_count'])}视频' : ''}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: t.colorScheme.outline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      followButton(context, t),
                                    ],
                                  ),
                                )
                              : SelfSizedHorizontalList(
                                  gapSize: 25,
                                  itemCount: videoItem['staff'].length,
                                  childBuilder: (index) => GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      int? ownerMid = !widget.loadingStatus
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
                                          '/member?mid=${videoItem['staff'][index].mid}',
                                          // arguments: {
                                          // 'face':
                                          //     videoItem['staff'][index].face,
                                          // 'heroTag': Utils.makeHeroTag(
                                          //     videoItem['staff'][index].mid),
                                          // },
                                        );
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            NetworkImgLayer(
                                              type: 'avatar',
                                              src: videoItem['staff'][index]
                                                  .face,
                                              width: 35,
                                              height: 35,
                                              fadeInDuration: Duration.zero,
                                              fadeOutDuration: Duration.zero,
                                            ),
                                            if ((videoItem['staff'][index]
                                                        .official?['type'] ??
                                                    -1) !=
                                                -1)
                                              Positioned(
                                                right: -2,
                                                bottom: -2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                  ),
                                                  child: Icon(
                                                    Icons.offline_bolt,
                                                    color: videoItem['staff']
                                                                        [index]
                                                                    .official?[
                                                                'type'] ==
                                                            0
                                                        ? Colors.yellow
                                                        : Colors
                                                            .lightBlueAccent,
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
                                                        onTap: () {
                                                          Utils
                                                              .actionRelationMod(
                                                            context: context,
                                                            mid: videoItem[
                                                                        'staff']
                                                                    [index]
                                                                .mid,
                                                            isFollow: false,
                                                            callback: (val) {
                                                              videoIntroController
                                                                      .staffRelations[
                                                                  '${videoItem['staff'][index].mid}'] = true;
                                                            },
                                                          );
                                                        },
                                                        child: Ink(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondaryContainer,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            MdiIcons.plus,
                                                            size: 16,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
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
                                                        videoItem['staff']
                                                                    [index]
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
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
                      child: _buildVideoTitle(),
                    ),
                    expanded: GestureDetector(
                      onLongPress: () {
                        Feedback.forLongPress(context);
                        Utils.copyText(
                            '${videoDetail.title ?? videoItem['title'] ?? ''}');
                      },
                      child: _buildVideoTitle(true),
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
                    children: [
                      Row(
                        children: <Widget>[
                          StatView(
                            context: context,
                            theme: 'gray',
                            value: Utils.numFormat(!widget.loadingStatus
                                ? videoDetail.stat?.view ?? '-'
                                : videoItem['stat']?.view ?? '-'),
                            size: 'medium',
                            textColor: t.colorScheme.outline,
                          ),
                          const SizedBox(width: 10),
                          StatDanMu(
                            context: context,
                            theme: 'gray',
                            value: Utils.numFormat(!widget.loadingStatus
                                ? videoDetail.stat?.danmu ?? '-'
                                : videoItem['stat']?.danmu ?? '-'),
                            size: 'medium',
                            textColor: t.colorScheme.outline,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            Utils.dateFormat(
                                !widget.loadingStatus
                                    ? videoDetail.pubdate
                                    : videoItem['pubdate'],
                                formatType: 'detail'),
                            style: TextStyle(
                              fontSize: 12,
                              color: t.colorScheme.outline,
                            ),
                          ),
                          if (MineController.anonymity.value) ...<Widget>[
                            const SizedBox(width: 10),
                            Icon(
                              MdiIcons.incognito,
                              size: 15,
                              color: t.colorScheme.outline,
                              semanticLabel: '无痕',
                            ),
                          ],
                          const SizedBox(width: 10),
                          if (videoIntroController.isShowOnlineTotal)
                            Obx(
                              () => Text(
                                '${videoIntroController.total.value}人在看',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: t.colorScheme.outline,
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
                                  final res =
                                      await videoIntroController.aiConclusion();
                                  if (res['status']) {
                                    if (videoIntroController.modelResult.summary
                                            .isNullOrEmpty &&
                                        videoIntroController
                                                .modelResult.outline ==
                                            null) {
                                      SmartDialog.showToast("当前视频不支持AI视频总结");
                                    } else {
                                      widget.showAiBottomSheet();
                                    }
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
                  if (videoIntroController
                              .videoDetail.value.argueMsg?.isNotEmpty ==
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
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          WidgetSpan(child: SizedBox(width: 2)),
                          TextSpan(
                            text:
                                '${videoIntroController.videoDetail.value.argueMsg}',
                          )
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
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
                        GestureDetector(
                          onTap: () {
                            Utils.copyText(
                                '${videoIntroController.videoDetail.value.bvid}');
                          },
                          child: Text(
                            videoIntroController.videoDetail.value.bvid ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        if (videoIntroController
                            .videoDetail.value.descV2.isNullOrEmpty.not) ...[
                          const SizedBox(height: 8),
                          SelectableText.rich(
                            style: const TextStyle(
                              height: 1.4,
                              // fontSize: 13,
                            ),
                            TextSpan(
                              children: [
                                buildContent(context,
                                    videoIntroController.videoDetail.value),
                              ],
                            ),
                          ),
                        ],
                        if (videoIntroController.videoTags is List &&
                            videoIntroController.videoTags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (videoIntroController.videoTags as List)
                                .map(
                                  (item) => SearchText(
                                    fontSize: 13,
                                    text: item['tag_name'],
                                    onTap: (_) => Get.toNamed('/searchResult',
                                        parameters: {
                                          'keyword': item['tag_name']
                                        }),
                                    onLongPress: (_) =>
                                        Utils.copyText(item['tag_name']),
                                  ),
                                )
                                .toList(),
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
                    () =>
                        videoIntroController.queryVideoIntroData.value["status"]
                            ? const SizedBox.shrink()
                            : Center(
                                child: TextButton.icon(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () {
                                    videoIntroController.queryVideoIntroData
                                        .value["status"] = true;
                                    videoIntroController.queryVideoIntro();
                                    if (videoDetailCtr.videoUrl.isNullOrEmpty &&
                                        videoDetailCtr.isQuerying.not) {
                                      videoDetailCtr.queryVideoUrl();
                                    }
                                  },
                                  label: const Text("点此重新加载"),
                                ),
                              ),
                  ),
                  // 点赞收藏转发 布局样式1
                  // SingleChildScrollView(
                  //   padding: const EdgeInsets.only(top: 7, bottom: 7),
                  //   scrollDirection: Axis.horizontal,
                  //   child: actionRow(
                  //     context,
                  //     videoIntroController,
                  //     videoDetailCtr,
                  //   ),
                  // ),
                  // 点赞收藏转发 布局样式2
                  if (!isHorizontal) ...[
                    const SizedBox(height: 8),
                    actionGrid(context, videoIntroController),
                  ],
                  // 合集
                  if (!widget.loadingStatus &&
                      videoDetail.ugcSeason != null &&
                      (context.orientation != Orientation.landscape ||
                          (context.orientation == Orientation.landscape &&
                              videoDetailCtr.horizontalSeasonPanel.not)))
                    Obx(
                      () => SeasonPanel(
                        key: ValueKey(videoIntroController.videoDetail.value),
                        heroTag: widget.heroTag,
                        changeFuc: videoIntroController.changeSeasonOrbangu,
                        showEpisodes: widget.showEpisodes,
                        videoIntroController: videoIntroController,
                      ),
                    ),
                  if (!widget.loadingStatus &&
                      videoDetail.pages != null &&
                      videoDetail.pages!.length > 1 &&
                      (context.orientation != Orientation.landscape ||
                          (context.orientation == Orientation.landscape &&
                              videoDetailCtr.horizontalSeasonPanel.not))) ...[
                    Obx(
                      () => PagesPanel(
                        key: ValueKey(videoIntroController.videoDetail.value),
                        heroTag: widget.heroTag,
                        videoIntroController: videoIntroController,
                        bvid: videoIntroController.bvid,
                        changeFuc: videoIntroController.changeSeasonOrbangu,
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
            visualDensity: const VisualDensity(vertical: -3),
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
              6 => '已互关',
              128 => '已拉黑',
              _ => '关注'
            },
            style: TextStyle(fontSize: t.textTheme.labelMedium!.fontSize),
          ),
        );
      },
    );
  }

  Widget actionGrid(
      BuildContext context, VideoIntroController videoIntroController) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        margin: const EdgeInsets.only(top: 1),
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Obx(
              () => ActionItem(
                icon: const Icon(FontAwesomeIcons.thumbsUp),
                selectIcon: const Icon(FontAwesomeIcons.solidThumbsUp),
                onTap: () => handleState(videoIntroController.actionLikeVideo),
                onLongPress: () =>
                    handleState(videoIntroController.actionOneThree),
                selectStatus: videoIntroController.hasLike.value,
                loadingStatus: widget.loadingStatus,
                semanticsLabel: '点赞',
                text: !widget.loadingStatus
                    ? Utils.numFormat(videoDetail.stat!.like!)
                    : '-',
                needAnim: true,
                hasTriple: videoIntroController.hasLike.value &&
                    videoIntroController.hasCoin.value &&
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
                onTap: () =>
                    handleState(videoIntroController.actionDislikeVideo),
                selectStatus: videoIntroController.hasDislike.value,
                loadingStatus: widget.loadingStatus,
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
                selectStatus: videoIntroController.hasCoin.value,
                loadingStatus: widget.loadingStatus,
                semanticsLabel: '投币',
                text: !widget.loadingStatus
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
                loadingStatus: widget.loadingStatus,
                semanticsLabel: '收藏',
                text: !widget.loadingStatus
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
                loadingStatus: widget.loadingStatus,
                semanticsLabel: '再看',
                text: '再看',
              ),
            ),
            ActionItem(
              icon: const Icon(FontAwesomeIcons.shareFromSquare),
              onTap: () => videoIntroController.actionShareVideo(context),
              selectStatus: false,
              loadingStatus: widget.loadingStatus,
              semanticsLabel: '分享',
              text: !widget.loadingStatus
                  ? Utils.numFormat(videoDetail.stat!.share!)
                  : '分享',
            ),
          ],
        ),
      );
    });
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
          loadingStatus: widget.loadingStatus,
          text:
              !widget.loadingStatus ? videoDetail.stat!.like!.toString() : '-',
        ),
      ),
      const SizedBox(width: 8),
      Obx(
        () => ActionRowItem(
          icon: const Icon(FontAwesomeIcons.b),
          onTap: () => handleState(videoIntroController.actionCoinVideo),
          selectStatus: videoIntroController.hasCoin.value,
          loadingStatus: widget.loadingStatus,
          text:
              !widget.loadingStatus ? videoDetail.stat!.coin!.toString() : '-',
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
          loadingStatus: widget.loadingStatus,
          text: !widget.loadingStatus
              ? videoDetail.stat!.favorite!.toString()
              : '-',
        ),
      ),
      const SizedBox(width: 8),
      ActionRowItem(
        icon: const Icon(FontAwesomeIcons.comment),
        onTap: () {
          videoDetailCtr.tabCtr.animateTo(1);
        },
        selectStatus: false,
        loadingStatus: widget.loadingStatus,
        text: !widget.loadingStatus ? videoDetail.stat!.reply!.toString() : '-',
      ),
      const SizedBox(width: 8),
      ActionRowItem(
          icon: const Icon(FontAwesomeIcons.share),
          onTap: () => videoIntroController.actionShareVideo(context),
          selectStatus: false,
          loadingStatus: widget.loadingStatus,
          // text: !loadingStatus
          //     ? videoDetail.stat!.share!.toString()
          //     : '-',
          text: '转发'),
    ]);
  }

  InlineSpan buildContent(BuildContext context, VideoDetailData content) {
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
                  // validate
                  int aid = int.parse(matchStr.substring(2));
                  IdUtils.av2bv(aid);
                  spanChildren.add(
                    TextSpan(
                      text: matchStr,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          PiliScheme.videoPush(aid, null);
                        },
                    ),
                  );
                } catch (e) {
                  spanChildren.add(TextSpan(text: matchStr));
                }
              } else if (RegExp(r'^bv[a-z\d]{10}$', caseSensitive: false)
                  .hasMatch(matchStr)) {
                try {
                  // validate
                  IdUtils.bv2av(matchStr);
                  spanChildren.add(
                    TextSpan(
                      text: matchStr,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          PiliScheme.videoPush(null, matchStr);
                        },
                    ),
                  );
                } catch (e) {
                  spanChildren.add(TextSpan(text: matchStr));
                }
              } else {
                spanChildren.add(
                  TextSpan(
                    text: matchStr,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        try {
                          Utils.handleWebview(matchStr);
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
          final Color colorSchemePrimary =
              Theme.of(context).colorScheme.primary;
          final String heroTag = Utils.makeHeroTag(currentDesc.bizId);
          return TextSpan(
            text: '@${currentDesc.rawText}',
            style: TextStyle(color: colorSchemePrimary),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(
                  '/member?mid=${currentDesc.bizId}',
                  arguments: {'face': '', 'heroTag': heroTag},
                );
              },
          );
        default:
          return const TextSpan();
      }
    });
    return TextSpan(children: spanChildren);
  }
}
