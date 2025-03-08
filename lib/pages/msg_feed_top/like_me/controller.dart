import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/models/msg/msgfeed_like_me.dart';

class LikeMeController extends CommonController {
  int cursor = -1;
  int cursorTime = -1;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  bool customHandleResponse(Success response) {
    MsgFeedLikeMe data = response.response;
    if (data.total?.cursor?.isEnd == true ||
        data.total?.items.isNullOrEmpty == true) {
      isEnd = true;
    }
    cursor = data.total?.cursor?.id ?? -1;
    cursorTime = data.total?.cursor?.time ?? -1;
    List<LikeMeItems> latest = data.latest?.items ?? [];
    List<LikeMeItems> total = data.total?.items ?? [];
    if (currentPage != 1 && loadingState.value is Success) {
      loadingState.value = LoadingState.success((loadingState.value as Success)
          .response as Pair<List<LikeMeItems>, List<LikeMeItems>>
        ..first.addAll(latest)
        ..second.addAll(total));
    } else {
      loadingState.value =
          LoadingState.success(Pair(first: latest, second: total));
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
      MsgHttp.msgFeedLikeMe(cursor: cursor, cursorTime: cursorTime);
}
