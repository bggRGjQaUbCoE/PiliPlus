import 'package:hive/hive.dart';

class SetIntAdapter extends TypeAdapter<Set<int>> {
  @override
  final int typeId = 11;

  @override
  Set<int> read(BinaryReader reader) {
    return reader.readIntList().toSet();
  }

  @override
  void write(BinaryWriter writer, Set<int> obj) {
    writer.writeIntList(obj.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetIntAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
