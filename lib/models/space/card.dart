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
import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable()
class SpaceCard {
  Avatar? avatar;
  String? mid;
  String? name;
  bool? approve;
  String? rank;
  String? face;
  @JsonKey(name: 'DisplayRank')
  String? displayRank;
  int? regtime;
  int? spacesta;
  String? birthday;
  String? place;
  String? description;
  int? article;
  dynamic attentions;
  int fans;
  int? friend;
  int attention;
  String? sign;
  @JsonKey(name: 'level_info')
  LevelInfo? levelInfo;
  Pendant? pendant;
  Nameplate? nameplate;
  @JsonKey(name: 'official_verify')
  OfficialVerify? officialVerify;
  @JsonKey(name: 'profession_verify')
  ProfessionVerify? professionVerify;
  Vip? vip;
  int? silence;
  @JsonKey(name: 'end_time')
  int? endTime;
  @JsonKey(name: 'silence_url')
  String? silenceUrl;
  Likes? likes;
  Achieve? achieve;
  @JsonKey(name: 'pendant_url')
  String? pendantUrl;
  @JsonKey(name: 'pendant_title')
  String? pendantTitle;
  @JsonKey(name: 'pr_info')
  PrInfo? prInfo;
  Relation? relation;
  @JsonKey(name: 'is_deleted')
  int? isDeleted;
  Honours? honours;
  // Profession? profession;
  // School? school;
  @JsonKey(name: 'space_tag')
  List<Item>? spaceTag;
  @JsonKey(name: 'face_nft_new')
  int? faceNftNew;
  @JsonKey(name: 'has_face_nft')
  bool? hasFaceNft;
  @JsonKey(name: 'nft_certificate')
  NftCertificate? nftCertificate;
  Entrance? entrance;
  @JsonKey(name: 'nft_id')
  String? nftId;
  @JsonKey(name: 'nft_face_icon')
  dynamic nftFaceIcon;
  @JsonKey(name: 'space_tag_bottom')
  List<Item>? spaceTagBottom;
  @JsonKey(name: 'digital_id')
  String? digitalId;
  @JsonKey(name: 'digital_type')
  int? digitalType;
  @JsonKey(name: 'has_digital_asset')
  bool? hasDigitalAsset;

  SpaceCard({
    this.avatar,
    this.mid,
    this.name,
    this.approve,
    this.rank,
    this.face,
    this.displayRank,
    this.regtime,
    this.spacesta,
    this.birthday,
    this.place,
    this.description,
    this.article,
    this.attentions,
    required this.fans,
    this.friend,
    required this.attention,
    this.sign,
    this.levelInfo,
    this.pendant,
    this.nameplate,
    this.officialVerify,
    this.professionVerify,
    this.vip,
    this.silence,
    this.endTime,
    this.silenceUrl,
    this.likes,
    this.achieve,
    this.pendantUrl,
    this.pendantTitle,
    this.prInfo,
    this.relation,
    this.isDeleted,
    this.honours,
    // this.profession,
    // this.school,
    this.spaceTag,
    this.faceNftNew,
    this.hasFaceNft,
    this.nftCertificate,
    this.entrance,
    this.nftId,
    this.nftFaceIcon,
    this.spaceTagBottom,
    this.digitalId,
    this.digitalType,
    this.hasDigitalAsset,
  });

  factory SpaceCard.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  Map<String, dynamic> toJson() => _$CardToJson(this);
}
