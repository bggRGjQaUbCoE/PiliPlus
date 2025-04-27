import 'dart:async';

import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../../common/skeleton/dynamic_card.dart';
import '../../../utils/grid.dart';

import '../index.dart';
import '../widgets/dynamic_panel.dart';
import 'controller.dart';

class DynamicsTabPage extends CommonPage {
  const DynamicsTabPage({super.key, required this.dynamicsType});

  final String dynamicsType;

  @override
  State<DynamicsTabPage> createState() => _DynamicsTabPageState();
}

class _DynamicsTabPageState
    extends CommonPageState<DynamicsTabPage, DynamicsTabController>
    with AutomaticKeepAliveClientMixin {
  late bool dynamicsWaterfallFlow;
  StreamSubscription? _listener;
  late final MainController _mainController = Get.find<MainController>();

  DynamicsController dynamicsController = Get.put(DynamicsController());
  @override
  late DynamicsTabController controller = Get.put(
    DynamicsTabController(dynamicsType: widget.dynamicsType)
      ..mid = dynamicsController.mid.value,
    tag: widget.dynamicsType,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void listener() {
    if (_mainController.navigationBars[0]['id'] != 1 &&
        _mainController.selectedIndex.value == 0) {
      return;
    }
    super.listener();
  }

  @override
  void initState() {
    super.initState();
    if (widget.dynamicsType == 'up') {
      _listener = dynamicsController.mid.listen((mid) {
        if (mid != -1) {
          controller
            ..mid = mid
            ..onReload();
        }
      });
    }
    dynamicsWaterfallFlow = GStorage.setting
        .get(SettingBoxKey.dynamicsWaterfallFlow, defaultValue: true);
  }

  @override
  void dispose() {
    _listener?.cancel();
    dynamicsController.mid.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: () async {
        dynamicsController.queryFollowUp();
        await controller.onRefresh();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller.scrollController,
        slivers: [
          Obx(() => _buildBody(controller.loadingState.value)),
        ],
      ),
    );
  }

  Widget skeleton() {
    if (!dynamicsWaterfallFlow) {
      return SliverCrossAxisGroup(
        slivers: [
          const SliverFillRemaining(),
          SliverConstrainedCrossAxis(
            maxExtent: Grid.smallCardWidth * 2,
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                return const DynamicCardSkeleton();
              },
              itemCount: 10,
            ),
          ),
          const SliverFillRemaining()
        ],
      );
    }
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithExtentAndRatio(
        crossAxisSpacing: StyleString.cardSpace / 2,
        mainAxisSpacing: StyleString.cardSpace / 2,
        maxCrossAxisExtent: Grid.smallCardWidth * 2,
        childAspectRatio: StyleString.aspectRatio,
        mainAxisExtent: 50,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const DynamicCardSkeleton();
        },
        childCount: 10,
      ),
    );
  }

  Widget _buildBody(LoadingState<List<DynamicItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => skeleton(),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 80,
              ),
              sliver: dynamicsWaterfallFlow
                  ? SliverWaterfallFlow.extent(
                      maxCrossAxisExtent: Grid.smallCardWidth * 2,
                      crossAxisSpacing: StyleString.cardSpace / 2,
                      lastChildLayoutTypeBuilder: (index) {
                        if (index == loadingState.response!.length - 1) {
                          controller.onLoadMore();
                        }
                        return index == loadingState.response!.length
                            ? LastChildLayoutType.foot
                            : LastChildLayoutType.none;
                      },
                      children: [
                        if (dynamicsController.tabController.index == 4 &&
                            dynamicsController.mid.value != -1) ...[
                          for (var i in loadingState.response!)
                            DynamicPanel(
                              item: i,
                              onRemove: controller.onRemove,
                            ),
                        ] else ...[
                          for (var i in loadingState.response!)
                            if (!dynamicsController.tempBannedList
                                .contains(i.modules.moduleAuthor?.mid))
                              DynamicPanel(
                                item: i,
                                onRemove: controller.onRemove,
                              ),
                        ]
                      ],
                    )
                  : SliverCrossAxisGroup(
                      slivers: [
                        const SliverFillRemaining(),
                        SliverConstrainedCrossAxis(
                          maxExtent: Grid.smallCardWidth * 2,
                          sliver: SliverList.builder(
                            itemBuilder: (context, index) {
                              if (index == loadingState.response!.length - 1) {
                                controller.onLoadMore();
                              }
                              final item = loadingState.response![index];
                              if ((dynamicsController.tabController.index ==
                                          4 &&
                                      dynamicsController.mid.value != -1) ||
                                  !dynamicsController.tempBannedList.contains(
                                      item.modules.moduleAuthor?.mid)) {
                                return DynamicPanel(
                                  item: item,
                                  onRemove: controller.onRemove,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            itemCount: loadingState.response!.length,
                          ),
                        ),
                        const SliverFillRemaining(),
                      ],
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
}
