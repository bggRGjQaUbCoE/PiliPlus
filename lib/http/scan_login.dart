import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/login.dart';
import 'package:PiliPlus/utils/app_sign.dart';
import 'package:dio/dio.dart';

/// 扫码授权：用主账号（TV / HD 端登录得来）的凭证，替 Web 端或 TV 端完成登录确认。
///
/// 请求外观与 [LoginHttp] 完全一致 —— 走 HD（`android_hd`）通道：
/// `app-key: android_hd`、HD UA、HD `statistics`、`build=2051100`，
/// 签名用 HD appkey/appsec（[AppSign.appSign] 默认值）。
///
/// 两条硬性约束（实测）：
///   1. 签名 appkey 必须与 access_key 签发端同源 —— 主账号是 TV 端登录得来，
///      所以必须用 HD appkey 签名，用 App appkey 会返回 `-663 鉴权失败`；
///   2. TV 端 confirm 的请求 UA 必须是 App 版 BiliDroid（见 [userAgentApp]），
///      用 HD 版 UA 会返回 `86096 请使用最新版本扫码登录`（与签名 appkey 无关）。
abstract final class ScanLoginHttp {
  /// HD 通道请求头（与 [LoginHttp.headers] 同源）
  static Map<String, String> get headers => LoginHttp.headers;

  /// TV confirm 专用 UA：必须是 App 版 BiliDroid 且版本不能过低
  static const String userAgentApp =
      'Mozilla/5.0 BiliDroid/9.2.0 (bbcallen@gmail.com) 9.2.0 os/android '
      'model/PJZ110 mobi_app/android build/9020300 '
      'channel/oppo_tv.danmaku.bili_20200623 innerVer/9020310 osVer/16 network/2';

  /// TV confirm 请求头：仅 UA 换成 App 版
  static Map<String, String> get _tvHeaders => {
    ...headers,
    'user-agent': userAgentApp,
    'Referer': 'https://account.bilibili.com/h5/account-h5/auth/scan-web',
  };

  /// Web 端确认的公共参数（HD 风格：不带 `mobi_app` / `platform`）
  static Map<String, dynamic> _webParams({
    required String accessKey,
    required String csrf,
    required String qrcodeKey,
  }) => {
    'access_key': accessKey,
    'build': '2051100',
    'csrf': csrf,
    'disable_rcmd': '0',
    'qrcode_key': qrcodeKey,
    'statistics': Constants.statistics,
  };

  /// Web：检查二维码（鉴权核心 = access_key + csrf + sign）
  static Future webQrcodeCheck({
    required String accessKey,
    required String csrf,
    required String qrcodeKey,
  }) async {
    final params = _webParams(
      accessKey: accessKey,
      csrf: csrf,
      qrcodeKey: qrcodeKey,
    );
    AppSign.appSign(params);
    final res = await Request().get(
      Api.webQrcodeCheck,
      queryParameters: params,
      options: Options(headers: headers),
    );
    return {
      'code': res.data['code'],
      'msg': res.data['message'],
      'data': res.data['data'],
    };
  }

  /// Web：取二维码场景（`data.transient` 表示是否需要二次确认）
  static Future webQrcodeScene({
    required String accessKey,
    required String csrf,
    required String qrcodeKey,
  }) async {
    final params = _webParams(
      accessKey: accessKey,
      csrf: csrf,
      qrcodeKey: qrcodeKey,
    );
    AppSign.appSign(params);
    final res = await Request().get(
      Api.webQrcodeScene,
      queryParameters: params,
      options: Options(headers: headers),
    );
    return {
      'code': res.data['code'],
      'msg': res.data['message'],
      'data': res.data['data'],
    };
  }

  /// Web：确认二维码（Web 端随后自行 poll 领取登录态）
  ///
  /// `env_key` / `verify_code` / `verify_key` 为空串也必须参与签名
  /// （编码成 `key=`），见 [AppSign]。
  static Future webQrcodeConfirm({
    required String accessKey,
    required String csrf,
    required String qrcodeKey,
    required String transient,
    String verifyType = 'verify_tel',
  }) async {
    final params = _webParams(
      accessKey: accessKey,
      csrf: csrf,
      qrcodeKey: qrcodeKey,
    )..addAll({
      'env_key': '',
      'transient': transient,
      'verify_code': '',
      'verify_key': '',
      'verify_type': verifyType,
    });
    AppSign.appSign(params);
    final res = await Request().post(
      Api.webQrcodeConfirm,
      data: params,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: headers,
      ),
    );
    return {
      'code': res.data['code'],
      'msg': res.data['message'],
      'data': res.data['data'],
    };
  }

  /// TV：确认二维码（TV 端随后自行 poll 领取登录态）
  static Future tvConfirm({
    required String accessKey,
    required String authCode,
    required String csrf,
  }) async {
    final params = {
      'access_key': accessKey,
      'auth_code': authCode,
      'build': '2051100',
      'csrf': csrf,
      'disable_rcmd': '0',
      'mobi_app': 'android',
      'platform': 'android',
      'statistics': Constants.statistics,
    };
    AppSign.appSign(params);
    final res = await Request().post(
      Api.qrcodeConfirm,
      queryParameters: params,
      options: Options(headers: _tvHeaders),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
        'msg': res.data['message'],
      };
    } else {
      return {
        'status': false,
        'code': res.data['code'],
        'msg': res.data['message'],
        'data': res.data['data'],
      };
    }
  }
}
