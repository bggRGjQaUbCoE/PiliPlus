import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/emote/data.dart';
import 'package:PiliPlus/models_new/emote/package.dart';
import 'package:PiliPlus/models_new/reply/data.dart';
import 'package:PiliPlus/models_new/reply/reply.dart';
import 'package:PiliPlus/models_new/reply2reply/data.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:dio/dio.dart';

class ReplyHttp {
  static final Options options = Options(
    headers: {...Constants.baseHeaders, 'cookie': ''},
    extra: {'account': NoAccount()},
  );

  static Future<LoadingState> replyList({
    required bool isLogin,
    required int oid,
    required String nextOffset,
    required int type,
    required int page,
    int sort = 1,
    required bool antiGoodsReply,
    // bool? enableFilter,
  }) async {
    var res = !isLogin
        ? await Request().get(
            '${Api.replyList}/main',
            queryParameters: {
              'oid': oid,
              'type': type,
              'pagination_str':
                  '{"offset":"${nextOffset.replaceAll('"', '\\"')}"}',
              'mode': sort + 2, //2:按时间排序；3：按热度排序
            },
            options: !isLogin ? options : null,
          )
        : await Request().get(
            Api.replyList,
            queryParameters: {
              'oid': oid,
              'type': type,
              'sort': sort,
              'pn': page,
              'ps': 20,
            },
            options: !isLogin ? options : null,
          );
    if (res.data['code'] == 0) {
      ReplyData replyData = ReplyData.fromJson(res.data['data']);
      // if (enableFilter != false && replyRegExp.pattern.isNotEmpty) {
      //   // topReplies
      //   if (replyData.topReplies?.isNotEmpty == true) {
      //     replyData.topReplies!.removeWhere((item) {
      //       bool hasMatch = replyRegExp.hasMatch(item.content?.message ?? '');
      //       // remove subreplies
      //       if (!hasMatch) {
      //         if (item.replies?.isNotEmpty == true) {
      //           item.replies!.removeWhere((item) =>
      //               replyRegExp.hasMatch(item.content?.message ?? ''));
      //         }
      //       }
      //       return hasMatch;
      //     });
      //   }

      //   // replies
      //   if (replyData.replies?.isNotEmpty == true) {
      //     replyData.replies!.removeWhere((item) {
      //       bool hasMatch = replyRegExp.hasMatch(item.content?.message ?? '');
      //       // remove subreplies
      //       if (!hasMatch) {
      //         if (item.replies?.isNotEmpty == true) {
      //           item.replies!.removeWhere((item) =>
      //               replyRegExp.hasMatch(item.content?.message ?? ''));
      //         }
      //       }
      //       return hasMatch;
      //     });
      //   }
      // }

      // // antiGoodsReply
      // if (antiGoodsReply) {
      //   // topReplies
      //   if (replyData.topReplies?.isNotEmpty == true) {
      //     replyData.topReplies!.removeWhere((item) {
      //       bool hasMatch = needRemove(item);
      //       // remove subreplies
      //       if (!hasMatch) {
      //         if (item.replies?.isNotEmpty == true) {
      //           item.replies!.removeWhere(needRemove);
      //         }
      //       }
      //       return hasMatch;
      //     });
      //   }

      //   // replies
      //   if (replyData.replies?.isNotEmpty == true) {
      //     replyData.replies!.removeWhere((item) {
      //       bool hasMatch = needRemove(item);
      //       // remove subreplies
      //       if (!hasMatch) {
      //         if (item.replies?.isNotEmpty == true) {
      //           item.replies!.removeWhere(needRemove);
      //         }
      //       }
      //       return hasMatch;
      //     });
      //   }
      // }
      return Success(replyData);
    } else {
      return Error(res.data['message']);
    }
  }

  static bool needRemove(ReplyItemModel reply) {
    try {
      if ((reply.content?.jumpUrl?.isNotEmpty == true &&
              reply.content!.jumpUrl!.values.any((url) {
                return url['extra'] != null &&
                    (url['extra']['goods_cm_control'] == 1 ||
                        url['extra']['goods_item_id'] != 0 ||
                        url['extra']['goods_prefetched_cache'].isNotEmpty);
              })) ||
          reply.content?.message?.contains(Constants.goodsUrlPrefix) == true) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  static Future<LoadingState<ReplyReplyData>> replyReplyList({
    required bool isLogin,
    required int oid,
    required int root,
    required int pageNum,
    required int type,
    required bool antiGoodsReply,
    bool? isCheck,
    bool? filterBanWord,
  }) async {
    var res = await Request().get(
      Api.replyReplyList,
      queryParameters: {
        'oid': oid,
        'root': root,
        'pn': pageNum,
        'type': type,
        'sort': 1,
        if (isLogin) 'csrf': Accounts.main.csrf,
      },
      options: !isLogin ? options : null,
    );
    if (res.data['code'] == 0) {
      ReplyReplyData replyData = ReplyReplyData.fromJson(res.data['data']);
      // if (filterBanWord != false && replyRegExp.pattern.isNotEmpty) {
      //   if (replyData.replies?.isNotEmpty == true) {
      //     replyData.replies!.removeWhere(
      //         (item) => replyRegExp.hasMatch(item.content?.message ?? ''));
      //   }
      // }
      // if (antiGoodsReply) {
      //   if (replyData.replies?.isNotEmpty == true) {
      //     replyData.replies!.removeWhere(needRemove);
      //   }
      // }
      return Success(replyData);
    } else {
      return Error(
        isCheck == true
            ? '${res.data['code']}${res.data['message']}'
            : res.data['message'],
      );
    }
  }

  static Future hateReply({
    required int type,
    required int action,
    required int oid,
    required int rpid,
  }) async {
    var res = await Request().post(
      Api.hateReply,
      data: {
        'type': type,
        'oid': oid,
        'rpid': rpid,
        'action': action,
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

  // 评论点赞
  static Future likeReply({
    required int type,
    required int oid,
    required int rpid,
    required int action,
  }) async {
    var res = await Request().post(
      Api.likeReply,
      data: {
        'type': type,
        'oid': oid,
        'rpid': rpid,
        'action': action,
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

  static Future<LoadingState<List<Package>?>> getEmoteList({
    String? business,
  }) async {
    var res = await Request().get(
      Api.myEmote,
      queryParameters: {
        'business': business ?? 'reply',
        'web_location': '333.1245',
      },
    );
    if (res.data['code'] == 0) {
      return Success(EmoteModelData.fromJson(res.data['data']).packages);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future replyTop({
    required Object oid,
    required Object type,
    required Object rpid,
    required bool isUpTop,
  }) async {
    var res = await Request().post(
      Api.replyTop,
      data: {
        'oid': oid,
        'type': type,
        'rpid': rpid,
        'action': isUpTop ? 0 : 1,
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
}
