import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/retry_interceptor.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/accounts/account_manager/account_mgr.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:archive/archive.dart';
import 'package:brotli/brotli.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class Request {
  static const _gzipDecoder = GZipDecoder();
  static const _brotliDecoder = BrotliDecoder();

  static final Request _instance = Request._internal();
  static late final IOHttpClientAdapter _http11Adapter;
  static late AccountManager accountManager;
  static bool _isCookieInitialized = false;
  static late final bool _enableHttp2AtStartup;
  static late final Dio dio;
  static Dio? _http11Dio;
  static Dio get http11Dio =>
      _http11Dio ??= _enableHttp2AtStartup
          ? _createDio(enableHttp2: false)
          : dio;
  factory Request() => _instance;

  /// 设置cookie
  static void setCookie() {
    _isCookieInitialized = true;
    accountManager = AccountManager();
    dio.interceptors.add(accountManager);
    if (_http11Dio case final http11Dio? when !identical(http11Dio, dio)) {
      http11Dio.interceptors.add(accountManager);
    }
    Accounts.refresh();
    LoginUtils.setWebCookie();

    if (Accounts.main.isLogin) {
      final coin = Pref.userInfoCache?.money;
      if (coin == null) {
        setCoin();
      } else {
        GlobalData().coins = coin;
      }
    }
  }

  static Future<void> setCoin() async {
    final res = await UserHttp.getCoin();
    if (res case Success(:final response)) {
      GlobalData().coins = response;
    }
  }

  static Future<void> buvidActive(Account account) async {
    // 这样线程不安全, 但仍按预期进行
    if (account.activated) return;
    account.activated = true;
    try {
      // final html = await Request().get(Api.dynamicSpmPrefix,
      //     options: Options(extra: {'account': account}));
      // final String spmPrefix = _spmPrefixExp.firstMatch(html.data)!.group(1)!;
      final String randPngEnd = base64.encode([
        ...Iterable<int>.generate(32, (_) => Utils.random.nextInt(256)),
        0,
        0,
        0,
        0,
        73,
        69,
        78,
        68,
        ...Iterable<int>.generate(4, (_) => Utils.random.nextInt(256)),
      ]);

      final jsonData = json.encode({
        '3064': 1,
        '39c8': '333.1387.fp.risk',
        '3c43': {
          'adca': 'Linux',
          'bfe9': randPngEnd.substring(randPngEnd.length - 50),
        },
      });

      await Request().post(
        Api.activateBuvidApi,
        data: {'payload': jsonData},
        options: Options(
          extra: {'account': account},
          contentType: Headers.jsonContentType,
        ),
      );
    } catch (_) {}
  }

  /*
   * config it and create
   */
  Request._internal() {
    _enableHttp2AtStartup = Pref.enableHttp2;
    final bool enableSystemProxy;
    String? systemProxyHost;
    int? systemProxyPort;
    if (Pref.enableSystemProxy) {
      systemProxyHost = Pref.systemProxyHost;
      systemProxyPort = int.tryParse(Pref.systemProxyPort);
      enableSystemProxy = systemProxyPort != null && systemProxyHost.isNotEmpty;
    } else {
      enableSystemProxy = false;
    }

    _http11Adapter = IOHttpClientAdapter(
      createHttpClient: enableSystemProxy
          ? () => HttpClient()
              ..idleTimeout = const Duration(seconds: 15)
              ..autoUncompress = false
              ..findProxy = ((_) => 'PROXY $systemProxyHost:$systemProxyPort')
              ..badCertificateCallback = (cert, host, port) => true
          : () => HttpClient()
              ..idleTimeout = const Duration(seconds: 15)
              ..autoUncompress = false, // Http2Adapter没有自动解压, 统一行为
    );

    dio = _createDio(
      enableHttp2: _enableHttp2AtStartup,
      enableSystemProxy: enableSystemProxy,
      systemProxyHost: systemProxyHost,
      systemProxyPort: systemProxyPort,
    );
  }

  static Dio _createDio({
    required bool enableHttp2,
    bool? enableSystemProxy,
    String? systemProxyHost,
    int? systemProxyPort,
  }) {
    final client = Dio(
      BaseOptions(
        //请求基地址,可以包含子路径
        baseUrl: HttpString.apiBaseUrl,
        //连接服务器超时时间，单位是毫秒.
        connectTimeout: const Duration(milliseconds: 10000),
        //响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: const Duration(milliseconds: 10000),
        //Http请求头.
        headers: {
          'user-agent': 'Dart/3.6 (dart:io)', // Http2Adapter不会自动添加标头
          if (!enableHttp2) 'connection': 'keep-alive',
          'accept-encoding': 'br,gzip',
        },
        responseDecoder: _responseDecoder, // Http2Adapter没有自动解压
        persistentConnection: true,
      ),
    );

    final effectiveEnableSystemProxy = enableSystemProxy ?? Pref.enableSystemProxy;
    final effectiveSystemProxyHost = systemProxyHost ?? Pref.systemProxyHost;
    final effectiveSystemProxyPort =
        systemProxyPort ?? int.tryParse(Pref.systemProxyPort);

    client.httpClientAdapter = enableHttp2
        ? Http2Adapter(
            ConnectionManager(
              idleTimeout: const Duration(seconds: 15),
              onClientCreate: effectiveEnableSystemProxy
                  ? (_, config) {
                      config
                        ..proxy = Uri(
                          scheme: 'http',
                          host: effectiveSystemProxyHost,
                          port: effectiveSystemProxyPort,
                        )
                        ..onBadCertificate = (_) => true;
                    }
                  : Pref.badCertificateCallback
                  ? (_, config) {
                      config.onBadCertificate = (_) => true;
                    }
                  : null,
            ),
            fallbackAdapter: _http11Adapter,
          )
        : _http11Adapter;

    // 先于其他Interceptor
    client.interceptors.add(
      RetryInterceptor(client, Pref.retryCount, Pref.retryDelay),
    );

    if (_isCookieInitialized) {
      client.interceptors.add(accountManager);
    }

    // 日志拦截器 输出请求、响应内容
    if (kDebugMode) {
      client.interceptors.add(
        LogInterceptor(
          request: false,
          requestHeader: false,
          responseHeader: false,
        ),
      );
    }

    client
      ..transformer = BackgroundTransformer()
      ..options.validateStatus = (int? status) {
        return status != null && status >= 200 && status < 300;
      };

    return client;
  }

  /*
   * get请求
   */
  Future<Response> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.get<T>(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return Response(
        data: {
          'message': await AccountManager.dioError(e),
        }, // 将自定义 Map 数据赋值给 Response 的 data 属性
        statusCode: e.response?.statusCode ?? -1,
        requestOptions: e.requestOptions,
      );
    }
  }

  /*
   * post请求
   */
  Future<Response> post<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    // if (kDebugMode) debugPrint('post-data: $data');
    try {
      return await dio.post<T>(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      AccountManager.toast(e);
      return Response(
        data: {
          'message': await AccountManager.dioError(e),
        }, // 将自定义 Map 数据赋值给 Response 的 data 属性
        statusCode: e.response?.statusCode ?? -1,
        requestOptions: e.requestOptions,
      );
    }
  }

  /*
   * 下载文件
   */
  Future<Response> downloadFile(
    String urlPath,
    String savePath, {
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.download(
        urlPath,
        savePath,
        cancelToken: cancelToken,
        // onReceiveProgress: (int count, int total) {
        // 进度
        // if (kDebugMode) debugPrint("$count $total");
        // },
      );
      // if (kDebugMode) debugPrint('downloadFile success: ${response.data}');
    } on DioException catch (e) {
      // if (kDebugMode) debugPrint('downloadFile error: $e');
      return Response(
        data: {
          'message': await AccountManager.dioError(e),
        },
        statusCode: e.response?.statusCode ?? -1,
        requestOptions: e.requestOptions,
      );
    }
  }

  static List<int> responseBytesDecoder(
    List<int> responseBytes,
    Map<String, List<String>> headers,
  ) => switch (headers['content-encoding']?.firstOrNull) {
    'gzip' => _gzipDecoder.decodeBytes(responseBytes),
    'br' => _brotliDecoder.convert(responseBytes),
    _ => responseBytes,
  };

  static String _responseDecoder(
    List<int> responseBytes,
    RequestOptions options,
    ResponseBody responseBody,
  ) => utf8.decode(
    responseBytesDecoder(responseBytes, responseBody.headers),
    allowMalformed: true,
  );
}
