import 'package:PiliPlus/models_new/pgc/pgc_info_model/area.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/brief.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/cooperator.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/new_ep.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/publish.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/rating.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/season.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/section.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/stat.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/up_info.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/user_status.dart';
import 'package:collection/collection.dart';

class PgcInfoModel {
  String? actors;
  List<Area>? areas;
  String? cover;
  List<EpisodeItem>? episodes;
  String? evaluate;
  int? mediaId;
  NewEp? newEp;
  Publish? publish;
  Rating? rating;
  int? seasonId;
  String? seasonTitle;
  List<Section>? sections;
  PgcStat? stat;
  String? subtitle;
  String? title;
  int? type;
  UpInfo? upInfo;
  UserStatus? userStatus;
  List<Cooperator>? cooperators;
  Brief? brief;
  List<Season>? seasons;

  bool get hasSeasons => seasons != null && seasons!.length > 1;

  bool get hasEpisodes => episodes?.isNotEmpty ?? false;

  bool get hasEpisodesOrSeasons => hasEpisodes || hasSeasons;

  bool get hasSections => sections?.isNotEmpty ?? false;

  (EpisodeItem? episode, int? sectionIndex) findEpisode([int? epId]) {
    epId ??= userStatus?.progress?.lastEpId;

    if (epId == null) {
      var episode = episodes?.firstOrNull;
      if (episode != null) return (episode, null);
      episode = sections?.firstOrNull?.episodes?.firstOrNull;
      return (episode, 0);
    }

    if (episodes != null && episodes!.isNotEmpty) {
      final episode = episodes!.firstWhereOrNull((e) => e.epId == epId);
      if (episode != null) return (episode, null);
    }

    if (sections != null && sections!.isNotEmpty) {
      for (final (index, section) in sections!.indexed) {
        for (final episode in section.episodes!) {
          if (episode.epId == epId) {
            return (episode, index);
          }
        }
      }
    }

    var episode = episodes?.firstOrNull;
    if (episode != null) return (episode, null);
    episode = sections?.firstOrNull?.episodes?.firstOrNull;
    if (episode != null) return (episode, 0);
    return const (null, null);
  }

  PgcInfoModel({
    this.actors,
    this.areas,
    this.cover,
    this.episodes,
    this.evaluate,
    this.mediaId,
    this.newEp,
    this.publish,
    this.rating,
    this.seasonId,
    this.seasonTitle,
    this.sections,
    this.stat,
    this.subtitle,
    this.title,
    this.type,
    this.upInfo,
    this.userStatus,
    this.cooperators,
    this.brief,
    this.seasons,
  });

  factory PgcInfoModel.fromJson(Map<String, dynamic> json) => PgcInfoModel(
    actors: json['actors'] as String?,
    areas: (json['areas'] as List<dynamic>?)
        ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
        .toList(),
    cover: json['cover'] as String?,
    episodes: (json['episodes'] as List<dynamic>?)
        ?.map((e) => EpisodeItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    evaluate: json['evaluate'] as String?,
    mediaId: json['media_id'] as int?,
    newEp: json['new_ep'] == null
        ? null
        : NewEp.fromJson(json['new_ep'] as Map<String, dynamic>),
    publish: json['publish'] == null
        ? null
        : Publish.fromJson(json['publish'] as Map<String, dynamic>),
    rating: json['rating'] == null
        ? null
        : Rating.fromJson(json['rating'] as Map<String, dynamic>),
    seasonId: json['season_id'] as int?,
    seasonTitle: json['season_title'] as String?,
    sections: (json['section'] as List<dynamic>?)
        ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
        .toList(),
    stat: json['stat'] == null
        ? null
        : PgcStat.fromJson(json['stat'] as Map<String, dynamic>),
    subtitle: json['subtitle'] as String?,
    title: json['title'] as String?,
    type: json['type'] as int?,
    upInfo: json['up_info'] == null
        ? null
        : UpInfo.fromJson(json['up_info'] as Map<String, dynamic>),
    userStatus: json['user_status'] == null
        ? null
        : UserStatus.fromJson(json['user_status'] as Map<String, dynamic>),
    cooperators: (json['cooperators'] as List?)
        ?.map((e) => Cooperator.fromJson(e))
        .toList(),
    brief: json['brief'] == null
        ? null
        : Brief.fromJson(json['brief'] as Map<String, dynamic>),
    seasons: (json['seasons'] as List<dynamic>?)
        ?.map((e) => Season.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
