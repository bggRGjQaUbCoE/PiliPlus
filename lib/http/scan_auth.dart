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
  /// ponytail: 仅解析标准的 qrcode_key=/auth_code= 形式，裸 key 不支持，
  /// 需要时再放开成「用户手动选类型」。
  static (ScanQrType, String)? parse(String raw) {
    final text = raw.trim();
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
    return null;
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
    final sessdata = cookieOf(account, 'SESSDATA');
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
    final sessdata = cookieOf(account, 'SESSDATA');
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

  static Map<String, String> _headers(LoginAccount account) {
    final sessdata = cookieOf(account, 'SESSDATA');
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

  static Map<String, dynamic> _webParams(
    LoginAccount account,
    String accessKey,
    String qrcodeKey,
  ) {
    return {
      'access_key': accessKey,
      'build': _build,
      'csrf': cookieOf(account, 'bili_jct'),
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
      ScanSign.sign(params);
      final res = await Request().get(
        url,
        queryParameters: params,
        options: Options(headers: headers, extra: _extra),
      );
      final data = res.data;
      if (data is! Map) {
        return Error(_messageOf(data));
      }
      if (url == Api.qrWebScene) {
        final scene = data['data'];
        if (scene is Map && scene['transient'] == true) {
          transient = 'true';
        }
      }
    }

    final params = _webParams(account, accessKey, qrcodeKey)
      ..['env_key'] = ''
      ..['transient'] = transient
      ..['verify_code'] = ''
      ..['verify_key'] = ''
      ..['verify_type'] = 'verify_tel';
    ScanSign.sign(params);
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
      'csrf': cookieOf(account, 'bili_jct'),
      'mobi_app': 'android',
      'platform': 'android',
      'build': _build,
      'disable_rcmd': '0',
      'statistics': Constants.statisticsScan,
    };
    ScanSign.sign(params);
    final res = await Request().post(
      Api.qrcodeConfirm,
      queryParameters: params,
      options: Options(headers: headers, extra: _extra),
    );
    return _result(res, '已确认 TV 端登录');
  }

  /// 绕过 AccountManager 的 header/cookie 注入，Cookie 由本类手工控制
  static const Map<String, dynamic> _extra = {'account': NoAccount()};

  static LoadingState<String> _result(Response res, String successMsg) {
    final data = res.data;
    if (data is Map && data['code'] == 0) {
      return Success(successMsg);
    }
    return Error(_messageOf(data));
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
