import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class MemberDynamicsController
    extends CommonListController<DynamicsDataModel, DynamicItemModel> {
  MemberDynamicsController(this.mid);
  int mid;
  String offset = '';

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<void> onRefresh() {
    offset = '';
    return super.onRefresh();
  }

  @override
  Future<void> queryData([bool isRefresh = true]) {
    if (!isRefresh && (isEnd || offset == '-1')) {
      return Future.value();
    }
    return super.queryData(isRefresh);
  }

  @override
  List<DynamicItemModel>? getDataList(DynamicsDataModel response) {
    offset = response.offset?.isNotEmpty == true ? response.offset! : '-1';
    if (response.hasMore == false) {
      isEnd = true;
    }
    return response.items;
  }

  @override
  Future<LoadingState<DynamicsDataModel>> customGetData() =>
      MemberHttp.memberDynamic(
        offset: offset,
        mid: mid,
      );

  Future<void> onRemove(dynamic dynamicId) async {
    var res = await MsgHttp.removeDynamic(dynIdStr: dynamicId);
    if (res['status']) {
      loadingState
        ..value.data!.removeWhere((item) => item.idStr == dynamicId)
        ..refresh();
      SmartDialog.showToast('删除成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future<void> onSetTop(bool isTop, Object dynamicId) async {
    var res = isTop
        ? await DynamicsHttp.rmTop(dynamicId: dynamicId)
        : await DynamicsHttp.setTop(dynamicId: dynamicId);
    if (res['status']) {
      List<DynamicItemModel> list = loadingState.value.data!;
      list[0].modules.moduleTag = null;
      if (isTop) {
        loadingState.refresh();
        SmartDialog.showToast('取消置顶成功');
      } else {
        final item = list.firstWhere((item) => item.idStr == dynamicId);
        item.modules.moduleTag = ModuleTag(text: '置顶');
        list
          ..remove(item)
          ..insert(0, item);
        loadingState.refresh();
        SmartDialog.showToast('置顶成功');
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
