import 'dart:convert';
import 'dart:developer';
import 'package:PiliPlus/grpc/app/card/v1/card.pb.dart' as card;
import 'package:PiliPlus/grpc/grpc_repo.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../common/constants.dart';
import '../models/common/reply_type.dart';
import '../models/home/rcmd/result.dart';
import '../models/model_hot_video_item.dart';
import '../models/model_rec_video_item.dart';
import '../models/user/fav_folder.dart';
import '../models/video/ai.dart';
import '../models/video/play/url.dart';
import '../models/video_detail_res.dart';
import '../utils/id_utils.dart';
import '../utils/recommend_filter.dart';
import '../utils/storage.dart';
import '../utils/wbi_sign.dart';
import 'api.dart';
import 'init.dart';
import 'login.dart';

/// res.data['code'] == 0 请求正常返回结果
/// res.data['data'] 为结果
/// 返回{'status': bool, 'data': List}
/// view层根据 status 判断渲染逻辑
class VideoHttp {
  static bool enableRcmdDynamic =
      GStorage.setting.get(SettingBoxKey.enableRcmdDynamic, defaultValue: true);
  static RegExp zoneRegExp =
      RegExp(GStorage.banWordForZone, caseSensitive: false);

  // 首页推荐视频
  static Future<LoadingState> rcmdVideoList(
      {required int ps, required int freshIdx}) async {
    var res = await Request().get(
      Api.recommendListWeb,
      queryParameters: {
        'version': 1,
        'feed_version': 'V8',
        'homepage_ver': 1,
        'ps': ps,
        'fresh_idx': freshIdx,
        'brush': freshIdx,
        'fresh_type': 4
      },
    );
    if (res.data['code'] == 0) {
      List<RecVideoItemModel> list = [];
      Set<int> blackMids = GStorage.blackMids;
      for (var i in res.data['data']['item']) {
        //过滤掉live与ad，以及拉黑用户
        if (i['goto'] == 'av' &&
            (i['owner'] != null && !blackMids.contains(i['owner']['mid']))) {
          RecVideoItemModel videoItem = RecVideoItemModel.fromJson(i);
          if (!RecommendFilter.filter(videoItem)) {
            list.add(videoItem);
          }
        }
      }
      return LoadingState.success(list);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  // 添加额外的loginState变量模拟未登录状态
  static Future<LoadingState> rcmdVideoListApp({required int freshIdx}) async {
    Map<String, String> data = {
      'build': '1462100',
      'c_locale': 'zh_CN',
      'channel': 'yingyongbao',
      'column': '4',
      'device': 'pad',
      'device_name': 'vivo',
      'device_type': '0',
      'disable_rcmd': '0',
      'flush': '5',
      'fnval': '976',
      'fnver': '0',
      'force_host': '2', //使用https
      'fourk': '1',
      'guidance': '0',
      'https_url_req': '0',
      'idx': freshIdx.toString(),
      'mobi_app': 'android_hd',
      'network': 'wifi',
      'platform': 'android',
      'player_net': '1',
      'pull': freshIdx == 0 ? 'true' : 'false',
      'qn': '32',
      'recsys_mode': '0',
      's_locale': 'zh_CN',
      'splash_id': '',
      'statistics': Constants.statistics,
      'voice_balance': '0'
    };
    var res = await Request().get(
      Api.recommendListApp,
      queryParameters: data,
      options: Options(headers: {
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
      }),
    );
    if (res.data['code'] == 0) {
      List<RecVideoItemAppModel> list = [];
      Set<int> blackMids = GStorage.blackMids;
      for (var i in res.data['data']['items']) {
        // 屏蔽推广和拉黑用户
        if (i['card_goto'] != 'ad_av' &&
            i['card_goto'] != 'ad_web_s' &&
            i['ad_info'] == null &&
            (!enableRcmdDynamic ? i['card_goto'] != 'picture' : true) &&
            (i['args'] != null && !blackMids.contains(i['args']['up_id']))) {
          // if (zoneRegExp.pattern.isNotEmpty &&
          //     i['args']?['rname'] != null &&
          //     zoneRegExp.hasMatch(i['args']['rname'])) {
          //   continue;
          // }
          RecVideoItemAppModel videoItem = RecVideoItemAppModel.fromJson(i);
          if (!RecommendFilter.filter(videoItem)) {
            list.add(videoItem);
          }
        }
      }
      return LoadingState.success(list);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  // 最热视频
  static Future<LoadingState> hotVideoList(
      {required int pn, required int ps}) async {
    var res = await Request().get(
      Api.hotList,
      queryParameters: {'pn': pn, 'ps': ps},
    );
    if (res.data['code'] == 0) {
      List<HotVideoItemModel> list = [];
      Set<int> blackMids = GStorage.blackMids;
      for (var i in res.data['data']['list']) {
        if (!blackMids.contains(i['owner']['mid']) &&
            !RecommendFilter.filterTitle(i['title']) &&
            !RecommendFilter.filterLikeRatio(
                i['stat']['like'], i['stat']['view'])) {
          if (zoneRegExp.pattern.isNotEmpty &&
              i['tname'] != null &&
              zoneRegExp.hasMatch(i['tname'])) {
            continue;
          }
          list.add(HotVideoItemModel.fromJson(i));
        }
      }
      return LoadingState.success(list);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> hotVideoListGrpc({required int idx}) async {
    dynamic res = await GrpcRepo.popular(idx);
    if (res['status']) {
      List<card.Card> list = [];
      Set<int> blackMids = GStorage.blackMids;
      for (card.Card item in res['data']) {
        if (!blackMids.contains(item.smallCoverV5.up.id.toInt())) {
          list.add(item);
        }
      }
      return LoadingState.success(list);
    } else {
      return LoadingState.error(res['msg']);
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
    bool? forcePgcApi,
  }) async {
    Map<String, dynamic> data = {
      if (avid != null) 'avid': avid,
      if (bvid != null) 'bvid': bvid,
      if (epid != null) 'ep_id': epid,
      if (seasonId != null) 'season_id': seasonId,
      'cid': cid,
      'qn': qn ?? 80,
      // 获取所有格式的视频
      'fnval': 4048,
      'fourk': 1,
      'voice_balance': 1,
      'gaia_source': 'pre-load',
      'web_location': 1550101,
    };

    // 免登录查看1080p
    if (!Accounts.get(AccountType.video).isLogin &&
        GStorage.setting.get(SettingBoxKey.p1080, defaultValue: true)) {
      data['try_look'] = 1;
    }

    Map params = await WbiSign.makSign(data);

    late final usePgcApi =
        forcePgcApi == true || Accounts.get(AccountType.video).isLogin;

    try {
      var res = await Request().get(
        epid != null && usePgcApi ? Api.bangumiVideoUrl : Api.videoUrl,
        queryParameters: params,
      );

      if (res.data['code'] == 0) {
        late PlayUrlModel data;
        if (epid != null && usePgcApi) {
          data = PlayUrlModel.fromJson(res.data['result']['video_info'])
            ..lastPlayTime = res.data['result']['play_view_business_info']
                ['user_status']['watch_progress']['current_watch_progress'];
        } else {
          data = PlayUrlModel.fromJson(res.data['data']);
        }
        return {
          'status': true,
          'data': data,
        };
      } else {
        if (epid != null && usePgcApi.not && forcePgcApi != true) {
          return videoUrl(
            avid: avid,
            bvid: bvid,
            cid: cid,
            qn: qn,
            epid: epid,
            seasonId: seasonId,
            forcePgcApi: true,
          );
        }
        return {
          'status': false,
          'data': [],
          'code': res.data['code'],
          'msg': res.data['message'],
        };
      }
    } catch (err) {
      return {'status': false, 'data': [], 'msg': err};
    }
  }

  // 视频信息 标题、简介
  static Future videoIntro({required String bvid}) async {
    var res =
        await Request().get(Api.videoIntro, queryParameters: {'bvid': bvid});
    VideoDetailResponse result = VideoDetailResponse.fromJson(res.data);
    if (result.code == 0) {
      return {
        'status': true,
        'data': result.data!,
      };
    } else {
      // Map errMap = {
      //   -400: '请求错误',
      //   -403: '权限不足',
      //   -404: '视频资源失效',
      //   62002: '稿件不可见',
      //   62004: '稿件审核中',
      // };
      return {
        'status': false,
        'data': result.data,
        'code': result.code,
        'msg': result.message,
        // 'msg': errMap[result.code] ?? '请求异常',
      };
    }
  }

  static Future seasonFav({
    required bool isFav,
    required dynamic seasonId,
  }) async {
    var res = await Request().post(
      Api.seasonFav + (isFav ? 'unfav' : 'fav'),
      data: {
        'platform': 'web',
        'season_id': seasonId,
        'csrf': Accounts.main.csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
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
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  // 相关视频
  static Future<LoadingState> relatedVideoList({required String bvid}) async {
    var res =
        await Request().get(Api.relatedList, queryParameters: {'bvid': bvid});
    if (res.data['code'] == 0) {
      final items =
          (res.data['data'] as List).map((i) => HotVideoItemModel.fromJson(i));
      final list = RecommendFilter.applyFilterToRelatedVideos
          ? items.where((i) => !RecommendFilter.filterAll(i)).toList()
          : items.toList();
      return LoadingState.success(list);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  // 获取点赞/投币/收藏状态 bangumi
  static Future bangumiLikeCoinFav({dynamic epId}) async {
    var res = await Request().get(
      Api.bangumiLikeCoinFav,
      queryParameters: {'ep_id': epId},
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 获取点赞状态
  // static Future hasLikeVideo({required String bvid}) async {
  //   var res =
  //       await Request().get(Api.hasLikeVideo, queryParameters: {'bvid': bvid});
  //   if (res.data['code'] == 0) {
  //     return {'status': true, 'data': res.data['data']};
  //   } else {
  //     return {'status': false, 'data': []};
  //   }
  // }

  // 获取投币状态
  // static Future hasCoinVideo({required String bvid}) async {
  //   var res =
  //       await Request().get(Api.hasCoinVideo, queryParameters: {'bvid': bvid});
  //   if (res.data['code'] == 0) {
  //     return {'status': true, 'data': res.data['data']};
  //   } else {
  //     return {'status': false, 'data': []};
  //   }
  // }

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
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  // 获取收藏状态
  // static Future hasFavVideo({required int aid}) async {
  //   var res =
  //       await Request().get(Api.hasFavVideo, queryParameters: {'aid': aid});
  //   if (res.data['code'] == 0) {
  //     return {'status': true, 'data': res.data['data']};
  //   } else {
  //     return {'status': false, 'data': []};
  //   }
  // }

  // 一键三连 bangumi
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
          'user-agent': Request.headerUa(type: 'pc'),
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
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
          'user-agent': Request.headerUa(type: 'pc'),
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
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
      // queryParameters: {
      //   'bvid': bvid,
      //   'like': type ? 1 : 2,
      //   'csrf': Accounts.main.csrf,
      // },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
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
        'msg': res.data is String ? res.data : res.data['message']
      };
    }
  }

  // 推送不感兴趣反馈
  static Future feedDislike(
      {required String goto,
      required int id,
      int? reasonId,
      int? feedbackId}) async {
    if (Accounts.get(AccountType.recommend).accessKey.isNullOrEmpty) {
      return {'status': false, 'msg': "请退出账号后重新登录"};
    }
    assert((reasonId != null) ^ (feedbackId != null));
    var res = await Request().get(Api.feedDislike, queryParameters: {
      'goto': goto,
      'id': id,
      // 'mid': mid,
      if (reasonId != null) 'reason_id': reasonId,
      if (feedbackId != null) 'feedback_id': feedbackId,
      'build': '1',
      'mobi_app': 'android',
    });
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 推送不感兴趣取消
  static Future feedDislikeCancel(
      {required String goto,
      required int id,
      int? reasonId,
      int? feedbackId}) async {
    if (Accounts.get(AccountType.recommend).accessKey.isNullOrEmpty) {
      return {'status': false, 'msg': "请退出账号后重新登录"};
    }
    // assert ((reasonId != null) ^ (feedbackId != null));
    var res = await Request().get(Api.feedDislikeCancel, queryParameters: {
      'goto': goto,
      'id': id,
      // 'mid': mid,
      if (reasonId != null) 'reason_id': reasonId,
      if (feedbackId != null) 'feedback_id': feedbackId,
      'build': '1',
      'mobi_app': 'android',
    });
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // （取消）收藏
  static Future delFav({
    List? ids,
    String? delIds,
  }) async {
    var res = await Request().post(
      Api.delFav,
      data: {
        'resources': ids?.join(','),
        'media_id': delIds,
        'platform': 'web',
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // （取消）收藏
  static Future favVideo({
    int? aid,
    String? addIds,
    String? delIds,
    int? type,
  }) async {
    var res = await Request().post(
      Api.favVideo,
      data: {
        'rid': aid,
        'type': type ?? 2,
        'add_media_ids': addIds ?? '',
        'del_media_ids': delIds ?? '',
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // （取消）收藏 bangumi
  // static Future favBangumi({
  //   required dynamic epId,
  //   String? addIds,
  //   String? delIds,
  // }) async {
  //   var res = await Request().post(
  //     Api.favBangumi,
  //     data: {
  //       'resources': '$epId:24',
  //       'add_media_ids': addIds ?? '',
  //       'del_media_ids': delIds ?? '',
  //       'csrf': Accounts.main.csrf,
  //     },
  //     options: Options(
  //       headers: {
  //         'Content-Type': Headers.formUrlEncodedContentType,
  //       },
  //     ),
  //   );
  //   if (res.data['code'] == 0) {
  //     return {'status': true, 'data': res.data['data']};
  //   } else {
  //     return {'status': false, 'msg': res.data['message']};
  //   }
  // }

  static Future copyOrMoveFav({
    required bool isCopy,
    required bool isFav,
    required dynamic srcMediaId,
    required dynamic tarMediaId,
    dynamic mid,
    required List resources,
  }) async {
    var res = await Request().post(
      isFav
          ? isCopy
              ? Api.copyFav
              : Api.moveFav
          : isCopy
              ? Api.copyToview
              : Api.moveToview,
      data: {
        if (srcMediaId != null) 'src_media_id': srcMediaId,
        'tar_media_id': tarMediaId,
        if (mid != null) 'mid': mid,
        'resources': resources.join(','),
        'platform': 'web',
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

  static Future allFavFolders(mid) async {
    var res = await Request().get(
      Api.favFolder,
      queryParameters: {'up_mid': mid},
    );
    if (res.data['code'] == 0) {
      FavFolderData data = FavFolderData.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 查看视频被收藏在哪个文件夹
  static Future videoInFolder({
    dynamic mid,
    dynamic rid,
    dynamic type,
  }) async {
    var res = await Request().get(
      Api.favFolder,
      queryParameters: {
        'up_mid': mid,
        'rid': rid,
        if (type != null) 'type': type,
      },
    );
    if (res.data['code'] == 0) {
      FavFolderData data = FavFolderData.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': []};
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
    required ReplyType type,
    required int oid,
    required String message,
    int? root,
    int? parent,
    List? pictures,
    bool? syncToDynamic,
  }) async {
    if (message == '') {
      return {'status': false, 'data': [], 'msg': '请输入评论内容'};
    }
    Map<String, dynamic> data = {
      'type': type.index,
      'oid': oid,
      if (root != null && root != 0) 'root': root,
      if (parent != null && parent != 0) 'parent': parent,
      'message': message,
      if (pictures != null) 'pictures': jsonEncode(pictures),
      if (syncToDynamic == true) 'sync_to_dynamic': 1,
      'csrf': Accounts.main.csrf,
    };
    var res = await Request().post(
      Api.replyAdd,
      data: FormData.fromMap(data),
    );
    log(res.toString());
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  static Future replyDel({
    required int type, //replyType
    required int oid,
    required int rpid,
  }) async {
    var res = await Request().post(Api.replyDel, queryParameters: {
      'type': type, //type.index
      'oid': oid,
      'rpid': rpid,
      'csrf': Accounts.main.csrf,
    });
    log(res.toString());
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 操作用户关系
  static Future relationMod(
      {required int mid, required int act, required int reSrc}) async {
    var res = await Request().post(
      Api.relationMod,
      data: {
        'fid': mid,
        'act': act,
        're_src': reSrc,
        'gaia_source': 'web_main',
        'spmid': '333.999.0.0',
        'extend_content': {
          "entity": "user",
          "entity_id": mid,
          'fp': Request.headerUa(type: 'pc'),
        },
        'csrf': Accounts.main.csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'origin': 'https://space.bilibili.com',
          'referer': 'https://space.bilibili.com/$mid/dynamic',
          'user-agent': Request.headerUa(type: 'pc'),
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
        'csrf': await Request.getCsrf(),
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
    await Request().post(Api.historyReport, queryParameters: {
      if (aid != null) 'aid': aid,
      if (type != null) 'type': type,
      'csrf': Accounts.main.csrf,
    });
  }

  // 视频播放进度
  static Future heartBeat({
    bvid,
    cid,
    progress,
    epid,
    seasonId,
    subType,
  }) async {
    await Request().post(Api.heartBeat, queryParameters: {
      // 'aid': aid,
      'bvid': bvid,
      'cid': cid,
      if (epid != null) 'epid': epid,
      if (seasonId != null) 'sid': seasonId,
      if (epid != null) 'type': 4,
      if (subType != null) 'sub_type': subType,
      'played_time': progress,
      'csrf': Accounts.main.csrf,
    });
  }

  static Future medialistHistory({
    required int desc,
    required dynamic oid,
    required dynamic upperMid,
  }) async {
    await Request().post(Api.mediaListHistory, queryParameters: {
      'desc': desc,
      'oid': oid,
      'upper_mid': upperMid,
      'csrf': Accounts.main.csrf,
    });
  }

  // 添加追番
  static Future bangumiAdd({int? seasonId}) async {
    var res = await Request().post(Api.bangumiAdd, queryParameters: {
      'season_id': seasonId,
      'csrf': Accounts.main.csrf,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'msg':
            res.data['result'] == null ? 'failed' : res.data['result']['toast']
      };
    } else {
      return {
        'status': false,
        'msg':
            res.data['result'] == null ? 'failed' : res.data['result']['toast']
      };
    }
  }

  // 取消追番
  static Future bangumiDel({int? seasonId}) async {
    var res = await Request().post(Api.bangumiDel, queryParameters: {
      'season_id': seasonId,
      'csrf': Accounts.main.csrf,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'msg':
            res.data['result'] == null ? 'failed' : res.data['result']['toast']
      };
    } else {
      return {
        'status': false,
        'msg':
            res.data['result'] == null ? 'failed' : res.data['result']['toast']
      };
    }
  }

  static Future bangumiUpdate({
    required List seasonId,
    required dynamic status,
  }) async {
    var res = await Request().post(
      Api.bangumiUpdate,
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
      'msg': res.data['result'] == null ? 'failed' : res.data['result']['toast']
    };
  }

  // 查看视频同时在看人数
  static Future onlineTotal({int? aid, String? bvid, int? cid}) async {
    var res = await Request().get(Api.onlineTotal, queryParameters: {
      'aid': aid,
      'bvid': bvid,
      'cid': cid,
    });
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
    Map params = await WbiSign.makSign({
      'bvid': bvid,
      'cid': cid,
      'up_mid': upMid,
    });
    var res = await Request().get(Api.aiConclusion, queryParameters: params);
    if (res.data['code'] == 0 && res.data['data']['code'] == 0) {
      return {
        'status': true,
        'data': AiConclusionModel.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'data': []};
    }
  }

  static Future<Map<String, dynamic>> subtitlesJson(
      {String? aid, String? bvid, required int cid}) async {
    assert(aid != null || bvid != null);
    var res = await Request().get(
      Api.subtitleUrl,
      queryParameters: {
        if (aid != null) 'aid': aid,
        if (bvid != null) 'bvid': bvid,
        'cid': cid,
      },
    );
    if (res.data['code'] == 0) {
      dynamic data = res.data['data'];
      /*
      [
        {
          "id": 1430455228267894300,
          "lan": "ai-zh",
          "lan_doc": "中文（自动生成）",
          "is_lock": false,
          "subtitle_url": "//aisubtitle.hdslb.com/bfs/ai_subtitle/prod/15508958271448462983dacf99a49f40ccdf91a4df8d925e2b58?auth_key=1708941835-aaa0e44844594386ad356795733983a2-0-89af73c6aad5a1fca43b02113fa9d485",
          "type": 1,
          "id_str": "1430455228267894272",
          "ai_type": 0,
          "ai_status": 2
        }
      ]
       */
      return {
        'status': true,
        'subtitles': data['subtitle']['subtitles'],
        'view_points': data['view_points'],
        // 'last_play_time': data['last_play_time'],
        'last_play_cid': data['last_play_cid'],
        'interaction': data['interaction'],
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future vttSubtitles(Map<String, dynamic> subtile) async {
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
      final sb = StringBuffer('WEBVTT\n\n');
      sb.writeAll(
          list.map((item) =>
              '${item?['sid'] ?? 0}\n${subtitleTimecode(item['from'])} --> ${subtitleTimecode(item['to'])}\n${item['content'].trim()}'),
          '\n\n');
      return sb.toString();
    }

    var res = await Request().get("https:${subtile['subtitle_url']}");

    if (res.data?['body'] is List) {
      return await compute(processList, res.data['body'] as List);
    }
    return null;
  }

  // 视频排行
  static Future<LoadingState> getRankVideoList(int rid) async {
    var rankApi = "${Api.getRankApi}?rid=$rid&type=all";
    var res = await Request().get(rankApi);
    if (res.data['code'] == 0) {
      List<HotVideoItemModel> list = [];
      Set<int> blackMids = GStorage.blackMids;
      for (var i in res.data['data']['list']) {
        if (!blackMids.contains(i['owner']['mid']) &&
            !RecommendFilter.filterTitle(i['title']) &&
            !RecommendFilter.filterLikeRatio(
                i['stat']['like'], i['stat']['view'])) {
          if (zoneRegExp.pattern.isNotEmpty &&
              i['tname'] != null &&
              zoneRegExp.hasMatch(i['tname'])) {
            continue;
          }
          list.add(HotVideoItemModel.fromJson(i));
        }
      }
      return LoadingState.success(list);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> getVideoNoteList({
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
        if (uperMid != null) 'uper_mid': uperMid,
      },
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(res.data['data']);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> noteList({
    required int page,
  }) async {
    var res = await Request().get(
      Api.noteList,
      queryParameters: {
        'pn': page,
        'ps': 10,
        'csrf': Accounts.main.csrf,
      },
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(res.data['data']?['list']);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> userNoteList({
    required int page,
  }) async {
    var res = await Request().get(
      Api.userNoteList,
      queryParameters: {
        'pn': page,
        'ps': 10,
        'csrf': Accounts.main.csrf,
      },
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(res.data['data']?['list']);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> addNote({
    required oid,
    required String title,
    required String summary,
  }) async {
    String noteId = '';
    try {
      final res = await Request().get(Api.archiveNote, queryParameters: {
        'oid': oid,
        'oid_type': 0,
        'csrf': Accounts.main.csrf,
      });
      if (res.data['code'] == 0) {
        if (res.data['data']['noteIds'] != null) {
          noteId = res.data['data']['noteIds'].first;
        }
      }
    } catch (_) {}

    final res = await Request().post(
      Api.addNote,
      data: {
        'cont_len': summary.length,
        'note_id': noteId,
        'oid': oid,
        'oid_type': 0,
        'platform': 'web',
        'title': title,
        'summary': summary,
        'content': jsonEncode([
          {"insert": summary},
        ]),
        'from': 'close',
        'hash': DateTime.now().millisecondsSinceEpoch,
        'tags': '',
        'csrf': Accounts.main.csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(res.data['data']?['list']);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future delNote({
    required bool isPublish,
    required List noteIds,
  }) async {
    final res = await Request().post(
      isPublish ? Api.delPublishNote : Api.delNote,
      data: {
        isPublish ? 'cvids' : 'note_ids': noteIds.join(','),
        'csrf': Accounts.main.csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }
}
