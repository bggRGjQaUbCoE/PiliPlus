import 'dart:convert';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/error_msg.dart';
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
import 'package:PiliPlus/models_new/bubble/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/group.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reaction/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reserve/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reserve_info/data.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_feed/topic_card_list.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_top/top_details.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_top/topic_item.dart';
import 'package:PiliPlus/models_new/followee_votes/vote.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/parse_int.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';

abstract final class DynamicsHttp {
  @pragma('vm:notify-debugger-on-exception')
  static Future<LoadingState<DynamicsDataModel>> followDynamic({
    int? hostMid,
    String? offset,
    Set<int>? tempBannedList,
    DynamicsTabType type = .all,
  }) async {
    Map<String, dynamic> data = {
      if (type == .up) 'host_mid': hostMid else 'type': type.name,
      'offset': ?offset,
      'features': Constants.dynFeatures,
    };
    final res = await Request().get(Api.followDynamic, queryParameters: data);
    final code = res.data['code'];
    if (code == 0) {
      try {
        DynamicsDataModel data = DynamicsDataModel.fromJson(
          res.data['data'],
          type: type,
          tempBannedList: tempBannedList,
        );
        if (data.loadNext == true) {
          return await followDynamic(
            type: type,
            offset: data.offset,
            hostMid: hostMid,
            tempBannedList: tempBannedList,
          );
        }
        return Success(data);
      } catch (e, s) {
        return Error('$e\n\n$s');
      }
    } else {
      return Error(code == 4101132 ? '没有数据' : res.data['message']);
    }
  }

