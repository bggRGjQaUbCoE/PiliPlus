import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/grpc/grpc_repo.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/video/reply/item.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:dio/dio.dart';

import '../models/video/reply/data.dart';
import '../models/video/reply/emote.dart';
import 'api.dart';
import 'init.dart';

class ReplyHttp {
  static Options get _options =>
      Options(extra: {'account': AnonymousAccount()});

  static RegExp replyRegExp =
      RegExp(GStorage.banWordForReply, caseSensitive: false);

  static Future<LoadingState> replyList({
    required bool isLogin,
    required int oid,
    required String nextOffset,
    required int type,
    required int page,
    int sort = 1,
    required bool antiGoodsReply,
    bool? enableFilter,
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
            options: isLogin.not ? _options : null,
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
            options: isLogin.not ? _options : null,
          );
    if (res.data['code'] == 0) {
      ReplyData replyData = ReplyData.fromJson(res.data['data']);
      if (enableFilter != false && replyRegExp.pattern.isNotEmpty) {
        // topReplies
        if (replyData.topReplies?.isNotEmpty == true) {
          replyData.topReplies!.removeWhere((item) {
            bool hasMatch = replyRegExp.hasMatch(item.content?.message ?? '');
            // remove subreplies
            if (hasMatch.not) {
              if (item.replies?.isNotEmpty == true) {
                item.replies!.removeWhere((item) =>
                    replyRegExp.hasMatch(item.content?.message ?? ''));
              }
            }
            return hasMatch;
          });
        }

        // replies
        if (replyData.replies?.isNotEmpty == true) {
          replyData.replies!.removeWhere((item) {
            bool hasMatch = replyRegExp.hasMatch(item.content?.message ?? '');
            // remove subreplies
            if (hasMatch.not) {
              if (item.replies?.isNotEmpty == true) {
                item.replies!.removeWhere((item) =>
                    replyRegExp.hasMatch(item.content?.message ?? ''));
              }
            }
            return hasMatch;
          });
        }
      }

      // antiGoodsReply
      if (antiGoodsReply) {
        // topReplies
        if (replyData.topReplies?.isNotEmpty == true) {
          replyData.topReplies!.removeWhere((item) {
            bool hasMatch = needRemove(item);
            // remove subreplies
            if (hasMatch.not) {
              if (item.replies?.isNotEmpty == true) {
                item.replies!.removeWhere(needRemove);
              }
            }
            return hasMatch;
          });
        }

        // replies
        if (replyData.replies?.isNotEmpty == true) {
          replyData.replies!.removeWhere((item) {
            bool hasMatch = needRemove(item);
            // remove subreplies
            if (hasMatch.not) {
              if (item.replies?.isNotEmpty == true) {
                item.replies!.removeWhere(needRemove);
              }
            }
            return hasMatch;
          });
        }
      }
      return LoadingState.success(replyData);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future<LoadingState> replyListGrpc({
    int type = 1,
    required int oid,
    required CursorReq cursor,
    required bool antiGoodsReply,
  }) async {
    dynamic res = await GrpcRepo.mainList(type: type, oid: oid, cursor: cursor);
    if (res['status']) {
      MainListReply mainListReply = res['data'];
      // keyword filter
      if (replyRegExp.pattern.isNotEmpty) {
        // upTop
        if (mainListReply.hasUpTop() &&
            replyRegExp.hasMatch(mainListReply.upTop.content.message)) {
          mainListReply.clearUpTop();
        }

        // replies
        if (mainListReply.replies.isNotEmpty) {
          mainListReply.replies.removeWhere((item) {
            bool hasMatch = replyRegExp.hasMatch(item.content.message);
            // remove subreplies
            if (hasMatch.not) {
              if (item.replies.isNotEmpty) {
                item.replies.removeWhere(
                    (item) => replyRegExp.hasMatch(item.content.message));
              }
            }
            return hasMatch;
          });
        }
      }

      // antiGoodsReply
      if (antiGoodsReply) {
        // upTop
        if (mainListReply.hasUpTop() && needRemoveGrpc(mainListReply.upTop)) {
          mainListReply.clearUpTop();
        }

        // replies
        if (mainListReply.replies.isNotEmpty) {
          mainListReply.replies.removeWhere((item) {
            bool hasMatch = needRemoveGrpc(item);
            // remove subreplies
            if (hasMatch.not) {
              if (item.replies.isNotEmpty) {
                item.replies.removeWhere(needRemoveGrpc);
              }
            }
            return hasMatch;
          });
        }
      }
      return LoadingState.success(mainListReply);
    } else {
      return LoadingState.error(res['msg']);
    }
  }

  // ref BiliRoamingX
  static bool needRemoveGrpc(ReplyInfo reply) {
    if ((reply.content.url.isNotEmpty &&
            reply.content.url.values.any((url) {
              return url.hasExtra() &&
                  (url.extra.goodsCmControl == 1 ||
                      url.extra.goodsItemId != 0 ||
                      url.extra.goodsPrefetchedCache.isNotEmpty);
            })) ||
        reply.content.message.contains(Constants.goodsUrlPrefix)) {
      return true;
    }
    return false;
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

  static Future<LoadingState> replyReplyList({
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
        if (isLogin) 'csrf': await Request.getCsrf(),
      },
      options: isLogin.not ? _options : null,
    );
    if (res.data['code'] == 0) {
      ReplyReplyData replyData = ReplyReplyData.fromJson(res.data['data']);
      if (filterBanWord != false && replyRegExp.pattern.isNotEmpty) {
        if (replyData.replies?.isNotEmpty == true) {
          replyData.replies!.removeWhere(
              (item) => replyRegExp.hasMatch(item.content?.message ?? ''));
        }
      }
      if (antiGoodsReply) {
        if (replyData.replies?.isNotEmpty == true) {
          replyData.replies!.removeWhere(needRemove);
        }
      }
      return LoadingState.success(replyData);
    } else {
      return LoadingState.error(
        isCheck == true
            ? '${res.data['code']}${res.data['message']}'
            : res.data['message'],
      );
    }
  }

  static Future<LoadingState> replyReplyListGrpc({
    int type = 1,
    required int oid,
    required int root,
    required int rpid,
    required CursorReq cursor,
    required bool antiGoodsReply,
  }) async {
    dynamic res = await GrpcRepo.detailList(
      type: type,
      oid: oid,
      root: root,
      rpid: rpid,
      cursor: cursor,
    );
    if (res['status']) {
      DetailListReply detailListReply = res['data'];
      if (replyRegExp.pattern.isNotEmpty) {
        if (detailListReply.root.replies.isNotEmpty) {
          detailListReply.root.replies.removeWhere(
              (item) => replyRegExp.hasMatch(item.content.message));
        }
      }
      if (antiGoodsReply) {
        if (detailListReply.root.replies.isNotEmpty) {
          detailListReply.root.replies.removeWhere(needRemoveGrpc);
        }
      }
      return LoadingState.success(detailListReply);
    } else {
      return LoadingState.error(res['msg']);
    }
  }

  static Future<LoadingState> dialogListGrpc({
    int type = 1,
    required int oid,
    required int root,
    required int rpid,
    required CursorReq cursor,
    required bool antiGoodsReply,
  }) async {
    dynamic res = await GrpcRepo.dialogList(
      type: type,
      oid: oid,
      root: root,
      rpid: rpid,
      cursor: cursor,
    );
    if (res['status']) {
      DialogListReply dialogListReply = res['data'];
      if (replyRegExp.pattern.isNotEmpty) {
        if (dialogListReply.replies.isNotEmpty) {
          dialogListReply.replies.removeWhere(
              (item) => replyRegExp.hasMatch(item.content.message));
        }
      }
      if (antiGoodsReply) {
        if (dialogListReply.replies.isNotEmpty) {
          dialogListReply.replies.removeWhere(needRemoveGrpc);
        }
      }
      return LoadingState.success(dialogListReply);
    } else {
      return LoadingState.error(res['msg']);
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
        'csrf': await Request.getCsrf(),
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'date': [],
        'msg': res.data['message'],
      };
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
      queryParameters: {
        'type': type,
        'oid': oid,
        'rpid': rpid,
        'action': action,
        'csrf': await Request.getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'date': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future<LoadingState> getEmoteList({String? business}) async {
    var res = await Request().get(Api.myEmote, queryParameters: {
      'business': business ?? 'reply',
      'web_location': '333.1245',
    });
    if (res.data['code'] == 0) {
      return LoadingState.success(
          EmoteModelData.fromJson(res.data['data']).packages);
    } else {
      return LoadingState.error(res.data['message']);
    }
  }
}
