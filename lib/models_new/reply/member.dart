import 'package:PiliPlus/models/model_avatar.dart';
import 'package:PiliPlus/models_new/reply/level_info.dart';
import 'package:PiliPlus/models_new/reply/nameplate.dart';
import 'package:PiliPlus/models_new/reply/senior.dart';

class ReplyMember {
  String? mid;
  String? uname;
  String? sex;
  String? sign;
  String? avatar;
  String? rank;
  int? faceNftNew;
  int? isSeniorMember;
  Senior? senior;
  LevelInfo? levelInfo;
  Pendant? pendant;
  Nameplate? nameplate;
  BaseOfficialVerify? officialVerify;
  Vip? vip;
  dynamic fansDetail;
  bool? isContractor;
  String? contractDesc;
  dynamic nftInteraction;

  ReplyMember({
    this.mid,
    this.uname,
    this.sex,
    this.sign,
    this.avatar,
    this.rank,
    this.faceNftNew,
    this.isSeniorMember,
    this.senior,
    this.levelInfo,
    this.pendant,
    this.nameplate,
    this.officialVerify,
    this.vip,
    this.fansDetail,
    this.isContractor,
    this.contractDesc,
    this.nftInteraction,
  });

  factory ReplyMember.fromJson(Map<String, dynamic> json) => ReplyMember(
    mid: json['mid'] as String?,
    uname: json['uname'] as String?,
    sex: json['sex'] as String?,
    sign: json['sign'] as String?,
    avatar: json['avatar'] as String?,
    rank: json['rank'] as String?,
    faceNftNew: json['face_nft_new'] as int?,
    isSeniorMember: json['is_senior_member'] as int?,
    senior: json['senior'] == null
        ? null
        : Senior.fromJson(json['senior'] as Map<String, dynamic>),
    levelInfo: json['level_info'] == null
        ? null
        : LevelInfo.fromJson(json['level_info'] as Map<String, dynamic>),
    pendant: json['pendant'] == null
        ? null
        : Pendant.fromJson(json['pendant'] as Map<String, dynamic>),
    nameplate: json['nameplate'] == null
        ? null
        : Nameplate.fromJson(json['nameplate'] as Map<String, dynamic>),
    officialVerify: json['official_verify'] == null
        ? null
        : BaseOfficialVerify.fromJson(
            json['official_verify'] as Map<String, dynamic>,
          ),
    vip: json['vip'] == null
        ? null
        : Vip.fromJson(json['vip'] as Map<String, dynamic>),
    fansDetail: json['fans_detail'] as dynamic,
    isContractor: json['is_contractor'] as bool?,
    contractDesc: json['contract_desc'] as String?,
    nftInteraction: json['nft_interaction'] as dynamic,
  );
}
