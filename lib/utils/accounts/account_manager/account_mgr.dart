// 基于 dio_cookie_manager 思路扩展：除 Cookie 外还负责账号选择、App 签名、
// gRPC 元数据、错误提示和 Set-Cookie 持久化。不要直接照搬上游实现。
import 'dart:io';

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/accounts/api_type.dart';
import 'package:PiliPlus/utils/app_sign.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:material_ui/material_ui.dart';

// Dio 可能把多个 Set-Cookie 合并到一个响应头；只拆分会出现在后续 cookie 键值前的逗号，
// 避免误拆 Expires=Wed, 21 Oct 2015 07:28:00 GMT 这类属性值。
final _setCookieReg = RegExp('(?<=)(,)(?=[^;]+?=)');

class AccountManager extends Interceptor {
  AccountManager();

  static String blockServer = Pref.blockServer;

  /// 将 CookieJar 返回的 Cookie 扁平化为请求头。
  ///
  /// 更长的 path 排在前面，与浏览器处理同名 Cookie 时的优先级一致。
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

  /// 请求发送前的统一策略。
  ///
  /// 关键顺序：先固定本请求使用的账号，再决定跳过 Cookie、注入 Web Cookie，
  /// 或为 App/gRPC 请求注入 access_key、headers 和签名。
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;

    // 绑定结果写入 options.extra，使响应阶段能取回同一个账号实例保存 Cookie。
    final account = _bindRequestAccount(options);

    // NoAccount 是显式跳过点；CDN 和被屏蔽服务器不应收到 B 站 Cookie。
    if (account is NoAccount || _skipCookie(path)) return handler.next(options);

    // 心跳接口要求登录账号，游客模式下直接取消而不是发出必然失败的请求。
    if (!account.isLogin && path == Api.heartBeat) {
      return handler.reject(
        DioException.requestCancelled(requestOptions: options, reason: null),
        false,
      );
    }

    final isApp = path.startsWith(HttpString.appBaseUrl);

    if (isApp && options.responseType == ResponseType.bytes) {
      // gRPC-over-HTTP 复用 App 地址，但鉴权依靠 protobuf/header 元数据而非 Cookie。
      options.headers.addAll(account.grpcHeaders);
      return handler.next(options);
    }

    options.headers
      ..addAll(account.headers)
      ..['referer'] ??= HttpString.baseUrl;

