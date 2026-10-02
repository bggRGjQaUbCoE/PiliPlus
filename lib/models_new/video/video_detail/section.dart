import 'package:PiliPlus/models/common/list_order.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';

class SectionItem {
  int? seasonId;
  int? id;
  String? title;
  int? type;
  List<EpisodeItem>? episodes;
  ListOrder listOrder = ListOrder.asc;
  List<EpisodeItem>? originalEpisodes;

  SectionItem({this.seasonId, this.id, this.title, this.type, this.episodes});

  factory SectionItem.fromJson(Map<String, dynamic> json) => SectionItem(
    seasonId: json['season_id'] as int?,
    id: json['id'] as int?,
    title: json['title'] as String?,
    type: json['type'] as int?,
    episodes: (json['episodes'] as List<dynamic>?)
        ?.map((e) => EpisodeItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
