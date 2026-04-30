import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TVHomeCategory {
  recommend('推荐', Icons.thumb_up_outlined),
  hot('热门', Icons.whatshot_outlined),
  live('直播', Icons.live_tv_outlined),
  pgc('番剧', Icons.movie_outlined),
  rank('排行', Icons.leaderboard_outlined),
  dynamics('动态', Icons.dynamic_feed_outlined),
  history('历史', Icons.history_outlined),
  later('稍后再看', Icons.watch_later_outlined),
  favorite('收藏', Icons.star_outline),
  search('搜索', Icons.search),
  setting('设置', Icons.settings_outlined);

  const TVHomeCategory(this.label, this.icon);
  final String label;
  final IconData icon;
}

class TVHomeController extends GetxController {
  final RxInt selectedCategory = 0.obs;
  final RxBool sidebarExpanded = false.obs;
  final Rx<LoadingState<List?>> rcmdState = LoadingState<List?>.loading().obs;
  final Rx<LoadingState<List?>> hotState = LoadingState<List?>.loading().obs;

  AccountService get accountService => Get.find<AccountService>();

  @override
  void onInit() {
    super.onInit();
    loadRcmd();
    loadHot();
  }

  Future<void> loadRcmd() async {
    rcmdState.value = LoadingState.loading();
    final res = await VideoHttp.rcmdVideoListApp(freshIdx: 0);
    rcmdState.value = switch (res) {
      Success(:final response) => Success(response),
      Error(:final errMsg) => Error(errMsg),
      _ => const Error(null),
    };
  }

  Future<void> loadHot() async {
    hotState.value = LoadingState.loading();
    final res = await VideoHttp.hotVideoList(pn: 1, ps: 20);
    hotState.value = switch (res) {
      Success(:final response) => Success(response),
      Error(:final errMsg) => Error(errMsg),
      _ => const Error(null),
    };
  }
}
