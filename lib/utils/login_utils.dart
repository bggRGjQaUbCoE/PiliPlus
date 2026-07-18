import 'dart:io' show Platform;

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/accounts/web_cookie_origin.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart' show Digest;
import 'package:flutter/foundation.dart' show debugPrint, debugPrintStack;
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as web;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

abstract final class LoginUtils {
  static Future<void> _webCookieMutation = Future<void>.value();
  static int _mainLoginGeneration = 0;

  static Future<void> _mutateWebCookies(Future<void> Function() mutation) {
    final previous = _webCookieMutation;
    final next = () async {
      try {
        await previous;
      } catch (_) {}
      await mutation();
    }();
    _webCookieMutation = next;
    return next;
  }

  static Future<void> setWebCookie([Account? account]) {
    if (Platform.isLinux) {
      return Future<void>.value();
    }
    final cookies = (account ?? Accounts.main).cookieJar.toList();
    final webManager = web.CookieManager.instance(
      webViewEnvironment: webViewEnvironment,
    );
    return _mutateWebCookies(
      () async {
        await Future.wait(
          cookies.map(
            (cookie) => webManager.setCookie(
              url: web.WebUri(webCookieOrigin(cookie.domain)),
              name: cookie.name,
              value: cookie.value,
              path: cookie.path ?? '/',
              domain: cookie.domain,
              isSecure: cookie.secure,
              isHttpOnly: cookie.httpOnly,
            ),
          ),
        );
      },
    );
  }

  static Future<void> _replaceWebCookies(Account account) {
    if (Platform.isLinux) {
      return Future<void>.value();
    }
    final cookies = account.cookieJar.toList();
    final webManager = web.CookieManager.instance(
      webViewEnvironment: webViewEnvironment,
    );
    return _mutateWebCookies(() async {
      final existingCookies = await webManager.getAllCookies();
      await Future.wait(
        existingCookies
            .where((cookie) => isBilibiliCookieDomain(cookie.domain))
            .map(
              (cookie) => webManager.deleteCookie(
                url: web.WebUri(webCookieOrigin(cookie.domain)),
                name: cookie.name,
                path: cookie.path ?? '/',
                domain: cookie.domain,
              ),
            ),
      );
      await Future.wait(
        cookies.map(
          (cookie) => webManager.setCookie(
            url: web.WebUri(webCookieOrigin(cookie.domain)),
            name: cookie.name,
            value: cookie.value,
            path: cookie.path ?? '/',
            domain: cookie.domain,
            isSecure: cookie.secure,
            isHttpOnly: cookie.httpOnly,
          ),
        ),
      );
    });
  }

  static Future<void> _clearWebCookies() {
    if (Platform.isLinux) {
      return Future<void>.value();
    }
    return _mutateWebCookies(() async {
      await web.CookieManager.instance(
        webViewEnvironment: webViewEnvironment,
      ).deleteAllCookies();
    });
  }

  static Future<void> onLoginMain() async {
    final account = Accounts.main;
    final generation = ++_mainLoginGeneration;
    bool isCurrent() =>
        generation == _mainLoginGeneration && identical(account, Accounts.main);
    final accountService = Get.find<AccountService>();
    final wasLoggedIn = accountService.isLogin.value;
    GlobalData().coins = null;
    if (wasLoggedIn) {
      accountService.notifyMainAccountChanged(isLogin: true);
    }

    await Future.wait([
      GStorage.userInfo.delete('userInfoCache'),
      GStorage.localCache.delete(LocalCacheKey.historyPause),
    ]);
    if (!isCurrent()) return;

    late final LoadingState<UserInfoData> res;
    try {
      res = await UserHttp.userInfo(account: account);
    } catch (error, stackTrace) {
      if (isCurrent()) {
        debugPrint('Main account validation failed: ${error.runtimeType}');
        debugPrintStack(stackTrace: stackTrace);
        SmartDialog.showToast('账号验证失败，请检查网络后重试');
      }
      return;
    }
    if (!isCurrent()) return;
    if (res case Success(:final response)) {
      if (response.isLogin != true) {
        await Accounts.deleteAll({account});
        SmartDialog.showNotify(
          msg: '登录失败，请检查cookie是否正确，账号未登录',
          notifyType: .warning,
        );
        return;
      }

      if (!wasLoggedIn) {
        accountService.notifyMainAccountChanged(isLogin: true);
      }
      accountService.face.value = response.face ?? '';
      GlobalData().coins = response.money;

      try {
        await _replaceWebCookies(account);
      } catch (error, stackTrace) {
        debugPrint('WebView cookie sync failed: ${error.runtimeType}');
        debugPrintStack(stackTrace: stackTrace);
      }
      if (!isCurrent()) return;
      RequestUtils.syncHistoryStatus();

      SmartDialog.showToast('main登录成功');
      if (response != Pref.userInfoCache) {
        await GStorage.userInfo.put('userInfoCache', response);
      }
    } else {
      // 获取用户信息失败
      final errMsg = res.toString();
      if (errMsg == '账号未登录') {
        await Accounts.deleteAll({account});
        SmartDialog.showNotify(
          msg: '登录失败，请检查cookie是否正确，$errMsg',
          notifyType: .warning,
        );
      } else {
        SmartDialog.showToast(errMsg);
      }
    }
  }

  static Future<void> onLogoutMain() {
    _mainLoginGeneration++;
    Get.find<AccountService>().notifyMainAccountChanged(isLogin: false);

    return Future.wait([
      _clearWebCookies(),
      GStorage.userInfo.delete('userInfoCache'),
      GStorage.localCache.delete(LocalCacheKey.historyPause),
    ]);
  }

  static String generateBuvid() {
    final md5Str = Digest(
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
