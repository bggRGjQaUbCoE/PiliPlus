import 'dart:async';

import 'package:PiliPlus/features/watchroom/model.dart';
import 'package:PiliPlus/features/watchroom/session.dart';
import 'package:PiliPlus/features/watchroom/wire.dart';
import 'package:flutter_test/flutter_test.dart';

const hostInvite =
    'https://m.bilibili.com/bangumi/theatre/invite?roomid=12345&invitemid=7&seasonid=90&epid=91&token=host-grant';

class HostTransport implements RoomTransport {
  final calls = <({String path, Map<String, dynamic> parameters})>[];
  Future<Map<String, dynamic>> Function(
    String path,
    Map<String, dynamic> parameters,
  )?
  handler;
  @override
  Future<Map<String, dynamic>> call(
    String path, {
    bool post = false,
    Map<String, dynamic> parameters = const {},
  }) async {
    calls.add((path: path, parameters: Map.of(parameters)));
    if (handler != null) return handler!(path, parameters);
    return response(path);
  }

  Map<String, dynamic> response(String path) {
    if (path.endsWith('/create')) {
      return {'room_id': 12345, 'share_url': hostInvite};
    }
    if (path.endsWith('/join') || path.endsWith('/info')) {
      return {
        'room_id': 12345,
        'mid': 7,
        'season_id': 90,
        'episode_id': 91,
        'status': {'status': 1, 'progress': 40},
        'share_url': 'https://www.bilibili.com/watchroom/12345',
      };
    }
    return {};
  }
}

RoomSession newSession(HostTransport transport, {int mid = 7}) => RoomSession(
  transport: transport,
  mid: mid,
  buvid: 'host-test-device',
  realtime: false,
  now: () => DateTime.utc(2026, 11, 11),
);

final _activeSessions = <RoomSession>[];

RoomSession trackedSession(HostTransport transport, {int mid = 7}) {
  final room = newSession(transport, mid: mid);
  _activeSessions.add(room);
  return room;
}

void hostTest(String description, Future<void> Function(WidgetTester) body) {
  testWidgets(description, (tester) async {
    try {
      await body(tester);
    } finally {
      for (final room in _activeSessions) {
        await room.leave();
      }
      _activeSessions.clear();
    }
  });
}

class HostPlayer {
  Duration position = const Duration(seconds: 40);
  bool playing = true;
  RoomPlayer bind(RoomSession room, {int episodeId = 91, int seasonId = 90}) =>
      RoomPlayer(
        identity: 'host',
        seasonId: seasonId,
        episodeId: episodeId,
        position: () => position,
        playing: () => playing,
        play: () async {
          playing = true;
          room.observeLocal('play');
        },
        pause: () async {
          playing = false;
          room.observeLocal('pause');
        },
        seek: (value) async {
          position = value;
          room.observeLocal('seek');
        },
      );
}

