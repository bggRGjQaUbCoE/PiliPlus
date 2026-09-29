import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/l10n/l10n.dart';
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
      loadingState
        ..value.data!.removeWhere((item) => item.idStr == dynamicId)
        ..refresh();
      SmartDialog.showToast(L10n.current.commonWhisperControllerOnRemoveText);
    } else {
      res.toast();
    }
  }

  Future<void> onSetTop(bool isTop, Object dynamicId) async {
    final res = await (isTop
        ? DynamicsHttp.rmTop(dynamicId: dynamicId)
        : DynamicsHttp.setTop(dynamicId: dynamicId));
    if (res.isSuccess) {
      List<DynamicItemModel> list = loadingState.value.data!;
      list[0].modules
        ..moduleTag = null
        ..moduleAuthor?.isTop = false;
      if (isTop) {
        loadingState.refresh();
        SmartDialog.showToast(
          L10n.current.memberDynamicsControllerOnSetTopText3,
        );
      } else {
        final item = list.firstWhere((item) => item.idStr == dynamicId);
        item.modules
          ..moduleTag = ModuleTag(text: L10n.current.pin)
          ..moduleAuthor?.isTop = true;
        list
          ..remove(item)
          ..insert(0, item);
        loadingState.refresh();
        SmartDialog.showToast(
          L10n.current.memberDynamicsControllerOnSetTopText2,
        );
      }
    } else {
      res.toast();
    }
  }
}
