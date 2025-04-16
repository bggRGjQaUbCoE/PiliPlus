// edit from package:dio_cookie_manager
import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../account.dart';

final _setCookieReg = RegExp('(?<=)(,)(?=[^;]+?=)');

class AccountManager extends Interceptor {
  static final Map<AccountType, Set<String>> apiTypeSet = {
    AccountType.heartbeat: {
      Api.videoIntro,
      Api.replyList,
      Api.replyReplyList,
      Api.heartBeat,
      Api.ab2c,
      Api.bangumiInfo,
      Api.liveRoomInfo,
      Api.liveRoomInfoH5,
      Api.onlineTotal,
      Api.dynamicDetail,
      Api.aiConclusion,
      Api.getSeasonDetailApi,
      Api.liveRoomDmToken,
      Api.liveRoomDmPrefetch,
      Api.searchByType,
      Api.memberDynamicSearch,
      Api.memberArchive
    },
    AccountType.recommend: {
      Api.recommendListWeb,
      Api.recommendListApp,
      Api.feedDislike,
      Api.feedDislikeCancel,
      Api.hotList,
      Api.relatedList,
      Api.hotSearchList, // 不同账号搜索结果可能不一样
      Api.searchDefault,
      Api.searchSuggest,
      Api.liveList,
      Api.searchTrending,
      Api.searchRecommend,
    },
    AccountType.video: {Api.videoUrl, Api.bangumiVideoUrl}
  };

  static final loginApi = {
    Api.getTVCode,
    Api.qrcodePoll,
    Api.getCaptcha,
    Api.getWebKey,
    Api.appSmsCode,
    Api.loginByPwdApi,
    Api.logInByAppSms,
    Api.safeCenterGetInfo,
    Api.preCapture,
    Api.safeCenterSmsCode,
    Api.safeCenterSmsVerify,
    Api.oauth2AccessToken,
  };

  AccountManager();

  String blockServer = GStorage.blockServer;

  static String getCookies(List<Cookie> cookies) {
    // Sort cookies by path (longer path first).
    cookies.sort((a, b) {
      if (a.path == null && b.path == null) {
        return 0;
      } else if (a.path == null) {
        return -1;
      } else if (b.path == null) {
        return 1;
      } else {
        return b.path!.length.compareTo(a.path!.length);
      }
    });
    return cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;

    if (_skipCookie(path)) return handler.next(options);

    final Account account = options.extra['account'] ?? _findAccount(path);

    if (account.isLogin) {
      options.headers.addAll(account.headers);
    } else if (path == Api.heartBeat) {
      return handler.reject(
          DioException.requestCancelled(requestOptions: options, reason: null),
          false);
    }

    // app端不需要管理cookie
    if (path.startsWith(HttpString.appBaseUrl)) {
      // debugPrint('is app: ${options.path}');
      // bytes是grpc响应
      if (options.responseType != ResponseType.bytes) {
        final dataPtr = (options.method == 'POST' && options.data is Map
                ? options.data as Map
                : options.queryParameters)
            .cast<String, dynamic>();
        if (dataPtr.isNotEmpty) {
          if (!account.accessKey.isNullOrEmpty) {
            dataPtr['access_key'] = account.accessKey!;
          }
          dataPtr['ts'] ??=
              (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
          Utils.appSign(dataPtr);
          // debugPrint(dataPtr.toString());
        }
      }
      return handler.next(options);
    } else {
      account.cookieJar.loadForRequest(options.uri).then((cookies) {
        final previousCookies =
            options.headers[HttpHeaders.cookieHeader] as String?;
        final newCookies = getCookies([
          ...?previousCookies
              ?.split(';')
              .where((e) => e.isNotEmpty)
              .map((c) => Cookie.fromSetCookieValue(c)),
          ...cookies,
        ]);
        options.headers[HttpHeaders.cookieHeader] =
            newCookies.isNotEmpty ? newCookies : '';
        handler.next(options);
      }).catchError((dynamic e, StackTrace s) {
        final err = DioException(
          requestOptions: options,
          error: e,
          stackTrace: s,
        );
        handler.reject(err, true);
      });
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final path = response.requestOptions.path;
    if (path.startsWith(HttpString.appBaseUrl) || _skipCookie(path)) {
      return handler.next(response);
    } else {
      _saveCookies(response).then((_) => handler.next(response)).catchError(
        (dynamic e, StackTrace s) {
          final error = DioException(
            requestOptions: response.requestOptions,
            error: e,
            stackTrace: s,
          );
          handler.reject(error, true);
        },
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    const List<String> skipShow = [
      'heartbeat',
      'history/report',
      'roomEntryAction',
      'seg.so',
      'online/total',
      'github',
      'hdslb.com',
      'biliimg.com',
      'site/getCoin',
    ];
    String url = err.requestOptions.uri.toString();
    debugPrint('🌹🌹ApiInterceptor: $url');
    if (skipShow.any((i) => url.contains(i)) ||
        (url.contains('skipSegments') && err.requestOptions.method == 'GET')) {
      // skip
    } else {
      dioError(err).then((res) => SmartDialog.showToast(res + url));
    }

    if (err.response != null &&
        !err.response!.requestOptions.path.startsWith(HttpString.appBaseUrl)) {
      _saveCookies(err.response!).then((_) => handler.next(err)).catchError(
        (dynamic e, StackTrace s) {
          final error = DioException(
            requestOptions: err.response!.requestOptions,
            error: e,
            stackTrace: s,
          );
          handler.next(error);
        },
      );
    } else {
      handler.next(err);
    }
  }

  Future<void> _saveCookies(Response response) async {
    final Account account = response.requestOptions.extra['account'] ??
        _findAccount(response.requestOptions.path);
    final setCookies = response.headers[HttpHeaders.setCookieHeader];
    if (setCookies == null || setCookies.isEmpty) {
      return;
    }
    final List<Cookie> cookies = setCookies
        .map((str) => str.split(_setCookieReg))
        .expand((cookie) => cookie)
        .where((cookie) => cookie.isNotEmpty)
        .map((str) => Cookie.fromSetCookieValue(str))
        .toList();
    final statusCode = response.statusCode ?? 0;
    final locations = response.headers[HttpHeaders.locationHeader] ?? [];
    final isRedirectRequest = statusCode >= 300 && statusCode < 400;
    final originalUri = response.requestOptions.uri;
    final realUri = originalUri.resolveUri(response.realUri);
    await account.cookieJar.saveFromResponse(realUri, cookies);
    if (isRedirectRequest && locations.isNotEmpty) {
      final originalUri = response.realUri;
      await Future.wait(
        locations.map(
          (location) => account.cookieJar.saveFromResponse(
            // Resolves the location based on the current Uri.
            originalUri.resolve(location),
            cookies,
          ),
        ),
      );
    }
    await account.onChange();
  }

  bool _skipCookie(String path) {
    return path.startsWith(blockServer) ||
        path.contains('hdslb.com') ||
        path.contains('biliimg.com');
  }

  Account _findAccount(String path) => loginApi.contains(path)
      ? AnonymousAccount()
      : Accounts.get(AccountType.values.firstWhere(
          (i) => apiTypeSet[i]?.contains(path) == true,
          orElse: () => AccountType.main));

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
