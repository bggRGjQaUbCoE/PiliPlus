import 'package:PiliPlus/utils/accounts/web_cookie_origin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('webCookieOrigin', () {
    test('normalizes a leading-dot cookie domain', () {
      expect(
        webCookieOrigin('.bilibili.com'),
        'https://bilibili.com/',
      );
    });

    test('normalizes whitespace around a host-only domain', () {
      expect(
        webCookieOrigin('  bilibili.com  '),
        'https://bilibili.com/',
      );
    });

    test('rejects a missing cookie domain', () {
      expect(() => webCookieOrigin(null), throwsArgumentError);
    });
  });
}
