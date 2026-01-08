import 'dart:convert';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/sponsor_block_api.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models_new/sponsor_block/segment_item.dart';
import 'package:PiliPlus/models_new/sponsor_block/user_info.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:dio/dio.dart';

/// https://github.com/hanydd/BilibiliSponsorBlock/wiki/API
abstract final class SponsorBlock {
  static String get blockServer => Pref.blockServer;
  static final options = Options(
    followRedirects: true,
    // https://github.com/hanydd/BilibiliSponsorBlock/wiki/API#1-%E5%85%AC%E7%94%A8%E5%8F%82%E6%95%B0
    headers: {
      'origin': 'PiliPlus',
      'x-ext-version': BuildConfig.versionName,
    },
    validateStatus: (status) => true,
  );

  static Error getErrMsg(Response res) {
    String statusMessage = switch (res.statusCode) {
      200 => '意料之外的响应',
      400 => '参数错误',
      403 => '被自动审核机制拒绝',
      404 => '未找到数据',
      409 => '重复提交',
      429 => '提交太快（触发速率控制）',
      500 => '服务器无法获取信息',
      -1 => res.data['message'].toString(), // DioException
      _ => res.statusMessage ?? res.statusCode.toString(),
    };
    if (res.statusCode != null && res.statusCode != -1) {
      final data = res.data;
      if (res.statusCode == 200 ||
          (data is String && data.isNotEmpty && data.length < 200)) {
        statusMessage = '$statusMessage：$data';
      }
    }
    return Error(statusMessage, code: res.statusCode);
  }

  static String _api(String url) => '$blockServer/api/$url';

  static Future<LoadingState<List<SegmentItemModel>>> getSkipSegments({
    required String bvid,
    required int cid,
  }) async {
    final res = await Request().get(
      _api(SponsorBlockApi.skipSegments),
      queryParameters: {
        'videoID': bvid,
        'cid': cid,
      },
      options: options,
    );

    if (res.statusCode == 200) {
      if (res.data case final List list) {
        return Success(list.map((i) => SegmentItemModel.fromJson(i)).toList());
      }
    }
    return getErrMsg(res);
  }

  static Future<LoadingState<Null>> voteOnSponsorTime({
    required String uuid,
    int? type,
    SegmentType? category,
  }) async {
    assert((type == null) == (category == null));
    final res = await Request().post(
      _api(SponsorBlockApi.voteOnSponsorTime),
      queryParameters: {
        'UUID': uuid,
        'type': ?type,
        'category': ?category?.name,
        'userID': Pref.blockUserID,
      },
      options: options,
    );
    return res.statusCode == 200 ? const Success(null) : getErrMsg(res);
  }

  static Future<LoadingState<Null>> viewedVideoSponsorTime(String uuid) async {
    final res = await Request().post(
      _api(SponsorBlockApi.viewedVideoSponsorTime),
      data: {'UUID': uuid},
      options: options,
    );
    return res.statusCode == 200 ? const Success(null) : getErrMsg(res);
  }

  static Future<LoadingState<Null>> uptimeStatus() async {
    final res = await Request().get(
      _api(SponsorBlockApi.uptimeStatus),
      options: options,
    );
    if (res.statusCode == 200 &&
        res.data is String &&
        Utils.isStringNumeric(res.data)) {
      return const Success(null);
    }
    return getErrMsg(res);
  }

  static Future<LoadingState<UserInfo>> userInfo(
      List<String> query, {
        String? userId,
      }) async {
    final res = await Request().get(
      _api(SponsorBlockApi.userInfo),
      queryParameters: {
        'userID': userId ?? Pref.blockUserID,
        'values': jsonEncode(query),
      },
      options: options,
    );
    if (res.statusCode == 200) {
      return Success(UserInfo.fromJson(res.data));
    }
    return getErrMsg(res);
  }

  static Future<LoadingState<List<SegmentItemModel>>> postSkipSegments({
    required String bvid,
    required int cid,
    required double videoDuration,
    required List<PostSegmentModel> segments,
  }) async {
    final res = await Request().post(
      _api(SponsorBlockApi.skipSegments),
      data: {
        'videoID': bvid,
        'cid': cid.toString(),
        'userID': Pref.blockUserID,
        'userAgent': 'PiliPlus/${BuildConfig.versionName}',
        'videoDuration': videoDuration,
        'segments': segments
            .map(
              (item) => {
            'segment': [item.segment.first, item.segment.second],
            'category': item.category.name,
            'actionType': item.actionType.name,
          },
        )
            .toList(),
      },
      options: options,
    );

    if (res.statusCode == 200) {
      if (res.data case final List list) {
        return Success(list.map((i) => SegmentItemModel.fromJson(i)).toList());
      }
    }
    return getErrMsg(res);
  }

  /// {
  ///   "bvID": string,     // B站视频BVID
  ///   "cid": string,      // 视频CID
  ///   "ytbID": string,    // YouTube视频ID
  ///   "UUID": string,     // 绑定记录的UUID（不是视频中片段的UUID，是绑定记录本身的UUID）
  ///   "votes": int,       // 绑定记录的投票数
  ///   "locked": int,      // 绑定记录是否锁定
  /// }
  /// TODO: show port video info dialog
  static Future<LoadingState<String>> getPortVideo({
    required String bvid,
    required int cid,
  }) async {
    final res = await Request().get(
      _api(SponsorBlockApi.portVideo),
      queryParameters: {
        'videoID': bvid,
        'cid': cid.toString(),
      },
      options: options,
    );

    if (res.statusCode == 200) {
      if (res.data case final Map<String, dynamic> data) {
        if (data['ytbID'] case String ytbId) {
          return Success(ytbId);
        }
      }
    }
    return getErrMsg(res);
  }

  static Future<LoadingState<String>> postPortVideo({
    required String bvid,
    required int cid,
    required String ytbId,
    required int videoDuration,
  }) async {
    final res = await Request().post(
      _api(SponsorBlockApi.portVideo),
      data: {
        'bvID': bvid,
        'cid': cid.toString(),
        'ytbID': ytbId,
        'userID': Pref.blockUserID,
        'biliDuration': videoDuration,
      },
      options: options,
    );

    if (res.statusCode == 200) {
      if (res.data case final Map<String, dynamic> data) {
        if (data['UUID'] case String uuid) {
          return Success(uuid);
        }
      }
    }
    return getErrMsg(res);
  }
}
