import 'dart:convert';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/grpc_repo.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/space/data.dart';
import 'package:PiliPlus/models/space_fav/space_fav.dart';
import 'package:PiliPlus/pages/member/new/content/member_contribute/member_contribute.dart'
    show ContributeType;
import 'package:PiliPlus/utils/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/dynamics/result.dart';
import '../models/follow/result.dart';
import '../models/member/archive.dart';
import '../models/member/coin.dart';
import '../models/member/info.dart';
import '../models/member/seasons.dart';
import '../models/member/tags.dart';
import '../models/space_archive/data.dart' as archive;
import '../models/space_article/data.dart' as article;
import '../utils/utils.dart';
import '../utils/wbi_sign.dart';
import 'index.dart';

class MemberHttp {
  static Future reportMember(
    dynamic mid, {
    String? reason,
    int? reasonV2,
  }) async {
    var res = await Request().post(
      HttpString.spaceBaseUrl + Api.reportMember,
      data: FormData.fromMap(
        {
          'mid': mid,
          'reason': reason,
          if (reasonV2 != null) 'reason_v2': reasonV2,
          'csrf': await Request.getCsrf(),
        },
      ),
    );
    debugPrint('report: ${res.data}');
    return {
      'status': res.data['status'],
      'msg': res.data['message'] ?? res.data['data'],
    };
  }

  static Future<LoadingState> spaceDynamic({
    required int mid,
    required int page,
  }) async {
    dynamic result = await GrpcRepo.dynSpace(uid: mid, page: page);
    if (result['status']) {
      return LoadingState.success(result['data']);
    } else {
      return LoadingState.error(result['msg']);
    }
  }

