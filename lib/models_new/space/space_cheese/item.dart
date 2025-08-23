import 'package:PiliPlus/utils/extension.dart';

class SpaceCheeseItem {
  bool? cooperated;
  String? cooperationMark;
  String? cover;
  int? epCount;
  String? link;
  List<String>? marks;
  int? page;
  int? play;
  int? seasonId;
  String? status;
  String? subtitle;
  String? title;
  String? ctime;

  SpaceCheeseItem({
    this.cooperated,
    this.cooperationMark,
    this.cover,
    this.epCount,
    this.link,
    this.marks,
    this.page,
    this.play,
    this.seasonId,
    this.status,
    this.subtitle,
    this.title,
    this.ctime,
  });

  factory SpaceCheeseItem.fromJson(Map<String, dynamic> json) =>
      SpaceCheeseItem(
        cooperated: json['cooperated'] as bool?,
        cooperationMark: json['cooperation_mark'] as String?,
        cover: json['cover'] as String?,
        epCount: json['ep_count'] as int?,
        link: json['link'] as String?,
        marks: (json['marks'] as List?)?.fromCast(),
        page: json['page'] as int?,
        play: json['play'] as int?,
        seasonId: json['season_id'] as int?,
        status: json['status'] as String?,
        subtitle: json['subtitle'] as String?,
        title: json['title'] as String?,
        ctime: json['ctime'] as String?,
      );
}
