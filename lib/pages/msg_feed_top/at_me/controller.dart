import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/msg/msgfeed_at_me.dart';

class AtMeController extends CommonController {
  int cursor = -1;
  int cursorTime = -1;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  bool customHandleResponse(Success response) {
    MsgFeedAtMe data = response.response;
    if (data.cursor?.isEnd == true || data.items.isNullOrEmpty) {
      isEnd = true;
    }
    cursor = data.cursor?.id ?? -1;
    cursorTime = data.cursor?.time ?? -1;
    if (currentPage != 1 && loadingState.value is Success) {
      loadingState.value = LoadingState.success(
          (loadingState.value as Success).response as List
            ..addAll(data.items ?? <AtMeItems>[]));
    } else {
      loadingState.value = LoadingState.success(data.items);
    }
    return true;
  }

  @override
  Future onRefresh() {
    cursor = -1;
    cursorTime = -1;
    return super.onRefresh();
  }

  @override
  Future<LoadingState> customGetData() =>
      MsgHttp.msgFeedAtMe(cursor: cursor, cursorTime: cursorTime);
}
