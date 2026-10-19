import 'package:PiliPlus/models/model_avatar.dart';
import 'package:PiliPlus/models_new/space/space/achieve.dart';
import 'package:PiliPlus/models_new/space/space/followings_followed_upper.dart';
import 'package:PiliPlus/models_new/space/space/level_info.dart';
import 'package:PiliPlus/models_new/space/space/likes.dart';
import 'package:PiliPlus/models_new/space/space/live_fans_wearing.dart';
import 'package:PiliPlus/models_new/space/space/official_verify.dart';
import 'package:PiliPlus/models_new/space/space/pr_info.dart';
import 'package:PiliPlus/models_new/space/space/relation.dart';
import 'package:PiliPlus/models_new/space/space/space_tag.dart';

class SpaceCard {
  String? mid;
  String? name;
  String? face;
  int? regtime;
  String? birthday;
  int? article;
  int? fans;
  int? friend;
  int? attention;
  String? sign;
  LevelInfo? levelInfo;
  Pendant? pendant;
  OfficialVerify? officialVerify;
  Vip? vip;
  int? silence;
  int? endTime;
  String? silenceUrl;
  Likes? likes;
  Achieve? achieve;
  SpaceRelation? relation;
  LiveFansWearing? liveFansWearing;
  List<SpaceTag>? spaceTag;
  SpacePrInfo? prInfo;
  FollowingsFollowedUpper? followingsFollowedUpper;
  String? medalName;

  SpaceCard({
    this.mid,
    this.name,
    this.face,
    this.regtime,
    this.birthday,
    this.article,
    this.fans,
    this.friend,
    this.attention,
    this.sign,
    this.levelInfo,
    this.pendant,
    this.officialVerify,
    this.vip,
    this.silence,
    this.endTime,
    this.silenceUrl,
    this.likes,
    this.achieve,
    this.relation,
    this.liveFansWearing,
    this.spaceTag,
    this.prInfo,
    this.followingsFollowedUpper,
  });

  factory SpaceCard.fromJson(Map<String, dynamic> json) => SpaceCard(
    mid: json['mid'] as String?,
    name: json['name'] as String?,
    face: json['face'] as String?,
    regtime: json['regtime'] as int?,
    birthday: json['birthday'] as String?,
    article: json['article'] as int?,
    fans: json['fans'] as int?,
    friend: json['friend'] as int?,
    attention: json['attention'] as int?,
    sign: json['sign'] as String?,
    levelInfo: json['level_info'] == null
        ? null
        : LevelInfo.fromJson(json['level_info'] as Map<String, dynamic>),
    pendant: json['pendant'] == null
        ? null
        : Pendant.fromJson(json['pendant'] as Map<String, dynamic>),
    officialVerify: json['official_verify'] == null
        ? null
        : OfficialVerify.fromJson(
            json['official_verify'] as Map<String, dynamic>,
          ),
    vip: json['vip'] == null
        ? null
        : Vip.fromJson(json['vip'] as Map<String, dynamic>),
    silence: json['silence'] as int?,
    endTime: json['end_time'] as int?,
    silenceUrl: json['silence_url'] as String?,
    likes: json['likes'] == null
        ? null
        : Likes.fromJson(json['likes'] as Map<String, dynamic>),
    achieve: json['achieve'] == null
        ? null
        : Achieve.fromJson(json['achieve'] as Map<String, dynamic>),
    relation: json['relation'] == null
        ? null
        : SpaceRelation.fromJson(json['relation'] as Map<String, dynamic>),
    liveFansWearing: json['live_fans_wearing'] == null
        ? null
        : LiveFansWearing.fromJson(
            json['live_fans_wearing'] as Map<String, dynamic>,
          ),
    spaceTag: (json['space_tag'] as List<dynamic>?)
        ?.where((e) => const ['location', 'real_name'].contains(e['type']))
        .map((e) => SpaceTag.fromJson(e as Map<String, dynamic>))
        .toList(),
    prInfo: json['pr_info'] == null
        ? null
        : SpacePrInfo.fromJson(json['pr_info'] as Map<String, dynamic>),
    followingsFollowedUpper: json['followings_followed_upper'] == null
        ? null
        : FollowingsFollowedUpper.fromJson(
            json['followings_followed_upper'] as Map<String, dynamic>,
          ),
  );
}
