import 'package:PiliPlus/models/common/rank_type.dart';
import 'package:PiliPlus/pages/rank/controller.dart';
import 'package:PiliPlus/pages/rank/zone/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage>
    with AutomaticKeepAliveClientMixin {
  final RankController _rankController = Get.put(RankController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        _buildTab(theme),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _rankController.tabController,
            children: RankType.values
                .map(
                  (item) => ZonePage(
                    rid: item.rid,
                    seasonType: item.seasonType,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabHeight = MediaQuery.textScalerOf(context).scale(21) + 14;
  }

  late double _tabHeight;

  Widget _buildTab(ThemeData theme) {
    return SizedBox(
      width: 64,
      child: Obx(() {
        final tabIndex = _rankController.tabIndex.value;
        return ListView.builder(
          controller: _rankController.tabScrollController,
          padding: .only(bottom: MediaQuery.paddingOf(context).bottom + 105),
          itemCount: RankType.values.length,
          itemBuilder: (context, index) {
            final item = RankType.values[index];
            final isCurr = index == tabIndex;
            return SizedBox(
              height: _tabHeight,
              child: Material(
                color: isCurr
                    ? theme.colorScheme.onInverseSurface
                    : theme.colorScheme.surface,
                child: InkWell(
                  onTap: isCurr
                      ? _rankController.animateToTop
                      : () => _rankController
                          ..tabIndex.value = index
                          ..tabController.animateTo(index)
                          ..scrollToCurrentIndex(_tabHeight, index),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCurr)
                        Container(
                          width: 3,
                          height: double.infinity,
                          color: theme.colorScheme.primary,
                        )
                      else
                        const SizedBox(width: 3),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const .symmetric(vertical: 7),
                          child: Text(
                            item.label,
                            style: isCurr
                                ? TextStyle(
                                    fontSize: 15,
                                    color: theme.colorScheme.primary,
                                  )
                                : const TextStyle(fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
