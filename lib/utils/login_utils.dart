import 'dart:io' show Platform;

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/main.dart' show webViewEnvironment;
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/web_cookie_sync.dart';
import 'package:collection/collection.dart';
import 'package:PiliPlus/utils/linux_cookie_manager.dart';
import 'package:crypto/crypto.dart' show Digest;
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as web;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

abstract final class LoginUtils {
  static final _webCookies = WebCookieSync<Account>(
    current: () => Accounts.main,
    replace: _replaceWebCookies,
    merge: _writeWebCookies,
    clear: _clearWebCookies,
  );

  /// Ordinary WebView cookie refresh keeps its existing browsing session.
  /// Main-account changes and official paid pages use a full replacement.
  static Future<void> setWebCookie([Account? account]) =>
      _webCookies.mergeIfCurrent(account ?? Accounts.main);

  /// Remove the old browser identity before Accounts.main is reassigned.
  /// A failed clear aborts the switch while the old app account is still
  /// selected, so ordinary WebViews cannot silently show another account.
  static Future<void> clearWebCookiesBeforeMainSwitch(Account previous) async {
    try {
      await _webCookies.clearIfCurrent(previous);
    } catch (_) {
      SmartDialog.showToast('网页账号清理失败，已阻止切换主账号');
      rethrow;
    }
  }

  /// Called immediately after selecting the new main account, before the
  /// potentially slow user-info request. Paid pages still run prepare() and
  /// verify again immediately before navigation.
  static Future<void> syncSelectedMainWebCookies(Account selected) async {
    if (!selected.isLogin) return;
    try {
      await _webCookies.replaceIfCurrent(selected);
    } catch (_) {
      SmartDialog.showToast('新账号网页登录态未同步；官方付费页面将保持关闭');
    }
  }

  static Future<void> _writeWebCookies(Account account) async {
    if (Platform.isLinux) return;
    final webManager = web.CookieManager.instance(
      webViewEnvironment: webViewEnvironment,
    );
    for (final cookie in account.cookieJar.toList()) {
      final domain = cookie.domain;
      if (domain == null || domain.isEmpty) {
        throw StateError('WebView cookie has no domain');
      }
      final host = domain.startsWith('.') ? domain.substring(1) : domain;
      final written = await webManager.setCookie(
        url: web.WebUri('https://$host/'),
        name: cookie.name,
        value: cookie.value,
        path: cookie.path ?? '/',
        domain: domain,
        isSecure: cookie.secure,
        isHttpOnly: cookie.httpOnly,
      );
      if (!written) throw StateError('WebView cookie write failed');
    }
  }

  static bool _isBiliDomain(String domain) {
    final host = domain.toLowerCase().replaceFirst(RegExp(r'^\.'), '');
    return host == 'bilibili.com' || host.endsWith('.bilibili.com');
  }

  static Future<void> _clearWebCookies() async {
    if (Platform.isLinux) {
      await LinuxCookieManager.deleteAllCookies();
      return;
    }
    final webManager = web.CookieManager.instance(
      webViewEnvironment: webViewEnvironment,
    );
    if (Platform.isMacOS || Platform.isIOS) {
      // Keep ordinary non-Bilibili WebView sessions intact on Apple platforms.
      final cookies = await webManager.getAllCookies();
      for (final cookie in cookies) {
        final domain = cookie.domain;
        if (domain == null || !_isBiliDomain(domain)) continue;
        final host = domain.startsWith('.') ? domain.substring(1) : domain;
        final deleted = await webManager.deleteCookie(
          url: web.WebUri('https://$host/'),
          name: cookie.name,
          path: cookie.path ?? '/',
          domain: domain,
        );
        if (!deleted) throw StateError('WebView cookie deletion failed');
      }
    } else if (!await webManager.deleteAllCookies()) {
      // On Android/Windows getAllCookies may omit domain metadata, so a
      // targeted deletion cannot prove that the old paid-session is gone.
      throw StateError('WebView cookie deletion failed');
    }
    for (final host in ['live.bilibili.com', 'link.bilibili.com']) {
      final url = web.WebUri('https://$host/');
      for (final name in ['DedeUserID', 'SESSDATA', 'bili_jct']) {
        if (await webManager.getCookie(url: url, name: name) != null) {
          throw StateError('Old WebView account cookie remains');
        }
      }
    }
  }

