import 'dart:async';

import 'package:PiliPlus/features/watchroom/model.dart';
import 'package:PiliPlus/features/watchroom/session.dart';
import 'package:flutter_test/flutter_test.dart';

const signedShare =
    'https://m.bilibili.com/bangumi/theatre/invite?roomid=12345&invitemid=7&seasonid=90&epid=91&token=server-issued-test-grant';

class InvitationTransport implements RoomTransport {
  final calls = <({String path, Map<String, dynamic> parameters})>[];
  Future<Map<String, dynamic>> Function()? season;

  @override
  Future<Map<String, dynamic>> call(
    String path, {
    bool post = false,
    Map<String, dynamic> parameters = const {},
  }) async {
    calls.add((path: path, parameters: parameters));
    if (path == 'pgc/view/web/freya/season') {
      if (season != null) return season!();
      return {
        'room_info': {
          'room_id': 12345,
          'oid': 90,
          'sub_id': 91,
          'is_open': 0,
          'share_url': signedShare,
        },
      };
    }
    if (path.endsWith('/create')) return {'room_id': 12345};
    if (path.endsWith('/join') || path.endsWith('/info')) {
      return {
        'room_id': 12345,
        'mid': 7,
        'season_id': 90,
        'episode_id': 91,
        'status': {'status': 1, 'progress': 12},
        'share_url': 'https://www.bilibili.com/watchroom/12345',
      };
    }
    return {};
  }
}

RoomSession makeRoom(InvitationTransport transport) => RoomSession(
  transport: transport,
  mid: 7,
  buvid: 'test',
  realtime: false,
);

void main() {
  test(
    'bare create and room info acquire the official nested season invitation',
    () async {
      final transport = InvitationTransport();
      final created = makeRoom(transport);
      addTearDown(created.leave);
      await created.create(90, 91);
      expect(created.invitation?.token, isNull);
      final invite = await created.invitationForShare();
      expect(invite.roomId, 12345);
      expect(invite.inviter, '7');
      expect(invite.token, 'server-issued-test-grant');
      final call = transport.calls.singleWhere(
        (call) => call.path == 'pgc/view/web/freya/season',
      );
      expect(call.parameters, {
        'room_id': 12345,
        'season_id': 90,
        'ep_id': 91,
        'platform': 'web',
      });
      await created.invitationForShare();
      expect(
        transport.calls.where(
          (call) => call.path == 'pgc/view/web/freya/season',
        ),
        hasLength(1),
      );
    },
  );

  test(
    'missing private credentials fail instead of returning a bare room URL',
    () async {
      final transport = InvitationTransport()
        ..season = () async => {
          'room_info': {
            'room_id': 12345,
            'is_open': 0,
            'share_url': 'https://www.bilibili.com/watchroom/12345',
          },
        };
      final room = makeRoom(transport);
      addTearDown(room.leave);
      await room.create(90, 91);
      await expectLater(
        room.invitationForShare(),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('私密'),
          ),
        ),
      );
      expect(room.invitation?.token, isNull);
    },
  );

  test('explicit public rooms may share an unsigned URL', () async {
    final transport = InvitationTransport()
      ..season = () async => {
        'room_info': {'room_id': 12345, 'is_open': 1},
      };
    final room = makeRoom(transport);
    addTearDown(room.leave);
    await room.create(90, 91);
    expect((await room.invitationForShare()).roomId, 12345);
  });

  test('metadata for another room is rejected', () async {
    final transport = InvitationTransport()
      ..season = () async => {
        'room_info': {'room_id': 99999, 'is_open': 0, 'share_url': signedShare},
      };
    final room = makeRoom(transport);
    addTearDown(room.leave);
    await room.create(90, 91);
    await expectLater(room.invitationForShare(), throwsFormatException);
  });

  test(
    'an invitation fetched after leaving cannot be copied as the current room',
    () async {
      final pending = Completer<Map<String, dynamic>>();
      final transport = InvitationTransport()..season = () => pending.future;
      final room = makeRoom(transport);
      addTearDown(room.leave);
      await room.create(90, 91);
      final invitation = room.invitationForShare();
      final rejected = expectLater(invitation, throwsStateError);
      await room.leave();
      pending.complete({
        'room_info': {'room_id': 12345, 'share_url': signedShare},
      });
      await rejected;
      expect(room.invitation, isNull);
    },
  );

  test(
    'a complete accepted invitation needs no extra season request',
    () async {
      final transport = InvitationTransport();
      final joined = makeRoom(transport);
      addTearDown(joined.leave);
      await joined.join(RoomInvite.parse(signedShare));
      expect(
        (await joined.invitationForShare()).token,
        'server-issued-test-grant',
      );
      expect(
        transport.calls.where(
          (call) => call.path == 'pgc/view/web/freya/season',
        ),
        isEmpty,
      );
    },
  );
}
