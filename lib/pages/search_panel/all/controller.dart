import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/models/search/search_esports.dart';
import 'package:PiliPlus/pages/search_panel/video/controller.dart';
import 'package:PiliPlus/utils/crisis_helper.dart';

class SearchAllController extends SearchVideoController with SearchVideoMixin {
  SearchAllController({
    required super.keyword,
    required super.searchType,
    required super.tag,
  });

  List<SearchUser>? searchUser;
  List<SearchPgcItemModel>? searchMedia;
  List<SearchActivity>? searchActivity;
  SearchEsports? searchEsports;
  List<SearchTip>? searchTips;

  /// 命中高危词且服务端未下发提示卡片时置为 true。
  /// 此时展示整页关怀卡片，并屏蔽搜索结果。
  bool isCrisis = false;

  @override
  bool customHandleResponse(bool isRefresh, Success<SearchVideoData> response) {
    final res = response.response;
    if (isRefresh) {
      searchType_ = .video;
      searchUser = res.searchUser;
      searchMedia = res.searchMedia;
      searchActivity = res.searchActivity;
      searchEsports = res.searchEsports;
      searchTips = res.searchTips;
      // 服务端已下发卡片时与官方行为一致（小卡片 + 正常结果）；
      // 服务端静默压制的词才走本地兜底。
      isCrisis = searchTips == null && CrisisHelper.isCrisis(keyword);
    }
    final handled = super.customHandleResponse(isRefresh, response);
    // 高危词下隐藏结果数量角标（-1 表示不展示）
    if (isCrisis) {
      searchResultController?.count[searchType.index] = -1;
    }
    return handled;
  }

  @override
  late var searchType_ = searchType;

  void _computeActualSearchType() {
    if (order.isNotEmpty ||
        videoDurationType != .all ||
        videoZoneType != .all ||
        pubBegin != null ||
        pubEnd != null) {
      searchType_ = .video;
      return;
    }
    searchType_ = .all;
  }

  @override
  Future<void> onRefresh() {
    _computeActualSearchType();
    searchUser = null;
    searchMedia = null;
    searchActivity = null;
    searchEsports = null;
    searchTips = null;
    isCrisis = false;
    return super.onRefresh();
  }
}
