import 'dart:convert';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/login.dart';
import 'package:PiliPlus/http/ua_type.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/home/rcmd/result.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/models/model_rec_video_item.dart';
import 'package:PiliPlus/models/pgc_lcf.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/pgc/pgc_rank/pgc_rank_item_model.dart';
import 'package:PiliPlus/models_new/triple/pgc_triple.dart';
import 'package:PiliPlus/models_new/triple/ugc_triple.dart';
import 'package:PiliPlus/models_new/video/video_ai_conclusion/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/video_detail_response.dart';
import 'package:PiliPlus/models_new/video/video_note_list/data.dart';
import 'package:PiliPlus/models_new/video/video_play_info/data.dart';
import 'package:PiliPlus/models_new/video/video_relation/data.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// view层根据 status 判断渲染逻辑
class VideoHttp {
  // static bool enableRcmdDynamic = Pref.enableRcmdDynamic;
  static RegExp zoneRegExp = RegExp(Pref.banWordForZone, caseSensitive: false);
  static bool enableFilter = zoneRegExp.pattern.isNotEmpty;

  // 首页推荐视频
  static Future<LoadingState> rcmdVideoList({
    required int ps,
    required int freshIdx,
  }) async {
    var res = await Request().get(
      Api.recommendListWeb,
      queryParameters: {
        'version': 1,
        'feed_version': 'V8',
        'homepage_ver': 1,
        'ps': ps,
        'fresh_idx': freshIdx,
        'brush': freshIdx,
        'fresh_type': 4,
      },
    );
    if (res.data['code'] == 0) {
      List<RecVideoItemModel> list = <RecVideoItemModel>[];
      for (var i in res.data['data']['item']) {
        //过滤掉live与ad，以及拉黑用户
        if (i['goto'] == 'av' &&
            (i['owner'] != null &&
                !GlobalData().blackMids.contains(i['owner']['mid']))) {
          RecVideoItemModel videoItem = RecVideoItemModel.fromJson(i);
          if (!RecommendFilter.filter(videoItem)) {
            list.add(videoItem);
          }
        }
      }
      return Success(list);
    } else {
      return Error(res.data['message']);
    }
  }

