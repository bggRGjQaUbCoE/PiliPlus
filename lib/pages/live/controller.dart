import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/live/follow.dart';
import 'package:PiliPlus/models/live/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class LiveController
    extends CommonListController<List<LiveItemModel>?, LiveItemModel> {
  @override
  void onInit() {
    super.onInit();
    queryData();
    if (isLogin.value) {
      fetchLiveFollowing();
    }
  }

  String? gaiaVtoken;

  @override
  Future<LoadingState<List<LiveItemModel>?>> customGetData() =>
      LiveHttp.liveList(pn: currentPage, gaiaVtoken: gaiaVtoken);

  @override
  bool handleError(String? errMsg) {
    if (errMsg?.startsWith('voucher') == true) {
      loadingState.value = LoadingState.error(' -352 ');
      RequestUtils.validate(
        errMsg!,
        (gaiaVtoken) {
          this.gaiaVtoken = gaiaVtoken;
          onReload();
        },
      );
      return true;
    }
    return false;
  }

  @override
  Future onRefresh() {
    fetchLiveFollowing();
    return super.onRefresh();
  }

  @override
  Future onReload() {
    if (loadingState.value is Error) {
      String? errMsg = (loadingState.value as Error).errMsg;
      if (errMsg == '-352') {
        gaiaVtoken = null;
      }
    }
    return super.onReload();
  }

  late RxBool isLogin = Accounts.main.isLogin.obs;
  late Rx<LoadingState<List<LiveFollowingItemModel>?>> followListState =
      Rx(LoadingState.loading());
  late int followPage = 1;
  late bool followEnd = false;
  late RxInt liveCount = 0.obs;

  Future fetchLiveFollowing([bool isRefresh = true]) async {
    if (!isLogin.value || (isRefresh.not && followEnd)) {
      return;
    }
    if (isRefresh) {
      followPage = 1;
      followEnd = false;
    }
    dynamic res = await LiveHttp.liveFollowing(pn: followPage, ps: 20);
    if (res['status']) {
      LiveFollowingModel data = res['data'];
      liveCount.value = data.liveCount ?? 0;
      List<LiveFollowingItemModel>? dataList = data.list
          ?.where((LiveFollowingItemModel item) =>
              item.liveStatus == 1 && item.recordLiveTime == 0)
          .toList();
      if (dataList.isNullOrEmpty) {
        followEnd = true;
        if (isRefresh) {
          followListState.value = LoadingState.success(dataList);
        }
        return;
      }
      if (isRefresh) {
        if (dataList!.length >= liveCount.value) {
          followEnd = true;
        }
        followListState.value = LoadingState.success(dataList);
      } else if (followListState.value is Success) {
        List<LiveFollowingItemModel> list = followListState.value.data!
          ..addAll(dataList!);
        if (list.length >= liveCount.value) {
          followEnd = true;
        }
        followListState.refresh();
      }
      followPage++;
    } else if (isRefresh) {
      followListState.value = LoadingState.error(res['msg']);
    }
  }
}
