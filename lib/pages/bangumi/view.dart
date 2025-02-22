import 'dart:async';

import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/tab_type.dart';
import 'package:PiliPlus/pages/bangumi/pgc_index/pgc_index_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/pages/home/index.dart';
import 'package:PiliPlus/pages/main/index.dart';

import '../../utils/grid.dart';
import 'controller.dart';
import 'widgets/bangumi_card_v.dart';
import 'package:PiliPlus/common/widgets/spring_physics.dart';

class BangumiPage extends StatefulWidget {
  const BangumiPage({
    super.key,
    required this.tabType,
  });

  final TabType tabType;

  @override
  State<BangumiPage> createState() => _BangumiPageState();
}

class _BangumiPageState extends State<BangumiPage>
    with AutomaticKeepAliveClientMixin {
  late final BangumiController _bangumiController = Get.put(
    BangumiController(tabType: widget.tabType),
    tag: widget.tabType.name,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    StreamController<bool> mainStream =
        Get.find<MainController>().bottomBarStream;
    StreamController<bool> searchBarStream =
        Get.find<HomeController>().searchBarStream;
    _bangumiController.scrollController.addListener(
      () async {
        final ScrollDirection direction =
            _bangumiController.scrollController.position.userScrollDirection;
        if (direction == ScrollDirection.forward) {
          mainStream.add(true);
          searchBarStream.add(true);
        } else if (direction == ScrollDirection.reverse) {
          mainStream.add(false);
          searchBarStream.add(false);
        }
      },
    );
  }

  @override
  void dispose() {
    _bangumiController.scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: () async {
        await Future.wait([
          _bangumiController.onRefresh(),
          _bangumiController.queryBangumiFollow(),
        ]);
      },
      child: CustomScrollView(
        controller: _bangumiController.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Obx(
              () => _bangumiController.isLogin.value
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Text(
                                  '最近${widget.tabType == TabType.bangumi ? '追番' : '追剧'}${_bangumiController.followCount.value == -1 ? '' : ' ${_bangumiController.followCount.value}'}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              IconButton(
                                tooltip: '刷新',
                                onPressed: () {
                                  _bangumiController
                                    ..followPage = 1
                                    ..followEnd = false
                                    ..queryBangumiFollow();
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Grid.smallCardWidth / 2 / 0.75 +
                              MediaQuery.textScalerOf(context).scale(50),
                          child: Obx(
                            () => _buildFollowBody(
                                _bangumiController.followState.value),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          SliverToBoxAdapter(
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
                    onTap: () {
                      if (widget.tabType == TabType.bangumi) {
                        Get.to(PgcIndexPage());
                      } else {
                        List titles = const ['全部', '电影', '电视剧', '纪录片', '综艺'];
                        List types = const [102, 2, 5, 3, 7];
                        Get.to(
                          Scaffold(
                            appBar: AppBar(title: const Text('索引')),
                            body: DefaultTabController(
                              length: types.length,
                              child: Column(
                                children: [
                                  TabBar(
                                      tabs: titles
                                          .map((title) => Tab(text: title))
                                          .toList()),
                                  Expanded(
                                    child: TabBarView(
                                        physics: customTabBarViewScrollPhysics,
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
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                StyleString.safeSpace, 0, StyleString.safeSpace, 0),
            sliver: Obx(
              () => _buildBody(_bangumiController.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => const SliverToBoxAdapter(),
      Success() => (loadingState.response as List?)?.isNotEmpty == true
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
                  if (index == loadingState.response.length - 1) {
                    _bangumiController.onLoadMore();
                  }
                  return BangumiCardV(
                      bangumiItem: loadingState.response[index]);
                },
                childCount: loadingState.response.length,
              ),
            )
          : HttpError(
              callback: _bangumiController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          callback: _bangumiController.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }

  Widget _buildFollowList(Success loadingState) {
    return ListView.builder(
      controller: _bangumiController.followController,
      scrollDirection: Axis.horizontal,
      itemCount: loadingState.response.length,
      itemBuilder: (context, index) {
        if (index == loadingState.response.length - 1) {
          _bangumiController.queryBangumiFollow(false);
        }
        return Container(
          width: Grid.smallCardWidth / 2,
          margin: EdgeInsets.only(
            left: StyleString.safeSpace,
            right: index == loadingState.response.length - 1
                ? StyleString.safeSpace
                : 0,
          ),
          child: BangumiCardV(
            bangumiItem: loadingState.response[index],
          ),
        );
      },
    );
  }

  Widget _buildFollowBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => (loadingState.response as List?)?.isNotEmpty == true
          ? _buildFollowList(loadingState)
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
      LoadingState() => throw UnimplementedError(),
    };
  }
}
