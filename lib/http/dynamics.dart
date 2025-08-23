import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/reply/reply_option_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:PiliPlus/models_new/article/article_info/data.dart';
import 'package:PiliPlus/models_new/article/article_list/data.dart';
import 'package:PiliPlus/models_new/article/article_view/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/group.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reserve/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reserve_info/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_feed/topic_card_list.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_top/top_details.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_top/topic_item.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';

class DynamicsHttp {
  static Future<LoadingState<DynamicsDataModel>> followDynamic({
    DynamicsTabType type = DynamicsTabType.all,
    String? offset,
    int? mid,
    Set<int>? tempBannedList,
  }) async {
    final data = {
      if (type == DynamicsTabType.up)
        'host_mid': mid!
      else ...{
        'type': type.name,
        'timezone_offset': '-480',
      },
      'offset': ?offset,
      'features': 'itemOpusStyle,listOnlyfans',
    };
    var res = await Request().get(Api.followDynamic, queryParameters: data);
    var code = res.data['code'];
    if (code == 0) {
      try {
        DynamicsDataModel data = DynamicsDataModel.fromJson(
          res.data['data'],
          type: type,
          tempBannedList: tempBannedList,
        );
        return Success(data);
      } catch (err) {
        return Error(err.toString());
      }
    } else {
      return Error(code == 4101132 ? '没有数据' : res.data['message']);
    }
  }

