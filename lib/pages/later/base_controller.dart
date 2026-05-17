import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/pages/common/play_all_btn_mixin.dart';
import 'package:get/get.dart';

class LaterBaseController extends GetxController with PlayAllBtnMixin {
  RxBool enableMultiSelect = false.obs;
  RxInt checkedCount = 0.obs;

  RxList<int> counts = List.filled(LaterViewType.values.length, -1).obs;
}
