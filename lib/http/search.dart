import 'dart:convert';

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/search/search_type.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/models/search/suggest.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_pub_search/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/models_new/search/search_rcmd/data.dart';
import 'package:PiliPlus/models_new/search/search_trending/data.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class SearchHttp {
  // 获取搜索建议
  static Future searchSuggest({required String term}) async {
    var res = await Request().get(
      Api.searchSuggest,
      queryParameters: {
        'term': term,
        'main_ver': 'v1',
        'highlight': term,
      },
    );
    if (res.data is String) {
      Map<String, dynamic> resultMap = json.decode(res.data);
      if (resultMap['code'] == 0) {
        if (resultMap['result'] is Map) {
          return {
            'status': true,
            'data': SearchSuggestModel.fromJson(resultMap['result']),
          };
        }
      }
    }
    return {'status': false, 'msg': '请求错误'};
  }

  // 分类搜索
  @pragma('vm:notify-debugger-on-exception')
  static Future<LoadingState<R>> searchByType<R extends SearchNumData>({
    required SearchType searchType,
    required String keyword,
    required page,
    String? order,
    int? duration,
    int? tids,
    int? orderSort,
    int? userType,
    int? categoryId,
    int? pubBegin,
    int? pubEnd,
    String? gaiaVtoken,
    required ValueChanged<String> onSuccess,
  }) async {
    var params = await WbiSign.makSign({
      'search_type': searchType.name,
      'keyword': keyword,
      'page': page,
      if (order?.isNotEmpty == true) 'order': order,
      'duration': ?duration,
      'tids': ?tids,
      'order_sort': ?orderSort,
      'user_type': ?userType,
      'category_id': ?categoryId,
      'pubtime_begin_s': ?pubBegin,
      'pubtime_end_s': ?pubEnd,
      'page_size': 20,
      'platform': 'pc',
      'web_location': 1430654,
      'gaia_vtoken': ?gaiaVtoken,
    });
    var res = await Request().get(
      Api.searchByType,
      queryParameters: params,
      options: Options(
        headers: {
          if (gaiaVtoken != null) 'cookie': 'x-bili-gaia-vtoken=$gaiaVtoken',
          'origin': 'https://search.bilibili.com',
          'referer':
              'https://search.bilibili.com/${searchType.name}?keyword=${Uri.encodeFull(keyword)}',
        },
      ),
    );
    final resData = res.data;
    if (resData is Map) {
      if (resData['code'] == 0) {
        final Map<String, dynamic> dataData = resData['data'];
        final vVoucher = dataData['v_voucher'];
        if (vVoucher != null) {
          RequestUtils.validate(vVoucher, onSuccess);
          return const Error('触发风控');
        }
        dynamic data;
        try {
          switch (searchType) {
            case SearchType.video:
              data = SearchVideoData.fromJson(dataData);
              break;
            case SearchType.live_room:
              data = SearchLiveData.fromJson(dataData);
              break;
            case SearchType.bili_user:
              data = SearchUserData.fromJson(dataData);
              break;
            case SearchType.media_bangumi || SearchType.media_ft:
              data = SearchPgcData.fromJson(dataData);
              break;
            case SearchType.article:
              data = SearchArticleData.fromJson(dataData);
              break;
            // default:
            //   break;
          }
          return Success(data);
        } catch (e, s) {
          return Error('$e\n\n$s');
        }
      } else {
        return Error(resData['message'], code: resData['code']);
      }
    } else {
      return const Error('服务器错误');
    }
  }

  @pragma('vm:notify-debugger-on-exception')
  static Future<LoadingState<SearchAllData>> searchAll({
    required String keyword,
    required page,
    String? order,
    int? duration,
    int? tids,
    int? orderSort,
    int? userType,
    int? categoryId,
    int? pubBegin,
    int? pubEnd,
  }) async {
    var params = await WbiSign.makSign({
      'keyword': keyword,
      'page': page,
      if (order?.isNotEmpty == true) 'order': order,
      'duration': ?duration,
      'tids': ?tids,
      'order_sort': ?orderSort,
      'user_type': ?userType,
      'category_id': ?categoryId,
      'pubtime_begin_s': ?pubBegin,
      'pubtime_end_s': ?pubEnd,
    });
    var res = await Request().get(
      Api.searchAll,
      queryParameters: params,
    );
    if (res.data is! Map) {
      return const Error('没有相关数据');
    }
    if (res.data['code'] == 0) {
      try {
        return Success(SearchAllData.fromJson(res.data['data']));
      } catch (e, s) {
        return Error('$e\n\n$s');
      }
    } else {
      return Error(res.data['message'] ?? '没有相关数据');
    }
  }

  static Future<int?> ab2c({dynamic aid, dynamic bvid, int? part}) async {
    var res = await Request().get(
      Api.ab2c,
      queryParameters: {
        'aid': ?aid,
        'bvid': ?bvid,
      },
    );
    if (res.data['code'] == 0) {
      if (res.data['data'] case List list) {
        return part != null
            ? (list.getOrNull(part - 1)?['cid'] ?? list.firstOrNull?['cid'])
            : list.firstOrNull?['cid'];
      } else {
        return null;
      }
    } else {
      SmartDialog.showToast("ab2c error: ${res.data['message']}");
      return null;
    }
  }

  static Future<LoadingState<PgcInfoModel>> pgcInfo({
    dynamic seasonId,
    dynamic epId,
  }) async {
    var res = await Request().get(
      Api.pgcInfo,
      queryParameters: {
        'season_id': ?seasonId,
        'ep_id': ?epId,
      },
    );
    if (res.data['code'] == 0) {
      return Success(PgcInfoModel.fromJson(res.data['result']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<PgcInfoModel>> pugvInfo({
    dynamic seasonId,
    dynamic epId,
  }) async {
    var res = await Request().get(
      Api.pugvInfo,
      queryParameters: {
        'season_id': ?seasonId,
        'ep_id': ?epId,
      },
    );
    if (res.data['code'] == 0) {
      return Success(PgcInfoModel.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState> episodeInfo({dynamic epId}) async {
    var res = await Request().get(
      Api.episodeInfo,
      queryParameters: {
        'ep_id': ?epId,
      },
    );
    if (res.data['code'] == 0) {
      return Success(res.data['data']);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SearchTrendingData>> searchTrending({
    int limit = 30,
  }) async {
    final res = await Request().get(
      Api.searchTrending,
      queryParameters: {
        'limit': limit,
      },
    );
    if (res.data['code'] == 0) {
      return Success(SearchTrendingData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SearchRcmdData>> searchRecommend() async {
    final res = await Request().get(
      Api.searchRecommend,
      queryParameters: {
        'build': 8430300,
        'channel': 'master',
        'version': '8.43.0',
        'c_locale': 'zh_CN',
        'mobi_app': 'android',
        'platform': 'android',
        's_locale': 'zh_CN',
        'from': 2,
      },
    );
    if (res.data['code'] == 0) {
      return Success(SearchRcmdData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<TopicPubSearchData>> topicPubSearch({
    required String keywords,
    String content = '',
    required int pageNum,
  }) async {
    final res = await Request().get(
      Api.topicPubSearch,
      queryParameters: {
        'keywords': keywords,
        'content': content,
        if (pageNum == 1) ...{
          'page_size': 20,
          'page_num': 1,
        } else
          'offset': 20 * (pageNum - 1),
        'web_location': 333.1365,
      },
    );
    if (res.data['code'] == 0) {
      return Success(TopicPubSearchData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }
}
