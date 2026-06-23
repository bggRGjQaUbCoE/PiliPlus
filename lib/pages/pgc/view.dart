import 'dart:math';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/button/more_btn.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/fav_type.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/list.dart';
import 'package:PiliPlus/models_new/pgc/pgc_timeline/result.dart';
import 'package:PiliPlus/pages/pgc/controller.dart';
import 'package:PiliPlus/pages/pgc/widgets/pgc_card_v.dart';
import 'package:PiliPlus/pages/pgc/widgets/pgc_card_v_timeline.dart';
import 'package:PiliPlus/pages/pgc_index/controller.dart';
import 'package:PiliPlus/pages/pgc_index/view.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PgcPage extends StatelessWidget {
  const PgcPage({
    super.key,
    required this.tabType,
  });

  final HomeTabType tabType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(
      PgcController(tabType: tabType),
      tag: tabType.name,
    );
    return refreshIndicator(
      onRefresh: controller.onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildFollow(theme, controller),
          if (controller.showPgcTimeline)
            SliverToBoxAdapter(
              child: SizedBox(
                height: Grid.smallCardWidth / 2 / 0.75 + 96,
                child: Obx(
                  () => _buildTimeline(
                    theme,
                    controller,
                    controller.timelineState.value,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeline(
    ThemeData theme,
    PgcController controller,
    LoadingState<List<TimelineResult>?> loadingState,
  ) => switch (loadingState) {
    Loading() => m3eLoading,
    Success(:final response) =>
      response != null && response.isNotEmpty
          ? Builder(
              builder: (context) {
                final initialIndex = max(
                  0,
                  response.indexWhere((item) => item.isToday == 1),
                );
                return DefaultTabController(
                  initialIndex: initialIndex,
                  length: response.length,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Text('追番时间表', style: theme.textTheme.titleMedium),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TabBar(
                              dividerHeight: 0,
                              isScrollable: true,
                              tabAlignment: .start,
                              overlayColor: const WidgetStatePropertyAll(
                                Colors.transparent,
                              ),
                              splashFactory: NoSplash.splashFactory,
                              padding: const .only(right: 10),
                              indicatorPadding: const .symmetric(
                                horizontal: 4,
                                vertical: 10,
                              ),
                              indicator: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor:
                                  theme.colorScheme.onSecondaryContainer,
                              labelStyle: const TextStyle(fontSize: 14),
                              dividerColor: Colors.transparent,
                              tabs: response.map(
                                (item) {
                                  return Tab(
                                    text:
                                        '${item.date} ${item.isToday == 1 ? '今天' : '周${const [
                                                '一',
                                                '二',
                                                '三',
                                                '四',
                                                '五',
                                                '六',
                                                '日',
                                              ][item.dayOfWeek! - 1]}'}',
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: response.map((item) {
                            if (item.episodes.isNullOrEmpty) {
                              return const SizedBox.shrink();
                            }
                            return ListView.builder(
                              padding: .zero,
                              scrollDirection: .horizontal,
                              itemCount: item.episodes!.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: Grid.smallCardWidth / 2,
                                  margin: .only(
                                    left: Style.safeSpace,
                                    right: index == item.episodes!.length - 1
                                        ? Style.safeSpace
                                        : 0,
                                  ),
                                  child: PgcCardVTimeline(
                                    item: item.episodes![index],
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const SizedBox.shrink(),
    Error(:final errMsg) => GestureDetector(
      behavior: .opaque,
      onTap: controller.queryPgcTimeline,
      child: Container(
        alignment: .center,
        padding: const .symmetric(horizontal: 16),
        child: Text(errMsg ?? '', textAlign: .center),
      ),
    ),
  };

  Widget _buildFollow(ThemeData theme, PgcController controller) =>
      SliverToBoxAdapter(
        child: Obx(
          () => controller.accountService.isLogin.value
              ? Column(
                  children: [
                    _buildFollowTitle(theme, controller),
                    SizedBox(
                      height: Grid.smallCardWidth / 2 / 0.75 + 50,
                      child: Obx(
                        () => _buildFollowBody(
                          controller,
                          controller.loadingState.value,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      );

  Widget _buildFollowTitle(
    ThemeData theme,
    PgcController controller,
  ) => Padding(
    padding: const .only(left: 16),
    child: Row(
      children: [
        Obx(
          () => Text(
            '最近${tabType == .bangumi ? '追番' : '追剧'}${controller.followCount.value == -1 ? '' : ' ${controller.followCount.value}'}',
            style: theme.textTheme.titleMedium,
          ),
        ),
        const Spacer(),
        _buildIndexBtn(),
        IconButton(
          tooltip: '刷新',
          onPressed: () => controller..onRefresh(),
          icon: const Icon(Icons.refresh, size: 20),
        ),
        Obx(
          () => controller.accountService.isLogin.value
              ? Padding(
                  padding: const .symmetric(horizontal: 10),
                  child: moreTextButton(
                    text: '查看全部',
                    onTap: () => Get.toNamed(
                      '/fav',
                      arguments: tabType == .bangumi
                          ? FavTabType.bangumi.index
                          : FavTabType.cinema.index,
                    ),
                    padding: const .symmetric(vertical: 8),
                    color: theme.colorScheme.secondary,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    ),
  );

  Widget _buildFollowBody(
    PgcController controller,
    LoadingState<List<FavPgcItemModel>?> state,
  ) {
    return switch (state) {
      Loading() => m3eLoading,
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? ListView.builder(
                padding: .zero,
                itemCount: response.length,
                scrollDirection: .horizontal,
                key: PageStorageKey(tabType),
                controller: controller.scrollController,
                itemBuilder: (context, index) {
                  if (index == response.length - 1) {
                    controller.onLoadMore();
                  }
                  return Container(
                    width: Grid.smallCardWidth / 2,
                    margin: .only(
                      left: Style.safeSpace,
                      right: index == response.length - 1 ? Style.safeSpace : 0,
                    ),
                    child: PgcCardV(item: response[index]),
                  );
                },
              )
            : Center(
                child: Text('还没有${tabType == .bangumi ? '追番' : '追剧'}'),
              ),
      Error(:final errMsg) => Container(
        alignment: .center,
        padding: const .symmetric(horizontal: 16),
        child: Text(errMsg ?? '', textAlign: .center),
      ),
    };
  }

  Widget _buildIndexBtn() {
    return IconButton(
      tooltip: '索引',
      onPressed: () {
        if (tabType == .bangumi) {
          Get.to(const PgcIndexPage());
        } else {
          const titles = ['全部', '电影', '电视剧', '纪录片', '综艺'];
          List<int> types = const [102, 2, 5, 3, 7];
          Get.to(
            scaffold(
              appBar: AppBar(title: const Text('索引')),
              body: DefaultTabController(
                length: types.length,
                child: Builder(
                  builder: (context) {
                    return Column(
                      children: [
                        ViewSafeArea(
                          child: TabBar(
                            tabs: titles
                                .map((title) => Tab(text: title))
                                .toList(),
                            onTap: (index) {
                              try {
                                if (!DefaultTabController.of(
                                  context,
                                ).indexIsChanging) {
                                  Get.find<PgcIndexController>(
                                    tag: types[index].toString(),
                                  ).animateToTop();
                                }
                              } catch (_) {}
                            },
                          ),
                        ),
                        Expanded(
                          child: tabBarView(
                            children: types
                                .map(
                                  (type) => PgcIndexPage(indexType: type),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
      icon: const Icon(Icons.filter_list, size: 20),
    );
  }
}
