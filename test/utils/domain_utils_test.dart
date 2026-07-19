import 'package:PiliPlus/utils/domain_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts only the domain itself or a label-delimited subdomain', () {
    expect(isSameOrSubdomain('bilibili.com', 'bilibili.com'), isTrue);
    expect(isSameOrSubdomain('www.bilibili.com', 'bilibili.com'), isTrue);
    expect(isSameOrSubdomain('WWW.BILIBILI.COM.', 'bilibili.com'), isTrue);
    expect(isSameOrSubdomain('evilbilibili.com', 'bilibili.com'), isFalse);
    expect(
      isSameOrSubdomain('bilibili.com.evil.test', 'bilibili.com'),
      isFalse,
    );
  });
}
