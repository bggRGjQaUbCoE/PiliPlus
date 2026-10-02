import 'package:PiliPlus/models/common/video/author_play_speed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthorPlaySpeed', () {
    test('round-trips through json map list', () {
      final original = {
        123: const AuthorPlaySpeed(mid: 123, name: 'Alice', speed: 1.5),
        456: const AuthorPlaySpeed(mid: 456, name: 'UID:456', speed: 2.0),
      };

      final encoded = encodeAuthorPlaySpeeds(original);
      final decoded = decodeAuthorPlaySpeeds(encoded);

      expect(decoded.length, 2);
      expect(decoded[123]?.name, 'Alice');
      expect(decoded[123]?.speed, 1.5);
      expect(decoded[456]?.speed, 2.0);
    });

    test('decode tolerates string mid keys and partial maps', () {
      final decoded = decodeAuthorPlaySpeeds([
        {'mid': '789', 'name': 'Bob', 'speed': 1.25},
        {'mid': 'bad', 'name': 'x', 'speed': 1.0},
        {'name': 'missing mid', 'speed': 1.0},
      ]);

      expect(decoded.keys, [789]);
      expect(decoded[789]?.name, 'Bob');
      expect(decoded[789]?.speed, 1.25);
    });

    test('resolvePlaySpeedForAuthor prefers author speed then default', () {
      final map = {
        1: const AuthorPlaySpeed(mid: 1, name: 'A', speed: 1.5),
      };

      expect(
        resolvePlaySpeedForAuthor(
          mid: 1,
          authorSpeeds: map,
          defaultSpeed: 1.0,
        ),
        1.5,
      );
      expect(
        resolvePlaySpeedForAuthor(
          mid: 2,
          authorSpeeds: map,
          defaultSpeed: 1.0,
        ),
        1.0,
      );
      expect(
        resolvePlaySpeedForAuthor(
          mid: null,
          authorSpeeds: map,
          defaultSpeed: 1.0,
        ),
        1.0,
      );
    });
  });
}
