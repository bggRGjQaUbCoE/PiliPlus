import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/model_rec_video_item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

class RcmdController
    extends
        CommonListController<
          List<BaseRecVideoItemModel>,
          BaseRecVideoItemModel
        > {
  late bool enableSaveLastData = Pref.enableSaveLastData;
  final bool appRcmd = Pref.appRcmd;

  int? lastRefreshAt;
  late bool savedRcmdTip = Pref.savedRcmdTip;

  @override
  void onInit() {
    super.onInit();
    page = 0;
    queryData();
  }

  @override
  Future<LoadingState<List<BaseRecVideoItemModel>>> customGetData() {
    return appRcmd
        ? VideoHttp.rcmdVideoListApp(freshIdx: page)
        : VideoHttp.rcmdVideoList(freshIdx: page, ps: 20);
  }

  @override
  void handleListResponse(List<BaseRecVideoItemModel> dataList) {
    if (enableSaveLastData && page == 0 && loadingState.value.isSuccess) {
      final currentList = loadingState.value.data;
      if (currentList?.isNotEmpty == true) {
        if (savedRcmdTip) {
          lastRefreshAt = dataList.length;
        }
        if (currentList!.length > 500) {
          currentList.removeRange(50, currentList.length);
        }
        dataList.addAll(currentList);
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
