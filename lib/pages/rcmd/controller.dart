import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/home/rcmd/result.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';

class RcmdController
    extends
        CommonListController<
          List<RcmdVideoItemAppModel>,
          RcmdVideoItemAppModel
        > {
  int? lastRefreshAt;

  @override
  void onInit() {
    super.onInit();
    page = 0;
    queryData();
  }

  @override
  Future<LoadingState<List<RcmdVideoItemAppModel>>> customGetData() =>
      VideoHttp.rcmdVideoListApp(freshIdx: page);

  @override
  void handleListResponse(List<RcmdVideoItemAppModel> dataList) {
    if (page == 0) {
      if (loadingState.value case Success(:final response)) {
        if (response != null && response.isNotEmpty) {
          lastRefreshAt = dataList.length;
          if (response.length > 200) {
            dataList.addAll(response.take(50));
          } else {
            dataList.addAll(response);
          }
        }
      }
    }
  }

  @override
  Future<void> onRefresh() {
    page = 0;
    isEnd = false;
    return queryData();
  }
}
