import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/article_list/data.dart';
import 'package:PiliPlus/models/dynamics/dyn_topic_feed/topic_card_list.dart';
import 'package:PiliPlus/models/dynamics/dyn_topic_top/top_details.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:PiliPlus/models/space_article/item.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';

class DynamicsHttp {
  static RegExp banWordForDyn =
      RegExp(GStorage.banWordForDyn, caseSensitive: false);

  static Future<LoadingState<DynamicsDataModel>> followDynamic({
    DynamicsTabType type = DynamicsTabType.all,
    String? offset,
    int? mid,
  }) async {
    Map<String, dynamic> data = {
      if (type == DynamicsTabType.up)
        'host_mid': mid
      else ...{
        'type': type.name,
        'timezone_offset': '-480',
      },
      'offset': offset,
      'features': 'itemOpusStyle,listOnlyfans',
    };
    var res = await Request().get(Api.followDynamic, queryParameters: data);
    if (res.data['code'] == 0) {
      try {
        DynamicsDataModel data = DynamicsDataModel.fromJson(res.data['data']);
        final antiGoodsDyn = GStorage.antiGoodsDyn;
        final filterWord = banWordForDyn.pattern.isNotEmpty;

        data.items?.removeWhere(
          (item) =>
              (antiGoodsDyn &&
                  (item.orig?.modules.moduleDynamic?.additional?.type ==
                          'ADDITIONAL_TYPE_GOODS' ||
                      item.modules.moduleDynamic?.additional?.type ==
                          'ADDITIONAL_TYPE_GOODS')) ||
              (filterWord &&
                  (item.orig?.modules.moduleDynamic?.major?.opus?.summary?.text
                              ?.contains(banWordForDyn) ==
                          true ||
                      item.modules.moduleDynamic?.major?.opus?.summary?.text
                              ?.contains(banWordForDyn) ==
                          true ||
                      item.orig?.modules.moduleDynamic?.desc?.text
                              ?.contains(banWordForDyn) ==
                          true ||
                      item.modules.moduleDynamic?.desc?.text
                              ?.contains(banWordForDyn) ==
                          true)),
        );
        return Success(data);
      } catch (err) {
        return Error(err.toString());
      }
    } else {
      return Error(res.data['message']);
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
        'features': 'itemOpusStyle',
        'gaia_source': 'Athena',
        'web_location': '333.1330',
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.1330"}',
        if (Accounts.main.isLogin) 'csrf': Accounts.main.csrf,
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
    if (res.data['code'] == 0) {
      return Success(SpaceArticleItem.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
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
    if (res.data['code'] == 0) {
      return Success(DynamicItemModel.fromOpusJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<VoteInfo>> voteInfo(dynamic voteId) async {
    final res =
        await Request().get(Api.voteInfo, queryParameters: {'vote_id': voteId});
    if (res.data['code'] == 0) {
      return Success(VoteInfo.fromSeparatedJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<VoteInfo>> doVote({
    required voteId,
    required List<int> votes,
    bool anonymity = false,
    dynamicId,
  }) async {
    final csrf = Accounts.main.csrf;
    final data = {
      'vote_id': voteId,
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
    if (res.data['code'] == 0) {
      return Success(VoteInfo.fromJson(res.data['data']['vote_info']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<TopDetails?>> topicTop({required topicId}) async {
    final res = await Request().get(
      Api.topicTop,
      queryParameters: {
        'topic_id': topicId,
        'source': 'Web',
      },
    );
    if (res.data['code'] == 0) {
      TopDetails? data = res.data['data']?['top_details'] == null
          ? null
          : TopDetails.fromJson(res.data['data']['top_details']);
      return Success(data);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<TopicCardList?>> topicFeed({
    required topicId,
    required String offset,
    required int sortBy,
  }) async {
    final res = await Request().get(
      Api.topicFeed,
      queryParameters: {
        'topic_id': topicId,
        'sort_by': sortBy,
        'offset': offset,
        'page_size': 20,
        'source': 'Web',
        // itemOpusStyle,listOnlyfans,opusBigCover,onlyfansVote,decorationCard
        'features': 'itemOpusStyle,listOnlyfans',
      },
    );
    if (res.data['code'] == 0) {
      TopicCardList? data = res.data['data']?['topic_card_list'] == null
          ? null
          : TopicCardList.fromJson(res.data['data']['topic_card_list']);
      return Success(data);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<ArticleListData>> articleList({
    required id,
  }) async {
    final res = await Request().get(
      Api.articleList,
      queryParameters: {
        'id': id,
        'web_location': 333.1400,
      },
    );
    if (res.data['code'] == 0) {
      return Success(ArticleListData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future dynReserve({
    required reserveId,
    required curBtnStatus,
    required dynamicIdStr,
    required reserveTotal,
  }) async {
    var res = await Request().post(
      Api.dynReserve,
      queryParameters: {
        'csrf': Accounts.main.csrf,
      },
      data: {
        'reserve_id': reserveId,
        'cur_btn_status': curBtnStatus,
        'dynamic_id_str': dynamicIdStr,
        'reserve_total': reserveTotal,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }
}
