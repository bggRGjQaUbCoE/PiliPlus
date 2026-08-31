import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:PiliPlus/tcp/live_frame_decoder.dart';
import 'package:flutter_test/flutter_test.dart';

Uint8List _packet({
  required int protocol,
  required int operation,
  required List<int> body,
}) {
  final header = ByteData(LiveFrameDecoder.headerSize)
    ..setUint32(0, LiveFrameDecoder.headerSize + body.length, Endian.big)
    ..setUint16(4, LiveFrameDecoder.headerSize, Endian.big)
    ..setUint16(6, protocol, Endian.big)
    ..setUint32(8, operation, Endian.big)
    ..setUint32(12, 1, Endian.big);
  return Uint8List.fromList([...header.buffer.asUint8List(), ...body]);
}

void main() {
  test('decodes concatenated packages in order without tail copies', () {
    final data = Uint8List.fromList([
      ..._packet(
        protocol: 0,
        operation: 5,
        body: utf8.encode('{"cmd":"first"}'),
      ),
      ..._packet(
        protocol: 0,
        operation: 5,
        body: utf8.encode('{"cmd":"second"}'),
      ),
    ]);

    final result = LiveFrameDecoder.decode(data);

    expect(result.messages, [
      {'cmd': 'first'},
      {'cmd': 'second'},
    ]);
  });

  test('iterates over thousands of concatenated packages', () {
    final builder = BytesBuilder(copy: false);
    for (var index = 0; index < 2000; index++) {
      builder.add(
        _packet(
          protocol: 0,
          operation: 5,
          body: utf8.encode('{"index":$index}'),
        ),
      );
    }

    final result = LiveFrameDecoder.decode(builder.takeBytes());

    expect(result.messages, hasLength(2000));
    expect(result.messages.first, {'index': 0});
    expect(result.messages.last, {'index': 1999});
  });

  test('decodes compressed nested packages', () {
    final nested = _packet(
      protocol: 0,
      operation: 5,
      body: utf8.encode('{"cmd":"compressed"}'),
    );
    final data = _packet(
      protocol: 2,
      operation: 5,
      body: ZLibEncoder().convert(nested),
    );

    final result = LiveFrameDecoder.decode(data);

    expect(result.messages, [
      {'cmd': 'compressed'},
    ]);
  });

  test('rejects truncated and invalid package sizes', () {
    expect(
      () => LiveFrameDecoder.decode(Uint8List(15)),
      throwsFormatException,
    );

    final invalid = _packet(
      protocol: 0,
      operation: 5,
      body: utf8.encode('{}'),
    );
    ByteData.sublistView(invalid).setUint32(0, 1024, Endian.big);
    expect(() => LiveFrameDecoder.decode(invalid), throwsFormatException);
  });

  test('persistent worker transfers and decodes frames off-isolate', () async {
    final worker = LiveFrameDecoderWorker();
    addTearDown(worker.close);
    final data = _packet(
      protocol: 1,
      operation: 8,
      body: utf8.encode('{"code":0}'),
    );

    final result = await worker.decode(data);

    expect(result.authenticated, isTrue);
    expect(result.messages, [
      {'code': 0},
    ]);
  });

  test('closing during worker startup completes pending decode', () async {
    final worker = LiveFrameDecoderWorker();
    final data = _packet(
      protocol: 0,
      operation: 5,
      body: utf8.encode('{}'),
    );

    final decoding = worker.decode(data);
    worker.close();

    await expectLater(decoding, throwsStateError);
  });
}
