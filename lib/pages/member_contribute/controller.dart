import 'dart:math';

import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models_new/space/space/tab2.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class MemberContributeCtr extends GetxController
    with GetSingleTickerProviderStateMixin {
  MemberContributeCtr({
    required this.heroTag,
    required this.initialIndex,
  });
  final String? heroTag;
  final int? initialIndex;

  TabController? tabController;
  List<Tab>? get tabs => tabController == null
      ? null
      : items!
            .map(
              (item) => Tab(
                text: item.param == 'ugcSeason'
                    ? L10n.current.memberContributeCtrOnInitTitle
                    : _ctr.tabTitle(item.param, item.title),
              ),
            )
            .toList();
  late final _ctr = Get.find<MemberController>(tag: heroTag);
  List<SpaceTab2Item>? items;

  @override
  void onInit() {
    super.onInit();
    SpaceTab2 contribute = _ctr.tab2!.firstWhere(
      (item) => item.param == 'contribute',
    );
    final items = contribute.items;
    if (items != null && items.isNotEmpty) {
      this.items = items;
      if (contribute.items!.length > 1) {
        // show if exist
        if (_ctr.hasSeasonOrSeries == true) {
          items.add(
            SpaceTab2Item(
              param: 'ugcSeason',
              title: L10n.current.memberContributeCtrOnInitTitle,
            ),
          );
        }
        tabController = TabController(
          vsync: this,
          length: items.length,
          initialIndex: max(0, initialIndex ?? 0),
        );
      }
    }
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }
}
