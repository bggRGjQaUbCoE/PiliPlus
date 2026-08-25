import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/group.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class DynMentionController
    extends CommonListController<List<MentionGroup>?, MentionGroup> {
  final focusNode = FocusNode();
  final controller = TextEditingController();

  final RxBool enableClear = false.obs;

  final RxBool showBtn = false.obs;
  Set<MentionItem>? mentionList;

  void updateBtn() {
    showBtn.value = mentionList?.isNotEmpty == true;
  }

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<void> onRefresh() {
    mentionList?.clear();
    showBtn.value = false;
    return super.onRefresh();
  }

  @override
  Future<LoadingState<List<MentionGroup>?>> customGetData() =>
      DynamicsHttp.dynMention(keyword: controller.text);

  @override
  void onClose() {
    focusNode.dispose();
    controller.dispose();
    mentionList?.clear();
    mentionList = null;
    super.onClose();
  }

  void onCheck(bool? value, MentionItem item) {
    if (value == true) {
      (mentionList ??= <MentionItem>{}).add(item);
    } else {
      mentionList!.remove(item);
    }
    updateBtn();
  }
}
