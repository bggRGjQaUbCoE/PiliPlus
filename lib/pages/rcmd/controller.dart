import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/rcmd_source.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

class RcmdController extends CommonListController {
  late bool enableSaveLastData = Pref.enableSaveLastData;

  /// 可在设置页切换后立即生效，无需重启
  RcmdSource rcmdSource = Pref.rcmdSource;

  int? lastRefreshAt;
  late bool savedRcmdTip = Pref.savedRcmdTip;

  @override
  bool get isEnd => false;

  @override
  void onInit() {
    super.onInit();
    page = 0;
    queryData();
  }

  @override
  Future<LoadingState> customGetData() {
    return switch (rcmdSource) {
      RcmdSource.app => VideoHttp.rcmdVideoListApp(freshIdx: page),
      // 桌面端：同一公开接口 + PC 端参数组合，ps 取接口上限 30
      RcmdSource.desktop => VideoHttp.rcmdVideoList(
        freshIdx: page,
        ps: 30,
        desktop: true,
      ),
      RcmdSource.web => VideoHttp.rcmdVideoList(freshIdx: page, ps: 20),
    };
  }

  @override
  bool handleError(String? errMsg) {
    return enableSaveLastData;
  }

  @override
  void handleListResponse(List dataList) {
    if (enableSaveLastData && page == 0) {
      if (loadingState.value case Success(:final response)) {
        if (response != null && response.isNotEmpty) {
          if (savedRcmdTip) {
            lastRefreshAt = dataList.length;
          }
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