  static Future<LoadingState<FollowUpModel>> followUp() async {
    final res = await Request().get(
      Api.followUp,
      queryParameters: {
        'up_list_more': 1,
        'web_location': 333.1365,
      },
    );
    if (res.data['code'] == 0) {
      return Success(FollowUpModel.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<FollowUpModel>> dynUpList(String? offset) async {
    final res = await Request().get(
      Api.dynUplist,
      queryParameters: {
        'offset': ?offset,
        'platform': 'web',
        'web_location': 333.1365,
      },
    );
    if (res.data['code'] == 0) {
      return Success(FollowUpModel.fromUpList(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  /// 按本地动态 id 基线收集新增动态的作者。
  ///
  /// 动态流接口虽然接受 `update_baseline` 参数并返回 `update_num`，但实测该字段在
  /// 传入基线后恒为字符串 `'0'`、与基线深浅无关，因此「哪些动态算新」改由客户端判定：
  /// 把服务端返回的 `update_baseline`（代表「此刻」的截止线）存下来，下次只取回动态 id
  /// 严格大于该截止线的记录即可，无需再向接口传参。
  ///
  /// 这里固定读综合动态流（`type=all`）而不是按模式切换流：实测同一时间窗内，综合流中
  /// `DYNAMIC_TYPE_AV` 的集合与视频流（`type=video`）返回的集合完全一致，所以一次请求
  /// 就能同时支撑「所有动态」与「仅视频」两种展示，且后者天然是前者的子集。
  ///
  /// 翻页与截断规则本身位于 [DynamicUpUpdateResult.scan]，此处只负责取页，
  /// 使同一套规则可以用真实抓包数据离线回归。
  ///
  /// [backfillPages] 只在首次启用（本地还没有基线）时生效：先取若干页作为回补，
  /// 避免刚开启功能后红点长时间为空；基线仍推进到「此刻」，回补内容不会被重复计入。
  /// [maxPages] 是已有基线时的翻页上限，防止长时间未检查导致请求无限翻页。
  static Future<LoadingState<DynamicUpUpdateResult>> followDynamicUpdates({
    required String? updateBaseline,
    int backfillPages = 0,
    int maxPages = 8,
  }) async {
    // 取页失败时暂存服务端返回的错误信息，供上层提示用户。
    dynamic errorMessage;
    final result = await DynamicUpUpdateResult.scan(
      baselineId: safeToInt(updateBaseline) ?? 0,
      backfillPages: backfillPages,
      maxPages: maxPages,
      loadPage: (offset) async {
        final res = await Request().get(
          Api.followDynamic,
          queryParameters: {
            if (offset?.isNotEmpty == true) 'offset': offset,
            'type': DynamicsTabType.all.name,
            'features': Constants.dynFeatures,
          },
        );
        if (res.data['code'] != 0) {
          errorMessage = res.data['message'];
          return null;
        }
        return DynamicUpUpdatePage.fromJson(res.data['data']);
      },
    );
    if (result == null) {
      return Error(errorMessage ?? '获取更新动态失败');
    }
    return Success(result);
  }

  static Future<LoadingState<FollowUpModel>> followings({
    int? vmid,
    int? pn,
    int ps = 20,
    String orderType = '', // ''=>最近关注，'attention'=>最常访问
  }) async {
    final res = await Request().get(
      Api.followings,
      queryParameters: {
        'vmid': vmid,
        'pn': pn,
        'ps': ps,
        'order': 'desc',
        'order_type': orderType,
      },
    );
    if (res.data['code'] == 0) {
      return Success(FollowUpModel.fromFollowList(res.data['data']));
    } else {
      return Error(errorMsg[res.data['code']] ?? res.data['message']);
    }
  }

  // 动态点赞
  // static Future likeDynamic({
  //   required String? dynamicId,
  //   required int? up,
  // }) async {
  //   final res = await Request().post(
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
  static Future<LoadingState<void>> thumbDynamic({
    required String? dynamicId,
    required int? up,
  }) async {
    final res = await Request().post(
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
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<Map?>> createDynamic({
    dynamic mid,
    dynamic dynIdStr, // repost dyn
    dynamic rid, // repost video
    dynamic dynType,
    dynamic rawText,
    List? pics,
    int? publishTime,
    ReplyOptionType? replyOption,
    int? privatePub,
    List<Map<String, dynamic>>? extraContent,
    Pair<int, String>? topic,
    String? title,
    Map? attachCard,
  }) async {
    final res = await Request().post(
      Api.createDynamic,
      queryParameters: {
        'platform': 'web',
        'csrf': Accounts.main.csrf,
        'x-bili-device-req-json': '{"platform": "web", "device": "pc"}',
        'x-bili-web-req-json': '{"spm_id": "333.999"}',
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
            if (title != null && title.isNotEmpty) 'title': title,
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
      return Success(res.data['data']);
    } else {
      return Error(res.data['message']);
    }
  }

  //
  @pragma('vm:notify-debugger-on-exception')
  static Future<LoadingState<DynamicItemModel>> dynamicDetail({
    dynamic id,
    dynamic rid,
    dynamic type,
    bool clearCookie = false,
  }) async {
    final res = await Request().get(
      Api.dynamicDetail,
      queryParameters: {
        'timezone_offset': -480,
        'id': ?id,
        'rid': ?rid,
        'type': ?type,
        'features': Constants.dynFeatures,
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
        return Success(DynamicItemModel.fromJson(res.data['data']['item']));
      } catch (e, s) {
        return Error('$e\n\n$s');
      }
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<void>> setTop({
    required Object dynamicId,
  }) async {
    final res = await Request().post(
      Api.setTopDyn,
      queryParameters: {
        'csrf': Accounts.main.csrf,
      },
      data: {
        'dyn_str': dynamicId,
      },
    );
    if (res.data['code'] == 0) {
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<void>> rmTop({
    required Object dynamicId,
  }) async {
    final res = await Request().post(
      Api.rmTopDyn,
      queryParameters: {
        'csrf': Accounts.main.csrf,
      },
      data: {
        'dyn_str': dynamicId,
      },
    );
    if (res.data['code'] == 0) {
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<ArticleInfoData>> articleInfo({
    required Object cvId,
  }) async {
    final res = await Request().get(
      Api.articleInfo,
      queryParameters: await WbiSign.makSign({
        'id': cvId,
        'mobi_app': 'pc',
        'from': 'web',
        'gaia_source': 'main_web',
      }),
    );
    if (res.data['code'] == 0) {
      return Success(ArticleInfoData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<ArticleViewData>> articleView({
    required dynamic cvId,
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
    required dynamic opusId,
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

  static Future<LoadingState<VoteInfo>> voteInfo(dynamic voteId) async {
    final res = await Request().get(
      Api.voteInfo,
      queryParameters: {'vote_id': voteId},
    );
    if (res.data['code'] == 0) {
      final voteInfo = VoteInfo.fromSeparatedJson(res.data['data']);
      return voteInfo.voteId == null
          ? const Error('无效的投票id')
          : Success(voteInfo);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<VoteInfo>> doVote({
    required int voteId,
    required List<int> votes,
    bool anonymous = false,
    int? dynamicId,
  }) async {
    final csrf = Accounts.main.csrf;
    final data = {
      'vote_id': voteId,
      'votes': votes,
      'voter_uid': Accounts.main.mid,
      'status': anonymous ? 1 : 0,
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
    String? offset,
    required int sortBy,
  }) async {
    final res = await Request().get(
      Api.topicFeed,
      queryParameters: {
        'topic_id': topicId,
        'sort_by': sortBy,
        'offset': ?offset,
        'page_size': 20,
        'source': 'Web',
        'features': Constants.dynFeatures,
      },
    );
    if (res.data['code'] == 0) {
      final list = res.data['data']?['topic_card_list'];
      if (list == null) {
        return const Success(null);
      } else {
        return Success(TopicCardList.fromJson(list));
      }
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<TopicCardList?>> topicFold({
    required Object topicId,
    required int sortBy,
  }) async {
    final res = await Request().get(
      Api.topicFold,
      queryParameters: {
        'topic_id': topicId,
        'sort_by': sortBy,
      },
    );
    if (res.data['code'] == 0) {
      final list = res.data['data']?['topic_card_list'];
      if (list == null) {
        return const Success(null);
      } else {
        return Success(TopicCardList.fromJson(list));
      }
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

  static Future<LoadingState<DynReserveData>> dynReserve({
    required Object? reserveId,
    required Object? curBtnStatus,
    required Object dynamicIdStr,
    required Object? reserveTotal,
  }) async {
    final res = await Request().post(
      Api.dynReserve,
      queryParameters: {
        'csrf': Accounts.main.csrf,
      },
      data: {
        'reserve_id': ?reserveId,
        'cur_btn_status': ?curBtnStatus,
        'dynamic_id_str': dynamicIdStr,
        'reserve_total': ?reserveTotal,
      },
    );
    if (res.data['code'] == 0) {
      return Success(DynReserveData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
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

  static Future<LoadingState<List<OpusPicModel>?>> dynPic(dynamic id) async {
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
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
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
    required dynamic sid,
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

  static Future<LoadingState<List<FolloweeVote>?>> followeeVotes({
    required dynamic voteId,
  }) async {
    final res = await Request().get(
      Api.followeeVotes,
      queryParameters: {
        'vote_id': voteId,
      },
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data']?['votes'] as List?)
            ?.map((e) => FolloweeVote.fromJson(e))
            .toList(),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<void>> dynPrivatePubSetting({
    required Object dynId,
    int? dynType,
    required String action,
  }) async {
    final res = await Request().post(
      Api.dynPrivatePubSetting,
      queryParameters: {
        'platform': 'web',
        'csrf': Accounts.main.csrf,
      },
      data: {
        "object_id": jsonEncode({
          "dyn_id": dynId.toString(),
          "dyn_type": ?dynType,
        }),
        "action": action,
      },
      options: Options(contentType: Headers.jsonContentType),
    );
    if (res.data['code'] == 0) {
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<void>> editDyn({
    required Object dynId,
    Object? repostDynId,
    dynamic rawText,
    List? pics,
    ReplyOptionType? replyOption,
    int? privatePub,
    List<Map<String, dynamic>>? extraContent,
    Pair<int, String>? topic,
    String? title,
    Map? attachCard,
  }) async {
    final uploadId =
        "${Accounts.main.mid}_${DateTime.now().millisecondsSinceEpoch ~/ 1000}_${Utils.random.nextInt(9000) + 1000}";
    final res = await Request().post(
      Api.editDyn,
      queryParameters: await WbiSign.makSign({
        'platform': 'web',
        'csrf': Accounts.main.csrf,
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.1368"}',
        'w_dyn_req.upload_id': uploadId,
        'w_dyn_req.meta':
            '{"app_meta":{"from":"create.dynamic.web","mobi_app":"web"}}',
      }),
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
            if (title != null && title.isNotEmpty) 'title': title,
          },
          if (privatePub != null || replyOption != null)
            "option": {
              'private_pub': ?privatePub,
              if (replyOption == ReplyOptionType.close)
                "close_comment": 1
              else if (replyOption == ReplyOptionType.choose)
                "up_choose_comment": 1,
            },
          "scene": repostDynId != null
              ? 4
              : pics != null
              ? 2
              : 1,
          'pics': ?pics,
          "attach_card": attachCard,
          "upload_id": uploadId,
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
        "dyn_id_str": dynId.toString(),
        if (repostDynId != null)
          "web_repost_src": {"dyn_id_str": repostDynId.toString()},
      },
      options: Options(contentType: Headers.jsonContentType),
    );
    if (res.data['code'] == 0) {
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<BubbleData>> bubble({
    required Object tribeId,
    Object? categoryId,
    int? sortType,
    required int page,
  }) async {
    final res = await Request().get(
      Api.bubble,
      queryParameters: {
        'tribee_id': tribeId,
        'category_id': ?categoryId,
        'sort_type': ?sortType,
        'page_size': 20,
        'page_num': page,
        'web_location': 333.40165,
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.40165"}',
      },
    );
    if (res.data['code'] == 0) {
      return Success(BubbleData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<DynReactionData>> dynReaction({
    required Object id,
    String? offset,
  }) async {
    final res = await Request().get(
      Api.dynReaction,
      queryParameters: {
        'id': id,
        'offset': ?offset,
        'web_location': 333.1369,
      },
    );
    if (res.data['code'] == 0) {
      return Success(DynReactionData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }
}
