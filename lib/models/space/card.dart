import 'package:PiliPlus/models/model_avatar.dart' hide Avatar;
import 'package:PiliPlus/models/space/achieve.dart';
import 'package:PiliPlus/models/space/avatar.dart';
import 'package:PiliPlus/models/space/entrance.dart';
import 'package:PiliPlus/models/space/honours.dart';
import 'package:PiliPlus/models/space/level_info.dart';
import 'package:PiliPlus/models/space/likes.dart';
import 'package:PiliPlus/models/space/nameplate.dart';
import 'package:PiliPlus/models/space/nft_certificate.dart';
import 'package:PiliPlus/models/space/official_verify.dart';
import 'package:PiliPlus/models/space/pr_info.dart';
import 'package:PiliPlus/models/space/profession_verify.dart';
import 'package:PiliPlus/models/space/relation.dart';
import 'package:PiliPlus/models/space/space_tag_bottom.dart';

class SpaceCard {
  Avatar? avatar;
  String? mid;
  String? name;
  bool? approve;
  String? rank;
  String? face;
  String? displayRank;
  int? regtime;
  int? spacesta;
  String? birthday;
  String? place;
  String? description;
  int? article;
  dynamic attentions;
  late int fans;
  int? friend;
  late int attention;
  String? sign;
  LevelInfo? levelInfo;
  Pendant? pendant;
  Nameplate? nameplate;
  OfficialVerify? officialVerify;
  ProfessionVerify? professionVerify;
  Vip? vip;
  int? silence;
  int? endTime;
  String? silenceUrl;
  Likes? likes;
  Achieve? achieve;
  String? pendantUrl;
  String? pendantTitle;
  PrInfo? prInfo;
  Relation? relation;
  int? isDeleted;
  Honours? honours;
  // Profession? profession;
  // School? school;
  List<Item>? spaceTag;
  int? faceNftNew;
  bool? hasFaceNft;
  NftCertificate? nftCertificate;
  Entrance? entrance;
  String? nftId;
  dynamic nftFaceIcon;
  List<Item>? spaceTagBottom;
  String? digitalId;
  int? digitalType;
  bool? hasDigitalAsset;

  SpaceCard.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'] == null
        ? null
        : Avatar.fromJson(json['avatar'] as Map<String, dynamic>);
    mid = json['mid'] as String?;
    name = json['name'] as String?;
    approve = json['approve'] as bool?;
    rank = json['rank'] as String?;
    face = json['face'] as String?;
    displayRank = json['DisplayRank'] as String?;
    regtime = (json['regtime'] as num?)?.toInt();
    spacesta = (json['spacesta'] as num?)?.toInt();
    birthday = json['birthday'] as String?;
    place = json['place'] as String?;
    description = json['description'] as String?;
    article = (json['article'] as num?)?.toInt();
    attentions = json['attentions'];
    fans = (json['fans'] as num?)?.toInt() ?? 0;
    friend = (json['friend'] as num?)?.toInt();
    attention = (json['attention'] as num?)?.toInt() ?? 0;
    sign = json['sign'] as String?;
    levelInfo = json['level_info'] == null
        ? null
        : LevelInfo.fromJson(json['level_info'] as Map<String, dynamic>);
    pendant = json['pendant'] == null
        ? null
        : Pendant.fromJson(json['pendant'] as Map<String, dynamic>);
    nameplate = json['nameplate'] == null
        ? null
        : Nameplate.fromJson(json['nameplate'] as Map<String, dynamic>);
    officialVerify = json['official_verify'] == null
        ? null
        : OfficialVerify.fromJson(
            json['official_verify'] as Map<String, dynamic>);
    professionVerify = json['profession_verify'] == null
        ? null
        : ProfessionVerify.fromJson(
            json['profession_verify'] as Map<String, dynamic>);
    vip = json['vip'] == null
        ? null
        : CardVip.fromJson(json['vip'] as Map<String, dynamic>);
    silence = (json['silence'] as num?)?.toInt();
    endTime = (json['end_time'] as num?)?.toInt();
    silenceUrl = json['silence_url'] as String?;
    likes = json['likes'] == null
        ? null
        : Likes.fromJson(json['likes'] as Map<String, dynamic>);
    achieve = json['achieve'] == null
        ? null
        : Achieve.fromJson(json['achieve'] as Map<String, dynamic>);
    pendantUrl = json['pendant_url'] as String?;
    pendantTitle = json['pendant_title'] as String?;
    prInfo = json['pr_info'] == null
        ? null
        : PrInfo.fromJson(json['pr_info'] as Map<String, dynamic>);
    relation = json['relation'] == null
        ? null
        : Relation.fromJson(json['relation'] as Map<String, dynamic>);
    isDeleted = (json['is_deleted'] as num?)?.toInt();
    honours = json['honours'] == null
        ? null
        : Honours.fromJson(json['honours'] as Map<String, dynamic>);
    // profession = json['profession'] == null
    //     ? null
    //     : Profession.fromJson(json['profession'] as Map<String, dynamic>);
    // school = json['school'] == null
    //     ? null
    //     : School.fromJson(json['school'] as Map<String, dynamic>);
    spaceTag = (json['space_tag'] as List<dynamic>?)
        ?.where((item) => (item['title'] as String?)?.startsWith('IP') == true)
        .toList()
        .map((item) => Item.fromJson(item))
        .toList();
    faceNftNew = (json['face_nft_new'] as num?)?.toInt();
    hasFaceNft = json['has_face_nft'] as bool?;
    nftCertificate = json['nft_certificate'] == null
        ? null
        : NftCertificate.fromJson(
            json['nft_certificate'] as Map<String, dynamic>);
    entrance = json['entrance'] == null
        ? null
        : Entrance.fromJson(json['entrance'] as Map<String, dynamic>);
    nftId = json['nft_id'] as String?;
    nftFaceIcon = json['nft_face_icon'];
    spaceTagBottom = (json['space_tag_bottom'] as List<dynamic>?)
        ?.map((item) => Item.fromJson(item))
        .toList();
    digitalId = json['digital_id'] as String?;
    digitalType = (json['digital_type'] as num?)?.toInt();
    hasDigitalAsset = json['has_digital_asset'] as bool?;
  }
}

class CardVip implements Vip {
  @override
  int? dueDate;
  @override
  Label? label;
  @override
  late int status;
  @override
  int? type;

  CardVip.fromJson(Map<String, dynamic> json) {
    type = json['vipType'];
    status = json['vipStatus'] ?? 0;
    dueDate = json['vipDueDate'];
    if (json['label'] != null) label = Label.fromJson(json['label']);
  }
}
