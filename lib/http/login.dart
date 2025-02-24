import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import '../common/constants.dart';
import '../models/login/index.dart';
import '../utils/login.dart';
import '../utils/utils.dart';
import 'index.dart';

class LoginHttp {
  static final String deviceId = LoginUtils.genDeviceId();
  static final String buvid = LoginUtils.buvid;
  static const String host = 'passport.bilibili.com';
  static final Map<String, String> headers = {
    'Host': host,
    'buvid': buvid,
    'env': 'prod',
    'app-key': 'android_hd',
    'user-agent': Constants.userAgent,
    'x-bili-trace-id': Constants.traceId,
    'x-bili-aurora-eid': '',
    'x-bili-aurora-zone': '',
    'bili-http-engine': 'cronet',
    'content-type': 'application/x-www-form-urlencoded; charset=utf-8',
  };

  static Future<Map<String, dynamic>> getHDcode() async {
    var params = {
      'appkey': Constants.appKey,
      // 'local_id': 'Y952A395BB157D305D8A8340FC2AAECECE17',
      'local_id': '0',
      //精确到秒的时间戳
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      'platform': 'android',
      'mobi_app': 'android_hd',
    };
    String sign = Utils.appSign(
      params,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await Request()
        .post(Api.getTVCode, queryParameters: {...params, 'sign': sign});

    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future codePoll(String authCode) async {
    var params = {
      'appkey': Constants.appKey,
      'auth_code': authCode,
      'local_id': '0',
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
    };
    String sign = Utils.appSign(
      params,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await Request()
        .post(Api.qrcodePoll, queryParameters: {...params, 'sign': sign});
    return {
      'status': res.data['code'] == 0,
      'code': res.data['code'],
      'data': res.data['data'],
      'msg': res.data['message']
    };
  }

  static Future queryCaptcha() async {
    var res = await Request().get(Api.getCaptcha);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': CaptchaDataModel.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'data': res.data['message']};
    }
  }

  // 获取salt与PubKey
  static Future getWebKey() async {
    var res = await Request().get(Api.getWebKey);
    //data: {'disable_rcmd': 0, 'local_id': LoginUtils.generateBuvid()});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': {}, 'msg': res.data['message']};
    }
  }

  static Future sendSmsCode({
    required String cid,
    required String tel,
    // String? deviceTouristId,
    String? gee_challenge,
    String? gee_seccode,
    String? gee_validate,
    String? recaptcha_token,
  }) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    var data = {
      'appkey': Constants.appKey,
      'build': '2001100',
      'buvid': buvid,
      'c_locale': 'zh_CN',
      'channel': 'yingyongbao',
      'cid': cid,
      // if (deviceTouristId != null) 'device_tourist_id': deviceTouristId,
      'disable_rcmd': '0',
      if (gee_challenge != null) 'gee_challenge': gee_challenge,
      if (gee_seccode != null) 'gee_seccode': gee_seccode,
      if (gee_validate != null) 'gee_validate': gee_validate,
      'local_id': buvid,
      // https://chinggg.github.io/post/appre/
      'login_session_id':
          md5.convert(utf8.encode(buvid + timestamp.toString())).toString(),
      'mobi_app': 'android_hd',
      'platform': 'android',
      if (recaptcha_token != null) 'recaptcha_token': recaptcha_token,
      's_locale': 'zh_CN',
      'statistics': Constants.statistics,
      'tel': tel,
      'ts': (timestamp ~/ 1000).toString(),
    };
    String sign = Utils.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );

