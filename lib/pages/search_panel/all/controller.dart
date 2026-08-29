import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/search/search_type.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/pages/search_panel/controller.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/text_similarity.dart';

class SearchAllController
    extends SearchPanelController<SearchAllData, dynamic> {
  static const int _emptyPageRetryLimit = 4;

  SearchAllController({
    required super.keyword,
    required super.searchType,
    required super.tag,
  });

  late bool hasJump2Video = false;
  final TextDeduplicator _titleDeduplicator = TextDeduplicator();
  bool _filteredEmptyPage = false;

  @override
  void onInit() {
    hasFooter = true;
    super.onInit();
    jump2Video();
  }

  @override
  List? getDataList(response) {
    return response.list;
  }

  @override
  void resetForRefresh() {
    super.resetForRefresh();
    _titleDeduplicator.clear();
  }

  @override
  bool customHandleResponse(bool isRefresh, Success response) {
    searchResultController?.count[searchType.index] =
        response.response.numResults ?? 0;
    if (searchType == SearchType.video && !hasJump2Video && isRefresh) {
      hasJump2Video = true;
      onPushDetail(response.response.list);
    }
    return false;
  }

  @override
  Future<LoadingState<SearchAllData>> customGetData() async {
    _filteredEmptyPage = false;
    LoadingState<SearchAllData>? lastResponse;
    int currentPage = page;
    for (var attempt = 0; attempt < _emptyPageRetryLimit; attempt++) {
      final response = await SearchHttp.searchAll(
        keyword: keyword,
        page: currentPage,
        order: order,
        duration: null,
        tids: videoZoneType?.tids,
        orderSort: userOrderType?.value.orderSort,
        userType: userType?.value.index,
        categoryId: articleZoneType?.value.categoryId,
        pubBegin: pubBegin,
        pubEnd: pubEnd,
      );
      lastResponse = response;
      if (response case Success(:final response)) {
        final list = response.list;
        if (list == null || list.isEmpty) {
          page = currentPage;
          return lastResponse;
        }
        list.removeWhere(
          (item) => item is SearchVideoItemModel && _isDuplicateTitle(item),
        );
        if (list.isNotEmpty) {
          page = currentPage;
          return lastResponse;
        }
        currentPage++;
      } else {
        page = currentPage;
        return lastResponse;
      }
    }
    page = currentPage;
    _filteredEmptyPage = true;
    return lastResponse ?? const Error('搜索结果为空');
  }

  @override
  bool shouldMarkEmptyAsEnd(SearchAllData response) => !_filteredEmptyPage;

  bool _isDuplicateTitle(SearchVideoItemModel item) =>
      _titleDeduplicator.isDuplicate(
        item.title,
        exact: Pref.hideDuplicateSearchTitles,
        fuzzy: Pref.hideSimilarSearchTitles,
      );

  void onPushDetail(dynamic resultList) {
    try {
      int? aid = int.tryParse(keyword);
      if (aid != null && resultList.first.aid == aid) {
        PiliScheme.videoPush(aid, null, showDialog: false);
      }
    } catch (_) {}
  }

  void jump2Video() {
    if (IdUtils.avRegexExact.hasMatch(keyword)) {
      hasJump2Video = true;
      PiliScheme.videoPush(
        int.parse(keyword.substring(2)),
        null,
        showDialog: false,
      );
    } else if (IdUtils.bvRegexExact.hasMatch(keyword)) {
      hasJump2Video = true;
      PiliScheme.videoPush(null, keyword, showDialog: false);
    }
  }
}
