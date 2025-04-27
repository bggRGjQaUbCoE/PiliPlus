import 'dart:math';

import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/bangumi/list.dart';
import 'package:PiliPlus/models/bangumi/pgc_timeline/result.dart';
import 'package:PiliPlus/models/common/tab_type.dart';
import 'package:PiliPlus/pages/bangumi/pgc_index/pgc_index_page.dart';
import 'package:PiliPlus/pages/bangumi/widgets/bangumi_card_v_timeline.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';

import '../../utils/grid.dart';
import 'controller.dart';
import 'widgets/bangumi_card_v.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';

class BangumiPage extends CommonPage {
  const BangumiPage({
    super.key,
    required this.tabType,
  });

  final TabType tabType;

  @override
  State<BangumiPage> createState() => _BangumiPageState();
}

class _BangumiPageState extends CommonPageState<BangumiPage, BangumiController>
    with AutomaticKeepAliveClientMixin {
  @override
  late BangumiController controller = Get.put(
    BangumiController(tabType: widget.tabType),
    tag: widget.tabType.name,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: () async {
        await controller.onRefresh();
      },
      child: CustomScrollView(
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildFollow,
          if (controller.showPgcTimeline)
            SliverToBoxAdapter(
              child: SizedBox(
                height: Grid.smallCardWidth / 2 / 0.75 +
                    MediaQuery.textScalerOf(context).scale(96),
                child:
                    Obx(() => _buildTimeline(controller.timelineState.value)),
              ),
            ),
          ..._buildRcmd,
        ],
      ),
    );
  }

  late final List<String> weekList = [
    '一',
    '二',
    '三',
    '四',
    '五',
    '六',
    '日',
  ];

  Widget _buildTimeline(LoadingState<List<Result>?> loadingState) =>
      switch (loadingState) {
        Loading() => loadingWidget,
        Success() => loadingState.response?.isNotEmpty == true
            ? Builder(builder: (context) {
                final initialIndex = max(
                    0,
                    loadingState.response!
                        .indexWhere((item) => item.isToday == 1));
                return DefaultTabController(
                  initialIndex: initialIndex,
                  length: loadingState.response!.length,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Text(
                            '追番时间表',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: TabBar(
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                dividerHeight: 0,
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                splashFactory: NoSplash.splashFactory,
                                padding: const EdgeInsets.only(right: 10),
                                indicatorPadding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 10,
                                ),
                                indicator: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                labelStyle: TabBarTheme.of(context)
                                        .labelStyle
                                        ?.copyWith(fontSize: 14) ??
                                    const TextStyle(fontSize: 14),
                                dividerColor: Colors.transparent,
                                tabs: loadingState.response!
                                    .map(
                                      (item) => Tab(
                                        text:
                                            '${item.date} ${item.isToday == 1 ? '今天' : '周${weekList[item.dayOfWeek! - 1]}'}',
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeLeft:
                              context.orientation == Orientation.landscape,
                          child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: loadingState.response!.map((item) {
                                if (item.episodes!.isNullOrEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: item.episodes!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: Grid.smallCardWidth / 2,
                                      margin: EdgeInsets.only(
                                        left: StyleString.safeSpace,
                                        right:
                                            index == item.episodes!.length - 1
                                                ? StyleString.safeSpace
                                                : 0,
                                      ),
                                      child: BangumiCardVTimeline(
                                        item: item.episodes![index],
                                      ),
                                    );
                                  },
                                );
                              }).toList()),
                        ),
                      ),
                    ],
                  ),
                );
              })
            : const SizedBox.shrink(),
        Error() => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: controller.queryPgcTimeline,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                loadingState.errMsg,
                textAlign: TextAlign.center,
              ),
            ),
          ),
      };

  List<Widget> get _buildRcmd => [
        _buildRcmdTitle,
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
              StyleString.safeSpace, 0, StyleString.safeSpace, 0),
          sliver: Obx(
            () => _buildRcmdBody(controller.loadingState.value),
          ),
        ),
      ];

  Widget get _buildRcmdTitle => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 16,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '推荐',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (widget.tabType == TabType.bangumi) {
                    Get.to(PgcIndexPage());
                  } else {
                    List<String> titles = const [
                      '全部',
                      '电影',
                      '电视剧',
                      '纪录片',
                      '综艺',
                    ];
                    List<int> types = const [102, 2, 5, 3, 7];
                    Get.to(
                      Scaffold(
                        appBar: AppBar(title: const Text('索引')),
                        body: DefaultTabController(
                          length: types.length,
                          child: Column(
                            children: [
                              SafeArea(
                                top: false,
                                bottom: false,
                                child: TabBar(
                                    tabs: titles
                                        .map((title) => Tab(text: title))
                                        .toList()),
                              ),
                              Expanded(
                                child: tabBarView(
                                    children: types
                                        .map((type) =>
                                            PgcIndexPage(indexType: type))
                                        .toList()),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '查看更多',
                        strutStyle: StrutStyle(leading: 0, height: 1),
                        style: TextStyle(
                          height: 1,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildRcmdBody(
      LoadingState<List<BangumiListItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => const SliverToBoxAdapter(),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverGrid(
              gridDelegate: SliverGridDelegateWithExtentAndRatio(
                // 行间距
                mainAxisSpacing: StyleString.cardSpace,
                // 列间距
                crossAxisSpacing: StyleString.cardSpace,
                // 最大宽度
                maxCrossAxisExtent: Grid.smallCardWidth / 3 * 2,
                childAspectRatio: 0.75,
                mainAxisExtent: MediaQuery.textScalerOf(context).scale(50),
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == loadingState.response!.length - 1) {
                    controller.onLoadMore();
                  }
                  return BangumiCardV(
                      bangumiItem: loadingState.response![index]);
                },
                childCount: loadingState.response!.length,
              ),
            )
          : HttpError(
              onReload: controller.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: controller.onReload,
        ),
    };
  }

  Widget get _buildFollow => SliverToBoxAdapter(
        child: Obx(
          () => controller.isLogin.value
              ? Column(
                  children: [
                    _buildFollowTitle,
                    SizedBox(
                      height: Grid.smallCardWidth / 2 / 0.75 +
                          MediaQuery.textScalerOf(context).scale(50),
                      child: Obx(
                        () => _buildFollowBody(controller.followState.value),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      );

  Widget get _buildFollowTitle => Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            Obx(
              () => Text(
                '最近${widget.tabType == TabType.bangumi ? '追番' : '追剧'}${controller.followCount.value == -1 ? '' : ' ${controller.followCount.value}'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Spacer(),
            IconButton(
              tooltip: '刷新',
              onPressed: () {
                controller
                  ..followPage = 1
                  ..followEnd = false
                  ..queryBangumiFollow();
              },
              icon: const Icon(
                Icons.refresh,
                size: 20,
              ),
            ),
            Obx(
              () => controller.isLogin.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.toNamed(
                            '/fav',
                            arguments:
                                widget.tabType == TabType.bangumi ? 1 : 2,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '查看全部',
                                strutStyle: StrutStyle(leading: 0, height: 1),
                                style: TextStyle(
                                  height: 1,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );

  Widget _buildFollowBody(
      LoadingState<List<BangumiListItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => loadingState.response?.isNotEmpty == true
          ? MediaQuery.removePadding(
              context: context,
              removeLeft: context.orientation == Orientation.landscape,
              child: ListView.builder(
                controller: controller.followController,
                scrollDirection: Axis.horizontal,
                itemCount: loadingState.response!.length,
                itemBuilder: (context, index) {
                  if (index == loadingState.response!.length - 1) {
                    controller.queryBangumiFollow(false);
                  }
                  return Container(
                    width: Grid.smallCardWidth / 2,
                    margin: EdgeInsets.only(
                      left: StyleString.safeSpace,
                      right: index == loadingState.response!.length - 1
                          ? StyleString.safeSpace
                          : 0,
                    ),
                    child: BangumiCardV(
                      bangumiItem: loadingState.response![index],
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Text(
                  '还没有${widget.tabType == TabType.bangumi ? '追番' : '追剧'}')),
      Error() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Text(
            loadingState.errMsg,
            textAlign: TextAlign.center,
          ),
        ),
    };
  }
}
