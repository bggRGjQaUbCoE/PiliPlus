import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/fav_search/view.dart' show SearchType;
import 'package:PiliPlus/pages/history/base_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/pages/history/index.dart';

import '../../common/constants.dart';
import '../../utils/grid.dart';
import 'widgets/item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, this.type});

  final String? type;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin {
  late final _historyController = Get.put(
    HistoryController(widget.type),
    tag: widget.type ?? 'all',
  );

  HistoryController get currCtr {
    try {
      if (_historyController.tabController != null &&
          _historyController.tabController!.index != 0) {
        return Get.find<HistoryController>(
          tag: _historyController
              .tabs[_historyController.tabController!.index - 1].type,
        );
      }
    } catch (_) {
      return _historyController;
    }
    return _historyController;
  }

  bool get enableMultiSelect =>
      _historyController.baseCtr.enableMultiSelect.value;

  @override
  void dispose() {
    Get.delete<HistoryBaseController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.type != null
        ? _buildPage
        : Obx(
            () => PopScope(
              canPop: enableMultiSelect.not,
              onPopInvokedWithResult: (didPop, result) {
                if (enableMultiSelect) {
                  currCtr.handleSelect();
                }
              },
              child: Scaffold(
                appBar: widget.type != null
                    ? null
                    : AppBarWidget(
                        visible: enableMultiSelect,
                        child1: AppBar(
                          title: const Text('观看记录'),
                          actions: [
                            IconButton(
                              tooltip: '搜索',
                              onPressed: () => Get.toNamed(
                                '/favSearch',
                                arguments: {
                                  'searchType': SearchType.history,
                                },
                              ),
                              icon: const Icon(Icons.search_outlined),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String type) {
                                // 处理菜单项选择的逻辑
                                switch (type) {
                                  case 'pause':
                                    _historyController.baseCtr
                                        .onPauseHistory(context);
                                    break;
                                  case 'clear':
                                    _historyController.baseCtr
                                        .onClearHistory(context, () {
                                      _historyController.loadingState.value =
                                          LoadingState.success(null);
                                      if (_historyController.tabController !=
                                          null) {
                                        for (final item
                                            in _historyController.tabs) {
                                          try {
                                            Get.find<HistoryController>(
                                                        tag: item.type)
                                                    .loadingState
                                                    .value =
                                                LoadingState.success(null);
                                          } catch (_) {}
                                        }
                                      }
                                    });
                                    break;
                                  case 'del':
                                    currCtr.onDelHistory();
                                    break;
                                  case 'multiple':
                                    _historyController
                                        .baseCtr.enableMultiSelect.value = true;
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'pause',
                                  child: Obx(
                                    () => Text(
                                      !_historyController
                                              .baseCtr.pauseStatus.value
                                          ? '暂停观看记录'
                                          : '恢复观看记录',
                                    ),
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'clear',
                                  child: Text('清空观看记录'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'del',
                                  child: Text('删除已看记录'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'multiple',
                                  child: Text('多选删除'),
                                ),
                              ],
                            ),
                            const SizedBox(width: 6),
                          ],
                        ),
                        child2: AppBar(
                          leading: IconButton(
                            tooltip: '取消',
                            onPressed: () {
                              currCtr.handleSelect();
                            },
                            icon: const Icon(Icons.close_outlined),
                          ),
                          title: Obx(
                            () => Text(
                              '已选: ${_historyController.baseCtr.checkedCount.value}',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => currCtr.handleSelect(true),
                              child: const Text('全选'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  currCtr.onDelCheckedHistory(context),
                              child: Text(
                                '删除',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                        ),
                      ),
                body: Obx(
                  () => _historyController.tabs.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabBar(
                              controller: _historyController.tabController,
                              onTap: (value) {
                                if (_historyController
                                    .tabController!.indexIsChanging.not) {
                                  currCtr.scrollController.animToTop();
                                } else {
                                  if (enableMultiSelect) {
                                    if (_historyController
                                            .tabController!.previousIndex ==
                                        0) {
                                      _historyController.handleSelect();
                                    } else {
                                      try {
                                        Get.find<HistoryController>(
                                                tag: _historyController
                                                    .tabs[_historyController
                                                            .tabController!
                                                            .previousIndex -
                                                        1]
                                                    .type)
                                            .handleSelect();
                                      } catch (_) {}
                                    }
                                  }
                                }
                              },
                              tabs: [
                                Tab(text: '全部'),
                                ..._historyController.tabs.map(
                                  (item) => Tab(text: item.name),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: TabBarView(
                                  physics: enableMultiSelect
                                      ? const NeverScrollableScrollPhysics()
                                      : const CustomTabBarViewScrollPhysics(),
                                  controller: _historyController.tabController,
                                  children: [
                                    _buildPage,
                                    ..._historyController.tabs.map(
                                      (item) => HistoryPage(type: item.type),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : _buildPage,
                ),
              ),
            ),
          );
  }

  Widget get _buildPage => refreshIndicator(
        onRefresh: () async {
          await _historyController.onRefresh();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _historyController.scrollController,
          slivers: [
            Obx(() => _buildBody(_historyController.loadingState.value)),
          ],
        ),
      );

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => SliverGrid(
          gridDelegate: SliverGridDelegateWithExtentAndRatio(
            mainAxisSpacing: 2,
            maxCrossAxisExtent: Grid.mediumCardWidth * 2,
            childAspectRatio: StyleString.aspectRatio * 2.2,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const VideoCardHSkeleton();
            },
            childCount: 10,
          ),
        ),
      Success() => (loadingState.response as List?)?.isNotEmpty == true
          ? SliverPadding(
              padding: EdgeInsets.only(
                top: StyleString.safeSpace - 5,
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
                      _historyController.onLoadMore();
                    }
                    return HistoryItem(
                      videoItem: loadingState.response[index],
                      ctr: _historyController.baseCtr,
                      onChoose: () => _historyController.onSelect(index),
                      onDelete: (kid, business) =>
                          _historyController.delHistory(kid, business),
                    );
                  },
                  childCount: loadingState.response.length,
                ),
              ),
            )
          : HttpError(
              callback: _historyController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          callback: _historyController.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }

  @override
  bool get wantKeepAlive => true;
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    required this.child1,
    required this.child2,
    required this.visible,
    super.key,
  });

  final PreferredSizeWidget child1;
  final PreferredSizeWidget child2;
  final bool visible;
  @override
  Size get preferredSize => child1.preferredSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: !visible ? child1 : child2,
    );
  }
}
