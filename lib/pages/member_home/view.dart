import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_v_member_home.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/space/data.dart';
import 'package:PiliPlus/models/space/item.dart';
import 'package:PiliPlus/pages/bangumi/widgets/bangumi_card_v_member_home.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member_article/widget/item.dart';
import 'package:PiliPlus/pages/member_coin/view.dart';
import 'package:PiliPlus/pages/member_contribute/controller.dart';
import 'package:PiliPlus/pages/member_home/widget/fav_item.dart';
import 'package:PiliPlus/pages/member_like/view.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

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

  late final _ctr = Get.find<MemberController>(tag: widget.heroTag);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildBody(_ctr.loadingState.value);
  }

  Widget _buildBody(LoadingState<SpaceData?> loadingState) {
    final isVertical = context.orientation == Orientation.portrait;
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success(response: final res) => res != null
          ? CustomScrollView(
              slivers: [
                if (res.archive?.item?.isNotEmpty == true) ...[
                  _videoHeader(
                    title: '视频',
                    param: 'contribute',
                    param1: 'video',
                    count: res.archive!.count!,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StyleString.safeSpace,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithExtentAndRatio(
                        mainAxisSpacing: StyleString.cardSpace,
                        crossAxisSpacing: StyleString.cardSpace,
                        maxCrossAxisExtent: Grid.smallCardWidth,
                        childAspectRatio: StyleString.aspectRatio,
                        mainAxisExtent:
                            MediaQuery.textScalerOf(context).scale(55),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return VideoCardVMemberHome(
                            videoItem: res.archive!.item![index],
                          );
                        },
                        childCount:
                            min(isVertical ? 4 : 8, res.archive!.item!.length),
                      ),
                    ),
                  ),
                ],
                if (res.favourite2?.item?.isNotEmpty == true) ...[
                  _videoHeader(
                    title: '收藏',
                    param: 'favorite',
                    count: res.favourite2!.count!,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 98,
                      child: MemberFavItem(
                        item: res.favourite2!.item!.first,
                      ),
                    ),
                  ),
                ],
                if (res.coinArchive?.item?.isNotEmpty == true) ...[
                  _videoHeader(
                    title: '最近投币的视频',
                    param: 'coinArchive',
                    count: res.coinArchive!.count!,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StyleString.safeSpace,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithExtentAndRatio(
                        mainAxisSpacing: StyleString.cardSpace,
                        crossAxisSpacing: StyleString.cardSpace,
                        maxCrossAxisExtent: Grid.smallCardWidth,
                        childAspectRatio: StyleString.aspectRatio,
                        mainAxisExtent:
                            MediaQuery.textScalerOf(context).scale(55),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return VideoCardVMemberHome(
                            videoItem: res.coinArchive!.item![index],
                          );
                        },
                        childCount: min(
                            isVertical ? 2 : 4, res.coinArchive!.item!.length),
                      ),
                    ),
                  ),
                ],
                if (res.likeArchive?.item?.isNotEmpty == true) ...[
                  _videoHeader(
                    title: '最近点赞的视频',
                    param: 'likeArchive',
                    count: res.likeArchive!.count!,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StyleString.safeSpace,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithExtentAndRatio(
                        mainAxisSpacing: StyleString.cardSpace,
                        crossAxisSpacing: StyleString.cardSpace,
                        maxCrossAxisExtent: Grid.smallCardWidth,
                        childAspectRatio: StyleString.aspectRatio,
                        mainAxisExtent:
                            MediaQuery.textScalerOf(context).scale(55),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return VideoCardVMemberHome(
                            videoItem: res.likeArchive!.item![index],
                          );
                        },
                        childCount: min(
                            isVertical ? 2 : 4, res.likeArchive!.item!.length),
                      ),
                    ),
                  ),
                ],
                if (res.article?.item?.isNotEmpty == true) ...[
                  _videoHeader(
                    title: '专栏',
                    param: 'contribute',
                    param1: 'article',
                    count: res.article!.count!,
                  ),
                  SliverGrid(
                    gridDelegate: Grid.videoCardHDelegate(context),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return MemberArticleItem(
                          item: res.article!.item![index],
                        );
                      },
                      childCount: isVertical ? 1 : res.article!.item!.length,
                    ),
                  ),
                ],
                if (res.audios?.item?.isNotEmpty == true) ...[
                  _videoHeader(
                    title: '音频',
                    param: 'contribute',
                    param1: 'audio',
                    count: res.audios!.count!,
                  ),
                  // TODO
                ],
                if (res.season?.item?.isNotEmpty == true) ...[
                  _videoHeader(
                    title: '追番',
                    param: 'bangumi',
                    count: res.season!.count!,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StyleString.safeSpace,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithExtentAndRatio(
                        mainAxisSpacing: StyleString.cardSpace,
                        crossAxisSpacing: StyleString.cardSpace,
                        maxCrossAxisExtent: Grid.smallCardWidth / 3 * 2,
                        childAspectRatio: 0.75,
                        mainAxisExtent:
                            MediaQuery.textScalerOf(context).scale(52),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return BangumiCardVMemberHome(
                            bangumiItem: res.season!.item![index],
                          );
                        },
                        childCount:
                            min(isVertical ? 3 : 6, res.season!.item!.length),
                      ),
                    ),
                  ),
                ],
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 80 + MediaQuery.of(context).padding.bottom,
                  ),
                ),
              ],
            )
          : errorWidget(),
      Error() => errorWidget(),
    };
  }

  Widget _videoHeader({
    required String title,
    required String param,
    String? param1,
    required int count,
  }) {
    final color = Theme.of(context).colorScheme.outline;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$title '),
                  TextSpan(
                    text: count.toString(),
                    style: TextStyle(fontSize: 13, color: color),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                int index =
                    _ctr.tab2!.indexWhere((item) => item.param == param);
                if (index != -1) {
                  if (['video', 'article', 'audio'].contains(param1)) {
                    List<SpaceItem> items = _ctr.tab2!
                        .firstWhere((item) => item.param == param)
                        .items!;
                    int index1 =
                        items.indexWhere((item) => item.param == param1);
                    try {
                      final contributeCtr =
                          Get.find<MemberContributeCtr>(tag: widget.heroTag);
                      // contributeCtr.tabController?.animateTo(index1);
                      if (contributeCtr.tabController?.index != index1) {
                        contributeCtr.tabController?.index = index1;
                      }
                      debugPrint('initialized');
                    } catch (e) {
                      _ctr.contributeInitialIndex.value = index1;
                      debugPrint('not initialized');
                    }
                  }
                  _ctr.tabController?.animateTo(index);
                } else {
                  if (param == 'coinArchive') {
                    Get.to(MemberCoinPage(
                      mid: _ctr.mid,
                      name: _ctr.username,
                    ));
                    return;
                  }

                  if (param == 'likeArchive') {
                    Get.to(MemberLikePage(
                      mid: _ctr.mid,
                      name: _ctr.username,
                    ));
                    return;
                  }

                  // else TODO
                  SmartDialog.showToast('view $param');
                }
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '查看更多',
                      style: TextStyle(color: color),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: color,
                      ),
                      style: TextStyle(fontSize: 13, color: color),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
