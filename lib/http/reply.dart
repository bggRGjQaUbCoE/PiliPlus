import 'dart:io';

import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/grpc/grpc_repo.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:dio/dio.dart';

import '../models/video/reply/data.dart';
import '../models/video/reply/emote.dart';
import 'api.dart';
import 'init.dart';

class ReplyHttp {
  static Future<LoadingState> replyList({
    required bool isLogin,
    required int oid,
    required String nextOffset,
    required int type,
    required int page,
    int sort = 1,
    required String banWordForReply,
  }) async {
    Options? options = !isLogin
        ? Options(
            headers: {HttpHeaders.cookieHeader: "buvid3= ; b_nut= ; sid= "})
        : null;
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
            options: options,
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
            options: options,
          );
    if (res.data['code'] == 0) {
      ReplyData replyData = ReplyData.fromJson(res.data['data']);
      if (banWordForReply.isNotEmpty) {
        // topReplies
        if (replyData.topReplies?.isNotEmpty == true) {
          replyData.topReplies!.removeWhere((item) {
            bool hasMatch = RegExp(banWordForReply, caseSensitive: false)
                .hasMatch(item.content?.message ?? '');
            // remove subreplies
            if (hasMatch.not) {
              if (item.replies?.isNotEmpty == true) {
                item.replies!.removeWhere((item) =>
                    RegExp(banWordForReply, caseSensitive: false)
                        .hasMatch(item.content?.message ?? ''));
              }
            }
            return hasMatch;
          });
        }

        // replies
        if (replyData.replies?.isNotEmpty == true) {
          replyData.replies!.removeWhere((item) {
            bool hasMatch = RegExp(banWordForReply, caseSensitive: false)
                .hasMatch(item.content?.message ?? '');
            // remove subreplies
            if (hasMatch.not) {
              if (item.replies?.isNotEmpty == true) {
                item.replies!.removeWhere((item) =>
                    RegExp(banWordForReply, caseSensitive: false)
                        .hasMatch(item.content?.message ?? ''));
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
    required String banWordForReply,
  }) async {
    dynamic res = await GrpcRepo.mainList(type: type, oid: oid, cursor: cursor);
    if (res['status']) {
      MainListReply mainListReply = res['data'];
      if (banWordForReply.isNotEmpty) {
        // upTop
        if (mainListReply.hasUpTop() &&
            RegExp(banWordForReply, caseSensitive: false)
                .hasMatch(mainListReply.upTop.content.message)) {
          mainListReply.clearUpTop();
        }

        // replies
        if (mainListReply.replies.isNotEmpty) {
          mainListReply.replies.removeWhere((item) {
            bool hasMatch = RegExp(banWordForReply, caseSensitive: false)
                .hasMatch(item.content.message);
            // remove subreplies
            if (hasMatch.not) {
              if (item.replies.isNotEmpty) {
                item.replies.removeWhere((item) =>
                    RegExp(banWordForReply, caseSensitive: false)
                        .hasMatch(item.content.message));
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

  static Future<LoadingState> replyReplyList({
    required bool isLogin,
    required int oid,
    required int root,
    required int pageNum,
    required int type,
    required String banWordForReply,
    bool? isCheck,
  }) async {
    Options? options = isLogin.not
        ? Options(
            headers: {HttpHeaders.cookieHeader: "buvid3= ; b_nut= ; sid= "})
        : null;
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
      options: options,
    );
    if (res.data['code'] == 0) {
      ReplyReplyData replyData = ReplyReplyData.fromJson(res.data['data']);
      if (banWordForReply.isNotEmpty) {
        if (replyData.replies?.isNotEmpty == true) {
          replyData.replies!.removeWhere((item) =>
              RegExp(banWordForReply, caseSensitive: false)
                  .hasMatch(item.content?.message ?? ''));
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
    required String banWordForReply,
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
      if (banWordForReply.isNotEmpty) {
        if (detailListReply.root.replies.isNotEmpty) {
          detailListReply.root.replies.removeWhere((item) =>
              RegExp(banWordForReply, caseSensitive: false)
                  .hasMatch(item.content.message));
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
    required String banWordForReply,
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
      if (banWordForReply.isNotEmpty) {
        if (dialogListReply.replies.isNotEmpty) {
          dialogListReply.replies.removeWhere((item) =>
              RegExp(banWordForReply, caseSensitive: false)
                  .hasMatch(item.content.message));
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
