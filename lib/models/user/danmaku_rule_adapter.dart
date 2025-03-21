import 'package:PiliPlus/models/user/danmaku_rule.dart';
import 'package:hive/hive.dart';

class RuleFilterAdapter extends TypeAdapter<RuleFilter> {
  @override
  final int typeId = 12;

  @override
  RuleFilter read(BinaryReader reader) {
    return RuleFilter(
        reader.readStringList(),
        reader
            .readStringList()
            .map((i) => RegExp(i, caseSensitive: false))
            .toList(),
        reader.readStringList().toSet());
  }

  @override
  void write(BinaryWriter writer, RuleFilter obj) {
    writer
      ..writeStringList(obj.dmFilterString)
      ..writeStringList(obj.dmRegExp.map((i) => i.pattern).toList())
      ..writeStringList(obj.dmUid.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuleFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
