import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_area_list/area_item.dart';
import 'package:PiliPlus/models_new/live/live_area_list/area_list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:flutter/material.dart' show TabController;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LiveAreaController extends CommonListController<List<AreaList>?, AreaList>
    with GetSingleTickerProviderStateMixin {
  late final isLogin = Accounts.main.isLogin;

  late final isEditing = false.obs;
  late final favInfo = {};

  TabController? tabController;

  @override
  void onInit() {
    super.onInit();
    if (isLogin) {
      queryFavTags();
    }
    queryData();
  }

  @override
  Future<void> onRefresh() {
    if (isLogin) {
      queryFavTags();
    }
    return super.onRefresh();
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<List<AreaList>?> response) {
    assert(tabController == null);
    final length = response.response?.length;
    if (length != null && length != 0) {
      tabController = TabController(length: length, vsync: this);
    }
    return super.customHandleResponse(isRefresh, response);
  }

  Rx<LoadingState<List<AreaItem>>> favState =
      LoadingState<List<AreaItem>>.loading().obs;

  @override
  Future<LoadingState<List<AreaList>?>> customGetData() =>
      LiveHttp.liveAreaList();

  Future<void> queryFavTags() async {
    favState.value = await LiveHttp.getLiveFavTag();
  }

  Future<void> setFavTag() async {
    if (favState.value case Success(:final response)) {
      final res = await LiveHttp.setLiveFavTag(
        ids: response.map((e) => e.id).join(','),
      );
      if (res.isSuccess) {
        isEditing.toggle();
        SmartDialog.showToast('设置成功');
      } else {
        res.toast();
      }
    } else {
      isEditing.toggle();
    }
  }

  void onEdit() {
    if (isEditing.value) {
      setFavTag();
    } else {
      isEditing.toggle();
    }
  }

  @override
  void onClose() {
    tabController?.dispose();
    tabController = null;
    super.onClose();
  }
}
