import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/utils/storage.dart';

class RcmdController extends CommonController {
  late bool enableSaveLastData = GStorage.setting
      .get(SettingBoxKey.enableSaveLastData, defaultValue: false);
  late bool appRcmd = true;

  int? lastRefreshAt;
  late bool savedRcmdTip = GStorage.savedRcmdTip;

  @override
  void onInit() {
    super.onInit();
    appRcmd = GStorage.appRcmd;

    currentPage = 0;
    queryData();
  }

  @override
  Future<LoadingState> customGetData() {
    return appRcmd
        ? VideoHttp.rcmdVideoListApp(freshIdx: currentPage)
        : VideoHttp.rcmdVideoList(freshIdx: currentPage, ps: 20);
  }

  @override
  List? handleListResponse(List currentList, List dataList) {
    bool shouldSaveLast =
        enableSaveLastData && currentPage == 0 && currentList.isNotEmpty;
    if (shouldSaveLast && currentList.length > 500) {
      currentList = currentList.sublist(0, 50);
    }
    lastRefreshAt = shouldSaveLast && savedRcmdTip ? dataList.length : null;
    return shouldSaveLast ? dataList + currentList : null;
  }

  @override
  Future onRefresh() async {
    currentPage = 0;
    isEnd = false;
    await queryData();
  }
}
