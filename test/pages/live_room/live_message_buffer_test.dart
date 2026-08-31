import 'package:PiliPlus/pages/live_room/live_message_buffer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('retains only the newest values from a large batch', () {
    final values = <int>[];
    LiveMessageBuffer(
      values,
      maxLength: 5,
      trimCount: 2,
    ).addAll(List.generate(10, (index) => index));

    expect(values, [5, 6, 7, 8, 9]);
    expect(values.length, lessThanOrEqualTo(5));
  });

  test('tracks replacement changes even when length stays constant', () {
    final values = <int>[1, 2, 3];
    final buffer = LiveMessageBuffer(values, maxLength: 3, trimCount: 1);
    expect(buffer.markBuilt(), 3);
    expect(buffer.shouldRefresh, isFalse);

    buffer.add(4);

    expect(values, [2, 3, 4]);
    expect(values, hasLength(3));
    expect(buffer.shouldRefresh, isTrue);
    expect(buffer.markBuilt(), 3);
    expect(buffer.shouldRefresh, isFalse);
  });

  test('trims single additions in chunks under the hard limit', () {
    final values = List.generate(5, (index) => index);
    LiveMessageBuffer(values, maxLength: 5, trimCount: 2).add(5);

    expect(values, [2, 3, 4, 5]);
    expect(values.length, lessThanOrEqualTo(5));
  });

  test('non-reactive mutation waits for an explicit refresh', () async {
    final messages = LiveMessageList<int>();
    final buffer = LiveMessageBuffer(
      messages.nonReactiveValues,
      maxLength: 3,
      trimCount: 1,
    );
    var notifications = 0;
    final subscription = messages.listen((_) => notifications += 1);
    addTearDown(subscription.cancel);
    await pumpEventQueue();
    final initialNotifications = notifications;

    buffer.add(1);
    await pumpEventQueue();
    expect(notifications, initialNotifications);

    messages.refresh();
    await pumpEventQueue();
    expect(notifications, initialNotifications + 1);
  });
}
