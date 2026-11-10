import 'package:PiliPlus/utils/danmaku_mid_hash.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UID 哈希与 B 站弹幕作者标识算法一致', () {
    expect(danmakuMidHashOf(123456789), 'cbf43926');
    expect(danmakuMidHashOf('123456789'), 'cbf43926');
  });
}
