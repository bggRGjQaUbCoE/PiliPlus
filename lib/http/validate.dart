import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:dio/dio.dart';

class ValidateHttp {
  static Future gaiaVgateRegister(String vVoucher) async {
    final res = await Request().post(
      Api.gaiaVgateRegister,
      queryParameters: {
        if (Accounts.main.isLogin) 'csrf': Accounts.main.csrf,
      },
      data: {
        'v_voucher': vVoucher,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future gaiaVgateValidate({
    required Object? challenge,
    required Object? seccode,
    required Object? token,
    required Object? validate,
  }) async {
    final res = await Request().post(
      Api.gaiaVgateValidate,
      queryParameters: {
        if (Accounts.main.isLogin) 'csrf': Accounts.main.csrf,
      },
      data: {
        'challenge': challenge,
        'seccode': seccode,
        'token': token,
        'validate': validate,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }
}