void main() {
  for (final mid in [7, 8]) {
    hostTest(
      'explicit exit is acknowledged with publication off for member $mid',
      (tester) async {
        final transport = HostTransport(),
            pending = Completer<Map<String, dynamic>>();
        final room = trackedSession(transport, mid: mid);
        if (mid == 7) {
          await room.create(90, 91);
          await room.setControl(false);
        } else {
          await room.join(const RoomInvite(12345));
        }
        await tester.pump();
        transport.handler = (path, parameters) async {
          if (path.endsWith('/room/leave')) {
            return pending.future;
          }
          return transport.response(path);
        };
        final exit = room.exit();
        final repeated = room.exit();
        await tester.pump();
        expect(room.active, isTrue);
        expect(room.exiting, isTrue);
        expect(
          transport.calls
              .singleWhere((c) => c.path.endsWith('/room/leave'))
              .parameters,
          {'room_id': 12345, 'is_com': 0},
        );
        await tester.pump(const Duration(seconds: 30));
        expect(
          transport.calls.where((c) => c.path.endsWith('/room/leave')),
          hasLength(1),
        );
        expect(
          transport.calls.where((c) => c.path.contains('/modify/')),
          isEmpty,
        );
        pending.complete({});
        await Future.wait([exit, repeated]);
        expect(room.active, isFalse);
        final count = transport.calls.length;
        await tester.pump(const Duration(seconds: 30));
        expect(transport.calls.length, count);
      },
    );
  }

  hostTest('failed explicit exit retains membership and allows a retry', (
    tester,
  ) async {
    final transport = HostTransport();
    final room = trackedSession(transport);
    await room.create(90, 91);
    await tester.pump();
    transport.handler = (path, _) async {
      if (path.endsWith('/room/leave'))
        throw const RoomApiException(-500, '请稍后重试');
      return transport.response(path);
    };
    await expectLater(room.exit(), throwsA(isA<RoomApiException>()));
    expect(room.active, isTrue);
    expect(room.exiting, isFalse);
    expect(room.error, contains('退出放映厅失败'));
    transport.handler = null;
    await room.exit();
    expect(room.active, isFalse);
  });

  hostTest('exit drains an in-flight heartbeat before removing membership', (
    tester,
  ) async {
    final transport = HostTransport(),
        pending = Completer<Map<String, dynamic>>();
    final room = trackedSession(transport);
    await room.create(90, 91);
    await tester.pump();
    transport.calls.clear();
    transport.handler = (path, _) async {
      if (path.endsWith('/heartbeat')) return pending.future;
      return transport.response(path);
    };
    await tester.pump(const Duration(seconds: 30));
    expect(
      transport.calls.where((c) => c.path.endsWith('/heartbeat')),
      hasLength(1),
    );
    final exit = room.exit();
    await tester.pump();
    expect(
      transport.calls.where((c) => c.path.endsWith('/room/leave')),
      isEmpty,
    );
    await tester.pump(const Duration(seconds: 30));
    pending.complete({});
    await exit;
    expect(transport.calls.last.path, 'pgc/freya/room/leave');
    expect(
      transport.calls.where((c) => c.path.endsWith('/heartbeat')),
      hasLength(1),
    );
    expect(room.active, isFalse);
  });

  hostTest('a late exit response cannot clear a replacement room', (
    tester,
  ) async {
    final transport = HostTransport(),
        pending = Completer<Map<String, dynamic>>();
    final room = trackedSession(transport);
    await room.create(90, 91);
    await tester.pump();
    transport.handler = (path, _) async {
      if (path.endsWith('/room/leave')) return pending.future;
      return {
        ...transport.response(path),
        if (path.endsWith('/join') || path.endsWith('/info')) 'room_id': 67890,
      };
    };
    final exit = room.exit();
    await tester.pump();
    await room.leave();
    await room.join(const RoomInvite(67890));
    pending.complete({});
    await exit;
    expect(room.room!.roomId, 67890);
  });

  hostTest(
    'cross-season binding switches both IDs before publishing progress',
    (tester) async {
      final transport = HostTransport();
      final room = trackedSession(transport);
      await room.create(90, 91);
      final player = HostPlayer()..position = Duration.zero;
      await room.bindPlayer(player.bind(room, seasonId: 190, episodeId: 191));
      final writes = transport.calls
          .where((c) => c.path.contains('/modify/'))
          .toList();
      expect(writes.map((c) => c.path.split('/').last), ['season', 'progress']);
      expect(writes.first.parameters['season_id'], 190);
      expect(writes.first.parameters['episode_id'], 191);
      expect(writes.last.parameters['status'], 1);
      expect(room.room!.seasonId, 190);
      expect(room.room!.episodeId, 191);
      expect(room.playerAttached, isTrue);
    },
  );

  hostTest('failed cross-season switch cannot control the previous film', (
    tester,
  ) async {
    final transport = HostTransport();
    final room = trackedSession(transport);
    await room.create(90, 91);
    final player = HostPlayer();
    await room.bindPlayer(player.bind(room));
    transport.calls.clear();
    transport.handler = (path, _) async {
      if (path.endsWith('/modify/season'))
        throw const RoomApiException(6006111, '该影片暂不支持一起看');
      return transport.response(path);
    };
    await expectLater(
      room.bindPlayer(player.bind(room, seasonId: 190, episodeId: 191)),
      throwsA(isA<RoomApiException>()),
    );
    player.position = const Duration(minutes: 17);
    room.observeLocal('seek');
    room.observeHostPlaybackState();
    await room.publishPlayerState();
    await tester.pump(const Duration(seconds: 2));
    await room.refresh();
    expect(room.playbackError, contains('6006111'));
    expect(room.room!.episodeId, 91);
    expect(room.playerAttached, isFalse);
    await room.parkPlayer('host');
    expect(
      transport.calls.where((c) => c.path.endsWith('/modify/progress')),
      isEmpty,
    );
  });

  hostTest(
    'superseded episode switch never publishes the intermediate player',
    (tester) async {
      final transport = HostTransport(),
          pending = Completer<Map<String, dynamic>>();
      final room = trackedSession(transport);
      await room.create(90, 91);
      var switches = 0;
      transport.handler = (path, _) async {
        if (path.endsWith('/modify/season') && ++switches == 1)
          return pending.future;
        return transport.response(path);
      };
      final first = room.bindPlayer(
        (HostPlayer()..position = const Duration(seconds: 17)).bind(
          room,
          seasonId: 190,
          episodeId: 191,
        ),
      );
      await tester.pump();
      final second = room.bindPlayer(
        (HostPlayer()..position = Duration.zero).bind(
          room,
          seasonId: 290,
          episodeId: 291,
        ),
      );
      pending.complete({});
      await Future.wait([first, second]);
      final progress = transport.calls
          .where((c) => c.path.endsWith('/modify/progress'))
          .toList();
      expect(progress, hasLength(1));
      expect(progress.single.parameters['progress'], 0);
      expect(room.room!.episodeId, 291);
    },
  );

  hostTest('expired room stops being a resumable room after refresh', (
    tester,
  ) async {
    final transport = HostTransport();
    final room = trackedSession(transport);
    await room.create(90, 91);
    transport.handler = (path, _) async {
      if (path.endsWith('/info'))
        throw const RoomApiException(6006079, '放映室走失了');
      return transport.response(path);
    };
    await room.refresh();
    expect(room.active, isFalse);
    expect(room.error, contains('已结束'));
  });

  hostTest(
    'returning from the player publishes pause and keeps room membership',
    (tester) async {
      final transport = HostTransport();
      final room = trackedSession(transport);
      await room.create(90, 91);
      final player = HostPlayer()..position = const Duration(seconds: 123);
      await room.bindPlayer(player.bind(room));
      await room.parkPlayer('host');
      expect(room.active, isTrue);
      expect(room.canControl, isTrue);
      expect(room.playerAttached, isFalse);
      expect(room.room!.playing, isFalse);
      expect(room.room!.position, const Duration(seconds: 123));
      expect(transport.calls.last.path, endsWith('/modify/progress'));
      expect(transport.calls.last.parameters['status'], 0);
      expect(transport.calls.last.parameters['progress'], 123);
    },
  );

  hostTest(
    'returning as a guest preserves follow mode without controlling the room',
    (tester) async {
      final transport = HostTransport();
      final room = trackedSession(transport, mid: 8);
      await room.join(const RoomInvite(12345));
      await room.bindPlayer(HostPlayer().bind(room));
      await room.parkPlayer('host');
      expect(room.active, isTrue);
      expect(room.followHost, isTrue);
      expect(room.room!.playing, isTrue);
      expect(
        transport.calls.where((call) => call.path.contains('/modify/')),
        isEmpty,
      );
    },
  );

  hostTest('return pause is ordered after an in-flight playing update', (
    tester,
  ) async {
    final transport = HostTransport(),
        pending = Completer<Map<String, dynamic>>();
    final room = trackedSession(transport);
    await room.create(90, 91);
    final player = HostPlayer();
    await room.bindPlayer(player.bind(room));
    var progressWrites = 0;
    transport.handler = (path, _) async {
      if (path.endsWith('/modify/progress') && ++progressWrites == 1)
        return pending.future;
      return transport.response(path);
    };
    final playing = room.publishPlayerState();
    await tester.pump();
    player.position = const Duration(seconds: 63);
    final parking = room.parkPlayer('host');
    pending.complete({});
    await Future.wait([playing, parking]);
    expect(transport.calls.last.parameters['status'], 0);
    expect(transport.calls.last.parameters['progress'], 63);
    expect(room.room!.playing, isFalse);
  });

  hostTest(
    'creating around an existing paused player preserves its progress and state',
    (tester) async {
      final transport = HostTransport();
      final room = trackedSession(transport);
      final player = HostPlayer()
        ..position = const Duration(seconds: 123)
        ..playing = false;
      await room.create(90, 91);
      await room.bindPlayer(player.bind(room));
      await room.publishPlayerState();
      expect(player.position, const Duration(seconds: 123));
      expect(player.playing, isFalse);
      expect(transport.calls.last.parameters['progress'], 123);
      expect(transport.calls.last.parameters['status'], 0);
    },
  );

  hostTest('late server pause after a host episode switch is corrected', (
    tester,
  ) async {
    final transport = HostTransport();
    final room = trackedSession(transport);
    await room.create(90, 91);
    final player = HostPlayer()..position = const Duration(seconds: 2);
    await room.bindPlayer(player.bind(room, episodeId: 92));
    room.acceptEvent(
      RoomProto()
        ..number(1, 12345)
        ..message(
          5,
          RoomProto()
            ..number(2, 90)
            ..number(3, 92)
            ..number(4, 0)
            ..number(5, 0),
        ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(room.room!.playing, isTrue);
    expect(transport.calls.last.path, endsWith('/modify/progress'));
    expect(transport.calls.last.parameters['status'], 1);
    expect(transport.calls.last.parameters['progress'], 2);
  });

  hostTest('host startup recovers when the native playing event was missed', (
    tester,
  ) async {
    final transport = HostTransport();
    final room = trackedSession(transport);
    await room.create(90, 91);
    final player = HostPlayer()
      ..position = Duration.zero
      ..playing = false;
    await room.bindPlayer(player.bind(room, episodeId: 92));
    expect(transport.calls.last.parameters['status'], 0);
    transport.handler = (path, _) async => path.endsWith('/info')
        ? {
            ...transport.response(path),
            'episode_id': 92,
            'status': {'status': 0, 'progress': 0},
          }
        : transport.response(path);
    // The engine starts without an observable play callback, as can happen
    // while the upstream controller is still initializing the new media.
    player.playing = true;
    player.position = const Duration(seconds: 1);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 200));
    expect(transport.calls.last.parameters['status'], 1);
    expect(room.room!.playing, isTrue);
  });

  hostTest('episode startup verifies server state after the progress write', (
    tester,
  ) async {
    final transport = HostTransport();
    final room = trackedSession(transport);
    await room.create(90, 91);
    final player = HostPlayer()..position = Duration.zero;
    await room.bindPlayer(player.bind(room, episodeId: 92));
    // Simulate a successful write followed by the server's delayed season
    // reset, without any realtime event being delivered to this client.
    transport.handler = (path, _) async => path.endsWith('/info')
        ? {
            ...transport.response(path),
            'episode_id': 92,
            'status': {'status': 0, 'progress': 0},
          }
        : transport.response(path);
    player.position = const Duration(seconds: 1);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 200));
    expect(
      transport.calls.where((call) => call.path.endsWith('/info')).length,
      2,
    );
    expect(room.room!.playing, isTrue);
    expect(transport.calls.last.parameters['status'], 1);
    expect(transport.calls.last.parameters['progress'], 1);
  });

  hostTest('host reconciliation stops after publication is disabled', (
    tester,
  ) async {
    final transport = HostTransport();
    final room = trackedSession(transport);
    await room.create(90, 91);
    final player = HostPlayer()..position = Duration.zero;
    await room.bindPlayer(player.bind(room, episodeId: 92));
    await room.setControl(false);
    final count = transport.calls.length;
    player.playing = false;
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 200));
    expect(transport.calls.length, count);
  });

  hostTest('a late playing echo cannot override an intentional host pause', (
    tester,
  ) async {
    final transport = HostTransport();
    final room = trackedSession(transport);
    await room.create(90, 91);
    final player = HostPlayer()..position = const Duration(seconds: 5);
    await room.bindPlayer(player.bind(room, episodeId: 92));
    player.playing = false;
    room.observeLocal('pause');
    await tester.pump(const Duration(milliseconds: 200));
    room.acceptEvent(
      RoomProto()
        ..number(1, 12345)
        ..message(
          5,
          RoomProto()
            ..number(2, 90)
            ..number(3, 92)
            ..number(4, 1)
            ..number(5, 5),
        ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(player.playing, isFalse);
    expect(room.room!.playing, isFalse);
    expect(transport.calls.last.parameters['status'], 0);
    expect(transport.calls.last.parameters['progress'], 5);
  });

  hostTest(
    'host episode startup ignores personal history and keeps the room timeline',
    (tester) async {
      final room = trackedSession(HostTransport());
      await room.create(90, 91);
      expect(room.playbackFor(91)?.position, const Duration(seconds: 40));
      expect(room.playbackFor(92)?.position, Duration.zero);
      expect(room.playbackFor(92)?.playing, isTrue);
      await room.setControl(false);
      expect(room.playbackFor(92), isNull);
    },
  );

  hostTest(
    'new episode publishes its actual playing state without manual controls',
    (tester) async {
      final transport = HostTransport();
      final room = trackedSession(transport);
      await room.create(90, 91);
      final player = HostPlayer()..position = Duration.zero;
      await room.bindPlayer(player.bind(room, episodeId: 92));
      final writes = transport.calls
          .where((call) => call.path.contains('/modify/'))
          .toList();
      expect(writes.map((call) => call.path.split('/').last), [
        'season',
        'progress',
      ]);
      expect(writes.last.parameters['status'], 1);
      expect(writes.last.parameters['progress'], 0);
      expect(room.room!.playing, isTrue);
      expect(room.playbackFor(91)?.position, Duration.zero);
      await room.bindPlayer(player.bind(room));
      expect(room.room!.episodeId, 91);
      expect(transport.calls.last.parameters['status'], 1);
      expect(transport.calls.last.parameters['progress'], 0);
    },
  );

  hostTest(
    'late native playback start is published after the episode has loaded',
    (tester) async {
      final transport = HostTransport();
      final room = trackedSession(transport);
      await room.create(90, 91);
      final player = HostPlayer()
        ..position = Duration.zero
        ..playing = false;
      await room.bindPlayer(player.bind(room, episodeId: 92));
      expect(transport.calls.last.parameters['status'], 0);
      player.playing = true;
      room.observeHostPlaybackState();
      await tester.pump(const Duration(milliseconds: 200));
      expect(transport.calls.last.parameters['status'], 1);
      expect(room.room!.playing, isTrue);
    },
  );

  hostTest(
    'native engine events do not change guest follow mode or publish controls',
    (tester) async {
      final transport = HostTransport();
      final guest = trackedSession(transport, mid: 8);
      await guest.join(const RoomInvite(12345));
      await guest.bindPlayer(HostPlayer().bind(guest));
      guest.observeHostPlaybackState();
      await tester.pump(const Duration(milliseconds: 200));
      expect(guest.followHost, isTrue);
      expect(guest.playbackFor(92), isNull);
      expect(
        transport.calls.where((call) => call.path.contains('/modify/')),
        isEmpty,
      );
    },
  );

  hostTest('a complete join invitation survives partial room details', (
    tester,
  ) async {
    final transport = HostTransport();
    transport.handler = (path, _) async {
      if (path.endsWith('/create')) return {'room_id': 12345};
      if (path.endsWith('/join'))
        return {...transport.response(path), 'share_url': hostInvite};
      return transport.response(path);
    };
    final room = trackedSession(transport);
    await room.create(90, 91);
    expect(room.shareInvite.inviter, '7');
    expect(room.shareInvite.token, 'host-grant');
  });

  hostTest('overlapping entry requests keep the newest intent', (tester) async {
    final transport = HostTransport();
    final room = trackedSession(transport);
    final creating = room.create(90, 91);
    final joining = room.join(const RoomInvite(12345));
    await Future.wait([creating, joining]);
    expect(
      transport.calls.where((call) => call.path.endsWith('/create')),
      isEmpty,
    );
    expect(room.active, isTrue);
    expect(room.canControl, isFalse);
  });

  hostTest(
    'creating owns the room and retains its private invitation through join and refresh',
    (tester) async {
      final transport = HostTransport();
      // Use a single recorded transport for create, join, and subsequent refresh.
      final created = trackedSession(transport);
      await created.create(90, 91);
      expect(created.canControl, isTrue);
      expect(created.shareInvite.token, 'host-grant');
      final join = transport.calls.singleWhere(
        (call) => call.path.endsWith('/join'),
      );
      expect(join.parameters['token'], 'host-grant');
      await created.refresh();
      expect(created.shareInvite.token, 'host-grant');
      expect(created.shareInvite.inviter, '7');
    },
  );

  hostTest(
    'a cancelled create cannot enable control of a later owner-room join',
    (tester) async {
      final transport = HostTransport(),
          pending = Completer<Map<String, dynamic>>();
      var joins = 0;
      transport.handler = (path, _) async {
        if (path.endsWith('/join') && ++joins == 1) return pending.future;
        return transport.response(path);
      };
      final room = trackedSession(transport);
      final creating = room.create(90, 91);
      await tester.pump();
      expect(joins, 1);
      await room.leave();
      await room.join(const RoomInvite(12345));
      expect(room.canControl, isFalse);
      pending.complete(transport.response('join'));
      await creating;
      expect(room.canControl, isFalse);
      expect(room.active, isTrue);
    },
  );

  hostTest('host pause, seek, and play publish the final native state', (
    tester,
  ) async {
    final transport = HostTransport();
    final controlled = trackedSession(transport), player = HostPlayer();
    await controlled.create(90, 91);
    await controlled.bindPlayer(player.bind(controlled));
    player.playing = false;
    player.position = const Duration(seconds: 88);
    controlled.observeLocal('pause');
    controlled.observeLocal('seek');
    await tester.pump(const Duration(milliseconds: 200));
    final paused = transport.calls
        .where((call) => call.path.endsWith('/modify/progress'))
        .single;
    expect(paused.parameters['status'], 0);
    expect(paused.parameters['progress'], 88);
    player.playing = true;
    controlled.observeLocal('play');
    await tester.pump(const Duration(milliseconds: 200));
    expect(transport.calls.last.parameters['status'], 1);
  });

  hostTest('episode changes wait for an earlier progress write', (
    tester,
  ) async {
    final transport = HostTransport(),
        pending = Completer<Map<String, dynamic>>();
    final room = trackedSession(transport), player = HostPlayer();
    await room.create(90, 91);
    await room.bindPlayer(player.bind(room));
    transport.handler = (path, _) async => path.endsWith('/modify/progress')
        ? pending.future
        : transport.response(path);
    room.observeLocal('seek');
    await tester.pump(const Duration(milliseconds: 200));
    final change = room.changeEpisode(90, 92);
    await tester.pump();
    expect(
      transport.calls.where((call) => call.path.endsWith('/modify/season')),
      isEmpty,
    );
    pending.complete({});
    await change;
    final writes = transport.calls
        .where((call) => call.path.contains('/modify/'))
        .toList();
    expect(writes.map((call) => call.path.split('/').last), [
      'progress',
      'season',
    ]);
    expect(room.shareInvite.episodeId, 92);
    expect(room.shareInvite.token, 'host-grant');
  });

  hostTest(
    'rapid host episode changes keep only the newest queued request',
    (tester) async {
      final transport = HostTransport(),
          pending = Completer<Map<String, dynamic>>();
      final room = trackedSession(transport);
      await room.create(90, 91);
      transport.handler = (path, parameters) async =>
          parameters['episode_id'] == 92
          ? pending.future
          : transport.response(path);
      final first = room.changeEpisode(90, 92);
      await tester.pump();
      final second = room.changeEpisode(90, 93),
          third = room.changeEpisode(90, 94);
      await tester.pump();
      pending.complete({});
      await Future.wait([first, second, third]);
      final episodes = transport.calls
          .where((call) => call.path.endsWith('/modify/season'))
          .map((call) => call.parameters['episode_id']);
      expect(episodes, [92, 94]);
      expect(room.room!.episodeId, 94);
    },
  );

  hostTest('stopping host control invalidates an in-flight episode result', (
    tester,
  ) async {
    final transport = HostTransport(),
        pending = Completer<Map<String, dynamic>>();
    final room = trackedSession(transport);
    await room.create(90, 91);
    transport.handler = (path, _) async => path.endsWith('/modify/season')
        ? pending.future
        : transport.response(path);
    final change = room.changeEpisode(90, 92);
    await tester.pump();
    await room.setControl(false);
    pending.complete({});
    await change;
    expect(room.room!.episodeId, 91);
    expect(room.canControl, isFalse);
  });

  hostTest(
    'failed episode changes remain visible and do not block later commands',
    (tester) async {
      final transport = HostTransport();
      final controlled = trackedSession(transport);
      await controlled.create(90, 91);
      transport.handler = (path, parameters) async {
        if (parameters['episode_id'] == 92)
          throw const RoomApiException(-500, 'test rejected');
        return transport.response(path);
      };
      await expectLater(
        controlled.changeEpisode(90, 92),
        throwsA(isA<RoomApiException>()),
      );
      expect(controlled.error, contains('test rejected'));
      await controlled.changeEpisode(90, 93);
      expect(controlled.room!.episodeId, 93);
      expect(controlled.error, isEmpty);
    },
  );

  hostTest('guest cannot publish host commands', (tester) async {
    final transport = HostTransport();
    final guest = trackedSession(transport, mid: 8);
    await guest.join(const RoomInvite(12345));
    await expectLater(guest.setControl(true), throwsStateError);
    await guest.changeEpisode(90, 92);
    expect(
      transport.calls.where((call) => call.path.contains('/modify/')),
      isEmpty,
    );
  });
}
