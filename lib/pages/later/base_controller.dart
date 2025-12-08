import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';

class LaterBaseController extends GetxController {
  RxBool enableMultiSelect = false.obs;
  RxInt checkedCount = 0.obs;

  RxMap<LaterViewType, int> counts = {
    for (final item in LaterViewType.values) item: -1,
  }.obs;

  late double dx = 0;
  late final RxBool isPlayAll = Pref.enablePlayAll.obs;
  
  // 当前激活的 tab 索引
  RxInt currentTabIndex = 0.obs;

  void setIsPlayAll(bool isPlayAll) {
    if (this.isPlayAll.value == isPlayAll) return;
    this.isPlayAll.value = isPlayAll;
    GStorage.setting.put(SettingBoxKey.enablePlayAll, isPlayAll);
  }
}
