import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space/data.dart';
import 'package:PiliPlus/models_new/space/space/tab2.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member_article/widget/item.dart';
import 'package:PiliPlus/pages/member_audio/widgets/item.dart';
import 'package:PiliPlus/pages/member_coin_arc/view.dart';
import 'package:PiliPlus/pages/member_comic/widgets/item.dart';
import 'package:PiliPlus/pages/member_contribute/controller.dart';
import 'package:PiliPlus/pages/member_home/widgets/fav_item.dart';
import 'package:PiliPlus/pages/member_home/widgets/video_card_v_member_home.dart';
import 'package:PiliPlus/pages/member_like_arc/view.dart';
import 'package:PiliPlus/pages/member_pgc/widgets/pgc_card_v_member_pgc.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class MemberHome extends StatefulWidget {
  const MemberHome({super.key, this.heroTag});

  final String? heroTag;

  @override
  State<MemberHome> createState() => _MemberHomeState();
}

class _MemberHomeState extends State<MemberHome>
    with AutomaticKeepAliveClientMixin, GridMixin {
  @override
  bool get wantKeepAlive => true;

  late final _ctr = Get.find<MemberController>(tag: widget.heroTag);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildBody(_ctr.loadingState.value);
  }

  late final gridDelegateV = SliverGridDelegateWithExtentAndRatio(
    mainAxisSpacing: StyleString.cardSpace,
    crossAxisSpacing: StyleString.cardSpace,
    maxCrossAxisExtent: Grid.smallCardWidth,
    childAspectRatio: StyleString.aspectRatio,
    mainAxisExtent: MediaQuery.textScalerOf(context).scale(55),
  );

  late final gridDelegateAudio = SliverGridDelegateWithExtentAndRatio(
    mainAxisSpacing: 2,
    maxCrossAxisExtent: Grid.smallCardWidth * 2,
    childAspectRatio: StyleString.aspectRatio * 2.6,
    minHeight: MediaQuery.textScalerOf(context).scale(90),
  );

  late final gridDelegatePgc = SliverGridDelegateWithExtentAndRatio(
    mainAxisSpacing: StyleString.cardSpace,
    crossAxisSpacing: StyleString.cardSpace,
    maxCrossAxisExtent: Grid.smallCardWidth * 0.6,
    childAspectRatio: 0.75,
    mainAxisExtent: MediaQuery.textScalerOf(context).scale(52),
  );

  Widget _buildBody(LoadingState<SpaceData?> loadingState) {
    final isVertical = context.width < 600;
    final setting = _ctr.spaceSetting;
    final isOwner = setting != null;
    final color = Theme.of(context).colorScheme.outline;
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success(response: final res) =>
        res != null
            ? CustomScrollView(
                slivers: [
                  if (res.archive?.item?.isNotEmpty == true) ...[
                    _header(
                      color,
                      title: '视频',
                      param: 'contribute',
                      param1: 'video',
                      count: res.archive!.count!,
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StyleString.safeSpace,
                      ),
                      sliver: SliverGrid.builder(
                        gridDelegate: gridDelegateV,
                        itemBuilder: (context, index) {
                          return VideoCardVMemberHome(
                            videoItem: res.archive!.item![index],
                          );
                        },
                        itemCount: min(
                          isVertical ? 4 : 8,
                          res.archive!.item!.length,
                        ),
                      ),
                    ),
                  ],
                  if (res.favourite2?.item?.isNotEmpty == true) ...[
                    _header(
                      color,
                      title: '收藏',
                      param: 'favorite',
                      count: res.favourite2!.count!,
                      visible: isOwner ? setting.favVideo == 1 : null,
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
                    _header(
                      color,
                      title: '最近投币的视频',
                      param: 'coinArchive',
                      count: res.coinArchive!.count!,
                      visible: isOwner ? setting.coinsVideo == 1 : null,
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StyleString.safeSpace,
                      ),
                      sliver: SliverGrid.builder(
                        gridDelegate: gridDelegateV,
                        itemBuilder: (context, index) {
                          return VideoCardVMemberHome(
                            videoItem: res.coinArchive!.item![index],
                          );
                        },
                        itemCount: min(
                          isVertical ? 2 : 4,
                          res.coinArchive!.item!.length,
                        ),
                      ),
                    ),
                  ],
                  if (res.likeArchive?.item?.isNotEmpty == true) ...[
                    _header(
                      color,
                      title: '最近点赞的视频',
                      param: 'likeArchive',
                      count: res.likeArchive!.count!,
                      visible: isOwner ? setting.likesVideo == 1 : null,
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StyleString.safeSpace,
                      ),
                      sliver: SliverGrid.builder(
                        gridDelegate: gridDelegateV,
                        itemBuilder: (context, index) {
                          return VideoCardVMemberHome(
                            videoItem: res.likeArchive!.item![index],
                          );
                        },
                        itemCount: min(
                          isVertical ? 2 : 4,
                          res.likeArchive!.item!.length,
                        ),
                      ),
                    ),
                  ],
                  if (res.article?.item?.isNotEmpty == true) ...[
                    _header(
                      color,
                      title: '图文',
                      param: 'contribute',
                      param1: 'opus',
                      count: res.article!.count!,
                    ),
                    SliverGrid.builder(
                      gridDelegate: gridDelegate,
                      itemBuilder: (context, index) {
                        return MemberArticleItem(
                          item: res.article!.item![index],
                        );
                      },
                      itemCount: isVertical ? 1 : res.article!.item!.length,
                    ),
                  ],
                  if (res.audios?.item?.isNotEmpty == true) ...[
                    _header(
                      color,
                      title: '音频',
                      param: 'contribute',
                      param1: 'audio',
                      count: res.audios!.count!,
                    ),
                    SliverGrid.builder(
                      gridDelegate: gridDelegateAudio,
                      itemBuilder: (context, index) {
                        return MemberAudioItem(
                          item: res.audios!.item![index],
                        );
                      },
                      itemCount: isVertical ? 1 : min(2, res.audios!.count!),
                    ),
                  ],
                  if (res.comic?.item?.isNotEmpty == true) ...[
                    _header(
                      color,
                      title: '漫画',
                      param: 'contribute',
                      param1: 'comic',
                      count: res.comic!.count!,
                    ),
                    SliverGrid.builder(
                      gridDelegate: gridDelegate,
                      itemBuilder: (context, index) {
                        return MemberComicItem(item: res.comic!.item![index]);
                      },
                      itemCount: isVertical ? 1 : min(2, res.comic!.count!),
                    ),
                  ],
                  if (res.season?.item?.isNotEmpty == true) ...[
                    _header(
                      color,
                      title: '追番',
                      param: 'bangumi',
                      count: res.season!.count!,
                      visible: isOwner ? setting.bangumi == 1 : null,
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StyleString.safeSpace,
                      ),
                      sliver: SliverGrid.builder(
                        gridDelegate: gridDelegatePgc,
                        itemBuilder: (context, index) {
                          return PgcCardVMemberPgc(
                            item: res.season!.item![index],
                          );
                        },
                        itemCount: min(
                          isVertical ? 3 : 6,
                          res.season!.item!.length,
                        ),
                      ),
                    ),
                  ],
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100 + MediaQuery.viewPaddingOf(context).bottom,
                    ),
                  ),
                ],
              )
            : scrollErrorWidget(),
      Error(:var errMsg) => scrollErrorWidget(errMsg: errMsg),
    };
  }

  Widget _header(
    Color color, {
    required String title,
    required String param,
    String? param1,
    required int count,
    bool? visible,
  }) {
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
                  if (visible != null)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          visible == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 17,
                          color: color,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
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
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '查看更多',
                      style: TextStyle(color: color),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
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
