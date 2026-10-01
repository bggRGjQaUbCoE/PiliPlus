import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:PiliPlus/services/logger.dart';
import 'package:brotli/brotli.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:web_socket_channel/web_socket_channel.dart';

class PackageHeader {
  final int protocolVer;
  final int operationCode;
  final int seq;

  @override
  String toString() {
    return 'PackageHeader{protocolVer: $protocolVer, operationCode: $operationCode, seq: $seq}';
  }

  const PackageHeader({
    required this.protocolVer,
    required this.operationCode,
    required this.seq,
  });

  Uint8List toBytes(int contentSize) {
    final bytes = ByteData(0x10)
      ..setInt32(0, 0x10 + contentSize, Endian.big)
      ..setInt16(4, 0x10, Endian.big)
      ..setInt16(6, protocolVer, Endian.big)
      ..setInt32(8, operationCode, Endian.big)
      ..setInt32(12, seq, Endian.big);
    return bytes.buffer.asUint8List();
  }
}

class PackageHeaderRes extends PackageHeader {
  PackageHeaderRes({
    required this.totalSize,
    required this.headerSize,
    required super.protocolVer,
    required super.operationCode,
    required super.seq,
  });
  final int totalSize;
  final int headerSize;

  static PackageHeaderRes? fromBytesData(Uint8List data) {
    if (data.length < 16) {
      return null;
    }
    final byteData = ByteData.sublistView(data);

    final totalSize = byteData.getUint32(0, Endian.big);
    final headerSize = byteData.getUint16(4, Endian.big);
    final protocolVer = byteData.getUint16(6, Endian.big);
    final operationCode = byteData.getUint32(8, Endian.big);
    final seq = byteData.getUint32(12, Endian.big);

    if (headerSize < 16 || totalSize < headerSize || totalSize > data.length) {
      return null;
    }
    return PackageHeaderRes(
      totalSize: totalSize,
      headerSize: headerSize,
      protocolVer: protocolVer,
      operationCode: operationCode,
      seq: seq,
    );
  }

  @override
  String toString() {
    return 'PackageHeaderRes{totalSize: $totalSize, headerSize: $headerSize, protocolVer: $protocolVer, operationCode: $operationCode, seq: $seq}';
  }
}

abstract class Message {
  String toJsonStr();
}

class AuthMessage implements Message {
  int roomid;
  int uid;
  int protover;
  String platform;
  int type;
  String key;

  AuthMessage({
    required this.roomid,
    required this.uid,
    required this.protover,
    required this.platform,
    required this.type,
    required this.key,
  });

  @override
  String toJsonStr() {
    final message = {
      'roomid': roomid,
      'uid': uid,
      'protover': protover,
      'platform': platform,
      'type': type,
      'key': key,
    };
    return jsonEncode(message);
  }
}

abstract class AbstractPackage<T> {
  PackageHeader header;
  T body;
  Uint8List marshal();
  AbstractPackage({required this.header, required this.body});
}

//认证包
class AuthPackage extends AbstractPackage<Message> {
  AuthPackage({required super.header, required super.body});

  @override
  Uint8List marshal() {
    final json = utf8.encode(body.toJsonStr());
    final buffer = BytesBuilder()
      ..add(header.toBytes(json.length))
      ..add(json);
    return buffer.toBytes();
  }
}

//心跳包
class HeartbeatPackage extends AbstractPackage<dynamic> {
  HeartbeatPackage({required super.header, super.body});

  @override
  Uint8List marshal() {
    return header.toBytes(0);
  }
}

class LiveMessageStream {
  LiveMessageStream({
    required this.streamToken,
    required this.roomId,
    required this.uid,
    required this.servers,
    this.onDisconnected,
    this.socketFactory = WebSocketChannel.connect,
    this.connectTimeout = const Duration(seconds: 6),
    this.authTimeout = const Duration(seconds: 10),
    this.clock = DateTime.now,
  });

  final String streamToken;
  final int roomId, uid;
  final List<String> servers;
  final void Function()? onDisconnected;
  final WebSocketChannel Function(Uri) socketFactory;
  final Duration connectTimeout;
  final Duration authTimeout;
  final DateTime Function() clock;
  final List<void Function(dynamic obj)> _eventListeners = [];
  static final _zlib = ZLibDecoder();
  bool _active = true;
  bool _disconnected = false;
  bool _authenticated = false;
  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;
  Timer? _timer;
  final _authentication = Completer<bool>();
  DateTime? _lastHeartbeatReply;
  static const String logTag = 'LiveStreamService';