  static Future<void> _verifyWebAccount(Account account) async {
    final cookies = account.cookieJar.toList();
    String? expected(String name) {
      for (final cookie in cookies) {
        if (cookie.name == name &&
            cookie.domain != null &&
            _isBiliDomain(cookie.domain!)) {
          return cookie.value;
        }
      }
      return null;
    }

    final expectedUid = expected('DedeUserID');
    final expectedSession = expected('SESSDATA');
    final expectedCsrf = expected('bili_jct');
    if (expectedUid != '${account.mid}' ||
        expectedSession == null ||
        expectedSession.isEmpty ||
        expectedCsrf == null ||
        expectedCsrf.isEmpty) {
      throw StateError('Current account lacks verified WebView credentials');
    }
    final webManager = web.CookieManager.instance(
      webViewEnvironment: webViewEnvironment,
    );
    for (final host in ['live.bilibili.com', 'link.bilibili.com']) {
      final url = web.WebUri('https://$host/');
      for (final entry in {
        'DedeUserID': expectedUid,
        'SESSDATA': expectedSession,
        'bili_jct': expectedCsrf,
      }.entries) {
        final actual = await webManager.getCookie(url: url, name: entry.key);
        if (actual?.value.toString() != entry.value) {
          throw StateError('WebView account verification failed');
        }
      }
    }
  }

  static Future<void> _replaceWebCookies(Account account) async {
    if (Platform.isLinux) {
      throw UnsupportedError('Linux cannot verify HttpOnly WebView cookies');
    }
    await _clearWebCookies();
    await _writeWebCookies(account);
    if (account.isLogin) await _verifyWebAccount(account);
  }

  /// Call immediately before an official live payment/SC page is pushed.
  /// It waits for previous login/logout writes and verifies that both Bilibili
  /// hosts will receive the current main account's identity and session.
  static Future<void> prepareOfficialLiveWebview(Account account) async {
    if (!account.isLogin || !identical(Accounts.main, account)) {
      throw StateError('The main account changed');
    }
    await _webCookies.prepare(account);
  }

  static Future<void> onLoginMain([Account? selectedAccount]) async {
    final account = selectedAccount ?? Accounts.main;
    if (!identical(Accounts.main, account)) return;
    final res = await UserHttp.userInfo();
    if (!identical(Accounts.main, account)) return;
    if (res case Success(:final response)) {
      try {
        await _webCookies.replaceIfCurrent(account);
      } catch (_) {
        SmartDialog.showToast('网页登录态同步失败；官方付费页面将保持关闭，请刷新登录后重试');
      }
      if (!identical(Accounts.main, account)) return;
      RequestUtils.syncHistoryStatus();
      if (response.isLogin == true) {
        final accountService = Get.find<AccountService>()
          ..face.value = response.face!;

        if (accountService.isLogin.value) {
          accountService.isLogin.refresh();
        } else {
          accountService.isLogin.value = true;
        }

        SmartDialog.showToast('main登录成功');
        if (response != Pref.userInfoCache) {
          await GStorage.userInfo.put('userInfoCache', response);
        }
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

  static Future<void> onLogoutMain([Account? selectedAccount]) async {
    final account = selectedAccount ?? Accounts.main;
    if (!identical(Accounts.main, account)) return;
    Get.find<AccountService>()
      ..face.value = ''
      ..isLogin.value = false;

    try {
      await Future.wait([
        _webCookies.clearIfCurrent(account),
        GStorage.userInfo.delete('userInfoCache'),
      ]);
    } catch (_) {
      SmartDialog.showToast('网页登录态清理失败，请关闭网页并重试退出登录');
      rethrow;
    }
  }

  static Future<void> clearWebCookiesOnAccountReset() =>
      _webCookies.clearIfCurrent(Accounts.main);

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
