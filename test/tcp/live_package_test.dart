import 'dart:typed_data';

import 'package:PiliPlus/tcp/live.dart';
import 'package:flutter_test/flutter_test.dart';

Uint8List header({
  required int totalSize,
  int headerSize = 16,
  int protocolVer = 0,
  int operationCode = 5,
  int seq = 1,
  int trailingBytes = 0,
}) {
  final data = ByteData(16 + trailingBytes)
    ..setUint32(0, totalSize, Endian.big)
    ..setUint16(4, headerSize, Endian.big)
    ..setUint16(6, protocolVer, Endian.big)
    ..setUint32(8, operationCode, Endian.big)
    ..setUint32(12, seq, Endian.big);
  return data.buffer.asUint8List();
}

void main() {
  test('a truncated header is rejected before field reads', () {
    expect(PackageHeaderRes.fromBytesData(Uint8List(15)), isNull);
  });

  test('declared packet bounds must fit the received bytes', () {
    final packet = header(totalSize: 16);
    final parsed = PackageHeaderRes.fromBytesData(packet);

    expect(parsed, isNotNull);
    expect(parsed!.isWithin(packet.length), isTrue);
    expect(header(totalSize: 32).length, 16);
    expect(
      PackageHeaderRes.fromBytesData(header(totalSize: 32))!.isWithin(16),
      isFalse,
    );
  });
}
