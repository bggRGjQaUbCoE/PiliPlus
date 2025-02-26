import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ApiInterceptor extends Interceptor {
  static const List<String> anonymityList = [
    Api.videoUrl,
    Api.videoIntro,
    Api.relatedList,
    Api.replyList,
    Api.replyReplyList,
    Api.searchSuggest,
    Api.searchByType,
    Api.heartBeat,
    Api.ab2c,
    Api.bangumiInfo,
    Api.liveRoomInfo,
    Api.onlineTotal,
    Api.dynamicDetail,
    Api.aiConclusion,
    Api.getSeasonDetailApi,
    Api.liveRoomDmToken,
    Api.liveRoomDmPrefetch,
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    void onRemoveCookie() {
      options.headers.remove('x-bili-mid');
      options.headers.remove('x-bili-aurora-eid');
      options.headers.remove('x-bili-aurora-zone');
      options.headers.remove('cookie');
      options.queryParameters.remove('access_key');
      options.queryParameters.remove('csrf');
      options.queryParameters.remove('csrf_token');
      if (options.data is Map) {
        options.data.remove('access_key');
        options.data.remove('csrf');
        options.data.remove('csrf_token');
      }
    }

    // app端不需要cookie
    if (options.uri.host == 'app.bilibili.com') {
      options.headers.remove('cookie');
    }

    if (options.extra['clearCookie'] == true) {
      onRemoveCookie();
    } else if (MineController.anonymity.value) {
      String uri = options.uri.toString();
      for (var i in anonymityList) {
        // 如果请求的url包含无痕列表中的url，则清空cookie
        // 但需要保证匹配到url的后半部分不再出现/符号，否则会误伤
        int index = uri.indexOf(i);
        if (index == -1) continue;
        if (uri.lastIndexOf('/') >= index + i.length) continue;
        //SmartDialog.showToast('触发无痕模式\n\n$i\n\n${options.uri}');
        onRemoveCookie();
        break;
      }
    }

    handler.next(options);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   try {
  //     if (response.statusCode == 302) {
  //       final List<String> locations = response.headers['location']!;
  //       if (locations.isNotEmpty) {
  //         if (locations.first.startsWith('https://www.mcbbs.net')) {
  //           debugPrint('ApiInterceptor@@@@@: ${locations.first}');
  //           final Uri uri = Uri.parse(locations.first);
  //           final String? accessKey = uri.queryParameters['access_key'];
  //           final String? mid = uri.queryParameters['mid'];
  //           try {
  //             GStorage.localCache.put(LocalCacheKey.accessKey,
  //                 <String, String?>{'mid': mid, 'value': accessKey});
  //           } catch (_) {}
  //         }
  //       }
  //     }
  //   } catch (err) {
  //     debugPrint('ApiInterceptor: $err');
  //   }

  //   handler.next(response);
  // }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理网络请求错误
    // handler.next(err);
    String url = err.requestOptions.uri.toString();
    debugPrint('🌹🌹ApiInterceptor: $url');
    if (url.contains('heartbeat') ||
        url.contains('seg.so') ||
        url.contains('online/total') ||
        url.contains('github') ||
        (url.contains('skipSegments') && err.requestOptions.method == 'GET')) {
      // skip
    } else {
      SmartDialog.showToast(
        await dioError(err) + url,
        // displayType: SmartToastType.onlyRefresh,
        // displayTime: const Duration(milliseconds: 1200),
      );
    }
    super.onError(err, handler);
  }

  static Future<String> dioError(DioException error) async {
    switch (error.type) {
      case DioExceptionType.badCertificate:
        return '证书有误！';
      case DioExceptionType.badResponse:
        return '服务器异常，请稍后重试！';
      case DioExceptionType.cancel:
        return '请求已被取消，请重新请求';
      case DioExceptionType.connectionError:
        return '连接错误，请检查网络设置';
      case DioExceptionType.connectionTimeout:
        return '网络连接超时，请检查网络设置';
      case DioExceptionType.receiveTimeout:
        return '响应超时，请稍后重试！';
      case DioExceptionType.sendTimeout:
        return '发送请求超时，请检查网络设置';
      case DioExceptionType.unknown:
        final String res =
            (await Connectivity().checkConnectivity()).first.title;
        return '$res网络异常 ${error.error}';
    }
  }
}

extension _ConnectivityResultExt on ConnectivityResult {
  String get title => const ['蓝牙', 'Wi-Fi', '局域', '流量', '无', '代理', '其他'][index];
}
