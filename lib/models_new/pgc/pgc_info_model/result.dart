import 'package:PiliPlus/models_new/pgc/pgc_info_model/activity.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/area.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/freya.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/icon_font.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/new_ep.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/payment.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/play_strategy.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/positive.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/publish.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/rating.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/rights.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/season.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/section.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/series.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/show.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/stat.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/up_info.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/user_status.dart';

class PgcInfoModel {
  Activity? activity;
  String? actors;
  String? alias;
  List<Area>? areas;
  String? bkgCover;
  String? cover;
  bool? deliveryFragmentVideo;
  bool? enableVt;
  List<EpisodeItem>? episodes;
  String? evaluate;
  Freya? freya;
  int? hideEpVvVtDm;
  IconFont? iconFont;
  String? jpTitle;
  String? link;
  int? mediaId;
  int? mode;
  NewEp? newEp;
  Payment? payment;
  PlayStrategy? playStrategy;
  Positive? positive;
  Publish? publish;
  Rating? rating;
  String? record;
  Rights? rights;
  int? seasonId;
  String? seasonTitle;
  List<Season>? seasons;
  List<Section>? section;
  Series? series;
  String? shareCopy;
  String? shareSubTitle;
  String? shareUrl;
  Show? show;
  int? showSeasonType;
  String? squareCover;
  String? staff;
  PgcStat? stat;
  int? status;
  List? styles;
  String? subtitle;
  String? title;
  int? total;
  int? type;
  UpInfo? upInfo;
  UserStatus? userStatus;

  PgcInfoModel({
    this.activity,
    this.actors,
    this.alias,
    this.areas,
    this.bkgCover,
    this.cover,
    this.deliveryFragmentVideo,
    this.enableVt,
    this.episodes,
    this.evaluate,
    this.freya,
    this.hideEpVvVtDm,
    this.iconFont,
    this.jpTitle,
    this.link,
    this.mediaId,
    this.mode,
    this.newEp,
    this.payment,
    this.playStrategy,
    this.positive,
    this.publish,
    this.rating,
    this.record,
    this.rights,
    this.seasonId,
    this.seasonTitle,
    this.seasons,
    this.section,
    this.series,
    this.shareCopy,
    this.shareSubTitle,
    this.shareUrl,
    this.show,
    this.showSeasonType,
    this.squareCover,
    this.staff,
    this.stat,
    this.status,
    this.styles,
    this.subtitle,
    this.title,
    this.total,
    this.type,
    this.upInfo,
    this.userStatus,
  });

  factory PgcInfoModel.fromJson(Map<String, dynamic> json) => PgcInfoModel(
    activity: json['activity'] == null
        ? null
        : Activity.fromJson(json['activity'] as Map<String, dynamic>),
    actors: json['actors'] as String?,
    alias: json['alias'] as String?,
    areas: (json['areas'] as List<dynamic>?)
        ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
        .toList(),
    bkgCover: json['bkg_cover'] as String?,
    cover: json['cover'] as String?,
    deliveryFragmentVideo: json['delivery_fragment_video'] as bool?,
    enableVt: json['enable_vt'] as bool?,
    episodes: (json['episodes'] as List<dynamic>?)
        ?.map((e) => EpisodeItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    evaluate: json['evaluate'] as String?,
    freya: json['freya'] == null
        ? null
        : Freya.fromJson(json['freya'] as Map<String, dynamic>),
    hideEpVvVtDm: json['hide_ep_vv_vt_dm'] as int?,
    iconFont: json['icon_font'] == null
        ? null
        : IconFont.fromJson(json['icon_font'] as Map<String, dynamic>),
    jpTitle: json['jp_title'] as String?,
    link: json['link'] as String?,
    mediaId: json['media_id'] as int?,
    mode: json['mode'] as int?,
    newEp: json['new_ep'] == null
        ? null
        : NewEp.fromJson(json['new_ep'] as Map<String, dynamic>),
    payment: json['payment'] == null
        ? null
        : Payment.fromJson(json['payment'] as Map<String, dynamic>),
    playStrategy: json['play_strategy'] == null
        ? null
        : PlayStrategy.fromJson(json['play_strategy'] as Map<String, dynamic>),
    positive: json['positive'] == null
        ? null
        : Positive.fromJson(json['positive'] as Map<String, dynamic>),
    publish: json['publish'] == null
        ? null
        : Publish.fromJson(json['publish'] as Map<String, dynamic>),
    rating: json['rating'] == null
        ? null
        : Rating.fromJson(json['rating'] as Map<String, dynamic>),
    record: json['record'] as String?,
    rights: json['rights'] == null
        ? null
        : Rights.fromJson(json['rights'] as Map<String, dynamic>),
    seasonId: json['season_id'] as int?,
    seasonTitle: json['season_title'] as String?,
    seasons: (json['seasons'] as List<dynamic>?)
        ?.map((e) => Season.fromJson(e as Map<String, dynamic>))
        .toList(),
    section: (json['section'] as List<dynamic>?)
        ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
        .toList(),
    series: json['series'] == null
        ? null
        : Series.fromJson(json['series'] as Map<String, dynamic>),
    shareCopy: json['share_copy'] as String?,
    shareSubTitle: json['share_sub_title'] as String?,
    shareUrl: json['share_url'] as String?,
    show: json['show'] == null
        ? null
        : Show.fromJson(json['show'] as Map<String, dynamic>),
    showSeasonType: json['show_season_type'] as int?,
    squareCover: json['square_cover'] as String?,
    staff: json['staff'] as String?,
    stat: json['stat'] == null
        ? null
        : PgcStat.fromJson(json['stat'] as Map<String, dynamic>),
    status: json['status'] as int?,
    styles: json['styles'],
    subtitle: json['subtitle'] as String?,
    title: json['title'] as String?,
    total: json['total'] as int?,
    type: json['type'] as int?,
    upInfo: json['up_info'] == null
        ? null
        : UpInfo.fromJson(json['up_info'] as Map<String, dynamic>),
    userStatus: json['user_status'] == null
        ? null
        : UserStatus.fromJson(json['user_status'] as Map<String, dynamic>),
  );
}
