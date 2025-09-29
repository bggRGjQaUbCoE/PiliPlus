import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/ua_type.dart';
import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/member/info.dart';
import 'package:PiliPlus/models/member/tags.dart';
import 'package:PiliPlus/models_new/follow/data.dart';
import 'package:PiliPlus/models_new/follow/list.dart';
import 'package:PiliPlus/models_new/member/coin_like_arc/data.dart';
import 'package:PiliPlus/models_new/member/search_archive/data.dart';
import 'package:PiliPlus/models_new/member_card_info/data.dart';
import 'package:PiliPlus/models_new/space/space/data.dart';
import 'package:PiliPlus/models_new/space/space_archive/data.dart';
import 'package:PiliPlus/models_new/space/space_article/data.dart';
import 'package:PiliPlus/models_new/space/space_audio/data.dart';
import 'package:PiliPlus/models_new/space/space_cheese/data.dart';
import 'package:PiliPlus/models_new/space/space_opus/data.dart';
import 'package:PiliPlus/models_new/space/space_season_series/item.dart';
import 'package:PiliPlus/models_new/space/space_shop/data.dart';
import 'package:PiliPlus/models_new/upower_rank/data.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/app_sign.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';

class MemberHttp {
  static Future reportMember(
    dynamic mid, {
    String? reason,
    int? reasonV2,
  }) async {
    var res = await Request().post(
      HttpString.spaceBaseUrl + Api.reportMember,
      data: {
        'mid': mid,
        'reason': reason,
        'reason_v2': ?reasonV2,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return {
      'status': res.data['status'],
      'msg': res.data['message'] ?? res.data['data'],
    };
  }

  static Future<LoadingState<SpaceArticleData>> spaceArticle({
    required int mid,
    required int page,
  }) async {
    final params = {
      'build': 8430300,
      'channel': 'master',
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'mobi_app': 'android',
      'platform': 'android',
      'pn': page,
      'ps': 10,
      's_locale': 'zh_CN',
      'statistics': Constants.statisticsApp,
      'vmid': mid,
    };
    var res = await Request().get(
      Api.spaceArticle,
      queryParameters: params,
      options: Options(
        headers: {
          'bili-http-engine': 'cronet',
          'user-agent': Constants.userAgentApp,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return Success(SpaceArticleData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SpaceSsData>> seasonSeriesList({
    required int? mid,
    required int pn,
  }) async {
    var res = await Request().get(
      Api.seasonSeries,
      queryParameters: {
        'mid': mid,
        'page_num': pn,
        'page_size': 10,
      },
    );
    if (res.data['code'] == 0) {
      return Success(
        SpaceSsData.fromJson(res.data['data']?['items_lists'] ?? {}),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SpaceArchiveData>> spaceArchive({
    required ContributeType type,
    required int? mid,
    String? aid,
    String? order,
    String? sort,
    int? pn,
    int? next,
    int? seasonId,
    int? seriesId,
    bool? includeCursor,
  }) async {
    final params = {
      'aid': ?aid,
      'build': 8430300,
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'channel': 'master',
      'mobi_app': 'android',
      'platform': 'android',
      's_locale': 'zh_CN',
      'ps': 20,
      'pn': ?pn,
      'next': ?next,
      'season_id': ?seasonId,
      'series_id': ?seriesId,
      'qn': type == ContributeType.video ? 80 : 32,
      'order': ?order,
      'sort': ?sort,
      'include_cursor': ?includeCursor,
      'statistics': Constants.statisticsApp,
      'vmid': mid,
    };
    var res = await Request().get(
      switch (type) {
        ContributeType.video => Api.spaceArchive,
        ContributeType.charging => Api.spaceChargingArchive,
        ContributeType.season => Api.spaceSeason,
        ContributeType.series => Api.spaceSeries,
        ContributeType.bangumi => Api.spaceBangumi,
        ContributeType.comic => Api.spaceComic,
      },
      queryParameters: params,
      options: Options(
        headers: {
          'bili-http-engine': 'cronet',
          'user-agent': Constants.userAgentApp,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return Success(SpaceArchiveData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SpaceAudioData>> spaceAudio({
    required int page,
    required mid,
  }) async {
    var res = await Request().get(
      Api.spaceAudio,
      queryParameters: {
        'pn': page,
        'ps': 20,
        'order': 1,
        'uid': mid,
        'web_location': 333.1387,
      },
    );
    if (res.data['code'] == 0) {
      return Success(SpaceAudioData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SpaceCheeseData>> spaceCheese({
    required int page,
    required mid,
  }) async {
    var res = await Request().get(
      Api.spaceCheese,
      queryParameters: {
        'pn': page,
        'ps': 30,
        'mid': mid,
        'web_location': 333.1387,
      },
    );
    if (res.data['code'] == 0) {
      return Success(SpaceCheeseData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState> spaceStory({
    required mid,
    required aid,
    required beforeSize,
    required afterSize,
    required cid,
    required contain,
    required index,
  }) async {
    final params = {
      'aid': aid,
      'before_size': beforeSize,
      'after_size': afterSize,
      'cid': cid,
      'contain': contain,
      'index': index,
      'build': 8430300,
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'channel': 'master',
      'mobi_app': 'android',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statisticsApp,
      'vmid': mid,
    };
    var res = await Request().get(
      Api.spaceStory,
      queryParameters: params,
      options: Options(
        headers: {
          'bili-http-engine': 'cronet',
          'user-agent': Constants.userAgentApp,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return Success(res.data['data']);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SpaceData>> space({
    int? mid,
    dynamic fromViewAid,
  }) async {
    final params = {
      'build': 8430300,
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'channel': 'master',
      'mobi_app': 'android',
      'platform': 'android',
      's_locale': 'zh_CN',
      'from_view_aid': ?fromViewAid,
      'statistics': Constants.statisticsApp,
      'vmid': mid,
    };
    var res = await Request().get(
      Api.space,
      queryParameters: params,
      options: Options(
        headers: {
          'bili-http-engine': 'cronet',
          'user-agent': Constants.userAgentApp,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return Success(SpaceData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future memberInfo({
    int? mid,
    String token = '',
  }) async {
    String dmImgStr = Utils.base64EncodeRandomString(16, 64);
    String dmCoverImgStr = Utils.base64EncodeRandomString(32, 128);
    final params = await WbiSign.makSign({
      'mid': mid,
      'token': token,
      'platform': 'web',
      'web_location': 1550101,
      'dm_img_list': '[]',
      'dm_img_str': dmImgStr,
      'dm_cover_img_str': dmCoverImgStr,
      'dm_img_inter': '{"ds":[],"wh":[0,0,0],"of":[0,0,0]}',
    });
    var res = await Request().get(
      Api.memberInfo,
      queryParameters: params,
      options: Options(
        headers: {
          'origin': 'https://space.bilibili.com',
          'referer': 'https://space.bilibili.com/$mid/dynamic',
          'user-agent': UaType.pc.ua,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MemberInfoModel.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future memberStat({int? mid}) async {
    var res = await Request().get(Api.userStat, queryParameters: {'vmid': mid});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
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
      return {
        'status': true,
        'data': MemberCardInfoData.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<SearchArchiveData>> searchArchive({
    required mid,
    int ps = 30,
    int tid = 0,
    int? pn,
    String? keyword,
    String order = 'pubdate',
    bool orderAvoided = true,
  }) async {
    String dmImgStr = Utils.base64EncodeRandomString(16, 64);
    String dmCoverImgStr = Utils.base64EncodeRandomString(32, 128);
    final params = await WbiSign.makSign({
      'mid': mid,
      'ps': ps,
      'tid': tid,
      'pn': pn,
      'keyword': ?keyword,
      'order': order,
      'platform': 'web',
      'web_location': 1550101,
      'order_avoided': orderAvoided,
      'dm_img_list': '[]',
      'dm_img_str': dmImgStr,
      'dm_cover_img_str': dmCoverImgStr,
      'dm_img_inter': '{"ds":[],"wh":[0,0,0],"of":[0,0,0]}',
    });
    var res = await Request().get(
      Api.searchArchive,
      queryParameters: params,
      options: Options(
        headers: {
          HttpHeaders.userAgentHeader: UaType.pc.ua,
          HttpHeaders.refererHeader: '${HttpString.spaceBaseUrl}/$mid',
          'origin': HttpString.spaceBaseUrl,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return Success(SearchArchiveData.fromJson(res.data['data']));
    } else {
      Map errMap = const {
        -352: '风控校验失败，请检查登录状态',
      };
      return Error(errMap[res.data['code']] ?? res.data['message']);
    }
  }

  // 用户动态
  static Future<LoadingState<DynamicsDataModel>> memberDynamic({
    String? offset,
    int? mid,
  }) async {
    String dmImgStr = Utils.base64EncodeRandomString(16, 64);
    String dmCoverImgStr = Utils.base64EncodeRandomString(32, 128);
    final params = await WbiSign.makSign({
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
      try {
        DynamicsDataModel data = DynamicsDataModel.fromJson(res.data['data']);
        if (data.loadNext == true) {
          return memberDynamic(offset: data.offset, mid: mid);
        }
        return Success(data);
      } catch (err) {
        return Error(err.toString());
      }
    } else {
      Map errMap = const {
        -352: '风控校验失败，请检查登录状态',
      };
      return Error(errMap[res.data['code']] ?? res.data['message']);
    }
  }

  static Future<LoadingState<DynamicsDataModel>> dynSearch({
    required int pn,
    required dynamic mid,
    required dynamic offset,
    required String keyword,
  }) async {
    var res = await Request().get(
      Api.dynSearch,
      queryParameters: {
        'host_mid': mid,
        'page': pn,
        'offset': offset,
        'keyword': keyword,
        'features': 'itemOpusStyle,listOnlyfans',
        'web_location': 333.1387,
      },
    );
    if (res.data['code'] == 0) {
      return Success(DynamicsDataModel.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  // 查询分组
  static Future<LoadingState<List<MemberTagItemModel>>> followUpTags() async {
    var res = await Request().get(Api.followUpTag);
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data'] as List)
            .map((e) => MemberTagItemModel.fromJson(e))
            .toList(),
      );
    } else {
      return Error(res.data['message']);
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
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
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
  static Future addUsers(String fids, String tagids) async {
    var res = await Request().post(
      Api.addUsers,
      queryParameters: {
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.1387"}',
      },
      data: {
        'fids': fids,
        'tagids': tagids,
        'csrf': Accounts.main.csrf,
        // 'cross_domain': true
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': '操作成功'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 获取某分组下的up
  static Future<LoadingState<FollowData>> followUpGroup({
    int? mid,
    int? tagid,
    int? pn,
    int ps = 20,
  }) async {
    var res = await Request().get(
      Api.followUpGroup,
      queryParameters: {
        'mid': mid,
        'tagid': tagid,
        'pn': pn,
        'ps': ps,
      },
    );
    if (res.data['code'] == 0) {
      return Success(
        FollowData(
          list:
              (res.data['data'] as List?)
                  ?.map<FollowItemModel>((e) => FollowItemModel.fromJson(e))
                  .toList() ??
              <FollowItemModel>[],
        ),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future createFollowTag(tagName) async {
    var res = await Request().post(
      Api.createFollowTag,
      queryParameters: {
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.1387"}',
      },
      data: {
        'tag': tagName,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future updateFollowTag(tagid, name) async {
    var res = await Request().post(
      Api.updateFollowTag,
      queryParameters: {
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.1387"}',
      },
      data: {
        'tagid': tagid,
        'name': name,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future delFollowTag(tagid) async {
    var res = await Request().post(
      Api.delFollowTag,
      queryParameters: {
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.1387"}',
      },
      data: {
        'tagid': tagid,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
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
            .toList(),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 获取up播放数、点赞数
  static Future memberView({required int mid}) async {
    var res = await Request().get(
      Api.getMemberViewApi,
      queryParameters: {'mid': mid},
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 搜索follow
  static Future<LoadingState<FollowData>> getfollowSearch({
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
    var res = await Request().get(
      Api.followSearch,
      queryParameters: {
        ...data,
        'w_rid': params['w_rid'],
        'wts': params['wts'],
      },
    );
    if (res.data['code'] == 0) {
      return Success(FollowData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SpaceOpusData>> spaceOpus({
    required int hostMid,
    required int page,
    String offset = '',
    String type = 'all',
  }) async {
    var res = await Request().get(
      Api.spaceOpus,
      queryParameters: await WbiSign.makSign({
        'host_mid': hostMid,
        'page': page,
        'offset': offset,
        'type': type,
        'web_location': 333.1387,
      }),
    );
    if (res.data['code'] == 0) {
      return Success(SpaceOpusData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<UpowerRankData>> upowerRank({
    required upMid,
    required int page,
    int? privilegeType,
  }) async {
    var res = await Request().get(
      Api.upowerRank,
      queryParameters: {
        'up_mid': upMid,
        'pn': page,
        'ps': 100,
        'privilege_type': ?privilegeType,
        'mobi_app': 'web',
        'web_location': 333.1196,
        if (Accounts.main.isLogin) 'csrf': Accounts.main.csrf,
      },
    );
    if (res.data['code'] == 0) {
      return Success(UpowerRankData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<CoinLikeArcData>> coinArc({
    required int mid,
    required int page,
  }) async {
    var res = await Request().get(
      Api.coinArc,
      queryParameters: {
        'pn': page,
        'ps': 20,
        'vmid': mid,
      },
    );
    if (res.data['code'] == 0) {
      return Success(CoinLikeArcData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<CoinLikeArcData>> likeArc({
    required int mid,
    required int page,
  }) async {
    var res = await Request().get(
      Api.likeArc,
      queryParameters: {
        'pn': page,
        'ps': 20,
        'vmid': mid,
      },
    );
    if (res.data['code'] == 0) {
      return Success(CoinLikeArcData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SpaceShopData>> spaceShop({
    required int mid,
  }) async {
    final params = {
      'access_key': ?Accounts.main.accessKey,
      'actionKey': 'appkey',
      'build': 8430300,
      'mVersion': 309,
      'mallVersion': 8430300,
      'statistics': Constants.statisticsApp,
    };
    AppSign.appSign(params);
    var res = await Request().post(
      Api.spaceShop,
      queryParameters: params,
      data: {
        "from": "cps_productTab_$mid",
        "searchAfter": 0,
        "msource": "cps_productTab_$mid",
        "pageSize": 8,
        "upMid": mid.toString(),
      },
    );
    if (res.data['code'] == 0) {
      return Success(SpaceShopData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }
}
