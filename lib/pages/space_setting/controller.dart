import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models_new/space_setting/data.dart';
import 'package:PiliPlus/models_new/space_setting/privacy.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class SpaceSettingController
    extends CommonDataController<SpaceSettingData, Privacy?> {
  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  bool? hasMod;

  @override
  bool customHandleResponse(
    bool isRefresh,
    Success<SpaceSettingData> response,
  ) {
    loadingState.value = Success(response.response.privacy);
    return true;
  }

  @override
  Future<LoadingState<SpaceSettingData>> customGetData() =>
      UserHttp.spaceSetting();

  Future<void> onMod() async {
    if ((hasMod ?? false) && loadingState.value.isSuccess) {
      Privacy? data = loadingState.value.data;
      if (data != null) {
        var res = await UserHttp.spaceSettingMod(
          {
            for (var e in data.list1) e.key: e.value,
            for (var e in data.list2) e.key: e.value,
            for (var e in data.list3) e.key: e.value,
          },
        );
        if (!res['status']) {
          SmartDialog.showToast(res['msg']);
        }
      }
    }
  }
}
