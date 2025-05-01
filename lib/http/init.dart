import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/http/retry_interceptor.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/accounts/account_manager/account_mgr.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:archive/archive.dart';
import 'package:brotli/brotli.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import '../utils/storage.dart';
import 'constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as web;

class Request {
  static const _gzipDecoder = GZipDecoder();
  static const _brotilDecoder = BrotliDecoder();

  static final Request _instance = Request._internal();
  static late AccountManager accountManager;
  static late final Dio dio;
  factory Request() => _instance;
  // static final _rand = Random();
  // static final RegExp _spmPrefixExp = RegExp(r'<meta name="spm_prefix" content="([^"]+?)">');

  /// 设置cookie
  static Future<void> setCookie() async {
    accountManager = AccountManager();
    dio.interceptors.add(accountManager);
    await Accounts.refresh();
    final List<Cookie> cookies = Accounts.main.cookieJar.toList();
    final webManager = web.CookieManager();
    await Future.wait(cookies.map((item) => webManager.setCookie(
          url: web.WebUri(item.domain ?? ''),
          name: item.name,
          value: item.value,
          path: item.path ?? '',
          domain: item.domain,
          isSecure: item.secure,
          isHttpOnly: item.httpOnly,
        )));

    if (Accounts.main.isLogin) {
      final coin = GStorage.userInfo.get('userInfoCache')?.money;
      if (coin == null) {
        setCoin();
      } else {
        GlobalData().coins = coin;
      }
    }
  }

  static Future<void> setCoin() async {
    final res = await UserHttp.getCoin();
    if (res['status']) {
      GlobalData().coins = res['data'];
    }
  }

  // static Future<void> buvidActive(Account account) async {
  //   // 这样线程不安全, 但仍按预期进行
  //   if (account.activited) return;
  //   account.activited = true;
  //   try {
  //     final html = await Request().get(Api.dynamicSpmPrefix,
  //         options: Options(extra: {'account': account}));
  //     final String spmPrefix = _spmPrefixExp.firstMatch(html.data)!.group(1)!;
  //     final String randPngEnd = base64.encode(
  //         List<int>.generate(32, (_) => _rand.nextInt(256)) +
  //             List<int>.filled(4, 0) +
  //             [73, 69, 78, 68] +
  //             List<int>.generate(4, (_) => _rand.nextInt(256)));

  //     String jsonData = json.encode({
  //       '3064': 1,
  //       '39c8': '$spmPrefix.fp.risk',
  //       '3c43': {
  //         'adca': 'Linux',
  //         'bfe9': randPngEnd.substring(randPngEnd.length - 50),
  //       },
  //     });

  //     await Request().post(Api.activateBuvidApi,
  //         data: {'payload': jsonData},
  //         options: Options(contentType: Headers.jsonContentType));
  //   } catch (e) {
  //     log("setCookie, $e");
  //   }
  // }

  /*
   * config it and create
   */
  Request._internal() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = BaseOptions(
        //请求基地址,可以包含子路径
        baseUrl: HttpString.apiBaseUrl,
        //连接服务器超时时间，单位是毫秒.
        connectTimeout: const Duration(milliseconds: 10000),
        //响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: const Duration(milliseconds: 10000),
        //Http请求头.
        headers: {
          'connection': 'keep-alive',
          'accept-encoding': 'br,gzip',
          'user-agent': 'Dart/3.6 (dart:io)', // Http2Adapter不会自动添加标头
          'referer': HttpString.baseUrl,
          'env': 'prod',
          'app-key': 'android64',
          'x-bili-aurora-zone': 'sh001',
        },
        responseDecoder: responseDecoder, // Http2Adapter没有自动解压
        persistentConnection: true);

    final bool enableSystemProxy = GStorage.setting
        .get(SettingBoxKey.enableSystemProxy, defaultValue: false);
    final String systemProxyHost = GStorage.defaultSystemProxyHost;
    final String systemProxyPort = GStorage.defaultSystemProxyPort;

    final http11Adapter = IOHttpClientAdapter(createHttpClient: () {
      final client = HttpClient()
        ..idleTimeout = const Duration(seconds: 15)
        ..autoUncompress = false; // Http2Adapter没有自动解压, 统一行为
      // 设置代理
      if (enableSystemProxy) {
        client.findProxy = (_) => 'PROXY $systemProxyHost:$systemProxyPort';
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      }
      return client;
    });

