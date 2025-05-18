import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/pages/bangumi/controller.dart';
import 'package:PiliPlus/pages/bangumi/view.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/hot/controller.dart';
import 'package:PiliPlus/pages/hot/view.dart';
import 'package:PiliPlus/pages/live/controller.dart';
import 'package:PiliPlus/pages/live/view.dart';
import 'package:PiliPlus/pages/rank/controller.dart';
import 'package:PiliPlus/pages/rank/view.dart';
import 'package:PiliPlus/pages/rcmd/controller.dart';
import 'package:PiliPlus/pages/rcmd/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum HomeTabType implements EnumWithLabel {
  live('直播'),
  rcmd('推荐'),
  hot('热门'),
  rank('分区'),
  bangumi('番剧'),
  cinema('影视');

  @override
  final String label;
  const HomeTabType(this.label);

  ScrollOrRefreshMixin Function() get ctr => switch (this) {
        HomeTabType.live => Get.find<LiveController>,
        HomeTabType.rcmd => Get.find<RcmdController>,
        HomeTabType.hot => Get.find<HotController>,
        HomeTabType.rank =>
          (Get.find<RankController>) as ScrollOrRefreshMixin Function(),
        HomeTabType.bangumi || HomeTabType.cinema => () =>
            Get.find<BangumiController>(tag: name),
      };

  Widget get page => switch (this) {
        HomeTabType.live => const LivePage(),
        HomeTabType.rcmd => const RcmdPage(),
        HomeTabType.hot => const HotPage(),
        HomeTabType.rank => const RankPage(),
        HomeTabType.bangumi => const BangumiPage(tabType: HomeTabType.bangumi),
        HomeTabType.cinema => const BangumiPage(tabType: HomeTabType.cinema),
      };
}
