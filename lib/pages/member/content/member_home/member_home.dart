import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/video_card_v_member_home.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/space/data.dart';
import 'package:PiliPlus/models/space/item.dart';
import 'package:PiliPlus/pages/bangumi/widgets/bangumi_card_v_member_home.dart';
import 'package:PiliPlus/pages/member/content/member_contribute/content/article/widget/item.dart';
import 'package:PiliPlus/pages/member/content/member_contribute/member_contribute_ctr.dart';
import 'package:PiliPlus/pages/member/content/member_home/widget/fav_item.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member_coin/index.dart';
import 'package:PiliPlus/pages/member_like/index.dart';
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

  late final _ctr = Get.find<MemberControllerNew>(tag: widget.heroTag);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildBody(_ctr.loadingState.value);
  }

  Widget _buildBody(LoadingState loadingState) {
    final isVertical = context.orientation == Orientation.portrait;
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => loadingState.response is Data
          ? CustomScrollView(
              slivers: [
                if (loadingState.response?.archive?.item?.isNotEmpty ==
                    true) ...[
                  _videoHeader(
                    title: '视频',
                    param: 'contribute',
                    param1: 'video',
                    count: loadingState.response.archive.count,
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
                            videoItem:
                                loadingState.response.archive.item[index],
                          );
                        },
                        childCount: min(isVertical ? 4 : 8,
                            loadingState.response.archive.item.length),
                      ),
                    ),
                  ),
                ],
                if (loadingState.response?.favourite2?.item?.isNotEmpty ==
                    true) ...[
                  _videoHeader(
                    title: '收藏',
                    param: 'favorite',
                    count: loadingState.response.favourite2.count,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 98,
                      child: MemberFavItem(
                        item: loadingState.response.favourite2.item.first,
                      ),
                    ),
                  ),
                ],
                if (loadingState.response?.coinArchive?.item?.isNotEmpty ==
                    true) ...[
                  _videoHeader(
                    title: '最近投币的视频',
                    param: 'coinArchive',
                    count: loadingState.response.coinArchive.count,
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
                            videoItem:
                                loadingState.response.coinArchive.item[index],
                          );
                        },
                        childCount: min(isVertical ? 2 : 4,
                            loadingState.response.coinArchive.item.length),
                      ),
                    ),
                  ),
                ],
                if (loadingState.response?.likeArchive?.item?.isNotEmpty ==
                    true) ...[
                  _videoHeader(
                    title: '最近点赞的视频',
                    param: 'likeArchive',
                    count: loadingState.response.likeArchive.count,
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
                            videoItem:
                                loadingState.response.likeArchive.item[index],
                          );
                        },
                        childCount: min(isVertical ? 2 : 4,
                            loadingState.response.likeArchive.item.length),
                      ),
                    ),
                  ),
                ],
                if (loadingState.response?.article?.item?.isNotEmpty ==
                    true) ...[
                  _videoHeader(
                    title: '专栏',
                    param: 'contribute',
                    param1: 'article',
                    count: loadingState.response.article.count,
                  ),
                  SliverGrid(
                    gridDelegate: Grid.videoCardHDelegate(context),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return MemberArticleItem(
                          item: loadingState.response.article.item[index],
                        );
                      },
                      childCount: isVertical
                          ? 1
                          : loadingState.response.article.item.length,
                    ),
                  ),
                ],
                if (loadingState.response?.audios?.item?.isNotEmpty ==
                    true) ...[
                  _videoHeader(
                    title: '音频',
                    param: 'contribute',
                    param1: 'audio',
                    count: loadingState.response.audios.count,
                  ),
                  // TODO
                ],
                if (loadingState.response?.season?.item?.isNotEmpty ==
                    true) ...[
                  _videoHeader(
                    title: '追番',
                    param: 'bangumi',
                    count: loadingState.response.season.count,
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
                            bangumiItem:
                                loadingState.response.season.item[index],
                          );
                        },
                        childCount: min(isVertical ? 3 : 6,
                            loadingState.response.season.item.length),
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
  }) =>
      SliverToBoxAdapter(
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
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outline,
                      ),
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
                      List<Item> items = _ctr.tab2!
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
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.top,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outline,
                        ),
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
