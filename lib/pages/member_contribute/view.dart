import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models_new/space/space/tab2.dart';
import 'package:PiliPlus/pages/member_article/view.dart';
import 'package:PiliPlus/pages/member_audio/view.dart';
import 'package:PiliPlus/pages/member_comic/view.dart';
import 'package:PiliPlus/pages/member_contribute/controller.dart';
import 'package:PiliPlus/pages/member_opus/view.dart';
import 'package:PiliPlus/pages/member_season_series/view.dart';
import 'package:PiliPlus/pages/member_video/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberContribute extends StatefulWidget {
  const MemberContribute({
    super.key,
    this.heroTag,
    this.initialIndex,
    required this.mid,
  });

  final String? heroTag;
  final int? initialIndex;
  final int mid;

  @override
  State<MemberContribute> createState() => _MemberContributeState();
}

class _MemberContributeState extends State<MemberContribute>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final _controller = Get.putOrFind(
    () => MemberContributeCtr(
      heroTag: widget.heroTag,
      initialIndex: widget.initialIndex,
    ),
    tag: widget.heroTag,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return _controller.tabs != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                overlayColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
                splashFactory: NoSplash.splashFactory,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                isScrollable: true,
                tabs: _controller.tabs!,
                tabAlignment: TabAlignment.start,
                controller: _controller.tabController,
                dividerHeight: 0,
                indicatorWeight: 0,
                indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 8,
                ),
                indicator: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle:
                    TabBarTheme.of(
                      context,
                    ).labelStyle?.copyWith(fontSize: 14) ??
                    const TextStyle(fontSize: 14),
                labelColor: theme.colorScheme.onSecondaryContainer,
                unselectedLabelColor: theme.colorScheme.outline,
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller.tabController,
                  children: _controller.items!.map(_getPageFromType).toList(),
                ),
              ),
            ],
          )
        : _controller.items?.isNotEmpty == true
        ? _getPageFromType(_controller.items!.first)
        : const SizedBox.shrink();
  }

  Widget _getPageFromType(SpaceTab2Item item) {
    return switch (item.param) {
      'video' => MemberVideo(
        type: ContributeType.video,
        heroTag: widget.heroTag,
        mid: widget.mid,
        title: item.title,
        isSingle: _controller.tabs == null,
      ),
      'charging_video' => MemberVideo(
        type: ContributeType.charging,
        heroTag: widget.heroTag,
        mid: widget.mid,
        title: item.title,
      ),
      'article' => MemberArticle(
        heroTag: widget.heroTag,
        mid: widget.mid,
      ),
      'opus' => MemberOpus(
        isSingle: _controller.tabs == null,
        heroTag: widget.heroTag,
        mid: widget.mid,
      ),
      'audio' => MemberAudio(
        heroTag: widget.heroTag,
        mid: widget.mid,
      ),
      'comic' => MemberComic(
        heroTag: widget.heroTag,
        mid: widget.mid,
      ),
      'season_video' => MemberVideo(
        type: ContributeType.season,
        heroTag: widget.heroTag,
        mid: widget.mid,
        seasonId: item.seasonId,
        title: item.title,
      ),
      'series' => MemberVideo(
        type: ContributeType.series,
        heroTag: widget.heroTag,
        mid: widget.mid,
        seriesId: item.seriesId,
        title: item.title,
      ),
      'ugcSeason' => SeasonSeriesPage(
        mid: widget.mid,
        heroTag: widget.heroTag,
      ),
      _ => Center(child: Text(item.title!)),
    };
  }
}
