import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:get/get.dart';

/// 单个 UP（或「全部动态」）的动态流
///
/// 与 [DynamicsTabController] 的区别：数据源固定为某个 host_mid，
/// 供「逐个浏览 UP」的横向分页使用。
class DynUpFeedController
    extends CommonListController<DynamicsDataModel, DynamicItemModel>
    with AccountMixin, RefreshImplMixin {
  DynUpFeedController({required this.mid});

  /// -1 表示「全部动态」（不带 host_mid 过滤）
  final int mid;

  String? offset;

  bool get isAll => mid == -1;

  /// 动态页的全局状态可能已经被回收，取不到就退化为空
  DynamicsController? get _dynamicsController {
    try {
      return Get.find<DynamicsController>();
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<DynamicItemModel>? getDataList(DynamicsDataModel response) {
    offset = response.offset;
    if (response.hasMore != true) {
      isEnd = true;
    }
    return response.items;
  }

  @override
  Future<LoadingState<DynamicsDataModel>> customGetData() =>
      DynamicsHttp.followDynamic(
        offset: offset,
        type: isAll ? .all : .up,
        hostMid: isAll ? null : mid,
        tempBannedList: _dynamicsController?.tempBannedList,
      );

  @override
  Future<void> onRefresh() {
    offset = null;
    return super.onRefresh();
  }

  @override
  void onChangeAccount(bool isLogin) => onReload();

  Future<void> onRemove(int index, dynamic dynamicId) async {
    final res = await MsgHttp.removeDynamic(dynIdStr: dynamicId);
    if (res.isSuccess) {
      loadingState
        ..value.data?.removeAt(index)
        ..refresh();
    } else {
      res.toast();
    }
  }

  void onBlock(int index) {
    loadingState
      ..value.data?.removeAt(index)
      ..refresh();
  }

  void onUnfold(DynamicItemModel item, int index) {
    try {
      final list = loadingState.value.data!;
      final ids = item.modules.moduleFold!.ids!;
      final flag = index + ids.length + 1;
      for (int i = index + 1; i < flag; i++) {
        list[i].visible = true;
      }
      item.modules.moduleFold = null;
      loadingState.refresh();
    } catch (_) {}
  }
}
