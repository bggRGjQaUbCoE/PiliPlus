import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';

class LoginAccountAdapter extends TypeAdapter<LoginAccount> {
  @override
  final int typeId = 9;

  @override
  LoginAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginAccount(
      fields[0] as DefaultCookieJar,
      fields[1] as String?,
      fields[2] as String?,
      (fields[3] as List?)?.cast<AccountType>().toSet(),
    );
  }

  @override
  void write(BinaryWriter writer, LoginAccount obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cookieJar)
      ..writeByte(1)
      ..write(obj.accessKey)
      ..writeByte(2)
      ..write(obj.refresh)
      ..writeByte(3)
      ..write(obj.type.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
