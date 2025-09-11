import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/page/tabs.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/episode_panel_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart' as pgc;
import 'package:PiliPlus/models_new/video/video_detail/episode.dart' as ugc;
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/models_new/video/video_relation/data.dart';
import 'package:PiliPlus/pages/common/slide/common_collapse_slide_page.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/page.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' hide TabBarView;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class EpisodePanel extends CommonCollapseSlidePage {
  const EpisodePanel({
    super.key,
    super.enableSlide,
    required this.ugcIntroController,
    required this.heroTag,
    required this.type,
    // required this.count,
    // required this.name,
    required this.aid,
    required this.bvid,
    required this.cid,
    required this.cover,
    this.showTitle = true,
    required this.list,
    this.seasonId,
    this.initialTabIndex = 0,
    this.isSupportReverse,
    this.isReversed,
    this.onReverse,
    required this.onChangeEpisode,
    this.onClose,
  }) : assert(type == EpisodeType.pgc || ugcIntroController != null);

  final UgcIntroController? ugcIntroController;
  final String heroTag;
  final EpisodeType type;
  // final int count;
  // final String name;
  final int? aid;
  final String bvid;
  final int cid;
  final String? cover;
  final bool showTitle;
  final List list;
  final int? seasonId;
  final int initialTabIndex;
  final bool? isSupportReverse;
  final bool? isReversed;
  final ValueChanged<ugc.BaseEpisodeItem> onChangeEpisode;
  final VoidCallback? onReverse;
  final VoidCallback? onClose;

  @override
  State<EpisodePanel> createState() => _EpisodePanelState();
}

class _EpisodePanelState extends CommonCollapseSlidePageState<EpisodePanel> {
  // tab
  late final TabController _tabController = TabController(
    initialIndex: widget.initialTabIndex,
    length: widget.list.length,
    vsync: this,
  )..addListener(listener);
  late final RxInt _currentTabIndex = _tabController.index.obs;

  List get _getCurrEpisodes => widget.type == EpisodeType.season
      ? widget.list[_currentTabIndex.value].episodes
      : widget.list[_currentTabIndex.value];

  // item
  late int _currentItemIndex;
  int get _findCurrentItemIndex => max(
    0,
    _getCurrEpisodes.indexWhere((item) => item.cid == widget.cid),
  );

  late final List<bool> _isReversed;
  late final List<ItemScrollController> _itemScrollController;

  // fav
  Rx<LoadingState>? _favState;

  void listener() {
    _currentTabIndex.value = _tabController.index;
  }

  @override
  void didUpdateWidget(EpisodePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showTitle) {
      return;
    }

    void jumpToCurrent() {
      final newItemIndex = _findCurrentItemIndex;
      if (_currentItemIndex != newItemIndex) {
        _currentItemIndex = newItemIndex;
        try {
          _itemScrollController[_currentTabIndex.value].jumpTo(
            index: newItemIndex,
          );
        } catch (_) {}
      }
    }

