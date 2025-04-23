import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/dynamic_card.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/dynamic_panel.dart';
import 'package:PiliPlus/pages/member_search/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class SearchDynamic extends StatefulWidget {
  const SearchDynamic({
    super.key,
    required this.ctr,
  });

  final MemberSearchController ctr;

  @override
  State<SearchDynamic> createState() => _SearchDynamicState();
}

class _SearchDynamicState extends State<SearchDynamic>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: () async {
        await widget.ctr.refreshDynamic();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom + 80,
            ),
            sliver:
                Obx(() => _buildBody(context, widget.ctr.dynamicState.value)),
          )
        ],
      ),
    );
  }

  late final bool dynamicsWaterfallFlow = GStorage.setting
      .get(SettingBoxKey.dynamicsWaterfallFlow, defaultValue: true);

  Widget skeleton() {
    if (!dynamicsWaterfallFlow) {
      return SliverCrossAxisGroup(
        slivers: [
          const SliverFillRemaining(),
          SliverConstrainedCrossAxis(
            maxExtent: Grid.smallCardWidth * 2,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return const DynamicCardSkeleton();
                },
                childCount: 10,
              ),
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

  Widget _buildBody(BuildContext context,
      LoadingState<List<DynamicItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => skeleton(),
      Success() => loadingState.response?.isNotEmpty == true
          ? dynamicsWaterfallFlow
              ? SliverWaterfallFlow.extent(
                  maxCrossAxisExtent: Grid.smallCardWidth * 2,
                  crossAxisSpacing: StyleString.safeSpace,
                  mainAxisSpacing: StyleString.safeSpace,
                  lastChildLayoutTypeBuilder: (index) {
                    if (index == loadingState.response!.length - 1) {
                      EasyThrottle.throttle(
                          'member_dynamics', const Duration(milliseconds: 1000),
                          () {
                        widget.ctr.searchDynamic(false);
                      });
                    }
                    return index == loadingState.response!.length
                        ? LastChildLayoutType.foot
                        : LastChildLayoutType.none;
                  },
                  children: loadingState.response!
                      .map((item) => DynamicPanel(item: item))
                      .toList(),
                )
              : SliverCrossAxisGroup(
                  slivers: [
                    const SliverFillRemaining(),
                    SliverConstrainedCrossAxis(
                      maxExtent: Grid.smallCardWidth * 2,
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == loadingState.response!.length - 1) {
                              EasyThrottle.throttle('member_dynamics',
                                  const Duration(milliseconds: 1000), () {
                                widget.ctr.searchDynamic(false);
                              });
                            }
                            return DynamicPanel(
                              item: loadingState.response![index],
                            );
                          },
                          childCount: loadingState.response!.length,
                        ),
                      ),
                    ),
                    const SliverFillRemaining(),
                  ],
                )
          : HttpError(
              callback: () {
                widget.ctr.dynamicState.value = LoadingState.loading();
                widget.ctr.refreshDynamic();
              },
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          callback: () {
            widget.ctr.dynamicState.value = LoadingState.loading();
            widget.ctr.refreshDynamic();
          },
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }

  @override
  bool get wantKeepAlive => true;
}
