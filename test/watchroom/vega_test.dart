import 'package:PiliPlus/features/watchroom/vega.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'accepts current official Vega nodes and rejects misleading domains',
    () {
      expect(
        RoomVega.isOfficialNode(Uri.parse('wss://vega-dsa.biliapi.net/sub')),
        isTrue,
      );
      expect(
        RoomVega.isOfficialNode(Uri.parse('wss://vega.bilibili.com/sub')),
        isTrue,
      );
      for (final url in [
        'ws://vega-dsa.biliapi.net/sub',
        'wss://biliapi.net.attacker.example/sub',
        'wss://fakebiliapi.net/sub',
        'wss://user:password@vega-dsa.biliapi.net/sub',
      ]) {
        expect(RoomVega.isOfficialNode(Uri.parse(url)), isFalse, reason: url);
      }
    },
  );
}
