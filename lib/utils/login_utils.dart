import 'dart:async' show FutureOr;
import 'dart:io' show Platform;

import 'package:PiliPlus/grpc/grpc_req.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart' show Digest;
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as web;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

abstract final class LoginUtils {
  static FutureOr setWebCookie([Account? account]) {
    if (Platform.isLinux) {
      return null;
    }
    final cookies = (account ?? Accounts.main).cookieJar.toList();
    final webManager = web.CookieManager.instance(
      webViewEnvironment: webViewEnvironment,
    );
    final isWindows = Platform.isWindows;
    return Future.wait(
      cookies.map(
        (cookie) => webManager.setCookie(
          url: web.WebUri(
            '${isWindows ? 'https://' : ''} ${cookie.domain}',
          ),
          name: cookie.name,
          value: cookie.value,
          path: cookie.path ?? '/',
          domain: cookie.domain,
          isSecure: cookie.secure,
          isHttpOnly: cookie.httpOnly,
        ),
      ),
    );
  }

  static Future<void> onLoginMain() async {
    final account = Accounts.main;
    GrpcReq.updateHeaders(account.accessKey);
    setWebCookie(account);
    RequestUtils.syncHistoryStatus();
    final result = await UserHttp.userInfo();
    if (result.isSuccess) {
      final UserInfoData data = result.data;
      if (data.isLogin == true) {
        final accountService = Get.find<AccountService>()
          ..face.value = data.face!;

        if (accountService.isLogin.value) {
          accountService.isLogin.refresh();
        } else {
          accountService.isLogin.value = true;
        }

        SmartDialog.showToast('main登录成功');
        if (data != Pref.userInfoCache) {
          await GStorage.userInfo.put('userInfoCache', data);
        }
      }
    } else {
      // 获取用户信息失败
      await Accounts.deleteAll({account});
      SmartDialog.showNotify(
        msg: '登录失败，请检查cookie是否正确，${result.toString()}',
        notifyType: NotifyType.warning,
      );
    }
  }

  static Future<void> onLogoutMain() {
    Get.find<AccountService>()
      ..face.value = ''
      ..isLogin.value = false;

    GrpcReq.updateHeaders(null);

    return Future.wait([
      if (!Platform.isLinux)
        web.CookieManager.instance(
          webViewEnvironment: webViewEnvironment,
        ).deleteAllCookies(),
      GStorage.userInfo.delete('userInfoCache'),
    ]);
  }

  static String generateBuvid() {
    var md5Str = Digest(
      List.generate(16, (_) => Utils.random.nextInt(256)),
    ).toString();
    return 'XY${md5Str[2]}${md5Str[12]}${md5Str[22]}$md5Str';
  }

  static final buvid = Pref.buvid;

  // static String getUUID() {
  //   return const Uuid().v4().replaceAll('-', '');
  // }

  // static String generateBuvid() {
  //   String uuid = getUUID() + getUUID();
  //   return 'XY${uuid.substring(0, 35).toUpperCase()}';
  // }

  static String genDeviceId() {
    // https://github.com/bilive/bilive_client/blob/2873de0532c54832f5464a4c57325ad9af8b8698/bilive/lib/app_client.ts#L62
    final time = DateTime.now();

    final List<int> bytes = [
      ...Iterable.generate(16, (_) => Utils.random.nextInt(256)),
      _dec2bcd(time.year ~/ 100),
      _dec2bcd(time.year % 100),
      _dec2bcd(time.month),
      _dec2bcd(time.day),
      _dec2bcd(time.hour),
      _dec2bcd(time.minute),
      _dec2bcd(time.second),
      ...Iterable.generate(8, (_) => Utils.random.nextInt(256)),
    ];
    final check = (bytes.sum & 0xFF).toRadixString(16).padLeft(2, '0');

    return Digest(bytes).toString() + check;
  }

  static int _dec2bcd(int dec) {
    assert(0 <= dec && dec < 100);
    return ((dec ~/ 10) << 4) | (dec % 10);
  }
}
