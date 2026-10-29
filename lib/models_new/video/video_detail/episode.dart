import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/episode_panel_type.dart';
import 'package:PiliPlus/models_new/video/video_detail/arc.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';

typedef ShowEpisodes = void Function({required EpisodeType? type});

class BaseEpisodeItem {
  int? id;
  int? aid;
  int? cid;
  int? epId;
  String? bvid;
  String? badge;
  String? title;
  String? cover;

  PBadgeType get badgeType => switch (badge) {
    '预告' => .gray,
    '限免' => .free,
    _ => .primary,
  };

  BaseEpisodeItem({
    this.id,
    this.aid,
    this.cid,
    this.epId,
    this.bvid,
    this.badge,
    this.title,
    this.cover,
  });
}

class EpisodeItem extends BaseEpisodeItem {
  int? seasonId;
  int? sectionId;
  int? attribute;
  Arc? arc;
  Part? page;
  List<Part>? pages;
  @override
  String? get cover => arc?.pic;

  EpisodeItem({
    this.seasonId,
    this.sectionId,
    super.id,
    super.aid,
    super.cid,
    super.title,
    this.attribute,
    this.arc,
    this.page,
    super.bvid,
    this.pages,
    super.badge,
  });

  factory EpisodeItem.fromJson(Map<String, dynamic> json) => EpisodeItem(
    seasonId: json['season_id'] as int?,
    sectionId: json['section_id'] as int?,
    id: json['id'] as int?,
    aid: json['aid'] as int?,
    cid: json['cid'] as int?,
    title: json['title'] as String?,
    attribute: json['attribute'] as int?,
    arc: json['arc'] == null
        ? null
        : Arc.fromJson(json['arc'] as Map<String, dynamic>),
    page: json['page'] == null
        ? null
        : Part.fromJson(json['page'] as Map<String, dynamic>),
    bvid: json['bvid'] as String?,
    pages: (json['pages'] as List<dynamic>?)
        ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
        .toList(),
    badge: json['badge'],
  );
}