  static Future<LoadingState<FollowUpModel>> followUp() async {
    var res = await Request().get(Api.followUp);
    if (res.data['code'] == 0) {
      return Success(FollowUpModel.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
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

  static Future createDynamic({
    Object? mid,
    Object? dynIdStr, // repost dyn
    Object? rid, // repost video
    Object? dynType,
    Object? rawText,
    List? pics,
    int? publishTime,
    ReplyOptionType? replyOption,
    int? privatePub,
    List<Map<String, dynamic>>? extraContent,
    Pair<int, String>? topic,
    String? title,
    Map? attachCard,
  }) async {
    var res = await Request().post(
      Api.createDynamic,
      queryParameters: {
        'platform': 'web',
        'csrf': Accounts.main.csrf,
        'x-bili-device-req-json': {"platform": "web", "device": "pc"},
        'x-bili-web-req-json': {"spm_id": "333.999"},
      },
      data: {
        "dyn_req": {
          "content": {
            "contents": [
              if (rawText != null)
                {
                  "raw_text": rawText,
                  "type": 1,
                  "biz_id": "",
                },
              ...?extraContent,
            ],
            if (title?.isNotEmpty == true) 'title': title,
          },
          if (privatePub != null || replyOption != null || publishTime != null)
            "option": {
              'private_pub': ?privatePub,
              "timer_pub_time": ?publishTime,
              if (replyOption == ReplyOptionType.close)
                "close_comment": 1
              else if (replyOption == ReplyOptionType.choose)
                "up_choose_comment": 1,
            },
          "scene": rid != null
              ? 5
              : dynIdStr != null
              ? 4
              : pics != null
              ? 2
              : 1,
          'pics': ?pics,
          "attach_card": attachCard,
          "upload_id":
              "${rid != null ? 0 : mid}_${DateTime.now().millisecondsSinceEpoch ~/ 1000}_${Utils.random.nextInt(9000) + 1000}",
          "meta": {
            "app_meta": {"from": "create.dynamic.web", "mobi_app": "web"},
          },
          if (topic != null)
            "topic": {
              "id": topic.first,
              "name": topic.second,
              "from_source": "dyn.web.list",
              "from_topic_id": 0,
            },
        },
        if (dynIdStr != null || rid != null)
          "web_repost_src": {
            "dyn_id_str": ?dynIdStr,
            if (rid != null)
              "revs_id": {
                "dyn_type": dynType,
                "rid": rid,
              },
          },
      },
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

  //
  static Future dynamicDetail({
    Object? id,
    Object? rid,
    Object? type,
    bool clearCookie = false,
  }) async {
    var res = await Request().get(
      Api.dynamicDetail,
      queryParameters: {
        'timezone_offset': -480,
        'id': ?id,
        'rid': ?rid,
        'type': ?type,
        'features': 'itemOpusStyle',
        'gaia_source': 'Athena',
        'web_location': '333.1330',
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.1330"}',
        if (!clearCookie && Accounts.main.isLogin) 'csrf': Accounts.main.csrf,
      },
      options: clearCookie ? ReplyHttp.options : null,
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
    required Object dynamicId,
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

  static Future rmTop({
    required Object dynamicId,
  }) async {
    var res = await Request().post(
      Api.rmTopDyn,
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
    required Object cvId,
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
      return {
        'status': true,
        'data': ArticleInfoData.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<ArticleViewData>> articleView({
    required Object cvId,
  }) async {
    final res = await Request().get(
      Api.articleView,
      queryParameters: await WbiSign.makSign({
        'id': cvId,
        'gaia_source': 'main_web',
        'web_location': '333.976',
      }),
    );
    if (res.data['code'] == 0) {
      return Success(ArticleViewData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<DynamicItemModel>> opusDetail({
    required Object opusId,
  }) async {
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

  static Future<LoadingState<VoteInfo>> voteInfo(Object voteId) async {
    final res = await Request().get(
      Api.voteInfo,
      queryParameters: {'vote_id': voteId},
    );
    if (res.data['code'] == 0) {
      return Success(VoteInfo.fromSeparatedJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<VoteInfo>> doVote({
    required int voteId,
    required List<int> votes,
    bool anonymity = false,
    int? dynamicId,
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
      'csrf': csrf,
    };
    final res = await Request().post(
      Api.doVote,
      queryParameters: {'csrf': csrf},
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    );
    if (res.data['code'] == 0) {
      return Success(VoteInfo.fromJson(res.data['data']['vote_info']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<TopDetails?>> topicTop({
    required Object topicId,
  }) async {
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
    required Object topicId,
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
    required Object id,
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
    required Object reserveId,
    required Object curBtnStatus,
    required Object dynamicIdStr,
    required Object reserveTotal,
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
      return {
        'status': true,
        'data': DynReserveData.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<List<TopicItem>?>> dynTopicRcmd({
    int ps = 25,
  }) async {
    final res = await Request().get(
      Api.dynTopicRcmd,
      queryParameters: {
        'source': 'Web',
        'page_size': ps,
        'web_location': 333.1365,
      },
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data']?['topic_items'] as List?)
            ?.map((e) => TopicItem.fromJson(e))
            .toList(),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<OpusPicModel>?>> dynPic(Object id) async {
    final res = await Request().get(
      Api.dynPic,
      queryParameters: {
        'id': id,
        'web_location': 333.1368,
      },
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data'] as List?)
            ?.map((e) => OpusPicModel.fromJson(e))
            .toList(),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<MentionGroup>?>> dynMention({
    String? keyword,
  }) async {
    final res = await Request().get(
      Api.dynMention,
      queryParameters: {
        if (keyword?.isNotEmpty == true) 'keyword': keyword!,
        'web_location': 333.1365,
      },
    );
    if (res.data['code'] == 0) {
      return Success(
        DynMentionData.fromJson(res.data['data']).groups,
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<int?>> createVote(VoteInfo voteInfo) async {
    final res = await Request().post(
      Api.createVote,
      queryParameters: {'csrf': Accounts.main.csrf},
      data: {'vote_info': voteInfo.toJson()},
    );
    if (res.data['code'] == 0) {
      return Success(res.data['data']?['vote_id']);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<int?>> updateVote(VoteInfo voteInfo) async {
    final res = await Request().post(
      Api.updateVote,
      queryParameters: {'csrf': Accounts.main.csrf},
      data: {'vote_info': voteInfo.toJson()},
    );
    if (res.data['code'] == 0) {
      return Success(res.data['data']?['vote_id']);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<int?>> createReserve({
    int subType = 0,
    required String title,
    required int livePlanStartTime,
  }) async {
    final res = await Request().post(
      Api.createReserve,
      data: {
        'type': 2,
        'sub_type': subType,
        'from': 1,
        'title': title,
        'live_plan_start_time': livePlanStartTime,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return Success(res.data['data']?['sid']);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<int?>> updateReserve({
    int subType = 0,
    required String title,
    required int livePlanStartTime,
    required int sid,
  }) async {
    final res = await Request().post(
      Api.updateReserve,
      data: {
        'type': 2,
        'sub_type': subType,
        'from': 1,
        'title': title,
        'live_plan_start_time': livePlanStartTime,
        'id': sid,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return Success(res.data['data']?['sid']);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<ReserveInfoData>> reserveInfo({
    required Object sid,
  }) async {
    final res = await Request().get(
      Api.reserveInfo,
      queryParameters: {
        'from': 1,
        'id': sid,
        'web_location': 333.1365,
      },
    );
    if (res.data['code'] == 0) {
      return Success(ReserveInfoData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }
}
