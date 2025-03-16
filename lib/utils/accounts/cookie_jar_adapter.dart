import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';

import 'account.dart';

class BiliCookieJarAdapter extends TypeAdapter<DefaultCookieJar> {
  @override
  final int typeId = 8;

  @override
  DefaultCookieJar read(BinaryReader reader) =>
      BiliCookieJar.fromJson(reader.readMap().cast<String, String>());

  @override
  void write(BinaryWriter writer, DefaultCookieJar obj) {
    writer.writeMap(obj.toJson());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BiliCookieJarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