    late Uri proxy;
    if (enableSystemProxy) {
      proxy = Uri(
          scheme: 'http',
          host: systemProxyHost,
          port: int.parse(systemProxyPort));
    }

    dio = Dio(options)
      ..httpClientAdapter =
          GStorage.setting.get(SettingBoxKey.enableHttp2, defaultValue: false)
              ? Http2Adapter(
                  ConnectionManager(
                      idleTimeout: const Duration(seconds: 15),
                      onClientCreate: enableSystemProxy
                          ? (_, config) {
                              config
                                ..proxy = proxy
                                ..onBadCertificate = (_) => true;
                            }
                          : GStorage.badCertificateCallback
                              ? (_, config) {
                                  config.onBadCertificate = (_) => true;
                                }
                              : null),
                  fallbackAdapter: http11Adapter)
              : http11Adapter;

    // 先于其他Interceptor
    dio.interceptors
        .add(RetryInterceptor(GStorage.retryCount, GStorage.retryDelay));

    // 日志拦截器 输出请求、响应内容
    if (BuildConfig.isDebug) {
      dio.interceptors.add(LogInterceptor(
        request: false,
        requestHeader: false,
        responseHeader: false,
      ));
    }

    dio.transformer = BackgroundTransformer();
    dio.options.validateStatus = (int? status) {
      return status! >= 200 && status < 300;
    };
  }

  /*
   * get请求
   */
  Future<Response> get(url,
      {queryParameters, options, cancelToken, extra}) async {
    Response response;
    if (extra != null) {
      if (extra['ua'] != null) {
        options ??= Options();
        options.headers ??= <String, dynamic>{};
        options.headers!['user-agent'] = headerUa(type: extra['ua']);
      }
    }

    try {
      response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      Response errResponse = Response(
        data: {
          'message': await AccountManager.dioError(e)
        }, // 将自定义 Map 数据赋值给 Response 的 data 属性
        statusCode: e.response?.statusCode ?? -1,
        requestOptions: RequestOptions(),
      );
      return errResponse;
    }
  }

  /*
   * post请求
   */
  Future<Response> post(url,
      {data, queryParameters, options, cancelToken}) async {
    // debugPrint('post-data: $data');
    Response response;
    try {
      response = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      // debugPrint('post success: ${response.data}');
      return response;
    } on DioException catch (e) {
      AccountManager.toast(e);
      Response errResponse = Response(
        data: {
          'message': await AccountManager.dioError(e)
        }, // 将自定义 Map 数据赋值给 Response 的 data 属性
        statusCode: e.response?.statusCode ?? -1,
        requestOptions: RequestOptions(),
      );
      return errResponse;
    }
  }

  /*
   * 下载文件
   */
  Future<Response> downloadFile(urlPath, savePath, {cancelToken}) async {
    try {
      Response response = await dio.download(
        urlPath,
        savePath,
        cancelToken: cancelToken,
        // onReceiveProgress: (int count, int total) {
        //进度
        // debugPrint("$count $total");
        // },
      );
      // debugPrint('downloadFile success: ${response.data}');
      return response;
    } on DioException catch (e) {
      // debugPrint('downloadFile error: $e');
      return Response(
        data: {
          'message': await AccountManager.dioError(e),
        },
        statusCode: e.response?.statusCode ?? -1,
        requestOptions: RequestOptions(),
      );
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  static String headerUa({type = 'mob'}) {
    return switch (type) {
      'mob' =>
        'Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Mobile Safari/537.36',
      _ =>
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15'
    };
  }

  static String responseDecoder(List<int> responseBytes, RequestOptions options,
      ResponseBody responseBody) {
    switch (responseBody.headers['content-encoding']?.firstOrNull) {
      case 'gzip':
        return utf8.decode(_gzipDecoder.decodeBytes(responseBytes),
            allowMalformed: true);
      case 'br':
        return utf8.decode(_brotilDecoder.convert(responseBytes),
            allowMalformed: true);
      default:
        return utf8.decode(responseBytes, allowMalformed: true);
    }
  }
}
