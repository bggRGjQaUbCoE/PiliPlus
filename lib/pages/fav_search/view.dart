import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/follow/widgets/follow_item.dart';
import 'package:PiliPlus/pages/history/widgets/item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/pages/fav_detail/widget/fav_video_card.dart';

import 'controller.dart';

enum SearchType { fav, follow, history }

class FavSearchPage extends StatefulWidget {
  const FavSearchPage({super.key});

  @override
  State<FavSearchPage> createState() => _FavSearchPageState();
}

class _FavSearchPageState extends State<FavSearchPage> {
  final FavSearchController _favSearchCtr = Get.put(
    FavSearchController(),
    tag: Utils.generateRandomString(8),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: '搜索',
            onPressed: _favSearchCtr.onRefresh,
            icon: const Icon(Icons.search_outlined, size: 22),
          ),
          const SizedBox(width: 10)
        ],
        title: TextField(
          autofocus: true,
          focusNode: _favSearchCtr.searchFocusNode,
          controller: _favSearchCtr.controller,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: '搜索',
            border: InputBorder.none,
            suffixIcon: IconButton(
              tooltip: '清空',
              icon: const Icon(Icons.clear, size: 22),
              onPressed: _favSearchCtr.onClear,
            ),
          ),
          onSubmitted: (value) => _favSearchCtr.onReload(),
        ),
      ),
      body: Obx(() => _buildBody(_favSearchCtr.loadingState.value)),
    );
  }

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => errorWidget(),
      Success() => (loadingState.response as List?)?.isNotEmpty == true
          ? switch (_favSearchCtr.searchType) {
              SearchType.fav => CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _favSearchCtr.scrollController,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 80,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithExtentAndRatio(
                          mainAxisSpacing: 2,
                          maxCrossAxisExtent: Grid.mediumCardWidth * 2,
                          childAspectRatio: StyleString.aspectRatio * 2.2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == loadingState.response.length - 1) {
                              _favSearchCtr.onLoadMore();
                            }
                            final element = loadingState.response[index];
                            return FavVideoCardH(
                              videoItem: element,
                              searchType: _favSearchCtr.type,
                              callFn: _favSearchCtr.type != 1
                                  ? () {
                                      _favSearchCtr.onCancelFav(
                                        element.id!,
                                        element.type,
                                      );
                                    }
                                  : null,
                              onViewFav: () {
                                Utils.toViewPage(
                                  'bvid=${element.bvid}&cid=${element.cid}',
                                  arguments: {
                                    'videoItem': element,
                                    'heroTag': Utils.makeHeroTag(element.bvid),
                                    'sourceType': 'fav',
                                    'mediaId': Get.arguments['mediaId'],
                                    'oid': element.id,
                                    'favTitle': Get.arguments['title'],
                                    'count': Get.arguments['count'],
                                    'desc': true,
                                    'isContinuePlaying': true,
                                  },
                                );
                              },
                            );
                          },
                          childCount: loadingState.response.length,
                        ),
                      ),
                    ),
                  ],
                ),
              SearchType.follow => ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 80,
                  ),
                  controller: _favSearchCtr.scrollController,
                  itemCount: loadingState.response.length,
                  itemBuilder: ((context, index) {
                    if (index == loadingState.response.length - 1) {
                      _favSearchCtr.onLoadMore();
                    }
                    return FollowItem(
                      item: loadingState.response[index],
                    );
                  }),
                ),
              SearchType.history => CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _favSearchCtr.scrollController,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 80,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithExtentAndRatio(
                          mainAxisSpacing: 2,
                          maxCrossAxisExtent: Grid.mediumCardWidth * 2,
                          childAspectRatio: StyleString.aspectRatio * 2.2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == loadingState.response.length - 1) {
                              _favSearchCtr.onLoadMore();
                            }
                            return HistoryItem(
                              videoItem: loadingState.response[index],
                              ctr: _favSearchCtr,
                              onChoose: null,
                            );
                          },
                          childCount: loadingState.response.length,
                        ),
                      ),
                    ),
                  ],
                ),
            }
          : errorWidget(
              callback: _favSearchCtr.onReload,
            ),
      Error() => errorWidget(
          errMsg: loadingState.errMsg,
          callback: _favSearchCtr.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }
}
