import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/pgc.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/data.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/list.dart';
import 'package:PiliPlus/models_new/pgc/pgc_timeline/result.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';

class PgcController extends CommonListController<FavPgcData, FavPgcItemModel>
    with AccountMixin {
  PgcController({required HomeTabType tabType}) {
    switch (tabType) {
      case .bangumi:
        type = 1;
        showPgcTimeline = Pref.showPgcTimeline;
      case .cinema:
        type = 2;
        indexType = 102;
        showPgcTimeline = false;
      default:
    }
  }

  int? indexType;
  late final int type;
  late final int tabType;
  late final bool showPgcTimeline;
  // follow
  late final RxInt followCount = (-1).obs;

  @override
  final accountService = Get.find<AccountService>();

  @override
  void onInit() {
    super.onInit();

    queryData();
    if (showPgcTimeline) {
      queryPgcTimeline();
    }
  }

  @override
  Future<void> onRefresh() {
    if (showPgcTimeline) {
      queryPgcTimeline();
    }
    return super.onRefresh().whenComplete(scrollController.jumpToTop);
  }

  // timeline
  late Rx<LoadingState<List<TimelineResult>?>> timelineState =
      LoadingState<List<TimelineResult>?>.loading().obs;

  Future<void> queryPgcTimeline() async {
    final res = await Future.wait([
      PgcHttp.pgcTimeline(types: 1, before: 6, after: 6),
      PgcHttp.pgcTimeline(types: 4, before: 6, after: 6),
    ]);
    final list1 = res.first.dataOrNull;
    final list2 = res[1].dataOrNull;
    if (list1 != null &&
        list2 != null &&
        list1.isNotEmpty &&
        list2.isNotEmpty) {
      for (var i = 0; i < list1.length; i++) {
        list1[i].addAll(list2[i]);
      }
    }
    timelineState.value = Success(list1 ?? list2);
  }

  @override
  Future<LoadingState<FavPgcData>> customGetData() =>
      FavHttp.favPgc(type: type, pn: page);

  @override
  List<FavPgcItemModel>? getDataList(FavPgcData response) {
    followCount.value = response.total ?? 0;
    return response.list;
  }

  @override
  void onChangeAccount(bool isLogin) {
    if (isLogin) {
      onRefresh();
    } else {
      loadingState.value = LoadingState.loading();
    }
  }
}
