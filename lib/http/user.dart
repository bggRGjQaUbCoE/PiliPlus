import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/video/later.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../common/constants.dart';
import '../models/model_hot_video_item.dart';
import '../models/user/fav_detail.dart';
import '../models/user/fav_folder.dart';
import '../models/user/history.dart';
import '../models/user/info.dart';
import '../models/user/stat.dart';
import '../models/user/sub_detail.dart';
import '../models/user/sub_folder.dart';
import 'api.dart';
import 'init.dart';

class UserHttp {
  static Future<dynamic> userStat({required int mid}) async {
    var res = await Request().get(Api.userStat, queryParameters: {'vmid': mid});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false};
    }
  }

  static Future<dynamic> userInfo() async {
    var res = await Request().get(Api.userInfo);
    if (res.data['code'] == 0) {
      UserInfoData data = UserInfoData.fromJson(res.data['data']);
      GlobalData().coins = data.money;
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'msg': res.data['message']};
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

  // 收藏夹
  static Future<LoadingState<FavFolderData>> userfavFolder({
    required int pn,
    required int ps,
    required dynamic mid,
  }) async {
    var res = await Request().get(Api.userFavFolder, queryParameters: {
      'pn': pn,
      'ps': ps,
      'up_mid': mid,
    });
    if (res.data['code'] == 0) {
      return LoadingState.success(FavFolderData.fromJson(res.data['data']));
    } else {
      return LoadingState.error(res.data['message'] ?? '账号未登录');
    }
  }

  static Future sortFavFolder({
    required List<int?> sort,
  }) async {
    Map<String, dynamic> data = {
      'sort': sort.join(','),
      'csrf': Accounts.main.csrf,
    };
    Utils.appSign(data);
    var res = await Request().post(
      Api.sortFavFolder,
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future sortFav({
    required dynamic mediaId,
    required List<String> sort,
  }) async {
    Map<String, dynamic> data = {
      'media_id': mediaId,
      'sort': sort.join(','),
      'csrf': Accounts.main.csrf,
    };
    Utils.appSign(data);
    var res = await Request().post(
      Api.sortFav,
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future cleanFav({
    required dynamic mediaId,
  }) async {
    var res = await Request().post(
      Api.cleanFav,
      data: {
        'media_id': mediaId,
        'platform': 'web',
        'csrf': Accounts.main.csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future deleteFolder({
    required List<dynamic> mediaIds,
  }) async {
    var res = await Request().post(Api.deleteFolder,
        data: {
          'media_ids': mediaIds.join(','),
          'platform': 'web',
          'csrf': Accounts.main.csrf,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future addOrEditFolder({
    required bool isAdd,
    dynamic mediaId,
    required String title,
    required int privacy,
    required String cover,
    required String intro,
  }) async {
    var res = await Request().post(isAdd ? Api.addFolder : Api.editFolder,
        data: {
          'title': title,
          'intro': intro,
          'privacy': privacy,
          'cover': cover.isNotEmpty ? Uri.encodeFull(cover) : cover,
          'csrf': Accounts.main.csrf,
          if (mediaId != null) 'media_id': mediaId,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': FavFolderItemData.fromJson(res.data['data'])
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future folderInfo({
    dynamic mediaId,
  }) async {
    var res = await Request().get(Api.folderInfo, queryParameters: {
      'media_id': mediaId,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<FavDetailData>> userFavFolderDetail(
      {required int mediaId,
      required int pn,
      required int ps,
      String keyword = '',
      String order = 'mtime',
      int type = 0}) async {
    var res = await Request().get(Api.favResourceList, queryParameters: {
      'media_id': mediaId,
      'pn': pn,
      'ps': ps,
      'keyword': keyword,
      'order': order,
      'type': type,
      'tid': 0,
      'platform': 'web'
    });
    if (res.data['code'] == 0) {
      return LoadingState.success(FavDetailData.fromJson(res.data['data']));
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  // 稍后再看
  static Future<LoadingState<Map>> seeYouLater({
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
      if (res.data['data']['count'] == 0) {
        return LoadingState.success({'count': 0});
      }
      List<HotVideoItemModel> list = <HotVideoItemModel>[];
      if (res.data['data']?['list'] != null) {
        for (var i in res.data['data']['list']) {
          list.add(HotVideoItemModel.fromJson(i));
        }
      }
      return LoadingState.success({
        'list': list,
        'count': res.data['data']['count'],
      });
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  // 观看历史
  static Future<LoadingState<HistoryData>> historyList({
    required String type,
    int? max,
    int? viewAt,
  }) async {
    var res = await Request().get(Api.historyList, queryParameters: {
      'type': type,
      'ps': 20,
      'max': max ?? 0,
      'view_at': viewAt ?? 0,
    });
    if (res.data['code'] == 0) {
      return LoadingState.success(HistoryData.fromJson(res.data['data']));
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  // 暂停观看历史
  static Future pauseHistory(bool switchStatus) async {
    // 暂停switchStatus传true 否则false
    var res = await Request().post(
      Api.pauseHistory,
      queryParameters: {
        'switch': switchStatus,
        'jsonp': 'jsonp',
        'csrf': Accounts.main.csrf,
      },
    );
    return res;
  }

  // 观看历史暂停状态
  static Future historyStatus() async {
    var res = await Request().get(Api.historyStatus);
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 清空历史记录
  static Future clearHistory() async {
    var res = await Request().post(
      Api.clearHistory,
      queryParameters: {
        'jsonp': 'jsonp',
        'csrf': Accounts.main.csrf,
      },
    );
    return res;
  }

  // 稍后再看
  static Future toViewLater({String? bvid, dynamic aid}) async {
    var data = {'csrf': Accounts.main.csrf};
    if (bvid != null) {
      data['bvid'] = bvid;
    } else if (aid != null) {
      data['aid'] = aid;
    }
    var res = await Request().post(
      Api.toViewLater,
      queryParameters: data,
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': 'yeah！稍后再看'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 移除已观看
  static Future toViewDel({required List<int?> aids}) async {
    final Map<String, dynamic> params = {
      'csrf': Accounts.main.csrf,
      'resources': aids.join(',')
    };
    dynamic res = await Request().post(
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
      queryParameters: {
        if (cleanType != null) 'clean_type': cleanType,
        'csrf': Accounts.main.csrf,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': '操作完成'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 删除历史记录
  static Future delHistory(List<String> kidList) async {
    var res = await Request().post(
      Api.delHistory,
      data: {
        'kid': kidList.join(','),
        'jsonp': 'jsonp',
        'csrf': Accounts.main.csrf,
      },
      options: Options(
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
  static Future<LoadingState<HistoryData>> searchHistory(
      {required int pn, required String keyword}) async {
    var res = await Request().get(
      Api.searchHistory,
      queryParameters: {
        'pn': pn,
        'keyword': keyword,
        'business': 'all',
      },
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(HistoryData.fromJson(res.data['data']));
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  // 我的订阅
  static Future<LoadingState<List<SubFolderItemData>?>> userSubFolder({
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
      return LoadingState.success(
          SubFolderModelData.fromJson(res.data['data']).list);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState<SubDetailModelData>> favSeasonList({
    required int id,
    required int pn,
    required int ps,
  }) async {
    var res = await Request().get(
      Api.favSeasonList,
      queryParameters: {
        'season_id': id,
        'ps': ps,
        'pn': pn,
      },
    );
    if (res.data['code'] == 0) {
      return LoadingState.success(
          SubDetailModelData.fromJson(res.data['data']));
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> favArticle({
    required int page,
  }) async {
    var res = await Request().get(Api.favArticle, queryParameters: {
      'page_size': 20,
      'page': page,
    });
    if (res.data['code'] == 0) {
      return LoadingState.success(res.data['data']?['items']);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future addFavArticle({
    required dynamic id,
  }) async {
    var res = await Request().post(
      Api.addFavArticle,
      data: {
        'id': id,
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

  static Future delFavArticle({
    required dynamic id,
  }) async {
    var res = await Request().post(
      Api.delFavArticle,
      data: {
        'id': id,
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

  static Future communityAction({
    required dynamic opusId,
    required dynamic action,
  }) async {
    var res = await Request().post(
      Api.communityAction,
      queryParameters: {
        'csrf': Accounts.main.csrf,
      },
      data: {
        "entity": {
          "object_id_str": opusId,
          "type": {"biz": 2}
        },
        "action": action, // 3 fav, 4 unfav
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<SubDetailModelData>> favResourceList({
    required int id,
    required int pn,
    required int ps,
  }) async {
    var res = await Request().get(Api.favResourceList, queryParameters: {
      'media_id': id,
      'ps': ps,
      'pn': pn,
    });
    if (res.data['code'] == 0) {
      return LoadingState.success(
          SubDetailModelData.fromJson(res.data['data']));
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  // 取消订阅
  static Future cancelSub({required int id, required int type}) async {
    late dynamic res;
    if (type == 11) {
      res = await Request().post(
        Api.unfavFolder,
        queryParameters: {
          'media_id': id,
          'csrf': Accounts.main.csrf,
        },
      );
    } else {
      res = await Request().post(
        Api.unfavSeason,
        queryParameters: {
          'platform': 'web',
          'season_id': id,
          'csrf': Accounts.main.csrf,
        },
      );
    }
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static videoTags({required String bvid}) async {
    var res =
        await Request().get(Api.videoTags, queryParameters: {'bvid': bvid});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false};
    }
  }

  // 稍后再看列表
  static Future getMediaList({
    required dynamic type,
    required int bizId,
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
        if (oid != null) 'oid': oid,
        if (otype != null) 'otype': otype, // video:2 // bangumi: 24
        'ps': ps,
        'direction': direction,
        'desc': desc,
        'sort_field': sortField,
        'tid': 0,
        'with_current': withCurrent,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']['media_list'] != null
            ? res.data['data']['media_list']
                .map<MediaVideoItemModel>(
                    (e) => MediaVideoItemModel.fromJson(e))
                .toList()
            : <MediaVideoItemModel>[]
      };
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
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    return res.data as Map;
  }
}