  Future<bool> init() async {
    if (!_active || _disconnected) return false;
    for (final server in servers) {
      if (!_active) return false;
      WebSocketChannel? channel;
      try {
        channel = socketFactory(Uri.parse(server));
        await channel.ready.timeout(connectTimeout);
        if (!_active) {
          unawaited(channel.sink.close());
          return false;
        }
        _channel = channel;
        break;
      } catch (_) {
        // A timed out connection must not outlive the failed attempt.
        unawaited(channel?.sink.close());
      }
    }
    if (_channel == null || !_active) {
      _disconnect();
      return false;
    }
    _socketSubscription = _channel!.stream.listen(
      onData,
      onDone: _disconnect,
      onError: (_) => _disconnect(),
      cancelOnError: true,
    );
    try {
      _channel!.sink.add(
        AuthPackage(
          header: const PackageHeader(protocolVer: 1, operationCode: 7, seq: 1),
          body: AuthMessage(
            roomid: roomId,
            uid: uid,
            protover: 3,
            platform: 'web',
            type: 2,
            key: streamToken,
          ),
        ).marshal(),
      );
      final result = await _authentication.future.timeout(authTimeout);
      if (!result) _disconnect();
      return result && _active;
    } catch (_) {
      _disconnect();
      return false;
    }
  }

  void _authenticate(Uint8List body) {
    try {
      final response = jsonDecode(utf8.decode(body));
      if (response is! Map || response['code'] != 0) {
        _disconnect();
        return;
      }
      if (_authenticated || !_active) return;
      _authenticated = true;
      _lastHeartbeatReply = clock();
      if (!_authentication.isCompleted) _authentication.complete(true);
      _sendHeartbeat();
      _timer = Timer.periodic(const Duration(seconds: 30), (_) {
        if (clock().difference(_lastHeartbeatReply!) >
            const Duration(seconds: 75)) {
          _disconnect();
        } else {
          _sendHeartbeat();
        }
      });
    } catch (_) {
      _disconnect();
    }
  }

  void _sendHeartbeat() {
    if (!_active || _disconnected) return;
    try {
      _channel?.sink.add(
        HeartbeatPackage(
          header: const PackageHeader(protocolVer: 1, operationCode: 2, seq: 1),
        ).marshal(),
      );
    } catch (_) {
      _disconnect();
    }
  }

  void addEventListener(void Function(dynamic) func) {
    if (_active) _eventListeners.add(func);
  }

  /// Parse each frame independently, including concatenated and compressed
  /// packets. Truncated/invalid headers never index outside the buffer.
  void onData(dynamic data) {
    if (!_active || _disconnected) return;
    if (data is Uint8List) {
      _processPackets(data);
    } else if (data is List<int>) {
      _processPackets(Uint8List.fromList(data));
    }
  }

  void _processPackets(Uint8List data, [int depth = 0]) {
    if (depth > 2 || data.length > 16 * 1024 * 1024) return;
    var offset = 0;
    var packets = 0;
    while (_active &&
        !_disconnected &&
        offset < data.length &&
        packets++ < 10000) {
      final bytes = Uint8List.sublistView(data, offset);
      final header = PackageHeaderRes.fromBytesData(bytes);
      if (header == null) return;
      final body = Uint8List.sublistView(
        bytes,
        header.headerSize,
        header.totalSize,
      );
      offset += header.totalSize;
      if (header.operationCode == 3) {
        _lastHeartbeatReply = clock();
        continue;
      }
      if (header.operationCode == 8) {
        _authenticate(body);
        continue;
      }
      if (header.operationCode != 5 || !_authenticated) continue;
      try {
        if (header.protocolVer == 2 || header.protocolVer == 3) {
          final decoded = header.protocolVer == 2
              ? _zlib.convert(body)
              : const BrotliDecoder().convert(body);
          _processPackets(Uint8List.fromList(decoded), depth + 1);
        } else if (header.protocolVer == 0 || header.protocolVer == 1) {
          final message = jsonDecode(utf8.decode(body));
          for (final callback in List.of(_eventListeners)) {
            if (!_active || _disconnected) return;
            callback(message);
          }
        }
      } catch (_) {
        // Malformed messages are dropped without leaking token/payload data.
      }
    }
  }

  void _disconnect() {
    if (!_active || _disconnected) return;
    _disconnected = true;
    _release();
    onDisconnected?.call();
  }

  void _release() {
    _timer?.cancel();
    _timer = null;
    if (!_authentication.isCompleted) _authentication.complete(false);
    unawaited(_socketSubscription?.cancel());
    _socketSubscription = null;
    unawaited(_channel?.sink.close());
    _channel = null;
  }

  /// Intentional closure is terminal and must never request a reconnect.
  void close() {
    if (!_active) return;
    _active = false;
    if (kDebugMode) logger.i('$logTag close $hashCode');
    _release();
    _eventListeners.clear();
  }
}
