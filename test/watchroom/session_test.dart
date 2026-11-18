import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:PiliPlus/features/watchroom/model.dart';
import 'package:PiliPlus/features/watchroom/session.dart';
import 'package:PiliPlus/features/watchroom/wire.dart';

Map<String, dynamic> snapshot({
  int owner = 7,
  int position = 40,
  int status = 1,
}) => {
  'room_id': 12345,
  'mid': owner,
  'season_id': 90,
  'episode_id': 91,
  'status': {'status': status, 'progress': position},
  'members': [
    {'mid': owner, 'nickname': '房主'},
  ],
};

class FakeTransport implements RoomTransport {
  final calls = <String>[];
  Future<Map<String, dynamic>> Function(String, Map<String, dynamic>)? handler;
  @override
  Future<Map<String, dynamic>> call(
    String path, {
    bool post = false,
    Map<String, dynamic> parameters = const {},
  }) async {
    calls.add(path);
    if (handler != null) return handler!(path, parameters);
    if (path.endsWith('/join') || path.endsWith('/info')) return snapshot();
    return {};
  }
}

RoomProto progress(int position, {int status = 1}) => RoomProto()
  ..number(1, 12345)
  ..message(
    5,
    RoomProto()
      ..number(1, 12345)
      ..number(2, 90)
      ..number(3, 91)
      ..number(4, status)
      ..number(5, position),
  );

