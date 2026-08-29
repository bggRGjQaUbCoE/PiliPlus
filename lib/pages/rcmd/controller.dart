import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/rcmd_mode.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/text_similarity.dart';
import 'package:get/get.dart';

class RcmdController extends CommonListController {
  static const int _emptyPageRetryLimit = 2;

  late bool enableSaveLastData = Pref.enableSaveLastData;
  final RxBool appRcmd = Pref.appRcmd.obs;
  final Rx<RcmdMode> rcmdMode = Pref.rcmdMode.obs;

  int? lastRefreshAt;
  late bool savedRcmdTip = Pref.savedRcmdTip;
  final TextDeduplicator _titleDeduplicator = TextDeduplicator();
  int _freshIndex = 0;

  @override
  int get initialPage => 0;

  @override
  bool get isEnd => false;

  @override
  bool get autoLoadMore => true;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<LoadingState> customGetData() async {
    LoadingState? lastResponse;
    for (var attempt = 0; attempt < _emptyPageRetryLimit; attempt++) {
      final freshIndex = _freshIndex;
      final anonymous = rcmdMode.value.anonymousForPage(freshIndex);
      final LoadingState response;
      if (!anonymous && appRcmd.value) {
        response = await VideoHttp.rcmdVideoListApp(freshIdx: freshIndex);
      } else {
        response = await VideoHttp.rcmdVideoList(
          freshIdx: freshIndex,
          ps: 20,
          anonymous: anonymous,
        );
      }
      lastResponse = response;
      if (response case Success(:final response)) {
        _freshIndex++;
        final data = response as List;
        data.removeWhere(_isDuplicateTitle);
        if (data.isNotEmpty) return lastResponse;
      } else {
        return lastResponse;
      }
    }
    return lastResponse ?? const Success(<dynamic>[]);
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
          final previous = response.length > 200 ? response.take(50) : response;
          for (final item in previous) {
            if (!_isDuplicateTitle(item)) {
              dataList.add(item);
            }
          }
        }
      }
    }
  }

  @override
  void resetForRefresh() {
    super.resetForRefresh();
    _freshIndex = 0;
    _titleDeduplicator.clear();
  }

  bool _isDuplicateTitle(dynamic item) => _titleDeduplicator.isDuplicate(
    item.title?.toString() ?? '',
    exact: Pref.hideDuplicateRecommendTitles,
    fuzzy: Pref.hideSimilarRecommendTitles,
  );

  Future<void> switchSource(bool value) async {
    if (appRcmd.value == value) return;
    await GStorage.setting.put(SettingBoxKey.appRcmd, value);
    appRcmd.value = value;
    lastRefreshAt = null;
    await onRefresh();
  }

  Future<void> switchMode(RcmdMode value) async {
    if (rcmdMode.value == value) return;
    await GStorage.setting.put(SettingBoxKey.rcmdMode, value.index);
    rcmdMode.value = value;
    lastRefreshAt = null;
    await onRefresh();
  }
}
