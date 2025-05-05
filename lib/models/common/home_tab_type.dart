import 'package:PiliPlus/pages/bangumi/controller.dart';
import 'package:PiliPlus/pages/bangumi/view.dart';
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
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum HomeTabType {
  live('直播'),
  rcmd('推荐'),
  hot('热门'),
  rank('分区'),
  bangumi('番剧'),
  cinema('影视');

  final String description;
  const HomeTabType(this.description);
}

List get homeTabsConfig => [
      {
        'icon': const Icon(
          Icons.live_tv_outlined,
          size: 15,
        ),
        'label': '直播',
        'type': HomeTabType.live,
        'ctr': Get.find<LiveController>,
        'page': const LivePage(),
      },
      {
        'icon': const Icon(
          Icons.thumb_up_off_alt_outlined,
          size: 15,
        ),
        'label': '推荐',
        'type': HomeTabType.rcmd,
        'ctr': Get.find<RcmdController>,
        'page': const RcmdPage(),
      },
      {
        'icon': const Icon(
          Icons.whatshot_outlined,
          size: 15,
        ),
        'label': '热门',
        'type': HomeTabType.hot,
        'ctr': Get.find<HotController>,
        'page': const HotPage(),
      },
      {
        'icon': const Icon(
          Icons.category_outlined,
          size: 15,
        ),
        'label': '分区',
        'type': HomeTabType.rank,
        'ctr': Get.find<RankController>,
        'page': const RankPage(),
      },
      {
        'icon': const Icon(
          Icons.play_circle_outlined,
          size: 15,
        ),
        'label': '番剧',
        'type': HomeTabType.bangumi,
        'ctr': Get.find<BangumiController>,
        'page': const BangumiPage(tabType: HomeTabType.bangumi),
      },
      {
        'icon': Icon(
          MdiIcons.theater,
          size: 15,
        ),
        'label': '影视',
        'type': HomeTabType.cinema,
        'ctr': Get.find<BangumiController>,
        'page': const BangumiPage(tabType: HomeTabType.cinema),
      },
    ];
