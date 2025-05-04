import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:PiliPlus/models/space_article/item.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';

class DynamicsHttp {
  static Future<LoadingState<DynamicsDataModel>> followDynamic({
    String? type,
    String? offset,
    int? mid,
  }) async {
    Map<String, dynamic> data = {
      'type': type ?? 'all',
      'timezone_offset': '-480',
      'offset': offset,
      'features': 'itemOpusStyle,listOnlyfans'
    };
    if (mid != -1) {
      data['host_mid'] = mid;
      data.remove('timezone_offset');
    }
    var res = await Request().get(Api.followDynamic, queryParameters: data);
    if (res.data['code'] == 0) {
      try {
        DynamicsDataModel data = DynamicsDataModel.fromJson(res.data['data']);
        if (GStorage.antiGoodsDyn) {
          data.items?.removeWhere(
            (item) =>
                item.orig?.modules.moduleDynamic?.additional?.type ==
                    'ADDITIONAL_TYPE_GOODS' ||
                item.modules.moduleDynamic?.additional?.type ==
                    'ADDITIONAL_TYPE_GOODS',
          );
        }
        return LoadingState.success(data);
      } catch (err) {
        return LoadingState.error(err.toString());
      }
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future followUp() async {
    var res = await Request().get(Api.followUp);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': FollowUpModel.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 动态点赞
  // static Future likeDynamic({
  //   required String? dynamicId,
  //   required int? up,
  // }) async {
  //   var res = await Request().post(
  //     Api.likeDynamic,
  //     queryParameters: {
  //       'dynamic_id': dynamicId,
  //       'up': up,
  //       'csrf': Accounts.main.csrf,
  //     },
  //   );
  //   if (res.data['code'] == 0) {
  //     return {
  //       'status': true,
  //       'data': res.data['data'],
  //     };
  //   } else {
  //     return {'status': false, 'msg': res.data['message']};
  //   }
  // }

  // 动态点赞
  static Future thumbDynamic({
    required String? dynamicId,
    required int? up,
  }) async {
    var res = await Request().post(
      Api.thumbDynamic,
      queryParameters: {
        'csrf': Accounts.main.csrf,
      },
      data: {
        'dyn_id_str': dynamicId,
        'up': up,
        'spmid': '333.1365.0.0',
      },
      options: Options(
        headers: {
          'referer': HttpString.dynamicShareBaseUrl,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  //
  static Future dynamicDetail({
    dynamic id,
    dynamic rid,
    dynamic type,
    bool clearCookie = false,
  }) async {
    var res = await Request().get(
      Api.dynamicDetail,
      queryParameters: {
        'timezone_offset': -480,
        if (id != null) 'id': id,
        if (rid != null) 'rid': rid,
        if (type != null) 'type': type,
        'features': 'itemOpusStyle,listOnlyfans',
      },
      options:
          clearCookie ? Options(extra: {'account': AnonymousAccount()}) : null,
    );
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': DynamicItemModel.fromJson(res.data['data']['item']),
        };
      } catch (err) {
        return {
          'status': false,
          'msg': err.toString(),
        };
      }
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  static Future setTop({
    required dynamic dynamicId,
  }) async {
    var res = await Request().post(
      Api.setTopDyn,
      queryParameters: {
        'csrf': Accounts.main.csrf,
      },
      data: {
        'dyn_str': dynamicId,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future articleInfo({
    required dynamic cvId,
  }) async {
    var res = await Request().get(
      Api.articleInfo,
      queryParameters: await WbiSign.makSign({
        'id': cvId,
        'mobi_app': 'pc',
        'from': 'web',
        'gaia_source': 'main_web',
      }),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<SpaceArticleItem>> articleView(
      {required dynamic cvId}) async {
    final res = await Request().get(
      Api.articleView,
      queryParameters: await WbiSign.makSign({
        'id': cvId,
        'gaia_source': 'main_web',
        'web_location': '333.976',
      }),
    );

    return res.data['code'] == 0
        ? LoadingState.success(SpaceArticleItem.fromJson(res.data['data']))
        : LoadingState.error(res.data['message']);
  }

  static Future<LoadingState<DynamicItemModel>> opusDetail(
      {required dynamic opusId}) async {
    final res = await Request().get(
      Api.opusDetail,
      queryParameters: await WbiSign.makSign({
        'timezone_offset': '-480',
        'features': 'htmlNewStyle',
        'id': opusId,
      }),
    );

    return res.data['code'] == 0
        ? LoadingState.success(DynamicItemModel.fromOpusJson(res.data['data']))
        : LoadingState.error(res.data['message']);
  }

  static Future<LoadingState<VoteInfo>> voteInfo(dynamic voteId) async {
    final res =
        await Request().get(Api.voteInfo, queryParameters: {'vote_id': voteId});

    return res.data['code'] == 0
        ? LoadingState.success(VoteInfo.fromSeparatedJson(res.data['data']))
        : LoadingState.error(res.data['message']);
  }

  static Future<LoadingState<VoteInfo>> doVote({
    required int voteId,
    required List<int> votes,
    bool anonymity = false,
    int? dynamicId,
  }) async {
    final csrf = Accounts.main.csrf;
    final data = {
      'vote_id': 15141778,
      'votes': votes,
      'voter_uid': Accounts.main.mid,
      'status': anonymity ? 1 : 0,
      'op_bit': 0,
      'dynamic_id': dynamicId ?? 0,
      'csrf_token': csrf,
      'csrf': csrf
    };
    final res = await Request().post(Api.doVote,
        queryParameters: {'csrf': csrf},
        data: data,
        options: Options(contentType: Headers.jsonContentType));

    return res.data['code'] == 0
        ? LoadingState.success(VoteInfo.fromJson(res.data['data']['vote_info']))
        : LoadingState.error(res.data['message']);
  }
}
