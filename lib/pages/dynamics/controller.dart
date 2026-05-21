import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart' show ScrollController, TabController;
import 'package:get/get.dart';

class DynamicsController extends GetxController
    with GetSingleTickerProviderStateMixin, ScrollOrRefreshMixin, AccountMixin {
  @override
  final ScrollController scrollController = ScrollController();
  late final TabController tabController;

  late final RxInt mid = (-1).obs;
  late int currentMid = -1;

  Set<int> tempBannedList = <int>{};

  final Rx<LoadingState<FollowUpModel>> upState =
      LoadingState<FollowUpModel>.loading().obs;
  late bool _upEnd = false;
  late bool showLiveUp = false;

  final upPanelPosition = Pref.upPanelPosition;

  @override
  final AccountService accountService = Get.find<AccountService>();

  DynamicsTabController? get controller {
    try {
      return Get.find<DynamicsTabController>(
        tag: DynamicsTabType.values[tabController.index].name,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      length: DynamicsTabType.values.length,
      vsync: this,
    );
    queryFollowUp();
  }

  void onLoadMoreUp() {
    queryUpList();
  }

  Future<void> queryUpList() async {
    if (isQuerying || _upEnd) return;
    isQuerying = true;

    final res = await DynamicsHttp.dynUpList(upState.value.data.offset);

    if (res case Success(:final response)) {
      if (response.hasMore == false || response.offset.isNullOrEmpty) {
        _upEnd = true;
      }
      final upData = upState.value.data
        ..hasMore = response.hasMore
        ..offset = response.offset;
      final list = response.upList;
      if (list != null && list.isNotEmpty) {
        upData.upList.addAll(list);
        upState.refresh();
      }
    }

    isQuerying = false;
  }

  late bool isQuerying = false;
  Future<void> queryFollowUp() async {
    if (isQuerying) return;
    isQuerying = true;

    if (!accountService.isLogin.value) {
      upState.value = const Error(null);
      isQuerying = false;
      return;
    }

    // reset
    _upEnd = false;

    final res = await DynamicsHttp.followUp();

    if (res case final Success<FollowUpModel> i) {
      final data = i.response;
      if (data.hasMore == false || data.offset.isNullOrEmpty) {
        _upEnd = true;
      }
      upState.value = Success(data);
    } else {
      upState.value = const Error(null);
    }

    isQuerying = false;
  }

  void onSelectUp(int mid) {
    if (this.mid.value == mid) {
      tabController.index = (mid == -1 ? 0 : 4);
      if (mid == -1) {
        queryFollowUp();
      }
      controller?.onReload();
      return;
    }

    this.mid.value = mid;
    tabController.index = (mid == -1 ? 0 : 4);
  }

  @override
  Future<void> onRefresh() {
    _refreshFollowUp();
    return controller!.onRefresh();
  }

  void _refreshFollowUp() {
    queryFollowUp();
  }

  @override
  void animateToTop() {
    controller?.animateToTop();
    scrollController.animToTop();
  }

  @override
  void onClose() {
    mid.close();
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  @override
  void onChangeAccount(bool isLogin) => _refreshFollowUp();
}
