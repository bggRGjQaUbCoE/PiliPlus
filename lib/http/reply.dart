import 'dart:convert' show jsonEncode;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/emote/data.dart';
import 'package:PiliPlus/models_new/emote/package.dart';
import 'package:PiliPlus/models_new/reply/data.dart';
import 'package:PiliPlus/models_new/reply/reply.dart';
import 'package:PiliPlus/models_new/reply2reply/data.dart';
import 'package:PiliPlus/models_new/reply_interaction/data.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/comment_utils.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

abstract final class ReplyHttp {
  static final Options options = Options(
    headers: {...Constants.baseHeaders, 'cookie': ''},
    extra: {'account': const NoAccount()},
  );

  static Future<LoadingState<ReplyData>> replyList({
    required bool isLogin,
    required int oid,
    required String nextOffset,
    required int type,
    required int page,
    int sort = 1,
  }) async {
    final res = !isLogin
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
      return Success(ReplyData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<ReplyReplyData>> replyReplyList({
    required bool isLogin,
    required int oid,
    required int root,
    required int pageNum,
    required int type,
    bool isCheck = false,
  }) async {
    final res = await Request().get(
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
      return Success(replyData);
    } else {
      return Error(
        isCheck
            ? '${res.data['code']}${res.data['message']}'
            : res.data['message'],
      );
    }
  }

  static Future<LoadingState<void>> hateReply({
    required int type,
    required int action,
    required int oid,
    required int rpid,
  }) async {
    final res = await Request().post(
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
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  // 评论点赞
  static Future<LoadingState<void>> likeReply({
    required int type,
    required int oid,
    required int rpid,
    required int action,
  }) async {
    final res = await Request().post(
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
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<Package>?>> getEmoteList({
    String? business,
  }) async {
    final res = await Request().get(
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

  static Future<LoadingState<void>> replyTop({
    required Object oid,
    required Object type,
    required Object rpid,
    required bool isUpTop,
  }) async {
    final res = await Request().post(
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
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<void>> report({
    required Object rpid,
    required Object oid,
    required int reasonType,
    bool banUid = true,
    String? reasonDesc,
  }) async {
    final res = await Request().post(
      Api.replyReport,
      data: {
        'add_blacklist': banUid,
        'csrf': Accounts.main.csrf,
        'gaia_source': 'main_h5',
        'oid': oid,
        'platform': 'android',
        'reason': reasonType,
        'rpid': rpid,
        'scene': 'main',
        'type': 1,
        'content': ?reasonDesc,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (res.data['code'] == 0) {
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<ReplyInteractData>> replyInteraction({
    required Object oid,
    required Object type,
  }) async {
    final res = await Request().get(
      Api.replyInteraction,
      queryParameters: {
        'oid': oid,
        'type': type,
        'web_location': 333.1369,
      },
    );
    if (res.data['code'] == 0) {
      try {
        return Success(ReplyInteractData.fromJson(res.data['data']));
      } catch (e) {
        return Error(e.toString());
      }
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<void>> replySubjectModify({
    required int oid,
    required int type,
    required int action,
  }) async {
    final res = await Request().post(
      Api.replySubjectModify,
      data: {
        'oid': oid,
        'type': type,
        'action': action,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      if (res.data['data']?['action_toast'] case final String toast) {
        SmartDialog.showToast(toast);
      }
      return const Success(null);
    } else {
      SmartDialog.showToast(res.data['message'].toString());
      return const Error(null);
    }
  }

  /// B站风控返回码
  static const Set<int> _riskCodes = {-352, -412};

  /// 翻页间隔，过快容易触发风控
  static const Duration _crawlInterval = Duration(milliseconds: 500);

  /// 全量抓取视频评论（主楼 + 楼中楼），实现对齐 Web 端脚本：
  /// - 主楼优先走 wbi/main 游标翻页，auto 模式首轮探测失败自动回退旧接口并固定该模式
  /// - 楼中楼仅在 rcount > 0 时按 ps=20 翻页，单条失败不阻断整次抓取
  /// - 每页间隔 500ms，每 5 页回调 [onCheckpoint]，供外部落盘断点
  ///
  /// 抓到的评论累加进 [state.comments]，取消或异常时保留已抓到的部分。
  static Future<void> crawlComments({
    required int oid,
    required CommentCrawlState state,
    int type = 1,
    void Function()? onProgress,
    bool Function()? isCancelled,
    void Function(CommentCrawlState state)? onCheckpoint,
  }) async {
    bool cancelled() => isCancelled?.call() ?? false;
    var pageNo = 0;
    try {
      while (true) {
        if (cancelled()) return;
        final page = await _fetchReplyMain(oid: oid, type: type, state: state);
        for (final item in page.replies) {
          final record = item.toCommentRecord();
          if (record != null) state.comments.add(record);
          final rpid = item.rpid;
          if ((item.rcount ?? 0) > 0 && rpid != null) {
            state.comments.addAll(
              await _fetchSubReplies(
                oid: oid,
                root: rpid,
                type: type,
                cancelled: cancelled,
                onProgress: onProgress,
              ),
            );
          }
          onProgress?.call();
        }
        if (page.isEnd || page.replies.isEmpty) return;
        state.cursor = page.next;
        if (++pageNo % 5 == 0) onCheckpoint?.call(state);
        await Future.delayed(_crawlInterval);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 412) {
        throw const CommentCrawlException(
          'HTTP 412 请求被拦截',
          isRiskControl: true,
        );
      }
      rethrow;
    }
  }

  /// 主楼翻页，返回本页评论、是否到底、下一页游标
  static Future<({List<ReplyItemModel> replies, bool isEnd, String next})>
  _fetchReplyMain({
    required int oid,
    required int type,
    required CommentCrawlState state,
  }) async {
    if (state.mode != ReplyFetchMode.legacy) {
      try {
        final res = await Request().get(
          Api.replyWbiMain,
          queryParameters: await WbiSign.makSign({
            'oid': oid,
            'type': type,
            'mode': 3, // 按热度排序
            'plat': 1,
            'web_location': 1315875,
            'pagination_str': jsonEncode({'offset': state.cursor}),
          }),
        );
        final code = res.data['code'];
        if (code == 0) {
          state.mode = ReplyFetchMode.wbi;
          final data = ReplyData.fromJson(res.data['data']);
          return (
            replies: data.replies ?? const <ReplyItemModel>[],
            isEnd: data.cursor?.isEnd ?? false,
            next: data.cursor?.paginationReply?.nextOffset ?? '',
          );
        }
        final error = _toCrawlException(code, res.data['message']);
        // 已确认走 wbi 后失败、或风控，都要冒出去；auto 首轮失败才回退旧接口
        if (state.mode == ReplyFetchMode.wbi || error.isRiskControl) {
          throw error;
        }
        state.mode = ReplyFetchMode.legacy;
      } on CommentCrawlException {
        rethrow;
      } catch (e) {
        if (e is DioException && e.response?.statusCode == 412) {
          throw const CommentCrawlException(
            'HTTP 412 请求被拦截',
            isRiskControl: true,
          );
        }
        if (state.mode == ReplyFetchMode.wbi) rethrow;
        state.mode = ReplyFetchMode.legacy;
      }
    }
    final res = await Request().get(
      Api.replyMain,
      queryParameters: {
        'oid': oid,
        'type': type,
        'mode': 3,
        'ps': 20,
        'next': int.tryParse(state.cursor) ?? 0,
      },
    );
    final code = res.data['code'];
    if (code != 0) {
      throw _toCrawlException(code, res.data['message']);
    }
    final data = ReplyData.fromJson(res.data['data']);
    return (
      replies: data.replies ?? const <ReplyItemModel>[],
      isEnd: data.cursor?.isEnd ?? false,
      next: '${data.cursor?.next ?? 0}',
    );
  }

  /// 单条主楼下的楼中楼
  static Future<List<CommentRecord>> _fetchSubReplies({
    required int oid,
    required int root,
    required int type,
    required bool Function() cancelled,
    void Function()? onProgress,
  }) async {
    final list = <CommentRecord>[];
    var page = 1;
    while (true) {
      if (cancelled()) return list;
      final res = await Request().get(
        Api.replyReplyList,
        queryParameters: {
          'oid': oid,
          'type': type,
          'root': root,
          'ps': 20,
          'pn': page,
        },
      );
      final code = res.data['code'];
      if (_riskCodes.contains(code)) {
        throw _toCrawlException(code, res.data['message']);
      }
      // 单条楼中楼异常不阻断整次抓取
      if (code != 0) return list;
      final data = ReplyReplyData.fromJson(res.data['data']);
      final replies = data.replies;
      if (replies == null || replies.isEmpty) return list;
      for (final item in replies) {
        final record = item.toCommentRecord(isSub: true);
        if (record != null) {
          list.add(record);
          onProgress?.call();
        }
      }
      if (page * 20 >= (data.page?.count ?? 0)) return list;
      page++;
      await Future.delayed(_crawlInterval);
    }
  }

  static CommentCrawlException _toCrawlException(
    dynamic code,
    dynamic message,
  ) => CommentCrawlException(
    '${message ?? '请求失败'} (code $code)',
    isRiskControl: _riskCodes.contains(code),
  );
}
