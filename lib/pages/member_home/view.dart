import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/button/more_btn.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show platformAlwaysClampingPhysics;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space/data.dart';
import 'package:PiliPlus/models_new/space/space/tab2.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/models_new/space/space_article/item.dart';
import 'package:PiliPlus/models_new/space/space_audio/item.dart';
import 'package:PiliPlus/models_new/space/space_fav/list.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member_article/widget/item.dart';
import 'package:PiliPlus/pages/member_audio/widgets/item.dart';
import 'package:PiliPlus/pages/member_coin_arc/view.dart';
import 'package:PiliPlus/pages/member_comic/widgets/item.dart';
import 'package:PiliPlus/pages/member_contribute/controller.dart';
import 'package:PiliPlus/pages/member_home/widgets/fav_item.dart';
import 'package:PiliPlus/pages/member_home/widgets/video_card_v_member_home.dart';
import 'package:PiliPlus/pages/member_like_arc/view.dart';
import 'package:PiliPlus/pages/member_opus/widgets/opus_grid.dart';
import 'package:PiliPlus/pages/member_pgc/widgets/pgc_card_v_member_pgc.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/rendering.dart'
    show BoxHitTestEntry, BoxHitTestResult, RenderObjectWithChildMixin;
import 'package:flutter/services.dart'
    show
        MouseTrackerAnnotation,
        PointerEnterEventListener,
        PointerExitEventListener;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

part 'package:PiliPlus/pages/member_home/widgets/live_item.dart';

class MemberHome extends StatefulWidget {
  const MemberHome({super.key, this.heroTag});

  final String? heroTag;

  @override
  State<MemberHome> createState() => _MemberHomeState();
}

