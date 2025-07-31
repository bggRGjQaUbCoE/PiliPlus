import 'package:hive/hive.dart';

part 'info.g.dart';

@HiveType(typeId: 4)
class UserInfoData {
  UserInfoData({
    this.isLogin,
    this.emailVerified,
    this.face,
    this.levelInfo,
    this.mid,
    this.mobileVerified,
    this.money,
    this.moral,
    this.official,
    this.officialVerify,
    this.pendant,
    this.scores,
    this.uname,
    this.vipDueDate,
    this.vipStatus,
    this.vipType,
    this.vipPayType,
    this.vipThemeType,
    this.vipLabel,
    this.vipAvatarSub,
    this.vipNicknameColor,
    this.wallet,
    this.hasShop,
    this.shopUrl,
    this.isSeniorMember,
  });
  @HiveField(0)
  bool? isLogin;
  @HiveField(1)
  int? emailVerified;
  @HiveField(2)
  String? face;
  @HiveField(3)
  LevelInfo? levelInfo;
  @HiveField(4)
  int? mid;
  @HiveField(5)
  int? mobileVerified;
  @HiveField(6)
  double? money;
  @HiveField(7)
  int? moral;
  @HiveField(8)
  Map? official;
  @HiveField(9)
  Map? officialVerify;
  @HiveField(10)
  Map? pendant;
  @HiveField(11)
  int? scores;
  @HiveField(12)
  String? uname;
  @HiveField(13)
  int? vipDueDate;
  @HiveField(14)
  int? vipStatus;
  @HiveField(15)
  int? vipType;
  @HiveField(16)
  int? vipPayType;
  @HiveField(17)
  int? vipThemeType;
  @HiveField(18)
  Map? vipLabel;
  @HiveField(19)
  int? vipAvatarSub;
  @HiveField(20)
  String? vipNicknameColor;
  @HiveField(21)
  Map? wallet;
  @HiveField(22)
  bool? hasShop;
  @HiveField(23)
  String? shopUrl;
  @HiveField(24)
  int? isSeniorMember;

  UserInfoData.fromJson(Map<String, dynamic> json) {
    isLogin = json['isLogin'] ?? false;
    emailVerified = json['email_verified'];
    face = json['face'];
    levelInfo = json['level_info'] != null
        ? LevelInfo.fromJson(json['level_info'])
        : null;
    mid = json['mid'];
    mobileVerified = json['mobile_verified'];
    money = json['money'] is int ? json['money'].toDouble() : json['money'];
    moral = json['moral'];
    official = json['official'];
    officialVerify = json['officialVerify'];
    pendant = json['pendant'];
    scores = json['scores'];
    uname = json['uname'];
    vipDueDate = json['vipDueDate'];
    vipStatus = json['vipStatus'];
    vipType = json['vipType'];
    vipPayType = json['vip_pay_type'];
    vipThemeType = json['vip_theme_type'];
    vipLabel = json['vip_label'];
    vipAvatarSub = json['vip_avatar_subscript'];
    vipNicknameColor = json['vip_nickname_color'];
    wallet = json['wallet'];
    hasShop = json['has_shop'];
    shopUrl = json['shop_url'];
    isSeniorMember = json['is_senior_member'];
  }

  @override
  int get hashCode => Object.hash(mid, uname, face, money, vipStatus);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserInfoData &&
            isLogin == other.isLogin &&
            face == other.face &&
            levelInfo == other.levelInfo &&
            mid == other.mid &&
            money == other.money &&
            uname == other.uname &&
            vipDueDate == other.vipDueDate &&
            vipStatus == other.vipStatus &&
            isSeniorMember == other.isSeniorMember;
  }
}

@HiveType(typeId: 5)
class LevelInfo {
  LevelInfo({
    this.currentLevel,
    this.currentMin,
    this.currentExp,
    this.nextExp,
  });
  @HiveField(0)
  int? currentLevel;
  @HiveField(1)
  int? currentMin;
  @HiveField(2)
  int? currentExp;
  @HiveField(3)
  int? nextExp;

  LevelInfo.fromJson(Map<String, dynamic> json) {
    currentLevel = json['current_level'];
    currentMin = json['current_min'];
    currentExp = json['current_exp'];
    nextExp = json['current_level'] == 6
        ? json['current_exp']
        : json['next_exp'];
  }

  @override
  int get hashCode => currentExp.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LevelInfo && currentExp == other.currentExp;
  }
}
