import 'dart:async';

import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';
import 'package:PiliPlus/models_new/video/video_detail/section.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO refa
class SeasonPanel extends StatefulWidget {
  const SeasonPanel({
    super.key,
    required this.heroTag,
    required this.showEpisodes,
    this.canTap = true,
    required this.ugcIntroController,
  });
  final String heroTag;
  final Function showEpisodes;
  final bool canTap;
  final UgcIntroController ugcIntroController;

  @override
  State<SeasonPanel> createState() => _SeasonPanelState();
}

class _SeasonPanelState extends State<SeasonPanel> {
  RxInt currentIndex = 0.obs;
  late VideoDetailController _videoDetailController;
  StreamSubscription? _listener;
  List<EpisodeItem> episodes = <EpisodeItem>[];

  UgcIntroController get ugcIntroController => widget.ugcIntroController;
  VideoDetailData get videoDetail =>
      widget.ugcIntroController.videoDetail.value;

  @override
  void initState() {
    super.initState();
    _videoDetailController = Get.find<VideoDetailController>(
      tag: widget.heroTag,
    );

    _videoDetailController.seasonCid = ugcIntroController.cid.value != 0
        ? (videoDetail.pages?.isNotEmpty == true
              ? videoDetail.isPageReversed
                    ? videoDetail.pages!.last.cid
                    : videoDetail.pages!.first.cid
              : ugcIntroController.cid.value)
        : videoDetail.isPageReversed
        ? videoDetail.pages!.last.cid
        : videoDetail.pages!.first.cid;

    /// 根据 cid 找到对应集，找到对应 episodes
    /// 有多个episodes时，只显示其中一个
    _findEpisode();
    if (episodes.isEmpty) {
      return;
    }

    /// 取对应 season_id 的 episodes
    currentIndex.value = episodes.indexWhere(
      (EpisodeItem e) => e.cid == _videoDetailController.seasonCid,
    );
    _listener = _videoDetailController.cid.listen((int cid) {
      if (_videoDetailController.seasonCid != cid) {
        bool isPart =
            videoDetail.pages?.indexWhere((item) => item.cid == cid) != -1;
        if (!isPart) {
          _videoDetailController.seasonCid = cid;
        }
      }
      _findEpisode();
      currentIndex.value = episodes.indexWhere(
        (EpisodeItem e) => e.cid == _videoDetailController.seasonCid,
      );
    });
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 2,
        right: 2,
      ),
      child: Material(
        color: theme.colorScheme.onInverseSurface,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          onTap: widget.canTap
              ? () => widget.showEpisodes(
                  _videoDetailController.seasonIndex.value,
                  videoDetail.ugcSeason,
                  null,
                  _videoDetailController.bvid,
                  null,
                  _videoDetailController.seasonCid,
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '合集：${videoDetail.ugcSeason!.title!}',
                    style: theme.textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 15),
                Image.asset(
                  'assets/images/live.png',
                  color: theme.colorScheme.primary,
                  height: 12,
                  semanticLabel: "正在播放：",
                ),
                const SizedBox(width: 10),
                Obx(
                  () => Text(
                    '${currentIndex.value + 1}/${episodes.length}',
                    style: theme.textTheme.labelMedium,
                    semanticsLabel:
                        '第${currentIndex.value + 1}集，共${episodes.length}集',
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 13,
                  semanticLabel: '查看',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _findEpisode() {
    final List<SectionItem> sections = videoDetail.ugcSeason!.sections!;
    for (int i = 0; i < sections.length; i++) {
      final List<EpisodeItem> episodesList = sections[i].episodes!;
      for (int j = 0; j < episodesList.length; j++) {
        if (episodesList[j].cid == _videoDetailController.seasonCid) {
          if (_videoDetailController.seasonIndex.value != i) {
            _videoDetailController.seasonIndex.value = i;
          }
          episodes = episodesList;
          break;
        }
      }
    }
  }
}