class _MemberHomeState extends State<MemberHome>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final setting = _ctr.spaceSetting;
  late final isOwner = setting != null;
  late final _ctr = Get.find<MemberController>(tag: widget.heroTag);

  late bool isVertical;
  late ColorScheme colorScheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
    isVertical = MediaQuery.widthOf(context) < 600;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildBody(_ctr.loadingState.value);
  }

  late final gridDelegateV = OpusGridDelegate(
    mainAxisSpacing: Style.cardSpace,
    crossAxisSpacing: Style.cardSpace,
    maxCrossAxisExtent: Grid.smallCardWidth,
    childAspectRatio: Style.aspectRatio,
    mainAxisExtent: MediaQuery.textScalerOf(context).scale(55),
  );

  late final gridDelegateH = OpusGridDelegateFixedMainAxisExtent(
    mainAxisSpacing: 2,
    mainAxisExtent: 110,
    maxCrossAxisExtent: Grid.smallCardWidth * 2,
  );

  late final gridDelegatePgc = OpusGridDelegate(
    mainAxisSpacing: Style.cardSpace,
    crossAxisSpacing: Style.cardSpace,
    maxCrossAxisExtent: Grid.smallCardWidth * 0.6,
    childAspectRatio: 0.75,
    mainAxisExtent: MediaQuery.textScalerOf(context).scale(52),
  );

  Widget _buildBody(LoadingState<SpaceData?> loadingState) {
    switch (loadingState) {
      case Loading():
        return m3eLoading;
      case Success(:final response):
        if (response == null) return scrollableError;

        final archives = response.archive?.item;
        final favourites = response.favourite2?.item;
        final coinArchives = response.coinArchive?.item;
        final likeArchives = response.likeArchive?.item;
        final articles = response.article?.item;
        final audios = response.audios?.item;
        final comics = response.comic?.item;
        final seasons = response.season?.item;

        return CustomScrollView(
          physics: platformAlwaysClampingPhysics,
          slivers: [
            if (archives != null && archives.isNotEmpty)
              ..._buildArchive(response.archive!.count!, archives),
            if (favourites != null && favourites.isNotEmpty)
              ..._buildFavourite(response.favourite2!.count!, favourites),
            if (coinArchives != null && coinArchives.isNotEmpty)
              ..._buildCoinArchive(response.coinArchive!.count!, coinArchives),
            if (likeArchives != null && likeArchives.isNotEmpty)
              ..._buildLikeArchive(response.likeArchive!.count!, likeArchives),
            if (articles != null && articles.isNotEmpty)
              ..._buildArticle(response.article!.count!, articles),
            if (audios != null && audios.isNotEmpty)
              ..._buildAudio(response.audios!.count!, audios),
            if (comics != null && comics.isNotEmpty)
              ..._buildComic(response.comic!.count!, comics),
            if (seasons != null && seasons.isNotEmpty)
              ..._buildSeason(response.season!.count!, seasons),
            ?_buildLiveItem,
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100 + MediaQuery.viewPaddingOf(context).bottom,
              ),
            ),
          ],
        );
      case Error(:final errMsg):
        return scrollErrorWidget(errMsg: errMsg);
    }
  }

  Widget? get _buildLiveItem {
    final live = _ctr.live;
    if (live != null && live.roomStatus == 1 && live.liveStatus != 1) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const .only(top: 20),
          child: _LiveItem(
            color: colorScheme.surfaceContainerHigh,
            child: GestureDetector(
              behavior: .opaque,
              onTap: () => PageUtils.toLiveRoom(live.roomid),
              child: Padding(
                padding: const .symmetric(vertical: 11),
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: .middle,
                        child: Icon(
                          size: 18,
                          Icons.bar_chart_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const TextSpan(text: ' TA现在并没有直播，去TA直播间'),
                    ],
                  ),
                  textAlign: .center,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return null;
  }

  Widget _header({
    required String title,
    required String param,
    String? param1,
    required int count,
    bool? visible,
  }) {
    final outline = colorScheme.outline;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const .symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$title '),
                  TextSpan(
                    text: count.toString(),
                    style: TextStyle(fontSize: 13, color: outline),
                  ),
                  if (visible != null)
                    WidgetSpan(
                      alignment: .middle,
                      child: Padding(
                        padding: const .only(left: 10),
                        child: Icon(
                          visible ? Icons.visibility : Icons.visibility_off,
                          size: 17,
                          color: outline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            moreTextButton(
              onTap: () {
                int index = _ctr.tab2!.indexWhere(
                  (item) => item.param == param,
                );
                if (index != -1) {
                  if (const [
                    'video',
                    'opus',
                    'audio',
                    'comic',
                  ].contains(param1)) {
                    List<SpaceTab2Item> items = _ctr.tab2!
                        .firstWhere((item) => item.param == param)
                        .items!;
                    int index1 = items.indexWhere(
                      (item) => item.param == param1,
                    );
                    if (index1 != -1) {
                      try {
                        final contributeCtr = Get.find<MemberContributeCtr>(
                          tag: widget.heroTag,
                        );
                        // contributeCtr.tabController?.animateTo(index1);
                        if (contributeCtr.tabController?.index != index1) {
                          contributeCtr.tabController?.index = index1;
                        }
                        // if (kDebugMode) debugPrint('initialized');
                      } catch (e) {
                        _ctr.contributeInitialIndex.value = index1;
                        // if (kDebugMode) debugPrint('not initialized');
                      }
                    }
                  }
                  _ctr.tabController?.animateTo(index);
                } else {
                  if (param == 'coinArchive') {
                    Get.to(
                      MemberCoinArcPage(
                        mid: _ctr.mid,
                        name: _ctr.username,
                      ),
                    );
                    return;
                  }

                  if (param == 'likeArchive') {
                    Get.to(
                      MemberLikeArcPage(
                        mid: _ctr.mid,
                        name: _ctr.username,
                      ),
                    );
                    return;
                  }

                  // else TODO
                  SmartDialog.showToast('view $param');
                }
              },
              color: outline,
            ),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> _buildArchive(
    int count,
    List<SpaceArchiveItem> archives,
  ) sync* {
    yield _header(
      title: '视频',
      param: 'contribute',
      param1: 'video',
      count: count,
    );
    yield SliverToBoxAdapter(
      child: Padding(
        padding: const .symmetric(horizontal: Style.safeSpace),
        child: OpusGridBuilder(
          childCount: archives.length,
          gridDelegate: gridDelegateV,
          builder: (context, opusGridInfo) => archives
              .take(
                isVertical
                    ? opusGridInfo.crossAxisCount * 2
                    : opusGridInfo.crossAxisCount,
              )
              .map(VideoCardVMemberHome.new)
              .toList(),
        ),
      ),
    );
  }

  Iterable<Widget> _buildFavourite(
    int count,
    List<SpaceFavItemModel> favourites,
  ) sync* {
    yield _header(
      title: '收藏',
      param: 'favorite',
      count: count,
      visible: isOwner ? setting!.favVideo == 1 : null,
    );
    yield SliverToBoxAdapter(
      child: OpusGridBuilder(
        gridDelegate: gridDelegateH,
        childCount: favourites.length,
        builder: (context, opusGridInfo) => favourites
            .take(opusGridInfo.crossAxisCount)
            .map(MemberFavItem.new)
            .toList(),
      ),
    );
  }

  Iterable<Widget> _buildCoinArchive(
    int count,
    List<SpaceArchiveItem> coinArchives,
  ) sync* {
    yield _header(
      title: '最近投币的视频',
      param: 'coinArchive',
      count: count,
      visible: isOwner ? setting!.coinsVideo == 1 : null,
    );
    yield SliverToBoxAdapter(
      child: Padding(
        padding: const .symmetric(horizontal: Style.safeSpace),
        child: OpusGridBuilder(
          gridDelegate: gridDelegateV,
          childCount: coinArchives.length,
          builder: (context, opusGridInfo) => coinArchives
              .take(opusGridInfo.crossAxisCount)
              .map(VideoCardVMemberHome.new)
              .toList(),
        ),
      ),
    );
  }

  Iterable<Widget> _buildLikeArchive(
    int count,
    List<SpaceArchiveItem> likeArchives,
  ) sync* {
    yield _header(
      title: '最近点赞的视频',
      param: 'likeArchive',
      count: count,
      visible: isOwner ? setting!.likesVideo == 1 : null,
    );
    yield SliverToBoxAdapter(
      child: Padding(
        padding: const .symmetric(horizontal: Style.safeSpace),
        child: OpusGridBuilder(
          gridDelegate: gridDelegateV,
          childCount: likeArchives.length,
          builder: (context, opusGridInfo) => likeArchives
              .take(opusGridInfo.crossAxisCount)
              .map(VideoCardVMemberHome.new)
              .toList(),
        ),
      ),
    );
  }

  Iterable<Widget> _buildArticle(
    int count,
    List<SpaceArticleItem> articles,
  ) sync* {
    yield _header(
      title: '图文',
      param: 'contribute',
      param1: 'opus',
      count: count,
    );
    yield SliverToBoxAdapter(
      child: OpusGridBuilder(
        gridDelegate: gridDelegateH,
        childCount: articles.length,
        builder: (context, opusGridInfo) => articles
            .take(opusGridInfo.crossAxisCount)
            .map(MemberArticleItem.new)
            .toList(),
      ),
    );
  }

  Iterable<Widget> _buildAudio(int count, List<SpaceAudioItem> audios) sync* {
    yield _header(
      title: '音频',
      param: 'contribute',
      param1: 'audio',
      count: count,
    );
    yield SliverToBoxAdapter(
      child: OpusGridBuilder(
        gridDelegate: gridDelegateH,
        childCount: audios.length,
        builder: (context, opusGridInfo) => audios
            .take(opusGridInfo.crossAxisCount)
            .map(MemberAudioItem.new)
            .toList(),
      ),
    );
  }

  Iterable<Widget> _buildComic(int count, List<SpaceArchiveItem> comics) sync* {
    yield _header(
      title: '漫画',
      param: 'contribute',
      param1: 'comic',
      count: count,
    );
    yield SliverToBoxAdapter(
      child: OpusGridBuilder(
        gridDelegate: gridDelegateH,
        childCount: comics.length,
        builder: (context, opusGridInfo) => comics
            .take(opusGridInfo.crossAxisCount)
            .map(MemberComicItem.new)
            .toList(),
      ),
    );
  }

  Iterable<Widget> _buildSeason(
    int count,
    List<SpaceArchiveItem> seasons,
  ) sync* {
    yield _header(
      title: '追番',
      param: 'bangumi',
      count: count,
      visible: isOwner ? setting!.bangumi == 1 : null,
    );
    yield SliverToBoxAdapter(
      child: Padding(
        padding: const .symmetric(horizontal: Style.safeSpace),
        child: OpusGridBuilder(
          gridDelegate: gridDelegatePgc,
          childCount: seasons.length,
          builder: (context, opusGridInfo) => seasons
              .take(opusGridInfo.crossAxisCount)
              .map(PgcCardVMemberPgc.new)
              .toList(),
        ),
      ),
    );
  }
}
