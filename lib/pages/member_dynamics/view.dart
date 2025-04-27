import 'package:PiliPlus/common/skeleton/dynamic_card.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/pages/member_dynamics/index.dart';
import 'package:PiliPlus/utils/utils.dart';

import '../../common/constants.dart';
import '../../common/widgets/http_error.dart';
import '../../utils/grid.dart';
import '../../utils/storage.dart';
import '../dynamics/widgets/dynamic_panel.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MemberDynamicsPage extends StatefulWidget {
  const MemberDynamicsPage({super.key, this.mid});

  final int? mid;

  @override
  State<MemberDynamicsPage> createState() => _MemberDynamicsPageState();
}

class _MemberDynamicsPageState extends State<MemberDynamicsPage>
    with AutomaticKeepAliveClientMixin {
  late MemberDynamicsController _memberDynamicController;
  late int mid;
  late bool dynamicsWaterfallFlow;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    mid = widget.mid ?? int.parse(Get.parameters['mid']!);
    final String heroTag = Utils.makeHeroTag(mid);
    _memberDynamicController =
        Get.put(MemberDynamicsController(mid), tag: heroTag);
    dynamicsWaterfallFlow = GStorage.setting
        .get(SettingBoxKey.dynamicsWaterfallFlow, defaultValue: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.mid == null
        ? Scaffold(
            appBar: AppBar(title: const Text('Ta的动态')),
            body: _buildBody,
          )
        : _buildBody;
  }

  Widget get _buildBody => refreshIndicator(
        onRefresh: () async {
          await _memberDynamicController.onRefresh();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            Obx(
              () => _buildContent(_memberDynamicController.loadingState.value),
            )
          ],
        ),
      );

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

  Widget _buildContent(LoadingState<List<DynamicItemModel>?> loadingState) {
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
                      crossAxisSpacing: StyleString.safeSpace,
                      lastChildLayoutTypeBuilder: (index) {
                        if (index == loadingState.response!.length - 1) {
                          _memberDynamicController.onLoadMore();
                        }
                        return index == loadingState.response!.length
                            ? LastChildLayoutType.foot
                            : LastChildLayoutType.none;
                      },
                      children: loadingState.response!
                          .map((item) => DynamicPanel(
                              item: item,
                              onRemove: _memberDynamicController.onRemove,
                              onSetTop: _memberDynamicController.onSetTop))
                          .toList(),
                    )
                  : SliverCrossAxisGroup(
                      slivers: [
                        const SliverFillRemaining(),
                        SliverConstrainedCrossAxis(
                          maxExtent: Grid.smallCardWidth * 2,
                          sliver: SliverList.builder(
                            itemBuilder: (context, index) {
                              if (index == loadingState.response!.length - 1) {
                                _memberDynamicController.onLoadMore();
                              }
                              return DynamicPanel(
                                item: loadingState.response![index],
                                onRemove: _memberDynamicController.onRemove,
                                onSetTop: _memberDynamicController.onSetTop,
                              );
                            },
                            itemCount: loadingState.response!.length,
                          ),
                        ),
                        const SliverFillRemaining(),
                      ],
                    ),
            )
          : HttpError(
              onReload: _memberDynamicController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _memberDynamicController.onReload,
        ),
    };
  }
}
