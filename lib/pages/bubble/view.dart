import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/bubble/dyn_list.dart';
import 'package:PiliPlus/pages/bubble/controller.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart'
    hide ListTile, SliverGridDelegateWithMaxCrossAxisExtent;
import 'package:get/get.dart';

class BubblePage extends StatefulWidget {
  const BubblePage({super.key, this.categoryId});

  final String? categoryId;

  @override
  State<BubblePage> createState() => _BubblePageState();
}

class _BubblePageState extends State<BubblePage>
    with AutomaticKeepAliveClientMixin {
  late final BubbleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      BubbleController(widget.categoryId),
      tag: widget.categoryId ?? 'all',
    );
  }

  BubbleController currCtr([int? index]) {
    try {
      index ??= _controller.tabController!.index;
      if (index != 0) {
        return Get.find<BubbleController>(
          tag: _controller.tabs.value![index].id.toString(),
        );
      }
    } catch (_) {}
    return _controller;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final padding = MediaQuery.viewPaddingOf(context);
    Widget child = refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller.scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(bottom: padding.bottom + 100),
            sliver: Obx(
              () => _buildBody(_controller.loadingState.value),
            ),
          ),
        ],
      ),
    );
    if (widget.categoryId != null) {
      return child;
    } else {
      child = Stack(
        clipBehavior: .none,
        children: [
          child,
          Positioned(
            right: kFloatingActionButtonMargin,
            bottom: kFloatingActionButtonMargin + padding.bottom,
            child: Obx(
              () {
                final sortInfo = _controller.sortInfo.value;
                if (sortInfo == null || sortInfo.showSort != true) {
                  return const SizedBox.shrink();
                }
                final item = sortInfo.sortItems?.firstWhereOrNull(
                  (e) => e.sortType == sortInfo.curSortType,
                );
                if (item != null) {
                  return FloatingActionButton.extended(
                    tooltip: '排序',
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        clipBehavior: .hardEdge,
                        contentPadding: const .symmetric(vertical: 12),
                        content: Column(
                          mainAxisSize: .min,
                          children: sortInfo.sortItems!.map(
                            (e) {
                              final isSelected = item.sortType == e.sortType;
                              return ListTile(
                                dense: true,
                                enabled: !isSelected,
                                onTap: () {
                                  Get.back();
                                  if (!isSelected) {
                                    _controller.onSort(e.sortType);
                                  }
                                },
                                title: Text(
                                  e.text!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                trailing: isSelected
                                    ? const Icon(size: 22, Icons.check)
                                    : null,
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.sort, size: 20),
                    label: Text(item.text!),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Obx(() {
          final tribeName = _controller.tribeName.value;
          if (tribeName == null) {
            return const SizedBox.shrink();
          }
          return Text('$tribeName小站');
        }),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: Obx(() {
          final tabs = _controller.tabs.value;
          if (tabs == null || tabs.isEmpty) {
            return child;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                isScrollable: true,
                tabAlignment: .start,
                controller: _controller.tabController,
                onTap: (index) {
                  if (!_controller.tabController!.indexIsChanging) {
                    currCtr().scrollController.animToTop();
                  }
                },
                tabs: tabs.map((item) => Tab(text: item.name!)).toList(),
              ),
              Expanded(
                child: tabBarView(
                  controller: _controller.tabController,
                  children: [
                    KeepAliveWrapper(child: child),
                    ...tabs
                        .skip(1)
                        .map((item) => BubblePage(categoryId: item.id)),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  late final gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    mainAxisExtent: 56,
    maxCrossAxisExtent: 2 * Grid.smallCardWidth,
  );

  Widget _buildBody(LoadingState<List<DynList>?> loadingState) {
    switch (loadingState) {
      case Loading():
        return const SliverFillRemaining(child: m3eLoading);
      case Success(:final response):
        if (response != null && response.isNotEmpty) {
          return SliverGrid.builder(
            gridDelegate: gridDelegate,
            itemBuilder: (context, index) {
              if (index == response.length - 1) {
                _controller.onLoadMore();
              }
              final item = response[index];
              return Material(
                type: .transparency,
                child: ListTile(
                  safeArea: false,
                  visualDensity: .standard,
                  // PageUtils.pushDynFromId(id: item.dynId);
                  onTap: () => Get.toNamed(
                    '/articlePage',
                    parameters: {
                      'id': item.dynId!,
                      'type': 'opus',
                    },
                  ),
                  title: Text(
                    item.title!,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  trailing: item.meta?.timeText == null
                      ? null
                      : Text(
                          item.meta!.timeText!,
                          style: const TextStyle(fontSize: 13),
                        ),
                ),
              );
            },
            itemCount: response.length,
          );
        }
        return HttpError(onReload: _controller.onReload);
      case Error(:final errMsg):
        return HttpError(
          errMsg: errMsg,
          onReload: _controller.onReload,
        );
    }
  }

  @override
  bool get wantKeepAlive => widget.categoryId != null;
}
