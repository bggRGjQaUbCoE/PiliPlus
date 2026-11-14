import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pref.parseBlacklistTimestamps', () {
    test('解析有效的秒级时间并忽略无效记录', () {
      final result = Pref.parseBlacklistTimestamps({
        '123': 1700000000,
        '456': '1700000001',
        'invalid': 'not-a-timestamp',
        'zero': 0,
        'negative': -1,
      });

      expect(result, {
        '123': 1700000000,
        '456': 1700000001,
      });
    });

    test('非映射数据返回空结果', () {
      expect(Pref.parseBlacklistTimestamps(const [1, 2, 3]), isEmpty);
      expect(Pref.parseBlacklistTimestamps(null), isEmpty);
    });
  });
}
