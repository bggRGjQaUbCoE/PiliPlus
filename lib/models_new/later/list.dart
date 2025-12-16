import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models_new/later/bangumi.dart';
import 'package:PiliPlus/models_new/later/page.dart';
import 'package:PiliPlus/models_new/later/rights.dart';
import 'package:PiliPlus/models_new/later/stat.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';

class LaterItemModel with MultiSelectData {
  int? aid;
  int? videos;
  String? pic;
  String? title;
  String? subtitle;
  int? pubdate;
  int? duration;
  String? redirectUrl;
  Rights? rights;
  Owner? owner;
  Stat? stat;
  List<Page>? pages;
  Bangumi? bangumi;
  int? cid;
  int? progress;
  String? bvid;
  bool? isPgc;
  String? pgcLabel;
  bool? isPugv;
  int? seasonId;
  bool? isCharging;

  LaterItemModel({
    this.aid,
    this.videos,
    this.pic,
    this.title,
    this.subtitle,
    this.pubdate,
    this.duration,
    this.redirectUrl,
    this.rights,
    this.owner,
    this.stat,
    this.pages,
    this.bangumi,
    this.cid,
    this.progress,
    this.bvid,
    this.isPgc,
    this.pgcLabel,
    this.isPugv,
    this.seasonId,
    this.isCharging,
  });

  factory LaterItemModel.fromJson(Map<String, dynamic> json) => LaterItemModel(
    aid: json['aid'] as int?,
    videos: json['videos'] as int?,
    pic: json['pic'] as String?,
    title: json['title'] as String?,
    pubdate: json['pubdate'] as int?,
    duration: json['duration'] as int?,
    redirectUrl: json['redirect_url'] as String?,
    rights: json['rights'] == null
        ? null
        : Rights.fromJson(json['rights'] as Map<String, dynamic>),
    owner: json['owner'] == null
        ? null
        : Owner.fromJson(json['owner'] as Map<String, dynamic>),
    stat: json['stat'] == null
        ? null
        : Stat.fromJson(json['stat'] as Map<String, dynamic>),
    pages: (json['pages'] as List<dynamic>?)
        ?.map((e) => Page.fromJson(e as Map<String, dynamic>))
        .toList(),
    bangumi: json['bangumi'] == null
        ? null
        : Bangumi.fromJson(json['bangumi'] as Map<String, dynamic>),
    subtitle: json['bangumi'] == null
        ? null
        : (json['title'] as String).replaceFirst(
            '${json['bangumi']['season']['title']} ',
            '',
          ),
    cid: json['cid'] as int?,
    progress: json['progress'] as int?,
    bvid: json['bvid'] as String?,
    isPgc: json['is_pgc'] as bool?,
    pgcLabel: json['pgc_label'] == '' ? null : json['pgc_label'],
    isPugv: json['is_pugv'] as bool?,
    seasonId: json['season_id'] as int?,
    isCharging: json['charging_pay']?['level'] != null,
  );
}
