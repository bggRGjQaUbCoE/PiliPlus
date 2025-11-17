import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart' as pgc;
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart' as ugc;
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/pages/download/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/page.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class DownloadPanel extends StatefulWidget {
  const DownloadPanel({
    super.key,
    required this.index,
    this.pgcItem,
    this.videoDetail,
    required this.episodes,
    required this.scrollController,
    required this.videoDetailController,
    required this.heroTag,
    this.ugcIntroController,
    required this.cidSet,
  });

  final int index;
  final PgcInfoModel? pgcItem;
  final VideoDetailData? videoDetail;
  final List<ugc.BaseEpisodeItem> episodes;
  final ScrollController scrollController;
  final VideoDetailController videoDetailController;
  final String heroTag;
  final UgcIntroController? ugcIntroController;
  final Set<int?> cidSet;

  @override
  State<DownloadPanel> createState() => _DownloadPanelState();
}

class _DownloadPanelState extends State<DownloadPanel> {
  final DownloadService _downloadService = Get.find<DownloadService>();
  final ListController _listController = ListController();

  late final cidSet = widget.cidSet;
  VideoQuality _quality = VideoQuality.fromCode(Pref.defaultVideoQa);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listController.jumpToItem(
        index: widget.index,
        scrollController: widget.scrollController,
        alignment: 0,
      );
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.colorScheme.outline.withValues(alpha: 0.2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildHeader(theme),
        _buildBody(theme),
        Divider(height: 1, color: dividerColor),
        _buildFooter(theme, dividerColor),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
      child: Row(
        spacing: 16,
        children: [
          Text(
            '最高画质',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          Builder(
            builder: (context) => PopupMenuButton<VideoQuality>(
              initialValue: _quality,
              onSelected: (value) {
                _quality = value;
                (context as Element).markNeedsBuild();
              },
              itemBuilder: (context) => VideoQuality.values
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(e.desc),
                    ),
                  )
                  .toList(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _quality.desc,
                      style: const TextStyle(height: 1),
                      strutStyle: const StrutStyle(height: 1, leading: 0),
                    ),
                    Icon(
                      size: 18,
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurfaceVariant,
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

  Widget _buildBody(ThemeData theme) {
    final episodes = widget.episodes;
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 100),
              sliver: SuperSliverList.builder(
                itemCount: episodes.length,
                listController: _listController,
                itemBuilder: (context, index) {
                  final episode = episodes[index];
                  final hasParts =
                      episode is ugc.EpisodeItem && episode.pages!.length > 1;
                  Widget child = _buildItem(
                    theme: theme,
                    index: index,
                    hasParts: hasParts,
                    episode: episode,
                    isCurrentIndex: index == widget.index,
                  );
                  if (hasParts) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        child,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          child: PagesPanel(
                            list: episode.pages,
                            cover: episode.arc?.pic,
                            heroTag: widget.heroTag,
                            ugcIntroController: widget.ugcIntroController!,
                            bvid: episode.bvid ?? IdUtils.av2bv(episode.aid!),
                            cidSet: cidSet,
                            onDownload: (Part part) => _onDownload(
                              index: index,
                              episode: part,
                              parent: episode,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return child;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  late final int? vipStatus = Pref.userInfoCache?.vipStatus;
  @pragma('vm:notify-debugger-on-exception')
  bool _onDownload({
    required int index,
    required ugc.BaseEpisodeItem episode,
    bool isFromList = false,
    bool isDownloadAll = false,
    ugc.EpisodeItem? parent,
  }) {
    final cid = episode.cid;
    // on download
    if (cid == null) {
      SmartDialog.showToast('null cid');
      return false;
    }

    if (cidSet.contains(cid)) {
      if (kDebugMode) {
        SmartDialog.showToast('downloded');
      }
      return false;
    }

    if (kReleaseMode && episode.badge == '会员') {
      if (vipStatus != 1) {
        if (!isDownloadAll) {
          SmartDialog.showToast('需要大会员');
        }
        return false;
      }
    }

    if (episode is ugc.EpisodeItem && episode.pages!.length > 1) {
      if (isFromList && kDebugMode) {
        SmartDialog.showToast('hasParts');
      }
      if (isDownloadAll) {
        for (int i = 0; i < episode.pages!.length; i++) {
          _onDownload(
            index: i,
            episode: episode.pages![i],
            parent: episode,
          );
        }
        return true;
      }
      return false;
    }

    try {
      switch (episode) {
        case Part part:
          _downloadService.downloadVideo(
            part,
            parent == null ? widget.videoDetail : null,
            parent,
            _quality,
          );
          break;
        case ugc.EpisodeItem episode:
          _downloadService.downloadVideo(
            episode.pages!.first,
            null,
            episode,
            _quality,
          );
          break;
        case pgc.EpisodeItem episode:
          _downloadService.downloadBangumi(
            index,
            widget.pgcItem!,
            episode,
            _quality,
          );
          break;
      }
      cidSet.add(cid);
      return true;
    } catch (e, s) {
      Utils.reportError(e, s);
      SmartDialog.showToast(e.toString());
    }
    return false;
  }

  Widget _buildItem({
    required ThemeData theme,
    required int index,
    required bool hasParts,
    required bool isCurrentIndex,
    required ugc.BaseEpisodeItem episode,
  }) {
    late String title;
    String? cover;
    num? duration;
    int? pubdate;
    int? view;
    int? danmaku;
    bool? isCharging;
    int? cid;

    switch (episode) {
      case Part part:
        cid = part.cid;
        cover = part.firstFrame ?? widget.videoDetail?.pic;
        title = part.part ?? widget.videoDetail!.title!;
        duration = part.duration;
        pubdate = part.ctime;
        break;
      case ugc.EpisodeItem item:
        cid = item.cid;
        title = item.title!;
        cover = item.arc?.pic;
        duration = item.arc?.duration;
        pubdate = item.arc?.pubdate;
        view = item.arc?.stat?.view;
        danmaku = item.arc?.stat?.danmaku;
        if (item.attribute == 8) {
          isCharging = true;
        }
        break;
      case pgc.EpisodeItem item:
        cid = item.cid;
        title = item.showTitle ?? item.title!;
        cover = item.cover;
        if (item.from == 'pugv') {
          duration = item.duration;
          view = item.play;
        } else {
          duration = item.duration == null ? null : item.duration! ~/ 1000;
        }
        pubdate = item.pubTime;
        break;
    }
    late final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: SizedBox(
        height: 98,
        child: Builder(
          builder: (context) {
            return Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  if (_onDownload(
                    index: index,
                    episode: episode,
                    isFromList: true,
                  )) {
                    (context as Element).markNeedsBuild();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: StyleString.safeSpace,
                    vertical: 5,
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      if (cover?.isNotEmpty == true)
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            NetworkImgLayer(
                              src: cover,
                              width: 140.8,
                              height: 88,
                            ),
                            if (duration != null && duration > 0)
                              PBadge(
                                text: DurationUtils.formatDuration(duration),
                                right: 6.0,
                                bottom: 6.0,
                                type: PBadgeType.gray,
                              ),
                            if (isCharging == true)
                              const PBadge(
                                text: '充电专属',
                                top: 6,
                                right: 6,
                                type: PBadgeType.error,
                              )
                            else if (episode.badge != null)
                              PBadge(
                                text: episode.badge,
                                top: 6,
                                right: 6,
                                type: switch (episode.badge) {
                                  '预告' => PBadgeType.gray,
                                  '限免' => PBadgeType.free,
                                  _ => PBadgeType.primary,
                                },
                              ),
                          ],
                        )
                      else if (isCurrentIndex)
                        Image.asset(
                          'assets/images/live.png',
                          color: primary,
                          height: 12,
                          semanticLabel: '正在播放：',
                        ),
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize:
                                          theme.textTheme.bodyMedium!.fontSize,
                                      height: 1.42,
                                      letterSpacing: 0.3,
                                      fontWeight: isCurrentIndex
                                          ? FontWeight.bold
                                          : null,
                                      color: isCurrentIndex ? primary : null,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (pubdate != null)
                                  Text(
                                    DateFormatUtils.format(pubdate),
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1,
                                      color: theme.colorScheme.outline,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                const SizedBox(height: 2),
                                Row(
                                  spacing: 8,
                                  children: [
                                    if (view != null)
                                      StatWidget(
                                        value: view,
                                        type: StatType.play,
                                      ),
                                    if (danmaku != null)
                                      StatWidget(
                                        value: danmaku,
                                        type: StatType.danmaku,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            if (!hasParts && cidSet.contains(cid))
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(
                                  size: 13,
                                  color: theme.colorScheme.secondary.withValues(
                                    alpha: 0.8,
                                  ),
                                  FontAwesomeIcons.circleDown,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme, Color dividerColor) {
    return Container(
      color: theme.hoverColor,
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Row(
        children: [
          _buildBottomBtn(
            text: '缓存全部',
            onTap: () {
              showConfirmDialog(
                context: context,
                title: '确定缓存全部？',
                onConfirm: () {
                  for (int i = 0; i < widget.episodes.length; i++) {
                    _onDownload(
                      index: i,
                      episode: widget.episodes[i],
                      isDownloadAll: true,
                    );
                  }
                  setState(() {});
                },
              );
            },
          ),
          SizedBox(
            height: 20,
            child: VerticalDivider(
              width: 1,
              color: dividerColor,
            ),
          ),
          _buildBottomBtn(
            text: '查看缓存',
            onTap: () => Navigator.of(context).push(
              GetPageRoute(page: () => const DownloadPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBtn({
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
