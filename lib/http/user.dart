import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/models/user/stat.dart';
import 'package:PiliPlus/models_new/coin_log/data.dart';
import 'package:PiliPlus/models_new/follow/data.dart';
import 'package:PiliPlus/models_new/history/data.dart';
import 'package:PiliPlus/models_new/later/data.dart';
import 'package:PiliPlus/models_new/login_log/data.dart';
import 'package:PiliPlus/models_new/media_list/data.dart';
import 'package:PiliPlus/models_new/space_setting/data.dart';
import 'package:PiliPlus/models_new/sub/sub/data.dart';
import 'package:PiliPlus/models_new/user_real_name/data.dart';
import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/app_sign.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class UserHttp {
  static Future<dynamic> userStat({required int mid}) async {
    var res = await Request().get(Api.userStat, queryParameters: {'vmid': mid});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false};
    }
  }

  static Future<LoadingState<UserInfoData>> userInfo() async {
    var res = await Request().get(Api.userInfo);
    if (res.data['code'] == 0) {
      UserInfoData data = UserInfoData.fromJson(res.data['data']);
      GlobalData().coins = data.money;
      return Success(data);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<dynamic> userStatOwner() async {
    var res = await Request().get(Api.userStatOwner);
    if (res.data['code'] == 0) {
      UserStat data = UserStat.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 稍后再看
  static Future<LoadingState<LaterData>> seeYouLater({
    required int page,
    int viewed = 0,
    String keyword = '',
    bool asc = false,
  }) async {
    var res = await Request().get(
      Api.seeYouLater,
      queryParameters: await WbiSign.makSign({
        'pn': page,
        'ps': 20,
        'viewed': viewed,
        'key': keyword,
        'asc': asc,
        'need_split': true,
        'web_location': 333.881,
      }),
    );
    if (res.data['code'] == 0) {
      return Success(LaterData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  // 观看历史
  static Future<LoadingState<HistoryData>> historyList({
    required String type,
    int? max,
    int? viewAt,
    Account? account,
  }) async {
    var res = await Request().get(
      Api.historyList,
      queryParameters: {
        'type': type,
        'ps': 20,
        'max': max ?? 0,
        'view_at': viewAt ?? 0,
      },
      options: Options(extra: {'account': account ?? Accounts.history}),
    );
    if (res.data['code'] == 0) {
      return Success(HistoryData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  // 暂停观看历史
  static Future pauseHistory(bool switchStatus, {Account? account}) async {
    // 暂停switchStatus传true 否则false
    account ??= Accounts.history;
    var res = await Request().post(
      Api.pauseHistory,
      data: {
        'switch': switchStatus,
        'jsonp': 'jsonp',
        'csrf': account.csrf,
      },
      options: Options(
        extra: {'account': account},
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    return res;
  }

  // 观看历史暂停状态
  static Future historyStatus({Account? account}) async {
    var res = await Request().get(
      Api.historyStatus,
      options: Options(extra: {'account': account ?? Accounts.history}),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 清空历史记录
  static Future clearHistory({Account? account}) async {
    account ??= Accounts.history;
    var res = await Request().post(
      Api.clearHistory,
      data: {
        'jsonp': 'jsonp',
        'csrf': account.csrf,
      },
      options: Options(
        extra: {'account': account},
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    return res;
  }

  // 稍后再看
  static Future toViewLater({String? bvid, dynamic aid}) async {
    var res = await Request().post(
      Api.toViewLater,
      data: {
        'aid': ?aid,
        'bvid': ?bvid,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': 'yeah！稍后再看'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 移除已观看
  static Future toViewDel({required String aids}) async {
    final Map<String, dynamic> params = {
      'csrf': Accounts.main.csrf,
      'resources': aids,
    };
    var res = await Request().post(
      Api.toViewDel,
      data: params,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': 'yeah！成功移除'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 获取用户凭证 失效
  static Future thirdLogin() async {
    var res = await Request().get(
      'https://passport.bilibili.com/login/app/third',
      queryParameters: {
        'appkey': Constants.appKey,
        'api': Constants.thirdApi,
        'sign': Constants.thirdSign,
      },
    );
    try {
      if (res.data['code'] == 0 && res.data['data']['has_login'] == 1) {
        Request().get(res.data['data']['confirm_uri']);
      }
    } catch (err) {
      SmartDialog.showNotify(msg: '获取用户凭证: $err', notifyType: NotifyType.error);
    }
  }

  // 清空稍后再看 // clean_type: null->all, 1->invalid, 2->viewed
  static Future toViewClear([int? cleanType]) async {
    var res = await Request().post(
      Api.toViewClear,
      data: {
        'clean_type': ?cleanType,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': '操作完成'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 删除历史记录
  static Future delHistory(String kid, {Account? account}) async {
    account ??= Accounts.history;
    var res = await Request().post(
      Api.delHistory,
      data: {
        'kid': kid,
        'jsonp': 'jsonp',
        'csrf': account.csrf,
      },
      options: Options(
        extra: {'account': account},
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': '已删除'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future hasFollow(int mid) async {
    var res = await Request().get(
      Api.relation,
      queryParameters: {
        'fid': mid,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 搜索历史记录
  static Future<LoadingState<HistoryData>> searchHistory({
    required int pn,
    required String keyword,
    Account? account,
  }) async {
    var res = await Request().get(
      Api.searchHistory,
      queryParameters: {
        'pn': pn,
        'keyword': keyword,
        'business': 'all',
      },
      options: Options(extra: {'account': account ?? Accounts.history}),
    );
    if (res.data['code'] == 0) {
      return Success(HistoryData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  // 我的订阅
  static Future<LoadingState<SubData>> userSubFolder({
    required int mid,
    required int pn,
    required int ps,
  }) async {
    var res = await Request().get(
      Api.userSubFolder,
      queryParameters: {
        'up_mid': mid,
        'ps': ps,
        'pn': pn,
        'platform': 'web',
      },
    );
    if (res.data['code'] == 0 && res.data['data'] is Map) {
      return Success(SubData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<VideoTagItem>?>> videoTags({
    required String bvid,
    Object? cid,
  }) async {
    var res = await Request().get(
      Api.videoTags,
      queryParameters: {'bvid': bvid, 'cid': ?cid},
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data'] as List?)
            ?.map((e) => VideoTagItem.fromJson(e))
            .toList(),
      );
    } else {
      return const Error(null);
    }
  }

  // 稍后再看列表
  static Future getMediaList({
    required dynamic type,
    required bizId,
    required int ps,
    dynamic oid,
    int? otype,
    bool withCurrent = false,
    bool desc = true,
    dynamic sortField = 1,
    bool direction = false,
  }) async {
    var res = await Request().get(
      Api.mediaList,
      queryParameters: {
        'mobi_app': 'web',
        'type': type,
        'biz_id': bizId,
        'oid': ?oid,
        'otype': ?otype, // ugc:2 // pgc: 24
        'ps': ps,
        'direction': direction,
        'desc': desc,
        'sort_field': sortField,
        'tid': 0,
        'with_current': withCurrent,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': MediaListData.fromJson(res.data['data'])};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future getCoin() async {
    final res = await Request().get(Api.getCoin);
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']?['money']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<Map> dynamicReport({
    required dynamic mid,
    required dynamic dynId,
    required int reasonType,
    String? reasonDesc,
  }) async {
    final res = await Request().post(
      Api.dynamicReport,
      queryParameters: {
        'csrf': Accounts.main.csrf,
      },
      data: {
        "accused_uid": mid,
        "dynamic_id": dynId,
        "reason_type": reasonType,
        "reason_desc": reasonType == 0 ? reasonDesc : null,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return res.data as Map;
  }

  static Future<LoadingState<SpaceSettingData>> spaceSetting() async {
    final res = await Request().get(
      Api.spaceSetting,
      queryParameters: {
        'mid': Accounts.main.mid,
      },
    );
    if (res.data['code'] == 0) {
      return Success(SpaceSettingData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future spaceSettingMod(data) async {
    final res = await Request().post(
      Api.spaceSettingMod,
      queryParameters: {
        'csrf': Accounts.main.csrf,
      },
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future vipExpAdd() async {
    final res = await Request().post(
      Api.vipExpAdd,
      queryParameters: {
        'mid': Accounts.main.mid,
        'csrf': Accounts.main.csrf,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<CoinLogData>> coinLog() async {
    final res = await Request().get(
      Api.coinLog,
      queryParameters: {
        'jsonp': 'jsonp',
        'web_location': '333.33',
      },
    );
    if (res.data['code'] == 0) {
      return Success(CoinLogData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<LoginLogData>> loginLog() async {
    final res = await Request().get(
      Api.loginLog,
      queryParameters: {
        'jsonp': 'jsonp',
        'web_location': '333.33',
      },
    );
    if (res.data['code'] == 0) {
      return Success(LoginLogData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<CoinLogData>> expLog() async {
    final res = await Request().get(
      Api.expLog,
      queryParameters: {
        'jsonp': 'jsonp',
        'web_location': '333.33',
      },
    );
    if (res.data['code'] == 0) {
      return Success(CoinLogData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<UserRealNameData>> getUserRealName(
    Object mid,
  ) async {
    final params = {
      'access_key': Accounts.main.accessKey,
      'up_mid': mid,
    };
    AppSign.appSign(params);
    final res = await Request().get(
      Api.userRealName,
      queryParameters: params,
    );
    if (res.data['code'] == 0) {
      return Success(UserRealNameData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<FollowData>> followedUp({
    required Object mid,
    required int pn,
  }) async {
    final res = await Request().get(
      Api.followedUp,
      queryParameters: {
        'csrf': Accounts.main.csrf,
        'pn': pn,
        'vmid': mid,
        'web_location': 333.789,
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.789"}',
      },
    );
    if (res.data['code'] == 0) {
      return Success(FollowData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<FollowData>> sameFollowing({
    required Object mid,
    int? pn,
  }) async {
    final res = await Request().get(
      Api.sameFollowing,
      queryParameters: {
        'csrf': Accounts.main.csrf,
        'pn': ?pn,
        'vmid': mid,
        'web_location': 333.789,
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.789"}',
      },
    );
    if (res.data['code'] == 0) {
      return Success(FollowData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }
}
