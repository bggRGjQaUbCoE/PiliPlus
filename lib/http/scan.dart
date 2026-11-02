import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/accounts/account_manager/account_mgr.dart';
import 'package:PiliPlus/utils/app_sign.dart';
import 'package:dio/dio.dart';

class ScanHttp {
  const ScanHttp(this.account);

  final Account account;

  Future<LoadingState<Map<String, dynamic>>> _request(
    String path, {
    bool post = false,
    Map<String, dynamic> parameters = const {},
  }) async {
    final params = <String, dynamic>{
      'access_key': ?account.accessKey,
      'csrf': account.csrf,
      'build': '2001100',
      'disable_rcmd': '0',
      'statistics': Constants.statistics,
      ...parameters,
    };
    AppSign.appSign(params);
    final options = Options(
      extra: {'account': account},
      contentType: Headers.formUrlEncodedContentType,
      headers: {'user-agent': Constants.userAgent},
    );
    try {
      final res = post
          ? await Request().post(path, data: params, options: options)
          : await Request().get(
              path,
              queryParameters: params,
              options: options,
            );
      if (res.data['code'] != 0) {
        return Error(
          res.data['code'] == 86038 ? '二维码已失效，请重新扫描' : res.data['message'],
          code: res.data['code'],
        );
      }
      return Success(res.data['data'] ?? <String, dynamic>{});
    } on DioException catch (e) {
      return Error(await AccountManager.dioError(e));
    }
  }

  Future<LoadingState<Map<String, dynamic>>> scene(String key) async {
    final checked = await _request(
      Api.scanWebCheck,
      parameters: {'qrcode_key': key},
    );
    if (!checked.isSuccess) return checked;
    return _request(Api.scanWebScene, parameters: {'qrcode_key': key});
  }

  Future<LoadingState<Map<String, dynamic>>> confirm({
    required String key,
    required String envKey,
    required bool transient,
    required String verifyKey,
    required String verifyCode,
  }) => _request(
    Api.scanWebConfirm,
    post: true,
    parameters: {
      'qrcode_key': key,
      'env_key': envKey,
      'transient': transient.toString(),
      'verify_type': 'verify_tel',
      'verify_key': verifyKey,
      'verify_code': verifyCode,
    },
  );

  Future<LoadingState<Map<String, dynamic>>> captcha() =>
      _request(Api.preCapture, post: true);

  Future<LoadingState<Map<String, dynamic>>> sendSms(
    Map<String, dynamic> captcha,
  ) => _request(
    Api.safeCenterSmsCode,
    post: true,
    parameters: {'sms_type': 'loginTelCheck', ...captcha},
  );

  Future<LoadingState<Map<String, dynamic>>> checkSms(
    String key,
    String code,
  ) => _request(
    Api.scanSmsCheck,
    parameters: {
      'sms_type': 'loginTelCheck',
      'captcha_key': key,
      'code': code,
    },
  );
}
