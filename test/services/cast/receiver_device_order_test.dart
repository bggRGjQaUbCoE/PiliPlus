import 'package:PiliPlus/services/cast/receiver_device_order.dart';
import 'package:flutter_test/flutter_test.dart';

final class _TestDevice {
  const _TestDevice({required this.id, required this.name});
  final String id;
  final String name;
}

void main() {
  const livingRoom = _TestDevice(id: 'cast-1', name: 'Living Room');
  const bedroom = _TestDevice(id: 'cast-2', name: 'Bedroom');
  const kitchen = _TestDevice(id: 'cast-3', name: 'Kitchen');

  String keyOf(_TestDevice d) => d.id;

  group('preserveDiscoveredOrderWithActive', () {
    test('returns discovered order when active is already present', () {
      final discovered = [livingRoom, bedroom, kitchen];
      final result = preserveDiscoveredOrderWithActive(
        discovered: discovered,
        active: bedroom,
        keyOf: keyOf,
      );

      expect(
        result.map(keyOf),
        ['cast-1', 'cast-2', 'cast-3'],
        reason: 'order must match discovery order exactly',
      );
      expect(result.length, 3, reason: 'no duplicate when active is in list');
    });

    test('appends active when missing from discovered', () {
      final discovered = [livingRoom, bedroom];
      final result = preserveDiscoveredOrderWithActive(
        discovered: discovered,
        active: kitchen,
        keyOf: keyOf,
      );

      expect(
        result.map(keyOf),
        ['cast-1', 'cast-2', 'cast-3'],
        reason: 'active appended after discovered when not found',
      );
      expect(result.length, 3);
    });

    test('preserves original order when active is first in list', () {
      final discovered = [livingRoom, bedroom, kitchen];
      final result = preserveDiscoveredOrderWithActive(
        discovered: discovered,
        active: livingRoom,
        keyOf: keyOf,
      );

      expect(
        result.map(keyOf),
        ['cast-1', 'cast-2', 'cast-3'],
        reason: 'first device stays first, order unchanged',
      );
      expect(result.length, 3);
    });

    test('preserves original order when active is last in list', () {
      final discovered = [livingRoom, bedroom, kitchen];
      final result = preserveDiscoveredOrderWithActive(
        discovered: discovered,
        active: kitchen,
        keyOf: keyOf,
      );

      expect(
        result.map(keyOf),
        ['cast-1', 'cast-2', 'cast-3'],
        reason: 'last device stays last, order unchanged',
      );
      expect(result.length, 3);
    });

    test('returns an empty list when both discovered and active are empty', () {
      final result = preserveDiscoveredOrderWithActive<_TestDevice>(
        discovered: const <_TestDevice>[],
        active: null,
        keyOf: keyOf,
      );

      expect(result, isEmpty);
    });

    test('returns list of one if only active is provided', () {
      final result = preserveDiscoveredOrderWithActive<_TestDevice>(
        discovered: const <_TestDevice>[],
        active: livingRoom,
        keyOf: keyOf,
      );

      expect(result.map(keyOf), ['cast-1']);
      expect(result.length, 1);
    });

    test('returns discovered unchanged when active is null', () {
      final discovered = [livingRoom, bedroom];
      final result = preserveDiscoveredOrderWithActive<_TestDevice>(
        discovered: discovered,
        active: null,
        keyOf: keyOf,
      );

      expect(result.map(keyOf), ['cast-1', 'cast-2']);
      expect(result.length, 2);
    });
  });

  group('preserveDiscoveredMapOrderWithActive', () {
    test(
      'returns discovered map unchanged when activeKey is already present',
      () {
        final discovered = {
          'cast-1': livingRoom,
          'cast-2': bedroom,
          'cast-3': kitchen,
        };
        final result = preserveDiscoveredMapOrderWithActive(
          discovered,
          activeKey: 'cast-2',
          active: bedroom,
        );

        expect(result.keys, ['cast-1', 'cast-2', 'cast-3']);
        expect(result.length, 3);
        expect(
          identical(result, discovered),
          isTrue,
          reason: 'same map instance returned when key exists',
        );
      },
    );

    test('appends active when activeKey is missing from discovered', () {
      final discovered = {
        'cast-1': livingRoom,
        'cast-2': bedroom,
      };
      final result = preserveDiscoveredMapOrderWithActive(
        discovered,
        activeKey: 'cast-3',
        active: kitchen,
      );

      expect(result.keys, ['cast-1', 'cast-2', 'cast-3']);
      expect(result['cast-3'], kitchen);
      expect(result.length, 3);
    });

    test('returns discovered unchanged when activeKey is null', () {
      final discovered = {
        'cast-1': livingRoom,
        'cast-2': bedroom,
      };
      final result = preserveDiscoveredMapOrderWithActive(
        discovered,
        activeKey: null,
        active: kitchen,
      );

      expect(result.keys, ['cast-1', 'cast-2']);
      expect(result.length, 2);
    });

    test('returns discovered unchanged when active is null', () {
      final discovered = {
        'cast-1': livingRoom,
        'cast-2': bedroom,
      };
      final result = preserveDiscoveredMapOrderWithActive(
        discovered,
        activeKey: 'cast-3',
        active: null,
      );

      expect(result.keys, ['cast-1', 'cast-2']);
      expect(result.length, 2);
    });

    test(
      'returns map of one entry when discovered is empty and active is provided',
      () {
        final result = preserveDiscoveredMapOrderWithActive(
          const <String, _TestDevice>{},
          activeKey: 'cast-1',
          active: livingRoom,
        );

        expect(result.keys, ['cast-1']);
        expect(result['cast-1'], livingRoom);
        expect(result.length, 1);
      },
    );

    test('returns empty map when both are empty', () {
      final result = preserveDiscoveredMapOrderWithActive(
        const <String, _TestDevice>{},
        activeKey: null,
        active: null,
      );

      expect(result, isEmpty);
    });
  });
}
