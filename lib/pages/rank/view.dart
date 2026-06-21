import 'package:PiliPlus/common/widgets/flutter/vertical_tabs.dart';
import 'package:PiliPlus/models/common/rank_type.dart';
import 'package:PiliPlus/pages/rank/controller.dart';
import 'package:PiliPlus/pages/rank/zone/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankPage extends StatelessWidget {
  const RankPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rankController = Get.put(RankController());

    Widget buildTab(ThemeData theme) {
      return VerticalTabBar(
        dividerWidth: 0,
        isScrollable: true,
        indicatorWeight: 3,
        indicatorSize: .tab,
        controller: rankController.tabController,
        padding: .only(bottom: MediaQuery.paddingOf(context).bottom + 105),
        tabs: RankType.values.map((e) => VerticalTab(text: e.label)).toList(),
        onTap: (index) {
          if (!rankController.tabController.indexIsChanging) {
            rankController.animateToTop();
          } else {
            rankController
              ..tabIndex.value = index
              ..tabController.animateTo(index);
          }
        },
      );
    }

    return Row(
      children: [
        buildTab(theme),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: rankController.tabController,
            children: RankType.values
                .map(
                  (item) =>
                      ZonePage(rid: item.rid, seasonType: item.seasonType),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
