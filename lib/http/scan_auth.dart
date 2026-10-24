import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/scan_sign.dart';
import 'package:dio/dio.dart';

/// 二维码类型
enum ScanQrType {
  /// 网页端（内容含 qrcode_key=）
  web,

  /// TV 端（内容含 auth_code=）
  tv,
}

/// 扫码授权：用本机已登录的账号确认其它端弹出的登录二维码
///
/// 对应 biliapphelper 的 ConfirmManager，接口、参数、签名保持一一对应。
abstract final class ScanAuth {
  static const String _referer =
      'https://account.bilibili.com/h5/account-h5/auth/scan-web';
  static const String _build = '9020300';

  /// 从二维码内容中解析出 key 与类型，无法识别时返回 null
  ///
  /// 类型为 null 表示内容里没有 qrcode_key=/auth_code=，是裸 key，
  /// 由调用方决定按网页端还是 TV 端处理（对应 extractKey 的兜底分支）。
  static (ScanQrType?, String)? parse(String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      return null;
    }
    for (final MapEntry(key: name, value: type) in const {
      'qrcode_key': ScanQrType.web,
      'auth_code': ScanQrType.tv,
    }.entries) {
      final index = text.indexOf('$name=');
      if (index < 0) {
        continue;
      }
      var value = text.substring(index + name.length + 1);
      for (final sep in const ['&', '#']) {
        final cut = value.indexOf(sep);
        if (cut >= 0) {
          value = value.substring(0, cut);
        }
      }
      if (value.isEmpty) {
        continue;
      }
      try {
        return (type, Uri.decodeComponent(value));
      } catch (_) {
        // 百分号编码非法时按原样使用
        return (type, value);
      }
    }
    // 裸 key 兜底；不含空白的链接说明不是登录二维码，不认
    if (text.contains('://') || text.contains(RegExp(r'\s'))) {
      return null;
    }
    return (null, text);
  }

  /// 账号不可用于扫码授权的原因，null 表示可用
  static String? unavailableReason(LoginAccount account) {
    if (accessKeyOf(account) != null) {
      return null;
    }
    final accessKey = account.accessKey;
    if (accessKey == null || accessKey.isEmpty) {
      return 'Cookie 登录，缺少 access_key';
    }
    final sessdata = sessdataOf(account);
    if (sessdata == null) {
      return 'Cookie 缺少 SESSDATA';
    }
    final parts = sessdata.split(',');
    if (parts.length != 3 || parts[2].length <= 8) {
      return 'SESSDATA 格式异常，无法拼出 access_key';
    }
    return 'access_key 无效';
  }

  /// 用于请求的 access_key
  ///
  /// access_key 不足 32 位时是「access_key + SESSDATA 第三段」的组合形式
  static String? accessKeyOf(LoginAccount account) {
    final accessKey = account.accessKey;
    if (accessKey == null || accessKey.isEmpty) {
      return null;
    }
    if (accessKey.length > 32) {
      return accessKey;
    }
    final sessdata = sessdataOf(account);
    if (sessdata == null) {
      return null;
    }
    final parts = sessdata.split(',');
    if (parts.length != 3 || parts[2].length <= 8) {
      return null;
    }
    return '$accessKey${parts[2].substring(8)}';
  }

  /// 读取 cookie 值，缺失返回 null
  static String? cookieOf(LoginAccount account, String name) {
    return account.cookieJar.domainCookies['bilibili.com']?['/']?[name]?.cookie
        .value;
  }

  /// 明文 SESSDATA
  ///
  /// 宿主把登录响应里的 cookie 原样存入（BiliCookieJar.fromList/fromJson 不解码），
  /// 而 B 站返回的 SESSDATA 是 URL 编码态（逗号是 %2C），拼 access_key 与
  /// Cookie 头都需要明文。对应 LoginManager.kt:225-226「SESSDATA %2C 还原为逗号」。
  static String? sessdataOf(LoginAccount account) {
    final raw = cookieOf(account, 'SESSDATA');
    if (raw == null) {
      return null;
    }
    try {
      return Uri.decodeComponent(raw);
    } catch (_) {
      // 非法百分号编码，按原样使用
      return raw;
    }
  }

  static Map<String, String> _headers(LoginAccount account) {
    final sessdata = sessdataOf(account);
    final biliJct = cookieOf(account, 'bili_jct');
    if (sessdata == null || biliJct == null) {
      throw '该账号缺少 SESSDATA/bili_jct，无法用于扫码授权';
    }
    return {
      'user-agent': Constants.userAgentScan,
      'referer': _referer,
      'accept': 'application/json, text/plain, */*',
      'app-key': 'android64',
      'env': 'prod',
      'cookie': 'SESSDATA=${Uri.encodeQueryComponent(sessdata)}; bili_jct=$biliJct',
    };
  }

  /// bili_jct（csrf），缺失时抛错而不是把 null 塞进签名参数
  static String _csrfOf(LoginAccount account) {
    final biliJct = cookieOf(account, 'bili_jct');
    if (biliJct == null || biliJct.isEmpty) {
      throw '该账号缺少 bili_jct，无法用于扫码授权';
    }
    return biliJct;
  }

  static Map<String, dynamic> _webParams(
    LoginAccount account,
    String accessKey,
    String qrcodeKey,
  ) {
    return {
      'access_key': accessKey,
      'build': _build,
      'csrf': _csrfOf(account),
      'disable_rcmd': '0',
      'mobi_app': 'android',
      'platform': 'android',
      'qrcode_key': qrcodeKey,
      'statistics': Constants.statisticsScan,
    };
  }

  /// 确认登录
  static Future<LoadingState<String>> confirm({
    required LoginAccount account,
    required ScanQrType type,
    required String key,
  }) async {
    try {
      final accessKey = accessKeyOf(account);
      if (accessKey == null) {
        return Error(unavailableReason(account) ?? '该账号无法用于扫码授权');
      }
      final headers = _headers(account);
      return type == ScanQrType.web
          ? await _confirmWeb(account, accessKey, headers, key)
          : await _confirmTv(account, accessKey, headers, key);
    } catch (e) {
      return Error('$e');
    }
  }

  /// 网页端：check -> scene -> confirm
  static Future<LoadingState<String>> _confirmWeb(
    LoginAccount account,
    String accessKey,
    Map<String, String> headers,
    String qrcodeKey,
  ) async {
    // 先 check 再 scene，transient 决定是否需要短信二次校验
    var transient = 'false';
    for (final url in const [Api.qrWebCheck, Api.qrWebScene]) {
      final params = _webParams(account, accessKey, qrcodeKey);
      _sign(params);
      final res = await Request().get(
        url,
        queryParameters: params,
        options: Options(headers: headers, extra: _extra),
      );
      final data = res.data;
      if (data is! Map || data['code'] != 0) {
        return Error(_messageOf(data));
      }
      if (url == Api.qrWebScene) {
        final scene = data['data'];
        // 对应 Kotlin 的 optBoolean(transient)：布尔与 1/"true" 都算真
        if (scene is Map) {
          final value = scene['transient'];
          if (value == true || value == 1 || value == 'true') {
            transient = 'true';
          }
        }
      }
    }

    final params = _webParams(account, accessKey, qrcodeKey)
      ..['env_key'] = ''
      ..['transient'] = transient
      ..['verify_code'] = ''
      ..['verify_key'] = ''
      ..['verify_type'] = 'verify_tel';
    _sign(params);
    final res = await Request().post(
      Api.qrWebConfirm,
      data: params,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: headers,
        extra: _extra,
      ),
    );
    return _result(res, '已确认网页端登录');
  }

  /// TV 端：参数进 query 的一次性确认
  static Future<LoadingState<String>> _confirmTv(
    LoginAccount account,
    String accessKey,
    Map<String, String> headers,
    String authCode,
  ) async {
    final params = {
      'access_key': accessKey,
      'auth_code': authCode,
      'csrf': _csrfOf(account),
      'mobi_app': 'android',
      'platform': 'android',
      'build': _build,
      'disable_rcmd': '0',
      'statistics': Constants.statisticsScan,
    };
    _sign(params);
    final res = await Request().post(
      Api.qrcodeConfirm,
      queryParameters: params,
      options: Options(headers: headers, extra: _extra),
    );
    return _result(res, '已确认 TV 端登录');
  }

  /// 扫码授权的签名必须跟随 access_key 的签发者
  ///
  /// access_key 与签发它的 appkey 绑定：宿主登录链路（lib/http/login.dart）
  /// 由 [Constants.appKey] 那一对签发，若 confirm 改用 ScanSign 自带默认那对，
  /// 服务端会判定 access_key 不属于当前 appkey，返回 -663「鉴权失败，请联系账号组」。
  static void _sign(Map<String, dynamic> params) =>
      ScanSign.sign(params, appkey: Constants.appKey, appsec: Constants.appSec);

  /// 绕过 AccountManager 的 header/cookie 注入，Cookie 由本类手工控制
  static const Map<String, dynamic> _extra = {'account': NoAccount()};

  static LoadingState<String> _result(Response res, String successMsg) {
    final data = res.data;
    if (data is Map && data['code'] == 0) {
      return Success(successMsg);
    }
    // statusCode == -1：Request.post 已捕获 DioException 并 toast 过，
    // 用 code 标记让调用方跳过重复提示（get 不走这条路径）
    return Error(
      _messageOf(data),
      code: res.statusCode == -1 ? -1 : null,
    );
  }

  static String _messageOf(Object? data) {
    if (data is Map) {
      final message = data['message'] ?? data['msg'];
      final code = data['code'];
      if (message != null && '$message'.isNotEmpty) {
        return code == null ? '$message' : '$message (code=$code)';
      }
    }
    return '扫码授权失败';
  }
}
