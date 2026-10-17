import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/models/search/search_esports.dart';
import 'package:PiliPlus/pages/search_panel/video/controller.dart';

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

  @override
  bool customHandleResponse(bool isRefresh, Success<SearchVideoData> response) {
    final res = response.response;
    if (isRefresh) {
      searchType_ = .video;
      searchUser = res.searchUser;
      searchMedia = res.searchMedia;
      searchActivity = res.searchActivity;
      searchEsports = res.searchEsports;
      searchTips = res.searchTips ?? _localCrisisTips();
    }
    return super.customHandleResponse(isRefresh, response);
  }

  @override
  late var searchType_ = searchType;

  /// 高风险关键词。服务端对部分词（如「自杀」）会压制搜索结果且不下发
  /// tips 模块，此时由客户端补齐同一张关怀卡片，避免求助入口完全消失。
  static const List<String> _crisisKeywords = [
    '自杀',
    '自尽',
    '自缢',
    '轻生',
    '想死',
    '不想活',
    '活不下去',
    '结束生命',
    '跳楼',
    '跳桥',
    '割腕',
    '自残',
    '烧炭',
  ];

  /// 「能量加油站」页面，与官方客户端一致。
  static const String _crisisJumpUrl =
      'https://www.bilibili.com/blackboard/era/3ERAmwloghvazr00.html';

  List<SearchTip>? _localCrisisTips() {
    final kw = keyword.trim();
    if (kw.isEmpty || !_crisisKeywords.any(kw.contains)) {
      return null;
    }
    return [
      SearchTip(
        title: '你不孤单，我们都在',
        subTitle: '如需帮助，请拨打全国24小时免费心理咨询热线 010-82951332',
        jumpUrl: _crisisJumpUrl,
      ),
    ];
  }

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
    return super.onRefresh();
  }
}
