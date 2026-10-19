import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/progress_bar/video_progress_indicator.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models_new/later/bangumi.dart';
import 'package:PiliPlus/models_new/later/rights.dart';
import 'package:PiliPlus/models_new/later/stat.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:material_ui/material_ui.dart'
    show ColorScheme, Widget, Positioned;

class LaterItemModel with MultiSelectData {
  int? aid;
  String? pic;
  String? title;
  String? subtitle;
  int? pubdate;
  int? duration;
  String? redirectUrl;
  Rights? rights;
  Owner? owner;
  Stat? stat;
  Bangumi? bangumi;
  int? cid;
  int? progress;
  String? bvid;
  bool? isPgc;
  String? pgcLabel;
  bool? isPugv;
  bool? isCharging;
  Dimension? dimension;

  Widget? get label => isCharging == true
      ? const PBadge(
          text: '充电专属',
          top: 6.0,
          right: 6.0,
          type: .error,
        )
      : rights?.isCooperation == 1
      ? const PBadge(
          text: '合作',
          top: 6.0,
          right: 6.0,
        )
      : pgcLabel != null
      ? PBadge(
          text: pgcLabel,
          top: 6.0,
          right: 6.0,
        )
      : isPugv == true
      ? const PBadge(
          text: '课堂',
          top: 6.0,
          right: 6.0,
        )
      : null;

  Iterable<Widget> progressIndicator(ColorScheme colorScheme) sync* {
    if (progress != null && progress != 0) {
      yield PBadge(
        text: progress == -1
            ? '已看完'
            : '${DurationUtils.formatDuration(progress)}/${DurationUtils.formatDuration(duration)}',
        right: 6,
        bottom: 8,
        type: .gray,
      );
      yield Positioned(
        left: 0,
        bottom: 0,
        right: 0,
        child: VideoProgressIndicator(
          color: colorScheme.primary,
          backgroundColor: colorScheme.secondaryContainer,
          progress: progress == -1 ? 1 : progress! / duration!,
        ),
      );
    } else if (duration! > 0) {
      yield PBadge(
        text: DurationUtils.formatDuration(duration),
        right: 6.0,
        bottom: 6.0,
        type: .gray,
      );
    }
  }

  LaterItemModel({
    this.aid,
    this.pic,
    this.title,
    this.subtitle,
    this.pubdate,
    this.duration,
    this.redirectUrl,
    this.rights,
    this.owner,
    this.stat,
    this.bangumi,
    this.cid,
    this.progress,
    this.bvid,
    this.isPgc,
    this.pgcLabel,
    this.isPugv,
    this.isCharging,
    this.dimension,
  });

  factory LaterItemModel.fromJson(Map<String, dynamic> json) => LaterItemModel(
    aid: json['aid'] as int?,
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
    isCharging: json['charging_pay']?['level'] != null,
    dimension: json['dimension'] == null
        ? null
        : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
  );
}
