import 'dart:convert';
import 'dart:typed_data';

// Minimal protobuf wire support for the official Vega/Freya protocol. Unknown
// fields are skipped; groups, truncated fields and oversized messages fail closed.
class RoomProto {
  final Map<int, List<Object>> _fields = {};
  RoomProto();
  factory RoomProto.decode(List<int> bytes) {
    if (bytes.length > 1024 * 1024) throw const FormatException('房间消息过大');
    final result = RoomProto();
    var index = 0;
    int varint() {
      var n = 0;
      for (var shift = 0; shift < 64; shift += 7) {
        if (index >= bytes.length) throw const FormatException('截断的 protobuf');
        final b = bytes[index++];
        if (shift == 63 && b > 1) throw const FormatException('无效的 varint');
        n |= (b & 127) << shift;
        if (b < 128) return n;
      }
      throw const FormatException('过长的 varint');
    }

    while (index < bytes.length) {
      final tag = varint(), field = tag >> 3, type = tag & 7;
      if (field <= 0) throw const FormatException('无效的 protobuf 字段');
      Object? value;
      if (type == 0) {
        value = varint();
      } else if (type == 2) {
        final length = varint();
        if (length < 0 || length > bytes.length - index)
          throw const FormatException('截断的 protobuf 内容');
        value = Uint8List.fromList(bytes.sublist(index, index + length));
        index += length;
      } else if (type == 1 || type == 5) {
        index += type == 1 ? 8 : 4;
        if (index > bytes.length) throw const FormatException('截断的固定字段');
      } else {
        throw const FormatException('不支持的 protobuf wire type');
      }
      if (value != null) (result._fields[field] ??= []).add(value);
    }
    return result;
  }
  RoomProto number(int field, int value) {
    (_fields[field] ??= []).add(value);
    return this;
  }

  RoomProto bytes(int field, List<int> value) {
    (_fields[field] ??= []).add(Uint8List.fromList(value));
    return this;
  }

  RoomProto text(int field, String value) => bytes(field, utf8.encode(value));
  RoomProto message(int field, RoomProto value) => bytes(field, value.encode());
  int integer(int field, [int fallback = 0]) =>
      _fields[field]?.firstOrNull is int
      ? _fields[field]!.first as int
      : fallback;
  List<int> data(int field) => _fields[field]?.firstOrNull is Uint8List
      ? _fields[field]!.first as Uint8List
      : const [];
  String string(int field) => utf8.decode(data(field), allowMalformed: true);
  RoomProto nested(int field) => RoomProto.decode(data(field));
  bool has(int field) => _fields.containsKey(field);
  Iterable<RoomProto> messages(int field) =>
      (_fields[field] ?? []).whereType<Uint8List>().map(RoomProto.decode);
  Uint8List encode() {
    final output = BytesBuilder();
    void varint(int value) {
      if (value < 0) throw const FormatException('这里只接受非负整数');
      while (value >= 128) {
        output.addByte((value & 127) | 128);
        value >>= 7;
      }
      output.addByte(value);
    }

    for (final entry in _fields.entries) {
      for (final value in entry.value) {
        varint((entry.key << 3) | (value is int ? 0 : 2));
        if (value is int) {
          varint(value);
        } else {
          final bytes = value as Uint8List;
          varint(bytes.length);
          output.add(bytes);
        }
      }
    }
    return output.takeBytes();
  }

  static RoomProto any(String type, RoomProto body) => RoomProto()
    ..text(1, 'type.googleapis.com/$type')
    ..message(2, body);
}
