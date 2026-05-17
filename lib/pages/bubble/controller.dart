import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/bubble/category_list.dart';
import 'package:PiliPlus/models_new/bubble/data.dart';
import 'package:PiliPlus/models_new/bubble/dyn_list.dart';
import 'package:PiliPlus/models_new/bubble/sort_info.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter/material.dart' show TabController;
import 'package:get/get.dart';
import 'package:PiliPlus/utils/nav.dart';

class BubbleController extends CommonListController<BubbleData, DynList>
    with GetSingleTickerProviderStateMixin {
  BubbleController(this.categoryId);
  final Object? categoryId;

  late final Object tribeId;
  int? sortType;

  final Rxn<SortInfo> sortInfo = Rxn<SortInfo>();
  TabController? tabController;
  final RxnString tribeName = RxnString();
  final Rxn<List<CategoryList>> tabs = Rxn<List<CategoryList>>();

  @override
  void onInit() {
    super.onInit();
    tribeId = Nav.arguments['id'];
    queryData();
  }

  @override
  List<DynList>? getDataList(BubbleData response) {
    return response.content?.dynList;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<BubbleData> response) {
    if (isRefresh) {
      final data = response.response;
      sortInfo.value = data.sortInfo;
      if (categoryId == null) {
        tribeName.value = data.baseInfo?.tribeInfo?.title;
        if (tabController == null) {
          if (data.category?.categoryList case final categories?
              when categories.isNotEmpty) {
            tabController = TabController(
              length: categories.length,
              vsync: this,
            );
            tabs.value = categories;
          }
        }
      }
    }
    return false;
  }

  @override
  Future<LoadingState<BubbleData>> customGetData() => DynamicsHttp.bubble(
    tribeId: tribeId,
    categoryId: categoryId,
    sortType: sortType,
    page: page,
  );

  @override
  void onClose() {
    tabController?.dispose();
    tabController = null;
    super.onClose();
  }

  void onSort(int? sortType) {
    this.sortType = sortType;
    onReload();
  }
}
