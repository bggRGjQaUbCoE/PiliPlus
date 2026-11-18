import 'dart:async';

import 'package:PiliPlus/features/watchroom/piliplus_adapter.dart';
import 'package:PiliPlus/features/watchroom/model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'host_test.dart' show HostTransport, newSession;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('desktop application exit waits for membership acknowledgement with publication off', () async {
    final transport = HostTransport();
    final room = newSession(transport);
    final adapter = WatchroomAdapter.instance;
    addTearDown(() async {
      await room.leave();
      adapter.session = null;
    });
    await room.create(90, 91);
    await room.setControl(false);
    adapter.session = room;
    final pending = Completer<Map<String, dynamic>>(),
        started = Completer<void>();
    transport.handler = (path, _) async {
      if (path.endsWith('/room/leave')) {
        started.complete();
        return pending.future;
      }
      return transport.response(path);
    };
    var finished = false;
    final closing = adapter.prepareDesktopExit().then((value) {
      finished = true;
      return value;
    });
    await started.future;
    expect(finished, isFalse);
    expect(room.active, isTrue);
    pending.complete({});
    expect(await closing, isTrue);
    expect(room.active, isFalse);
  });

  test(
    'failed desktop exit preserves the room and displays a retryable error',
    () async {
      final transport = HostTransport();
      final room = newSession(transport);
      final adapter = WatchroomAdapter.instance;
      addTearDown(() async {
        await room.leave();
        adapter.session = null;
      });
      await room.create(90, 91);
      adapter.session = room;
      transport.handler = (path, _) async {
        if (path.endsWith('/room/leave'))
          throw const RoomApiException(-400, '请求错误');
        return transport.response(path);
      };
      var notice = '';
      expect(
        await adapter.prepareDesktopExit(
          onError: (message) => notice = message,
        ),
        isFalse,
      );
      expect(notice, contains('-400'));
      expect(room.active, isTrue);
      transport.handler = null;
      expect(await adapter.prepareDesktopExit(), isTrue);
      expect(room.active, isFalse);
    },
  );
}