  static Future<LoadingState> spaceArticle({
    required int mid,
    required int page,
  }) async {
    String? accessKey = GStorage.localCache
        .get(LocalCacheKey.accessKey, defaultValue: {})['value'];
    Map<String, String> data = {
      if (accessKey?.isNotEmpty == true) 'access_key': accessKey!,
      'appkey': Constants.appKey,
      'build': '1462100',
      'c_locale': 'zh_CN',
      'channel': 'yingyongbao',
      'mobi_app': 'android_hd',
      'platform': 'android',
      'pn': '$page',
      'ps': '10',
      's_locale': 'zh_CN',
      'statistics': Constants.statistics,
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      'vmid': mid.toString(),
    };
    String sign = Utils.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );
    data['sign'] = sign;
    dynamic res = await Request().get(
      Api.spaceArticle,
      queryParameters: data,
      options: Options(
        headers: {
          'bili-http-engine': 'cronet',
          'user-agent': Constants.userAgent,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(article.Data.fromJson(res.data['data']));
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> spaceFav({
    required int mid,
  }) async {
    String? accessKey = GStorage.localCache
        .get(LocalCacheKey.accessKey, defaultValue: {})['value'];
    Map<String, String> data = {
      if (accessKey?.isNotEmpty == true) 'access_key': accessKey!,
      'appkey': Constants.appKey,
      'build': '1462100',
      'c_locale': 'zh_CN',
      'channel': 'yingyongbao',
      'mobi_app': 'android_hd',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statistics,
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      'up_mid': mid.toString(),
    };
    String sign = Utils.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );
    data['sign'] = sign;
    dynamic res = await Request().get(
      Api.spaceFav,
      queryParameters: data,
      options: Options(
        headers: {
          'bili-http-engine': 'cronet',
          'user-agent': Constants.userAgent,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(SpaceFav.fromJson(res.data).data);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> seasonSeriesList({
    required int? mid,
    required int pn,
  }) async {
    dynamic res = await Request().get(
      Api.seasonSeries,
      queryParameters: {
        'mid': mid,
        'page_num': pn,
        'page_size': 10,
      },
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(res.data['data']['items_lists']);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> spaceArchive({
    required ContributeType type,
    required int? mid,
    String? aid,
    String? order,
    String? sort,
    int? pn,
    int? next,
    int? seasonId,
    int? seriesId,
  }) async {
    String? accessKey = GStorage.localCache
        .get(LocalCacheKey.accessKey, defaultValue: {})['value'];
    Map<String, String> data = {
      if (accessKey?.isNotEmpty == true) 'access_key': accessKey!,
      if (aid != null) 'aid': aid.toString(),
      'appkey': Constants.appKey,
      'build': '1462100',
      'c_locale': 'zh_CN',
      'channel': 'yingyongbao',
      'mobi_app': 'android_hd',
      'platform': 'android',
      's_locale': 'zh_CN',
      'ps': '20',
      if (pn != null) 'pn': pn.toString(),
      if (next != null) 'next': next.toString(),
      if (seasonId != null) 'season_id': seasonId.toString(),
      if (seriesId != null) 'series_id': seriesId.toString(),
      'qn': type == ContributeType.video ? '80' : '32',
      if (order != null) 'order': order,
      if (sort != null) 'sort': sort,
      'statistics': Constants.statistics,
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      'vmid': mid.toString(),
    };
    String sign = Utils.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );
    data['sign'] = sign;
    dynamic res = await Request().get(
      type == ContributeType.video
          ? Api.spaceArchive
          : type == ContributeType.charging
              ? Api.spaceChargingArchive
              : type == ContributeType.season
                  ? Api.spaceSeason
                  : type == ContributeType.series
                      ? Api.spaceSeries
                      : Api.spaceBangumi,
      queryParameters: data,
      options: Options(
        headers: {
          'bili-http-engine': 'cronet',
          'user-agent': Constants.userAgent,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(archive.Data.fromJson(res.data['data']));
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> space({
    int? mid,
  }) async {
    String? accessKey = GStorage.localCache
        .get(LocalCacheKey.accessKey, defaultValue: {})['value'];
    Map<String, String> data = {
      if (accessKey?.isNotEmpty == true) 'access_key': accessKey!,
      'appkey': Constants.appKey,
      'build': '1462100',
      'c_locale': 'zh_CN',
      'channel': 'yingyongbao',
      'mobi_app': 'android_hd',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statistics,
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      'vmid': mid.toString(),
    };
    String sign = Utils.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );
    data['sign'] = sign;
    dynamic res = await Request().get(
      Api.space,
      queryParameters: data,
      options: Options(
        headers: {
          'bili-http-engine': 'cronet',
          'user-agent': Constants.userAgent,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(Data.fromJson(res.data['data']));
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future memberInfo({
    int? mid,
    String token = '',
    dynamic wwebid,
  }) async {
    space(mid: mid);
    Map params = await WbiSign.makSign({
      'mid': mid,
      'token': token,
      'platform': 'web',
      'web_location': 1550101,
      'w_webid': wwebid,
    });
    var res = await Request().get(
      Api.memberInfo,
      queryParameters: params,
      extra: {'ua': 'pc'},
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MemberInfoModel.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future memberStat({int? mid}) async {
    var res = await Request().get(Api.userStat, queryParameters: {'vmid': mid});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future memberCardInfo({int? mid}) async {
    var res = await Request().get(
      Api.memberCardInfo,
      queryParameters: {
        'mid': mid,
        'photo': false,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future memberArchive({
    int? mid,
    int ps = 40,
    int tid = 0,
    int? pn,
    String? keyword,
    String order = 'pubdate',
    bool orderAvoided = true,
    dynamic wwebid,
  }) async {
    String dmImgStr = Utils.base64EncodeRandomString(16, 64);
    String dmCoverImgStr = Utils.base64EncodeRandomString(32, 128);
    Map params = await WbiSign.makSign({
      'mid': mid,
      'ps': ps,
      'tid': tid,
      'pn': pn,
      'keyword': keyword ?? '',
      'order': order,
      'platform': 'web',
      'web_location': 1550101,
      'order_avoided': orderAvoided,
      'dm_img_list': '[]',
      'dm_img_str': dmImgStr,
      'dm_cover_img_str': dmCoverImgStr,
      'dm_img_inter': '{"ds":[],"wh":[0,0,0],"of":[0,0,0]}',
      'w_webid': wwebid,
    });
    var res = await Request().get(
      Api.memberArchive,
      queryParameters: params,
      extra: {'ua': 'Mozilla/5.0'},
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MemberArchiveDataModel.fromJson(res.data['data'])
      };
    } else {
      Map errMap = {
        -352: '风控校验失败，请检查登录状态',
      };
      return {
        'status': false,
        'msg': errMap[res.data['code']] ?? res.data['message'],
      };
    }
  }

  // 用户动态
  static Future<LoadingState> memberDynamic({
    String? offset,
    int? mid,
    required bool antiGoodsDyn,
  }) async {
    String dmImgStr = Utils.base64EncodeRandomString(16, 64);
    String dmCoverImgStr = Utils.base64EncodeRandomString(32, 128);
    Map params = await WbiSign.makSign({
      'offset': offset ?? '',
      'host_mid': mid,
      'timezone_offset': '-480',
      'features': 'itemOpusStyle,listOnlyfans',
      'platform': 'web',
      'web_location': '333.999',
      'dm_img_list': '[]',
      'dm_img_str': dmImgStr,
      'dm_cover_img_str': dmCoverImgStr,
      'dm_img_inter': '{"ds":[],"wh":[0,0,0],"of":[0,0,0]}',
      'x-bili-device-req-json': jsonEncode({"platform": "web", "device": "pc"}),
      'x-bili-web-req-json': jsonEncode({"spm_id": "333.999"}),
    });
    var res = await Request().get(Api.memberDynamic, queryParameters: params);
    if (res.data['code'] == 0) {
      DynamicsDataModel data = DynamicsDataModel.fromJson(res.data['data']);
      if (antiGoodsDyn) {
        data.items?.removeWhere((item) =>
            item.orig?.modules?.moduleDynamic?.additional?.type ==
                'ADDITIONAL_TYPE_GOODS' ||
            item.modules?.moduleDynamic?.additional?.type ==
                'ADDITIONAL_TYPE_GOODS');
      }
      return LoadingState.success(data);
    } else {
      Map errMap = {
        -352: '风控校验失败，请检查登录状态',
      };
      return LoadingState.error(
          errMap[res.data['code']] ?? res.data['message']);
    }
  }

  // 搜索用户动态
  static Future memberDynamicSearch({
    int? pn,
    int? ps,
    int? mid,
    required String keyword,
  }) async {
    var res = await Request().get(Api.memberDynamicSearch, queryParameters: {
      'keyword': keyword,
      'mid': mid,
      'pn': pn,
      'ps': ps,
      'platform': 'web'
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']['cards'],
        'count': res.data['data']['total']
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  // 查询分组
  static Future followUpTags() async {
    var res = await Request().get(Api.followUpTag);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']
            .map<MemberTagItemModel>((e) => MemberTagItemModel.fromJson(e))
            .toList()
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future specialAction({
    int? fid,
    bool isAdd = true,
  }) async {
    var res = await Request().post(
      isAdd ? Api.addSpecial : Api.delSpecial,
      data: {
        'fid': fid,
        'csrf': await Request.getCsrf(),
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  // 设置分组
  static Future addUsers(int? fids, String? tagids) async {
    var res = await Request().post(
      Api.addUsers,
      data: {
        'fids': fids,
        'tagids': tagids ?? '0',
        'csrf': await Request.getCsrf(),
        // 'cross_domain': true
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': [], 'msg': '操作成功'};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取某分组下的up
  static Future followUpGroup(
    int? mid,
    int? tagid,
    int? pn,
    int? ps,
  ) async {
    var res = await Request().get(Api.followUpGroup, queryParameters: {
      'mid': mid,
      'tagid': tagid,
      'pn': pn,
      'ps': ps,
    });
    if (res.data['code'] == 0) {
      // FollowItemModel
      return {
        'status': true,
        'data': res.data['data']
            .map<FollowItemModel>((e) => FollowItemModel.fromJson(e))
            .toList()
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取up置顶
  static Future getTopVideo(String? vmid) async {
    var res = await Request().get(Api.getTopVideoApi);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']
            .map<MemberTagItemModel>((e) => MemberTagItemModel.fromJson(e))
            .toList()
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取uo专栏
  static Future getMemberSeasons(int? mid, int? pn, int? ps) async {
    var res = await Request().get(Api.getMemberSeasonsApi, queryParameters: {
      'mid': mid,
      'page_num': pn,
      'page_size': ps,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MemberSeasonsDataModel.fromJson(res.data['data']['items_lists'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 最近投币
  static Future<LoadingState> getRecentCoinVideo({required int mid}) async {
    Map params = await WbiSign.makSign({
      'mid': mid,
      'gaia_source': 'main_web',
      'web_location': 333.999,
    });
    var res = await Request().get(
      Api.getRecentCoinVideoApi,
      queryParameters: {
        'vmid': mid,
        'gaia_source': 'main_web',
        'web_location': 333.999,
        'w_rid': params['w_rid'],
        'wts': params['wts'],
      },
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(res.data['data']
          .map<MemberCoinsDataModel>((e) => MemberCoinsDataModel.fromJson(e))
          .toList());
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  // 最近点赞
  static Future<LoadingState> getRecentLikeVideo({required int mid}) async {
    Map params = await WbiSign.makSign({
      'mid': mid,
      'gaia_source': 'main_web',
      'web_location': 333.999,
    });
    var res = await Request().get(
      Api.getRecentLikeVideoApi,
      queryParameters: {
        'vmid': mid,
        'gaia_source': 'main_web',
        'web_location': 333.999,
        'w_rid': params['w_rid'],
        'wts': params['wts'],
      },
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(res.data['data']['list']
          .map<MemberCoinsDataModel>((e) => MemberCoinsDataModel.fromJson(e))
          .toList());
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  // 查看某个专栏
  static Future getSeasonDetail({
    required int mid,
    required int seasonId,
    bool sortReverse = false,
    required int pn,
    required int ps,
  }) async {
    var res = await Request().get(
      Api.getSeasonDetailApi,
      queryParameters: {
        'mid': mid,
        'season_id': seasonId,
        'sort_reverse': sortReverse,
        'page_num': pn,
        'page_size': ps,
      },
    );
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': MemberSeasonsList.fromJson(res.data['data'])
        };
      } catch (err) {
        debugPrint(err.toString());
      }
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取up播放数、点赞数
  static Future memberView({required int mid}) async {
    var res = await Request()
        .get(Api.getMemberViewApi, queryParameters: {'mid': mid});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 搜索follow
  static Future<LoadingState> getfollowSearch({
    required int mid,
    required int ps,
    required int pn,
    required String name,
  }) async {
    Map<String, dynamic> data = {
      'vmid': mid,
      'pn': pn,
      'ps': ps,
      'order': 'desc',
      'order_type': 'attention',
      'gaia_source': 'main_web',
      'name': name,
      'web_location': 333.999,
    };
    Map params = await WbiSign.makSign(data);
    var res = await Request().get(Api.followSearch, queryParameters: {
      ...data,
      'w_rid': params['w_rid'],
      'wts': params['wts'],
    });
    if (res.data['code'] == 0) {
      return LoadingState.success(FollowDataModel.fromJson(res.data['data']));
    } else {
      return LoadingState.error(res.data['message']);
    }
  }
}
