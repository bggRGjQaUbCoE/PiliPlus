import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models_new/video/video_detail/argue_info.dart';
import 'package:PiliPlus/models_new/video/video_detail/desc_v2.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/models_new/video/video_detail/rights.dart';
import 'package:PiliPlus/models_new/video/video_detail/staff.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat.dart';
import 'package:PiliPlus/models_new/video/video_detail/ugc_season.dart';
import 'package:PiliPlus/utils/parse_string.dart';

class VideoDetailData {
  String? bvid;
  int? aid;
  int? videos;
  int? copyright;
  String? pic;
  String? title;
  int? pubdate;
  int? ctime;
  String? desc;
  List<DescV2>? descV2;
  int? duration;
  Rights? rights;
  Owner? owner;
  VideoStat? stat;
  ArgueInfo? argueInfo;
  int? cid;
  Dimension? dimension;
  int? seasonId;
  bool? isUpowerExclusive;
  List<Part>? pages;
  UgcSeason? ugcSeason;
  List<Staff>? staff;
  String? redirectUrl;
  bool isPageReversed = false;

  VideoDetailData({
    this.bvid,
    this.aid,
    this.videos,
    this.copyright,
    this.pic,
    this.title,
    this.pubdate,
    this.ctime,
    this.desc,
    this.descV2,
    this.duration,
    this.rights,
    this.owner,
    this.stat,
    this.argueInfo,
    this.cid,
    this.dimension,
    this.seasonId,
    this.isUpowerExclusive,
    this.pages,
    this.ugcSeason,
    this.staff,
    this.redirectUrl,
  });

  factory VideoDetailData.fromJson(Map<String, dynamic> json) =>
      VideoDetailData(
        bvid: json['bvid'] as String?,
        aid: json['aid'] as int?,
        videos: json['videos'] as int?,
        copyright: json['copyright'] as int?,
        pic: json['pic'] as String?,
        title: json['title'] as String?,
        pubdate: json['pubdate'] as int?,
        ctime: json['ctime'] as int?,
        desc: json['desc'] as String?,
        descV2: (json['desc_v2'] as List<dynamic>?)
            ?.map((e) => DescV2.fromJson(e as Map<String, dynamic>))
            .toList(),
        duration: json['duration'] as int?,
        rights: json['rights'] == null
            ? null
            : Rights.fromJson(json['rights'] as Map<String, dynamic>),
        owner: json['owner'] == null
            ? null
            : Owner.fromJson(json['owner'] as Map<String, dynamic>),
        stat: json['stat'] == null
            ? null
            : VideoStat.fromJson(json['stat'] as Map<String, dynamic>),
        argueInfo: json['argue_info'] == null
            ? null
            : ArgueInfo.fromJson(json['argue_info'] as Map<String, dynamic>),
        cid: json['cid'] as int?,
        dimension: json['dimension'] == null
            ? null
            : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
        seasonId: json['season_id'] as int?,
        isUpowerExclusive: json['is_upower_exclusive'] as bool?,
        pages: (json['pages'] as List<dynamic>?)
            ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
            .toList(),
        ugcSeason: json['ugc_season'] == null
            ? null
            : UgcSeason.fromJson(json['ugc_season'] as Map<String, dynamic>),
        staff: (json["staff"] as List?)
            ?.map((item) => Staff.fromJson(item))
            .toList(),
        redirectUrl: nonNullOrEmptyString(json['redirect_url']),
      );
}
