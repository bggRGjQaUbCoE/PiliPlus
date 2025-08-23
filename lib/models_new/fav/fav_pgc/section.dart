import 'package:PiliPlus/utils/extension.dart';

class Section {
  int? sectionId;
  int? seasonId;
  int? limitGroup;
  int? watchPlatform;
  String? copyright;
  int? banAreaShow;
  List<int>? episodeIds;

  Section({
    this.sectionId,
    this.seasonId,
    this.limitGroup,
    this.watchPlatform,
    this.copyright,
    this.banAreaShow,
    this.episodeIds,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    sectionId: json['section_id'] as int?,
    seasonId: json['season_id'] as int?,
    limitGroup: json['limit_group'] as int?,
    watchPlatform: json['watch_platform'] as int?,
    copyright: json['copyright'] as String?,
    banAreaShow: json['ban_area_show'] as int?,
    episodeIds: (json['episode_ids'] as List?)?.fromCast(),
  );
}
