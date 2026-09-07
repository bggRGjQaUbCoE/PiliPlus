import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/tcp/live_frame_decoder.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
      logger.w('数据不足以解析PackageHeader');
      return null;
    }
    final byteData = ByteData.sublistView(data);

    final totalSize = byteData.getUint32(0, Endian.big);
    final headerSize = byteData.getUint16(4, Endian.big);
    final protocolVer = byteData.getUint16(6, Endian.big);
    final operationCode = byteData.getUint32(8, Endian.big);
    final seq = byteData.getUint32(12, Endian.big);

    if (headerSize < 16 || totalSize < headerSize || totalSize > data.length) {
      logger.w('PackageHeader尺寸无效');
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
  String streamToken;
  int roomId, uid;
  List<String> servers;
  final List<void Function(dynamic obj)> _eventListeners = [];
  LiveMessageStream({
    required this.streamToken,
    required this.roomId,
    required this.uid,
    required this.servers,
  });

  bool _active = true;
  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;
  Timer? _timer;
  final LiveFrameDecoderWorker _decoder = LiveFrameDecoderWorker();
  final String logTag = "LiveStreamService";

  Future<void> init() async {
    final authPackage = AuthPackage(
      header: const PackageHeader(
        protocolVer: 1,
        operationCode: 7,
        seq: 1,
      ),
      body: AuthMessage(
        roomid: roomId,
        uid: uid,
        protover: 3,
        platform: 'web',
        type: 2,
        key: streamToken,
      ),
    );

    // final marshaledData = authPackage.marshal();
    // logger.d(marshaledData);
    try {
      Future<WebSocketChannel> getSocket() async {
        for (final server in servers) {
          try {
            final channel = WebSocketChannel.connect(Uri.parse(server));
            await channel.ready;
            return channel;
          } catch (_) {}
        }
        throw Exception("all servers connect failed");
      }

      _channel = await getSocket();
      if (!_active) {
        if (kDebugMode) logger.i("$logTag init inactive $hashCode");
        close();
        return;
      }
      // logger
      //   ..d('$logTag ===> TCP连接建立')
      //   ..d('$logTag ===> 发送认证包');
      _socketSubscription = _channel?.stream.listen(
        onData,
        onDone: close,
        onError: (_) => close(),
      );
      _channel?.sink.add(authPackage.marshal());
    } catch (e) {
      SmartDialog.showToast("弹幕地址链接失败: $e");
    }
  }

  Future<void> _heartBeat() async {
    if (!_active) {
      if (kDebugMode) logger.i("$logTag init heartBeat inactive $hashCode");
      close();
      return;
    }
    if (kDebugMode) logger.i("$logTag 直播间信息流认证成功 $hashCode");
    int heartBeatCount = 1;
    _timer ??= Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_active) {
        if (kDebugMode) logger.i("$logTag heartBeat inactive $hashCode");
        timer.cancel();
        close();
        return;
      }
      if (kDebugMode) logger.i("$logTag heartBeat $hashCode");
      final package = HeartbeatPackage(
        header: PackageHeader(
          protocolVer: 1,
          operationCode: 2,
          seq: heartBeatCount,
        ),
      );
      try {
        _channel?.sink.add(package.marshal());
      } catch (_) {
        timer.cancel();
      }
      heartBeatCount++;
    });
  }

  void addEventListener(void Function(dynamic) func) {
    _eventListeners.add(func);
  }

  @pragma('vm:notify-debugger-on-exception')
  void onData(dynamic data) {
    if (data is! List<int>) return;
    final bytes = data is Uint8List ? data : Uint8List.fromList(data);
    _socketSubscription?.pause();
    _decodeFrame(bytes).whenComplete(() {
      if (_active) _socketSubscription?.resume();
    });
  }

  Future<void> _decodeFrame(Uint8List data) async {
    try {
      final result = await _decoder.decode(data);
      if (!_active) return;
      if (result.authenticated) {
        unawaited(_heartBeat());
      }
      for (final message in result.messages) {
        for (final listener in List.of(_eventListeners)) {
          listener(message);
        }
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        logger.w('$logTag frame decode failed: $error\n$stackTrace');
      }
    }
  }

  void close() {
    _active = false;
    if (kDebugMode) logger.i("$logTag close $hashCode");
    _timer?.cancel();
    _timer = null;
    _decoder.close();
    _eventListeners.clear();
    _socketSubscription?.cancel();
    _socketSubscription = null;
    _channel?.sink.close();
    _channel = null;
  }
}
