import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DynamicsTabController
    extends CommonListController<DynamicsDataModel, DynamicItemModel> {
  DynamicsTabController({required this.dynamicsType});
  final String dynamicsType;
  String offset = '';
  int mid = -1;
  late final MainController mainController = Get.find<MainController>();

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future onRefresh() {
    if (dynamicsType == 'all') {
      mainController.setCount();
    }
    offset = '';
    return super.onRefresh();
  }

  @override
  List<DynamicItemModel>? getDataList(DynamicsDataModel response) {
    return response.items;
  }

  @override
  bool customHandleResponse(
      bool isRefresh, Success<DynamicsDataModel> response) {
    offset = response.response.offset ?? '';
    return false;
  }

  @override
  Future<LoadingState<DynamicsDataModel>> customGetData() =>
      DynamicsHttp.followDynamic(
        type: dynamicsType == "up" ? "all" : dynamicsType,
        offset: offset,
        mid: dynamicsType == "up" ? mid : -1,
      );

  Future onRemove(dynamic dynamicId) async {
    var res = await MsgHttp.removeDynamic(dynIdStr: dynamicId);
    if (res['status']) {
      loadingState.value.data!.removeWhere((item) => item.idStr == dynamicId);
      loadingState.refresh();
      SmartDialog.showToast('删除成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future onSetTop(bool isTop, dynamic dynamicId) async {
    var res = await DynamicsHttp.setTop(dynamicId: dynamicId);
    if (res['status']) {
      SmartDialog.showToast('${isTop ? '取消' : ''}置顶成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  @override
  Future onReload() {
    scrollController.jumpToTop();
    return super.onReload();
  }
}