    // App API 不使用 Cookie Jar；它依赖 access_key、客户端头和请求签名。
    if (isApp) {
      // if (kDebugMode) debugPrint('is app: ${options.path}');
      final dataPtr = (options.method == 'POST' && options.data is Map
          ? (options.data as Map).cast<String, dynamic>()
          : options.queryParameters);
      if (dataPtr.isNotEmpty) {
        if (!account.accessKey.isNullOrEmpty) {
          dataPtr['access_key'] = account.accessKey!;
        }
        AppSign.appSign(dataPtr..remove('sign'));
        // if (kDebugMode) debugPrint(dataPtr.toString());
      }
      return handler.next(options);
    } else {
      // Web API 从所选账号的 CookieJar 加载匹配 domain/path 的 Cookie，
      // 再与调用方显式提供的 Cookie 合并。
      account.cookieJar
          .loadForRequest(options.uri)
          .then((cookies) {
            final previousCookies =
                options.headers[HttpHeaders.cookieHeader] as String?;
            final newCookies = getCookies([
              ...?previousCookies
                  ?.split(';')
                  .where((e) => e.isNotEmpty)
                  .map(Cookie.fromSetCookieValue),
              ...cookies,
            ]);
            options.headers[HttpHeaders.cookieHeader] = newCookies.isNotEmpty
                ? newCookies
                : '';
            handler.next(options);
          })
          .catchError((Object e, StackTrace s) {
            final err = DioException(
              requestOptions: options,
              error: e,
              stackTrace: s,
            );
            handler.reject(err, true);
          });
    }
  }

  /// 收到 Web 响应后先保存服务端更新/删除的 Cookie，再把响应交给调用方。
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_boundRequestAccount(response.requestOptions) case final account?) {
      final future = _saveCookies(
        account,
        response,
      ).whenComplete(() => handler.next(response));
      assert(() {
        future.catchError(
          (Object e, StackTrace s) {
            throw DioException(
              requestOptions: response.requestOptions,
              error: e,
              stackTrace: s,
            );
          },
        );
        return true;
      }());
    } else {
      return handler.next(response);
    }
  }

  /// 错误响应也可能包含有效的 Set-Cookie，因此保存 Cookie 后再继续传播异常。
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    if (options.responseType == ResponseType.stream) {
      return handler.next(err);
    }

    if (options.method != 'POST') toast(err);

    if (err.response case final res?) {
      if (_boundRequestAccount(options) case final account?) {
        _saveCookies(account, res).then(
          (_) => handler.next(err),
          onError: (Object e, StackTrace s) => handler.next(
            DioException(
              requestOptions: options,
              error: e,
              stackTrace: s,
            ),
          ),
        );
        return;
      }
    }
    return handler.next(err);
  }

  static void toast(DioException err) {
    const skipShow = [
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
    if (kDebugMode) debugPrint('🌹🌹ApiInterceptor: $url\n$err');
    if (skipShow.any(url.contains) ||
        (url.contains('skipSegments') && err.requestOptions.method == 'GET')) {
      // skip
    } else {
      dioError(err).then((res) => SmartDialog.showToast(res + url));
    }
  }

  /// 解析 Set-Cookie，并保存到该请求绑定账号的 CookieJar。
  static Future<void> _saveCookies(Account account, Response response) async {
    final setCookies = response.headers[HttpHeaders.setCookieHeader];
    if (setCookies == null || setCookies.isEmpty) {
      return;
    }
    final List<Cookie> cookies = setCookies
        .map((str) => str.split(_setCookieReg))
        .expand((cookie) => cookie)
        .where((cookie) => cookie.isNotEmpty)
        .map(Cookie.fromSetCookieValue)
        .toList();
    final statusCode = response.statusCode ?? 0;
    final locations = response.headers[HttpHeaders.locationHeader] ?? const [];
    final isRedirectRequest = statusCode >= 300 && statusCode < 400;
    final originalUri = response.requestOptions.uri;
    // 使用最终响应 URL 解析 domain/path；重定向时也按 Location 的目标域保存。
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

  static bool _skipCookie(String path) {
    return path.startsWith(blockServer) ||
        path.contains('hdslb.com') ||
        path.contains('biliimg.com');
  }

  /// 根据 URL 选择账号角色。
  ///
  /// 登录接口必须匿名；其余接口先匹配 heartbeat/recommend/video 规则，
  /// 未命中时回退到主账号。调用方也可通过 Options.extra['account'] 显式覆盖。
  static Account _findAccount(String path) => ApiType.loginApi.contains(path)
      ? AnonymousAccount()
      : Accounts.get(
          AccountType.values.firstWhere(
            (i) => ApiType.apiTypeSet[i]?.contains(path) == true,
            orElse: () => AccountType.main,
          ),
        );

  /// 首次触达请求时选择账号并记录；同一请求的响应阶段复用该结果。
  static Account _bindRequestAccount(RequestOptions options) {
    assert(options.extra['account'] is Account?);
    return options.extra['account'] ??= _findAccount(options.path);
  }

  /// 仅 Web/Cookie 请求需要回写账号；App、CDN 和 NoAccount 请求不保存 Cookie。
  static Account? _boundRequestAccount(RequestOptions options) {
    final path = options.path;
    final account = options.extra['account'] as Account;
    if (account is NoAccount ||
        path.startsWith(HttpString.appBaseUrl) ||
        _skipCookie(path)) {
      return null;
    }
    return account;
  }

  /// 把 Dio 技术异常转换为面向用户的中文提示。
  static Future<String> dioError(DioException error) async {
    switch (error.type) {
      case .badCertificate:
        return '证书有误！';
      case .badResponse:
        return '服务器异常，请稍后重试！';
      case .cancel:
        return '请求已被取消，请重新请求';
      case .connectionError:
        return '连接错误，请检查网络设置';
      case .connectionTimeout:
        return '网络连接超时，请检查网络设置';
      case .receiveTimeout:
        return '响应超时，请稍后重试！';
      case .sendTimeout:
        return '发送请求超时，请检查网络设置';
      case .transformTimeout:
        return '转换响应数据超时！';
      case .unknown:
        String desc;
        try {
          desc = PlatformUtils.isMobile
              ? (await Connectivity().checkConnectivity()).first.desc
              : '';
        } catch (_) {
          desc = '';
        }
        return '$desc网络异常 ${error.error}';
    }
  }
}

extension _ConnectivityResultExt on ConnectivityResult {
  String get desc => const ['蓝牙', 'Wi-Fi', '局域', '流量', '无', '代理', '其他'][index];
}
