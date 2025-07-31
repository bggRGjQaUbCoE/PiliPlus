import 'package:PiliPlus/models_new/pgc/pgc_info_model/badge_info.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/icon_font.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/new_ep.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/stat.dart';

class Season {
  String? badge;
  BadgeInfo? badgeInfo;
  int? badgeType;
  String? cover;
  bool? enableVt;
  String? horizontalCover1610;
  String? horizontalCover169;
  IconFont? iconFont;
  int? mediaId;
  NewEp? newEp;
  int? seasonId;
  String? seasonTitle;
  int? seasonType;
  PgcStat? stat;

  Season({
    this.badge,
    this.badgeInfo,
    this.badgeType,
    this.cover,
    this.enableVt,
    this.horizontalCover1610,
    this.horizontalCover169,
    this.iconFont,
    this.mediaId,
    this.newEp,
    this.seasonId,
    this.seasonTitle,
    this.seasonType,
    this.stat,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
    badge: json['badge'] as String?,
    badgeInfo: json['badge_info'] == null
        ? null
        : BadgeInfo.fromJson(json['badge_info'] as Map<String, dynamic>),
    badgeType: json['badge_type'] as int?,
    cover: json['cover'] as String?,
    enableVt: json['enable_vt'] as bool?,
    horizontalCover1610: json['horizontal_cover_1610'] as String?,
    horizontalCover169: json['horizontal_cover_169'] as String?,
    iconFont: json['icon_font'] == null
        ? null
        : IconFont.fromJson(json['icon_font'] as Map<String, dynamic>),
    mediaId: json['media_id'] as int?,
    newEp: json['new_ep'] == null
        ? null
        : NewEp.fromJson(json['new_ep'] as Map<String, dynamic>),
    seasonId: json['season_id'] as int?,
    seasonTitle: json['season_title'] as String?,
    seasonType: json['season_type'] as int?,
    stat: json['stat'] == null
        ? null
        : PgcStat.fromJson(json['stat'] as Map<String, dynamic>),
  );
}
