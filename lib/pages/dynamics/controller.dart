import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';

class DynamicsController
    extends CommonDataController<FollowUpModel, FollowUpModel>
    with AccountMixin {
  String? offset;

  bool isEnd = false;
  late bool showLiveUp = false;
  final Set<int> tempBannedList = <int>{};
  final upPanelPosition = Pref.upPanelPosition;

  late final innerController = Get.find<DynamicsTabController>();

  @override
  final AccountService accountService = Get.find<AccountService>();

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<FollowUpModel> response) {
    final res = response.response;
    offset = res.offset;
    if (!isRefresh) {
      final lastData = loadingState.value.data;
      if (res.upList case final upList?) {
        lastData.upList!.addAll(upList);
      }
      res
        ..liveUsers = lastData.liveUsers
        ..upList = lastData.upList;
    }
    if (res.hasMore != true || offset.isNullOrEmpty) {
      isEnd = true;
    }
    return false;
  }

  @override
  Future<LoadingState<FollowUpModel>> customGetData() {
    if (offset == null) {
      return DynamicsHttp.followUp();
    }
    return DynamicsHttp.dynUpList(offset);
  }

  Future<void> singleRefresh() {
    offset = null;
    isEnd = false;
    return super.onRefresh();
  }

  @override
  Future<void> onRefresh() {
    singleRefresh();
    return innerController.onRefresh();
  }

  @override
  Future<void> queryData([bool isRefresh = true]) {
    if (!isRefresh && isEnd) return Future.value();
    return super.queryData(isRefresh);
  }

  @override
  void animateToTop() {
    super.animateToTop();
    innerController.scrollController.animToTop();
  }

  @override
  void onChangeAccount(bool isLogin) => onReload();
}
