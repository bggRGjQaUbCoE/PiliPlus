import 'dart:math';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/rcmd_mode.dart';
import 'package:PiliPlus/models/model_rec_video_item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

class RcmdController extends CommonListController {
  late bool enableSaveLastData = Pref.enableSaveLastData;
  final RcmdMode rcmdMode = Pref.rcmdMode;
  bool get appRcmd => rcmdMode == RcmdMode.app;

  int? lastRefreshAt;
  late bool savedRcmdTip = Pref.savedRcmdTip;

  // 合并模式专用页码：Web端由基类 page 管理（自动 ++），App端在此自管
  int _appPage = 0;
  bool _isFirstPage = false;

  @override
  bool get isEnd => false;

  @override
  void onInit() {
    super.onInit();
    page = 0;
    _appPage = 0;
    queryData();
  }

  @override
  Future<LoadingState> customGetData() async {
    if (rcmdMode != RcmdMode.merged) {
      // 单源模式
      _isFirstPage = (page == 0);
      return appRcmd
          ? VideoHttp.rcmdVideoListApp(freshIdx: page)
          : VideoHttp.rcmdVideoList(freshIdx: page, ps: 20);
    }

    // 合并模式：并行请求
    _isFirstPage = (page == 0 && _appPage == 0);
    final results = await Future.wait([
      VideoHttp.rcmdVideoList(freshIdx: page, ps: 20),
      VideoHttp.rcmdVideoListApp(freshIdx: _appPage),
    ]);

    // 静默降级：一个成功就展示
    List<BaseRcmdVideoItemModel> webList = [];
    List<BaseRcmdVideoItemModel> appList = [];
    if (results[0] case Success(:final response)) {
      webList = response;
    } else {
      logger.w('Web端推荐获取失败: ${results[0]}');
    }
    if (results[1] case Success(:final response)) {
      appList = response;
    } else {
      logger.w('App端推荐获取失败: ${results[1]}');
    }

    // 交错排列 + 按 aid 去重
    final seen = <int>{};
    final merged = <BaseRcmdVideoItemModel>[];
    final minLen = min(appList.length, webList.length);
    for (int i = 0; i < minLen; i++) {
      if (appList[i].aid != null && seen.add(appList[i].aid!)) {
        merged.add(appList[i]);
      }
      if (webList[i].aid != null && seen.add(webList[i].aid!)) {
        merged.add(webList[i]);
      }
    }
    // 多出的部分追加到末尾
    for (int i = minLen; i < appList.length; i++) {
      if (appList[i].aid != null && seen.add(appList[i].aid!)) {
        merged.add(appList[i]);
      }
    }
    for (int i = minLen; i < webList.length; i++) {
      if (webList[i].aid != null && seen.add(webList[i].aid!)) {
        merged.add(webList[i]);
      }
    }

    _appPage++; // App端页码自增（Web端由基类 page++ 管理）

    return Success(merged);
  }

  @override
  bool handleError(String? errMsg) {
    return enableSaveLastData;
  }

  @override
  void handleListResponse(List dataList) {
    if (enableSaveLastData && _isFirstPage) {
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
    _appPage = 0; // 重置 App 端页码
    isEnd = false;
    return queryData();
  }
}
