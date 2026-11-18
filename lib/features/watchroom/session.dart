import 'dart:async';

import 'model.dart';
import 'vega.dart';
import 'wire.dart';

abstract interface class RoomTransport {
  Future<Map<String, dynamic>> call(
    String path, {
    bool post = false,
    Map<String, dynamic> parameters = const {},
  });
}

class RoomPlayer {
  final String identity;
  final int episodeId, seasonId;
  final Duration Function() position;
  final bool Function() playing;
  final Future<void> Function() play, pause;
  final Future<void> Function(Duration) seek;
  const RoomPlayer({
    required this.identity,
    required this.episodeId,
    required this.seasonId,
    required this.position,
    required this.playing,
    required this.play,
    required this.pause,
    required this.seek,
  });
}

class RoomSession {
  final RoomTransport transport;
  final int mid;
  final String buvid;
  final String Function()? currentBuvid;
  final Future<void> Function(int seasonId, int episodeId)? openEpisode;
  final bool realtime;
  final DateTime Function() now;
  final _changes = StreamController<void>.broadcast(sync: true);
  Stream<void> get changes => _changes.stream;
  RoomSnapshot? room;
  RoomInvite? invitation;
  RoomPlayer? _player;
  RoomPlayer? _confirmedHostPlayer;
  RoomVega? _vega;
  Timer? _poll, _heartbeat, _retry, _publishDebounce;
  Timer? _hostSync, _hostConfirmation;
  int _generation = 0, _revision = 0, _retryCount = 0;
  int _controlRevision = 0, _episodeRevision = 0;
  Future<void> _writeTail = Future<void>.value();
  Future<void>? _exitPending;
  bool exiting = false;
  bool busy = false, followHost = true, controlRoom = false;
  bool _refreshing = false,
      _applying = false,
      _applyAgain = false,
      _publishing = false;
  int? _requestedEpisode;
  String connection = '未加入', error = '';
  String playbackError = '';
  final List<RoomChat> messages = [];
  final Set<String> _messageIds = {};
  bool get active => room != null;
  bool get isOwner => room?.ownerId == mid;
  bool get canControl => !exiting && isOwner && controlRoom;
  bool get playerAttached =>
      room != null &&
      _player?.episodeId == room!.episodeId &&
      _player?.seasonId == room!.seasonId;

  ({Duration position, bool playing})? playbackFor(int? episode) {
    final snapshot = room;
    if (snapshot == null || episode == null || episode <= 0) return null;
    if (episode != snapshot.episodeId) {
      return canControl ? (position: Duration.zero, playing: true) : null;
    }
    return (position: snapshot.targetAt(now()), playing: snapshot.playing);
  }

  RoomInvite get shareInvite {
    final snapshot = room;
    if (snapshot == null) throw StateError('请先加入放映室');
    return RoomInvite(
      snapshot.roomId,
      seasonId: snapshot.seasonId,
      episodeId: snapshot.episodeId,
      inviter: invitation?.inviter,
      token: invitation?.token,
      roomMode: invitation?.roomMode ?? 0,
    );
  }

  bool _completeInvitation(RoomInvite? invite) =>
      (invite?.inviter?.isNotEmpty ?? false) &&
      (invite?.token?.isNotEmpty ?? false);

  Future<RoomInvite> invitationForShare() async {
    final snapshot = room, generation = _generation;
    if (snapshot == null) throw StateError('请先加入放映室');
    if (_completeInvitation(invitation)) return shareInvite;
    // The web player obtains the signed invitation from the season response,
    // not from create/join/basic room info. Never invent a private share URL.
    final data = await transport.call(
      'pgc/view/web/freya/season',
      parameters: {
        'room_id': snapshot.roomId,
        'season_id': snapshot.seasonId,
        'ep_id': snapshot.episodeId,
        'platform': 'web',
      },
    );
    if (!_current(generation) || room!.roomId != snapshot.roomId) {
      throw StateError('房间已切换，请重新复制邀请');
    }
    final details = roomMap(data['room_info']);
    if (details.isEmpty ||
        (details.containsKey('room_id') &&
            roomInt(details['room_id']) != snapshot.roomId)) {
      throw const FormatException('未能取得当前放映室的邀请信息，请稍后重试');
    }
    final candidate = _withInvitation(details, shareInvite);
    if (!_completeInvitation(candidate) && roomInt(details['is_open']) != 1) {
      throw StateError('未能取得私密房间的完整邀请链接，请稍后重试');
    }
    invitation = candidate;
    _notify();
    return shareInvite;
  }

