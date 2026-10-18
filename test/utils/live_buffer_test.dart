import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pref.buildLiveBuffer', () {
    test('默认值与旧实现完全一致（零回归）', () {
      // 旧实现：'demuxer-max-bytes': bufferSize * 0x200000
      expect(
        Pref.buildLiveBuffer(sizeMb: 0, sec: 0, fallbackSizeMb: 4),
        <String, String>{
          'cache': 'yes',
          'demuxer-max-bytes': (4 * 0x200000).toStringAsFixed(0),
          'demuxer-max-back-bytes': '0',
        },
      );
    });

    test('单独设置前向缓冲大小时不再按缓冲大小的 2 倍计算', () {
      final buffer = Pref.buildLiveBuffer(sizeMb: 6, fallbackSizeMb: 4);
      expect(buffer['demuxer-max-bytes'], (6 * 0x100000).toStringAsFixed(0));
      expect(buffer['demuxer-max-back-bytes'], '0');
      expect(buffer.containsKey('cache-secs'), isFalse);
      expect(buffer.containsKey('demuxer-hysteresis-secs'), isFalse);
    });

    test('设置直播缓冲时长时写入 cache-secs 与 demuxer-hysteresis-secs', () {
      final buffer = Pref.buildLiveBuffer(sec: 12, fallbackSizeMb: 4);
      expect(buffer['demuxer-max-bytes'], (4 * 0x200000).toStringAsFixed(0));
      expect(buffer['cache-secs'], '12.000');
      expect(buffer['demuxer-hysteresis-secs'], (12 / 1.5).toStringAsFixed(3));
    });
  });
}
