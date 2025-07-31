import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/models_new/video/video_detail/rights.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat.dart';

class Arc {
  int? aid;
  int? videos;
  int? typeId;
  String? typeName;
  int? copyright;
  String? pic;
  String? title;
  int? pubdate;
  int? ctime;
  String? desc;
  int? state;
  int? duration;
  Rights? rights;
  Owner? author;
  VideoStat? stat;
  String? dynam1c;
  Dimension? dimension;
  bool? isChargeableSeason;
  bool? isBlooper;
  int? enableVt;
  String? vtDisplay;
  int? typeIdV2;
  String? typeNameV2;
  int? isLessonVideo;

  Arc({
    this.aid,
    this.videos,
    this.typeId,
    this.typeName,
    this.copyright,
    this.pic,
    this.title,
    this.pubdate,
    this.ctime,
    this.desc,
    this.state,
    this.duration,
    this.rights,
    this.author,
    this.stat,
    this.dynam1c,
    this.dimension,
    this.isChargeableSeason,
    this.isBlooper,
    this.enableVt,
    this.vtDisplay,
    this.typeIdV2,
    this.typeNameV2,
    this.isLessonVideo,
  });

  factory Arc.fromJson(Map<String, dynamic> json) => Arc(
    aid: json['aid'] as int?,
    videos: json['videos'] as int?,
    typeId: json['type_id'] as int?,
    typeName: json['type_name'] as String?,
    copyright: json['copyright'] as int?,
    pic: json['pic'] as String?,
    title: json['title'] as String?,
    pubdate: json['pubdate'] as int?,
    ctime: json['ctime'] as int?,
    desc: json['desc'] as String?,
    state: json['state'] as int?,
    duration: json['duration'] as int?,
    rights: json['rights'] == null
        ? null
        : Rights.fromJson(json['rights'] as Map<String, dynamic>),
    author: json['author'] == null
        ? null
        : Owner.fromJson(json['author'] as Map<String, dynamic>),
    stat: json['stat'] == null
        ? null
        : VideoStat.fromJson(json['stat'] as Map<String, dynamic>),
    dynam1c: json['dynamic'] as String?,
    dimension: json['dimension'] == null
        ? null
        : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
    isChargeableSeason: json['is_chargeable_season'] as bool?,
    isBlooper: json['is_blooper'] as bool?,
    enableVt: json['enable_vt'] as int?,
    vtDisplay: json['vt_display'] as String?,
    typeIdV2: json['type_id_v2'] as int?,
    typeNameV2: json['type_name_v2'] as String?,
    isLessonVideo: json['is_lesson_video'] as int?,
  );
}
