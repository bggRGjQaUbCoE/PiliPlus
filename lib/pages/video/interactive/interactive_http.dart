import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/data.dart';
import 'package:dio/dio.dart' show CancelToken, Response;
import 'package:flutter/foundation.dart';

/// 互动视频 API：/x/stein/edgeinfo_v2 封装。
class InteractiveHttp {
  /// 请求节点数据。
  ///
  /// 返回 (data, code, message)；网络/业务失败时 data 为 null。
  static Future<(EdgeInfoData?, int, String)> edgeInfo(
    String bvid,
    int graphVersion, {
    int? edgeId,
    CancelToken? cancelToken,
  }) async {
    final Map<String, dynamic> query = <String, dynamic>{
      'bvid': bvid,
      'graph_version': graphVersion,
      if (edgeId != null && edgeId > 0) 'edge_id': edgeId,
    };
    try {
      final Response res = await Request().get(
        '/x/stein/edgeinfo_v2',
        queryParameters: query,
        cancelToken: cancelToken,
      );
      if (res.statusCode != 200) {
        return (null, -1, 'HTTP ${res.statusCode}');
      }
      final dynamic body = res.data;
      if (body is! Map<String, dynamic>) {
        return (null, -1, '响应格式异常');
      }
      final int code = body['code'] is int ? body['code'] as int : -1;
      final String message = body['message'] is String
          ? body['message'] as String
          : '';
      if (code != 0) {
        return (null, code, message);
      }
      return (EdgeInfoData.fromJson(body['data']), 0, '');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[InteractiveHttp] edgeInfo failed: $e');
      }
      return (null, -1, e.toString());
    }
  }
}
