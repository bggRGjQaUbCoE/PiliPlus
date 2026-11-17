import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

abstract class CommonSearchController<R, T> extends CommonListController<R, T> {
  final editController = TextEditingController();
  final focusNode = FocusNode();
  String? _submittedQuery;

  @override
  void onInit() {
    super.onInit();
    loadingState.value = const Success(null);
  }

  bool onClear() {
    if (editController.text.isNotEmpty) {
      editController.clear();
      onRefresh();
      return true;
    } else {
      Get.back();
      return false;
    }
  }

  @override
  Future<void> onRefresh() {
    if (isClosed) return Future.value();
    if (editController.value.text.isEmpty) {
      final invalidate =
          _submittedQuery != null ||
          isLoading ||
          loadingState.value.dataOrNull != null;
      _submittedQuery = null;
      if (invalidate) return onReload();
      loadingState.value = const Success(null);
      return Future.syncValue(null);
    }
    if (_submittedQuery != editController.text) {
      _submittedQuery = editController.text;
      return onReload();
    }
    return super.onRefresh();
  }

  @override
  void onClose() {
    editController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