  // 添加额外的loginState变量模拟未登录状态
  static Future<LoadingState> rcmdVideoListApp({required int freshIdx}) async {
    final params = {
      'build': 2001100,
      'c_locale': 'zh_CN',
      'channel': 'master',
      'column': 4,
      'device': 'pad',
      'device_name': 'android',
      'device_type': 0,
      'disable_rcmd': 0,
      'flush': 5,
      'fnval': 976,
      'fnver': 0,
      'force_host': 2, //使用https
      'fourk': 1,
      'guidance': 0,
      'https_url_req': 0,
      'idx': freshIdx,
      'mobi_app': 'android_hd',
      'network': 'wifi',
      'platform': 'android',
      'player_net': 1,
      'pull': freshIdx == 0 ? 'true' : 'false',
      'qn': 32,
      'recsys_mode': 0,
      's_locale': 'zh_CN',
      'splash_id': '',
      'statistics': Constants.statistics,
      'voice_balance': 0,
    };
    var res = await Request().get(
      Api.recommendListApp,
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
          'app-key': 'android_hd',
          'User-Agent': Constants.userAgent,
          'x-bili-trace-id': Constants.traceId,
          'x-bili-aurora-eid': '',
          'x-bili-aurora-zone': '',
          'bili-http-engine': 'cronet',
        },
      ),
    );
    if (res.data['code'] == 0) {
      List<RecVideoItemAppModel> list = <RecVideoItemAppModel>[];
      for (var i in res.data['data']['items']) {
        // 屏蔽推广和拉黑用户
        if (i['card_goto'] != 'ad_av' &&
            i['card_goto'] != 'ad_web_s' &&
            i['ad_info'] == null &&
            // (!enableRcmdDynamic ? i['card_goto'] != 'picture' : true) &&
            (i['args'] != null &&
                !GlobalData().blackMids.contains(i['args']['up_id']))) {
          if (enableFilter &&
              i['args']?['tname'] != null &&
              zoneRegExp.hasMatch(i['args']['tname'])) {
            continue;
          }
          RecVideoItemAppModel videoItem = RecVideoItemAppModel.fromJson(i);
          if (!RecommendFilter.filter(videoItem)) {
            list.add(videoItem);
          }
        }
      }
      return Success(list);
    } else {
      return Error(res.data['message']);
    }
  }

  // 最热视频
  static Future<LoadingState<List<HotVideoItemModel>>> hotVideoList({
    required int pn,
    required int ps,
  }) async {
    var res = await Request().get(
      Api.hotList,
      queryParameters: {'pn': pn, 'ps': ps},
    );
    if (res.data['code'] == 0) {
      List<HotVideoItemModel> list = <HotVideoItemModel>[];
      for (var i in res.data['data']['list']) {
        if (!GlobalData().blackMids.contains(i['owner']['mid']) &&
            !RecommendFilter.filterTitle(i['title']) &&
            !RecommendFilter.filterLikeRatio(
              i['stat']['like'],
              i['stat']['view'],
            )) {
          if (enableFilter &&
              i['tname'] != null &&
              zoneRegExp.hasMatch(i['tname'])) {
            continue;
          }
          list.add(HotVideoItemModel.fromJson(i));
        }
      }
      return Success(list);
    } else {
      return Error(res.data['message']);
    }
  }

  // 视频流
  static Future videoUrl({
    int? avid,
    String? bvid,
    required int cid,
    int? qn,
    dynamic epid,
    dynamic seasonId,
    required bool tryLook,
    required VideoType videoType,
  }) async {
    final params = await WbiSign.makSign({
      'avid': ?avid,
      'bvid': ?bvid,
      'ep_id': ?epid,
      'season_id': ?seasonId,
      'cid': cid,
      'qn': qn ?? 80,
      // 获取所有格式的视频
      'fnval': 4048,
      'fourk': 1,
      'fnver': 0,
      'voice_balance': 1,
      'gaia_source': 'pre-load',
      'isGaiaAvoided': true,
      'web_location': 1315873,
      // 免登录查看1080p
      if (tryLook) 'try_look': 1,
    });

    try {
      var res = await Request().get(
        videoType.api,
        queryParameters: params,
      );

      if (res.data['code'] == 0) {
        late PlayUrlModel data;
        switch (videoType) {
          case VideoType.ugc:
            data = PlayUrlModel.fromJson(res.data['data']);
          case VideoType.pugv:
            var result = res.data['data'];
            data = PlayUrlModel.fromJson(result)
              ..lastPlayTime =
                  result?['play_view_business_info']?['user_status']?['watch_progress']?['current_watch_progress'];
          case VideoType.pgc:
            var result = res.data['result'];
            data = PlayUrlModel.fromJson(result['video_info'])
              ..lastPlayTime =
                  result?['play_view_business_info']?['user_status']?['watch_progress']?['current_watch_progress'];
        }
        return {'status': true, 'data': data};
      } else {
        if (epid != null && videoType == VideoType.ugc) {
          return videoUrl(
            avid: avid,
            bvid: bvid,
            cid: cid,
            qn: qn,
            epid: epid,
            seasonId: seasonId,
            tryLook: tryLook,
            videoType: VideoType.pgc,
          );
        }
        return {
          'status': false,
          'code': res.data['code'],
          'msg': res.data['message'],
        };
      }
    } catch (err) {
      return {'status': false, 'msg': err.toString()};
    }
  }

  // 视频信息 标题、简介
  static Future<LoadingState<VideoDetailData>> videoIntro({
    required String bvid,
  }) async {
    var res = await Request().get(
      Api.videoIntro,
      queryParameters: {'bvid': bvid},
    );
    VideoDetailResponse data = VideoDetailResponse.fromJson(res.data);
    if (data.code == 0) {
      return Success(data.data!);
    } else {
      return Error(data.message);
    }
  }

  static Future videoRelation({required dynamic bvid}) async {
    var res = await Request().get(
      Api.videoRelation,
      queryParameters: {
        'aid': IdUtils.bv2av(bvid),
        'bvid': bvid,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': VideoRelation.fromJson(res.data['data']),
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  // 相关视频
  static Future<LoadingState<List<HotVideoItemModel>?>> relatedVideoList({
    required String bvid,
  }) async {
    var res = await Request().get(
      Api.relatedList,
      queryParameters: {'bvid': bvid},
    );
    if (res.data['code'] == 0) {
      final items = (res.data['data'] as List?)?.map(
        (i) => HotVideoItemModel.fromJson(i),
      );
      final list = RecommendFilter.applyFilterToRelatedVideos
          ? items?.where((i) => !RecommendFilter.filterAll(i)).toList()
          : items?.toList();
      return Success(list);
    } else {
      return Error(res.data['message']);
    }
  }

  // 获取点赞/投币/收藏状态 pgc
  static Future pgcLikeCoinFav({dynamic epId}) async {
    var res = await Request().get(
      Api.pgcLikeCoinFav,
      queryParameters: {'ep_id': epId},
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': PgcLCF.fromJson(res.data['data'])};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 投币
  static Future coinVideo({
    required String bvid,
    required int multiply,
    int selectLike = 0,
  }) async {
    var res = await Request().post(
      Api.coinVideo,
      data: {
        'aid': IdUtils.bv2av(bvid).toString(),
        // 'bvid': bvid,
        'multiply': multiply.toString(),
        'select_like': selectLike.toString(),
        // 'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 一键三连 pgc
  static Future triple({dynamic epId, required dynamic seasonId}) async {
    var res = await Request().post(
      Api.triple,
      data: {
        'ep_id': epId,
        'csrf': Accounts.main.csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'origin': 'https://www.bilibili.com',
          'referer': 'https://www.bilibili.com/bangumi/play/ss$seasonId',
          'user-agent': UaType.pc.ua,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': PgcTriple.fromJson(res.data['data'])};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 一键三连
  static Future oneThree({required String bvid}) async {
    var res = await Request().post(
      Api.oneThree,
      data: {
        'aid': IdUtils.bv2av(bvid),
        'eab_x': 2,
        'ramval': 0,
        'source': 'web_normal',
        'ga': 1,
        'csrf': Accounts.main.csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'origin': 'https://www.bilibili.com',
          'referer': 'https://www.bilibili.com/video/$bvid',
          'user-agent': UaType.pc.ua,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': UgcTriple.fromJson(res.data['data'])};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // （取消）点赞
  static Future likeVideo({required String bvid, required bool type}) async {
    var res = await Request().post(
      Api.likeVideo,
      data: {
        'aid': IdUtils.bv2av(bvid).toString(),
        'like': type ? '0' : '1',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // （取消）点踩
  static Future dislikeVideo({required String bvid, required bool type}) async {
    if (Accounts.main.accessKey.isNullOrEmpty) {
      return {'status': false, 'msg': "请退出账号后重新登录"};
    }
    var res = await Request().post(
      Api.dislikeVideo,
      data: {
        'aid': IdUtils.bv2av(bvid).toString(),
        'dislike': type ? '0' : '1',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data is! String && res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {
        'status': false,
        'msg': res.data is String ? res.data : res.data['message'],
      };
    }
  }

  // 推送不感兴趣反馈
  static Future feedDislike({
    required String goto,
    required int id,
    int? reasonId,
    int? feedbackId,
  }) async {
    if (Accounts.get(AccountType.recommend).accessKey.isNullOrEmpty) {
      return {'status': false, 'msg': "请退出账号后重新登录"};
    }
    assert((reasonId != null) ^ (feedbackId != null));
    var res = await Request().get(
      Api.feedDislike,
      queryParameters: {
        'goto': goto,
        'id': id,
        'reason_id': ?reasonId,
        'feedback_id': ?feedbackId,
        'build': 1,
        'mobi_app': 'android',
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 推送不感兴趣取消
  static Future feedDislikeCancel({
    required String goto,
    required int id,
    int? reasonId,
    int? feedbackId,
  }) async {
    if (Accounts.get(AccountType.recommend).accessKey.isNullOrEmpty) {
      return {'status': false, 'msg': "请退出账号后重新登录"};
    }
    var res = await Request().get(
      Api.feedDislikeCancel,
      queryParameters: {
        'goto': goto,
        'id': id,
        'reason_id': ?reasonId,
        'feedback_id': ?feedbackId,
        'build': 1,
        'mobi_app': 'android',
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 发表评论 replyAdd

  // type	num	评论区类型代码	必要	类型代码见表
  // oid	num	目标评论区id	必要
  // root	num	根评论rpid	非必要	二级评论以上使用
  // parent	num	父评论rpid	非必要	二级评论同根评论id 大于二级评论为要回复的评论id
  // message	str	发送评论内容	必要	最大1000字符
  // plat	num	发送平台标识	非必要	1：web端 2：安卓客户端  3：ios客户端  4：wp客户端
  static Future replyAdd({
    required int type,
    required int oid,
    required String message,
    int? root,
    int? parent,
    List? pictures,
    bool? syncToDynamic,
    Map<String, int>? atNameToMid,
  }) async {
    if (message == '') {
      return {'status': false, 'msg': '请输入评论内容'};
    }
    Map<String, dynamic> data = {
      'type': type,
      'oid': oid,
      if (root != null && root != 0) 'root': root,
      if (parent != null && parent != 0) 'parent': parent,
      'message': message,
      if (atNameToMid?.isNotEmpty == true)
        'at_name_to_mid': jsonEncode(atNameToMid), // {"name":uid}
      if (pictures != null) 'pictures': jsonEncode(pictures),
      if (syncToDynamic == true) 'sync_to_dynamic': 1,
      'csrf': Accounts.main.csrf,
    };
    var res = await Request().post(
      Api.replyAdd,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future replyDel({
    required int type, //replyType
    required int oid,
    required int rpid,
  }) async {
    var res = await Request().post(
      Api.replyDel,
      queryParameters: {
        'type': type, //type.index
        'oid': oid,
        'rpid': rpid,
        'csrf': Accounts.main.csrf,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 操作用户关系
  static Future relationMod({
    required int mid,
    required int act,
    required int reSrc,
  }) async {
    var res = await Request().post(
      Api.relationMod,
      queryParameters: {
        'statistics': '{"appId":100,"platform":5}',
        'x-bili-device-req-json':
            '{"platform":"web","device":"pc","spmid":"333.1387"}',
      },
      data: {
        'fid': mid,
        'act': act,
        're_src': reSrc,
        'gaia_source': 'web_main',
        'spmid': '333.1387',
        'extend_content': jsonEncode({
          "entity": "user",
          "entity_id": mid,
          'fp': UaType.pc.ua,
        }),
        'csrf': Accounts.main.csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'origin': 'https://space.bilibili.com',
          'referer': 'https://space.bilibili.com/$mid/dynamic',
          'user-agent': UaType.pc.ua,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future roomEntryAction({
    roomId,
  }) async {
    await Request().post(
      Api.roomEntryAction,
      queryParameters: {
        'csrf': Accounts.heartbeat.csrf,
      },
      data: {
        'room_id': roomId,
        'platform': 'pc',
      },
    );
  }

  static Future historyReport({
    aid,
    type,
  }) async {
    await Request().post(
      Api.historyReport,
      queryParameters: {
        'aid': ?aid,
        'type': ?type,
        'csrf': Accounts.heartbeat.csrf,
      },
    );
  }

  // 视频播放进度
  static Future heartBeat({
    aid,
    bvid,
    cid,
    progress,
    epid,
    seasonId,
    subType,
    required VideoType videoType,
  }) async {
    final isPugv = videoType == VideoType.pugv;
    await Request().post(
      Api.heartBeat,
      queryParameters: {
        if (isPugv) 'aid': ?aid else 'bvid': ?bvid,
        'cid': cid,
        'epid': ?epid,
        'sid': ?seasonId,
        'type': videoType.type,
        'sub_type': ?subType,
        'played_time': progress,
        'csrf': Accounts.heartbeat.csrf,
      },
    );
  }

  static Future medialistHistory({
    required int desc,
    required dynamic oid,
    required dynamic upperMid,
  }) async {
    await Request().post(
      Api.mediaListHistory,
      queryParameters: {
        'desc': desc,
        'oid': oid,
        'upper_mid': upperMid,
        'csrf': Accounts.heartbeat.csrf,
      },
    );
  }

  // 添加追番
  static Future pgcAdd({int? seasonId}) async {
    var res = await Request().post(
      Api.pgcAdd,
      queryParameters: {
        'season_id': seasonId,
        'csrf': Accounts.main.csrf,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'msg': res.data['result'] == null
            ? 'failed'
            : res.data['result']['toast'],
      };
    } else {
      return {
        'status': false,
        'msg': res.data['result'] == null
            ? 'failed'
            : res.data['result']['toast'],
      };
    }
  }

  // 取消追番
  static Future pgcDel({int? seasonId}) async {
    var res = await Request().post(
      Api.pgcDel,
      queryParameters: {
        'season_id': seasonId,
        'csrf': Accounts.main.csrf,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'msg': res.data['result'] == null
            ? 'failed'
            : res.data['result']['toast'],
      };
    } else {
      return {
        'status': false,
        'msg': res.data['result'] == null
            ? 'failed'
            : res.data['result']['toast'],
      };
    }
  }

  static Future pgcUpdate({
    required List seasonId,
    required dynamic status,
  }) async {
    var res = await Request().post(
      Api.pgcUpdate,
      data: {
        'season_id': seasonId.join(','),
        'status': status,
        'csrf': Accounts.main.csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    return {
      'status': res.data['code'] == 0,
      'msg': res.data['result'] == null
          ? 'failed'
          : res.data['result']['toast'],
    };
  }

  // 查看视频同时在看人数
  static Future onlineTotal({int? aid, String? bvid, int? cid}) async {
    var res = await Request().get(
      Api.onlineTotal,
      queryParameters: {
        'aid': aid,
        'bvid': bvid,
        'cid': cid,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']['total']};
    } else {
      return {'status': false, 'data': null, 'msg': res.data['message']};
    }
  }

  static Future aiConclusion({
    String? bvid,
    int? cid,
    int? upMid,
  }) async {
    final params = await WbiSign.makSign({
      'bvid': bvid,
      'cid': cid,
      'up_mid': upMid,
    });
    var res = await Request().get(Api.aiConclusion, queryParameters: params);
    if (res.data['code'] == 0 && res.data['data']['code'] == 0) {
      return {
        'status': true,
        'data': AiConclusionData.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future playInfo({String? aid, String? bvid, required int cid}) async {
    assert(aid != null || bvid != null);
    var res = await Request().get(
      Api.playInfo,
      queryParameters: {
        'aid': ?aid,
        'bvid': ?bvid,
        'cid': cid,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': PlayInfoData.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<String?> vttSubtitles(String subtitleUrl) async {
    String subtitleTimecode(num seconds) {
      int h = seconds ~/ 3600;
      seconds %= 3600;
      int m = seconds ~/ 60;
      seconds %= 60;
      String sms = seconds.toStringAsFixed(3).padLeft(6, '0');
      return h == 0
          ? "${m.toString().padLeft(2, '0')}:$sms"
          : "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:$sms";
    }

    String processList(List list) {
      final sb = StringBuffer('WEBVTT\n\n')
        ..writeAll(
          list.map(
            (item) =>
                '${item?['sid'] ?? 0}\n${subtitleTimecode(item['from'])} --> ${subtitleTimecode(item['to'])}\n${item['content'].trim()}',
          ),
          '\n\n',
        );
      return sb.toString();
    }

    var res = await Request().get("https:$subtitleUrl");

    if (res.data?['body'] case List list) {
      return compute<List, String>(processList, list);
    }
    return null;
  }

  // 视频排行
  static Future<LoadingState<List<HotVideoItemModel>>> getRankVideoList(
    int rid,
  ) async {
    var res = await Request().get(
      Api.getRankApi,
      queryParameters: await WbiSign.makSign({
        'rid': rid,
        'type': 'all',
      }),
    );
    if (res.data['code'] == 0) {
      List<HotVideoItemModel> list = <HotVideoItemModel>[];
      for (var i in res.data['data']['list']) {
        if (!GlobalData().blackMids.contains(i['owner']['mid']) &&
            !RecommendFilter.filterTitle(i['title']) &&
            !RecommendFilter.filterLikeRatio(
              i['stat']['like'],
              i['stat']['view'],
            )) {
          if (enableFilter &&
              i['tname'] != null &&
              zoneRegExp.hasMatch(i['tname'])) {
            continue;
          }
          list.add(HotVideoItemModel.fromJson(i));
        }
      }
      return Success(list);
    } else {
      return Error(res.data['message']);
    }
  }

  // pgc 排行
  static Future<LoadingState> pgcRankList({
    int day = 3,
    required int seasonType,
  }) async {
    var res = await Request().get(
      Api.pgcRank,
      queryParameters: await WbiSign.makSign({
        'day': day,
        'season_type': seasonType,
      }),
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['result']?['list'] as List?)
            ?.map((e) => PgcRankItemModel.fromJson(e))
            .toList(),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  // pgc season 排行
  static Future<LoadingState> pgcSeasonRankList({
    int day = 3,
    required int seasonType,
  }) async {
    var res = await Request().get(
      Api.pgcSeasonRank,
      queryParameters: await WbiSign.makSign({
        'day': day,
        'season_type': seasonType,
      }),
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data']?['list'] as List?)
            ?.map((e) => PgcRankItemModel.fromJson(e))
            .toList(),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<VideoNoteData>> getVideoNoteList({
    dynamic oid,
    dynamic uperMid,
    required int page,
  }) async {
    var res = await Request().get(
      Api.archiveNoteList,
      queryParameters: {
        'csrf': Accounts.main.csrf,
        'oid': oid,
        'oid_type': 0,
        'pn': page,
        'ps': 10,
        'uper_mid': ?uperMid,
      },
    );
    if (res.data['code'] == 0) {
      return Success(VideoNoteData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }
}
