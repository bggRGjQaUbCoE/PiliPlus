import 'dart:math';

import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_area_list/area_item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:material_ui/material_ui.dart' show TabController;
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';

class LiveAreaDetailController
    extends CommonListController<List<AreaItem>?, AreaItem>
    with GetSingleTickerProviderStateMixin {
  LiveAreaDetailController(this.areaId, this.parentAreaId);
  final dynamic areaId;
  final dynamic parentAreaId;

  TabController? tabController;

  bool showFirstFrame = false;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<AreaItem>? getDataList(List<AreaItem>? response) {
    if (response != null && response.isNotEmpty) {
      assert(tabController == null);
      final initialIndex = max(0, response.indexWhere((e) => e.id == areaId));
      tabController = TabController(
        length: response.length,
        initialIndex: initialIndex,
        vsync: this,
      );
    }
    return response;
  }

  @override
  Future<LoadingState<List<AreaItem>?>> customGetData() =>
      LiveHttp.liveRoomAreaList(parentid: parentAreaId);

  @override
  void onClose() {
    tabController?.dispose();
    tabController = null;
    super.onClose();
  }
}
