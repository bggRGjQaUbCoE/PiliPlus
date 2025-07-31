import 'package:PiliPlus/models_new/video/video_detail/section.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat.dart';

class UgcSeason {
  int? id;
  String? title;
  String? cover;
  int? mid;
  String? intro;
  int? signState;
  int? attribute;
  List<SectionItem>? sections;
  VideoStat? stat;
  int? epCount;
  int? seasonType;
  bool? isPaySeason;
  int? enableVt;

  UgcSeason({
    this.id,
    this.title,
    this.cover,
    this.mid,
    this.intro,
    this.signState,
    this.attribute,
    this.sections,
    this.stat,
    this.epCount,
    this.seasonType,
    this.isPaySeason,
    this.enableVt,
  });

  factory UgcSeason.fromJson(Map<String, dynamic> json) => UgcSeason(
    id: json['id'] as int?,
    title: json['title'] as String?,
    cover: json['cover'] as String?,
    mid: json['mid'] as int?,
    intro: json['intro'] as String?,
    signState: json['sign_state'] as int?,
    attribute: json['attribute'] as int?,
    sections: (json['sections'] as List<dynamic>?)
        ?.map((e) => SectionItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    stat: json['stat'] == null
        ? null
        : VideoStat.fromJson(json['stat'] as Map<String, dynamic>),
    epCount: json['ep_count'] as int?,
    seasonType: json['season_type'] as int?,
    isPaySeason: json['is_pay_season'] as bool?,
    enableVt: json['enable_vt'] as int?,
  );
}