void main() {
  test(
    'official mobile invitations retain the credentials needed to join',
    () async {
      final invite = RoomInvite.parse(
        'https://m.bilibili.com/bangumi/theatre/invite?roomid=12345&invitemid=7&seasonid=90&epid=91&room_mode=0&token=sample-invite',
      );
      expect(invite.roomId, 12345);
      expect(invite.seasonId, 90);
      expect(invite.episodeId, 91);
      expect(invite.uri.queryParameters['invitemid'], '7');
      expect(invite.uri.queryParameters['token'], 'sample-invite');
      expect(
        () => RoomInvite.parse(
          'https://m.bilibili.com.evil.example/bangumi/theatre/invite?roomid=12345',
        ),
        throwsFormatException,
      );
      final transport = FakeTransport()
        ..handler = (path, parameters) async {
          if (path.endsWith('/join')) {
            expect(parameters['room_id'], 12345);
            expect(parameters['mid'], '7');
            expect(parameters['token'], 'sample-invite');
          }
          return snapshot();
        };
      final room = RoomSession(
        transport: transport,
        mid: 8,
        buvid: 'test-device',
        realtime: false,
      );
      expect(room.playerAttached, isFalse);
      await room.join(invite);
      expect(room.active, isTrue);
      expect(room.playerAttached, isFalse);
      await room.leave();
    },
  );

  test(
    'invites retain private invitation parameters and reject misleading hosts',
    () {
      final invite = RoomInvite.parse(
        'https://www.bilibili.com/watchroom/12345?wepid=91&seasonid=90&invitemid=7&token=abc',
      );
      expect(invite.roomId, 12345);
      expect(invite.uri.queryParameters['token'], 'abc');
      expect(RoomInvite.parse('12345').roomId, 12345);
      expect(
        RoomInvite.parse('bilibili://pgc/room?room_id=12345&ep_id=91')
            .episodeId,
        91,
      );
      expect(
        () => RoomInvite.parse(
          'https://bilibili.com.evil.example/watchroom/12345',
        ),
        throwsFormatException,
      );
      expect(
        () => RoomInvite.parse('https://www.bilibili.com/video/BV12345'),
        throwsFormatException,
      );
    },
  );
  test('protobuf supports real Freya field numbers and rejects truncation', () {
    // room_id=12345; progress message: room=12345, season=90, ep=91,
    // status=Play(1), progress=45 seconds. These bytes use the public page schema.
    final bytes = [
      8,
      185,
      96,
      42,
      11,
      8,
      185,
      96,
      16,
      90,
      24,
      91,
      32,
      1,
      40,
      45,
    ];
    final event = RoomProto.decode(bytes);
    expect(event.integer(1), 12345);
    expect(event.nested(5).integer(5), 45);
    expect(
      RoomProto.decode([10, 1, 120, 160, 6, 1]).string(1),
      'x',
    ); // unknown field 100
    expect(() => RoomProto.decode([10, 5, 1]), throwsFormatException);
    expect(() => RoomProto.decode([0]), throwsFormatException);
    expect(() => RoomProto.decode(List.filled(12, 128)), throwsFormatException);
  });
  test(
    'playing targets advance monotonically; paused targets remain fixed',
    () {
      final at = DateTime.utc(2026, 1, 1);
      expect(
        RoomSnapshot.fromJson(
          snapshot(),
          at,
        ).targetAt(at.add(const Duration(seconds: 2))),
        const Duration(seconds: 42),
      );
      expect(
        RoomSnapshot.fromJson(
          snapshot(status: 0),
          at,
        ).targetAt(at.add(const Duration(seconds: 2))),
        const Duration(seconds: 40),
      );
      expect(
        RoomSnapshot.fromJson(
          snapshot(),
          at,
        ).targetAt(at.subtract(const Duration(seconds: 1))),
        const Duration(seconds: 40),
      );
    },
  );
  test(
    'cold player aligns with official room without echoing remote controls',
    () async {
      final transport = FakeTransport();
      final room = RoomSession(
        transport: transport,
        mid: 8,
        buvid: 'test',
        realtime: false,
      );
      addTearDown(room.leave);
      await room.join(const RoomInvite(12345));
      var position = Duration.zero, playing = false;
      await room.bindPlayer(
        RoomPlayer(
          identity: 'a',
          episodeId: 91,
          seasonId: 90,
          position: () => position,
          playing: () => playing,
          seek: (p) async {
            position = p;
            room.observeLocal('seek');
          },
          play: () async {
            playing = true;
            room.observeLocal('play');
          },
          pause: () async {
            playing = false;
            room.observeLocal('pause');
          },
        ),
      );
      expect(position.inSeconds, 40);
      expect(playing, isTrue);
      expect(room.followHost, isTrue);
      expect(
        transport.calls.where((s) => s.endsWith('/modify/progress')),
        isEmpty,
      );
      room.acceptEvent(progress(52, status: 0));
      await Future<void>.delayed(Duration.zero);
      expect(playing, isFalse);
      expect(position.inSeconds, 52);
    },
  );
  test(
    'owner joining a room on a second device starts in follow mode',
    () async {
      final room = RoomSession(
        transport: FakeTransport(),
        mid: 7,
        buvid: 'test',
        realtime: false,
      );
      addTearDown(room.leave);
      await room.join(const RoomInvite(12345));
      expect(room.isOwner, isTrue);
      expect(room.canControl, isFalse);
    },
  );
  test(
    'late HTTP snapshots cannot overwrite a newer websocket event',
    () async {
      final transport = FakeTransport();
      final room = RoomSession(
        transport: transport,
        mid: 8,
        buvid: 'test',
        realtime: false,
      );
      addTearDown(room.leave);
      await room.join(const RoomInvite(12345));
      final pending = Completer<Map<String, dynamic>>();
      transport.handler = (path, _) async =>
          path.endsWith('/info') ? pending.future : {};
      final refresh = room.refresh();
      room.acceptEvent(progress(90));
      pending.complete(snapshot(position: 20));
      await refresh;
      expect(room.room!.position.inSeconds, 90);
    },
  );
  test('leaving during join cannot resurrect the old room', () async {
    final transport = FakeTransport();
    final pending = Completer<Map<String, dynamic>>();
    transport.handler = (_, _) => pending.future;
    final room = RoomSession(
      transport: transport,
      mid: 8,
      buvid: 'test',
      realtime: false,
    );
    final joining = room.join(const RoomInvite(12345));
    await Future<void>.delayed(Duration.zero);
    await room.leave();
    pending.complete(snapshot());
    await joining;
    expect(room.active, isFalse);
    expect(room.busy, isFalse);
  });
  test(
    'chat and removal decode the official string ID and user field',
    () async {
      final room = RoomSession(
        transport: FakeTransport(),
        mid: 8,
        buvid: 'test',
        realtime: false,
      );
      addTearDown(room.leave);
      await room.join(const RoomInvite(12345));
      final event = RoomProto()
        ..number(1, 12345)
        ..message(
          7,
          RoomProto()
            ..message(7, RoomProto()..text(1, '{"text":"你好"}'))
            ..message(8, RoomProto()..text(3, '测试成员'))
            ..text(9, 'long-message-id'),
        );
      room.acceptEvent(event);
      room.acceptEvent(event);
      expect(room.messages, hasLength(1));
      expect(room.messages.single.author, '测试成员');
      expect(room.messages.single.text, '你好');
      room.acceptEvent(
        RoomProto()
          ..number(1, 12345)
          ..message(8, RoomProto()..text(4, 'long-message-id')),
      );
      expect(room.messages, isEmpty);
    },
  );
}
