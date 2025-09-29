import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/login.dart';
import 'package:PiliPlus/http/ua_type.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/models/common/live_search_type.dart';
import 'package:PiliPlus/models_new/live/live_area_list/area_item.dart';
import 'package:PiliPlus/models_new/live/live_area_list/area_list.dart';
import 'package:PiliPlus/models_new/live/live_dm_block/data.dart';
import 'package:PiliPlus/models_new/live/live_dm_block/shield_info.dart';
import 'package:PiliPlus/models_new/live/live_dm_info/data.dart';
import 'package:PiliPlus/models_new/live/live_emote/data.dart';
import 'package:PiliPlus/models_new/live/live_emote/datum.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/data.dart';
import 'package:PiliPlus/models_new/live/live_follow/data.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/data.dart';
import 'package:PiliPlus/models_new/live/live_search/data.dart';
import 'package:PiliPlus/models_new/live/live_second_list/data.dart';
import 'package:PiliPlus/models_new/live/live_superchat/data.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/app_sign.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';

abstract final class LiveHttp {
  static Account get recommend => Accounts.get(AccountType.recommend);

  static Future sendLiveMsg({
    required Object roomId,
    required Object msg,
    Object? dmType,
    Object? emoticonOptions,
  }) async {
    String csrf = Accounts.main.csrf;
    var res = await Request().post(
      Api.sendLiveMsg,
      data: FormData.fromMap({
        'bubble': 0,
        'msg': msg,
        'color': 16777215,
        'mode': 1,
        'dm_type': ?dmType,
        if (emoticonOptions != null)
          'emoticonOptions': emoticonOptions
        else ...{
          'room_type': 0,
          'jumpfrom': 0,
          'reply_mid': 0,
          'reply_attr': 0,
          'replay_dmid': '',
          'statistics': Constants.statistics,
          'reply_type': 0,
          'reply_uname': '',
        },
        'fontsize': 25,
        'rnd': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'roomid': roomId,
        'csrf': csrf,
        'csrf_token': csrf,
      }),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  static Future liveRoomInfo({roomId, qn, bool onlyAudio = false}) async {
    var res = await Request().get(
      Api.liveRoomInfo,
      queryParameters: {
        'room_id': roomId,
        'protocol': '0, 1',
        'format': '0, 1, 2',
        'codec': '0, 1',
        'qn': qn,
        'platform': 'web',
        'ptype': 8,
        'dolby': 5,
        'panorama': 1,
        if (onlyAudio) 'only_audio': 1,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': RoomPlayInfoData.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future liveRoomInfoH5({roomId, qn}) async {
    var res = await Request().get(
      Api.liveRoomInfoH5,
      queryParameters: {
        'room_id': roomId,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': RoomInfoH5Data.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future liveRoomDanmaPrefetch({roomId}) async {
    var res = await Request().get(
      Api.liveRoomDmPrefetch,
      queryParameters: {'roomid': roomId},
      options: Options(
        headers: {
          'referer': 'https://live.bilibili.com/$roomId',
          'user-agent': UaType.pc.ua,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']?['room']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future liveRoomGetDanmakuToken({roomId}) async {
    var res = await Request().get(
      Api.liveRoomDmToken,
      queryParameters: await WbiSign.makSign({
        'id': roomId,
        'web_location': 444.8,
      }),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': LiveDmInfoData.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<List<LiveEmoteDatum>?>> getLiveEmoticons({
    required int roomId,
  }) async {
    var res = await Request().get(
      Api.getLiveEmoticons,
      queryParameters: {
        'platform': 'pc',
        'room_id': roomId,
      },
    );
    if (res.data['code'] == 0) {
      return Success(LiveEmoteData.fromJson(res.data['data']).data);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<LiveIndexData>> liveFeedIndex({
    required int pn,
    bool moduleSelect = false,
  }) async {
    final params = {
      'access_key': ?recommend.accessKey,
      'appkey': Constants.appKey,
      'channel': 'master',
      'actionKey': 'appkey',
      'build': 8430300,
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'device': 'android',
      'device_name': 'android',
      'device_type': 0,
      'fnval': 912,
      'disable_rcmd': 0,
      'https_url_req': 1,
      if (moduleSelect) 'module_select': 1,
      'mobi_app': 'android',
      'network': 'wifi',
      'page': pn,
      'platform': 'android',
      if (recommend.isLogin) 'relation_page': 1,
      's_locale': 'zh_CN',
      'scale': 2,
      'statistics': Constants.statisticsApp,
      'ts': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    AppSign.appSign(
      params,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await Request().get(
      Api.liveFeedIndex,
      queryParameters: params,
      options: Options(
        headers: {
          'buvid': LoginHttp.buvid,
          'fp_local':
              '1111111111111111111111111111111111111111111111111111111111111111',
          'fp_remote':
              '1111111111111111111111111111111111111111111111111111111111111111',
          'session_id': '11111111',
          'env': 'prod',
          'app-key': 'android',
          'User-Agent': Constants.userAgentApp,
          'x-bili-trace-id': Constants.traceId,
          'x-bili-aurora-eid': '',
          'x-bili-aurora-zone': '',
          'bili-http-engine': 'cronet',
        },
      ),
    );
    if (res.data['code'] == 0) {
      return Success(LiveIndexData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<LiveFollowData>> liveFollow(int page) async {
    var res = await Request().get(
      Api.liveFollow,
      queryParameters: {
        'page': page,
        'page_size': 9,
        'ignoreRecord': 1,
        'hit_ab': true,
      },
    );
    if (res.data['code'] == 0) {
      return Success(LiveFollowData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<LiveSecondData>> liveSecondList({
    required int pn,
    required Object? areaId,
    required Object? parentAreaId,
    String? sortType,
  }) async {
    final params = {
      'access_key': ?recommend.accessKey,
      'appkey': Constants.appKey,
      'actionKey': 'appkey',
      'channel': 'master',
      'area_id': ?areaId,
      'parent_area_id': ?parentAreaId,
      'build': 8430300,
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'device': 'android',
      'device_name': 'android',
      'device_type': 0,
      'fnval': 912,
      'disable_rcmd': 0,
      'https_url_req': 1,
      'mobi_app': 'android',
      'module_select': 0,
      'network': 'wifi',
      'page': pn,
      'page_size': 20,
      'platform': 'android',
      'qn': 0,
      'sort_type': ?sortType,
      'tag_version': 1,
      's_locale': 'zh_CN',
      'scale': 2,
      'statistics': Constants.statisticsApp,
      'ts': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    AppSign.appSign(
      params,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await Request().get(
      Api.liveSecondList,
      queryParameters: params,
      options: Options(
        headers: {
          'buvid': LoginHttp.buvid,
          'fp_local':
              '1111111111111111111111111111111111111111111111111111111111111111',
          'fp_remote':
              '1111111111111111111111111111111111111111111111111111111111111111',
          'session_id': '11111111',
          'env': 'prod',
          'app-key': 'android',
          'User-Agent': Constants.userAgentApp,
          'x-bili-trace-id': Constants.traceId,
          'x-bili-aurora-eid': '',
          'x-bili-aurora-zone': '',
          'bili-http-engine': 'cronet',
        },
      ),
    );
    if (res.data['code'] == 0) {
      return Success(LiveSecondData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<AreaList>?>> liveAreaList() async {
    final params = {
      'access_key': ?recommend.accessKey,
      'appkey': Constants.appKey,
      'actionKey': 'appkey',
      'build': 8430300,
      'channel': 'master',
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'device': 'android',
      'disable_rcmd': 0,
      'mobi_app': 'android',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statisticsApp,
      'ts': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    AppSign.appSign(
      params,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await Request().get(
      Api.liveAreaList,
      queryParameters: params,
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data']?['list'] as List?)
            ?.map((e) => AreaList.fromJson(e))
            .toList(),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<AreaItem>>> getLiveFavTag() async {
    final params = {
      'access_key': ?Accounts.main.accessKey,
      'appkey': Constants.appKey,
      'actionKey': 'appkey',
      'build': 8430300,
      'channel': 'master',
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'device': 'android',
      'disable_rcmd': 0,
      'mobi_app': 'android',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statisticsApp,
      'ts': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    AppSign.appSign(
      params,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await Request().get(
      Api.getLiveFavTag,
      queryParameters: params,
    );

    if (res.data['code'] == 0) {
      return Success(
        (res.data['data']?['tags'] as List?)
                ?.map((e) => AreaItem.fromJson(e))
                .toList() ??
            <AreaItem>[],
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future setLiveFavTag({
    required String ids,
  }) async {
    final data = {
      'tags': ids,
      'access_key': Accounts.main.accessKey,
      'appkey': Constants.appKey,
      'actionKey': 'appkey',
      'build': 8430300,
      'channel': 'master',
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'device': 'android',
      'disable_rcmd': 0,
      'mobi_app': 'android',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statisticsApp,
      'ts': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    AppSign.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await Request().post(
      Api.setLiveFavTag,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<List<AreaItem>?>> liveRoomAreaList({
    required Object parentid,
  }) async {
    final params = {
      'access_key': ?recommend.accessKey,
      'appkey': Constants.appKey,
      'actionKey': 'appkey',
      'build': 8430300,
      'channel': 'master',
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'device': 'android',
      'disable_rcmd': 0,
      'need_entrance': 1,
      'parent_id': parentid,
      'source_id': 2,
      'mobi_app': 'android',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statisticsApp,
      'ts': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    AppSign.appSign(
      params,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await Request().get(
      Api.liveRoomAreaList,
      queryParameters: params,
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data'] as List?)?.map((e) => AreaItem.fromJson(e)).toList(),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<LiveSearchData>> liveSearch({
    required int page,
    required String keyword,
    required LiveSearchType type,
  }) async {
    final params = {
      'access_key': ?recommend.accessKey,
      'appkey': Constants.appKey,
      'actionKey': 'appkey',
      'build': 8430300,
      'channel': 'master',
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'device': 'android',
      'page': page,
      'pagesize': 30,
      'keyword': keyword,
      'disable_rcmd': 0,
      'mobi_app': 'android',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statisticsApp,
      'ts': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'type': type.name,
    };
    AppSign.appSign(
      params,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await Request().get(
      Api.liveSearch,
      queryParameters: params,
    );
    if (res.data['code'] == 0) {
      return Success(LiveSearchData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<ShieldInfo?>> getLiveInfoByUser(
    dynamic roomId,
  ) async {
    var res = await Request().get(
      Api.getLiveInfoByUser,
      queryParameters: await WbiSign.makSign({
        'room_id': roomId,
        'from': 0,
        'not_mock_enter_effect': 1,
        'web_location': 444.8,
      }),
    );
    if (res.data['code'] == 0) {
      return Success(LiveDmBlockData.fromJson(res.data['data']).shieldInfo);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future liveSetSilent({
    required String type,
    required int level,
  }) async {
    final csrf = Accounts.main.csrf;
    var res = await Request().post(
      Api.liveSetSilent,
      data: {
        'type': type,
        'level': level,
        'csrf': csrf,
        'csrf_token': csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future addShieldKeyword({
    required String keyword,
  }) async {
    final csrf = Accounts.main.csrf;
    var res = await Request().post(
      Api.addShieldKeyword,
      data: {
        'keyword': keyword,
        'csrf': csrf,
        'csrf_token': csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future delShieldKeyword({
    required String keyword,
  }) async {
    final csrf = Accounts.main.csrf;
    var res = await Request().post(
      Api.delShieldKeyword,
      data: {
        'keyword': keyword,
        'csrf': csrf,
        'csrf_token': csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future liveShieldUser({
    required dynamic uid,
    required dynamic roomid,
    required int type,
  }) async {
    final csrf = Accounts.main.csrf;
    var res = await Request().post(
      Api.liveShieldUser,
      data: {
        'uid': uid,
        'roomid': roomid,
        'type': type,
        'csrf': csrf,
        'csrf_token': csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future liveLikeReport({
    required int clickTime,
    required dynamic roomId,
    required dynamic uid,
    required dynamic anchorId,
  }) async {
    var res = await Request().post(
      Api.liveLikeReport,
      data: await WbiSign.makSign({
        'click_time': clickTime,
        'room_id': roomId,
        'uid': uid,
        'anchor_id': anchorId,
        'web_location': 444.8,
        'csrf': Accounts.heartbeat.csrf,
      }),
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<SuperChatData>> superChatMsg(
    dynamic roomId,
  ) async {
    var res = await Request().get(
      Api.superChatMsg,
      queryParameters: {
        'room_id': roomId,
      },
    );
    if (res.data['code'] == 0) {
      try {
        return Success(SuperChatData.fromJson(res.data['data']));
      } catch (e) {
        return Error(e.toString());
      }
    } else {
      return Error(res.data['message']);
    }
  }
}
