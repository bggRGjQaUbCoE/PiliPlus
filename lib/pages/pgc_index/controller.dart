import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/pgc.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_condition/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_condition/sort.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_result/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_result/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

class PgcIndexController
    extends CommonListController<PgcIndexResult, PgcIndexItem> {
  PgcIndexController(this.indexType);
  int? indexType;
  Rx<LoadingState<PgcIndexConditionData>> conditionState =
      LoadingState<PgcIndexConditionData>.loading().obs;

  late final RxBool isExpand = false.obs;

  RxMap<String, dynamic> indexParams = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getPgcIndexCondition();
  }

  Future<void> getPgcIndexCondition() async {
    var res = await PgcHttp.pgcIndexCondition(
      seasonType: indexType == null ? 1 : null,
      type: 0,
      indexType: indexType,
    );
    if (res.isSuccess) {
      PgcIndexConditionData data = res.data;
      if (data.order?.isNotEmpty == true) {
        indexParams['order'] = data.order!.first.field;
      }
      if (data.filter?.isNotEmpty == true) {
        for (PgcConditionFilter item in data.filter!) {
          indexParams['${item.field}'] = item.values?.firstOrNull?.keyword;
        }
      }
      queryData();
    }
    conditionState.value = res;
  }

  @override
  Future<LoadingState<PgcIndexResult>> customGetData() =>
      PgcHttp.pgcIndexResult(
        page: page,
        params: indexParams,
        seasonType: indexType == null ? 1 : null,
        type: 0,
        indexType: indexType,
      );

  @override
  List<PgcIndexItem>? getDataList(PgcIndexResult response) {
    if (response.hasNext == null || response.hasNext == 0) {
      isEnd = true;
    }
    return response.list;
  }
}
