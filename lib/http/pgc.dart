import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/pgc_review_type.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_condition/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_result/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_result/list.dart';
import 'package:PiliPlus/models_new/pgc/pgc_review/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_timeline/pgc_timeline.dart';
import 'package:PiliPlus/models_new/pgc/pgc_timeline/result.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:dio/dio.dart';

class PgcHttp {
  static Future<LoadingState<PgcIndexResult>> pgcIndexResult({
    required int page,
    required Map<String, dynamic> params,
    Object? seasonType,
    Object? type,
    Object? indexType,
  }) async {
    var res = await Request().get(
      Api.pgcIndexResult,
      queryParameters: {
        ...params,
        'season_type': ?seasonType,
        'type': ?type,
        'index_type': ?indexType,
        'page': page,
        'pagesize': 21,
      },
    );
    if (res.data['code'] == 0) {
      return Success(PgcIndexResult.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<PgcIndexConditionData>> pgcIndexCondition({
    Object? seasonType,
    required Object type,
    Object? indexType,
  }) async {
    var res = await Request().get(
      Api.pgcIndexCondition,
      queryParameters: {
        'season_type': ?seasonType,
        'type': type,
        'index_type': ?indexType,
      },
    );
    if (res.data['code'] == 0) {
      return Success(PgcIndexConditionData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<PgcIndexItem>?>> pgcIndex({
    required int page,
    int? indexType,
  }) async {
    var res = await Request().get(
      Api.pgcIndex,
      queryParameters: {
        'page': page,
        'index_type': ?indexType,
      },
    );
    if (res.data['code'] == 0) {
      return Success(PgcIndexResult.fromJson(res.data['data']).list);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<Result>?>> pgcTimeline({
    int types = 1, // 1：`番剧`<br />3：`电影`<br />4：`国创` |
    required int before,
    required int after,
  }) async {
    var res = await Request().get(
      Api.pgcTimeline,
      queryParameters: {
        'types': types,
        'before': before,
        'after': after,
      },
    );
    if (res.data['code'] == 0) {
      return Success(PgcTimeline.fromJson(res.data).result);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<PgcReviewData>> pgcReview({
    required PgcReviewType type,
    required mediaId,
    int sort = 0,
    String? next,
  }) async {
    var res = await Request().get(
      type.api,
      queryParameters: {
        'media_id': mediaId,
        'ps': 20,
        'sort': sort,
        'cursor': ?next,
        'web_location': 666.19,
      },
    );
    if (res.data['code'] == 0) {
      return Success(PgcReviewData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future pgcReviewLike({
    required Object mediaId,
    required Object reviewId,
  }) async {
    var res = await Request().post(
      Api.pgcReviewLike,
      data: {
        'media_id': mediaId,
        'review_type': 2,
        'review_id': reviewId,
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

  static Future pgcReviewDislike({
    required Object mediaId,
    required Object reviewId,
  }) async {
    var res = await Request().post(
      Api.pgcReviewDislike,
      data: {
        'media_id': mediaId,
        'review_type': 2,
        'review_id': reviewId,
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

  static Future pgcReviewPost({
    required Object mediaId,
    required int score,
    required String content,
    bool shareFeed = false,
  }) async {
    var res = await Request().post(
      Api.pgcReviewPost,
      data: {
        'media_id': mediaId,
        'score': score,
        'content': content,
        if (shareFeed) 'share_feed': 1,
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

  static Future pgcReviewMod({
    required Object mediaId,
    required int score,
    required String content,
    required Object reviewId,
  }) async {
    var res = await Request().post(
      Api.pgcReviewMod,
      data: {
        'media_id': mediaId,
        'score': score,
        'content': content,
        'review_id': reviewId,
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

  static Future pgcReviewDel({
    required Object mediaId,
    required Object reviewId,
  }) async {
    var res = await Request().post(
      Api.pgcReviewDel,
      data: {
        'media_id': mediaId,
        'review_id': reviewId,
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
