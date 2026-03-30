import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/live/live_contribution_rank_type.dart';
import 'package:PiliPlus/models_new/live/live_contribution_rank/item.dart';
import 'package:PiliPlus/pages/live_room/contribution_rank/controller.dart';
import 'package:PiliPlus/pages/member/widget/medal_widget.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContributionRankPanel extends StatefulWidget {
  const ContributionRankPanel({
    super.key,
    required this.ruid,
    required this.roomId,
  });

  final Object ruid;
  final Object roomId;

  @override
  State<ContributionRankPanel> createState() => _ContributionRankPanelState();
}

class _ContributionRankPanelState extends State<ContributionRankPanel>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: LiveContributionRankType.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45,
          child: TabBar(
            controller: _tabController,
            tabs: LiveContributionRankType.values
                .map((e) => Tab(text: e.title))
                .toList(),
            dividerColor: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.3),
            onTap: (index) {
              if (!_tabController.indexIsChanging) {
                Get.find<ContributionRankController>(
                  tag:
                      '${widget.roomId}${LiveContributionRankType.values[index].name}',
                ).scrollController.animToTop();
              }
            },
          ),
        ),
        Expanded(
          child: tabBarView(
            controller: _tabController,
            children: LiveContributionRankType.values
                .map(
                  (e) => _ContributionRankType(
                    ruid: widget.ruid,
                    roomId: widget.roomId,
                    type: e,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ContributionRankType extends StatefulWidget {
  const _ContributionRankType({
    required this.ruid,
    required this.roomId,
    required this.type,
  });

  final Object ruid;
  final Object roomId;
  final LiveContributionRankType type;

  @override
  State<_ContributionRankType> createState() => _ContributionRankTypeState();
}

class _ContributionRankTypeState extends State<_ContributionRankType>
    with AutomaticKeepAliveClientMixin {
  late final ContributionRankController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      ContributionRankController(
        ruid: widget.ruid,
        roomId: widget.roomId,
        type: widget.type,
      ),
      tag: '${widget.roomId}${widget.type.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final showScore = widget.type == .online_rank;
    return Material(
      type: .transparency,
      child: refreshIndicator(
        onRefresh: _controller.onRefresh,
        child: CustomScrollView(
          controller: _controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ViewSliverSafeArea(
              sliver: Obx(
                () => _buildBody(showScore, _controller.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    bool showScore,
    LoadingState<List<LiveContributionRankItem>?> state,
  ) {
    return switch (state) {
      Loading() => linearLoading,
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverFixedExtentList.builder(
                itemCount: response.length,
                itemBuilder: (context, index) {
                  final item = response[index];
                  return _Item(
                    index: index,
                    item: item,
                    showScore: showScore,
                  );
                },
                itemExtent: 60,
              )
            : HttpError(onReload: _controller.onReload),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  @override
  bool get wantKeepAlive => true;
}

class _Item extends StatelessWidget {
  const _Item({
    required this.index,
    required this.item,
    required this.showScore,
  });

  final int index;
  final bool showScore;
  final LiveContributionRankItem item;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = ColorScheme.of(context);
    Widget child = Text(item.name!);
    if (item.uinfoMedal case final uinfoMedal?) {
      try {
        child = Column(
          spacing: 4,
          crossAxisAlignment: .start,
          children: [
            child,
            MedalWidget.fromMedalInfo(
              medal: uinfoMedal,
              padding: MedalWidget.mediumPadding,
            ),
          ],
        );
      } catch (e, s) {
        if (kDebugMode) {
          Utils.reportError(e, s);
        }
      }
    }
    return InkWell(
      onTap: () => Get.toNamed('/member?mid=${item.uid}'),
      child: Padding(
        padding: const .only(left: 10, top: 9, bottom: 8, right: 16),
        child: Row(
          spacing: 10,
          children: [
            SizedBox(
              width: 32,
              child: Center(
                child: Text(
                  '${index + 1}',
                  textAlign: .center,
                  textScaler: .noScaling,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Utils.index2Color(index, colorScheme.outline),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            NetworkImgLayer(
              src: item.face,
              width: 42,
              height: 42,
              type: .avatar,
            ),
            Expanded(child: child),
            if (showScore)
              Text(
                item.score.toString(),
                style: TextStyle(color: colorScheme.outline),
              ),
          ],
        ),
      ),
    );
  }
}