  RoomSession({
    required this.transport,
    required this.mid,
    required this.buvid,
    this.currentBuvid,
    this.openEpisode,
    this.realtime = true,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  void _notify() {
    if (!_changes.isClosed) _changes.add(null);
  }

  bool _current(int generation) =>
      generation == _generation && room != null && !exiting;

  RoomInvite _withInvitation(Map<String, dynamic> data, RoomInvite fallback) {
    try {
      final official = RoomInvite.parse('${data['share_url'] ?? ''}');
      if (official.roomId == fallback.roomId && _completeInvitation(official)) {
        return official;
      }
    } on FormatException {
      // A partial share URL must not discard a working private invitation.
    }
    return fallback;
  }

  Future<void> _write(Future<void> Function() action) async {
    final previous = _writeTail;
    final done = Completer<void>();
    _writeTail = done.future;
    await previous;
    try {
      await action();
    } finally {
      done.complete();
    }
  }

  Future<void> join(RoomInvite invite) async {
    if (exiting) throw StateError('正在退出放映厅，请稍候再加入');
    final leaving = leave();
    final generation = _generation;
    await leaving;
    if (generation != _generation) return;
    await _enter(invite, generation);
  }

  Future<void> _enter(RoomInvite invite, int generation) async {
    busy = true;
    error = '';
    connection = '正在加入';
    _notify();
    try {
      var data = await transport.call(
        'pgc/freya/web/room/join',
        post: true,
        parameters: {
          'room_id': invite.roomId,
          'platform': 'web',
          if (invite.inviter != null) 'mid': invite.inviter,
          if (invite.token != null) 'token': invite.token,
        },
      );
      if (generation != _generation) return;
      final joinedInvite = _withInvitation(data, invite);
      // Joining can return only the room IDs. Fetch the authoritative timeline
      // before opening a cold player rather than briefly starting at zero.
      final details = await transport.call(
        'pgc/freya/web/room/info',
        parameters: {
          'room_id': invite.roomId,
          'platform': 'web',
        },
      );
      if (generation != _generation) return;
      data = {...data, ...details};
      final snapshot = RoomSnapshot.fromJson(data, now());
      if (snapshot.roomId != invite.roomId ||
          snapshot.episodeId <= 0 ||
          snapshot.seasonId <= 0) {
        throw const FormatException('官方接口没有返回完整的房间和剧集信息');
      }
      room = snapshot;
      invitation = _withInvitation(details, joinedInvite);
      _revision++;
      connection = '已加入，正在连接同步';
      _poll = Timer.periodic(const Duration(seconds: 5), (_) {
        unawaited(refresh());
      });
      _hostSync = Timer.periodic(const Duration(seconds: 1), (_) {
        _reconcileHostPlayback();
      });
      _heartbeat = Timer.periodic(const Duration(seconds: 30), (_) {
        unawaited(_sendHeartbeat(generation));
      });
      unawaited(_sendHeartbeat(generation));
      unawaited(_firstMessages(generation));
      if (realtime) unawaited(_connect(generation));
      _notify();
    } catch (e) {
      if (generation == _generation) {
        error = '$e';
        connection = '加入失败';
        _notify();
      }
      rethrow;
    } finally {
      if (generation == _generation) {
        busy = false;
        _notify();
      }
    }
  }

  Future<void> create(int seasonId, int episodeId) async {
    if (exiting) throw StateError('正在退出放映厅，请稍候再创建');
    if (seasonId <= 0 || episodeId <= 0)
      throw const FormatException('请先选择番剧和剧集');
    final leaving = leave();
    final generation = _generation;
    await leaving;
    if (generation != _generation) return;
    busy = true;
    connection = '正在创建';
    _notify();
    try {
      final data = await transport.call(
        'pgc/freya/web/room/create',
        post: true,
        parameters: {
          'season_id': seasonId,
          'episode_id': episodeId,
          'is_open': 0,
          'platform': 'web',
        },
      );
      if (generation != _generation) return;
      final id = roomInt(data['room_id']);
      if (id <= 0) throw const FormatException('官方接口没有返回房间号');
      await _enter(
        _withInvitation(
          data,
          RoomInvite(id, seasonId: seasonId, episodeId: episodeId),
        ),
        generation,
      );
      if (!_current(generation)) return;
      controlRoom = isOwner;
      _notify();
    } catch (e) {
      if (generation == _generation) {
        error = '$e';
        connection = '创建失败';
        _notify();
      }
      rethrow;
    } finally {
      if (generation == _generation) {
        busy = false;
        _notify();
      }
    }
  }

  Future<void> _connect(int generation) async {
    RoomVega? channel;
    try {
      if (!_current(generation)) return;
      final node = await transport.call(
        'pgc/vega/deneb/nodes/get',
        parameters: {'platform': 'web'},
      );
      final token = await transport.call(
        'pgc/vega/deneb/token/web/get',
        parameters: {'vega_abtest': 2},
      );
      if (!_current(generation)) return;
      channel = RoomVega(
        onEvent: (event) {
          if (_current(generation)) acceptEvent(event);
        },
        onDisconnected: () {
          if (_current(generation)) _scheduleReconnect(generation);
        },
      );
      _vega = channel;
      await channel.connect(
        url: '${node['url'] ?? ''}',
        token: '${token['token'] ?? ''}',
        buvid: currentBuvid?.call() ?? buvid,
        roomId: room!.roomId,
      );
      if (!_current(generation) || _vega != channel) {
        await channel.close();
        return;
      }
      _retryCount = 0;
      connection = '实时同步';
      _notify();
      await refresh();
    } catch (_) {
      await channel?.close();
      if (_current(generation)) _scheduleReconnect(generation);
    }
  }

  void _scheduleReconnect(int generation) {
    if (!_current(generation) || (_retry?.isActive ?? false)) return;
    connection = '推送重连中，使用定时同步';
    _notify();
    final delay = [2, 4, 8, 15, 30][_retryCount.clamp(0, 4)];
    _retryCount++;
    _retry = Timer(Duration(seconds: delay), () {
      unawaited(_connect(generation));
    });
  }

  Future<void> refresh() async {
    if (!active || exiting || _refreshing) return;
    final generation = _generation, revision = _revision, roomId = room!.roomId;
    _refreshing = true;
    try {
      final data = await transport.call(
        'pgc/freya/web/room/info',
        parameters: {'room_id': roomId, 'platform': 'web'},
      );
      if (!_current(generation) || revision != _revision) return;
      final snapshot = RoomSnapshot.fromJson(data, now());
      if (snapshot.roomId != roomId || snapshot.episodeId <= 0) return;
      room = snapshot;
      invitation = _withInvitation(data, invitation ?? RoomInvite(roomId));
      _revision++;
      error = '';
      if (!isOwner) controlRoom = false;
      _notify();
      _reconcileHostPlayback();
      await _applyRemote();
    } catch (e) {
      if (_current(generation)) {
        if (e is RoomApiException && e.code == 6006079) {
          await leave();
          error = '当前放映厅已结束，请重新加入或创建';
          _notify();
          return;
        }
        error = '$e';
        _notify();
      }
    } finally {
      if (generation == _generation) _refreshing = false;
    }
  }

  Future<void> _sendHeartbeat(int generation) async {
    if (!_current(generation)) return;
    try {
      await _write(() async {
        if (!_current(generation)) return;
        final snapshot = room!;
        await transport.call(
          'pgc/freya/web/room/heartbeat',
          post: true,
          parameters: {
            'room_id': snapshot.roomId,
            'mid': mid,
            'season_id': snapshot.seasonId,
            'episode_id': snapshot.episodeId,
            'type': isOwner ? 1 : 0,
            'play_status': playerAttached && (_player?.playing() ?? false)
                ? 1
                : 0,
            'buvid': currentBuvid?.call() ?? buvid,
            'ts': now().millisecondsSinceEpoch,
          },
        );
      });
    } catch (e) {
      if (_current(generation)) {
        error = '$e';
        _notify();
      }
    }
  }

  Future<void> _firstMessages(int generation) async {
    try {
      final data = await transport.call(
        'pgc/freya/web/im/msg/first_tips',
        parameters: {'room_id': room!.roomId, 'start_seq_id': 0},
      );
      if (!_current(generation)) return;
      for (final value in data['msg_list'] as List? ?? []) {
        _addChat(RoomChat.fromJson(roomMap(value)));
      }
    } catch (_) {
      /* Chat history is optional; playback remains available. */
    }
  }

  void acceptEvent(RoomProto event) {
    if (exiting) return;
    final snapshot = room;
    if (snapshot == null || event.integer(1) != snapshot.roomId) return;
    _revision++;
    if (event.has(4)) {
      final members = event.nested(4);
      room = snapshot.membership(members.integer(2), [
        for (final member in members.messages(3))
          RoomMember(member.integer(1), member.string(3)),
      ]);
      if (!isOwner) controlRoom = false;
    } else if (event.has(5)) {
      final progress = event.nested(5);
      room = snapshot.progress(
        season: progress.integer(2),
        episode: progress.integer(3),
        state: progress.integer(4),
        position: Duration(seconds: progress.integer(5)),
        at: now(),
      );
      _reconcileHostPlayback();
      unawaited(_applyRemote());
    } else if (event.has(7)) {
      final value = event.nested(7),
          user = value.nested(8),
          message = value.nested(7);
      _addChat(
        RoomChat(
          value.string(9).isEmpty ? '${value.integer(2)}' : value.string(9),
          user.string(3).isEmpty ? '系统' : user.string(3),
          RoomChat.content(message.string(1)),
        ),
      );
    } else if (event.has(8)) {
      final value = event.nested(8);
      final id = value.string(4).isEmpty
          ? '${value.integer(2)}'
          : value.string(4);
      messages.removeWhere((message) => message.id == id);
    } else if (event.has(9) || event.has(17)) {
      unawaited(
        leave().then((_) {
          error = '放映室已结束，请重新加入其他房间';
          _notify();
        }),
      );
    }
    _notify();
  }

  void _addChat(RoomChat message) {
    if (message.text.isEmpty ||
        (message.id.isNotEmpty && !_messageIds.add(message.id)))
      return;
    messages.add(message);
    if (messages.length > 200) {
      final removed = messages.removeAt(0);
      _messageIds.remove(removed.id);
    }
    _notify();
  }

  Future<void> sendText(String text) async {
    text = text.trim();
    if (!active || exiting || text.isEmpty) return;
    if (text.runes.length > 233) throw const FormatException('文字消息最多 233 字');
    final generation = _generation;
    final data = await transport.call(
      'pgc/freya/web/im/msg/send',
      post: true,
      parameters: {
        'room_id': room!.roomId,
        'content_type': 0,
        'content': {'text': text},
        'req_id': now().millisecondsSinceEpoch,
        'platform': 'web',
      },
    );
    if (_current(generation))
      _addChat(RoomChat('${data['id'] ?? ''}', '我', text));
  }

  Future<void> bindPlayer(RoomPlayer player) async {
    if (!active || exiting) return;
    final generation = _generation;
    _player = player;
    _confirmedHostPlayer = null;
    if (!playerAttached && canControl) {
      try {
        await changeEpisode(player.seasonId, player.episodeId);
      } catch (e) {
        if (_current(generation) && _player == player) {
          playbackError = '当前剧集未能同步到放映厅：$e。房间仍在原影片，已停止同步当前视频的播放操作。';
          _notify();
        }
        rethrow;
      }
      if (!_current(generation) ||
          _player != player ||
          !canControl ||
          !playerAttached)
        return;
      _confirmedHostPlayer = player;
      playbackError = '';
      _publishDebounce?.cancel();
      await _publish(generation);
    } else {
      if (playerAttached && canControl) _confirmedHostPlayer = player;
      if (playerAttached) playbackError = '';
      await _applyRemote();
    }
    if (_current(generation) && _player == player && canControl) {
      _reconcileHostPlayback();
      _confirmHostPlayback(generation, player);
    }
    _notify();
  }

  void unbindPlayer(String identity) {
    if (_player?.identity == identity) {
      _hostConfirmation?.cancel();
      _player = null;
      _confirmedHostPlayer = null;
      _notify();
    }
  }

  Future<void> publishPlayerState() => _publish(_generation);

  /// Returning to the app keeps membership, but the host must explicitly
  /// publish the final pause even if the native engine is disposed at once.
  Future<void> parkPlayer(String identity) async {
    final player = _player, snapshot = room;
    if (player == null || player.identity != identity || snapshot == null)
      return;
    final position = player.position();
    final generation = _generation, control = _controlRevision;
    final publish =
        canControl && playerAttached && _confirmedHostPlayer == player;
    _hostConfirmation?.cancel();
    _publishDebounce?.cancel();
    _player = null;
    _confirmedHostPlayer = null;
    if (publish) {
      room = snapshot.progress(
        season: snapshot.seasonId,
        episode: snapshot.episodeId,
        state: 0,
        position: position,
        at: now(),
      );
      _revision++;
    }
    _notify();
    if (!publish) return;
    try {
      await _write(() async {
        if (!_current(generation) ||
            !canControl ||
            control != _controlRevision ||
            _player != null ||
            room!.episodeId != snapshot.episodeId)
          return;
        await transport.call(
          'pgc/freya/web/room/modify/progress',
          post: true,
          parameters: {
            'room_id': snapshot.roomId,
            'status': 0,
            'progress': position.inSeconds,
            'platform': 'web',
          },
        );
      });
    } catch (e) {
      if (_current(generation)) {
        error = '$e';
        _notify();
      }
    }
  }

  Future<void> _applyRemote() async {
    if (!active || exiting || canControl || !followHost || _player == null)
      return;
    if (_applying) {
      _applyAgain = true;
      return;
    }
    _applying = true;
    final generation = _generation;
    try {
      do {
        _applyAgain = false;
        final player = _player, snapshot = room;
        if (!_current(generation) ||
            player == null ||
            snapshot == null ||
            canControl ||
            !followHost)
          break;
        if (player.episodeId != snapshot.episodeId ||
            player.seasonId != snapshot.seasonId) {
          if (_requestedEpisode != snapshot.episodeId) {
            _requestedEpisode = snapshot.episodeId;
            await openEpisode?.call(snapshot.seasonId, snapshot.episodeId);
          }
          break;
        }
        _requestedEpisode = null;
        final target = snapshot.targetAt(now());
        if (!snapshot.playing && player.playing()) await player.pause();
        if (!_current(generation) || _player != player) break;
        if ((player.position() - target).abs() >
            const Duration(milliseconds: 1200))
          await player.seek(target);
        if (!_current(generation) || _player != player) break;
        if (snapshot.playing && !player.playing()) await player.play();
      } while (_applyAgain);
    } catch (e) {
      if (_current(generation)) {
        error = '$e';
        _notify();
      }
    } finally {
      _applying = false;
      if (_applyAgain && active) {
        _applyAgain = false;
        unawaited(_applyRemote());
      }
    }
  }

  void observeLocal(String action) {
    if (!active || exiting || _applying || !playerAttached) return;
    if (!canControl) {
      if (action == 'pause' || action == 'seek') followHost = false;
      if (action == 'play') {
        followHost = true;
        unawaited(_applyRemote());
      }
      _notify();
      return;
    }
    _queuePublish();
  }

  void observeHostPlaybackState() {
    if (active && canControl && playerAttached) _queuePublish();
  }

  void _reconcileHostPlayback() {
    final player = _player, snapshot = room;
    if (!canControl ||
        !playerAttached ||
        player == null ||
        snapshot == null ||
        _confirmedHostPlayer != player)
      return;
    // Local playback is authoritative for the controlling host. A delayed
    // season reset/echo must not leave members paused while the engine plays.
    if (player.playing() != snapshot.playing ||
        (player.position() - snapshot.targetAt(now())).abs() >
            const Duration(seconds: 2)) {
      _queuePublish();
    }
  }

  void _confirmHostPlayback(
    int generation,
    RoomPlayer player, {
    int remaining = 2,
  }) {
    _hostConfirmation?.cancel();
    // Confirm at 1s and 3s: a successful progress response can precede the
    // server's delayed episode reset, and realtime delivery is not guaranteed.
    _hostConfirmation = Timer(
      Duration(seconds: remaining == 2 ? 1 : 2),
      () async {
        if (!_current(generation) || _player != player || !canControl) return;
        await refresh();
        if (remaining > 1 &&
            _current(generation) &&
            _player == player &&
            canControl) {
          _confirmHostPlayback(generation, player, remaining: remaining - 1);
        }
      },
    );
  }

  void _queuePublish() {
    _publishDebounce?.cancel();
    final generation = _generation;
    _publishDebounce = Timer(const Duration(milliseconds: 180), () {
      unawaited(_publish(generation));
    });
  }

  Future<void> _publish(int generation) async {
    if (!_current(generation) ||
        !canControl ||
        !playerAttached ||
        _confirmedHostPlayer != _player)
      return;
    if (_publishing) {
      _queuePublish();
      return;
    }
    _publishing = true;
    final control = _controlRevision;
    try {
      await _write(() async {
        if (!_current(generation) ||
            !canControl ||
            !playerAttached ||
            _confirmedHostPlayer != _player ||
            control != _controlRevision)
          return;
        final player = _player!, snapshot = room!, revision = _revision;
        final position = player.position(), status = player.playing() ? 1 : 0;
        await transport.call(
          'pgc/freya/web/room/modify/progress',
          post: true,
          parameters: {
            'room_id': snapshot.roomId,
            'status': status,
            'progress': position.inSeconds,
            'platform': 'web',
          },
        );
        if (!_current(generation) ||
            _player != player ||
            revision != _revision ||
            control != _controlRevision ||
            !canControl)
          return;
        room = snapshot.progress(
          season: snapshot.seasonId,
          episode: snapshot.episodeId,
          state: status,
          position: position,
          at: now(),
        );
        _revision++;
        error = '';
        _notify();
      });
    } catch (e) {
      if (_current(generation) && control == _controlRevision) {
        error = '$e';
        _notify();
      }
    } finally {
      if (generation == _generation) _publishing = false;
    }
  }

  Future<void> setControl(bool enabled) async {
    if (exiting) return;
    if (!isOwner && enabled) throw StateError('只有房主账号可以控制房间');
    final generation = _generation, control = ++_controlRevision;
    _publishDebounce?.cancel();
    _hostConfirmation?.cancel();
    // Align before resuming publication so an old local timeline cannot be
    // broadcast to the other room members.
    controlRoom = false;
    followHost = true;
    await _applyRemote();
    if (!_current(generation) || control != _controlRevision) return;
    controlRoom = enabled && isOwner;
    _confirmedHostPlayer = controlRoom && playerAttached ? _player : null;
    _notify();
  }

  Future<void> setFollow(bool enabled) async {
    followHost = enabled;
    _notify();
    if (enabled) await _applyRemote();
  }

  Future<void> changeEpisode(int seasonId, int episodeId) async {
    if (!canControl || seasonId <= 0 || episodeId <= 0) return;
    final generation = _generation,
        control = _controlRevision,
        episode = ++_episodeRevision;
    try {
      await _write(() async {
        if (!_current(generation) ||
            !canControl ||
            control != _controlRevision ||
            episode != _episodeRevision)
          return;
        await transport.call(
          'pgc/freya/web/room/modify/season',
          post: true,
          parameters: {
            'room_id': room!.roomId,
            'season_id': seasonId,
            'episode_id': episodeId,
            'platform': 'web',
          },
        );
        if (!_current(generation) ||
            !canControl ||
            control != _controlRevision ||
            episode != _episodeRevision)
          return;
        room = room!.progress(
          season: seasonId,
          episode: episodeId,
          state: 0,
          position: Duration.zero,
          at: now(),
        );
        _revision++;
        error = '';
        _notify();
        _queuePublish();
      });
    } catch (e) {
      if (_current(generation) &&
          control == _controlRevision &&
          episode == _episodeRevision) {
        error = '$e';
        _notify();
      }
      rethrow;
    }
  }

  /// Explicit membership exit is independent of playback publication. The
  /// Android client's ChatRoomOperationService.leaveRoom uses this endpoint;
  /// is_com=0 is the ordinary PGC room (the common room uses type 8).
  Future<void> exit() =>
      _exitPending ??= _exitRoom().whenComplete(() => _exitPending = null);

  Future<void> _exitRoom() async {
    final snapshot = room, generation = _generation;
    if (snapshot == null) return;
    exiting = true;
    _controlRevision++;
    _episodeRevision++;
    _publishDebounce?.cancel();
    _hostConfirmation?.cancel();
    connection = '正在退出';
    error = '';
    _notify();
    try {
      // Drain a heartbeat/progress request already on the wire. Queued writes
      // check _current again and are suppressed while this request is pending.
      await _write(() async {
        if (generation != _generation || room?.roomId != snapshot.roomId)
          return;
        await transport.call(
          'pgc/freya/room/leave',
          post: true,
          parameters: {'room_id': snapshot.roomId, 'is_com': 0},
        );
      });
      if (generation != _generation || room?.roomId != snapshot.roomId) return;
      await leave();
    } catch (e) {
      if (generation == _generation && room?.roomId == snapshot.roomId) {
        exiting = false;
        connection = '退出失败，仍在房间';
        error = '退出放映厅失败：$e';
        _notify();
        if (realtime && _vega == null) _scheduleReconnect(generation);
      }
      rethrow;
    }
  }

  /// Local cleanup for room expiry, account changes and session replacement.
  /// Only the user-facing exit action invokes the server membership endpoint.
  Future<void> leave() async {
    _generation++;
    _controlRevision++;
    _episodeRevision++;
    _writeTail = Future<void>.value();
    _poll?.cancel();
    _hostSync?.cancel();
    _hostConfirmation?.cancel();
    _heartbeat?.cancel();
    _retry?.cancel();
    _publishDebounce?.cancel();
    final channel = _vega;
    _vega = null;
    room = null;
    invitation = null;
    _player = null;
    _confirmedHostPlayer = null;
    playbackError = '';
    _requestedEpisode = null;
    _refreshing = false;
    _publishing = false;
    _retryCount = 0;
    controlRoom = false;
    followHost = true;
    busy = false;
    exiting = false;
    error = '';
    connection = '未加入';
    messages.clear();
    _messageIds.clear();
    _notify();
    await channel?.close();
  }
}
