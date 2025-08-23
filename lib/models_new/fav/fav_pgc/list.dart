import 'package:PiliPlus/models_new/fav/fav_pgc/area.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/badge_info.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/badge_infos.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/config_attrs.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/first_ep_info.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/new_ep.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/producer.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/publish.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/rating.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/rights.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/section.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/series.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/stat.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/utils/extension.dart';

class FavPgcItemModel with MultiSelectData {
  int? seasonId;
  int? mediaId;
  int? seasonType;
  String? seasonTypeName;
  String? title;
  String? cover;
  int? totalCount;
  int? isFinish;
  int? isStarted;
  int? isPlay;
  String? badge;
  int? badgeType;
  Rights? rights;
  Stat? stat;
  NewEp? newEp;
  Rating? rating;
  String? squareCover;
  int? seasonStatus;
  String? seasonTitle;
  String? badgeEp;
  int? mediaAttr;
  int? seasonAttr;
  String? evaluate;
  List<Area>? areas;
  String? subtitle;
  int? firstEp;
  int? canWatch;
  Series? series;
  Publish? publish;
  int? mode;
  List<Section>? section;
  String? url;
  BadgeInfo? badgeInfo;
  String? renewalTime;
  FirstEpInfo? firstEpInfo;
  int? formalEpCount;
  String? shortUrl;
  BadgeInfos? badgeInfos;
  String? seasonVersion;
  String? horizontalCover169;
  String? horizontalCover1610;
  String? subtitle14;
  int? viewableCrowdType;
  List<Producer>? producers;
  String? summary;
  List<String>? styles;
  ConfigAttrs? configAttrs;
  int? followStatus;
  int? isNew;
  String? progress;
  bool? bothFollow;
  String? subtitle25;

  FavPgcItemModel({
    this.seasonId,
    this.mediaId,
    this.seasonType,
    this.seasonTypeName,
    this.title,
    this.cover,
    this.totalCount,
    this.isFinish,
    this.isStarted,
    this.isPlay,
    this.badge,
    this.badgeType,
    this.rights,
    this.stat,
    this.newEp,
    this.rating,
    this.squareCover,
    this.seasonStatus,
    this.seasonTitle,
    this.badgeEp,
    this.mediaAttr,
    this.seasonAttr,
    this.evaluate,
    this.areas,
    this.subtitle,
    this.firstEp,
    this.canWatch,
    this.series,
    this.publish,
    this.mode,
    this.section,
    this.url,
    this.badgeInfo,
    this.renewalTime,
    this.firstEpInfo,
    this.formalEpCount,
    this.shortUrl,
    this.badgeInfos,
    this.seasonVersion,
    this.horizontalCover169,
    this.horizontalCover1610,
    this.subtitle14,
    this.viewableCrowdType,
    this.producers,
    this.summary,
    this.styles,
    this.configAttrs,
    this.followStatus,
    this.isNew,
    this.progress,
    this.bothFollow,
    this.subtitle25,
  });

  factory FavPgcItemModel.fromJson(
    Map<String, dynamic> json,
  ) => FavPgcItemModel(
    seasonId: json['season_id'] as int?,
    mediaId: json['media_id'] as int?,
    seasonType: json['season_type'] as int?,
    seasonTypeName: json['season_type_name'] as String?,
    title: json['title'] as String?,
    cover: json['cover'] as String?,
    totalCount: json['total_count'] as int?,
    isFinish: json['is_finish'] as int?,
    isStarted: json['is_started'] as int?,
    isPlay: json['is_play'] as int?,
    badge: json['badge'] as String?,
    badgeType: json['badge_type'] as int?,
    rights: json['rights'] == null
        ? null
        : Rights.fromJson(json['rights'] as Map<String, dynamic>),
    stat: json['stat'] == null
        ? null
        : Stat.fromJson(json['stat'] as Map<String, dynamic>),
    newEp: json['new_ep'] == null
        ? null
        : NewEp.fromJson(json['new_ep'] as Map<String, dynamic>),
    rating: json['rating'] == null
        ? null
        : Rating.fromJson(json['rating'] as Map<String, dynamic>),
    squareCover: json['square_cover'] as String?,
    seasonStatus: json['season_status'] as int?,
    seasonTitle: json['season_title'] as String?,
    badgeEp: json['badge_ep'] as String?,
    mediaAttr: json['media_attr'] as int?,
    seasonAttr: json['season_attr'] as int?,
    evaluate: json['evaluate'] as String?,
    areas: (json['areas'] as List<dynamic>?)
        ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
        .toList(),
    subtitle: json['subtitle'] as String?,
    firstEp: json['first_ep'] as int?,
    canWatch: json['can_watch'] as int?,
    series: json['series'] == null
        ? null
        : Series.fromJson(json['series'] as Map<String, dynamic>),
    publish: json['publish'] == null
        ? null
        : Publish.fromJson(json['publish'] as Map<String, dynamic>),
    mode: json['mode'] as int?,
    section: (json['section'] as List<dynamic>?)
        ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
        .toList(),
    url: json['url'] as String?,
    badgeInfo: json['badge_info'] == null
        ? null
        : BadgeInfo.fromJson(json['badge_info'] as Map<String, dynamic>),
    renewalTime: json['renewal_time'] as String?,
    firstEpInfo: json['first_ep_info'] == null
        ? null
        : FirstEpInfo.fromJson(json['first_ep_info'] as Map<String, dynamic>),
    formalEpCount: json['formal_ep_count'] as int?,
    shortUrl: json['short_url'] as String?,
    badgeInfos: json['badge_infos'] == null
        ? null
        : BadgeInfos.fromJson(json['badge_infos'] as Map<String, dynamic>),
    seasonVersion: json['season_version'] as String?,
    horizontalCover169: json['horizontal_cover_16_9'] as String?,
    horizontalCover1610: json['horizontal_cover_16_10'] as String?,
    subtitle14: json['subtitle_14'] as String?,
    viewableCrowdType: json['viewable_crowd_type'] as int?,
    producers: (json['producers'] as List<dynamic>?)
        ?.map((e) => Producer.fromJson(e as Map<String, dynamic>))
        .toList(),
    summary: json['summary'] as String?,
    styles: (json['styles'] as List?)?.fromCast(),
    configAttrs: json['config_attrs'] == null
        ? null
        : ConfigAttrs.fromJson(json['config_attrs'] as Map<String, dynamic>),
    followStatus: json['follow_status'] as int?,
    isNew: json['is_new'] as int?,
    progress: json['progress'] == '' ? null : json['progress'],
    bothFollow: json['both_follow'] as bool?,
    subtitle25: json['subtitle_25'] as String?,
  );
}
