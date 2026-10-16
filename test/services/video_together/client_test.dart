import 'dart:async';

import 'package:PiliPlus/services/video_together/client.dart';
// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group('VideoTogetherClient connection ownership', () {
    test('disconnect cancels an in-flight WebSocket handshake', () async {
      final channel = _FakeWebSocketChannel();
      final client = _clientWithFactory((_) => channel);

      final connectFuture = client.connect();
      final connectionFailed = expectLater(
        connectFuture,
        throwsA(isA<StateError>()),
      );
      await Future<void>.delayed(Duration.zero);
      await client.disconnect();
      await connectionFailed;

      expect(client.isConnected, isFalse);
      expect(client.isConnecting, isFalse);
      expect(channel.sink.closeCount, 1);

      channel.completeReady();
      await Future<void>.delayed(Duration.zero);
      expect(client.isConnected, isFalse);
    });

    test('stream close fails a handshake before ready can revive it', () async {
      final channel = _FakeWebSocketChannel();
      final client = _clientWithFactory((_) => channel);

      final connecting = client.connect();
      await Future<void>.delayed(Duration.zero);
      await channel.closeIncoming();

      await expectLater(connecting, throwsA(isA<StateError>()));
      channel.completeReady();
      await Future<void>.delayed(Duration.zero);
      expect(client.isConnected, isFalse);
      expect(client.isConnecting, isFalse);
      expect(channel.sink.closeCount, 1);
    });

    test(
      'a synchronous channel factory failure clears connecting state',
      () async {
        final client = _clientWithFactory(
          (_) => throw StateError('factory failed'),
        );

        await expectLater(client.connect(), throwsA(isA<StateError>()));
        expect(client.isConnected, isFalse);
        expect(client.isConnecting, isFalse);
      },
    );

    test('a synchronous send failure does not poison the next join', () async {
      final channel = _FakeWebSocketChannel()..completeReady();
      final client = _clientWithFactory((_) => channel);
      await client.connect();

      channel.sink.throwOnAdd = true;
      await expectLater(
        client.joinRoom(roomName: 'room', password: ''),
        throwsA(isA<StateError>()),
      );

      channel.sink.throwOnAdd = false;
      final joined = client.joinRoom(roomName: 'room', password: '');
      channel.addData(
        '{"method":"/room/join","data":{"name":"room"}}',
      );
      expect((await joined).name, 'room');
      await client.disconnect();
    });

    test(
      'events from a replaced channel cannot disconnect the new one',
      () async {
        final first = _FakeWebSocketChannel()..completeReady();
        final second = _FakeWebSocketChannel()..completeReady();
        final channels = <_FakeWebSocketChannel>[first, second];
        var factoryIndex = 0;
        var disconnectedCount = 0;
        final client = _clientWithFactory(
          (_) => channels[factoryIndex++],
          onDisconnected: () => disconnectedCount += 1,
        );

        await client.connect();
        await client.disconnect();
        await client.connect();
        expect(client.isConnected, isTrue);

        first.addError(StateError('stale socket error'));
        await Future<void>.delayed(Duration.zero);

        expect(client.isConnected, isTrue);
        expect(disconnectedCount, 0);
        await client.disconnect();
      },
    );
  });
}

VideoTogetherClient _clientWithFactory(
  WebSocketChannel Function(Uri uri) factory, {
  void Function()? onDisconnected,
}) => VideoTogetherClient(
  server: 'https://example.com',
  channelFactory: factory,
  connectTimeout: const Duration(seconds: 1),
  onRoom: (_, _) {},
  onError: (_) {},
  onTextMessage: (_, _) {},
  onDisconnected: onDisconnected ?? () {},
);

final class _FakeWebSocketChannel extends StreamChannelMixin<dynamic>
    implements WebSocketChannel {
  _FakeWebSocketChannel()
    : _streamController = StreamController<dynamic>.broadcast(),
      _readyCompleter = Completer<void>(),
      sink = _FakeWebSocketSink();

  final StreamController<dynamic> _streamController;
  final Completer<void> _readyCompleter;

  @override
  final _FakeWebSocketSink sink;

  @override
  Stream<dynamic> get stream => _streamController.stream;

  @override
  Future<void> get ready => _readyCompleter.future;

  @override
  String? get protocol => null;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  void completeReady() {
    if (!_readyCompleter.isCompleted) _readyCompleter.complete();
  }

  void addError(Object error) {
    if (!_streamController.isClosed) _streamController.addError(error);
  }

  void addData(dynamic data) {
    if (!_streamController.isClosed) _streamController.add(data);
  }

  Future<void> closeIncoming() => _streamController.close();
}

final class _FakeWebSocketSink extends DelegatingStreamSink<dynamic>
    implements WebSocketSink {
  _FakeWebSocketSink() : this._(StreamController<dynamic>.broadcast());

  _FakeWebSocketSink._(this._controller) : super(_controller.sink);

  final StreamController<dynamic> _controller;
  int closeCount = 0;
  bool throwOnAdd = false;

  @override
  void add(dynamic data) {
    if (throwOnAdd) throw StateError('send failed');
    if (!_controller.isClosed) _controller.add(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    if (!_controller.isClosed) _controller.addError(error, stackTrace);
  }

  @override
  Future<void> addStream(Stream<dynamic> stream) =>
      _controller.addStream(stream);

  @override
  Future<void> get done => _controller.done;

  @override
  Future<void> close([int? closeCode, String? closeReason]) {
    closeCount += 1;
    if (_controller.isClosed) return _controller.done;
    return _controller.close();
  }
}
