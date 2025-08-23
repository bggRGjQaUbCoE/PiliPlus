// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoDataAdapter extends TypeAdapter<UserInfoData> {
  @override
  final int typeId = 4;

  @override
  UserInfoData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfoData(
      isLogin: fields[0] as bool?,
      emailVerified: fields[1] as int?,
      face: fields[2] as String?,
      levelInfo: fields[3] as LevelInfo?,
      mid: fields[4] as int?,
      mobileVerified: fields[5] as int?,
      money: fields[6] as double?,
      moral: fields[7] as int?,
      official: (fields[8] as Map?)?.fromCast<dynamic, dynamic>(),
      officialVerify: (fields[9] as Map?)?.fromCast<dynamic, dynamic>(),
      pendant: (fields[10] as Map?)?.fromCast<dynamic, dynamic>(),
      scores: fields[11] as int?,
      uname: fields[12] as String?,
      vipDueDate: fields[13] as int?,
      vipStatus: fields[14] as int?,
      vipType: fields[15] as int?,
      vipPayType: fields[16] as int?,
      vipThemeType: fields[17] as int?,
      vipLabel: (fields[18] as Map?)?.fromCast<dynamic, dynamic>(),
      vipAvatarSub: fields[19] as int?,
      vipNicknameColor: fields[20] as String?,
      wallet: (fields[21] as Map?)?.fromCast<dynamic, dynamic>(),
      hasShop: fields[22] as bool?,
      shopUrl: fields[23] as String?,
      isSeniorMember: fields[24] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInfoData obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.isLogin)
      ..writeByte(1)
      ..write(obj.emailVerified)
      ..writeByte(2)
      ..write(obj.face)
      ..writeByte(3)
      ..write(obj.levelInfo)
      ..writeByte(4)
      ..write(obj.mid)
      ..writeByte(5)
      ..write(obj.mobileVerified)
      ..writeByte(6)
      ..write(obj.money)
      ..writeByte(7)
      ..write(obj.moral)
      ..writeByte(8)
      ..write(obj.official)
      ..writeByte(9)
      ..write(obj.officialVerify)
      ..writeByte(10)
      ..write(obj.pendant)
      ..writeByte(11)
      ..write(obj.scores)
      ..writeByte(12)
      ..write(obj.uname)
      ..writeByte(13)
      ..write(obj.vipDueDate)
      ..writeByte(14)
      ..write(obj.vipStatus)
      ..writeByte(15)
      ..write(obj.vipType)
      ..writeByte(16)
      ..write(obj.vipPayType)
      ..writeByte(17)
      ..write(obj.vipThemeType)
      ..writeByte(18)
      ..write(obj.vipLabel)
      ..writeByte(19)
      ..write(obj.vipAvatarSub)
      ..writeByte(20)
      ..write(obj.vipNicknameColor)
      ..writeByte(21)
      ..write(obj.wallet)
      ..writeByte(22)
      ..write(obj.hasShop)
      ..writeByte(23)
      ..write(obj.shopUrl)
      ..writeByte(24)
      ..write(obj.isSeniorMember);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LevelInfoAdapter extends TypeAdapter<LevelInfo> {
  @override
  final int typeId = 5;

  @override
  LevelInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelInfo(
      currentLevel: fields[0] as int?,
      currentMin: fields[1] as int?,
      currentExp: fields[2] as int?,
      nextExp: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LevelInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.currentLevel)
      ..writeByte(1)
      ..write(obj.currentMin)
      ..writeByte(2)
      ..write(obj.currentExp)
      ..writeByte(3)
      ..write(obj.nextExp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
