import 'package:hive/hive.dart';
import 'package:PiliPlus/models/comment_record.dart';

class CommentRecordAdapter extends TypeAdapter<CommentRecord> {
  @override
  final int typeId = 20;

  @override
  CommentRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommentRecord(
      type: fields[0] as int,
      oid: fields[1] as int,
      message: fields[2] as String,
      root: fields[3] as int?,
      parent: fields[4] as int?,
      pictures: fields[5] as List<dynamic>?,
      syncToDynamic: fields[6] as bool? ?? false,
      atNameToMid: (fields[7] as Map?)?.cast<String, int>(),
      rpid: fields[8] as int?,
      timestamp: fields[9] as DateTime,
      senderMid: fields[10] as int?,
      senderFace: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CommentRecord obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.oid)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.root)
      ..writeByte(4)
      ..write(obj.parent)
      ..writeByte(5)
      ..write(obj.pictures)
      ..writeByte(6)
      ..write(obj.syncToDynamic)
      ..writeByte(7)
      ..write(obj.atNameToMid)
      ..writeByte(8)
      ..write(obj.rpid)
      ..writeByte(9)
      ..write(obj.timestamp)
      ..writeByte(10)
      ..write(obj.senderMid)
      ..writeByte(11)
      ..write(obj.senderFace);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