    // jump to current
    if (_currentTabIndex.value != widget.initialTabIndex) {
      _tabController.animateTo(
        widget.initialTabIndex,
        duration: const Duration(milliseconds: 200),
      );
      Future.delayed(const Duration(milliseconds: 300), jumpToCurrent);
    } else {
      jumpToCurrent();
    }
  }

  @override
  void initState() {
    super.initState();
    _itemScrollController = List.generate(
      widget.list.length,
      (_) => ItemScrollController(),
    );
    _isReversed = List.filled(widget.list.length, false);

    if (widget.type == EpisodeType.season && Accounts.main.isLogin) {
      _favState = LoadingState.loading().obs;
      VideoHttp.videoRelation(bvid: widget.bvid).then(
        (result) {
          if (result['status']) {
            VideoRelation data = result['data'];
            _favState!.value = Success(data.seasonFav ?? false);
          }
        },
      );
    }

    _currentItemIndex = _findCurrentItemIndex;
  }

  @override
  void init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        isInit = false;
        _itemScrollController[widget.initialTabIndex].jumpTo(
          index: _currentItemIndex,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(listener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget buildPage(ThemeData theme) {
    final isMulti = widget.type == EpisodeType.season && widget.list.length > 1;

    Widget tabbar() => TabBar(
      controller: _tabController,
      padding: const EdgeInsets.only(right: 60),
      isScrollable: true,
      tabs: widget.list.map((item) => Tab(text: item.title)).toList(),
      dividerHeight: 1,
      dividerColor: theme.dividerColor.withValues(alpha: 0.1),
    );

    if (isMulti && enableSlide) {
      return CustomTabBarView(
        controller: _tabController,
        physics: const CustomTabBarViewScrollPhysics(),
        bgColor: theme.colorScheme.surface,
        header: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToolbar(theme),
            tabbar(),
          ],
        ),
        children: List.generate(
          widget.list.length,
          (index) => _buildBody(
            theme,
            index,
            widget.list[index].episodes,
          ),
        ),
      );
    }

    return Material(
      color: widget.showTitle ? theme.colorScheme.surface : null,
      type: widget.showTitle ? MaterialType.canvas : MaterialType.transparency,
      child: Column(
        children: [
          _buildToolbar(theme),
          if (isMulti) ...[
            tabbar(),
            Expanded(
              child: tabBarView(
                controller: _tabController,
                children: List.generate(
                  widget.list.length,
                  (index) => _buildBody(
                    theme,
                    index,
                    widget.list[index].episodes,
                  ),
                ),
              ),
            ),
          ] else
            Expanded(child: enableSlide ? slideList(theme) : buildList(theme)),
        ],
      ),
    );
  }

  @override
  Widget buildList(ThemeData theme) {
    return _buildBody(theme, 0, _getCurrEpisodes);
  }

  Widget _buildBody(ThemeData theme, int tabIndex, List episodes) {
    final isCurrTab = tabIndex == widget.initialTabIndex;
    return KeepAliveWrapper(
      builder: (context) => ScrollablePositionedList.separated(
        padding: EdgeInsets.only(
          top: 7,
          bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
        ),
        reverse: _isReversed[tabIndex],
        itemCount: episodes.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int itemIndex) {
          final ugc.BaseEpisodeItem episode = episodes[itemIndex];
          final isCurrItem = isCurrTab ? itemIndex == _currentItemIndex : false;
          Widget episodeItem = _buildEpisodeItem(
            theme: theme,
            episode: episode,
            index: itemIndex,
            length: episodes.length,
            isCurrentIndex: isCurrItem,
          );
          if (episode is ugc.EpisodeItem &&
              widget.showTitle &&
              episode.pages!.length > 1) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                episodeItem,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: PagesPanel(
                    list: isCurrTab && isCurrItem ? null : episode.pages,
                    cover: episode.arc?.pic,
                    heroTag: widget.heroTag,
                    ugcIntroController: widget.ugcIntroController!,
                    bvid: episode.bvid ?? IdUtils.av2bv(episode.aid!),
                  ),
                ),
              ],
            );
          }
          return episodeItem;
        },
        itemScrollController: _itemScrollController[tabIndex],
        separatorBuilder: (context, index) => const SizedBox(height: 2),
      ),
    );
  }

  Widget _buildEpisodeItem({
    required ThemeData theme,
    required ugc.BaseEpisodeItem episode,
    required int index,
    required int length,
    required bool isCurrentIndex,
  }) {
    late String title;
    String? cover;
    String? bvid;
    num? duration;
    int? pubdate;
    int? view;
    int? danmaku;
    bool? isCharging;

    switch (episode) {
      case Part part:
        cover = part.firstFrame ?? widget.cover;
        title = part.pagePart!;
        duration = part.duration;
        pubdate = part.ctime;
        break;
      case ugc.EpisodeItem item:
        title = item.title!;
        cover = item.arc?.pic;
        bvid = item.bvid;
        duration = item.arc?.duration;
        pubdate = item.arc?.pubdate;
        view = item.arc?.stat?.view;
        danmaku = item.arc?.stat?.danmaku;
        if (item.attribute == 8) {
          isCharging = true;
        }
        break;
      case pgc.EpisodeItem item:
        bvid = item.bvid;
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
    late final Color primary = theme.colorScheme.primary;

    return SizedBox(
      height: 98,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            if (episode.badge == "会员") {
              UserInfoData? userInfo = Pref.userInfoCache;
              int vipStatus = userInfo?.vipStatus ?? 0;
              if (vipStatus != 1) {
                SmartDialog.showToast('需要大会员');
                // return;
              }
            }
            SmartDialog.showToast('切换到：$title');
            widget.onClose?.call();
            if (!widget.showTitle) {
              _currentItemIndex = index;
            }
            widget.onChangeEpisode(episode);
            if (widget.type == EpisodeType.season) {
              try {
                Get.find<VideoDetailController>(
                  tag: widget.ugcIntroController!.heroTag,
                ).seasonCid = episode.cid;
              } catch (_) {}
            }
          },
          onLongPress: () {
            if (cover?.isNotEmpty == true) {
              imageSaveDialog(title: title, cover: cover, bvid: bvid);
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
                    semanticLabel: "正在播放：",
                  ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: theme.textTheme.bodyMedium!.fontSize,
                            height: 1.42,
                            letterSpacing: 0.3,
                            fontWeight: isCurrentIndex ? FontWeight.bold : null,
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
                      if (view != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          spacing: 8,
                          children: [
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavBtn(LoadingState loadingState) {
    return switch (loadingState) {
      Success(:var response) => mediumButton(
        tooltip: response ? '取消订阅' : '订阅',
        icon: response
            ? Icons.notifications_off_outlined
            : Icons.notifications_active_outlined,
        onPressed: () async {
          var result = await FavHttp.seasonFav(
            isFav: response,
            seasonId: widget.seasonId,
          );
          if (result['status']) {
            SmartDialog.showToast('${response ? '取消' : ''}订阅成功');
            _favState!.value = Success(!response);
          } else {
            SmartDialog.showToast(result['msg']);
          }
        },
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget get _buildReverseBtn => mediumButton(
    tooltip: widget.isReversed == true ? '正序播放' : '倒序播放',
    icon: widget.isReversed == true
        ? MdiIcons.sortDescending
        : MdiIcons.sortAscending,
    onPressed: () => widget.onReverse?.call(),
  );

  Widget _buildToolbar(ThemeData theme) => Container(
    height: 45,
    padding: EdgeInsets.symmetric(horizontal: widget.showTitle ? 14 : 6),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
    ),
    child: Row(
      children: [
        if (widget.showTitle)
          Text(
            widget.type.title,
            style: theme.textTheme.titleMedium,
          ),
        if (_favState != null) Obx(() => _buildFavBtn(_favState!.value)),
        mediumButton(
          tooltip: '跳至顶部',
          icon: Icons.vertical_align_top,
          onPressed: () {
            try {
              final currentTabIndex = _currentTabIndex.value;
              _itemScrollController[currentTabIndex].scrollTo(
                index: !_isReversed[currentTabIndex]
                    ? 0
                    : _getCurrEpisodes.length - 1,
                duration: const Duration(milliseconds: 200),
              );
            } catch (e) {
              if (kDebugMode) debugPrint('to top: $e');
            }
          },
        ),
        mediumButton(
          tooltip: '跳至底部',
          icon: Icons.vertical_align_bottom,
          onPressed: () {
            try {
              final currentTabIndex = _currentTabIndex.value;
              _itemScrollController[currentTabIndex].scrollTo(
                index: !_isReversed[currentTabIndex]
                    ? _getCurrEpisodes.length - 1
                    : 0,
                duration: const Duration(milliseconds: 200),
              );
            } catch (e) {
              if (kDebugMode) debugPrint('to bottom: $e');
            }
          },
        ),
        mediumButton(
          tooltip: '跳至当前',
          icon: Icons.my_location,
          onPressed: () async {
            try {
              final currentTabIndex = _currentTabIndex.value;
              if (currentTabIndex != widget.initialTabIndex) {
                _tabController.animateTo(widget.initialTabIndex);
                await Future.delayed(const Duration(milliseconds: 225));
              }
              _itemScrollController[widget.initialTabIndex].scrollTo(
                index: _currentItemIndex,
                duration: const Duration(milliseconds: 200),
              );
            } catch (_) {}
          },
        ),
        if (widget.isSupportReverse == true)
          Obx(
            () {
              return _currentTabIndex.value == widget.initialTabIndex
                  ? _buildReverseBtn
                  : const SizedBox.shrink();
            },
          ),
        const Spacer(),
        Obx(
          () {
            final currentTabIndex = _currentTabIndex.value;
            return mediumButton(
              tooltip: _isReversed[currentTabIndex] ? '顺序' : '倒序',
              icon: !_isReversed[currentTabIndex]
                  ? MdiIcons.sortNumericAscending
                  : MdiIcons.sortNumericDescending,
              onPressed: () => setState(() {
                _isReversed[currentTabIndex] = !_isReversed[currentTabIndex];
              }),
            );
          },
        ),
        if (widget.onClose != null)
          mediumButton(
            tooltip: '关闭',
            icon: Icons.close,
            onPressed: widget.onClose,
          ),
      ],
    ),
  );
}
