import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/animated_height.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/expandable.dart';
import 'package:PiliPlus/common/widgets/gesture/tap_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show ReloadScrollPhysics;
import 'package:PiliPlus/common/widgets/selection_text.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/translucent_column.dart';
import 'package:PiliPlus/http/sponsor_block.dart';
import 'package:PiliPlus/models_new/video/video_ai_conclusion/model_result.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/desc_v2.dart';
import 'package:PiliPlus/models_new/video/video_detail/staff.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat.dart';
import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/action_item.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/page.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/season.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/bili_colors.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UgcIntroPanel extends StatefulWidget {
  const UgcIntroPanel({
    super.key,
    required this.heroTag,
    required this.showAiBottomSheet,
    required this.showEpisodes,
    required this.onShowMemberPage,
    required this.isPortrait,
    required this.isHorizontal,
  });
  final String heroTag;
  final Function showAiBottomSheet;
  final Function showEpisodes;
  final ValueChanged<int?> onShowMemberPage;
  final bool isPortrait;
  final bool isHorizontal;

  @override
  State<UgcIntroPanel> createState() => _UgcIntroPanelState();
}

class _UgcIntroPanelState extends State<UgcIntroPanel> {
  late ColorScheme colorScheme;
  late final UgcIntroController introController;
  late final VideoDetailController videoDetailCtr =
      Get.find<VideoDetailController>(tag: widget.heroTag);

