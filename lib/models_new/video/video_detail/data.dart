import 'package:PiliPlus/models_new/video/video_detail/argue_info.dart';
import 'package:PiliPlus/models_new/video/video_detail/desc_v2.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/models_new/video/video_detail/owner.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/models_new/video/video_detail/rights.dart';
import 'package:PiliPlus/models_new/video/video_detail/staff.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat.dart';
import 'package:PiliPlus/models_new/video/video_detail/subtitle.dart';
import 'package:PiliPlus/models_new/video/video_detail/ugc_season.dart';
import 'package:PiliPlus/models_new/video/video_detail/user_garb.dart';
import 'package:PiliPlus/utils/app_scheme.dart';

class VideoDetailData {
  String? bvid;
  int? aid;
  int? videos;
  int? tid;
  int? tidV2;
  String? tname;
  String? tnameV2;
  int? copyright;
  String? pic;
  String? title;
  int? pubdate;
  int? ctime;
  String? desc;
  List<DescV2>? descV2;
  int? state;
  int? duration;
  Rights? rights;
  Owner? owner;
  VideoStat? stat;
  ArgueInfo? argueInfo;
  String? dynam1c;
  int? cid;
  Dimension? dimension;
  int? seasonId;
  int? teenageMode;
  bool? isChargeableSeason;
  bool? isStory;
  bool? isUpowerExclusive;
  bool? isUpowerPlay;
  bool? isUpowerPreview;
  int? enableVt;
  String? vtDisplay;
  bool? isUpowerExclusiveWithQa;
  bool? noCache;
  List<Part>? pages;
  Subtitle? subtitle;
  UgcSeason? ugcSeason;
  bool? isSeasonDisplay;
  UserGarb? userGarb;
  String? likeIcon;
  bool? needJumpBv;
  bool? disableShowUpInfo;
  int? isStoryPlay;
  bool? isViewSelf;
  String? epId;
  List<Staff>? staff;
  bool isPageReversed = false;

  VideoDetailData({
    this.bvid,
    this.aid,
    this.videos,
    this.tid,
    this.tidV2,
    this.tname,
    this.tnameV2,
    this.copyright,
    this.pic,
    this.title,
    this.pubdate,
    this.ctime,
    this.desc,
    this.descV2,
    this.state,
    this.duration,
    this.rights,
    this.owner,
    this.stat,
    this.argueInfo,
    this.dynam1c,
    this.cid,
    this.dimension,
    this.seasonId,
    this.teenageMode,
    this.isChargeableSeason,
    this.isStory,
    this.isUpowerExclusive,
    this.isUpowerPlay,
    this.isUpowerPreview,
    this.enableVt,
    this.vtDisplay,
    this.isUpowerExclusiveWithQa,
    this.noCache,
    this.pages,
    this.subtitle,
    this.ugcSeason,
    this.isSeasonDisplay,
    this.userGarb,
    this.likeIcon,
    this.needJumpBv,
    this.disableShowUpInfo,
    this.isStoryPlay,
    this.isViewSelf,
    this.epId,
    this.staff,
  });

  factory VideoDetailData.fromJson(Map<String, dynamic> json) =>
      VideoDetailData(
        bvid: json['bvid'] as String?,
        aid: json['aid'] as int?,
        videos: json['videos'] as int?,
        tid: json['tid'] as int?,
        tidV2: json['tid_v2'] as int?,
        tname: json['tname'] as String?,
        tnameV2: json['tname_v2'] as String?,
        copyright: json['copyright'] as int?,
        pic: json['pic'] as String?,
        title: json['title'] as String?,
        pubdate: json['pubdate'] as int?,
        ctime: json['ctime'] as int?,
        desc: json['desc'] as String?,
        descV2: (json['desc_v2'] as List<dynamic>?)
            ?.map((e) => DescV2.fromJson(e as Map<String, dynamic>))
            .toList(),
        state: json['state'] as int?,
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
        dynam1c: json['dynamic'] as String?,
        cid: json['cid'] as int?,
        dimension: json['dimension'] == null
            ? null
            : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
        seasonId: json['season_id'] as int?,
        teenageMode: json['teenage_mode'] as int?,
        isChargeableSeason: json['is_chargeable_season'] as bool?,
        isStory: json['is_story'] as bool?,
        isUpowerExclusive: json['is_upower_exclusive'] as bool?,
        isUpowerPlay: json['is_upower_play'] as bool?,
        isUpowerPreview: json['is_upower_preview'] as bool?,
        enableVt: json['enable_vt'] as int?,
        vtDisplay: json['vt_display'] as String?,
        isUpowerExclusiveWithQa: json['is_upower_exclusive_with_qa'] as bool?,
        noCache: json['no_cache'] as bool?,
        pages: (json['pages'] as List<dynamic>?)
            ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtitle: json['subtitle'] == null
            ? null
            : Subtitle.fromJson(json['subtitle'] as Map<String, dynamic>),
        ugcSeason: json['ugc_season'] == null
            ? null
            : UgcSeason.fromJson(json['ugc_season'] as Map<String, dynamic>),
        isSeasonDisplay: json['is_season_display'] as bool?,
        userGarb: json['user_garb'] == null
            ? null
            : UserGarb.fromJson(json['user_garb'] as Map<String, dynamic>),
        likeIcon: json['like_icon'] as String?,
        needJumpBv: json['need_jump_bv'] as bool?,
        disableShowUpInfo: json['disable_show_up_info'] as bool?,
        isStoryPlay: json['is_story_play'] as int?,
        isViewSelf: json['is_view_self'] as bool?,
        staff: (json["staff"] as List?)
            ?.map((item) => Staff.fromJson(item))
            .toList(),
        epId: json['redirect_url'] == null
            ? null
            : PiliScheme.uriDigitRegExp
                  .firstMatch(json['redirect_url'])
                  ?.group(1),
      );
}
