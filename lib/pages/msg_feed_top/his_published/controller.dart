import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/comment_record.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class HisPublishedController
    extends CommonListController<List<CommentRecord>, CommentRecord> {
  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<CommentRecord>? getDataList(List<CommentRecord> response) {
    isEnd = true;
    return response;
  }

  @override
  Future<LoadingState<List<CommentRecord>>> customGetData() async {
    try {
      final records = GStorage.commentRecords.values.toList();
      records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return Success(records);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<void> onRemove(int index) async {
    try {
      final record = loadingState.value.data![index];
      await record.delete();
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
      SmartDialog.showToast('删除成功');
    } catch (_) {
      SmartDialog.showToast('删除失败');
    }
  }
}
