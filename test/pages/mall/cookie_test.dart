import 'dart:async';

import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';

class _CookieStore extends PlatformCookieManager {
  _CookieStore()
    : super.implementation(const PlatformCookieManagerCreationParams());

  final cookies = <String, Map<String, String>>{};
  final targets = <String>[];
  Completer<void>? gate;
  bool rejectWrite = false;
  bool writeResult = true;
  String? rejectedSession;
  final sessions = <String>[];

  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = '/',
    String? domain,
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    targets.add(url.host);
    cookies.remove(domain ?? url.host);
    return true;
  }

  @override
  Future<bool> setCookie({
    required WebUri url,
    required String name,
    required String value,
    String path = '/',
    String? domain,
    int? expiresDate,
    int? maxAge,
    bool? isSecure,
    bool? isHttpOnly,
    HTTPCookieSameSitePolicy? sameSite,
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    targets.add(url.host);
    expect(url.scheme, 'https');
    expect(domain, '.bilibili.com');
    if (name == 'SESSDATA') sessions.add(value);
    await gate?.future;
    if (rejectWrite || (name == 'SESSDATA' && value == rejectedSession)) {
      throw PlatformException(code: 'cookie_write_failed');
    }
    (cookies[domain!] ??= {})[name] = value;
    return writeResult;
  }
}

class _WebPlatform extends InAppWebViewPlatform {
  final store = _CookieStore();

  @override
  PlatformCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) => store;
}

void main() {
  final platform = _WebPlatform();
  InAppWebViewPlatform.instance = platform;
  final store = platform.store;

  LoginAccount account(String session) => LoginAccount(
    BiliCookieJar.fromJson({
      'SESSDATA': session,
      'DedeUserID': '1',
      'bili_jct': 'test',
    }),
    'test-access',
    'test-refresh',
    null,
    'test-buvid',
  );

  setUp(() {
    store
      ..cookies.clear()
      ..targets.clear()
      ..gate = null
      ..rejectWrite = false
      ..writeResult = true
      ..rejectedSession = null
      ..sessions.clear();
  });

  test(
    'account switching removes old Bili cookies and leaves other domains alone',
    () async {
      store.cookies['example.org'] = {'session': 'unrelated'};
      await LoginUtils.syncMallWebCookie(account('account-a'));
      store.cookies['.bilibili.com']!['obsolete'] = 'old-account-only';
      store.cookies['mall.bilibili.com'] = {'SESSDATA': 'old-host-cookie'};
      store.cookies['passport.bilibili.com'] = {'SESSDATA': 'old-login-host'};
      store.cookies['show.bilibili.com'] = {'SESSDATA': 'old-ticket-host'};
      await LoginUtils.syncMallWebCookie(account('account-b'));
      expect(store.cookies['.bilibili.com']!['SESSDATA'], 'account-b');
      expect(store.cookies['.bilibili.com'], isNot(contains('obsolete')));
      expect(store.cookies, isNot(contains('mall.bilibili.com')));
      expect(store.cookies, isNot(contains('passport.bilibili.com')));
      expect(store.cookies, isNot(contains('show.bilibili.com')));
      expect(store.cookies['example.org'], {'session': 'unrelated'});
      expect(store.targets.toSet(), {
        'bilibili.com',
        'mall.bilibili.com',
        'passport.bilibili.com',
        'show.bilibili.com',
      });
    },
  );

  test('anonymous sync removes login cookies', () async {
    await LoginUtils.syncMallWebCookie(account('account-a'));
    await LoginUtils.syncMallWebCookie(AnonymousAccount());
    expect(store.cookies['.bilibili.com'], isNot(contains('SESSDATA')));
    expect(store.cookies['.bilibili.com'], isNot(contains('DedeUserID')));
  });

  test('sync waits for native cookie writes', () async {
    store.gate = Completer<void>();
    var complete = false;
    final sync = LoginUtils.syncMallWebCookie(account('account-a'))
        .then((_) => complete = true);
    await Future<void>.delayed(Duration.zero);
    expect(complete, isFalse);
    store.gate!.complete();
    await sync;
    expect(complete, isTrue);
  });

  test('native cookie errors propagate', () async {
    store.rejectWrite = true;
    await expectLater(
      LoginUtils.syncMallWebCookie(account('account-a')),
      throwsA(isA<PlatformException>()),
    );
  });

  test('an unsuccessful native cookie write is reported', () async {
    store.writeResult = false;
    await expectLater(
      LoginUtils.syncMallWebCookie(account('account-a')),
      throwsStateError,
    );
  });

  test('overlapping account synchronization stays ordered', () async {
    store.gate = Completer<void>();
    final first = LoginUtils.syncMallWebCookie(account('account-a'));
    final second = LoginUtils.syncMallWebCookie(account('account-b'));
    await Future<void>.delayed(Duration.zero);
    expect(store.sessions, ['account-a']);
    store.gate!.complete();
    await Future.wait([first, second]);
    expect(store.sessions, ['account-a', 'account-b']);
    expect(store.cookies['.bilibili.com']!['SESSDATA'], 'account-b');
  });

  test(
    'a failed synchronization reports its error and releases the next account',
    () async {
      store.rejectedSession = 'account-a';
      final first = expectLater(
        LoginUtils.syncMallWebCookie(account('account-a')),
        throwsA(isA<PlatformException>()),
      );
      final second = LoginUtils.syncMallWebCookie(account('account-b'));
      await Future.wait([first, second]);
      expect(store.cookies['.bilibili.com']!['SESSDATA'], 'account-b');
      await LoginUtils.syncMallWebCookie(AnonymousAccount());
      expect(store.cookies['.bilibili.com'], isNot(contains('SESSDATA')));
    },
  );
}
