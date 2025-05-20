import 'dart:async';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/dynamic_card.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/dynamics/widgets/dynamic_panel.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class DynamicsTabPage extends CommonPage {
  const DynamicsTabPage({super.key, required this.dynamicsType});

  final DynamicsTabType dynamicsType;

  @override
  State<DynamicsTabPage> createState() => _DynamicsTabPageState();

  static Widget dynSkeleton(bool dynamicsWaterfallFlow) {
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
    tag: widget.dynamicsType.name,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void listener() {
    if (_mainController.navigationBars[0] != NavigationBarType.dynamics &&
        _mainController.selectedIndex.value == 0) {
      return;
    }
    super.listener();
  }

  @override
  void initState() {
    super.initState();
    if (widget.dynamicsType == DynamicsTabType.up) {
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
      onRefresh: () {
        dynamicsController.queryFollowUp();
        return controller.onRefresh();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller.scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom + 80,
            ),
            sliver: Obx(() => _buildBody(controller.loadingState.value)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LoadingState<List<DynamicItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => DynamicsTabPage.dynSkeleton(dynamicsWaterfallFlow),
      Success(:var response) => response?.isNotEmpty == true
          ? dynamicsWaterfallFlow
              ? SliverWaterfallFlow.extent(
                  maxCrossAxisExtent: Grid.smallCardWidth * 2,
                  crossAxisSpacing: StyleString.cardSpace / 2,
                  lastChildLayoutTypeBuilder: (index) {
                    if (index == response.length - 1) {
                      controller.onLoadMore();
                    }
                    return index == response.length
                        ? LastChildLayoutType.foot
                        : LastChildLayoutType.none;
                  },
                  children: [
                    for (int index = 0; index < response!.length; index++)
                      DynamicPanel(
                        item: response[index],
                        onRemove: (idStr) => controller.onRemove(index, idStr),
                        onBlock: () => controller.onBlock(index),
                      )
                  ],
                )
              : SliverCrossAxisGroup(
                  slivers: [
                    const SliverFillRemaining(),
                    SliverConstrainedCrossAxis(
                      maxExtent: Grid.smallCardWidth * 2,
                      sliver: SliverList.builder(
                        itemBuilder: (context, index) {
                          if (index == response.length - 1) {
                            controller.onLoadMore();
                          }
                          final item = response[index];
                          return DynamicPanel(
                            item: item,
                            onRemove: (idStr) =>
                                controller.onRemove(index, idStr),
                            onBlock: () => controller.onBlock(index),
                          );
                        },
                        itemCount: response!.length,
                      ),
                    ),
                    const SliverFillRemaining(),
                  ],
                )
          : HttpError(
              onReload: controller.onReload,
            ),
      Error(:var errMsg) => HttpError(
          errMsg: errMsg,
          onReload: controller.onReload,
        ),
    };
  }
}