  @override
  void initState() {
    super.initState();
    introController = Get.putOrFind(
      UgcIntroController.new,
      tag: widget.heroTag,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = widget.isPortrait;
    final isHorizontal = !isPortrait && widget.isHorizontal;
    return SliverPadding(
      padding: const .only(
        left: Style.safeSpace,
        right: Style.safeSpace,
        top: 10,
      ),
      sliver: Obx(
        () {
          final videoDetail = introController.videoDetail.value;
          final isLoading = videoDetail.bvid == null;
          return SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                if (isLoading) return;
                feedBack();
                introController.expand.toggle();
              },
              child: TranslucentColumn(
                crossAxisAlignment: .start,
                children: [
                  NoTranslucentArea(
                    child: _buildOwnerInfo(
                      isLoading,
                      isPortrait,
                      isHorizontal,
                      videoDetail,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTitle(isLoading, isHorizontal, videoDetail),
                  const SizedBox(height: 8),
                  Stack(
                    clipBehavior: .none,
                    children: [
                      _buildInfo(videoDetail.stat, videoDetail.pubdate),
                      if (introController.enableAi) _aiBtn,
                    ],
                  ),
                  if (introController.showArgueMsg)
                    if (videoDetail.argueInfo?.argueMsg case final argueMsg?
                        when argueMsg.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      _buildArgueInfo(argueMsg),
                    ],
                  if (isHorizontal && PlatformUtils.isDesktop)
                    ..._infos(videoDetail)
                  else
                    Obx(
                      () => AnimatedHeight(
                        expand: introController.expand.value,
                        duration: const Duration(milliseconds: 300),
                        child: TranslucentColumn(
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          children: _infos(videoDetail),
                        ),
                      ),
                    ),
                  Obx(
                    () => introController.status.value
                        ? const SizedBox.shrink()
                        : Center(
                            child: TextButton.icon(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                introController
                                  ..status.value = true
                                  ..queryVideoIntro();
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
                    actionGrid(
                      context,
                      isLoading,
                      introController,
                      videoDetail.stat,
                    ),
                  ],
                  // 合集
                  if (!isLoading &&
                      videoDetail.ugcSeason != null &&
                      (isPortrait ||
                          !videoDetailCtr
                              .plPlayerController
                              .horizontalSeasonPanel))
                    Obx(
                      () => SeasonPanel(
                        key: ValueKey(introController.videoDetail.value),
                        heroTag: widget.heroTag,
                        showEpisodes: widget.showEpisodes,
                        ugcIntroController: introController,
                      ),
                    ),
                  if (!isLoading &&
                      videoDetail.pages != null &&
                      videoDetail.pages!.length > 1 &&
                      (isPortrait ||
                          !videoDetailCtr
                              .plPlayerController
                              .horizontalSeasonPanel))
                    Obx(
                      () => PagesPanel(
                        key: ValueKey(introController.videoDetail.value),
                        heroTag: widget.heroTag,
                        ugcIntroController: introController,
                        bvid: introController.bvid,
                        showEpisodes: widget.showEpisodes,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArgueInfo(String argueMsg) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: .middle,
            child: Padding(
              padding: const .only(right: 2),
              child: Icon(
                size: 13,
                Icons.error_outline,
                color: colorScheme.outline,
              ),
            ),
          ),
          TextSpan(text: argueMsg),
        ],
      ),
      style: TextStyle(fontSize: 12, color: colorScheme.outline),
    );
  }

  Widget _buildTitle(
    bool isLoading,
    bool isHorizontal,
    VideoDetailData videoDetail,
  ) {
    if (isLoading) {
      return _buildVideoTitle(videoDetail);
    } else if (isHorizontal && PlatformUtils.isDesktop) {
      return _buildVideoTitle(videoDetail, isSelectable: true);
    }
    return Obx(
      () => ExpandablePanel(
        collapsed: _gestureVideoTitle(videoDetail),
        expanded: _gestureVideoTitle(videoDetail, isExpand: true),
        expand: introController.expand.value,
      ),
    );
  }

  Widget _gestureVideoTitle(
    VideoDetailData videoDetail, {
    bool isExpand = false,
  }) {
    return GestureDetector(
      onLongPress: () {
        Feedback.forLongPress(context);
        Utils.copyText(videoDetail.title ?? '');
      },
      child: _buildVideoTitle(videoDetail, isExpand: isExpand),
    );
  }

  List<Widget> _infos(VideoDetailData videoDetail) => [
    const SizedBox(height: 8, width: .infinity),
    GestureDetector(
      onTap: () => Utils.copyText('${videoDetail.bvid}'),
      child: Text(
        videoDetail.bvid ?? '',
        style: TextStyle(fontSize: 14, color: colorScheme.secondary),
      ),
    ),
    if (videoDetail.descV2 case final descV2? when descV2.isNotEmpty) ...[
      const SizedBox(height: 8),
      SelectionText.rich(
        buildDesc(descV2),
        style: const TextStyle(height: 1.4),
      ),
    ],
    NoTranslucentArea(
      child: Obx(() {
        final videoTags = introController.videoTags.value;
        if (videoTags == null || videoTags.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildTags(videoTags);
      }),
    ),
  ];

  WidgetSpan _labelWidget(String text, Color bgColor, Color textColor) {
    return WidgetSpan(
      alignment: .middle,
      child: Container(
        padding: const .symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Text(
          text,
          textScaler: TextScaler.noScaling,
          strutStyle: const StrutStyle(
            leading: 0,
            height: 1,
            fontSize: 12,
          ),
          style: TextStyle(
            height: 1,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoTitle(
    VideoDetailData videoDetail, {
    bool isExpand = false,
    bool isSelectable = false,
  }) {
    Widget child() {
      final videoLabel = videoDetailCtr.videoLabel.value;
      final textSpan = TextSpan(
        children: [
          if (videoLabel.isNotEmpty) ...[
            WidgetSpan(
              alignment: .middle,
              child: Container(
                padding: const .symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Stack(
                      clipBehavior: .none,
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 16,
                          color: colorScheme.onSecondaryContainer,
                        ),
                        Icon(
                          Icons.play_arrow_rounded,
                          size: 12,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ],
                    ),
                    Text(
                      videoLabel,
                      textScaler: TextScaler.noScaling,
                      strutStyle: const StrutStyle(
                        leading: 0,
                        height: 1,
                        fontSize: 13,
                      ),
                      style: TextStyle(
                        height: 1,
                        fontSize: 13,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const TextSpan(text: ' '),
          ],
          if (videoDetail.isUpowerExclusive == true) ...[
            _labelWidget(
              '充电专属',
              colorScheme.isDark
                  ? colorScheme.error
                  : colorScheme.errorContainer,
              colorScheme.isDark
                  ? colorScheme.onError
                  : colorScheme.onErrorContainer,
            ),
            const TextSpan(text: ' '),
          ] else if (videoDetail.rights?.isSteinGate == 1) ...[
            _labelWidget(
              '互动视频',
              colorScheme.secondaryContainer,
              colorScheme.onSecondaryContainer,
            ),
            const TextSpan(text: ' '),
          ],
          TextSpan(text: videoDetail.title ?? ''),
        ],
      );
      if (isSelectable) {
        return SelectionText.rich(
          textSpan,
          style: const TextStyle(fontSize: 16),
        );
      }
      return Text.rich(
        textSpan,
        maxLines: isExpand ? null : 2,
        overflow: isExpand ? null : .ellipsis,
        style: const TextStyle(fontSize: 16),
      );
    }

    if (videoDetailCtr.plPlayerController.enableSponsorBlock) {
      return Obx(child);
    }
    return child();
  }

  Widget followButton(BuildContext context) {
    return Obx(
      () {
        int attr = introController.followStatus.value.attribute ?? 0;
        return TextButton(
          onPressed: () => introController.actionRelationMod(context),
          style: TextButton.styleFrom(
            tapTargetSize: .shrinkWrap,
            visualDensity: const VisualDensity(vertical: -2.8),
            foregroundColor: attr != 0
                ? colorScheme.outline
                : colorScheme.onSecondaryContainer,
            backgroundColor: attr != 0
                ? colorScheme.onInverseSurface
                : colorScheme.secondaryContainer,
          ),
          child: Text(
            switch (attr) {
              1 => '悄悄关注',
              2 => '已关注',
              4 || 6 => '已互关',
              128 => '已拉黑',
              -10 => '特别关注',
              _ => ' 关注 ',
            },
            style: const TextStyle(fontSize: 13),
          ),
        );
      },
    );
  }

  Widget actionGrid(
    BuildContext context,
    bool isLoading,
    UgcIntroController introController,
    VideoStat? stat,
  ) {
    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Obx(
            () => ActionItem(
              animation: introController.tripleAnimation,
              icon: const Icon(FontAwesomeIcons.thumbsUp),
              selectIcon: const Icon(FontAwesomeIcons.solidThumbsUp),
              selectStatus: introController.hasLike.value,
              semanticsLabel: '点赞',
              text: !isLoading ? NumUtils.numFormat(stat!.like) : null,
              onStartTriple: introController.onStartTriple,
              onCancelTriple: introController.onCancelTriple,
            ),
          ),
          Obx(
            () => ActionItem(
              icon: const Icon(FontAwesomeIcons.thumbsDown),
              selectIcon: const Icon(FontAwesomeIcons.solidThumbsDown),
              onTap: () => introController.handleAction(
                introController.actionDislikeVideo,
              ),
              selectStatus: introController.hasDislike.value,
              semanticsLabel: '点踩',
              text: "点踩",
            ),
          ),
          Obx(
            () => ActionItem(
              animation: introController.tripleAnimation,
              icon: const Icon(FontAwesomeIcons.b),
              selectIcon: const Icon(FontAwesomeIcons.b),
              onTap: introController.actionCoinVideo,
              selectStatus: introController.hasCoin,
              semanticsLabel: '投币',
              text: !isLoading ? NumUtils.numFormat(stat!.coin) : null,
            ),
          ),
          Obx(
            () => ActionItem(
              animation: introController.tripleAnimation,
              icon: const Icon(FontAwesomeIcons.star),
              selectIcon: const Icon(FontAwesomeIcons.solidStar),
              onTap: () => introController.showFavBottomSheet(context),
              onLongPress: () => introController.showFavBottomSheet(
                context,
                isLongPress: true,
              ),
              selectStatus: introController.hasFav.value,
              semanticsLabel: '收藏',
              text: !isLoading ? NumUtils.numFormat(stat!.favorite) : null,
            ),
          ),
          Obx(
            () => ActionItem(
              icon: const Icon(FontAwesomeIcons.clock),
              selectIcon: const Icon(FontAwesomeIcons.solidClock),
              onTap: () =>
                  introController.handleAction(introController.viewLater),
              selectStatus: introController.hasLater.value,
              semanticsLabel: '再看',
              text: '再看',
            ),
          ),
          ActionItem(
            icon: const Icon(FontAwesomeIcons.shareFromSquare),
            onTap: () => introController.actionShareVideo(context),
            selectStatus: false,
            semanticsLabel: '分享',
            text: !isLoading ? NumUtils.numFormat(stat!.share!) : null,
          ),
        ],
      ),
    );
  }

  static final RegExp urlRegExp = RegExp(
    Constants.urlRegex.pattern + r'|av\d+|bv[a-z\d]{10}|(?:\d+[:：])?\d+[:：]\d+',
    caseSensitive: false,
  );

  static final youtubeRegExp = RegExp(
    r'(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-z0-9_\-]{11})',
    caseSensitive: false,
  );

  TextSpan buildDesc(List<DescV2> descV2) {
    // type
    // 1 普通文本
    // 2 @用户
    final List<TextSpan> spanChildren = descV2.map((currentDesc) {
      switch (currentDesc.type) {
        case 1:
          final List<InlineSpan> spanChildren = <InlineSpan>[];
          currentDesc.rawText?.splitMapJoin(
            urlRegExp,
            onMatch: (Match match) {
              final matchStr = match[0]!;
              final matchStrLowerCase = matchStr.toLowerCase();
              if (matchStrLowerCase.startsWith('http')) {
                spanChildren.add(
                  TextSpan(
                    text: matchStr,
                    style: TextStyle(color: colorScheme.primary),
                    recognizer: NoDeadlineTapGestureRecognizer()
                      ..onTap = () async {
                        if (videoDetailCtr
                            .plPlayerController
                            .enableSponsorBlock) {
                          final duration =
                              videoDetailCtr.data.timeLength ??
                              videoDetailCtr
                                  .plPlayerController
                                  .durationInMilliseconds;
                          if (duration > 0) {
                            final ytbId = youtubeRegExp
                                .firstMatch(matchStr)
                                ?.group(1);
                            if (ytbId != null) {
                              final bvid = videoDetailCtr.bvid;
                              final cid = videoDetailCtr.cid.value;

                              SmartDialog.showLoading();
                              final hasPortVideo =
                                  (await SponsorBlock.getPortVideo(
                                    bvid: bvid,
                                    cid: cid,
                                  )).dataOrNull ==
                                  ytbId;
                              SmartDialog.dismiss();

                              if (!mounted) return;
                              final confirmed = await showConfirmDialog(
                                context: context,
                                title: const Text('空降助手：搬运视频同步'),
                                content: Text(
                                  '${hasPortVideo ? "" : "是否将"}该视频${hasPortVideo ? "已" : ""}绑定到此YouTube视频($ytbId)',
                                ),
                              );
                              if (!hasPortVideo && confirmed) {
                                final res = await SponsorBlock.postPortVideo(
                                  bvid: bvid,
                                  cid: cid,
                                  ytbId: ytbId,
                                  videoDuration: (duration / 1000).round(),
                                );
                                SmartDialog.showToast(
                                  '提交搬运视频${res.isSuccess ? "成功" : "失败: $res"}',
                                );
                                return;
                              }
                            }
                          }
                        }
                        PageUtils.handleWebview(matchStr);
                      },
                  ),
                );
              } else if (matchStrLowerCase.startsWith('av')) {
                try {
                  int aid = int.parse(matchStr.substring(2));
                  IdUtils.av2bv(aid);
                  spanChildren.add(
                    TextSpan(
                      text: matchStr,
                      style: TextStyle(color: colorScheme.primary),
                      recognizer: NoDeadlineTapGestureRecognizer()
                        ..onTap = () => PiliScheme.videoPush(aid, null),
                    ),
                  );
                } catch (e) {
                  spanChildren.add(TextSpan(text: matchStr));
                }
              } else if (matchStrLowerCase.startsWith('bv')) {
                try {
                  IdUtils.bv2av(matchStr);
                  spanChildren.add(
                    TextSpan(
                      text: matchStr,
                      style: TextStyle(color: colorScheme.primary),
                      recognizer: NoDeadlineTapGestureRecognizer()
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
                    style: TextStyle(color: colorScheme.primary),
                    recognizer: NoDeadlineTapGestureRecognizer()
                      ..onTap = () {
                        try {
                          Get.find<VideoDetailController>(
                            tag: widget.heroTag,
                          ).plPlayerController.seekTo(
                            Duration(
                              seconds: DurationUtils.parseDuration(matchStr),
                            ),
                            isSeek: false,
                          );
                        } catch (_) {}
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
          final Color colorSchemePrimary = colorScheme.primary;
          return TextSpan(
            text: '@${currentDesc.rawText}',
            style: TextStyle(color: colorSchemePrimary),
            recognizer: NoDeadlineTapGestureRecognizer()
              ..onTap = () => Get.toNamed('/member?mid=${currentDesc.bizId}'),
          );
        default:
          return const TextSpan();
      }
    }).toList();
    return TextSpan(children: spanChildren);
  }

  Widget _buildOwnerInfo(
    bool isLoading,
    bool isPortrait,
    bool isHorizontal,
    VideoDetailData videoDetail,
  ) {
    final mid = videoDetail.owner?.mid;
    return Row(
      children: [
        if (videoDetail.staff case final staff? when staff.isNotEmpty)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: .horizontal,
              hitTestBehavior: .deferToChild,
              physics: ReloadScrollPhysics(controller: introController),
              child: Row(
                spacing: 25,
                children: staff
                    .map((e) => _buildStaff(isPortrait, mid, e))
                    .toList(),
              ),
            ),
          )
        else ...[
          Expanded(
            child: Align(
              alignment: .centerLeft,
              child: _buildAvatar(
                () {
                  if (mid != null) {
                    feedBack();
                    if (!isPortrait && introController.horizontalMemberPage) {
                      widget.onShowMemberPage(mid);
                    } else {
                      Get.toNamed(
                        '/member?mid=$mid&from_view_aid=${videoDetailCtr.aid}',
                      );
                    }
                  }
                },
              ),
            ),
          ),
          followButton(context),
        ],
        if (isHorizontal) ...[
          const SizedBox(width: 10),
          Expanded(
            child: actionGrid(
              context,
              isLoading,
              introController,
              videoDetail.stat,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStaff(
    bool isPortrait,
    int? ownerMid,
    Staff item,
  ) {
    void onTap() => Get.toNamed(
      '/member?mid=${item.mid}&from_view_aid=${videoDetailCtr.aid}',
    );
    return GestureDetector(
      behavior: .opaque,
      onTap: () {
        if (item.mid == ownerMid &&
            !isPortrait &&
            introController.horizontalMemberPage) {
          widget.onShowMemberPage(ownerMid);
        } else {
          onTap();
        }
      },
      onSecondaryTap:
          PlatformUtils.isDesktop && introController.horizontalMemberPage
          ? onTap
          : null,
      child: Row(
        children: [
          Stack(
            clipBehavior: .none,
            children: [
              NetworkImgLayer(
                type: .avatar,
                src: item.face,
                width: 35,
                height: 35,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
              ),
              if (item.official?.type case final type? when type != -1)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: colorScheme.surface,
                    ),
                    child: item.official?.type == 0
                        ? const Icon(
                            Icons.offline_bolt,
                            color: BiliColors.yellow,
                            size: 14,
                          )
                        : const Icon(
                            Icons.offline_bolt,
                            color: Colors.lightBlueAccent,
                            size: 14,
                          ),
                  ),
                ),
              Positioned(
                top: 0,
                right: -6,
                child: Obx(
                  () {
                    if (introController.staffRelations['status'] == true &&
                        introController.staffRelations['${item.mid}'] == null) {
                      return Material(
                        type: .transparency,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => RequestUtils.actionRelationMod(
                            context: context,
                            mid: item.mid,
                            isFollow: false,
                            afterMod: (val) =>
                                introController.staffRelations['${item.mid}'] =
                                    true,
                          ),
                          child: Ink(
                            padding: const .all(2),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              shape: .circle,
                            ),
                            child: Icon(
                              MdiIcons.plus,
                              size: 16,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                item.name!,
                maxLines: 1,
                overflow: .ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: (item.vip?.status ?? 0) > 0 && item.vip?.type == 2
                      ? colorScheme.vipColor
                      : null,
                ),
              ),
              Text(
                item.title!,
                style: TextStyle(fontSize: 12, color: colorScheme.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(
    VoidCallback onPushMember,
  ) => GestureDetector(
    onTap: onPushMember,
    behavior: .opaque,
    onSecondaryTap:
        PlatformUtils.isDesktop && introController.horizontalMemberPage
        ? () => Get.toNamed(
            '/member?mid=${introController.userStat.value.card?.mid}&from_view_aid=${videoDetailCtr.aid}',
          )
        : null,
    child: Obx(
      () {
        final userStat = introController.userStat.value;
        final isVip = (userStat.card?.vip?.status ?? 0) > 0;
        return Row(
          spacing: 10,
          mainAxisSize: .min,
          children: [
            PendantAvatar(
              userStat.card?.face,
              size: 35,
              badgeSize: 14,
              vipStatus: userStat.card?.vip?.status,
              officialType: userStat.card?.official?.type,
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  userStat.card?.name ?? "",
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isVip && userStat.card?.vip?.type == 2
                        ? colorScheme.vipColor
                        : null,
                  ),
                ),
                Text(
                  '${NumUtils.numFormat(userStat.follower)}粉丝    ${'${NumUtils.numFormat(userStat.archiveCount)}视频'}',
                  style: TextStyle(fontSize: 12, color: colorScheme.outline),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  Widget _buildInfo(VideoStat? stat, int? pubdate) {
    return Row(
      spacing: 10,
      children: [
        StatWidget(
          type: .play,
          value: stat?.view,
          color: colorScheme.outline,
        ),
        StatWidget(
          type: .danmaku,
          value: stat?.danmaku,
          color: colorScheme.outline,
        ),
        Text(
          DateFormatUtils.format(pubdate),
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.outline,
          ),
        ),
        if (MineController.anonymity.value)
          Icon(
            MdiIcons.incognito,
            size: 15,
            color: colorScheme.outline,
            semanticLabel: '无痕',
          ),
        if (introController.isShowOnlineTotal)
          Obx(
            () => Text(
              '${introController.total.value}人在看',
              style: TextStyle(fontSize: 12, color: colorScheme.outline),
            ),
          ),
      ],
    );
  }

  Widget get _aiBtn => Positioned(
    right: 8,
    child: Center(
      child: GestureDetector(
        behavior: .opaque,
        onTap: () async {
          if (introController.aiConclusionResult == null) {
            await introController.aiConclusion();
          }
          if (introController.aiConclusionResult case AiConclusionResult(
            :final summary,
            :final outline,
          )) {
            if (summary?.isNotEmpty == true || outline?.isNotEmpty == true) {
              widget.showAiBottomSheet();
            } else {
              SmartDialog.showToast("当前视频不支持AI视频总结");
            }
          }
        },
        child: Image.asset(
          semanticLabel: 'AI总结',
          Assets.ai,
          height: 18,
          width: 18,
          cacheHeight: 18.cacheSize(context),
        ),
      ),
    ),
  );

  Widget _buildTags(List<VideoTagItem> tags) {
    return Padding(
      padding: const .only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags
            .map(
              (item) => SearchText(
                fontSize: 13,
                text: switch (item.tagType) {
                  'bgm' => item.tagName!.replaceFirst('发现', '♫ BGM：'),
                  'topic' => '#${item.tagName}',
                  _ => item.tagName!,
                },
                onTap: switch (item.tagType) {
                  'bgm' => (_) => Get.toNamed(
                    '/musicDetail',
                    parameters: {'musicId': item.musicId!},
                  ),
                  'topic' => (_) => Get.toNamed(
                    '/dynTopic',
                    parameters: {'id': item.tagId!.toString()},
                  ),
                  _ => (tagName) => Get.toNamed(
                    '/searchResult',
                    parameters: {'keyword': tagName},
                  ),
                },
                onLongPress: Utils.copyText,
              ),
            )
            .toList(),
      ),
    );
  }
}
