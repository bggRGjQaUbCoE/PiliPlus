import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/pgc.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/data.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/list.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_result/list.dart';
import 'package:PiliPlus/models_new/pgc/pgc_timeline/result.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PgcController
    extends CommonListController<List<PgcIndexItem>?, PgcIndexItem> {
  PgcController({required this.tabType});
  final HomeTabType tabType;

  late final showPgcTimeline =
      tabType == HomeTabType.bangumi && Pref.showPgcTimeline;

  AccountService accountService = Get.find<AccountService>();

  @override
  void onInit() {
    super.onInit();

    queryData();
    queryPgcFollow();
    if (showPgcTimeline) {
      queryPgcTimeline();
    }
    if (accountService.isLogin.value) {
      followController = ScrollController();
    }
  }

  @override
  Future<void> onRefresh() {
    if (accountService.isLogin.value) {
      followPage = 1;
      followEnd = false;
    }
    queryPgcFollow();
    if (showPgcTimeline) {
      queryPgcTimeline();
    }
    return super.onRefresh();
  }

  // follow
  late int followPage = 1;
  late RxInt followCount = (-1).obs;
  late bool followLoading = false;
  late bool followEnd = false;
  late Rx<LoadingState<List<FavPgcItemModel>?>> followState =
      LoadingState<List<FavPgcItemModel>?>.loading().obs;
  ScrollController? followController;

  // timeline
  late Rx<LoadingState<List<TimelineResult>?>> timelineState =
      LoadingState<List<TimelineResult>?>.loading().obs;

  Future<void> queryPgcTimeline() async {
    final res = await Future.wait([
      PgcHttp.pgcTimeline(types: 1, before: 6, after: 6),
      PgcHttp.pgcTimeline(types: 4, before: 6, after: 6),
    ]);
    var list1 = res.first.dataOrNull;
    var list2 = res[1].dataOrNull;
    if (list1 != null &&
        list2 != null &&
        list1.isNotEmpty &&
        list2.isNotEmpty) {
      for (var i = 0; i < list1.length; i++) {
        list1[i] + list2[i];
      }
    } else {
      list1 ??= list2;
    }
    timelineState.value = Success(list1);
  }

  // 我的订阅
  Future<void> queryPgcFollow([bool isRefresh = true]) async {
    if (!accountService.isLogin.value ||
        followLoading ||
        (!isRefresh && followEnd)) {
      return;
    }
    followLoading = true;
    var res = await FavHttp.favPgc(
      mid: accountService.mid,
      type: tabType == HomeTabType.bangumi ? 1 : 2,
      pn: followPage,
    );

    if (res.isSuccess) {
      FavPgcData data = res.data;
      List<FavPgcItemModel>? list = data.list;
      followCount.value = data.total ?? -1;

      if (list.isNullOrEmpty) {
        followEnd = true;
        if (isRefresh) {
          followState.value = Success(list);
        }
        followLoading = false;
        return;
      }

      if (isRefresh) {
        if (list!.length >= followCount.value) {
          followEnd = true;
        }
        followState.value = Success(list);
        followController?.animToTop();
      } else if (followState.value.isSuccess) {
        final currentList = followState.value.data!..addAll(list!);
        if (currentList.length >= followCount.value) {
          followEnd = true;
        }
        followState.refresh();
      }
      followPage++;
    } else if (isRefresh) {
      followState.value = res as Error;
    }
    followLoading = false;
  }

  @override
  Future<LoadingState<List<PgcIndexItem>?>> customGetData() => PgcHttp.pgcIndex(
    page: page,
    indexType: tabType == HomeTabType.cinema ? 102 : null,
  );

  @override
  void onClose() {
    followController?.dispose();
    super.onClose();
  }
}
