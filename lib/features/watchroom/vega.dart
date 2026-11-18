import 'dart:async';
import 'dart:io';

import 'model.dart';
import 'wire.dart';

class RoomVega {
  static const _type = 'pgc.gateway.vega.v1';
  static const _route = '/$_type.VegaFrameDoc/';
  final void Function(RoomProto) onEvent;
  final void Function() onDisconnected;
  final _pending = <String, Completer<RoomProto>>{};
  final _seen = <String>{};
  WebSocket? _socket;
  StreamSubscription<dynamic>? _subscription;
  Timer? _heartbeat;
  int _sequence = 0;
  DateTime _lastReceived = DateTime.now();
  bool _closed = false;
  RoomVega({required this.onEvent, required this.onDisconnected});

  static bool isOfficialNode(Uri uri) =>
      uri.scheme == 'wss' &&
      uri.userInfo.isEmpty &&
      const ['bilibili.com', 'biliapi.net'].any(
        (domain) => uri.host == domain || uri.host.endsWith('.$domain'),
      );

  Future<void> connect({
    required String url,
    required String token,
    required String buvid,
    required int roomId,
  }) async {
    final uri = Uri.parse(url);
    if (!isOfficialNode(uri)) {
      throw const FormatException('官方房间推送节点地址无效');
    }
    final socket = await WebSocket.connect(
      url,
      protocols: ['proto'],
      headers: {'Origin': 'https://www.bilibili.com'},
    ).timeout(const Duration(seconds: 10));
    if (_closed) {
      await socket.close();
      return;
    }
    _socket = socket;
    socket.pingInterval = const Duration(seconds: 20);
    _subscription = socket.listen(
      _receive,
      onDone: _lost,
      onError: (Object _) => _lost(),
      cancelOnError: true,
    );
    await _request(
      'Auth',
      RoomProto()
        ..text(1, buvid)
        ..text(2, token),
    );
    final subscription = RoomProto()
      ..message(
        1,
        RoomProto()
          ..text(1, 'freya')
          ..message(
            2,
            RoomProto.any('pgc.biz.RoomProto', RoomProto()..text(1, '$roomId')),
          ),
      );
    await _request('Subscribe', subscription);
    if (_closed) return;
    _lastReceived = DateTime.now();
    _heartbeat = Timer.periodic(const Duration(seconds: 20), (_) async {
      if (DateTime.now().difference(_lastReceived) >
          const Duration(seconds: 60)) {
        _lost();
        return;
      }
      try {
        await _request('Heartbeat', RoomProto());
      } catch (_) {
        _lost();
      }
    });
  }

  Future<RoomProto> _request(
    String action,
    RoomProto body, {
    bool wait = true,
  }) async {
    if (_closed || _socket == null) throw StateError('房间推送连接已关闭');
    final id = '${++_sequence}';
    final completer = Completer<RoomProto>();
    if (wait) _pending[id] = completer;
    final frame = RoomProto()
      ..message(
        1,
        RoomProto()
          ..text(2, id)
          ..number(3, _sequence),
      )
      ..text(2, '$_route$action')
      ..message(3, RoomProto.any('$_type.${action}Req', body));
    _socket!.add(frame.encode());
    if (!wait) return RoomProto();
    try {
      return await completer.future.timeout(const Duration(seconds: 8));
    } finally {
      _pending.remove(id);
    }
  }

  void _receive(dynamic bytes) {
    if (_closed || bytes is! List<int>) return;
    try {
      final frame = RoomProto.decode(bytes), options = frame.nested(1);
      _lastReceived = DateTime.now();
      if (options.integer(4) != 0) {
        final ack = RoomProto()
          ..text(
            1,
            options.string(8).isEmpty
                ? '${options.integer(1)}'
                : options.string(8),
          )
          ..text(2, '${DateTime.now().millisecondsSinceEpoch}')
          ..text(3, '1')
          ..text(4, frame.string(2))
          ..number(5, options.integer(3));
        unawaited(
          _request(
            'MessageAck',
            ack,
            wait: false,
          ).catchError((Object _) => RoomProto()),
        );
      }
      final pending = _pending.remove(options.string(2));
      final status = options.nested(5);
      if (pending != null) {
        if (status.integer(1) != 0) {
          pending.completeError(
            RoomApiException(status.integer(1), status.string(2)),
          );
        } else {
          pending.complete(frame);
        }
        return;
      }
      final id = options.string(8);
      if (id.isNotEmpty && !_seen.add(id)) return;
      if (_seen.length > 512) _seen.remove(_seen.first);
      if (frame.string(2).endsWith('FreyaEventBody'))
        onEvent(frame.nested(3).nested(2));
    } catch (_) {
      _lost();
    }
  }

  void _lost() {
    if (_closed) return;
    unawaited(close());
    onDisconnected();
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _heartbeat?.cancel();
    for (final value in _pending.values) {
      if (!value.isCompleted) value.completeError(StateError('房间推送连接已关闭'));
    }
    _pending.clear();
    await _subscription?.cancel();
    await _socket?.close();
  }
}