    var res = await Request().post(
      Api.appSmsCode,
      data: {...data, 'sign': sign},
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: headers,
      ),
    );

    if (res.data['code'] == 0 && res.data['data']['recaptcha_url'] == "") {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'code': res.data['code'],
        'msg': res.data['message'],
        'data': res.data['data']
      };
    }
  }

  // static Future getGuestId(String key) async {
  //   dynamic publicKey = RSAKeyParser().parse(key);
  //   var params = {
  //     'appkey': Constants.appKey,
  //     'build': '2001100',
  //     'buvid': buvid,
  //     'c_locale': 'zh_CN',
  //     'channel': 'yingyongbao',
  //     'deviceInfo': 'xxxxxx',
  //     'disable_rcmd': '0',
  //     'dt': Uri.encodeComponent(Encrypter(RSA(publicKey: publicKey))
  //         .encrypt(generateRandomString(16))
  //         .base64),
  //     'local_id': buvid,
  //     'mobi_app': 'android_hd',
  //     'platform': 'android',
  //     's_locale': 'zh_CN',
  //     'statistics': Constants.statistics,
  //     'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
  //   };
  //   String sign = Utils.appSign(
  //     params,
  //     Constants.appKey,
  //     Constants.appSec,
  //   );
  //   var res = await Request().post(Api.getGuestId,
  //       queryParameters: {...params, 'sign': sign},
  //       options: Options(
  //         contentType: Headers.formUrlEncodedContentType,
  //         headers: headers,
  //       ));
  //   print("getGuestId: $res");
  //   if (res.data['code'] == 0) {
  //     return {'status': true, 'data': res.data['data']};
  //   } else {
  //     return {'status': false, 'msg': res.data['message']};
  //   }
  // }

  // app端密码登录
  static Future loginByPwd({
    required String username,
    required String password,
    required String key,
    required String salt,
    String? gee_challenge,
    String? gee_seccode,
    String? gee_validate,
    String? recaptcha_token,
  }) async {
    dynamic publicKey = RSAKeyParser().parse(key);
    String passwordEncrypted =
        Encrypter(RSA(publicKey: publicKey)).encrypt(salt + password).base64;

    Map<String, String> data = {
      'appkey': Constants.appKey,
      'bili_local_id': deviceId,
      'build': '2001100',
      'buvid': buvid,
      'c_locale': 'zh_CN',
      'channel': 'yingyongbao',
      'device': 'phone',
      'device_id': deviceId,
      //'device_meta': '',
      'device_name': 'vivo',
      'device_platform': 'Android14vivo',
      'disable_rcmd': '0',
      'dt': Uri.encodeComponent(Encrypter(RSA(publicKey: publicKey))
          .encrypt(Utils.generateRandomString(16))
          .base64),
      'from_pv': 'main.homepage.avatar-nologin.all.click',
      'from_url': Uri.encodeComponent('bilibili://pegasus/promo'),
      if (gee_challenge != null) 'gee_challenge': gee_challenge,
      if (gee_seccode != null) 'gee_seccode': gee_seccode,
      if (gee_validate != null) 'gee_validate': gee_validate,
      'local_id': buvid, //LoginUtils.generateBuvid(),
      'mobi_app': 'android_hd',
      'password': passwordEncrypted,
      'permission': 'ALL',
      'platform': 'android',
      if (recaptcha_token != null) 'recaptcha_token': recaptcha_token,
      's_locale': 'zh_CN',
      'statistics': Constants.statistics,
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      'username': username,
    };
    String sign = Utils.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );
    data['sign'] = sign;
    data.map((key, value) {
      return MapEntry<String, dynamic>(key, value);
    });
    var res = await Request().post(
      Api.loginByPwdApi,
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: headers,
        //responseType: ResponseType.plain
      ),
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
        'data': res.data['data']
      };
    }
  }

  // app端短信验证码登录
  static Future loginBySms({
    required String captchaKey,
    required String tel,
    required String code,
    required String cid,
    required String key,
  }) async {
    dynamic publicKey = RSAKeyParser().parse(key);
    Map<String, String> data = {
      'appkey': Constants.appKey,
      'bili_local_id': deviceId,
      'build': '2001100',
      'buvid': buvid,
      'c_locale': 'zh_CN',
      'captcha_key': captchaKey,
      'channel': 'yingyongbao',
      'cid': cid,
      'code': code,
      'device': 'phone',
      'device_id': deviceId,
      //'device_meta': '',
      'device_name': 'vivo',
      'device_platform': 'Android14vivo',
      // 'device_tourist_id': '',
      'disable_rcmd': '0',
      'dt': Uri.encodeComponent(Encrypter(RSA(publicKey: publicKey))
          .encrypt(Utils.generateRandomString(16))
          .base64),
      'from_pv': 'main.my-information.my-login.0.click',
      'from_url': Uri.encodeComponent('bilibili://user_center/mine'),
      'local_id': buvid,
      'mobi_app': 'android_hd',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statistics,
      'tel': tel,
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
    };
    String sign = Utils.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );
    data['sign'] = sign;
    data.map((key, value) {
      return MapEntry<String, dynamic>(key, value);
    });
    var res = await Request().post(
      Api.logInByAppSms,
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: headers,
        //responseType: ResponseType.plain
      ),
    );

    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'code': res.data['code'],
        'msg': res.data['message'],
        'data': res.data['data']
      };
    }
  }

  // 密码登录时风控验证手机
  static Future safeCenterGetInfo({
    required String tmpCode,
  }) async {
    var res = await Request().get(
      Api.safeCenterGetInfo,
      queryParameters: {
        'tmp_code': tmpCode,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'code': res.data['code'],
        'msg': res.data['message'],
        'data': res.data['data']
      };
    }
  }

  // 风控验证手机前的极验验证码
  static Future preCapture() async {
    var res = await Request().post(Api.preCapture);

    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'code': res.data['code'],
        'msg': res.data['message'],
        'data': res.data['data']
      };
    }
  }

  // 风控验证手机：发送短信验证码
  static Future safeCenterSmsCode({
    String? smsType,
    required String tmpCode,
    String? geeChallenge,
    String? geeSeccode,
    String? geeValidate,
    String? recaptchaToken,
    required String refererUrl,
  }) async {
    Map<String, String> data = {
      'disable_rcmd': '0',
      'sms_type': smsType ?? 'loginTelCheck',
      'tmp_code': tmpCode,
      if (geeChallenge != null) 'gee_challenge': geeChallenge,
      if (geeSeccode != null) 'gee_seccode': geeSeccode,
      if (geeValidate != null) 'gee_validate': geeValidate,
      if (recaptchaToken != null) 'recaptcha_token': recaptchaToken,
    };
    String sign = Utils.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );
    data['sign'] = sign;
    var res = await Request().post(
      Api.safeCenterSmsCode,
      data: data,
      options:
          Options(contentType: Headers.formUrlEncodedContentType, headers: {
        "Referer": refererUrl,
      }),
    );

    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'code': res.data['code'],
        'msg': res.data['message'],
        'data': res.data['data']
      };
    }
  }

  // 风控验证手机：提交短信验证码
  static Future safeCenterSmsVerify({
    String? type,
    required String code,
    required String tmpCode,
    required String requestId,
    required String source,
    required String captchaKey,
    required String refererUrl,
  }) async {
    Map<String, String> data = {
      'type': type ?? 'loginTelCheck',
      'code': code,
      'tmp_code': tmpCode,
      'request_id': requestId,
      'source': source,
      'captcha_key': captchaKey,
    };
    String sign = Utils.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );
    data['sign'] = sign;
    var res = await Request().post(
      Api.safeCenterSmsVerify,
      data: data,
      options:
          Options(contentType: Headers.formUrlEncodedContentType, headers: {
        "Referer": refererUrl,
      }),
    );

    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'code': res.data['code'],
        'msg': res.data['message'],
        'data': res.data['data']
      };
    }
  }

  // 风控验证手机：用oauthCode换回accessToken
  static Future oauth2AccessToken({
    required String code,
  }) async {
    Map<String, String> data = {
      'appkey': Constants.appKey,
      'build': '2001100',
      'buvid': buvid,
      // 'c_locale': 'zh_CN',
      // 'channel': 'yingyongbao',
      'code': code,
      // 'device': 'phone',
      // 'device_id': deviceId,
      // 'device_name': 'vivo',
      // 'device_platform': 'Android14vivo',
      'disable_rcmd': '0',
      'grant_type': 'authorization_code',
      'local_id': buvid,
      'mobi_app': 'android_hd',
      'platform': 'android',
      // 's_locale': 'zh_CN',
      // 'statistics': Constants.statistics,
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
    };
    String sign = Utils.appSign(
      data,
      Constants.appKey,
      Constants.appSec,
    );
    data['sign'] = sign;
    data.map((key, value) {
      return MapEntry<String, dynamic>(key, value);
    });
    var res = await Request().post(
      Api.oauth2AccessToken,
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: headers,
      ),
    );

    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'code': res.data['code'],
        'msg': res.data['message'],
        'data': res.data['data']
      };
    }
  }
}
