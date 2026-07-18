import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

bool removeMemberDynamicById(
  List<DynamicItemModel>? list,
  Object? dynamicId,
) {
  if (list == null) return false;
  final index = list.indexWhere((item) => item.idStr == dynamicId);
  if (index == -1) return false;
  list.removeAt(index);
  return true;
}

bool reconcileMemberDynamicTop(
  List<DynamicItemModel>? list, {
  required bool wasTop,
  required Object dynamicId,
}) {
  if (list == null) return false;
  final targetIndex = list.indexWhere((item) => item.idStr == dynamicId);
  if (targetIndex == -1) return false;

  void clearPinnedState(DynamicItemModel item) {
    final modules = item.modules;
    if (modules.moduleTag?.text == '置顶') {
      modules.moduleTag = null;
    }
    if (modules.moduleAuthor?.isTop == true) {
      modules.moduleAuthor!.isTop = false;
    }
  }

  final target = list[targetIndex];
  if (wasTop) {
    clearPinnedState(target);
    return true;
  }

  for (final item in list) {
    clearPinnedState(item);
  }
  target.modules
    ..moduleTag = ModuleTag(text: '置顶')
    ..moduleAuthor?.isTop = true;
  list
    ..removeAt(targetIndex)
    ..insert(0, target);
  return true;
}

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
      return Future.syncValue(null);
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
    final res = await MsgHttp.removeDynamic(dynIdStr: dynamicId);
    if (res.isSuccess) {
      if (removeMemberDynamicById(
        loadingState.value.dataOrNull,
        dynamicId,
      )) {
        loadingState.refresh();
      }
      reconcileAfterMutation().ignore();
      SmartDialog.showToast('删除成功');
    } else {
      res.toast();
    }
  }

  Future<void> onSetTop(bool isTop, Object dynamicId) async {
    final res = await (isTop
        ? DynamicsHttp.rmTop(dynamicId: dynamicId)
        : DynamicsHttp.setTop(dynamicId: dynamicId));
    if (res.isSuccess) {
      if (reconcileMemberDynamicTop(
        loadingState.value.dataOrNull,
        wasTop: isTop,
        dynamicId: dynamicId,
      )) {
        loadingState.refresh();
      }
      reconcileAfterMutation().ignore();
      SmartDialog.showToast(isTop ? '取消置顶成功' : '置顶成功');
    } else {
      res.toast();
    }
  }
}
