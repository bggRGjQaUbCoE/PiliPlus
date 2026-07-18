import 'package:PiliPlus/utils/accounts/cookie_header_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseCookieHeader', () {
    test('trims names in a standard spaced Cookie header', () {
      final parsed = parseCookieHeader(
        'SESSDATA=session; bili_jct=csrf; DedeUserID=42',
      );

      expect(parsed.cookies, {
        'SESSDATA': 'session',
        'bili_jct': 'csrf',
        'DedeUserID': '42',
      });
      expect(
        parsed.header,
        'SESSDATA=session; bili_jct=csrf; DedeUserID=42',
      );
    });

    test('preserves every equals character in a cookie value', () {
      final parsed = parseCookieHeader(
        'SESSDATA=abc=def==; DedeUserID=42',
      );

      expect(parsed.cookies['SESSDATA'], 'abc=def==');
      expect(parsed.header, 'SESSDATA=abc=def==; DedeUserID=42');
    });

    test('excludes malformed segments from both representations', () {
      final parsed = parseCookieHeader(
        'SESSDATA=session; malformed; bad name=value; bili_jct=csrf',
      );

      expect(parsed.cookies, {
        'SESSDATA': 'session',
        'bili_jct': 'csrf',
      });
      expect(parsed.header, 'SESSDATA=session; bili_jct=csrf');
    });
  });
}
