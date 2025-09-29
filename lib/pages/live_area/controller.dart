import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_area_list/area_item.dart';
import 'package:PiliPlus/models_new/live/live_area_list/area_list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LiveAreaController
    extends CommonListController<List<AreaList>?, AreaList> {
  AccountService accountService = Get.find<AccountService>();

  late final isEditing = false.obs;
  late final favInfo = {};

  @override
  void onInit() {
    super.onInit();
    if (accountService.isLogin.value) {
      queryFavTags();
    }
    queryData();
  }

  @override
  Future<void> onRefresh() {
    if (accountService.isLogin.value) {
      queryFavTags();
    }
    return super.onRefresh();
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
    if (favState.value.isSuccess) {
      final res = await LiveHttp.setLiveFavTag(
        ids: favState.value.data.map((e) => e.id).join(','),
      );
      if (res['status']) {
        isEditing.value = !isEditing.value;
        SmartDialog.showToast('设置成功');
      } else {
        SmartDialog.showToast(res['msg']);
      }
    } else {
      isEditing.value = !isEditing.value;
    }
  }

  void onEdit() {
    if (isEditing.value) {
      setFavTag();
    } else {
      isEditing.value = !isEditing.value;
    }
  }
}
