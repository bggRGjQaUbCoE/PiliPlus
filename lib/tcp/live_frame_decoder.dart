import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:brotli/brotli.dart';

final class LiveFrameDecodeResult {
  const LiveFrameDecodeResult({
    required this.messages,
    required this.authenticated,
  });

  final List<dynamic> messages;
  final bool authenticated;
}

final class LiveFrameDecoder {
  static const int headerSize = 16;
  static const int maxFrameBytes = 16 * 1024 * 1024;
  static const int maxDecodedBytes = 32 * 1024 * 1024;
  static const int maxPackets = 10000;
  static const int maxCompressionDepth = 3;

  static LiveFrameDecodeResult decode(Uint8List data) {
    if (data.length > maxFrameBytes) {
      throw const FormatException('Live frame exceeds $maxFrameBytes bytes');
    }

    final messages = <dynamic>[];
    final cursors = <_FrameCursor>[_FrameCursor(data, 0)];
    var authenticated = false;
    var decodedBytes = data.length;
    var packetCount = 0;

    while (cursors.isNotEmpty) {
      final cursor = cursors.last;
      if (cursor.offset == cursor.data.length) {
        cursors.removeLast();
        continue;
      }
      if (cursor.data.length - cursor.offset < headerSize) {
        throw const FormatException('Truncated live package header');
      }
      if (++packetCount > maxPackets) {
        throw const FormatException('Live frame exceeds $maxPackets packages');
      }

      final header = ByteData.sublistView(
        cursor.data,
        cursor.offset,
        cursor.offset + headerSize,
      );
      final totalSize = header.getUint32(0, Endian.big);
      final packageHeaderSize = header.getUint16(4, Endian.big);
      final protocolVersion = header.getUint16(6, Endian.big);
      final operationCode = header.getUint32(8, Endian.big);
      if (packageHeaderSize < headerSize ||
          totalSize < packageHeaderSize ||
          totalSize > cursor.data.length - cursor.offset) {
        throw FormatException(
          'Invalid live package size: total=$totalSize, '
          'header=$packageHeaderSize',
        );
      }

      final bodyStart = cursor.offset + packageHeaderSize;
      final packageEnd = cursor.offset + totalSize;
      final body = Uint8List.sublistView(
        cursor.data,
        bodyStart,
        packageEnd,
      );
      cursor.offset = packageEnd;

      if (operationCode == 3) {
        continue;
      }
      if (operationCode == 8) {
        authenticated = true;
      }

      switch (protocolVersion) {
        case 0:
        case 1:
          if (body.isNotEmpty) {
            messages.add(jsonDecode(utf8.decode(body)));
          }
        case 2:
        case 3:
          if (cursor.depth >= maxCompressionDepth) {
            throw const FormatException(
              'Live frame exceeds compression depth $maxCompressionDepth',
            );
          }
          final List<int> decoded = protocolVersion == 2
              ? ZLibDecoder().convert(body)
              : const BrotliDecoder().convert(body);
          decodedBytes += decoded.length;
          if (decodedBytes > maxDecodedBytes) {
            throw const FormatException(
              'Decoded live frame exceeds $maxDecodedBytes bytes',
            );
          }
          cursors.add(
            _FrameCursor(
              decoded is Uint8List ? decoded : Uint8List.fromList(decoded),
              cursor.depth + 1,
            ),
          );
        default:
          throw FormatException(
            'Unsupported live protocol version: $protocolVersion',
          );
      }
    }

    return LiveFrameDecodeResult(
      messages: messages,
      authenticated: authenticated,
    );
  }
}

final class _FrameCursor {
  _FrameCursor(this.data, this.depth);

  final Uint8List data;
  final int depth;
  int offset = 0;
}

final class LiveFrameDecoderWorker {
  ReceivePort? _receivePort;
  ReceivePort? _exitPort;
  ReceivePort? _errorPort;
  Isolate? _isolate;
  SendPort? _sendPort;
  Future<void>? _starting;
  Completer<void>? _ready;
  final Map<int, Completer<LiveFrameDecodeResult>> _pending = {};
  int _nextId = 0;
  bool _closed = false;

  Future<LiveFrameDecodeResult> decode(Uint8List data) async {
    if (_closed) throw StateError('Live frame decoder is closed');
    await (_starting ??= _start());
    if (_closed || _sendPort == null) {
      throw StateError('Live frame decoder is closed');
    }

    final id = _nextId++;
    final completer = Completer<LiveFrameDecodeResult>();
    _pending[id] = completer;
    _sendPort!.send([
      id,
      TransferableTypedData.fromList([data]),
    ]);
    return completer.future;
  }

  Future<void> _start() async {
    final ready = _ready = Completer<void>();
    _receivePort = ReceivePort()
      ..listen((message) {
        if (message is SendPort) {
          _sendPort = message;
          if (!ready.isCompleted) ready.complete();
          return;
        }
        final response = message as List<dynamic>;
        final completer = _pending.remove(response[0] as int);
        if (completer == null) return;
        if (response[1] as bool) {
          completer.complete(
            LiveFrameDecodeResult(
              messages: List<dynamic>.from(response[2] as List),
              authenticated: response[3] as bool,
            ),
          );
        } else {
          completer.completeError(
            FormatException(response[2] as String),
            StackTrace.fromString(response[3] as String),
          );
        }
      });
    _exitPort = ReceivePort()..listen((_) => _failPending('exited'));
    _errorPort = ReceivePort()..listen((_) => _failPending('failed'));
    _isolate = await Isolate.spawn(
      _liveFrameDecoderEntry,
      _receivePort!.sendPort,
      debugName: 'PiliPlus live frame decoder',
      onExit: _exitPort!.sendPort,
      onError: _errorPort!.sendPort,
      errorsAreFatal: true,
    );
    if (_closed) {
      _isolate?.kill(priority: Isolate.immediate);
      if (!ready.isCompleted) ready.complete();
      return;
    }
    await ready.future;
    _ready = null;
  }

  void _failPending(String reason) {
    final error = StateError('Live frame decoder $reason');
    final ready = _ready;
    if (!_closed && ready != null && !ready.isCompleted) {
      ready.completeError(error);
    }
    for (final completer in _pending.values) {
      if (!completer.isCompleted) completer.completeError(error);
    }
    _pending.clear();
    if (!_closed) {
      _isolate = null;
      _sendPort = null;
      _starting = null;
      _ready = null;
      _receivePort?.close();
      _receivePort = null;
      _exitPort?.close();
      _exitPort = null;
      _errorPort?.close();
      _errorPort = null;
    }
  }

  void close() {
    if (_closed) return;
    _closed = true;
    final ready = _ready;
    if (ready != null && !ready.isCompleted) ready.complete();
    _failPending('closed');
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _sendPort = null;
    _receivePort?.close();
    _receivePort = null;
    _exitPort?.close();
    _exitPort = null;
    _errorPort?.close();
    _errorPort = null;
  }
}

void _liveFrameDecoderEntry(SendPort mainPort) {
  final receivePort = ReceivePort();
  mainPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    final request = message as List<dynamic>;
    final id = request[0] as int;
    try {
      final data = (request[1] as TransferableTypedData)
          .materialize()
          .asUint8List();
      final result = LiveFrameDecoder.decode(data);
      mainPort.send([id, true, result.messages, result.authenticated]);
    } catch (error, stackTrace) {
      mainPort.send([id, false, error.toString(), stackTrace.toString()]);
    }
  });
}
